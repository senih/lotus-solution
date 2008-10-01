<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.XML" %>
<%@ Import Namespace="System.Collections.Generic" %>

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
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)      
        'Add JavaScript
        Dim litJs As New Literal
        litJs.Text = "<script type=""text/javascript"" language=""javascript"" src=""systems/nlsmenu/nlsmenu.js""></sc" & "ript>"
        Page.Header.Controls.Add(litJs)
        Dim litJs2 As New Literal
        litJs2.Text = "<script type=""text/javascript"" language=""javascript"" src=""systems/nlsmenu/nlsmenueffect.js""></sc" & "ript>"
        Page.Header.Controls.Add(litJs2)
                
        'Default Configuration
        Dim bTreeHideRoot As Boolean = False
        Dim sOrient As String = "H"
        Dim sEffect As String = "fade"
        
        'Load XML Configuration
        Dim sXmlPath As String = Server.MapPath("templates/" & Me.TemplateFolderName & "/default.xml")
        If IO.File.Exists(sXmlPath) Then
            Dim xmldoc As New XmlDocument
            Dim fs As New IO.FileStream(sXmlPath, IO.FileMode.Open, IO.FileAccess.Read)
            xmldoc.Load(fs)
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_dropdown/hide_root")) Then
                bTreeHideRoot = CBool(xmldoc.SelectSingleNode("root/menu_dropdown/hide_root").InnerText)
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_dropdown/orient")) Then
                sOrient = xmldoc.SelectSingleNode("root/menu_dropdown/orient").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_dropdown/effect")) Then
                sEffect = xmldoc.SelectSingleNode("root/menu_dropdown/effect").InnerText
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
            oCommand = New SqlCommand("advcms_Sitemap2") 'Working
        Else
            oCommand = New SqlCommand("advcms_Sitemap") 'Published
        End If

        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxDropdownMenuLevel") '4=> 1 million
        oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "main"
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Dim sMenuScript As String = "var menuMgr = new NlsMenuManager(""mgr"");" & vbCrLf & _
            "menuMgr.defaultEffect=""" & sEffect & """;" & vbCrLf & _
            "menuMgr.timeout=500;" & vbCrLf
        
        Dim sMenuBar As String = "var menubar = menuMgr.createMenubar(""menubar"");" & vbCrLf & _
            "menubar.stlprf=""static_"";" & vbCrLf & _
            "menubar.showIcon=false;" & vbCrLf
        
        Dim sMenuItem As String = ""
        Dim nHomeId As Integer
        Dim dictTmp As New Dictionary(Of Integer, ArrayList)

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
                If nPrId = 0 Then
                    nHomeId = nPgId

                    If Not bTreeHideRoot Then
                        sMenuBar += "menubar.addItem(""" & nPgId & """, """ & sTtl & """, """ & sFileUrl & """, """", true, null, ""ref" & nPgId & """);" & vbCrLf
                    End If
                Else
                    Try
                        If nPrId = nHomeId Then
                            sMenuBar += "menubar.addItem(""" & nPgId & """, """ & sTtl & """, """ & sFileUrl & """, """", true, null, ""ref" & nPgId & """);" & vbCrLf
                            If bUseWindowOpen Then
                                sMenuBar += "menubar.getItemById(""" & nPgId & """).target=""_blank"";" & vbCrLf
                            End If
                        Else
                            If Not dictTmp.ContainsKey(nPrId) Then
                                sMenuItem += "var n" & nPrId & " = menuMgr.createMenu(""ref" & nPrId & """);" & vbCrLf
                                'Disable the following line to hide menu icon
                                'sMenuItem += "n" & nPrId & ".showIcon=true;" & vbCrLf
                            End If
                            sMenuItem += "n" & nPrId & ".addItem(""" & nPgId & """, """ & sTtl & """, """ & sFileUrl & """, [""systems/nlsmenu/img/submenuovr.gif"",""systems/nlsmenu/img/submenuovr.gif""], true, null, ""ref" & nPgId & """);" & vbCrLf
                            If bUseWindowOpen Then
                                sMenuBar += "n" & nPrId & ".getItemById(""" & nPgId & """).target=""_blank"";" & vbCrLf
                            End If
                            dictTmp.Add(nPrId, Nothing)
                        End If
                    Catch ex As Exception

                    End Try
                End If
            End If
        End While
                    
        panelMenu.Controls.Add(New LiteralControl("<script language=""JavaScript"" type=""text/javascript"">" & vbCrLf & "//<![CDATA[" & vbCrLf & _
            sMenuScript & _
            sMenuItem & _
            sMenuBar & _
            "menubar.orient=""" & sOrient & """;" & _
            "//]]></sc" & "ript>"))
            
        panelMenu.Controls.Add(New LiteralControl("<script language=""JavaScript"" type=""text/javascript"">" & vbCrLf & "//<![CDATA[" & vbCrLf & _
            "menuMgr.renderMenus();menuMgr.renderMenubar();" & _
            "//]]></sc" & "ript>"))

        oDataReader.Close()
        
        oConn.Close()
        oConn = Nothing
        oContent = Nothing
    End Sub
</script>

<asp:Panel ID="panelMenu" runat="server"></asp:Panel>
