<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Xml" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nListingTemplateId As Integer
    Private nListingPageSize As Integer
    Private sListingDefaultOrder As String
    Private nListingType As Integer
    Private nListingProperty As Integer
    Private nListingColumns As Integer
    Private sListingTemplateHeader As String
    Private sListingTemplateFooter As String
    Private sListingScript As String
    Private sElements As String
    Private sParentElements As String
    Private sDefaultElements As String = "<root>" & _
        "<title>True</title>" & _
        "<file_view>True</file_view>" & _
        "<file_download>True</file_download>" & _
        "<statistic_info>False</statistic_info>" & _
        "<category_info>False</category_info>" & _
        "<rating>False</rating>" & _
        "<comments>False</comments>" & _
        "<comments_anonymous>False</comments_anonymous>" & _
        "<listing_ordering>False</listing_ordering>" & _
        "<listing_ordering_by_title>False</listing_ordering_by_title>" & _
        "<listing_ordering_by_author>False</listing_ordering_by_author>" & _
        "<listing_ordering_by_person_last_updating>False</listing_ordering_by_person_last_updating>" & _
        "<listing_ordering_by_display_date>False</listing_ordering_by_display_date>" & _
        "<listing_ordering_by_publish_date>False</listing_ordering_by_publish_date>" & _
        "<listing_ordering_by_last_updated_date>False</listing_ordering_by_last_updated_date>" & _
        "<listing_ordering_by_size>False</listing_ordering_by_size>" & _
        "<listing_ordering_by_total_downloads>False</listing_ordering_by_total_downloads>" & _
        "<listing_ordering_by_downloads_today>False</listing_ordering_by_downloads_today>" & _
        "<listing_ordering_by_rating>False</listing_ordering_by_rating>" & _
        "<listing_ordering_by_comments>False</listing_ordering_by_comments>" & _
        "<listing_ordering_by_total_hits>False</listing_ordering_by_total_hits>" & _
        "<listing_ordering_by_hits_today>False</listing_ordering_by_hits_today>" & _
        "<listing_ordering_by_price>False</listing_ordering_by_price>" & _
        "<calendar>True</calendar>" & _
        "<month_list>True</month_list>" & _
        "<category_list>True</category_list>" & _
        "<subscribe>True</subscribe>" & _
        "</root>"
    
    Public Property ListingTemplateId() As Integer
        Get
            Return nListingTemplateId
        End Get
        Set(ByVal value As Integer)
            nListingTemplateId = value
        End Set
    End Property
    
    Public Property ListingColumns() As Integer
        Get
            Return nListingColumns
        End Get
        Set(ByVal value As Integer)
            nListingColumns = value
        End Set
    End Property
    
    Public Property ListingPageSize() As Integer
        Get
            Return nListingPageSize
        End Get
        Set(ByVal value As Integer)
            nListingPageSize = value
        End Set
    End Property
    
    Public Property ListingType() As Integer
        Get
            Return nListingType
        End Get
        Set(ByVal value As Integer)
            nListingType = value
        End Set
    End Property
    
    Public Property ListingProperty() As Integer
        Get
            Return nListingProperty
        End Get
        Set(ByVal value As Integer)
            nListingProperty = value
        End Set
    End Property
    
    Public Property ListingDefaultOrder() As String
        Get
            Return sListingDefaultOrder
        End Get
        Set(ByVal value As String)
            sListingDefaultOrder = value
        End Set
    End Property

    Public Property ListingTemplateHeader() As String
        Get
            Return sListingTemplateHeader
        End Get
        Set(ByVal value As String)
            sListingTemplateHeader = value
        End Set
    End Property
    
    Public Property ListingTemplateFooter() As String
        Get
            Return sListingTemplateFooter
        End Get
        Set(ByVal value As String)
            sListingTemplateFooter = value
        End Set
    End Property
    
    Public Property ListingScript() As String
        Get
            Return sListingScript
        End Get
        Set(ByVal value As String)
            sListingScript = value
        End Set
    End Property

    Public Property Elements() As String
        Get
            Return sElements
        End Get
        Set(ByVal value As String)
            sElements = value
        End Set
    End Property
    
    Public Property ParentElements() As String
        Get
            Return sParentElements
        End Get
        Set(ByVal value As String)
            sParentElements = value
        End Set
    End Property
    
    Protected Sub ShowListing()
        If Not ConfigurationManager.AppSettings("SQLOptimize") = "yes" Then
            ShowListing_()
            Exit Sub
        End If
        
        Dim nPageIndex As Integer
        nPageIndex = hidPageIndex.Value
        
        If sElements = "" Then
            sElements = sDefaultElements
        End If
        Dim oXML As XmlDocument = New XmlDocument
        oXML.LoadXml(sElements)

        If sParentElements = "" Then
            sParentElements = sDefaultElements
        End If
        Dim oXMLParent As XmlDocument = New XmlDocument
        oXMLParent.LoadXml(sParentElements)
        
        '*** LISTING ORDERING DROPDOWN ***
        If Not CBool(oXML.DocumentElement.Item("listing_ordering").InnerText) Then
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        'bIsListing And
        If nListingType = 1 And (nListingProperty = 1 Or nListingProperty = 3) Then 'Order By sorting
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_title").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("title"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_author").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("owner"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_person_last_updating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_by"))
        End If
        If Not IsNothing(oXML.GetElementsByTagName("listing_ordering_by_display_date")(0)) Then
            If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_display_date").InnerText) Then
                dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("display_date"))
            End If
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_publish_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("first_published_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_last_updated_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_rating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("rating"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_comments").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("comments"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_size").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("file_size"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_downloads").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_downloads"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_downloads_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("downloads_today"))
        End If

        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_hits").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_hits"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_hits_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("hits_today"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_price").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("current_price"))
        End If
        
        'sListingScript = "<scr" & "ipt type=""text/javascript"" src=""[%APP_PATH%]systems/media/swfobject.js""></scr" & "ipt>" & vbCrLf & _
        '    "<p id=""[%UNIQUE_ID%]""><a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player.</p>" & vbCrLf & _
        '    "<script type=""text/javascript"">" & vbCrLf & _
        '    "var s3 = new SWFObject(""[%APP_PATH%]systems/media/mediaplayer.swf"", ""playlist"", ""300"", ""312"", ""7"");" & vbCrLf & _
        '    "s3.addVariable(""file"",""[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]"");" & vbCrLf & _
        '    "s3.addVariable(""allowfullscreen"",""true"");" & vbCrLf & _
        '    "s3.addVariable(""backcolor"",""0x00000"");" & vbCrLf & _
        '    "s3.addVariable(""frontcolor"",""0xD9CFE7"");" & vbCrLf & _
        '    "s3.addVariable(""lightcolor"",""0xB5A0D3"");" & vbCrLf & _
        '    "s3.addVariable(""linktarget"",""_self"");" & vbCrLf & _
        '    "s3.addVariable(""width"",""300"");" & vbCrLf & _
        '    "s3.addVariable(""height"",""312"");" & vbCrLf & _
        '    "s3.addVariable(""displayheight"",""200"");" & vbCrLf & _
        '    "s3.write(""[%UNIQUE_ID%]"");" & vbCrLf & _
        '    "</scr" & "ipt>"
        sListingScript = sListingScript.Replace("[%APP_PATH%]", Me.AppPath)
        sListingScript = sListingScript.Replace("[%UNIQUE_ID%]", litScript.ClientID & "abc")
        sListingScript = sListingScript.Replace("[%PAGE_ID%]", Me.PageID)
        litScript.Text = sListingScript
        
        Dim oPds As PagedDataSource = New PagedDataSource
        Dim oContent As Content = New Content
        oContent.TimeOffset = Me.TimeOffset

        Dim nRecordCount As Integer

        If nListingType = 1 Then
            'General
        Else
            'News (Calendar-based)
            sListingDefaultOrder = "display_date"
        End If

        If Not Page.IsPostBack Then
            If Not sListingDefaultOrder = "" Then
                dropListingOrdering.SelectedValue = sListingDefaultOrder
            End If
        End If

        Dim sSortType As String = "DESC"
        
        If Not Page.IsPostBack Then
            'First load berdasarkan default order
            If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                sSortType = "ASC"
            End If
            oContent.SortingBy = sListingDefaultOrder
            oContent.SortingType = sSortType
        Else
            If dropListingOrdering.Visible = True Then
                'Postback dari dropdown atau paging
                If dropListingOrdering.SelectedValue = "title" Or dropListingOrdering.SelectedValue = "last_updated_by" Or dropListingOrdering.SelectedValue = "owner" Then
                    sSortType = "ASC"
                End If
                oContent.SortingBy = dropListingOrdering.SelectedValue
                oContent.SortingType = sSortType
            Else
                'Postback dari paging
                If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                    sSortType = "ASC"
                End If
                oContent.SortingBy = sListingDefaultOrder
                oContent.SortingType = sSortType
            End If
        End If
        
        If nListingProperty = 1 Or nListingProperty = 3 Then
            oContent.ManualOrder = True
        End If
        
        Dim bNoSelection As Boolean = False
        Dim nYear As Integer
        Dim nMonth As Integer
        Dim nDay As Integer
        If Not IsNothing(Request.QueryString("d")) Then
            nYear = Request.QueryString("d").Split("-")(0)
            nMonth = Request.QueryString("d").Split("-")(1)
            If Request.QueryString("d").Split("-").Length = 3 Then
                'Date Selection
                nDay = Request.QueryString("d").Split("-")(2)
                oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 3, New Date(nYear, nMonth, nDay)).DefaultView
            Else
                'Month Selection
                oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 5, , nYear, nMonth).DefaultView
            End If
        ElseIf Not IsNothing(Request.QueryString("w")) Then
            'Week Selection
            nYear = Request.QueryString("w").Split("-")(0)
            nMonth = Request.QueryString("w").Split("-")(1)
            nDay = Request.QueryString("w").Split("-")(2)
            oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 6, New Date(nYear, nMonth, nDay)).DefaultView
        ElseIf Not IsNothing(Request.QueryString("cat")) Then
            'Category Selection
            oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 7, , , , Request.QueryString("cat")).DefaultView
        Else
            'No Selection
            bNoSelection = True

            nYear = Now.Year
            nMonth = Now.Month
            If nListingType = 1 Then
                'General Listing
                oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 1).DefaultView
            Else
                'News/Journal
                oPds.DataSource = oContent.GetPagesWithin2005(Me.PageID, nPageIndex, nListingPageSize, nRecordCount, 2).DefaultView
            End If
        End If
       
        'Formatting
        panelDataList.Visible = True
        dlDataList.RepeatDirection = RepeatDirection.Horizontal
        dlDataList.ItemStyle.VerticalAlign = VerticalAlign.Top
        dlDataList.CellPadding = 0
        dlDataList.CellSpacing = 0
        dlDataList.GridLines = GridLines.None
        dlDataList.RepeatColumns = nListingColumns
        If nListingColumns = 1 Then
            dlDataList.RepeatLayout = RepeatLayout.Flow
        Else
            dlDataList.RepeatLayout = RepeatLayout.Table
        End If

        litDataListHeader.Text = sListingTemplateHeader
        litDataListFooter.Text = sListingTemplateFooter

        dlDataList.ItemTemplate = New TemplateListing(ListItemType.Item, nListingTemplateId, Me.RootID, Me.IsReader, Me.TimeOffset)

        oPds.AllowPaging = False

        Dim nPageCount As Integer = nRecordCount / nListingPageSize
        nPageCount = Math.Round((nRecordCount / nListingPageSize) + 0.4999)

        lblDataListPagingInfo.Text = GetLocalResourceObject("PAGE") & " " & (nPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & nPageCount
        lblDataListPagingInfo2.Text = GetLocalResourceObject("PAGE") & " " & (nPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & nPageCount

        If nPageIndex = 0 Then
            pgDataListFirst.Enabled = False
            pgDataListPrevious.Enabled = False
            pgDataListFirst2.Enabled = False
            pgDataListPrevious2.Enabled = False
        Else
            pgDataListFirst.Enabled = True
            pgDataListPrevious.Enabled = True
            pgDataListFirst2.Enabled = True
            pgDataListPrevious2.Enabled = True
        End If
        If nPageIndex = nPageCount - 1 Then
            pgDataListLast.Enabled = False
            pgDataListNext.Enabled = False
            pgDataListLast2.Enabled = False
            pgDataListNext2.Enabled = False
        Else
            pgDataListLast.Enabled = True
            pgDataListNext.Enabled = True
            pgDataListLast2.Enabled = True
            pgDataListNext2.Enabled = True
        End If

        dlDataList.DataSource = oPds
        dlDataList.DataBind()

        hidPageCount.Value = nPageCount
        'hidPageIndex.Value = nPageIndex

        If nRecordCount = 0 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        If nPageCount < 2 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        oContent = Nothing
        oPds = Nothing
        
        If dlDataList.Items.Count = 0 Then
            panelDataList.Visible = False
            If Me.IsAuthor Or Me.IsAdministrator Then
                idListingEmpty.Visible = True
            End If
        End If
    End Sub
    
    Protected Sub ShowListing_()
        Dim nPageIndex As Integer
        nPageIndex = hidPageIndex.Value
        
        If sElements = "" Then
            sElements = sDefaultElements
        End If
        Dim oXML As XmlDocument = New XmlDocument
        oXML.LoadXml(sElements)

        If sParentElements = "" Then
            sParentElements = sDefaultElements
        End If
        Dim oXMLParent As XmlDocument = New XmlDocument
        oXMLParent.LoadXml(sParentElements)
        
        '*** LISTING ORDERING DROPDOWN ***
        If Not CBool(oXML.DocumentElement.Item("listing_ordering").InnerText) Then
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        'bIsListing And
        If nListingType = 1 And (nListingProperty = 1 Or nListingProperty = 3) Then 'Order By sorting
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_title").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("title"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_author").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("owner"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_person_last_updating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_by"))
        End If
        If Not IsNothing(oXML.GetElementsByTagName("listing_ordering_by_display_date")(0)) Then
            If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_display_date").InnerText) Then
                dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("display_date"))
            End If
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_publish_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("first_published_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_last_updated_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_rating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("rating"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_comments").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("comments"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_size").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("file_size"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_downloads").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_downloads"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_downloads_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("downloads_today"))
        End If

        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_hits").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_hits"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_hits_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("hits_today"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_price").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("current_price"))
        End If
        
        sListingScript = sListingScript.Replace("[%APP_PATH%]", Me.AppPath)
        sListingScript = sListingScript.Replace("[%UNIQUE_ID%]", litScript.ClientID & "abc")
        sListingScript = sListingScript.Replace("[%PAGE_ID%]", Me.PageID)
        litScript.Text = sListingScript
        
        Dim oPds As PagedDataSource = New PagedDataSource
        Dim oContent As Content = New Content
        oContent.TimeOffset = Me.TimeOffset

        If nListingType = 1 Then
            'General
        Else
            'News (Calendar-based)
            sListingDefaultOrder = "display_date"
        End If

        If Not Page.IsPostBack Then
            If Not sListingDefaultOrder = "" Then
                dropListingOrdering.SelectedValue = sListingDefaultOrder
            End If
        End If

        Dim sSortType As String = "DESC"

        If Not Page.IsPostBack Then
            'First load berdasarkan default order
            If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                sSortType = "ASC"
            End If
            oContent.SortingBy = sListingDefaultOrder
            oContent.SortingType = sSortType
        Else
            If dropListingOrdering.Visible = True Then
                'Postback dari dropdown atau paging
                If dropListingOrdering.SelectedValue = "title" Or dropListingOrdering.SelectedValue = "last_updated_by" Or dropListingOrdering.SelectedValue = "owner" Then
                    sSortType = "ASC"
                End If
                oContent.SortingBy = dropListingOrdering.SelectedValue
                oContent.SortingType = sSortType
            Else
                'Postback dari paging
                If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                    sSortType = "ASC"
                End If
                oContent.SortingBy = sListingDefaultOrder
                oContent.SortingType = sSortType
            End If

        End If

        If nListingProperty = 1 Or nListingProperty = 3 Then
            oContent.ManualOrder = True
        End If

        Dim bNoSelection As Boolean = False
        Dim nYear As Integer
        Dim nMonth As Integer
        Dim nDay As Integer
        If Not IsNothing(Request.QueryString("d")) Then
            nYear = Request.QueryString("d").Split("-")(0)
            nMonth = Request.QueryString("d").Split("-")(1)
            If Request.QueryString("d").Split("-").Length = 3 Then
                'Date Selection
                nDay = Request.QueryString("d").Split("-")(2)
                oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 0, 3, New Date(nYear, nMonth, nDay), False).DefaultView 'Get all posts on the specified date.
            Else
                'Month Selection
                oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 0, 5, Nothing, False, nYear, nMonth).DefaultView 'Get all posts on the specified month.
            End If
        ElseIf Not IsNothing(Request.QueryString("w")) Then
            'Week Selection
            nYear = Request.QueryString("w").Split("-")(0)
            nMonth = Request.QueryString("w").Split("-")(1)
            nDay = Request.QueryString("w").Split("-")(2)
            oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 0, 6, New Date(nYear, nMonth, nDay), False).DefaultView 'Get all posts on the specified week.
        ElseIf Not IsNothing(Request.QueryString("cat")) Then
            'Get latest posts on the specified category.
            oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 0, 7, , , , , Request.QueryString("cat")).DefaultView
        Else
            'No Selection
            bNoSelection = True

            nYear = Now.Year
            nMonth = Now.Month
            If nListingType = 1 Then
                'General Listing
                oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 0, 1, Nothing, False).DefaultView 'Get all posts
            Else
                'News/Journal
                oPds.DataSource = oContent.GetPagesWithin(Me.PageID, 500, 2, Nothing, False).DefaultView 'Get 500 latest posts
            End If

        End If

        'Formatting
        panelDataList.Visible = True
        dlDataList.RepeatDirection = RepeatDirection.Horizontal
        dlDataList.ItemStyle.VerticalAlign = VerticalAlign.Top
        dlDataList.CellPadding = 0
        dlDataList.CellSpacing = 0
        dlDataList.GridLines = GridLines.None
        dlDataList.RepeatColumns = nListingColumns
        If nListingColumns = 1 Then
            dlDataList.RepeatLayout = RepeatLayout.Flow
        Else
            dlDataList.RepeatLayout = RepeatLayout.Table
        End If

        litDataListHeader.Text = sListingTemplateHeader
        litDataListFooter.Text = sListingTemplateFooter

        dlDataList.ItemTemplate = New TemplateListing(ListItemType.Item, nListingTemplateId, Me.RootID, Me.IsReader, Me.TimeOffset)

        oPds.AllowPaging = True
        oPds.PageSize = nListingPageSize
        oPds.CurrentPageIndex = nPageIndex
        lblDataListPagingInfo.Text = GetLocalResourceObject("PAGE") & " " & (oPds.CurrentPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & oPds.PageCount
        lblDataListPagingInfo2.Text = GetLocalResourceObject("PAGE") & " " & (oPds.CurrentPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & oPds.PageCount
        If oPds.IsFirstPage Then
            pgDataListFirst.Enabled = False
            pgDataListPrevious.Enabled = False
            pgDataListFirst2.Enabled = False
            pgDataListPrevious2.Enabled = False
        Else
            pgDataListFirst.Enabled = True
            pgDataListPrevious.Enabled = True
            pgDataListFirst2.Enabled = True
            pgDataListPrevious2.Enabled = True
        End If
        If oPds.IsLastPage Then
            pgDataListLast.Enabled = False
            pgDataListNext.Enabled = False
            pgDataListLast2.Enabled = False
            pgDataListNext2.Enabled = False
        Else
            pgDataListLast.Enabled = True
            pgDataListNext.Enabled = True
            pgDataListLast2.Enabled = True
            pgDataListNext2.Enabled = True
        End If

        dlDataList.DataSource = oPds
        dlDataList.DataBind()

        hidPageCount.Value = oPds.PageCount
        hidPageIndex.Value = oPds.CurrentPageIndex

        If oPds.Count = 0 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        If oPds.PageCount < 2 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        oContent = Nothing
        oPds = Nothing
        
        If dlDataList.Items.Count = 0 Then
            panelDataList.Visible = False
            If Me.IsAuthor Or Me.IsAdministrator Then
                idListingEmpty.Visible = True
            End If
        End If
    End Sub
    
    Protected Sub pgDataListFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListFirst.Click
        hidPageIndex.Value = 0
        'ShowListing()
    End Sub
    Protected Sub pgDataListLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListLast.Click
        hidPageIndex.Value = hidPageCount.Value - 1
        'ShowListing()
    End Sub
    Protected Sub pgDataListNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListNext.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) + 1
        'ShowListing()
    End Sub
    Protected Sub pgDataListPrevious_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListPrevious.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) - 1
        'ShowListing()
    End Sub
    Protected Sub pgDataListFirst2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListFirst2.Click
        hidPageIndex.Value = 0
        'ShowListing()
    End Sub
    Protected Sub pgDataListLast2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListLast2.Click
        hidPageIndex.Value = hidPageCount.Value - 1
        'ShowListing()
    End Sub
    Protected Sub pgDataListNext2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListNext2.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) + 1
        'ShowListing()
    End Sub
    Protected Sub pgDataListPrevious2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListPrevious2.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) - 1
        'ShowListing()
    End Sub

    Protected Sub dropListingOrdering_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dropListingOrdering.SelectedIndexChanged
        'ShowListing()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        ShowListing()
    End Sub
