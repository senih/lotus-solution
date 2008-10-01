<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
        
    Private sTitle As String = ""
    Private sLinkMore As String = ""
    Private nColumns As Integer
    Private nRecords As Integer
    Private nListingTemplateId As Integer
    Private bUseCustomEntries As Boolean
    Private nParentId As Integer
    Private sListingDefaultOrder As String
    Private sSortType As String
    
    Private sListingTemplateName As String = ""
    Private sListingTemplateItem As String = ""
    Private sListingTemplateHeader As String = ""
    Private sListingTemplateFooter As String = ""
    Private sListingScript As String = ""
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)      
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM custom_listings WHERE custom_listing_id=@custom_listing_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = Me.ModuleData
        oDataReader = oCmd.ExecuteReader
        While oDataReader.Read
            sTitle = HttpUtility.HtmlEncode(oDataReader("title").ToString())
            nListingTemplateId = oDataReader("listing_template_id").ToString()
            bUseCustomEntries = Convert.ToBoolean(oDataReader("use_custom_entries"))
            If Not IsDBNull(oDataReader("parent_id")) Then
                nParentId = oDataReader("parent_id")
            End If
        End While
        oDataReader.Close()
        
        oCmd = New SqlCommand("SELECT * FROM listing_templates WHERE id=@id")
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = nListingTemplateId
        oCmd.Connection = oConn
        oDataReader = oCmd.ExecuteReader()
        While oDataReader.Read()
            sListingTemplateName = oDataReader("template_name").ToString()
            sListingTemplateItem = oDataReader("template").ToString()
            sListingTemplateHeader = oDataReader("template_header").ToString()
            sListingTemplateFooter = oDataReader("template_footer").ToString()
            sListingScript = oDataReader("listing_script").ToString
            nColumns = oDataReader("listing_columns").ToString()
            nRecords = oDataReader("listing_page_size").ToString()
        End While
        oDataReader.Close()
        
        oCmd.Dispose()
        oConn.Close()
        
        Dim oContent As Content = New Content
        
        If Not bUseCustomEntries Then
            Dim dt As DataTable
            dt = oContent.GetPage(nParentId, True)
            If dt.Rows.Count > 0 Then
                If sTitle = "" Then
                    sTitle = dt.Rows(0).Item("title").ToString()
                End If
                sListingDefaultOrder = dt.Rows(0).Item("listing_default_order").ToString()
                If Convert.ToBoolean(dt.Rows(0).Item("is_listing")) Then
                    Dim nListingType As Integer = dt.Rows(0).Item("listing_type")
                    sSortType = "DESC"
                    If nListingType = 1 Then
                        'General    
                        If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                            sSortType = "ASC"
                        End If
                        oContent.SortingBy = sListingDefaultOrder
                        oContent.SortingType = sSortType
                        
                        Dim nListingProperty As Integer = dt.Rows(0).Item("listing_property")
                        If nListingProperty = 1 Or nListingProperty = 3 Then
                            oContent.ManualOrder = True
                        End If
                    Else
                        'Calendar-based
                        oContent.SortingBy = "display_date"
                        oContent.SortingType = "DESC"
                    End If
                Else
                    oContent.ManualOrder = True
                End If

                Dim sAppPath As String = HttpContext.Current.Request.ApplicationPath
                If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"
                
                sLinkMore = sAppPath & dt.Rows(0).Item("file_name").ToString()
            Else
                divBox.Visible = False
                oContent = Nothing
                Exit Sub
            End If
        End If
        
        sListingTemplateHeader = sListingTemplateHeader.Replace("[%TITLE%]", sTitle)
        sListingTemplateHeader = sListingTemplateHeader.Replace("[%READ_MORE%]", sLinkMore)
        litListingHeader.Text = sListingTemplateHeader
        sListingTemplateFooter = sListingTemplateFooter.Replace("[%TITLE%]", sTitle)
        sListingTemplateFooter = sListingTemplateFooter.Replace("[%READ_MORE%]", sLinkMore)
        litListingFooter.Text = sListingTemplateFooter
       
        If bUseCustomEntries Then
            dlListing.RepeatDirection = RepeatDirection.Horizontal
            dlListing.ItemStyle.VerticalAlign = VerticalAlign.Top
            dlListing.RepeatColumns = nColumns
            dlListing.HeaderTemplate = New TemplateListing(ListItemType.Header, nListingTemplateId, Me.RootID, Me.IsReader)
            dlListing.ItemTemplate = New TemplateListing(ListItemType.Item, nListingTemplateId, Me.RootID, Me.IsReader)
            dlListing.FooterTemplate = New TemplateListing(ListItemType.Footer, nListingTemplateId, Me.RootID, Me.IsReader)
            
            dlListing.DataSource = GetListingItems().DefaultView
            dlListing.DataBind()
            
            If dlListing.Items.Count = 0 Then
                divBox.Visible = False
            End If
            
        Else
            dlListing2.RepeatDirection = RepeatDirection.Horizontal
            dlListing2.ItemStyle.VerticalAlign = VerticalAlign.Top
            dlListing2.RepeatColumns = nColumns
            dlListing2.HeaderTemplate = New TemplateListing(ListItemType.Header, nListingTemplateId, Me.RootID, Me.IsReader)
            dlListing2.ItemTemplate = New TemplateListing(ListItemType.Item, nListingTemplateId, Me.RootID, Me.IsReader)
            dlListing2.FooterTemplate = New TemplateListing(ListItemType.Footer, nListingTemplateId, Me.RootID, Me.IsReader)

            dlListing2.DataSource = oContent.GetPagesWithin(nParentId, nRecords, 2)
            dlListing2.DataBind()
            
            If dlListing2.Items.Count = 0 Then
                divBox.Visible = False
            End If
        End If
        
        litListingScript.Text = sListingScript
        
        oContent = Nothing
    End Sub
    
    Function GetListingItems() As DataTable
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
        dt.Columns.Add(New DataColumn("custom_listing_item_id", GetType(Integer)))
        dt.Columns.Add(New DataColumn("file_view_listing_more_url", GetType(String)))
        
        dt.Columns.Add(New DataColumn("file_view_url", GetType(String)))
        
        Dim sSQL As String = "SELECT TOP " & nRecords & " custom_listing_items.custom_listing_item_id, custom_listing_items.custom_listing_id, pages_published.page_id, pages_published.version, pages_published.title, pages_published.summary, " & _            "pages_published.file_name, pages_published.link_target, pages_published.display_date, pages_published.owner,  " & _
            "pages_published.file_view, pages_published.file_attachment, pages_published.file_size, pages_published.file_view_listing, pages_published.price,  " & _
            "pages_published.sale_price, pages_published.discount_percentage, pages_published.last_updated_date,  " & _
            "pages_published.last_updated_by, pages_published.first_published_date, pages_published.channel_permission, pages_comments_count.comments, pages_views_count.total, pages_views_count_daily_.count, pages_downloads_count.total_downloads, pages_downloads_count_daily_.downloads_today,pages_ratings_count.ratings, pages_ratings_count.total_voters  " & _
            "FROM pages_published " & _
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
            "INNER JOIN " & _
            "custom_listing_items ON pages_published.page_id = custom_listing_items.page_id " & _
            "WHERE custom_listing_items.custom_listing_id = @custom_listing_id order by custom_listing_items.impression_date"
        
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        'oCommand.Parameters.Add("@records", SqlDbType.Int).Value = nRecords
        oCommand.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = Me.ModuleData
        oCommand.Parameters.Add("@now", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        While oDataReader.Read()
            
            If oDataReader("channel_permission") = 1 Then

                Dim dr As DataRow = dt.NewRow()
            
                dr("custom_listing_item_id") = oDataReader("custom_listing_item_id")
            
                Dim nPgId As Integer
                nPgId = oDataReader("page_id")
                dr("page_id") = nPgId
            
                Dim nVer As Integer
                nVer = oDataReader("version")

                dr("title") = HttpUtility.HtmlEncode(oDataReader("title").ToString())
                dr("summary") = oDataReader("summary").ToString()
                dr("file_name") = oDataReader("file_name").ToString()
                dr("display_date") = oDataReader("display_date")
                dr("link_target") = oDataReader("link_target")

                Dim sFileDownload As String
                sFileDownload = oDataReader("file_attachment").ToString()
                If Not sFileDownload.ToString = "" Then
                    dr("file_download") = sFileDownload.Substring(sFileDownload.IndexOf("_") + 1)
                Else
                    dr("file_download") = ""
                End If
                
                Dim sFileDownloadURL As String = ""
                If Not sFileDownload.ToString() = "" Then
                    sFileDownloadURL = "systems/file_download.aspx?pg=" & nPgId & "&ver=" & nVer
                End If
                dr("file_download_url") = sFileDownloadURL

                Dim sFileViewListing As String
                sFileViewListing = oDataReader("file_view_listing").ToString()
                
                Dim sFileViewListingURL As String = ""
                Dim sFileViewListingMoreURL As String = ""
                If Not sFileViewListing.ToString() = "" Then
                    Dim sExtension As String
                    sExtension = sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1).ToLower
                    If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                        'sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & sVer

                        If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                            'Access using ASPX
                            sFileViewListingURL = "systems/file_view_listing.aspx?pg=" & nPgId & "&ver=" & nVer
                            sFileViewListingMoreURL = "systems/file_view_listing_more.aspx?pg=" & nPgId & "&ver=" & nVer
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
                dr("file_view_listing_url") = sFileViewListingURL
                dr("file_view_listing_more_url") = sFileViewListingMoreURL
                
                Dim sFileView As String
                sFileView = oDataReader("file_view").ToString()
                
                Dim sFileViewURL As String = ""
                If Not sFileView.ToString() = "" Then
                    Dim sExtension As String
                    sExtension = sFileView.Substring(sFileView.LastIndexOf(".") + 1).ToLower
                    'If sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                    If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                        'Access using ASPX
                        sFileViewURL = "systems/file_view.aspx?pg=" & nPgId & "&ver=" & nVer
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
                dr("file_view_url") = sFileViewURL
                        
                If IsDBNull(oDataReader("file_size")) Then
                    dr("file_size") = Nothing
                Else
                    dr("file_size") = oDataReader("file_size")
                End If
                
                dr("owner") = oDataReader("owner").ToString()
                dr("last_updated_by") = oDataReader("last_updated_by").ToString()
                If IsDBNull(oDataReader("last_updated_date")) Then
                    dr("last_updated_date") = Nothing
                Else
                    dr("last_updated_date") = oDataReader("last_updated_date")
                End If

                Dim nPrice As Decimal
                Dim nSalePrice As Decimal
                Dim nDiscPercentage As Integer

                If IsDBNull(oDataReader("price")) Then
                    nPrice = 0
                Else
                    nPrice = oDataReader("price")
                End If
                If IsDBNull(oDataReader("sale_price")) Then
                    nSalePrice = 0
                Else
                    nSalePrice = oDataReader("sale_price")
                End If
                If IsDBNull(oDataReader("discount_percentage")) Then
                    nDiscPercentage = 0
                Else
                    nDiscPercentage = oDataReader("discount_percentage")
                End If

                dr("price") = nPrice
                dr("current_price") = GetPromoPrice(nPrice, nSalePrice, nDiscPercentage)
            
                If IsDBNull(oDataReader("comments")) Then
                    dr("comments") = 0
                Else
                    dr("comments") = oDataReader("comments")
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
                If IsDBNull(oDataReader("total")) Then
                    dr("total_hits") = 0
                Else
                    dr("total_hits") = oDataReader("total")
                End If
                If IsDBNull(oDataReader("count")) Then
                    dr("hits_today") = 0
                Else
                    dr("hits_today") = oDataReader("count")
                End If
            
                If Not IsDBNull(oDataReader("first_published_date")) Then
                    dr("first_published_date") = oDataReader("first_published_date")
                End If

                dt.Rows.Add(dr)
            End If
        End While
        
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
        
        Return dt
    End Function
    
    Function GetPromoPrice(ByVal price As Decimal, ByVal sale_price As Decimal, ByVal discount_percentage As Integer) As Decimal
        If sale_price > 0 Then
            Return sale_price
        ElseIf discount_percentage > 0 Then
            Return price - (price * (discount_percentage / 100))
        Else
            Return price
        End If
    End Function

    Protected Sub dlListing_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not bUseCustomEntries Then
            Exit Sub
        End If
        ' menampilkan yang teratas
        If dlListing.Items.Count > 0 Then
            Dim i As Integer
            Dim sqlCmd As SqlCommand = New SqlCommand
            sqlCmd.Connection = oConn
            oConn.Open()

            'ada limit impresions
            'sqlCmd.CommandText = "update products set impressions=impressions -1,impressions_date=getdate() WHERE product_id = @product_id "

            'tidak ada limit impressions
            sqlCmd.CommandText = "update custom_listing_items set impression_date=getdate() WHERE custom_listing_item_id = @custom_listing_item_id "
            sqlCmd.CommandType = CommandType.Text
            sqlCmd.Parameters.Add("@custom_listing_item_id", SqlDbType.Int)
        
            For i = 0 To dlListing.Items.Count - 1
                sqlCmd.Parameters.Item("@custom_listing_item_id").Value = dlListing.DataKeys(i)
                sqlCmd.ExecuteNonQuery()
                sqlCmd.Dispose()
            Next
            oConn.Close()
        End If
    End Sub
</script>

<asp:Literal ID="litListingScript" runat="server"></asp:Literal>
<div id="divBox" runat="server">
    <asp:Literal id="litListingHeader" runat="server"></asp:Literal>
    <asp:DataList ID="dlListing" Width="100%" DataKeyField="custom_listing_item_id" runat="server" OnPreRender="dlListing_PreRender">
    </asp:DataList>
    <asp:DataList ID="dlListing2" Width="100%" runat="server">
    </asp:DataList>
    <asp:Literal id="litListingFooter" runat="server"></asp:Literal>
</div>


