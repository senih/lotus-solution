<%@ Page Language="VB"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private sCurrentDirectory As String
    Private bUseAbsoluteUrl As Boolean = False

    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        End If
    End Sub
    
    Protected Function AppSrvPath() As String

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

        Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort
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
        GridView1.Columns(1).HeaderText = GetLocalResourceObject("lblFileName.HeaderText")
        GridView1.Columns(2).HeaderText = GetLocalResourceObject("lblLastUpdated.HeaderText")
        GridView1.Columns(3).HeaderText = "" 'GetLocalResourceObject("lblSize.HeaderText")
        GridView1.Columns(4).HeaderText = "" 'GetLocalResourceObject("lblPreview.HeaderText")
        lblEmpty.Text = GetLocalResourceObject("lblEmpty.Text")
        lblSource.Text = GetLocalResourceObject("lblSource.Text")
        lblInsertActual.Text = GetLocalResourceObject("lblInsertActual.Text")
        lblInsertAsLink.Text = GetLocalResourceObject("lblInsertAsLink.Text")
        lblInsertAsThumbnail.Text = GetLocalResourceObject("lblInsertAsThumbnail.Text")
        lblInsertActualObject.Text = GetLocalResourceObject("lblInsertActualObject.Text")
        lblInsertAsLink2.Text = GetLocalResourceObject("lblInsertAsLink.Text")
        btnUpload.Text = GetLocalResourceObject("btnUpload.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnInsert.Text = GetLocalResourceObject("btnInsert.Text")
        lblFolder.Text = GetLocalResourceObject("lblFolder.Text")
        btnNewFolder.Text = GetLocalResourceObject("btnNewFolder.Text")
        
        If Not Page.IsPostBack Then
            panelManager.Visible = False
        Else
            panelManager.Visible = True
        End If

        'Render Channels
        If Not Page.IsPostBack Then
            Dim oList As ListItem
            Dim sChannelName As String
            Dim Item As String
            Dim oChannelManager As ChannelManager = New ChannelManager
            
            dropChannels.Items.Clear()
            oList = New ListItem
            oList.Value = ""
            oList.Text = GetLocalResourceObject("SelectChannel") 'Select Channel..
            dropChannels.Items.Add(oList)

            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                Dim oDataReader As SqlDataReader
                oDataReader = oChannelManager.GetChannels()
                Do While oDataReader.Read()
                    oList = New ListItem
                    oList.Value = oDataReader("channel_id").ToString
                    oList.Text = oDataReader("channel_name").ToString
                    dropChannels.Items.Add(oList)
                Loop
                oDataReader.Close()
                oDataReader = Nothing
            Else
                For Each Item In Roles.GetRolesForUser(GetUser.UserName)
                    If Item.Contains("Authors") Then
                        If Item.Substring(Item.IndexOf("Authors")) = "Authors" Then
                            sChannelName = Item.Substring(0, Item.IndexOf("Authors") - 1)
                            oList = New ListItem
                            oList.Value = oChannelManager.GetChannelByName(sChannelName).ChannelId.ToString
                            oList.Text = sChannelName
                            dropChannels.Items.Add(oList)
                        End If
                    End If
                Next

            End If
            dropChannels.Attributes.Add("onchange", "if(this.value=='')return false;")
            oChannelManager = Nothing
        End If

        Dim sPath As String = Request.QueryString("path")
        If sPath <> "" Then

            If Not Page.IsPostBack Then
                Dim nChnlId As Integer
                If sPath.Substring(1).IndexOf("\") = -1 Then
                    nChnlId = sPath.Substring(1)
                Else
                    nChnlId = sPath.Substring(1, sPath.Substring(1).IndexOf("\"))
                End If
                dropChannels.SelectedValue = nChnlId
            End If
            
            sPath = Server.MapPath("../resources") & sPath
            If Directory.Exists(sPath) Then
                sCurrentDirectory = sPath
            End If
            'With My.Computer.FileSystem
            '    sPath = Server.MapPath("../resources") & sPath
            '    If .DirectoryExists(sPath) Then
            '        .CurrentDirectory = sPath
            '    End If
            'End With
            
            panelManager.Visible = True
            showFiles()
        Else
            lblFolder.Visible = False
            divScroll.Visible = False
        End If
        
        lblUploadStatus.Text = ""

    End Sub
    
    Protected Sub showFiles()
        'Authorization of using upload, delete, etc
        If Not IsNothing(GetUser) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                'noop
            Else
                Dim oChannel As ChannelManager = New ChannelManager
                Dim sChannelName As String
                sChannelName = oChannel.GetChannel(dropChannels.SelectedValue).ChannelName
                If Roles.IsUserInRole(GetUser.UserName, sChannelName & " Resource Managers") Then
                    'noop
                Else
                    'hide delete link
                    'GridView1.Columns(GridView1.Columns.Count - 1).Visible = False
                    panelSpecial.Visible = False
                End If
            End If
        End If
        
        
        With My.Computer.FileSystem
            'install Path
            Dim n As Integer
            Dim nFileLength As Double
            Dim i As Integer


            Dim sPhysicalPath As String = sCurrentDirectory
            Dim cItems As ObjectModel.ReadOnlyCollection(Of String)
            Dim sName As String
            Dim sResMapPath As String = Server.MapPath("../resources")
            Dim sResources As String = ""

            If sPhysicalPath.Length > sResMapPath.Length Then
                sResources = "resources" & sPhysicalPath.Substring(sResMapPath.Length).Replace("\", "/")
            Else
                sPhysicalPath = sResMapPath
                sCurrentDirectory = sResMapPath
            End If

            'Breadcrumb
            Dim sQueryString As String = Request.QueryString("path")
            Dim sBreadcrumb As String = ""
            
            'If Not sQueryString.Substring(1).IndexOf("\") = -1 Then
            '    sBreadcrumb = sQueryString.Substring(sQueryString.Substring(1).IndexOf("\") + 1)
            'End If
            'lblPath.Text = dropChannels.SelectedItem.Text & sBreadcrumb.Replace("\", " \ ")
            
            Dim item As String
            Dim slink As String = ""
            Dim count As String = 0
            Dim nLength As Integer
            If Not sQueryString.Substring(1).IndexOf("\") = -1 Then
                nLength = sQueryString.Substring(sQueryString.Substring(1).IndexOf("\")).Split("\").Length()
                For Each item In sQueryString.Substring(sQueryString.Substring(1).IndexOf("\")).Split("\")
                    slink = slink & "\" & item
                    If count = nLength - 1 Then
                        sBreadcrumb = sBreadcrumb & item
                    ElseIf count = 0 Then
                        sBreadcrumb = sBreadcrumb & "<a href=""page_resources.aspx?path=" & Server.UrlEncode(slink) & """>" & dropChannels.SelectedItem.Text & "</a>\"
                    Else
                        sBreadcrumb = sBreadcrumb & "<a href=""page_resources.aspx?path=" & Server.UrlEncode(slink) & """>" & item & "</a>\"
                    End If
                    count += 1
                Next
            Else
                sBreadcrumb = sBreadcrumb & dropChannels.SelectedItem.Text
            End If

            lblPath.Text = sBreadcrumb.Replace("\", " \ ")
            'dropChannels.SelectedItem.Text & sBreadcrumb.Replace("\", " \ ")

            
            
            Dim sInstallPath As String 'relative
            Dim sPath As String
            Dim sRawUrl As String = Context.Request.RawUrl.ToString()

            If sRawUrl.Contains("?") Then
                sPath = sRawUrl.Split(CChar("?"))(0).ToString
            Else
                sPath = sRawUrl
            End If
            sInstallPath = sPath.Substring(0, sPath.LastIndexOf("/") + 1)
            sInstallPath = sInstallPath.Replace("dialogs/", "") 'additional

            Dim dt As New DataTable
            dt.Columns.Add(New DataColumn("FileName", GetType(String)))
            dt.Columns.Add(New DataColumn("FileUrl", GetType(String)))
            dt.Columns.Add(New DataColumn("LastUpdated", GetType(DateTime)))
            dt.Columns.Add(New DataColumn("Size", GetType(String)))
            dt.Columns.Add(New DataColumn("Icon", GetType(String)))
            dt.Columns.Add(New DataColumn("thumbnail", GetType(String)))
            dt.Columns.Add(New DataColumn("index", GetType(String)))

            ' Create Up one Folder
            If Request.QueryString("path") <> "" Then
                If .GetParentPath(sCurrentDirectory) <> sResMapPath Then
                    Dim dr As DataRow = dt.NewRow()
                    dr("FileName") = "..."
                    dr("Icon") = ""
                    dr("FileUrl") = "page_resources.aspx?path=" & Server.UrlEncode(.GetParentPath(sCurrentDirectory).Substring(sResMapPath.Length))
                    dt.Rows.Add(dr)
                End If
            End If

            'List Folder at current directory
            cItems = .GetDirectories(sPhysicalPath, FileIO.SearchOption.SearchTopLevelOnly)
            n = cItems.Count

            Dim sVirtualPath As String
            For i = 0 To cItems.Count - 1
                Dim dr As DataRow = dt.NewRow()
                sName = .GetDirectoryInfo(cItems(i)).Name.ToString
                dr("FileName") = sName
                dr("LastUpdated") = .GetDirectoryInfo(cItems(i)).LastWriteTime

                nFileLength = .GetDirectoryInfo(cItems(i)).GetFiles.Length
                If nFileLength = 0 Then
                    dr("Size") = "" '"0 " & GetLocalResourceObject("Files")
                ElseIf nFileLength = 1 Then
                    dr("Size") = "1 " & GetLocalResourceObject("File")
                Else
                    dr("Size") = nFileLength & " " & GetLocalResourceObject("Files")
                End If

                sVirtualPath = "page_resources.aspx?path=" & Server.UrlEncode(.GetDirectoryInfo(cItems(i)).FullName.Substring(sResMapPath.Length))
                dr("Icon") = sVirtualPath
                dr("FileUrl") = sVirtualPath
                dt.Rows.Add(dr)
            Next

            'List All File at current directory
            cItems = .GetFiles(sPhysicalPath, FileIO.SearchOption.SearchTopLevelOnly)
            If cItems.Count = 0 Then
                btnDelete.Visible = False
                lblEmpty.Visible = True
            Else
                btnDelete.Visible = True
                lblEmpty.Visible = False
            End If

            For i = 0 To cItems.Count - 1
                Dim dr As DataRow = dt.NewRow()
                sName = .GetFileInfo(cItems(i)).Name.ToString
                dr("FileName") = sName
                dr("LastUpdated") = .GetFileInfo(cItems(i)).LastWriteTime

                nFileLength = .GetFileInfo(cItems(i)).Length
                If nFileLength = 0 Then
                    dr("Size") = "0 KB"
                ElseIf nFileLength / 1024 < 1 Then
                    dr("Size") = "1 KB"
                Else
                    dr("Size") = FormatNumber((nFileLength / 1024), 0).ToString & " KB"
                End If

                sVirtualPath = sInstallPath & sResources & "/" & sName
                Dim sExt As String = cItems(i).Substring(cItems(i).LastIndexOf(".") + 1).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Then
                    dr("Icon") = sInstallPath & "systems/image_thumbnail.aspx?file=" & sVirtualPath & "&Size=70"
                    dr("thumbnail") = sInstallPath & "systems/image_thumbnail.aspx?file=" & sVirtualPath & "&Size="
                Else
                    dr("Icon") = sInstallPath & "systems/images/blank.gif"
                    dr("thumbnail") = ""
                End If
                dr("index") = i
              
                dr("FileUrl") = sVirtualPath
                dt.Rows.Add(dr)
            Next

            GridView1.DataSource = dt
            GridView1.DataBind()

            btnDelete.OnClientClick = "if(_getSelection(document.getElementById('" & hidFilesToDel.ClientID & "'))){return confirm('" & GetLocalResourceObject("DeleteConfirm") & "')}else{return false}"
            btnDelete.Style.Add("margin-right", "5px")
            btnDelete2.Attributes.Add("onclick", "if(!confirm('" & GetLocalResourceObject("DeleteConfirm2") & "'))return;")
        End With
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        RedirectForLogin()
        Dim sPhysicalPath As String = sCurrentDirectory

        With FileUpload1.PostedFile
            'File asp,cgi,pl merupakan plain/text
            'aspx dan ascx typenya application/xml
            If Not (.ContentType.ToString = "application/octet-stream" Or .ContentType.ToString = "application/xml" _
                Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "cgi" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "pl" _
                Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "asp" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "aspx") Then
                FileUpload1.SaveAs(sPhysicalPath & "\" & FileUpload1.FileName)
                lblUploadStatus.Text = ""
            Else
                lblUploadStatus.Text = GetLocalResourceObject("UploadFailed")
                'Upload failed. File type not allowed.
            End If
        End With

        showFiles()
    End Sub

    Protected Sub dropChannels_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dropChannels.SelectedIndexChanged
        If Not IsNothing(Request.QueryString("abs")) Then
            Response.Redirect("page_resources.aspx?path=%5c" & dropChannels.SelectedValue & "&c=" & Request.QueryString("c") & "&abs=true")
        Else
            Response.Redirect("page_resources.aspx?path=%5c" & dropChannels.SelectedValue & "&c=" & Request.QueryString("c"))
        End If
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        RedirectForLogin()
        
        Dim Item As String
        With My.Computer.FileSystem
            For Each Item In hidFilesToDel.Value.Split("|")
                If My.Computer.FileSystem.FileExists(Server.MapPath(Item)) Then
                    File.Delete(Server.MapPath(Item))
                End If
            Next
        End With
        'Dim Item As String
        'With My.Computer.FileSystem
        '    For Each Item In hidFilesToDel.Value.Split("|")
        '        If Item.Contains("page_resources.aspx?path=") Then
        '            Dim sDirectory As String = Server.MapPath("../resources") & Server.UrlDecode(Item.Substring(Item.LastIndexOf("=") + 1))
        '            If .DirectoryExists(sDirectory) Then
        '                .DeleteDirectory(sDirectory, FileIO.UIOption.AllDialogs, FileIO.RecycleOption.DeletePermanently, FileIO.UICancelOption.ThrowException)
        '            End If
        '        Else
        '            If My.Computer.FileSystem.FileExists(Server.MapPath(Item)) Then
        '                My.Computer.FileSystem.DeleteFile(Server.MapPath(Item), FileIO.UIOption.OnlyErrorDialogs, FileIO.RecycleOption.DeletePermanently)
        '            End If
        '        End If
        '    Next
        'End With

        showFiles()
    End Sub

    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        Dim iIndex As Integer = e.NewPageIndex()
        GridView1.PageIndex = iIndex
        showFiles()
    End Sub

    Protected Sub btnNewFolder_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()
        Dim sPhysicalPath As String
        With My.Computer.FileSystem
            sPhysicalPath = sCurrentDirectory
            If .DirectoryExists(sPhysicalPath & "\" & txtNewFolder.Text) Then
                lblUploadStatus.Text = GetLocalResourceObject("DirectoryExist")
            Else
                .CreateDirectory(sPhysicalPath & "\" & txtNewFolder.Text)
                sCurrentDirectory = sPhysicalPath
            End If
        End With
        showFiles()
        txtNewFolder.Text = ""
    End Sub

    Function ShowCheckBox(ByVal sUrl As String) As String
        Dim sHTML As String
        If sUrl.Contains("?path=") Then
            sHTML = "<img src=""../systems/images/ico_folder.gif""><input name=""chkSelect"" style=""display:none"" type=""checkbox"" />"
            
            'Hide checkbox, krn user tdk punya role Resource Manager
            If panelSpecial.Visible = False Then sHTML = "<img src=""../systems/images/ico_folder.gif"">"
        Else
            sHTML = "<input name=""chkSelect"" type=""checkbox"" />"
            
            'Hide checkbox, krn user tdk punya role Resource Manager
            If panelSpecial.Visible = False Then sHTML = ""
        End If
        Return sHTML & "<input name=""hidSelect"" type=""hidden"" value=""" & sUrl & """ /> "
    End Function

    Function Preview(ByVal sIcon As String) As String
        Dim sHTML As String
        If sIcon = "" Then
            sHTML = ""
        ElseIf sIcon.Contains("?path=") Then
            sHTML = "<a href=""#"" " & _
            "onclick=""document.getElementById('" & hidFilesToDel.ClientID & "').value ='" & sIcon & "'; " & _
            "document.getElementById('" & btnDelete2.ClientID & "').click();return false;"">" & GetLocalResourceObject("delete") & "</a>"
        Else
            sHTML = "<img src=""" & sIcon & """>"
        End If
        Return sHTML
    End Function

    Function ShowLink(ByVal sUrl As String, ByVal sFileName As String, ByVal sIndex As String) As String
        Dim sHTML As String
        If sUrl.Contains("?path=") Then
            sHTML = "<a href=""" & sUrl & "&c=" & Request.QueryString("c") & """ name=""Folder"">" & sFileName & "</a>"
        Else
            'sHTML = "<a href=""" & sUrl & """ target=""_blank"">" & sFileName & "</a>"
            sHTML = "<a href=""javascript:selectImage(" & sIndex & ");"" >" & sFileName & "</a>"
        End If
        Return sHTML
    End Function

    Protected Sub btnDelete2_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()
        
        Dim Item As String = hidFilesToDel.Value
        Dim sDirectory As String = Server.MapPath("../resources") & Server.UrlDecode(Item.Substring(Item.LastIndexOf("=") + 1))
        If Directory.Exists(sDirectory) Then
            Directory.Delete(sDirectory)
        End If
        'Dim Item As String
        'With My.Computer.FileSystem
        '    For Each Item In hidFilesToDel.Value.Split("|")
        '        If Item.Contains("page_resources.aspx?path=") Then
        '            Dim sDirectory As String = Server.MapPath("../resources") & Server.UrlDecode(Item.Substring(Item.LastIndexOf("=") + 1))
        '            If .DirectoryExists(sDirectory) Then
        '                .DeleteDirectory(sDirectory, FileIO.UIOption.OnlyErrorDialogs, FileIO.RecycleOption.DeletePermanently)
        '            End If
        '        Else
        '            If .FileExists(Server.MapPath(Item)) Then
        '                .DeleteFile(Server.MapPath(Item), FileIO.UIOption.OnlyErrorDialogs, FileIO.RecycleOption.DeletePermanently)
        '            End If
        '        End If
        '    Next
        'End With

        showFiles()
    End Sub
    
    Function GetFileUrl(ByVal s As String) As String
        If bUseAbsoluteUrl Then
            Return AppSrvPath() & s
        Else
            Return s
        End If
    End Function
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script language="javascript">
    function selectImage(nIndex)
        {
        var s=document.getElementById("hidFileUrl"+nIndex).value;
        document.getElementById("txtURL").value=s;
        document.getElementById("hidThumbnail").value=document.getElementById("hidThumbnail"+nIndex).value;

        var sFileType="file";
        if(s.substring(s.toLowerCase().indexOf('.jpg')).toLowerCase()==".jpg") sFileType="image";
        if(s.substring(s.toLowerCase().indexOf('.gif')).toLowerCase()==".gif") sFileType="image";
        if(s.substring(s.toLowerCase().indexOf('.png')).toLowerCase()==".png") sFileType="image";
        if(s.substring(s.toLowerCase().indexOf('.wmv')).toLowerCase()==".wmv") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.wma')).toLowerCase()==".wma") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.mid')).toLowerCase()==".mid") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.wav')).toLowerCase()==".wav") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.avi')).toLowerCase()==".avi") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.mpg')).toLowerCase()==".mpg") sFileType="media";
        if(s.substring(s.toLowerCase().indexOf('.swf')).toLowerCase()==".swf") sFileType="flash";
        document.getElementById("hidFileType").value=sFileType;
        
        if(sFileType=="image")
            {
            document.getElementById("idImageSetting").style.display="";
            document.getElementById("idMediaFlashSetting").style.display="none";            
            }
        else if(sFileType=="media" ||sFileType=="flash")
            {            
            document.getElementById("idImageSetting").style.display="none";
            document.getElementById("idMediaFlashSetting").style.display="";            
            }
        else
            {
            document.getElementById("idImageSetting").style.display="none";
            document.getElementById("idMediaFlashSetting").style.display="none";            
            }
        }
        
    function doInsert()
        {
        var sFileType=document.getElementById("hidFileType").value;
        
        if(sFileType=="image")
            {
            if(document.getElementsByName("rdoImageInsertType")[0].checked)
                {//object
                doInsertImage(document.getElementById("txtURL").value,document.getElementById("txtTitle").value)
                }
            if(document.getElementsByName("rdoImageInsertType")[1].checked)
                {//link
                doInsertLink();
                }
            if(document.getElementsByName("rdoImageInsertType")[2].checked)
                {//thumbnail
                doInsertImage(document.getElementById("hidThumbnail").value + document.getElementById("selThumbSize").value,document.getElementById("txtTitle").value)
                }
            }
        else if(sFileType=="media")
            {
            if(document.getElementsByName("rdoObjectInsertType")[0].checked)
                {//object                
                var sURL = document.getElementById("txtURL").value;
                sHTML = "<embed selThis=\"selThis\" "+
		            "type=\"application/x-mplayer2\" "+
		            "pluginspage=\"http://www.microsoft.com/Windows/Downloads/Contents/MediaPlayer/\" "+
		            "src=\""+sURL+"\"></embed>"
		                           
	            if(navigator.appName.indexOf('Microsoft')!=-1)
                    {
                    //IE                    
                    var oEditor=dialogArguments.oUtil.oEditor;
                    oEditor.focus()
                    dialogArguments.oUtil.obj.insertHTML(sHTML);
	                }
	            else
	                {
	                //Moz
	                window.opener.oUtil.obj.insertHTML(sHTML);
	                }
                }
            if(document.getElementsByName("rdoObjectInsertType")[1].checked)
                {//link
                doInsertLink()
                }
            }
        else if(sFileType=="flash")
            {
            if(document.getElementsByName("rdoObjectInsertType")[0].checked)
                {//object
                var sURL = document.getElementById("txtURL").value;
                var sHTML = "<object "+
		            "classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" " +
		            "width=\"100\" "+
		            "height=\"100\" " +
		            "codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0\">"+
		            "	<param name=movie value=\""+sURL+"\">" +
		            "	<param name=play value=\"true\">" +
		            "	<param name=loop value=\"true\">" +
		            "	<param name=WMode value=\"Opaque\">" +
		            "	<param name=quality value=\"high\">" +
		            "<embed src=\""+sURL+"\" width=\"100\" height=\"100\" play=\"true\" loop=\"true\" wmode=\"Opaque\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\"></embed>\n"+
		            "</object>";
                	                
		        if(navigator.appName.indexOf('Microsoft')!=-1)
                    {
                    //IE                    
                    var oEditor=dialogArguments.oUtil.oEditor;
                    oEditor.focus()
                    dialogArguments.oUtil.obj.insertHTML(sHTML);
	                }
	            else
	                {
	                //Moz
	                window.opener.oUtil.obj.insertHTML(sHTML);
	                }
                }
            if(document.getElementsByName("rdoObjectInsertType")[1].checked)
                {//link
                doInsertLink()
                }
            }
        else //sFileType=="file"
            {
            doInsertLink()
            }
        }
    
    function doInsertImage(sURL,sTitle)
        {
        if(sURL=="")return;
        
        if(navigator.appName.indexOf('Microsoft')!=-1)
            {
            //IE
            var oEditor=dialogArguments.oUtil.oEditor;
            if(!oEditor)return;
            oEditor.focus()
	        var oSel=oEditor.document.selection.createRange();
	        oSel.execCommand("InsertImage", false, sURL);
	        

            var oSel=oEditor.document.selection.createRange();
            if (oSel.parentElement)oElement=oSel.parentElement();
            else oElement=oSel.item(0);
            if (oElement.tagName=="IMG")oElement.alt=sTitle;
	        }
	    else
	        {
	        //Moz
	        var oEditor=window.opener.oUtil.oEditor;
	        oEditor.document.execCommand("InsertImage", false, sURL);
	        
	        
            oSel=oEditor.getSelection();
            var range = oSel.getRangeAt(0);
            var oElement = range.startContainer.childNodes[range.startOffset-1];
            oSel=oEditor.getSelection();
            range = oEditor.document.createRange();
            range.selectNodeContents(oElement);
            oSel.removeAllRanges();
            oSel.addRange(range);                
            if (oElement.tagName=="IMG") oElement.setAttribute("ALT", sTitle);
	        }
        }
        
    function doInsertLink()
        {
        var sURL=document.getElementById("txtURL").value;
        if(sURL=="")return;
        
        if(navigator.appName.indexOf('Microsoft')!=-1)
            {
            //IE
            var oEditor=dialogArguments.oUtil.oEditor;
            if(!oEditor)return;
            oEditor.focus();
	        var oSel=oEditor.document.selection.createRange();
		    if(oSel.text=="")//If no (text) selection, then build selection using the typed URL
			    {
			    var oSelTmp=oSel.duplicate();			
			    oSel.text=sURL;
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
                var node = oEditor.document.createTextNode(sURL);
                range.insertNode(node);
                oEditor.document.designMode = "on";

                range = oEditor.document.createRange();
                range.setStart(node, 0);
                range.setEnd(node, sURL.length);
            
                oSel = oEditor.getSelection();
                oSel.removeAllRanges();
                oSel.addRange(range);            
                }
            oEditor.document.execCommand("CreateLink", false, sURL);   
	        }
        }
    </script>
</head>
<body style="margin:10px;width:90%;background-color:#E6E7E8">
<form id="form1" runat="server">


<asp:DropDownList ID="dropChannels" runat="server" AutoPostBack="true"></asp:DropDownList>
<br /><br />
<asp:Label ID="lblFolder" meta:resourcekey="lblFolder" runat="server" Text="Folder: "></asp:Label>
<asp:Label ID="lblPath" runat="server" Text=""></asp:Label>
<br /><br />

<div runat="server" id="divScroll" style="height:240px;overflow:auto;background:white;padding:0px;border-bottom:#cccccc 1px solid;margin-bottom:5px">    
<asp:GridView ID="GridView1" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" 
HeaderStyle-BackColor="#d6d7d8" CellPadding="7" runat="server" 
HeaderStyle-HorizontalAlign="left" AllowPaging="True" 
AllowSorting="false" AutoGenerateColumns="False">
<Columns>
   <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderText="" ItemStyle-CssClass="padding2">
    <ItemTemplate>
        <input id="hidFileUrl<%#Eval("index")%>" type="hidden" value="<%#GetFileUrl(Eval("FileUrl","")) %>" />
        <input id="hidThumbnail<%#Eval("index")%>" type="hidden" value="<%#GetFileUrl(Eval("thumbnail","")) %>" />
      <%#ShowCheckBox(Eval("FileUrl"))%>
    </ItemTemplate>
    </asp:TemplateField>
   <asp:TemplateField ItemStyle-VerticalAlign="Middle" meta:resourcekey="lblFileName"  HeaderText="File Name" HeaderStyle-Wrap="false" ItemStyle-CssClass="padding2">
    <ItemTemplate>
      <%#ShowLink(Eval("FileUrl"), Eval("FileName"), Eval("index", ""))%>
    </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField meta:resourcekey="lblLastUpdated" DataField="LastUpdated" HeaderText="Last Updated" SortExpression="LastUpdated">
       <ItemStyle VerticalAlign="Middle" Wrap="false"/>
   </asp:BoundField>
   <asp:BoundField meta:resourcekey="lblSize" DataField="Size" HeaderText="Size" SortExpression="Size">
       <ItemStyle VerticalAlign="Middle" Wrap="false" />
   </asp:BoundField>
   <asp:TemplateField ItemStyle-VerticalAlign="Middle"  meta:resourcekey="lblPreview"  ItemStyle-CssClass="padding2" HeaderText="Preview">
    <ItemTemplate >
      <%#Preview(Eval("Icon"))%>
    </ItemTemplate>
    </asp:TemplateField>
</Columns>
</asp:GridView>
</div>

<asp:Panel ID="panelManager" runat="server">

    <div style="margin:5px"></div>
    <script type="text/javascript" language="javascript">

    function _getSelection(oEl)
        {
        var bReturn=false;
        var sTmp="";
        for(var i=0;i<document.getElementsByName("chkSelect").length;i++)
            {
            var oInput=document.getElementsByName("chkSelect")[i];        
            if(oInput.checked==true)
                {
                sTmp+= "|" + document.getElementsByName("hidSelect")[i].value;
                //alert(document.getElementsByName("hidSelect")[i].value)
                bReturn=true;
                }
            }
        oEl.value=sTmp.substring(1);
        return bReturn;
        }
    </script>
    <asp:Label ID="lblEmpty" meta:resourcekey="lblEmpty" runat="server" Font-Bold="true" Text="No files found."></asp:Label>
    <div style="margin:15px"></div>  
          
    <asp:HiddenField ID="hidFilesToDel" runat="server" />
    
    <asp:Panel ID="panelSpecial" runat="server">
    
        <table cellpadding="0" cellspacing="0">
        <tr>
        <td><asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text="Delete selected files"  /></td>
        <td></td>            
        <td><asp:TextBox ID="txtNewFolder" runat="server"></asp:TextBox></td>
        <td><asp:Button ID="btnNewFolder" runat="server" Text="New Folder" meta:resourcekey="btnNewFolder" OnClick="btnNewFolder_Click" ValidationGroup="NewFolder" /></td>
        <td><asp:RequiredFieldValidator ID="rfv1" ControlToValidate="txtNewFolder" ValidationGroup="NewFolder" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator></td>
        </tr>
        </table>    
        
        <table cellpadding="0" cellspacing="0" style="margin-top:20px">
        <tr>
            <td><asp:FileUpload ID="FileUpload1" runat="server"/></td>
            <td><asp:Button ID="btnUpload" meta:resourcekey="btnUpload" runat="server" Text="Upload File" /></td>
        </tr>
        <tr>
            <td colspan="2"><div style="height:5px"></div></td>
        </tr>
        <tr>
            <td colspan="2"><asp:Label ID="lblUploadStatus" runat="server" Text="" ForeColor="Red"></asp:Label></td>
        </tr>
        </table>  

        <input id="btnDelete2" runat="server" style="display:none" type="button" onserverclick="btnDelete2_Click" /> 
    
    </asp:Panel>
    
    <div style="margin:7px"></div>
    <hr />
    <div style="margin:7px"></div>
 
    <input id="hidFileType" type="hidden" />

    <table style="margin-left:5px">
    <tr>
    <td>
        <asp:Label ID="lblSource" meta:resourcekey="lblSource" runat="server" Text="Source"></asp:Label>
    </td><td>:</td><td><input id="txtURL" type="text" style="width:400px" /></td>
    </tr>
    <tr id="idImageSetting" style="display:none">
    <td colspan="3">
        
        <input id="hidThumbnail" type="hidden" />
        <table cellpadding="0" cellspacing="0">
        <tr>
            <td><input id="rdo1" name="rdoImageInsertType" type="radio" checked="checked" /></td>
            <td colspan="2" onclick="document.getElementById('rdo1').checked=true">            
                <asp:Label ID="lblInsertActual" meta:resourcekey="lblInsertActual" runat="server" Text="Insert actual image."></asp:Label>
            </td>
            <td rowspan="3" valign="top" style="padding-left:7px;border-left:#cccccc 1px solid">
                <asp:Label ID="lblTitle" meta:resourcekey="lblTitle" runat="server" Text="Title"></asp:Label>:
                <input id="txtTitle" type="text" style="width:134px" />
            </td>
        </tr>
        <tr>
            <td><input id="rdo2" name="rdoImageInsertType" type="radio" /></td>
            <td colspan="2" onclick="document.getElementById('rdo2').checked=true">            
                <asp:Label ID="lblInsertAsLink" meta:resourcekey="lblInsertAsLink" runat="server" Text="Insert as a link."></asp:Label>
            </td>
        </tr>

        <tr>
            <td><input id="rdo3" name="rdoImageInsertType" type="radio" /></td>
            <td onclick="document.getElementById('rdo3').checked=true">            
                <asp:Label ID="lblInsertAsThumbnail" meta:resourcekey="lblInsertAsThumbnail" runat="server" Text="Insert as a thumbnail, size:"></asp:Label>
            </td>
            <td style="padding-right:7px">
                <select id="selThumbSize">
                    <option value="50">50x50 px</option>
                    <option value="60">60x60 px</option>
                    <option value="70" selected="selected">70x70 px</option>
                    <option value="80">80x80 px</option>
                    <option value="90">90x90 px</option>
                    <option value="100">100x100 px</option>
                    <option value="120">120x120 px</option>
                </select>
            </td>
        </tr>
        </table>         

    </td>
    </tr>
    <tr id="idMediaFlashSetting" style="display:none">
    <td colspan="3">
        <table>
        <tr>
            <td><input name="rdoObjectInsertType" type="radio" checked="checked" /></td>
            <td colspan="2">            
                <asp:Label ID="lblInsertActualObject" meta:resourcekey="lblInsertActualObject" runat="server" Text="Insert actual object."></asp:Label>
            </td>
        </tr>
        <tr>
            <td><input name="rdoObjectInsertType" type="radio" /></td>
            <td colspan="2">            
                <asp:Label ID="lblInsertAsLink2" meta:resourcekey="lblInsertAsLink" runat="server" Text="Insert as a link."></asp:Label>
            </td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
     
     <div style="margin:7px"></div>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " OnClientClick="self.close();return false;" />
    <asp:Button ID="btnInsert" meta:resourcekey="btnInsert" runat="server" Text=" Insert " OnClientClick="doInsert();self.close();return false;" />

</asp:Panel>  


</form>
</body>
</html>