</script>
<%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
<asp:UpdateProgress ID="UpdateProgress1" AssociatedUpdatePanelID="UpdatePanel1"  runat="server">
    <ProgressTemplate>
        <div class="icProgBg" style="padding-top:150px;text-align:center;z-index:2000;background-color:#333333;opacity:0.30;filter:alpha(opacity=30)">
        <img src="systems/images/animated_progress.gif" alt="" />
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>  --%>
    
<asp:Literal id="litScript" runat="server"></asp:Literal>
<asp:Panel ID="panelDataList" runat="server" visible="False">

<table id="idDataListHeaderContainer" summary="" runat="server" cellpadding="0" cellspacing="0" style="width:100%">
<tr>
<td style="width:100%">
    <div id="idDataListHeader" runat="server" class="paging">
    <asp:LinkButton ID="pgDataListFirst" meta:resourcekey="pgDataListFirst" runat="server">First</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListPrevious" meta:resourcekey="pgDataListPrevious" runat="server">Prev</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:Label ID="lblDataListPagingInfo" font-bold="true" runat="server" Text=""></asp:Label> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListNext" meta:resourcekey="pgDataListNext" runat="server">Next</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListLast" meta:resourcekey="pgDataListLast" runat="server">Last</asp:LinkButton>
    </div>          
