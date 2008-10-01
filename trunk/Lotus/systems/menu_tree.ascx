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
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)      
        'Add JavaScript
        Dim litJs As New Literal
        litJs.Text = "<script type=""text/javascript"" language=""javascript"" src=""systems/nlstree/nlstree.js""></sc" & "ript>"
        Page.Header.Controls.Add(litJs)
        
        'Default Configuration
        Dim nTreeRootId As Integer = 1
        Dim bTreeScroll As Boolean = True
        Dim nTreeWidth As Integer = 266
        Dim nTreeHeight As Integer = 375
        Dim bTreeHideRoot As Boolean = False
        Dim bTreeExpandAll As Boolean = False
        
        'Load XML Configuration
        Dim sXmlPath As String = Server.MapPath("templates/" & Me.TemplateFolderName & "/default.xml")
        If IO.File.Exists(sXmlPath) Then
            Dim xmldoc As New XmlDocument
            Dim fs As New IO.FileStream(sXmlPath, IO.FileMode.Open, IO.FileAccess.Read)
            xmldoc.Load(fs)
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/root_id")) Then
                nTreeRootId = xmldoc.SelectSingleNode("root/menu_tree/root_id").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/scroll")) Then
                bTreeScroll = CBool(xmldoc.SelectSingleNode("root/menu_tree/scroll").InnerText)
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/width")) Then
                nTreeWidth = xmldoc.SelectSingleNode("root/menu_tree/width").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/height")) Then
                nTreeHeight = xmldoc.SelectSingleNode("root/menu_tree/height").InnerText
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/hide_root")) Then
                bTreeHideRoot = CBool(xmldoc.SelectSingleNode("root/menu_tree/hide_root").InnerText)
            End If
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_tree/expand_all")) Then
                bTreeExpandAll = CBool(xmldoc.SelectSingleNode("root/menu_tree/expand_all").InnerText)
            End If
            xmldoc = Nothing
            fs = Nothing
        End If
        
        'DB & Content object Init
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        Dim oContent As New Content
        
        If Me.IsUserLoggedIn Then
            oCommand = New SqlCommand("advcms_Sitemap2")
        Else
            oCommand = New SqlCommand("advcms_Sitemap")
        End If
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nTreeRootId
        oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = 10
        oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "main"
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Dim sTree As String = ""

        Dim nCurrLevel As Integer = 0
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
                If Not bIsSys Then 'nLevel=0 adalah level dari selected TAB

                    sTree += "tree.add(" & nPgId & ", " & nPrId & ", """ & sTtl & """, """ & sFileUrl & """, """", true);"
                    If bUseWindowOpen Then
                        sTree += "tree.setNodeTarget(" & nPgId & ", ""_blank"");"
                    End If
                    
                End If
            End If
            nCurrLevel = nLevel
        End While
        
        If sTree <> "" Then
            Dim sSetting As String = ""
            If bTreeScroll Then
                sSetting += "tree.opt.enbScroll = true;tree.opt.width = """ & nTreeWidth & "px"";tree.opt.height = """ & nTreeHeight & "px"";"
            End If
            If bTreeHideRoot Then
                sSetting += "tree.opt.hideRoot = true;"
            End If
            Dim sSetting2 As String = ""
            If Not bTreeExpandAll Then
                sSetting2 += "tree.collapseAll();"
            End If
            Dim sTmp As String = "<sc" & "ript>var tree = new NlsTree(""tree1"");" & sSetting & sTree & "tree.render();" & sSetting2 & "tree.selectNodeById(" & Me.PageID & ");</sc" & "ript>"
            panelMenu.Controls.Add(New LiteralControl(sTmp))
        End If

        oDataReader.Close()
        
        oConn.Close()
        oConn = Nothing
        oContent = Nothing
    End Sub
</script>

<asp:Panel ID="panelMenu" runat="server"></asp:Panel>
