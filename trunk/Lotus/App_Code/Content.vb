Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security.Membership

Public Class Content
    Private sConn As String
    Private oConn As SqlConnection

    Private bUserLoggedIn As Boolean = False
    Private arrUserRoles() As String
    Private sUserName As String

    Public Function GetPage(ByVal nPageId As Integer, Optional ByVal bShowHidden As Boolean = False) As DataTable
        If Not IsNothing(GetUser) Then
            bUserLoggedIn = True
        End If

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("page_id", GetType(Integer)))
        dt.Columns.Add(New DataColumn("title", GetType(String)))
        dt.Columns.Add(New DataColumn("summary", GetType(String)))
        dt.Columns.Add(New DataColumn("file_name", GetType(String)))
        dt.Columns.Add(New DataColumn("is_listing", GetType(Boolean)))
        dt.Columns.Add(New DataColumn("listing_type", GetType(Integer)))
        dt.Columns.Add(New DataColumn("listing_property", GetType(Integer)))
        dt.Columns.Add(New DataColumn("listing_default_order", GetType(String)))

        Dim nPgId As Integer
        Dim sTtl As String
        Dim sLnk As String
        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String 'Published Version
        Dim sFile As String 'eg. default.aspx, mysite/default.aspx
        Dim sSmry As String = ""
        Dim bIsListing As Boolean
        Dim nListingType As Integer
        Dim nListingProperty As Integer
        Dim sListingDefaultOrder As String
        Dim bIsListing2 As Boolean
        Dim nListingType2 As Integer
        Dim nListingProperty2 As Integer
        Dim sListingDefaultOrder2 As String

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        If bUserLoggedIn Then 'yus
            oCommand = New SqlCommand("Select * From pages_working where page_id=@page_id")
        Else
            oCommand = New SqlCommand("Select * From pages_published where page_id=@page_id")
        End If
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            nPgId = oDataReader("page_id").ToString
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            If sLnk <> "" Then sTtl = sLnk

            sFile = oDataReader("file_name").ToString
            sSmry = oDataReader("summary").ToString

            If Not IsDBNull(oDataReader("is_listing")) Then
                bIsListing = Convert.ToBoolean(oDataReader("is_listing"))
            Else
                bIsListing = False
            End If
            If Not IsDBNull(oDataReader("listing_type")) Then
                nListingType = oDataReader("listing_type")
            End If
            If Not IsDBNull(oDataReader("listing_property")) Then
                nListingProperty = oDataReader("listing_property")
            End If
            sListingDefaultOrder = oDataReader("listing_default_order").ToString

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0

            If bUserLoggedIn Then

                'Published Version
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                If sLnk2 <> "" Then sTtl2 = sLnk2

                If Not IsDBNull(oDataReader("is_listing2")) Then
                    bIsListing2 = Convert.ToBoolean(oDataReader("is_listing2"))
                Else
                    bIsListing2 = False
                End If
                If Not IsDBNull(oDataReader("listing_type2")) Then
                    nListingType2 = oDataReader("listing_type2")
                End If
                If Not IsDBNull(oDataReader("listing_property2")) Then
                    nListingProperty2 = oDataReader("listing_property2")
                End If
                sListingDefaultOrder2 = oDataReader("listing_default_order2").ToString

                If bShowHidden Then
                    nShowMenu = ShowLink2( _
                        CInt(oDataReader("channel_permission")), _
                        oDataReader("channel_name").ToString, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        CBool(oDataReader("is_system")), _
                        False, _
                        bUserLoggedIn, _
                        CBool(oDataReader("disable_collaboration")), _
                        oDataReader("owner").ToString, _
                        oDataReader("last_updated_date"), _
                        oDataReader("status").ToString)
                Else
                    nShowMenu = ShowLink2( _
                        CInt(oDataReader("channel_permission")), _
                        oDataReader("channel_name").ToString, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        CBool(oDataReader("is_system")), _
                        CBool(oDataReader("is_hidden")), _
                        bUserLoggedIn, _
                        CBool(oDataReader("disable_collaboration")), _
                        oDataReader("owner").ToString, _
                        oDataReader("last_updated_date"), _
                        oDataReader("status").ToString)
                End If


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
                        bIsListing = bIsListing2
                        If IsNothing(nListingType2) Then
                            nListingType = Nothing
                        Else
                            nListingType = nListingType2
                        End If
                        If IsNothing(nListingProperty2) Then
                            nListingProperty = Nothing
                        Else
                            nListingProperty = nListingProperty2
                        End If
                        sListingDefaultOrder = sListingDefaultOrder2
                    End If
                End If
            Else
                If bShowHidden Then
                    bShowMenu = ShowLink( _
                        CInt(oDataReader("channel_permission")), _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        CBool(oDataReader("is_system")), _
                        False)
                Else
                    bShowMenu = ShowLink( _
                        CInt(oDataReader("channel_permission")), _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        CBool(oDataReader("is_system")), _
                        CBool(oDataReader("is_hidden")))
                End If

            End If

            If bShowMenu Then
                Dim dr As DataRow = dt.NewRow()
                dr("page_id") = nPgId
                dr("title") = sTtl
                dr("summary") = sSmry
                dr("file_name") = sFile
                dr("is_listing") = bIsListing
                If IsNothing(nListingType) Then
                    dr("listing_type") = Nothing
                Else
                    dr("listing_type") = nListingType
                End If
                If IsNothing(nListingProperty) Then
                    dr("listing_property") = Nothing
                Else
                    dr("listing_property") = nListingProperty
                End If
                dr("listing_default_order") = sListingDefaultOrder

                dt.Rows.Add(dr)
            End If

        End While

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing

        Return dt
    End Function

    Private sSortingBy As String = ""
    Public Property SortingBy() As String
        Get
            SortingBy = sSortingBy
        End Get
        Set(ByVal value As String)
            sSortingBy = value
        End Set
    End Property

    Private sSortingType As String = ""
    Public Property SortingType() As String
        Get
            SortingType = sSortingType
        End Get
        Set(ByVal value As String)
            sSortingType = value
        End Set
    End Property

    Private bManualOrder As Boolean = False
    Public Property ManualOrder() As Boolean
        Get
            Return bManualOrder
        End Get
        Set(ByVal value As Boolean)
            bManualOrder = value
        End Set
    End Property

    Private nTimeOffset As Double = 0
    Public Property TimeOffset() As Double
        Get
            Return nTimeOffset
        End Get
        Set(ByVal value As Double)
            nTimeOffset = value
        End Set
    End Property

    Public Function GetPagesWithin2005(ByVal nPageId As Integer, ByVal nPageIndex As Integer, ByVal nNumRows As Integer, ByRef nRecordsCount As Integer, Optional ByVal nType As Integer = 1, Optional ByVal dDisplayDate As DateTime = Nothing, Optional ByVal nYear As Integer = 2007, Optional ByVal nMonth As Integer = 1, Optional ByVal nCatId As Integer = 1) As DataTable
        If Not IsNothing(GetUser) Then
            bUserLoggedIn = True
        End If

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("page_id", GetType(Integer))) '-- not used yet
        dt.Columns.Add(New DataColumn("title", GetType(String)))
        dt.Columns.Add(New DataColumn("summary", GetType(String)))
        dt.Columns.Add(New DataColumn("file_name", GetType(String)))
        dt.Columns.Add(New DataColumn("link_target", GetType(String)))
        dt.Columns.Add(New DataColumn("display_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("content_body", GetType(String))) '-- not used yet
        dt.Columns.Add(New DataColumn("picture", GetType(String))) '-- not used
        dt.Columns.Add(New DataColumn("owner", GetType(String)))
        dt.Columns.Add(New DataColumn("comments", GetType(Integer)))
        dt.Columns.Add(New DataColumn("use_read_more", GetType(Boolean))) '-- not used yet
        dt.Columns.Add(New DataColumn("file_download_url", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_url", GetType(String)))
        dt.Columns.Add(New DataColumn("last_updated_by", GetType(String)))
        dt.Columns.Add(New DataColumn("first_published_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("last_updated_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("rating", GetType(Decimal)))
        dt.Columns.Add(New DataColumn("file_size", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_downloads", GetType(Integer)))
        dt.Columns.Add(New DataColumn("downloads_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_hits", GetType(Integer)))
        dt.Columns.Add(New DataColumn("hits_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("current_price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("file_download", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_more_url", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_url", GetType(String)))

        Dim nPgId As Integer
        Dim sLastUpdBy As String
        Dim sLastUpdBy2 As String
        Dim dLastUpd As DateTime
        Dim dLastUpd2 As DateTime
        Dim nFSize As Integer
        Dim nFSize2 As Integer
        Dim sTtl As String
        Dim sTtl2 As String
        Dim sLinkText As String
        Dim sLinkText2 As String
        Dim sSmry As String = ""
        Dim sSmry2 As String = ""
        Dim sBody As String = ""
        Dim sBody2 As String = ""
        Dim sFileDownload As String
        Dim sFileDownload2 As String
        Dim sFileView As String
        Dim sFileView2 As String
        Dim sFileViewListing As String
        Dim sFileViewListing2 As String
        Dim sVer As String
        Dim sVer2 As String
        Dim dDispDate As DateTime
        Dim dDispDate2 As DateTime
        Dim sLinkTarget As String
        Dim sLinkTarget2 As String
        Dim sFileName As String 'eg. default.aspx, mysite/default.aspx
        Dim sFileName2 As String

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        If nType = 1 Or nType = 2 Then
            oCommand = New SqlCommand("advcms_GetPagesWithin")
        ElseIf nType = 3 Or nType = 4 Or nType = 5 Or nType = 6 Then
            oCommand = New SqlCommand("advcms_GetPagesWithinOnRange")
        Else 'If nType = 7 Then
            oCommand = New SqlCommand("advcms_GetPagesWithinOnCategory")
        End If
        oCommand.CommandType = CommandType.StoredProcedure
        If bManualOrder Then
            sSortingBy = "sorting"
            sSortingType = "ASC"
        End If

        'MsgBox(nPageId & " " & nPageIndex & " " & nNumRows & " " & sSortingBy & " " & sSortingType)
        oCommand.Parameters.Add("@sort_by", SqlDbType.VarChar).Value = sSortingBy
        oCommand.Parameters.Add("@sort_type", SqlDbType.VarChar).Value = sSortingType
        If bUserLoggedIn Then
            oCommand.Parameters.Add("@is_login", SqlDbType.Bit).Value = True 'pages_working
        Else
            oCommand.Parameters.Add("@is_login", SqlDbType.Bit).Value = False 'pages_published
        End If
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Parameters.Add("@now", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)
        oCommand.Parameters.Add("@page_index", SqlDbType.Int).Value = nPageIndex
        oCommand.Parameters.Add("@num_rows", SqlDbType.Int).Value = nNumRows

        Dim dSt As DateTime
        Dim dEnd As DateTime
        Dim dTmp As DateTime

        If nType = 1 Then 'General Listing

        End If
        If nType = 2 Then 'News/Journal

        End If
        If nType = 3 Then 'Date Selection
            dSt = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 0, 0, 0)
            dEnd = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 4 Then 'Get all posts on the visible month. 
            dSt = (New DateTime(nYear, nMonth, 1, 0, 0, 0)).Subtract(System.TimeSpan.FromDays(7))
            dEnd = (New DateTime(nYear, nMonth, Date.DaysInMonth(nYear, nMonth), 23, 59, 59)).Add(System.TimeSpan.FromDays(7))
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 5 Then 'Month Selection
            dSt = New DateTime(nYear, nMonth, 1, 0, 0, 0)
            dEnd = New DateTime(nYear, nMonth, Date.DaysInMonth(nYear, nMonth), 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 6 Then 'Week Selection
            dSt = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 0, 0, 0)
            dTmp = dDisplayDate.Add(System.TimeSpan.FromDays(6))
            dEnd = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 7 Then 'Get latest posts on the specified category.
            oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = nCatId
        End If

        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        While oDataReader.Read()

            nRecordsCount = CInt(oDataReader("total_rows"))

            nPgId = oDataReader("page_id").ToString
            sTtl = oDataReader("title").ToString
            sLinkText = oDataReader("link_text").ToString
            sFileName = oDataReader("file_name").ToString
            sSmry = oDataReader("summary").ToString
            sBody = oDataReader("content_body").ToString
            dDispDate = CDate(oDataReader("display_date"))
            sLinkTarget = oDataReader("link_target").ToString
            sFileDownload = oDataReader("file_attachment").ToString
            sFileViewListing = oDataReader("file_view_listing").ToString
            sFileView = oDataReader("file_view").ToString
            sVer = oDataReader("version").ToString
            sLastUpdBy = oDataReader("last_updated_by").ToString
            dLastUpd = oDataReader("last_updated_date")
            nFSize = oDataReader("file_size")

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0

            If bUserLoggedIn Then
                'Published Version
                sTtl2 = oDataReader("title2").ToString
                sLinkText2 = oDataReader("link_text2").ToString
                sFileName2 = oDataReader("file_name2").ToString
                sSmry2 = oDataReader("summary2").ToString
                sBody2 = oDataReader("content_body2").ToString
                If IsDBNull(oDataReader("display_date2")) Then
                    dDispDate2 = Nothing
                Else
                    dDispDate2 = oDataReader("display_date2")
                End If
                sLinkTarget2 = oDataReader("link_target2").ToString
                sFileDownload2 = oDataReader("file_attachment2").ToString
                sFileViewListing2 = oDataReader("file_view_listing2").ToString
                sFileView2 = oDataReader("file_view2").ToString
                sVer2 = oDataReader("version2").ToString
                sLastUpdBy2 = oDataReader("last_updated_by2").ToString
                If IsDBNull(oDataReader("last_updated_date2")) Then
                    dLastUpd2 = Nothing
                Else
                    dLastUpd2 = oDataReader("last_updated_date2")
                End If
                If IsDBNull(oDataReader("file_size2")) Then
                    nFSize2 = Nothing
                Else
                    nFSize2 = oDataReader("file_size2")
                End If

                nShowMenu = ShowLink2( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("channel_name").ToString, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")), _
                    bUserLoggedIn, _
                    CBool(oDataReader("disable_collaboration")), _
                    oDataReader("owner").ToString, _
                    oDataReader("last_updated_date"), _
                    oDataReader("status").ToString, False)

                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True

                    sLinkTarget = "_self" 'this will replace if value is _blank
                    'so that author can still edit the page in the same window

                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        'bShowMenu = True
                        If CBool(oDataReader("is_hidden2")) Then
                            bShowMenu = False
                        Else
                            bShowMenu = True
                        End If
                        sTtl = sTtl2
                        sLinkText = sLinkText2
                        sSmry = sSmry2
                        sBody = sBody2
                        sFileDownload = sFileDownload2
                        sFileViewListing = sFileViewListing2
                        sFileView = sFileView2
                        sVer = sVer2
                        sLastUpdBy = sLastUpdBy2
                        dLastUpd = dLastUpd2
                        nFSize = nFSize2
                        dDispDate = dDispDate2
                        sLinkTarget = sLinkTarget2
                        sFileName = sFileName2
                    End If
                End If
            Else
                bShowMenu = ShowLink( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")))
            End If

            If bShowMenu Then

                Dim sFileDownloadURL As String = ""
                If Not sFileDownload.ToString = "" Then
                    sFileDownloadURL = "systems/file_download.aspx?pg=" & nPgId & "&ver=" & sVer
                End If

                Dim sFileViewListingURL As String = ""
                Dim sFileViewListingMoreURL As String = ""
                Dim sFileViewURL As String = ""
                If Not sFileViewListing.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1).ToLower
                    If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                        'sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer

                        If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                            'Access using ASPX
                            sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer
                            sFileViewListingMoreURL = "systems/file_view_listing_more.aspx?pg=" & nPgId & "&ver=" & sVer
                        Else
                            'Access file directly
                            'Thumbnail 100px
                            Dim sTmp As String
                            sTmp = sFileViewListing.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                            sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                            sFileViewListingURL = "resources/internal/file_views_listing/" & nPgId & "/" & sTmp
                            sFileViewListingMoreURL = "resources/internal/file_views_listing/" & nPgId & "/" & sFileViewListing
                        End If
                    End If
                End If
                If Not sFileView.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileView.Substring(sFileView.LastIndexOf(".") + 1).ToLower

                    'If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                    If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                        'Access using ASPX
                        sFileViewURL = "systems/file_view.aspx?pg=" & nPgId & "&ver=" & sVer
                    Else
                        'Access file directly
                        'Thumbnail 100px
                        Dim sTmp As String
                        sTmp = sFileView.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                        sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                        sFileViewURL = "resources/internal/file_views/" & nPgId & "/" & sFileView
                    End If
                    'End If
                End If

                If oDataReader("parent_id") = nPageId Then
                    Dim dr As DataRow = dt.NewRow()
                    dr("page_id") = nPgId

                    If sLinkText <> "" Then sTtl = sLinkText
                    dr("title") = sTtl

                    dr("summary") = sSmry

                    dr("file_download_url") = sFileDownloadURL
                    dr("file_view_listing_url") = sFileViewListingURL
                    dr("file_view_listing_more_url") = sFileViewListingMoreURL
                    dr("file_view_url") = sFileViewURL

                    dr("file_name") = sFileName
                    dr("display_date") = dDispDate
                    dr("link_target") = sLinkTarget

                    'If bBlog Then
                    '    If sBody.Contains("[break]") Then
                    '        dr("use_read_more") = True
                    '    Else
                    '        dr("use_read_more") = False
                    '    End If
                    '    sBody = sBody.Split("[break]")(0) '& "&nbsp;<a href=""" & sFile & """>More</a>"
                    'Else
                    '    dr("use_read_more") = False
                    'End If
                    dr("use_read_more") = False

                    dr("content_body") = sBody
                    dr("owner") = oDataReader("owner").ToString

                    If IsDBNull(oDataReader("comments")) Then
                        dr("comments") = 0
                    Else
                        dr("comments") = oDataReader("comments")
                    End If

                    dr("last_updated_by") = sLastUpdBy.ToString
                    If IsNothing(dLastUpd) Then
                        dr("last_updated_date") = Nothing
                    Else
                        dr("last_updated_date") = dLastUpd
                    End If
                    If Not sFileDownload.ToString = "" Then
                        dr("file_download") = sFileDownload.Substring(sFileDownload.IndexOf("_") + 1)
                    Else
                        dr("file_download") = ""
                    End If

                    If IsNothing(nFSize) Then
                        dr("file_size") = Nothing
                    Else
                        dr("file_size") = nFSize
                    End If
                    If Not IsDBNull(oDataReader("first_published_date")) Then
                        dr("first_published_date") = oDataReader("first_published_date")
                    End If
                    If IsDBNull(oDataReader("ratings")) Then
                        dr("rating") = 0
                    Else
                        dr("rating") = oDataReader("ratings") / oDataReader("total_voters")
                    End If
                    If IsDBNull(oDataReader("total_downloads")) Then
                        dr("total_downloads") = 0
                    Else
                        dr("total_downloads") = oDataReader("total_downloads")
                    End If
                    If IsDBNull(oDataReader("downloads_today")) Then
                        dr("downloads_today") = 0
                    Else
                        dr("downloads_today") = oDataReader("downloads_today")
                    End If
                    If IsDBNull(oDataReader("total_hits")) Then
                        dr("total_hits") = 0
                    Else
                        dr("total_hits") = oDataReader("total_hits")
                    End If
                    If IsDBNull(oDataReader("hits_today")) Then
                        dr("hits_today") = 0
                    Else
                        dr("hits_today") = oDataReader("hits_today")
                    End If

                    'Always from published or latest
                    If IsDBNull(oDataReader("price")) Then
                        dr("price") = 0
                    Else
                        dr("price") = oDataReader("price")
                    End If
                    If IsDBNull(oDataReader("current_price")) Then
                        dr("current_price") = 0
                    Else
                        dr("current_price") = oDataReader("current_price")
                    End If

                    dt.Rows.Add(dr)
                End If

            End If

        End While

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing


        'Ini dulu dipakai krn ada (misal) sort by current_price (field ini adanya di dataset, tapi tdk ada di table database)
        'Sekarang tdk dipakai krn ada issue kalau limit misal 3 records, seharusnya disorting dulu baru di-limit
        'If Not bManualOrder Then
        'dt.DefaultView.Sort = sSQLSort
        'End If

        Return dt
    End Function



    Public Function GetPagesWithin(ByVal nPageId As Integer, Optional ByVal nLimit As Integer = 0, Optional ByVal nType As Integer = 1, Optional ByVal dDisplayDate As DateTime = Nothing, Optional ByVal bBlog As Boolean = False, Optional ByVal nYear As Integer = 2007, Optional ByVal nMonth As Integer = 1, Optional ByVal nCatId As Integer = 1) As DataTable
        If Not IsNothing(GetUser) Then
            bUserLoggedIn = True
        End If

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("page_id", GetType(Integer))) '-- not used yet
        dt.Columns.Add(New DataColumn("title", GetType(String)))
        dt.Columns.Add(New DataColumn("summary", GetType(String)))
        dt.Columns.Add(New DataColumn("file_name", GetType(String)))
        dt.Columns.Add(New DataColumn("link_target", GetType(String)))
        dt.Columns.Add(New DataColumn("display_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("content_body", GetType(String))) '-- not used yet
        dt.Columns.Add(New DataColumn("picture", GetType(String))) '-- not used
        dt.Columns.Add(New DataColumn("owner", GetType(String)))
        dt.Columns.Add(New DataColumn("comments", GetType(Integer)))
        dt.Columns.Add(New DataColumn("use_read_more", GetType(Boolean))) '-- not used yet
        dt.Columns.Add(New DataColumn("file_download_url", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_url", GetType(String)))

        dt.Columns.Add(New DataColumn("last_updated_by", GetType(String)))
        dt.Columns.Add(New DataColumn("first_published_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("last_updated_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("rating", GetType(Decimal)))
        dt.Columns.Add(New DataColumn("file_size", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_downloads", GetType(Integer)))
        dt.Columns.Add(New DataColumn("downloads_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_hits", GetType(Integer)))
        dt.Columns.Add(New DataColumn("hits_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("current_price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("file_download", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_more_url", GetType(String)))

        dt.Columns.Add(New DataColumn("file_view_url", GetType(String)))

        Dim nPgId As Integer

        Dim sLastUpdBy As String
        Dim sLastUpdBy2 As String
        Dim dLastUpd As DateTime
        Dim dLastUpd2 As DateTime
        Dim nFSize As Integer
        Dim nFSize2 As Integer
        Dim sTtl As String
        Dim sTtl2 As String
        Dim sLinkText As String
        Dim sLinkText2 As String
        Dim sSmry As String = ""
        Dim sSmry2 As String = ""
        Dim sBody As String = ""
        Dim sBody2 As String = ""
        Dim sFileDownload As String
        Dim sFileDownload2 As String
        Dim sFileView As String
        Dim sFileView2 As String
        Dim sFileViewListing As String
        Dim sFileViewListing2 As String
        Dim sVer As String
        Dim sVer2 As String
        Dim dDispDate As DateTime
        Dim dDispDate2 As DateTime
        Dim sLinkTarget As String
        Dim sLinkTarget2 As String
        Dim sFileName As String 'eg. default.aspx, mysite/default.aspx
        Dim sFileName2 As String

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sListingShort As String = ""
        Dim bShowShortListPages As Boolean = False

        Dim sLimit As String = ""
        If nLimit <> 0 Then
            sLimit = " top " & nLimit
        End If

        Dim sSQLSort As String = ""
        If Not sSortingBy = "" Then
            sSQLSort = sSortingBy & " " & sSortingType
        End If

        'Dim sSQL As String = ""
        Dim sSQL As String = "SET LANGUAGE us_english "

        If bUserLoggedIn Then
            If nType = 1 Then
                sSQL = sSQL & "select " & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today, pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                    "from pages_working  " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                    "where pages_working.parent_id=@page_id"
            ElseIf nType = 2 Then 'SAMA DGN 1
                sSQL = sSQL & "select " & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                    "from pages_working  " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                    "where pages_working.parent_id=@page_id"
            ElseIf nType = 3 Or nType = 4 Or nType = 5 Then 'AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end
                sSQL = sSQL & "select" & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                    "from pages_working " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end"
            ElseIf nType = 6 Then 'SAMA DGN 4 & 5 | AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end
                sSQL = sSQL & "select" & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                    "from pages_working " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end"
            ElseIf nType = 7 Then 'listing_category_map.listing_category_id = @listing_category_id
                sSQL = sSQL & "select " & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                    "from pages_working " & _
                    "INNER JOIN listing_category_map ON pages_working.page_id = listing_category_map.page_id " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                    "where listing_category_map.listing_category_id = @listing_category_id"
            End If
        Else
            If nType = 1 Then
                sSQL = sSQL & "select " & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                    "from pages_published " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id"
            ElseIf nType = 2 Then 'SAMA DGN 1
                sSQL = sSQL & "select " & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                    "from pages_published " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id"
            ElseIf nType = 3 Or nType = 4 Or nType = 5 Then
                sSQL = sSQL & "select" & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                    "from pages_published " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end"
            ElseIf nType = 6 Then
                sSQL = sSQL & "select" & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                    "from pages_published " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                    "where parent_id=@page_id AND CONVERT(VARCHAR(10),display_date,111)>=@date_start AND CONVERT(VARCHAR(10),display_date,111)<=@date_end"
            ElseIf nType = 7 Then
                sSQL = sSQL & "select " & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                    "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                    "from pages_published " & _
                    "INNER JOIN listing_category_map ON pages_published.page_id = listing_category_map.page_id " & _
                    "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                    "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                    "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "   SELECT * FROM pages_views_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                    "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN ( " & _
                    "	SELECT * FROM pages_downloads_count_daily " & _
                    "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                    "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                    "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                    "where listing_category_map.listing_category_id = @listing_category_id"
            End If
        End If

        If bManualOrder Then
            sSQL = sSQL & " order by sorting ASC"
        Else
            If Not sSQLSort = "" Then
                sSQL = sSQL & " order by " & sSQLSort
            End If
        End If

        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId

        oCommand.Parameters.Add("@now", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)

        Dim dSt As DateTime
        Dim dEnd As DateTime
        Dim dTmp As DateTime

        If nType = 3 Then 'Date Selection
            dSt = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 0, 0, 0)
            dEnd = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 4 Then 'Get all posts on the visible month. 
            dSt = (New DateTime(nYear, nMonth, 1, 0, 0, 0)).Subtract(System.TimeSpan.FromDays(7))
            dEnd = (New DateTime(nYear, nMonth, Date.DaysInMonth(nYear, nMonth), 23, 59, 59)).Add(System.TimeSpan.FromDays(7))
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 5 Then 'Month Selection
            dSt = New DateTime(nYear, nMonth, 1, 0, 0, 0)
            dEnd = New DateTime(nYear, nMonth, Date.DaysInMonth(nYear, nMonth), 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 6 Then 'Week Selection
            dSt = New DateTime(dDisplayDate.Year, dDisplayDate.Month, dDisplayDate.Day, 0, 0, 0)
            dTmp = dDisplayDate.Add(System.TimeSpan.FromDays(6))
            dEnd = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 23, 59, 59)
            dSt = dSt.AddHours(-nTimeOffset)
            dEnd = dEnd.AddHours(-nTimeOffset)
            oCommand.Parameters.Add("@date_start", SqlDbType.DateTime).Value = dSt
            oCommand.Parameters.Add("@date_end", SqlDbType.DateTime).Value = dEnd
        End If
        If nType = 7 Then
            oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = nCatId
        End If

        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        While oDataReader.Read()

            nPgId = oDataReader("page_id").ToString
            sTtl = oDataReader("title").ToString
            sLinkText = oDataReader("link_text").ToString
            sFileName = oDataReader("file_name").ToString
            sSmry = oDataReader("summary").ToString
            sBody = oDataReader("content_body").ToString
            dDispDate = CDate(oDataReader("display_date"))
            sLinkTarget = oDataReader("link_target").ToString
            sFileDownload = oDataReader("file_attachment").ToString
            sFileViewListing = oDataReader("file_view_listing").ToString
            sFileView = oDataReader("file_view").ToString
            sVer = oDataReader("version").ToString
            sLastUpdBy = oDataReader("last_updated_by").ToString
            dLastUpd = oDataReader("last_updated_date")
            nFSize = oDataReader("file_size")

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0

            If bUserLoggedIn Then
                'Published Version
                sTtl2 = oDataReader("title2").ToString
                sLinkText2 = oDataReader("link_text2").ToString
                sFileName2 = oDataReader("file_name2").ToString
                sSmry2 = oDataReader("summary2").ToString
                sBody2 = oDataReader("content_body2").ToString
                If IsDBNull(oDataReader("display_date2")) Then
                    dDispDate2 = Nothing
                Else
                    dDispDate2 = oDataReader("display_date2")
                End If
                sLinkTarget2 = oDataReader("link_target2").ToString
                sFileDownload2 = oDataReader("file_attachment2").ToString
                sFileViewListing2 = oDataReader("file_view_listing2").ToString
                sFileView2 = oDataReader("file_view2").ToString
                sVer2 = oDataReader("version2").ToString
                sLastUpdBy2 = oDataReader("last_updated_by2").ToString
                If IsDBNull(oDataReader("last_updated_date2")) Then
                    dLastUpd2 = Nothing
                Else
                    dLastUpd2 = oDataReader("last_updated_date2")
                End If
                If IsDBNull(oDataReader("file_size2")) Then
                    nFSize2 = Nothing
                Else
                    nFSize2 = oDataReader("file_size2")
                End If

                nShowMenu = ShowLink2( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("channel_name").ToString, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")), _
                    bUserLoggedIn, _
                    CBool(oDataReader("disable_collaboration")), _
                    oDataReader("owner").ToString, _
                    oDataReader("last_updated_date"), _
                    oDataReader("status").ToString, bBlog)

                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True

                    sLinkTarget = "_self" 'this will replace if value is _blank
                    'so that author can still edit the page in the same window

                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        'bShowMenu = True
                        If CBool(oDataReader("is_hidden2")) Then
                            bShowMenu = False
                        Else
                            bShowMenu = True
                        End If
                        sTtl = sTtl2
                        sLinkText = sLinkText2
                        sSmry = sSmry2
                        sBody = sBody2
                        sFileDownload = sFileDownload2
                        sFileViewListing = sFileViewListing2
                        sFileView = sFileView2
                        sVer = sVer2
                        sLastUpdBy = sLastUpdBy2
                        dLastUpd = dLastUpd2
                        nFSize = nFSize2
                        dDispDate = dDispDate2
                        sLinkTarget = sLinkTarget2
                        sFileName = sFileName2
                    End If
                End If
            Else
                bShowMenu = ShowLink( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")))
            End If

            If bShowMenu Then

                Dim sFileDownloadURL As String = ""
                If Not sFileDownload.ToString = "" Then
                    sFileDownloadURL = "systems/file_download.aspx?pg=" & nPgId & "&ver=" & sVer
                End If

                Dim sFileViewListingURL As String = ""
                Dim sFileViewListingMoreURL As String = ""
                Dim sFileViewURL As String = ""
                If Not sFileViewListing.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1).ToLower
                    If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                        'sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer

                        If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                            'Access using ASPX
                            sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer
                            sFileViewListingMoreURL = "systems/file_view_listing_more.aspx?pg=" & nPgId & "&ver=" & sVer
                        Else
                            'Access file directly
                            'Thumbnail 100px
                            Dim sTmp As String
                            sTmp = sFileViewListing.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                            sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                            sFileViewListingURL = "resources/internal/file_views_listing/" & nPgId & "/" & sTmp
                            sFileViewListingMoreURL = "resources/internal/file_views_listing/" & nPgId & "/" & sFileViewListing
                        End If
                    End If
                End If
                If Not sFileView.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileView.Substring(sFileView.LastIndexOf(".") + 1).ToLower

                    'If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                    If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                        'Access using ASPX
                        sFileViewURL = "systems/file_view.aspx?pg=" & nPgId & "&ver=" & sVer
                    Else
                        'Access file directly
                        'Thumbnail 100px
                        Dim sTmp As String
                        sTmp = sFileView.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                        sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                        sFileViewURL = "resources/internal/file_views/" & nPgId & "/" & sFileView
                    End If
                    'End If
                End If

                If oDataReader("parent_id") = nPageId Then
                    Dim dr As DataRow = dt.NewRow()
                    dr("page_id") = nPgId

                    If sLinkText <> "" Then sTtl = sLinkText
                    dr("title") = sTtl

                    dr("summary") = sSmry

                    dr("file_download_url") = sFileDownloadURL
                    dr("file_view_listing_url") = sFileViewListingURL
                    dr("file_view_listing_more_url") = sFileViewListingMoreURL
                    dr("file_view_url") = sFileViewURL

                    dr("file_name") = sFileName
                    dr("display_date") = dDispDate
                    dr("link_target") = sLinkTarget
                    If bBlog Then
                        If sBody.Contains("[break]") Then
                            dr("use_read_more") = True
                        Else
                            dr("use_read_more") = False
                        End If
                        sBody = sBody.Split("[break]")(0) '& "&nbsp;<a href=""" & sFile & """>More</a>"
                    Else
                        dr("use_read_more") = False
                    End If
                    dr("content_body") = sBody
                    dr("owner") = oDataReader("owner").ToString

                    If IsDBNull(oDataReader("comments")) Then
                        dr("comments") = 0
                    Else
                        dr("comments") = oDataReader("comments")
                    End If

                    dr("last_updated_by") = sLastUpdBy.ToString
                    If IsNothing(dLastUpd) Then
                        dr("last_updated_date") = Nothing
                    Else
                        dr("last_updated_date") = dLastUpd
                    End If
                    If Not sFileDownload.ToString = "" Then
                        dr("file_download") = sFileDownload.Substring(sFileDownload.IndexOf("_") + 1)
                    Else
                        dr("file_download") = ""
                    End If

                    If IsNothing(nFSize) Then
                        dr("file_size") = Nothing
                    Else
                        dr("file_size") = nFSize
                    End If
                    If Not IsDBNull(oDataReader("first_published_date")) Then
                        dr("first_published_date") = oDataReader("first_published_date")
                    End If
                    If IsDBNull(oDataReader("ratings")) Then
                        dr("rating") = 0
                    Else
                        dr("rating") = oDataReader("ratings") / oDataReader("total_voters")
                    End If
                    If IsDBNull(oDataReader("total_downloads")) Then
                        dr("total_downloads") = 0
                    Else
                        dr("total_downloads") = oDataReader("total_downloads")
                    End If
                    If IsDBNull(oDataReader("downloads_today")) Then
                        dr("downloads_today") = 0
                    Else
                        dr("downloads_today") = oDataReader("downloads_today")
                    End If
                    If IsDBNull(oDataReader("total_hits")) Then
                        dr("total_hits") = 0
                    Else
                        dr("total_hits") = oDataReader("total_hits")
                    End If
                    If IsDBNull(oDataReader("hits_today")) Then
                        dr("hits_today") = 0
                    Else
                        dr("hits_today") = oDataReader("hits_today")
                    End If

                    'Always from published or latest
                    If IsDBNull(oDataReader("price")) Then
                        dr("price") = 0
                    Else
                        dr("price") = oDataReader("price")
                    End If
                    If IsDBNull(oDataReader("current_price")) Then
                        dr("current_price") = 0
                    Else
                        dr("current_price") = oDataReader("current_price")
                    End If

                    dt.Rows.Add(dr)
                End If

            End If

        End While

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing


        'Ini dulu dipakai krn ada (misal) sort by current_price (field ini adanya di dataset, tapi tdk ada di table database)
        'Sekarang tdk dipakai krn ada issue kalau limit misal 3 records, seharusnya disorting dulu baru di-limit
        'If Not bManualOrder Then
        'dt.DefaultView.Sort = sSQLSort
        'End If

        Return dt
    End Function

    Public Function GetMultiplePagesWithin(ByVal sPageId As String, Optional ByVal nLimit As Integer = 0, Optional ByVal nType As Integer = 1, Optional ByVal dDisplayDate As DateTime = Nothing, Optional ByVal bBlog As Boolean = False, Optional ByVal nYear As Integer = 2007, Optional ByVal nMonth As Integer = 1, Optional ByVal nCatId As Integer = 1) As DataTable
        If Not IsNothing(GetUser) Then
            bUserLoggedIn = True
        End If

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("page_id", GetType(Integer))) '-- not used yet
        dt.Columns.Add(New DataColumn("title", GetType(String)))
        dt.Columns.Add(New DataColumn("summary", GetType(String)))
        dt.Columns.Add(New DataColumn("file_name", GetType(String)))
        dt.Columns.Add(New DataColumn("link_target", GetType(String)))
        dt.Columns.Add(New DataColumn("display_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("content_body", GetType(String))) '-- not used yet
        dt.Columns.Add(New DataColumn("picture", GetType(String))) '-- not used
        dt.Columns.Add(New DataColumn("owner", GetType(String)))
        dt.Columns.Add(New DataColumn("comments", GetType(Integer)))
        dt.Columns.Add(New DataColumn("use_read_more", GetType(Boolean))) '-- not used yet
        dt.Columns.Add(New DataColumn("file_download_url", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_url", GetType(String)))

        dt.Columns.Add(New DataColumn("last_updated_by", GetType(String)))
        dt.Columns.Add(New DataColumn("first_published_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("last_updated_date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("rating", GetType(Decimal)))
        dt.Columns.Add(New DataColumn("file_size", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_downloads", GetType(Integer)))
        dt.Columns.Add(New DataColumn("downloads_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("total_hits", GetType(Integer)))
        dt.Columns.Add(New DataColumn("hits_today", GetType(Integer)))
        dt.Columns.Add(New DataColumn("price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("current_price", GetType(Decimal))) 'Always from published or latest
        dt.Columns.Add(New DataColumn("file_download", GetType(String)))
        dt.Columns.Add(New DataColumn("file_view_listing_more_url", GetType(String)))

        dt.Columns.Add(New DataColumn("file_view_url", GetType(String)))

        Dim nPgId As Integer

        Dim sLastUpdBy As String
        Dim sLastUpdBy2 As String
        Dim dLastUpd As DateTime
        Dim dLastUpd2 As DateTime
        Dim nFSize As Integer
        Dim nFSize2 As Integer
        Dim sTtl As String
        Dim sTtl2 As String
        Dim sLinkText As String
        Dim sLinkText2 As String
        Dim sSmry As String = ""
        Dim sSmry2 As String = ""
        Dim sBody As String = ""
        Dim sBody2 As String = ""
        Dim sFileDownload As String
        Dim sFileDownload2 As String
        Dim sFileView As String
        Dim sFileView2 As String
        Dim sFileViewListing As String
        Dim sFileViewListing2 As String
        Dim sVer As String
        Dim sVer2 As String
        Dim dDispDate As DateTime
        Dim dDispDate2 As DateTime
        Dim sLinkTarget As String
        Dim sLinkTarget2 As String
        Dim sFileName As String 'eg. default.aspx, mysite/default.aspx
        Dim sFileName2 As String

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sListingShort As String = ""
        Dim bShowShortListPages As Boolean = False

        Dim sLimit As String = ""
        If nLimit <> 0 Then
            sLimit = " top " & nLimit
        End If

        Dim sSQLSort As String = ""
        If Not sSortingBy = "" Then
            sSQLSort = sSortingBy & " " & sSortingType
        End If

        'Dim sSQL As String = ""
        Dim sSQL As String = "SET LANGUAGE us_english "
        Dim sSqlPageId As String = ""

        If bUserLoggedIn Then

            For Each item As String In sPageId.Split(",")
                If Not sSqlPageId = "" Then sSqlPageId += " OR"
                sSqlPageId = sSqlPageId & " pages_working.parent_id=" & item
            Next

            sSQL = sSQL & "select " & sLimit & " pages_working.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                "(CASE WHEN pages_working.sale_price>0 THEN pages_working.sale_price ELSE (CASE WHEN pages_working.discount_percentage > 0 THEN pages_working.price - (pages_working.price * (pages_working.discount_percentage / 100)) ELSE pages_working.price END) END) AS current_price " & _
                "from pages_working  " & _
                "LEFT OUTER JOIN pages_comments_count ON pages_working.page_id = pages_comments_count.page_id  " & _
                "LEFT OUTER JOIN pages_views_count ON pages_working.page_id = pages_views_count.page_id  " & _
                "LEFT OUTER JOIN pages_downloads_count ON pages_working.page_id = pages_downloads_count.page_id  " & _
                "LEFT OUTER JOIN ( " & _
                "   SELECT * FROM pages_views_count_daily " & _
                "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                "	ON pages_working.page_id = pages_views_count_daily_.page_id  " & _
                "LEFT OUTER JOIN ( " & _
                "	SELECT * FROM pages_downloads_count_daily " & _
                "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                "	ON pages_working.page_id = pages_downloads_count_daily_.page_id  " & _
                "LEFT OUTER JOIN pages_ratings_count ON pages_working.page_id = pages_ratings_count.page_id  " & _
                "where " & sSqlPageId
        Else
            For Each item As String In sPageId.Split(",")
                If Not sSqlPageId = "" Then sSqlPageId += " OR"
                sSqlPageId = sSqlPageId & " parent_id=" & item
            Next

            sSQL = sSQL & "select " & sLimit & " pages_published.*, pages_comments_count.comments, pages_views_count.total as total_hits, pages_views_count_daily_.count as hits_today, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters, pages_ratings_count.ratings/pages_ratings_count.total_voters as rating, " & _
                "(CASE WHEN pages_published.sale_price>0 THEN pages_published.sale_price ELSE (CASE WHEN pages_published.discount_percentage > 0 THEN pages_published.price - (pages_published.price * (pages_published.discount_percentage / 100)) ELSE pages_published.price END) END) AS current_price " & _
                "from pages_published " & _
                "LEFT OUTER JOIN pages_comments_count ON pages_published.page_id = pages_comments_count.page_id  " & _
                "LEFT OUTER JOIN pages_views_count ON pages_published.page_id = pages_views_count.page_id  " & _
                "LEFT OUTER JOIN pages_downloads_count ON pages_published.page_id = pages_downloads_count.page_id  " & _
                "LEFT OUTER JOIN ( " & _
                "   SELECT * FROM pages_views_count_daily " & _
                "	WHERE date_stamp = @now) as pages_views_count_daily_ " & _
                "	ON pages_published.page_id = pages_views_count_daily_.page_id  " & _
                "LEFT OUTER JOIN ( " & _
                "	SELECT * FROM pages_downloads_count_daily " & _
                "	WHERE date_stamp = @now) as pages_downloads_count_daily_  " & _
                "	ON pages_published.page_id = pages_downloads_count_daily_.page_id  " & _
                "LEFT OUTER JOIN pages_ratings_count ON pages_published.page_id = pages_ratings_count.page_id  " & _
                "where " & sSqlPageId
        End If

        If bManualOrder Then
            sSQL = sSQL & " order by sorting ASC"
        Else
            If Not sSQLSort = "" Then
                sSQL = sSQL & " order by " & sSQLSort
            End If
        End If

        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@now", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)

        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        While oDataReader.Read()

            nPgId = oDataReader("page_id").ToString
            sTtl = oDataReader("title").ToString
            sLinkText = oDataReader("link_text").ToString
            sFileName = oDataReader("file_name").ToString
            sSmry = oDataReader("summary").ToString
            sBody = oDataReader("content_body").ToString
            dDispDate = CDate(oDataReader("display_date"))
            sLinkTarget = oDataReader("link_target").ToString
            sFileDownload = oDataReader("file_attachment").ToString
            sFileViewListing = oDataReader("file_view_listing").ToString
            sFileView = oDataReader("file_view").ToString
            sVer = oDataReader("version").ToString
            sLastUpdBy = oDataReader("last_updated_by").ToString
            dLastUpd = oDataReader("last_updated_date")
            nFSize = oDataReader("file_size")

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0

            If bUserLoggedIn Then
                'Published Version
                sTtl2 = oDataReader("title2").ToString
                sLinkText2 = oDataReader("link_text2").ToString
                sFileName2 = oDataReader("file_name2").ToString
                sSmry2 = oDataReader("summary2").ToString
                sBody2 = oDataReader("content_body2").ToString
                If IsDBNull(oDataReader("display_date2")) Then
                    dDispDate2 = Nothing
                Else
                    dDispDate2 = oDataReader("display_date2")
                End If
                sLinkTarget2 = oDataReader("link_target2").ToString
                sFileDownload2 = oDataReader("file_attachment2").ToString
                sFileViewListing2 = oDataReader("file_view_listing2").ToString
                sFileView2 = oDataReader("file_view2").ToString
                sVer2 = oDataReader("version2").ToString
                sLastUpdBy2 = oDataReader("last_updated_by2").ToString
                If IsDBNull(oDataReader("last_updated_date2")) Then
                    dLastUpd2 = Nothing
                Else
                    dLastUpd2 = oDataReader("last_updated_date2")
                End If
                If IsDBNull(oDataReader("file_size2")) Then
                    nFSize2 = Nothing
                Else
                    nFSize2 = oDataReader("file_size2")
                End If

                nShowMenu = ShowLink2( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("channel_name").ToString, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")), _
                    bUserLoggedIn, _
                    CBool(oDataReader("disable_collaboration")), _
                    oDataReader("owner").ToString, _
                    oDataReader("last_updated_date"), _
                    oDataReader("status").ToString, bBlog)

                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True

                    sLinkTarget = "_self" 'this will replace if value is _blank
                    'so that author can still edit the page in the same window

                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        'bShowMenu = True
                        If CBool(oDataReader("is_hidden2")) Then
                            bShowMenu = False
                        Else
                            bShowMenu = True
                        End If
                        sTtl = sTtl2
                        sLinkText = sLinkText2
                        sSmry = sSmry2
                        sBody = sBody2
                        sFileDownload = sFileDownload2
                        sFileViewListing = sFileViewListing2
                        sFileView = sFileView2
                        sVer = sVer2
                        sLastUpdBy = sLastUpdBy2
                        dLastUpd = dLastUpd2
                        nFSize = nFSize2
                        dDispDate = dDispDate2
                        sLinkTarget = sLinkTarget2
                        sFileName = sFileName2
                    End If
                End If
            Else
                bShowMenu = ShowLink( _
                    CInt(oDataReader("channel_permission")), _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    CBool(oDataReader("is_system")), _
                    CBool(oDataReader("is_hidden")))
            End If

            If bShowMenu Then

                Dim sFileDownloadURL As String = ""
                If Not sFileDownload.ToString = "" Then
                    sFileDownloadURL = "systems/file_download.aspx?pg=" & nPgId & "&ver=" & sVer
                End If

                Dim sFileViewListingURL As String = ""
                Dim sFileViewListingMoreURL As String = ""
                Dim sFileViewURL As String = ""
                If Not sFileViewListing.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1).ToLower
                    If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                        'sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer

                        If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                            'Access using ASPX
                            sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer
                            sFileViewListingMoreURL = "systems/file_view_listing_more.aspx?pg=" & nPgId & "&ver=" & sVer
                        Else
                            'Access file directly
                            'Thumbnail 100px
                            Dim sTmp As String
                            sTmp = sFileViewListing.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                            sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                            sFileViewListingURL = "resources/internal/file_views_listing/" & nPgId & "/" & sTmp
                            sFileViewListingMoreURL = "resources/internal/file_views_listing/" & nPgId & "/" & sFileViewListing
                        End If
                    End If
                End If
                If Not sFileView.ToString = "" Then
                    Dim sExtension As String
                    sExtension = sFileView.Substring(sFileView.LastIndexOf(".") + 1).ToLower

                    'If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                    If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                        'Access using ASPX
                        sFileViewURL = "systems/file_view.aspx?pg=" & nPgId & "&ver=" & sVer
                    Else
                        'Access file directly
                        'Thumbnail 100px
                        Dim sTmp As String
                        sTmp = sFileView.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
                        sTmp = sTmp.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")

                        sFileViewURL = "resources/internal/file_views/" & nPgId & "/" & sFileView
                    End If
                    'End If
                End If

                'If oDataReader("parent_id") = nPageId Then
                Dim dr As DataRow = dt.NewRow()
                dr("page_id") = nPgId

                If sLinkText <> "" Then sTtl = sLinkText
                dr("title") = sTtl

                dr("summary") = sSmry

                dr("file_download_url") = sFileDownloadURL
                dr("file_view_listing_url") = sFileViewListingURL
                dr("file_view_listing_more_url") = sFileViewListingMoreURL
                dr("file_view_url") = sFileViewURL

                dr("file_name") = sFileName
                dr("display_date") = dDispDate
                dr("link_target") = sLinkTarget
                If bBlog Then
                    If sBody.Contains("[break]") Then
                        dr("use_read_more") = True
                    Else
                        dr("use_read_more") = False
                    End If
                    sBody = sBody.Split("[break]")(0) '& "&nbsp;<a href=""" & sFile & """>More</a>"
                Else
                    dr("use_read_more") = False
                End If
                dr("content_body") = sBody
                dr("owner") = oDataReader("owner").ToString

                If IsDBNull(oDataReader("comments")) Then
                    dr("comments") = 0
                Else
                    dr("comments") = oDataReader("comments")
                End If

                dr("last_updated_by") = sLastUpdBy.ToString
                If IsNothing(dLastUpd) Then
                    dr("last_updated_date") = Nothing
                Else
                    dr("last_updated_date") = dLastUpd
                End If
                If Not sFileDownload.ToString = "" Then
                    dr("file_download") = sFileDownload.Substring(sFileDownload.IndexOf("_") + 1)
                Else
                    dr("file_download") = ""
                End If

                If IsNothing(nFSize) Then
                    dr("file_size") = Nothing
                Else
                    dr("file_size") = nFSize
                End If
                If Not IsDBNull(oDataReader("first_published_date")) Then
                    dr("first_published_date") = oDataReader("first_published_date")
                End If
                If IsDBNull(oDataReader("ratings")) Then
                    dr("rating") = 0
                Else
                    dr("rating") = oDataReader("ratings") / oDataReader("total_voters")
                End If
                If IsDBNull(oDataReader("total_downloads")) Then
                    dr("total_downloads") = 0
                Else
                    dr("total_downloads") = oDataReader("total_downloads")
                End If
                If IsDBNull(oDataReader("downloads_today")) Then
                    dr("downloads_today") = 0
                Else
                    dr("downloads_today") = oDataReader("downloads_today")
                End If
                If IsDBNull(oDataReader("total_hits")) Then
                    dr("total_hits") = 0
                Else
                    dr("total_hits") = oDataReader("total_hits")
                End If
                If IsDBNull(oDataReader("hits_today")) Then
                    dr("hits_today") = 0
                Else
                    dr("hits_today") = oDataReader("hits_today")
                End If

                'Always from published or latest
                If IsDBNull(oDataReader("price")) Then
                    dr("price") = 0
                Else
                    dr("price") = oDataReader("price")
                End If
                If IsDBNull(oDataReader("current_price")) Then
                    dr("current_price") = 0
                Else
                    dr("current_price") = oDataReader("current_price")
                End If

                dt.Rows.Add(dr)
                'End If

            End If

        End While

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing


        'Ini dulu dipakai krn ada (misal) sort by current_price (field ini adanya di dataset, tapi tdk ada di table database)
        'Sekarang tdk dipakai krn ada issue kalau limit misal 3 records, seharusnya disorting dulu baru di-limit
        'If Not bManualOrder Then
        'dt.DefaultView.Sort = sSQLSort
        'End If

        Return dt
    End Function

    'Authorize User to Show/Hide a Menu Link
    Public Function ShowLink(ByVal nCPermission As Integer, _
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

    Public Function ShowLink2(ByVal nCPermission As Integer, _
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
                If sRole = "Administrators" Then
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
                'If bIsHdn Then
                '    vRetVal = 0
                'End If
            End If
        ElseIf nCPermission = 3 Then

            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            ElseIf bUserIsSubscriber Then
                'Show Published (Title/Link Text)
                vRetVal = 2
                'If bIsHdn Then
                '    vRetVal = 0
                'End If
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
                If sOwn.ToLower = sUserName.ToLower Or bIsEditor Or bIsPublisher Then
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
                If sLastUpdBy.ToLower = sUserName.ToLower And (sStat.Contains("locked") And Not sStat.Contains("unlocked")) Then
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

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)

        If Not IsNothing(GetUser) Then
            bUserLoggedIn = True
            sUserName = GetUser.UserName
            arrUserRoles = Roles.GetRolesForUser(sUserName)
        End If
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub

End Class