</td>
<td style="white-space:nowrap;padding-top:3px;font-size:9px"><asp:Literal ID="litOrderBy" Text="Order By:" runat="server"></asp:Literal>&nbsp;</td>
<td style="text-align:right;padding-top:5px;">
    <asp:DropDownList ID="dropListingOrdering" AutoPostBack="True" OnSelectedIndexChanged="dropListingOrdering_SelectedIndexChanged" runat="server">
    <asp:ListItem meta:resourcekey="optTitle" Value="title" Text="Title"></asp:ListItem>
    <asp:ListItem meta:resourcekey="optAuthor" Value="owner" Text="Author"></asp:ListItem>                                
    <asp:ListItem meta:resourcekey="optPersonLastUpdating" Value="last_updated_by" Text="Person Last Updating"></asp:ListItem>
    <asp:ListItem meta:resourcekey="optDisplayDate" Value="display_date" Text="Display Date"></asp:ListItem>            
    <asp:ListItem meta:resourcekey="optPublishDate" Value="first_published_date" Text="Publish Date"></asp:ListItem>            
    <asp:ListItem meta:resourcekey="optLastUpdatedDate" Value="last_updated_date" Text="Last Updated Date"></asp:ListItem>
    <asp:ListItem meta:resourcekey="optRating" Value="rating" Text="Rating"></asp:ListItem>     
    <asp:ListItem meta:resourcekey="optComments" Value="comments" Text="Comments"></asp:ListItem>  
    <asp:ListItem meta:resourcekey="optDownloadSize" Value="file_size" Text="Download Size"></asp:ListItem>         
    <asp:ListItem meta:resourcekey="optTotalDownloads" Value="total_downloads" Text="Total Downloads"></asp:ListItem> 
    <asp:ListItem meta:resourcekey="optDownloadsToday" Value="downloads_today" Text="Downloads Today"></asp:ListItem>  
    <asp:ListItem meta:resourcekey="optTotalHits" Value="total_hits" Text="Total Hits"></asp:ListItem>
    <asp:ListItem meta:resourcekey="optHitsToday" Value="hits_today" Text="Hits Today"></asp:ListItem>
    <asp:ListItem meta:resourcekey="optPrice" Value="current_price" Text="Price"></asp:ListItem>
    </asp:DropDownList>        
