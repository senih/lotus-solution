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
    
    Private sLinkPlacement As String
    Public Property LinkPlacement() As String
        Get
            Return sLinkPlacement
        End Get
        Set(ByVal value As String)
            sLinkPlacement = value
        End Set
    End Property
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)      
        
        'Default Configuration
        Dim nVertMenuLevel As Integer = ConfigurationManager.AppSettings("MaxDropdownMenuLevel") 'berlaku utk placeholderTopMenu_VerticalMenu juga
        Dim bHideHomeLink As Boolean = False
        
        Dim mnuBgImg As String = ""
        Dim mnuOverBgColor As String = ""
        Dim mnuNormalBgColor As String = ""
        'e.g.Rollover
        '<options name="mnuBgImg" value="templates/../images/menu_bg.gif"></options>
        '<options name="mnuOverBgColor" value="#D5D7CA"></options>
        '<options name="mnuNormalBgColor" value="#F1F1F1"></options>
        
        Dim sStyle As String = ""
        Dim sStyle2 As String = ""
        Dim sStyleSelected As String = ""
        Dim sOver As String = ""
        Dim sOut As String = ""
        
        'Load XML Configuration
        Dim sXmlPath As String = Server.MapPath("templates/" & Me.TemplateFolderName & "/default.xml")
        If IO.File.Exists(sXmlPath) Then
            Dim xmldoc As New XmlDocument
            Dim fs As New IO.FileStream(sXmlPath, IO.FileMode.Open, IO.FileAccess.Read)
            xmldoc.Load(fs)
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_vertical/hide_root")) Then
                bHideHomeLink = CBool(xmldoc.SelectSingleNode("root/menu_vertical/hide_root").InnerText)
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_vertical/mnuBgImg")) Then
                mnuBgImg = xmldoc.SelectSingleNode("root/menu_vertical/mnuBgImg").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_vertical/mnuOverBgColor")) Then
                mnuOverBgColor = xmldoc.SelectSingleNode("root/menu_vertical/mnuOverBgColor").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_vertical/mnuNormalBgColor")) Then
                mnuNormalBgColor = xmldoc.SelectSingleNode("root/menu_vertical/mnuNormalBgColor").InnerText
            End If
            xmldoc = Nothing
            fs = Nothing
            
            If mnuBgImg <> "" Then
                sStyle = "background:url('" & mnuBgImg & "') no-repeat 500 " & mnuNormalBgColor & ";"
                sStyle2 = "background:url('" & mnuBgImg & "') no-repeat left top " & mnuNormalBgColor & ";"
                sStyleSelected = "background:url('" & mnuBgImg & "') no-repeat left bottom " & mnuOverBgColor & ";"
                If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                    sOver = "this.style.backgroundPosition='left bottom';this.style.backgroundColor='" & mnuOverBgColor & "';"
                Else
                    sOver = "this.style.background='url(" & mnuBgImg & ") no-repeat left bottom " & mnuOverBgColor & "';"
                End If
                sOut = "this.style.backgroundPosition='left top';this.style.backgroundColor='" & mnuNormalBgColor & "';"
            End If
        End If
        
        'DB & Content object Init
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        Dim oContent As New Content
        
        If Me.IsUserLoggedIn Then 'yus
            oCommand = New SqlCommand("advcms_PageTree2")
        Else
            oCommand = New SqlCommand("advcms_PageTree")
        End If
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = nVertMenuLevel
        oCommand.Parameters.Add("@placement", SqlDbType.NVarChar, 50).Value = sLinkPlacement
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Dim sMenu As String = ""

        While oDataReader.Read()
            nLevel = CInt(oDataReader("lvl"))
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
                If Not bIsSys Then

                    If nLevel = 0 Then
                        If Not bHideHomeLink And sLinkPlacement = "main" Then 'Hide Home Link
                            If nPgId = Me.PageID Then
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuSelected"" style=""cursor:default;" & sStyleSelected & """>" & sTtl & "</td></tr>"
                            Else
                                If bUseWindowOpen Then
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.open('" & sFileUrl & "')"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                                Else
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.location.href='" & sFileUrl & "'"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                                End If
                            End If
                        End If
                    End If

                    If oColPath.Contains(nPgId.ToString) Then
                        If nPgId = Me.PageID Then
                            If nLevel = 1 Then
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuSelected"" style=""cursor:default;" & sStyleSelected & """>" & sTtl & "</td></tr>"
                            ElseIf nLevel > 1 Then
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuSelected"" style=""cursor:default;padding-left:" & ((nLevel - 1) * 20) & "px;" & sStyleSelected & """>" & sTtl & "</td></tr>"
                            End If
                        Else
                            If nLevel = 1 Then
                                If bUseWindowOpen Then
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuPath"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuPath';" & sOut & """ onclick=""window.open('" & sFileUrl & "')"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                                Else
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuPath"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuPath';" & sOut & """ onclick=""window.location.href='" & sFileUrl & "'"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                                End If
                            ElseIf nLevel > 1 Then
                                If bUseWindowOpen Then
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuPath"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuPath';" & sOut & """ onclick=""window.open('" & sFileUrl & "')"" style=""cursor:pointer;padding-left:" & ((nLevel - 1) * 20) & "px;" & sStyle & """>" & sTtl & "</td></tr>"
                                Else
                                    sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuPath"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuPath';" & sOut & """ onclick=""window.location.href='" & sFileUrl & "'"" style=""cursor:pointer;padding-left:" & ((nLevel - 1) * 20) & "px;" & sStyle & """>" & sTtl & "</td></tr>"
                                End If
                            End If
                        End If
                    Else
                        If nLevel = 1 Then
                            If bUseWindowOpen Then
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.open('" & sFileUrl & "')"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                            Else
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.location.href='" & sFileUrl & "'"" style=""cursor:pointer;" & sStyle & """>" & sTtl & "</td></tr>"
                            End If
                        ElseIf nLevel > 1 Then
                            If bUseWindowOpen Then
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.open('" & sFileUrl & "')"" style=""cursor:pointer;padding-left:" & ((nLevel - 1) * 20) & "px;" & sStyle & """>" & sTtl & "</td></tr>"
                            Else
                                sMenu += "<tr style=""" & sStyle2 & """><td class=""mnuNormal"" onmouseover=""this.className='mnuOver';" & sOver & """ onmouseout=""this.className='mnuNormal';" & sOut & """ onclick=""window.location.href='" & sFileUrl & "'"" style=""cursor:pointer;padding-left:" & ((nLevel - 1) * 20) & "px;" & sStyle & """>" & sTtl & "</td></tr>"
                            End If
                        End If
                    End If
                    
                End If
            End If

        End While
        
        If sMenu <> "" Then
            panelMenu.Controls.Add(New LiteralControl("<table class=""mnuVertical"" cellpadding=""0"" cellspacing=""0"">" & sMenu & "</table>"))
        End If

        oDataReader.Close()
        
        oConn.Close()
        oConn = Nothing
        oContent = Nothing
    End Sub
</script>

<asp:Panel ID="panelMenu" runat="server"></asp:Panel>
