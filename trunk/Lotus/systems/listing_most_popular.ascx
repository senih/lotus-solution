<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">
    Private nListingPageId As Integer
    Public Property ListingPageId() As Integer
        Get
            Return nListingPageId
        End Get
        Set(ByVal value As Integer)
            nListingPageId = value
        End Set
    End Property
    
    Private nNumRecords As Integer = 10
    Public Property NumRecords() As Integer
        Get
            Return nNumRecords
        End Get
        Set(ByVal value As Integer)
            nNumRecords = value
        End Set
    End Property
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oPds As PagedDataSource = New PagedDataSource
        Dim oContent As Content = New Content
        oContent.SortingBy = "total_hits"
        oContent.SortingType = "DESC"
        Dim nRecordCount As Integer
        oPds.DataSource = oContent.GetPagesWithin2005(nListingPageId, 0, nNumRecords, nRecordCount, 2).DefaultView
        
        dlDataList.RepeatLayout = RepeatLayout.Flow
        dlDataList.GridLines = GridLines.None
        dlDataList.RepeatColumns = 1
        
        dlDataList.DataSource = oPds
        dlDataList.DataBind()
    End Sub
</script>

<asp:DataList ID="dlDataList" Width="100%" runat="server">
<ItemTemplate>
<a href="<%#Eval("file_name")%>" title=""><%#Eval("title")%></a>
</ItemTemplate>
</asp:DataList>