</td>
</tr>
</table>      
 
<div style="margin-top:15px;margin-bottom:15px">
    <asp:Literal id="litDataListHeader" runat="server"></asp:Literal>
    <asp:DataList ID="dlDataList" Width="100%" runat="server"></asp:DataList>
    <asp:Literal id="litDataListFooter" runat="server"></asp:Literal>
</div>  

<asp:HiddenField ID="hidPageIndex" Value="0" runat="server"></asp:HiddenField>
<asp:HiddenField ID="hidPageCount" runat="server"></asp:HiddenField>      

<div id="idDataListFooter" runat="server" class="paging">
    <asp:LinkButton ID="pgDataListFirst2" meta:resourcekey="pgDataListFirst" runat="server">First</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListPrevious2" meta:resourcekey="pgDataListPrevious" runat="server">Prev</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:Label id="lblDataListPagingInfo2" font-bold="true" runat="server" Text=""></asp:Label> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListNext2" meta:resourcekey="pgDataListNext" runat="server">Next</asp:LinkButton> <span style="color:#ACA899">|</span>
    <asp:LinkButton ID="pgDataListLast2" meta:resourcekey="pgDataListLast" runat="server">Last</asp:LinkButton>
</div>

</asp:Panel>  

<div id="idListingEmpty" runat="server" visible="false" style="padding:4px;padding-top:0px;background:url('systems/images/bg_box3.gif') #F8F9F9;border:#e0e0e0 3px solid;text-align:center;font-size:10px">
    <div style="text-transform:uppercase;font-family:arial;font-weight:bold;font-size:12px;margin:3px"><asp:Literal id="litListingEmpty" meta:resourcekey="litListingEmpty" runat="server"></asp:Literal></div>
    <asp:Literal id="litClickAddNewLink" meta:resourcekey="litClickAddNewLink" runat="server">Click <b>Add New</b> link to add a new entry (page).</asp:Literal>
</div>
    
<%--</ContentTemplate>    
</asp:UpdatePanel>--%>