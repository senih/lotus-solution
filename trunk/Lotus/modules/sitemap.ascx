<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private oRootMain, oRootTop, oRootBottom, oNode As New TreeNode
    Private dictNodesMain As New Dictionary(Of String, TreeNode)
    Private dictNodesTop As New Dictionary(Of String, TreeNode)
    Private dictNodesBottom As New Dictionary(Of String, TreeNode)
    Private arrUserRoles() As String
    Private bUserLoggedIn As Boolean
    
    Private dictSiteMapMain As New Dictionary(Of String, ArrayList)
    Private dictSiteMapTop As New Dictionary(Of String, ArrayList)
    Private dictSiteMapBottom As New Dictionary(Of String, ArrayList)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim bUsePureHTML As Boolean = False
        
        If IsNothing(GetUser) Then
            bUserLoggedIn = False
        Else
            bUserLoggedIn = True
            arrUserRoles = Roles.GetRolesForUser(GetUser.UserName)
        End If
        
        treeMain.Nodes.Clear()
        treeTop.Nodes.Clear()
        treeBottom.Nodes.Clear()
    
        'MAIN Navigation
        RenderTree("main")
        If oRootMain.ChildNodes.Count > 0 Then
            treeMain.Nodes.Add(oRootMain)
            treeMain.ExpandAll()
        Else
            lblMain.Visible = False
        End If
        
        'TOP Navigation
        RenderTree("top")
        If oRootTop.ChildNodes.Count > 0 Then
            treeTop.Nodes.Add(oRootTop)
            treeTop.ExpandAll()
        Else
            lblTop.Visible = False
        End If
        
        'BOTTOM Navigation
        RenderTree("bottom")
        If oRootBottom.ChildNodes.Count > 0 Then
            treeBottom.Nodes.Add(oRootBottom)
            treeBottom.ExpandAll()
        Else
            lblBottom.Visible = False
        End If
                
        If bUsePureHTML Then
            treeMain.Visible = False
            treeTop.Visible = False
            treeBottom.Visible = False
            
            Dim sTreeMain As String = GetTree(dictSiteMapMain)
            Dim sTreeTop As String = GetTree(dictSiteMapTop)
            Dim sTreeBottom As String = GetTree(dictSiteMapBottom)
            litMain.Text = sTreeMain
            litTop.Text = sTreeTop
            litBottom.Text = sTreeBottom
            If sTreeMain = "" Then
                lblMain.Visible = False
            End If
            If sTreeTop = "" Then
                lblTop.Visible = False
            End If
            If sTreeBottom = "" Then
                lblBottom.Visible = False
            End If
        End If
        
    End Sub
    
    Function GetTree(ByVal dictSiteMap As Dictionary(Of String, ArrayList)) As String
        Dim arrSiteMap As Collections.Generic.KeyValuePair(Of String, ArrayList)
        Dim sHTML As String = ""
        Dim i As Integer
        
        Dim bEmpty As Boolean = True
        
        Dim sFile As String
        Dim sTitle As String
        Dim bSelected As Boolean
        Dim sTarget As String
        Dim nLevel As Integer
                
        Dim nLevelTmp As Integer = 0
        sHTML += "<ul>"
        Dim bInitial As Boolean = True
        For Each arrSiteMap In dictSiteMap
            
            sFile = arrSiteMap.Value(0)
            sTitle = arrSiteMap.Value(1)
            bSelected = CBool(arrSiteMap.Value(2))
            sTarget = arrSiteMap.Value(3)
            nLevel = CInt(arrSiteMap.Value(4))
            
            If bInitial Then
                'sHTML += "<li><a href=""" & sFile & """>" & sTitle & "</a>"
                bInitial = False
                nLevel = 1
            Else
                If nLevel > nLevelTmp Then
                    sHTML += "<ul>"
                    sHTML += "<li><a href=""" & sFile & """>" & sTitle & "</a>"
                ElseIf nLevel = nLevelTmp Then
                    sHTML += "</li><li><a href=""" & sFile & """>" & sTitle & "</a>"
                Else
                    For i = nLevel To nLevelTmp - 1
                        sHTML += "</li></ul>"
                    Next
                    sHTML += "</li><li><a href=""" & sFile & """>" & sTitle & "</a>"
                End If
                
                bEmpty = False
            End If
            
            nLevelTmp = nLevel
        Next
        For i = 1 To nLevelTmp
            sHTML += "</li></ul>"
        Next
        If bEmpty Then
            sHTML = ""
        End If
        Return sHTML
    End Function
        
    Private Sub RenderTree(ByVal place As String)

        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader = Nothing
        Dim sSQL As String = ""
        
        Dim arrItem As ArrayList
       
        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean
        Dim nLvl As Integer
        
        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""
        
        oConn = New SqlConnection(sConn)
        oConn.Open()
        If bUserLoggedIn Then 'yus
            oCommand = New SqlCommand("advcms_Sitemap2") 'Working
        Else
            oCommand = New SqlCommand("advcms_Sitemap") 'Published
        End If
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
        If place = "main" Then
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "main"
        ElseIf place = "top" Then
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "top"
        ElseIf place = "bottom" Then
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "bottom"
        End If
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
       
        Do While oDataReader.Read()
            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = "../" & oDataReader("file_name").ToString()
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
            nLvl = CInt(oDataReader("lvl"))
            
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
                    bIsSys, bIsHdn) 'yus
            End If
            
            If nPrId = 0 Then
                oRootMain.Value = nPgId.ToString
                oRootTop.Value = nPgId.ToString
                oRootBottom.Value = nPgId.ToString
                oRootMain.Text = sTtl
                oRootTop.Text = sTtl
                oRootBottom.Text = sTtl
                oRootMain.NavigateUrl = sFile
                oRootTop.NavigateUrl = sFile
                oRootBottom.NavigateUrl = sFile
                
                dictNodesMain.Add(nPgId.ToString, oRootMain)
                dictNodesTop.Add(nPgId.ToString, oRootTop)
                dictNodesBottom.Add(nPgId.ToString, oRootBottom)
                
                '~~~ HTML Tree ~~~
                arrItem = New ArrayList
                arrItem.Add(sFile)
                arrItem.Add(sTtl)
                arrItem.Add(False) 'selected
                arrItem.Add("") 'target
                arrItem.Add(nLvl)
                dictSiteMapMain.Add(nPgId, arrItem)
                dictSiteMapTop.Add(nPgId, arrItem)
                dictSiteMapBottom.Add(nPgId, arrItem)
                '~~~ /HTML Tree ~~~
            Else
                oNode = New TreeNode()
                oNode.Value = nPgId
                oNode.Text = sTtl
                oNode.NavigateUrl = sFile
                
                Try
                    If bShowMenu Then
                        If place = "main" Then
                            dictNodesMain(nPrId.ToString).ChildNodes.Add(oNode)
                            dictNodesMain.Add(nPgId.ToString, oNode)
                            
                            '~~~ HTML Tree ~~~                      
                            arrItem = New ArrayList
                            arrItem.Add(sFile)
                            arrItem.Add(sTtl)
                            arrItem.Add(False) 'selected
                            arrItem.Add("") 'target
                            arrItem.Add(nLvl)
                            dictSiteMapMain.Add(nPgId, arrItem)
                            '~~~ /HTML Tree ~~~
                            
                        ElseIf place = "top" Then
                            dictNodesTop(nPrId.ToString).ChildNodes.Add(oNode)
                            dictNodesTop.Add(nPgId.ToString, oNode)
                            
                            '~~~ HTML Tree ~~~                    
                            arrItem = New ArrayList
                            arrItem.Add(sFile)
                            arrItem.Add(sTtl)
                            arrItem.Add(False) 'selected
                            arrItem.Add("") 'target
                            arrItem.Add(nLvl)
                            dictSiteMapTop.Add(nPgId, arrItem)
                            '~~~ /HTML Tree ~~~
                            
                        ElseIf place = "bottom" Then
                            dictNodesBottom(nPrId.ToString).ChildNodes.Add(oNode)
                            dictNodesBottom.Add(nPgId.ToString, oNode)
                            
                            '~~~ HTML Tree ~~~                     
                            arrItem = New ArrayList
                            arrItem.Add(sFile)
                            arrItem.Add(sTtl)
                            arrItem.Add(False) 'selected
                            arrItem.Add("") 'target
                            arrItem.Add(nLvl)
                            dictSiteMapBottom.Add(nPgId, arrItem)
                            '~~~ /HTML Tree ~~~
                        End If
                        

                    End If
                Catch ex As Exception

                End Try
            End If

        Loop
        oDataReader.Close()
        oConn.Close()

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
            If bIsHdn Then
                bShowLink = False
            End If
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
                    'NOTE: Editor & Publisher harus bisa lihat Working copy juga
                    'utk review (tanpa harus edit)
                    'Jadi tdk perlu di-cek apakah:
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
                If bIsHdn Then
                    vRetVal = 0
                End If
            End If
        ElseIf nCPermission = 3 Then
            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            ElseIf bUserIsSubscriber Then
                'Show Published (Title/Link Text)
                vRetVal = 2
                If bIsHdn Then
                    vRetVal = 0
                End If
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
                If sOwn = Me.UserName Or bIsEditor Or bIsPublisher Then
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
                If sLastUpdBy = Me.UserName And (sStat.Contains("locked") And Not sStat.Contains("unlocked")) Then
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


<asp:Label ID="lblTop" meta:resourcekey="lblTop" runat="server" Font-Bold="true" Text="Top"></asp:Label>
<div style="margin:3px"></div>
<asp:Literal ID="litTop" runat="server"></asp:Literal>
<asp:TreeView ID="treeTop" runat="server" CssClass="tes" ShowLines=true></asp:TreeView><br /> 

<asp:Label ID="lblMain" meta:resourcekey="lblMain" runat="server" Font-Bold="true" Text="Main"></asp:Label>
<div style="margin:3px"></div>  
<asp:Literal ID="litMain" runat="server"></asp:Literal>     
<asp:TreeView ID="treeMain" runat="server" ShowLines=true></asp:TreeView><br />

<asp:Label ID="lblBottom" meta:resourcekey="lblBottom" runat="server" Font-Bold="true" Text="Bottom"></asp:Label>
<div style="margin:3px"></div>
<asp:Literal ID="litBottom" runat="server"></asp:Literal>
<asp:TreeView ID="treeBottom" runat="server" ShowLines=true></asp:TreeView>
