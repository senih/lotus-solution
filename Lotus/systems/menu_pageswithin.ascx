﻿<%@ Control Language="VB" Inherits="BaseUserControl"%>
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
    
    'ParentParentId
    Private nParentParentID As Integer
    Public Property ParentParentID() As Integer
        Get
            Return nParentParentID
        End Get
        Set(ByVal value As Integer)
            nParentParentID = value
        End Set
    End Property
    
    Private sPagesWithin As String = ""
    Private sSameLevelPages As String = ""
    Private bDone As Boolean = False
    
    Public ReadOnly Property PagesWithin() As String
        Get
            If Not bDone Then
                GetData()
                bDone = True
            End If
            Return sPagesWithin
        End Get
    End Property
    
    Public ReadOnly Property SameLevelPages() As String
        Get
            If Not bDone Then
                GetData()
                bDone = True
            End If
            Return sSameLevelPages
        End Get
    End Property
    
    Private Sub GetData()
        'Default Configuration
        Dim sSameLevelPagesTitle As String = "Quick Links"
        
        'Load XML Configuration
        Dim sXmlPath As String = Server.MapPath("templates/" & Me.TemplateFolderName & "/default.xml")
        If IO.File.Exists(sXmlPath) Then
            Dim xmldoc As New XmlDocument
            Dim fs As New IO.FileStream(sXmlPath, IO.FileMode.Open, IO.FileAccess.Read)
            xmldoc.Load(fs)
            If Not IsNothing(xmldoc.SelectSingleNode("root/menu_samelevelpages/title")) Then
                sSameLevelPagesTitle = xmldoc.SelectSingleNode("root/menu_samelevelpages/title").InnerText
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
            oCommand = New SqlCommand("advcms_ShowPageMenu2")
        Else
            oCommand = New SqlCommand("advcms_ShowPageMenu")
        End If
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        Dim sHTMLPagesWithin As String = ""
        
        Dim sHTMLSameLevelPages As String = ""
        Dim nNumOfSameLevel As Integer = 0 'kalau >1 baru boleh ditampilkan

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

                'Database Stored Title Localization
                'If bIsSys Then
                '    sTtl = GetLocalResourceObject(sTtl)
                'End If
                
                If oDataReader("parent_id") = Me.PageID And Not Me.ParentID = 0 Then
                    
                    sHTMLPagesWithin += "<div class=""boxItemLinksWithin""><a " & sTarget & " href=""" & sFile & """>" & sTtl & "</a></div>"
                    
                End If
                
                If Not nParentParentID = 0 And Not Me.ParentID = 0 And nPrId = Me.ParentID Then

                    'sHTMLSameLevelPages += "<div class=""boxItemQuickLinks"">"
                    If nPgId = Me.PageID Then
                        sHTMLSameLevelPages += "<div class=""boxItemQuickLinksSelected"">" & sTtl & "</div>"
                    Else
                        sHTMLSameLevelPages += "<div class=""boxItemQuickLinks""><a " & sTarget & " href=""" & sFile & """>" & sTtl & "</a></div>"
                    End If
                    'sHTMLSameLevelPages += "</div>"
                    nNumOfSameLevel = nNumOfSameLevel + 1
                    
                End If
                
            End If
        End While

        oDataReader.Close()
        
        oConn.Close()
        oConn = Nothing
        oContent = Nothing
        
        If sHTMLPagesWithin <> "" Then
            sPagesWithin = "<div class=""boxLinksWithin_top""></div><div class=""boxLinksWithin"">" & sHTMLPagesWithin & "</div><div class=""boxLinksWithin_bottom""></div>"
        End If

        If nNumOfSameLevel > 1 Then
            sSameLevelPages = "<div class=""boxQuickLinks_top""></div><div class=""boxQuickLinks"">" & _
                sHTMLSameLevelPages & _
                "</div><div class=""boxQuickLinks_bottom""></div>"
        Else
            sSameLevelPages = ""
        End If
    End Sub
</script>

