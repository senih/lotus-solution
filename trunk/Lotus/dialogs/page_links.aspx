<%@ Page Language="VB"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server">
    Private nRootId As Integer

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private arrUserRoles() As String
    Private bUserLoggedIn As Boolean
    Private bUseAbsoluteUrl As Boolean = False

    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        End If
    End Sub
    
    Protected Function AppFullPath() As String

        'returns:
        ' http://localhost/ 
        ' http://localhost/apppath/
        '(Selalu ada "/" di akhir)
        Dim sPort As String = Request.ServerVariables("SERVER_PORT")
        If IsNothing(sPort) Or sPort = "80" Or sPort = "443" Then
            sPort = ""
        Else
            sPort = ":" & sPort
        End If

        Dim sProtocol As String = Request.ServerVariables("SERVER_PORT_SECURE")
        If IsNothing(sProtocol) Or sProtocol = "0" Then
            sProtocol = "http://"
        Else
            sProtocol = "https://"
        End If

        If Request.ApplicationPath = "/" Then
            'App is installed in root
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath
        Else
            'App is installed in virtual directory
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath & "/"
        End If
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RedirectForLogin()

        If Not IsNothing(Request.QueryString("abs")) Then
            bUseAbsoluteUrl = True
        End If

        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        lblTop.Text = GetLocalResourceObject("lblTop.Text")
        lblMain.Text = GetLocalResourceObject("lblMain.Text")
        lblBottom.Text = GetLocalResourceObject("lblBottom.Text")
        lblURL.Text = GetLocalResourceObject("lblURL.Text")
        lblDisplayText.Text = GetLocalResourceObject("lblDisplayText.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnOk.Text = GetLocalResourceObject("btnOk.Text")
        
        nRootId = CInt(Request.QueryString("root"))

        If IsNothing(GetUser) Then
            bUserLoggedIn = False

            Response.Write("Session Expired.")
            Response.End()
        Else
            bUserLoggedIn = True
            arrUserRoles = Roles.GetRolesForUser(GetUser.UserName)
        End If

        treeMain.Nodes.Clear()
        treeTop.Nodes.Clear()
        treeBottom.Nodes.Clear()

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader

        Dim oRootMain, oRootTop, oRootBottom, oNode As New TreeNode
        Dim dictNodesMain As New Dictionary(Of String, TreeNode)
        Dim dictNodesTop As New Dictionary(Of String, TreeNode)
        Dim dictNodesBottom As New Dictionary(Of String, TreeNode)

        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        Dim Item As String
        Dim sUserRoles As String = ""
        For Each Item In arrUserRoles
            sUserRoles += Item & " "
        Next
        Dim bIsAdmin As Boolean = False
        If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
            bIsAdmin = True
        End If

        oConn = New SqlConnection(sConn)
        oConn.Open()

        'MAIN Navigation
        oCommand = New SqlCommand("advcms_Sitemap2") 'Working
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
        oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "main"
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Do While oDataReader.Read()

            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString()
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If
            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            If bUserLoggedIn Then
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                bShowMenu = ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn)
            End If

            If bUseAbsoluteUrl Then
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
                    "<span onclick=""selectLink('" & AppFullPath() & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            Else
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
               "<span onclick=""selectLink('" & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            End If

            If nPrId = 0 Then
                oRootMain.Value = nPgId.ToString
                oRootTop.Value = nPgId.ToString
                oRootBottom.Value = nPgId.ToString
                oRootMain.Text = sTtl
                oRootTop.Text = sTtl
                oRootBottom.Text = sTtl
                dictNodesMain.Add(nPgId.ToString, oRootMain)
                dictNodesTop.Add(nPgId.ToString, oRootTop)
                dictNodesBottom.Add(nPgId.ToString, oRootBottom)
            Else
                oNode = New TreeNode()
                oNode.Value = nPgId
                oNode.Text = sTtl

                Try
                    If bShowMenu Then
                        dictNodesMain(nPrId.ToString).ChildNodes.Add(oNode)
                        dictNodesMain.Add(nPgId.ToString, oNode)
                    End If
                Catch ex As Exception

                End Try
            End If
        Loop
        oDataReader.Close()
        treeMain.Nodes.Add(oRootMain)
        treeMain.ExpandAll()

        'TOP Navigation
        oCommand = New SqlCommand("advcms_Sitemap2") 'Working
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
        oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "top"
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Do While oDataReader.Read()

            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString()
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If
            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            If bUserLoggedIn Then
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                bShowMenu = ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn)
            End If

            If bUseAbsoluteUrl Then
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
                    "<span onclick=""selectLink('" & AppFullPath() & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            Else
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
                    "<span onclick=""selectLink('" & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            End If

            oNode = New TreeNode()
            oNode.Value = nPgId
            oNode.Text = sTtl

            Try
                If bShowMenu Then
                    dictNodesTop(nPrId.ToString).ChildNodes.Add(oNode)
                    dictNodesTop.Add(nPgId.ToString, oNode)
                End If
            Catch ex As Exception

            End Try
        Loop
        oDataReader.Close()
        treeTop.Nodes.Add(oRootTop)
        treeTop.ExpandAll()

        'BOTTOM Navigation
        oCommand = New SqlCommand("advcms_Sitemap2") 'Working
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
        oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "bottom"
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Do While oDataReader.Read()

            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString()
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If

            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            If bUserLoggedIn Then
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                bShowMenu = ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn)
            End If

            If bUseAbsoluteUrl Then
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
                    "<span onclick=""selectLink('" & AppFullPath() & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            Else
                sTtl = "<input type=""hidden"" id=""hid" & nPgId & """ value=""" & Server.HtmlEncode(sTtl) & """>" & _
                    "<span onclick=""selectLink('" & sFile & "',document.getElementById('hid" & nPgId & "').value);return false;"">" & sTtl & "</span>"
            End If

            oNode = New TreeNode()
            oNode.Value = nPgId
            oNode.Text = sTtl

            Try
                If bShowMenu Then
                    dictNodesBottom(nPrId.ToString).ChildNodes.Add(oNode)
                    dictNodesBottom.Add(nPgId.ToString, oNode)
                End If
            Catch ex As Exception

            End Try
        Loop
        oDataReader.Close()
        treeBottom.Nodes.Add(oRootBottom)
        treeBottom.ExpandAll()

        oConn.Close()

        btnOk.OnClientClick = "doInsert();self.close();return false;"
        btnClose.OnClientClick = "self.close();return false;"

    End Sub

    'Authorize User to Show/Hide a Menu Link
    Protected Function ShowLink(ByVal nCPermission As Integer, _
        ByVal oStartDate As Object, _
        ByVal oEndDate As Object, _
        ByVal bIsSys As Boolean, _
        ByVal bIsHdn As Boolean) As Boolean

        Dim bShowLink As Boolean = False

        '~~~ User Authorization (to display Title/Link Text) ~~~
        Dim bShowMenu As Boolean = False
        If nCPermission = 1 Or nCPermission = 2 Then
            'Utk nCPermission=2:
            'Walaupun user blm login, tdk apa2 link-nya ditampilkan
            bShowLink = True
        ElseIf nCPermission = 3 Then
            bShowLink = False
        End If
        '~~~ /User Authorization ~~~

        'Kalau page belum scheduled, set hidden.
        If Not oStartDate.ToString = "" Then
            If Now < CDate(oStartDate) Then
                bShowLink = False
            End If
        End If

        If Not oEndDate.ToString = "" Then
            If Now > CDate(oEndDate) Then
                bShowLink = False
            End If
        End If

        If bIsSys Then
            'IsSystem => non editable page 
            'eg. 
            '   - Admin pages (channel: General, no specific authorization - tergantung ascx yg diinclude)
            '     Advantage: admin page bisa di-bookmark (krn channel=General => link kelihatan)
            '   - SiteMap 
            If bIsHdn Then
                bShowLink = False 'Pasti
            Else
                bShowLink = True 'Pasti - Show Published (Title/Link Text)
                'Kebetulan utk page yg IsSystem sudah pasti tdk ada working copy,
                'Jadi yg di-show selalu Published / Latest Copy (bisa dari pages_working
            End If
        End If

        Return bShowLink
    End Function

    Protected Function ShowLink2(ByVal nCPermission As Integer, _
        ByVal sCName As String, _
        ByVal oStartDate As Object, _
        ByVal oEndDate As Object, _
        ByVal bIsSys As Boolean, _
        ByVal bIsHdn As Boolean, _
        ByVal bUserLoggedIn As Boolean, _
        Optional ByVal bDisCollab As Boolean = False, _
        Optional ByVal sOwn As String = "", _
        Optional ByVal sLastUpdBy As String = "", _
        Optional ByVal sStat As String = "", _
        Optional ByVal bBlog As Boolean = False) As Integer

        Dim vRetVal As Integer
        '0 => Do not show
        '1 => Show Working (Title/Link Text)
        '2 => Show Published (Title/Link Text)

        Dim bUserCanManage As Boolean = False
        Dim bUserIsSubscriber As Boolean = False
        Dim bIsAuthor As Boolean = False
        Dim bIsEditor As Boolean = False
        Dim bIsPublisher As Boolean = False
        Dim bIsAdministrator As Boolean = False

        If bUserLoggedIn Then
            Dim sRole As String
            For Each sRole In arrUserRoles
                If sRole = sCName & " Authors" Or _
                    sRole = sCName & " Editors" Or _
                    sRole = sCName & " Publishers" Or _
                    sRole = sCName & " Resource Managers" Or _
                    sRole = "Administrators" Then
                    bUserCanManage = True
                    bUserIsSubscriber = True
                    'TODO: Khusus utk Editor & Publisher, masih bisa di-check,
                    'apakah page :
                    '1. Released (Editor & Publisher lihat Working copy of Title/Link Text)
                    '2. Tidak    (Editor & Publisher lihat Published copy of Title/Link Text)
                End If
                If sRole = sCName & " Subscribers" Then
                    bUserCanManage = False
                    bUserIsSubscriber = True
                End If
                If sRole = sCName & " Authors" Then
                    bIsAuthor = True
                End If
                If sRole = sCName & " Editors" Then
                    bIsEditor = True
                End If
                If sRole = sCName & " Publishers" Then
                    bIsPublisher = True
                End If
                If sRole = sCName & " Administrators" Then
                    bIsAdministrator = True
                End If
            Next
        End If

        '~~~ User Authorization (to display Title/Link Text) ~~~
        Dim bShowMenu As Boolean = False
        If nCPermission = 1 Or nCPermission = 2 Then
            'Utk nCPermission=2:
            'Walaupun user blm login, tdk apa2 link-nya ditampilkan
            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            Else
                'Show Published (Title/Link Text)
                vRetVal = 2
            End If
        ElseIf nCPermission = 3 Then
            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            ElseIf bUserIsSubscriber Then
                'Show Published (Title/Link Text)
                vRetVal = 2
            Else
                vRetVal = 0
            End If
        End If
        '~~~ /User Authorization ~~~

        'Kalau page belum scheduled, set hidden.
        If Not oStartDate.ToString = "" Then
            If Now < CDate(oStartDate) Then
                vRetVal = 0

                If bUserCanManage Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If

            End If
        End If

        If Not oEndDate.ToString = "" Then
            If Now > CDate(oEndDate) Then
                vRetVal = 0

                If bUserCanManage Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If

            End If
        End If
        
        '******************************************
        '   Disable Collaboration Feature & BLOG
        '******************************************
        If bUserLoggedIn Then
            If bDisCollab Or bBlog Then
                If sOwn = GetUser.UserName Or bIsEditor Or bIsPublisher Then
                    'Show Working OR ikut sebelumnya
                    'vRetVal = 1
                Else
                    'Selain owner, editor & publisher => selalu Show Published
                    'Show Published
                    If vRetVal = 1 Then 'eg other Authors
                        vRetVal = 2
                    End If
                    If bIsHdn Then 'if hidden, other authors cannot see
                        vRetVal = 0
                    End If
                End If
                If sLastUpdBy = GetUser.UserName And (sStat.Contains("locked") And Not sStat.Contains("unlocked")) Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If
            End If
        End If
        '********************************

        If bIsAdministrator Then
            'Show Working (Title/Link Text)
            vRetVal = 1
        End If

        If bIsSys Then
            'IsSystem => non editable page 
            'eg. 
            '   - Admin pages (channel: General, no specific authorization - tergantung ascx yg diinclude)
            '     Advantage: admin page bisa di-bookmark (krn channel=General => link kelihatan)
            '   - SiteMap 
            If bIsHdn Then
                vRetVal = 0 'Pasti
            Else
                vRetVal = 2 'Pasti - Show Published (Title/Link Text)
                'Kebetulan utk page yg IsSystem sudah pasti tdk ada working copy,
                'Jadi yg di-show selalu Published / Latest Copy (bisa dari pages_working
            End If
        End If

        Return vRetVal
    End Function
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script>
    function selectLink(sFileName, sTitle)
        {
        document.getElementById("txtURL").value=sFileName;
        document.getElementById("txtDisplayText").value=sTitle;
        }
    function doInsert()
        {
        var sURL=document.getElementById("txtURL").value;
        var sDisplayText=document.getElementById("txtDisplayText").value;
        if(sURL=="")return;
        if(sDisplayText=="")sDisplayText=sURL;

        
        if(navigator.appName.indexOf('Microsoft')!=-1)
            {
            //IE
            var oEditor=dialogArguments.oUtil.oEditor;
            if(!oEditor)return;
            oEditor.focus()
	        var oSel=oEditor.document.selection.createRange();
    	    
		    if(oSel.text=="")//If no (text) selection, then build selection using the typed URL
			    {
			    var oSelTmp=oSel.duplicate();			
			    oSel.text=sDisplayText;
			    oSel.setEndPoint("StartToStart",oSelTmp);
			    oSel.select();
			    }
	        oSel.execCommand("CreateLink",false,sURL);
	        }
	    else
	        {
	        //Moz
	        var oEditor=window.opener.oUtil.oEditor;
            var oSel=oEditor.getSelection();
            var range = oSel.getRangeAt(0);

            var emptySel = false;
            if(range.toString()=="") 
                {
                //If no (text) selection, then build selection using the typed URL
                if (range.startContainer.nodeType==Node.ELEMENT_NODE) 
                    {
                    if (range.startContainer.childNodes[range.startOffset] != null && range.startContainer.childNodes[range.startOffset].nodeType != Node.TEXT_NODE) 
                        { 
                        if (range.startContainer.childNodes[range.startOffset].nodeName=="BR") emptySel = true; else emptySel=false;  
                        } 
                    else 
                        { 
                        emptySel = true; 
                        }
                    } 
                else 
                    {
                    emptySel = true;
                    }
                }

            if (emptySel) 
                {
                var node = oEditor.document.createTextNode(sDisplayText);
                range.insertNode(node);
                oEditor.document.designMode = "on";

                range = oEditor.document.createRange();
                range.setStart(node, 0);
                range.setEnd(node, sDisplayText.length);
            
                oSel = oEditor.getSelection();
                oSel.removeAllRanges();
                oSel.addRange(range);            
                }
            oEditor.document.execCommand("CreateLink", false, sURL);   
	        }
        }
    function adjustHeight()
        {
        if(navigator.appName.indexOf('Microsoft')!=-1)
            document.getElementById('cellContent').height=324;
        else
            document.getElementById('cellContent').height=380;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:0px;background-color:#E6E7E8;">
<form id="form1" runat="server">

<table width="100%" cellpadding=0 cellspacing=0 border=0>
<tr>
    <td colspan=3 id=cellContent valign=top>
        <div style="height:100%;overflow:auto;background:white;padding:10px;border-bottom:#cccccc 1px solid;margin-bottom:5px">    
        
        <asp:Label ID="lblTop" meta:resourcekey="lblTop" runat="server" Font-Bold="true" Text="Top"></asp:Label>
        <div style="margin:3px"></div>
        <asp:TreeView ID="treeTop" runat="server" ShowLines=true></asp:TreeView><br /> 
        
        <asp:Label ID="lblMain" meta:resourcekey="lblMain" runat="server" Font-Bold="true" Text="Main"></asp:Label>
        <div style="margin:3px"></div>       
        <asp:TreeView ID="treeMain" runat="server" ShowLines=true></asp:TreeView><br />
        
        <asp:Label ID="lblBottom" meta:resourcekey="lblBottom" runat="server" Font-Bold="true" Text="Bottom"></asp:Label>
        <div style="margin:3px"></div>
        <asp:TreeView ID="treeBottom" runat="server" ShowLines=true></asp:TreeView><br />
        
        </div>
    </td>
</tr>
<tr>
    <td style="padding-left:5px">
        <asp:Label ID="lblURL" meta:resourcekey="lblURL" runat="server" Text="URL"></asp:Label>
    </td>
    <td>&nbsp;:&nbsp;</td>
    <td width="100%">
        <input id="txtURL" type="text" style="width:200px" />
    </td>
</tr>
<tr>
    <td style="padding-left:5px" nowrap=nowrap>
        <asp:Label ID="lblDisplayText" meta:resourcekey="lblDisplayText" runat="server" Text="Display Text"></asp:Label>
    </td>
    <td>&nbsp;:&nbsp;</td>
    <td>
        <input id="txtDisplayText" type="text" style="width:200px" />
    </td>
</tr>
<tr>
    <td colspan=3 style="padding:10px;padding-right:15px" align=right>
        <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
        <asp:Button ID="btnOk" meta:resourcekey="btnOk" runat="server" Text="  Insert  " />
    </td>
</tr>
</table>

</form>
</body>
</html>
