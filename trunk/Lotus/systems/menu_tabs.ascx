<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.XML" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Dim sTtl As String
    Dim sLnk As String
    Dim sFile As String 'eg.default.aspx, mysite/default.aspx
    Dim sFileUrl As String 'eg. /default.aspx, /mysite/default.aspx
    Dim nPgId As Integer
    Dim nPrId As Integer
    Dim nLevel As Integer
    Dim nCPermission As Integer
    Dim sCName As String
    Dim bIsHdn As Boolean
    Dim bIsSys As Boolean
    Dim sTarget As String
    Dim bUseWindowOpen As Boolean

    Dim bIsLnk As Boolean 'tdk perlu bIsLnk krn pasti sama
    Dim sLnkTrgt As String = ""
    Dim sLnkTrgt2 As String = ""

    Dim sLnk2 As String 'Published Version
    Dim sTtl2 As String = "" 'Published Version
    Dim bDisCollab As Boolean
    Dim dtLastUpdBy As DateTime
    Dim sStat As String = ""
    Dim sOwn As String = ""
    
    Private oColPath As Collection
    Public Property ColPath() As Collection
        Get
            Return oColPath
        End Get
        Set(ByVal value As Collection)
            oColPath = value
        End Set
    End Property
    Private sTmpItem() As String
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)      
        
        'Default Configuration
        Dim bHideHomeLink As Boolean = False
        
        'Load XML Configuration
        Dim sXmlPath As String = Server.MapPath("templates/" & Me.TemplateFolderName & "/default.xml")
        If IO.File.Exists(sXmlPath) Then
            Dim xmldoc As New XmlDocument
            Dim fs As New IO.FileStream(sXmlPath, IO.FileMode.Open, IO.FileAccess.Read)
            xmldoc.Load(fs)
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tabs/hide_root")) Then
                bHideHomeLink = CBool(xmldoc.SelectSingleNode("root/menu_tabs/hide_root").InnerText)
            End If
            xmldoc = Nothing
            fs = Nothing
        End If
        
        'DB & Content object Init
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        Dim oContent As New Content
        
        If Me.IsUserLoggedIn Then 'yus
            oCommand = New SqlCommand("SELECT page_id, parent_id, sorting, page_type, file_name, " & _
                "title, link_text, published_start_date, published_end_date, is_hidden, " & _
                "is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, " & _
                "owner, title2, link_text2, is_link, link_target, link_target2 FROM pages_working where is_system=0 AND (page_id=@root_id or (parent_id=@root_id AND link_placement='main')) order by parent_id, sorting")
        Else
            oCommand = New SqlCommand("SELECT page_id, parent_id, sorting, page_type, file_name, title, link_text, published_start_date, published_end_date, is_hidden, " & _
                "is_system, channel_name, channel_permission, is_link, link_target from pages_published where is_system=0 AND (page_id=@root_id or (parent_id=@root_id AND link_placement='main')) order by parent_id, sorting")
        End If
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Dim sMenuTabs As String = ""

        While oDataReader.Read()
            'nLevel = CInt(oDataReader("lvl"))
            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString
            sFileUrl = Me.AppPath & oDataReader("file_name").ToString
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            If sLnk <> "" Then sTtl = sLnk
            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            '--- Linked Page
            If IsDBNull(oDataReader("is_link")) Then
                bIsLnk = False
            Else
                bIsLnk = Convert.ToBoolean(oDataReader("is_link"))
            End If

            sTarget = "target=""_self"""
            bUseWindowOpen = False
            If bIsLnk Then
                sLnkTrgt = oDataReader("link_target").ToString
                sTarget = "target=""" & sLnkTrgt & """"
                If sLnkTrgt = "_blank" Then bUseWindowOpen = True
            End If
            '--- /Linked Page

            If Me.IsUserLoggedIn Then
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If

                '--- Linked Page
                If bIsLnk Then
                    sLnkTrgt2 = oDataReader("link_target2").ToString
                End If
                '--- /Linked Page

                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If Me.IsUserLoggedIn Then
                nShowMenu = oContent.ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, Me.IsUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True

                    '--- Linked Page
                    sTarget = "target=""_self"""
                    bUseWindowOpen = False
                    '--- /Linked Page

                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2

                        '--- Linked Page
                        If bShowMenu And bIsLnk Then
                            sTarget = "target=""" & sLnkTrgt2 & """"
                            If sLnkTrgt2 = "_blank" Then bUseWindowOpen = True
                        End If
                        '--- /Linked Page
                    End If
                End If
            Else
                bShowMenu = oContent.ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn) 'yus
            End If

            If bShowMenu Then
                Dim sOnClick As String = "window.location.href='" & sFileUrl & "';return false;"
                If bUseWindowOpen Then
                    sOnClick = "window.open('" & sFileUrl & "');return false;"
                End If

                Dim sTabLeftClass As String
                Dim sTabCenterClass As String
                Dim sTabRightClass As String
                Dim sTabLinkClass As String

                'Main (Links) Menu
                If nPgId = Me.RootID Then
                    If Not bHideHomeLink Then 'Hide Home Link

                        If oColPath.Count = 1 Then
                            sTmpItem = oColPath(1)
                        Else
                            sTmpItem = oColPath(2)
                        End If

                        'Inactive
                        sTabLeftClass = "tabInactive_Left"
                        sTabCenterClass = "tabInactive_Center"
                        sTabRightClass = "tabInactive_Right"
                        sTabLinkClass = "tabInactiveLink"
                        If sFile = sTmpItem(0).ToString() Then
                            'Active
                            sTabLeftClass = "tabActive_Left"
                            sTabCenterClass = "tabActive_Center"
                            sTabRightClass = "tabActive_Right"
                            sTabLinkClass = "tabActiveLink"
                        End If

                        sMenuTabs += "<td>" & _
                        "   <table onclick=""" & sOnClick & """ style=""cursor:pointer"" cellpadding=""0"" cellspacing=""0""><tr>" & _
                        "   <td><div id=""tabLeft" & nPgId & """ class=""" & sTabLeftClass & """></div></td>" & _
                        "   <td id=""tabCenter" & nPgId & """ class=""" & sTabCenterClass & """><a class=""" & sTabLinkClass & """ " & sTarget & " href=""" & sFile & """>" & sTtl & "</a></td>" & _
                        "   <td><div id=""tabRight" & nPgId & """ class=""" & sTabRightClass & """></div></td></tr></table>" & _
                        "</td>"

                    End If
                Else

                    If oColPath.Count = 1 Then
                        sTmpItem = oColPath(1)
                    Else
                        sTmpItem = oColPath(2)
                    End If

                    'Inactive
                    sTabLeftClass = "tabInactive_Left"
                    sTabCenterClass = "tabInactive_Center"
                    sTabRightClass = "tabInactive_Right"
                    sTabLinkClass = "tabInactiveLink"
                    If sFile = sTmpItem(0).ToString() Then
                        'Active
                        sTabLeftClass = "tabActive_Left"
                        sTabCenterClass = "tabActive_Center"
                        sTabRightClass = "tabActive_Right"
                        sTabLinkClass = "tabActiveLink"
                    End If

                    sMenuTabs += "<td>" & _
                    "   <table onclick=""" & sOnClick & """ style=""cursor:pointer"" cellpadding=""0"" cellspacing=""0""><tr>" & _
                    "   <td><div id=""tabLeft" & nPgId & """ class=""" & sTabLeftClass & """></div></td>" & _
                    "   <td id=""tabCenter" & nPgId & """ class=""" & sTabCenterClass & """><a class=""" & sTabLinkClass & """ " & sTarget & " href=""" & sFile & """>" & sTtl & "</a></td>" & _
                    "   <td><div id=""tabRight" & nPgId & """ class=""" & sTabRightClass & """></div></td></tr></table>" & _
                    "</td>"

                End If
            End If
        End While
        
        If sMenuTabs <> "" Then
            panelMenu.Controls.Add(New LiteralControl("<table cellpadding=""0"" cellspacing=""0""><tr>" & sMenuTabs & "</tr></table>"))
        End If

        oDataReader.Close()
        
        oConn.Close()
        oConn = Nothing
        oContent = Nothing
    End Sub
</script>

<asp:Panel ID="panelMenu" runat="server"></asp:Panel>
