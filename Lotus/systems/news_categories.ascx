<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Private sNewsPage As String
    Public Property NewsPage() As String
        Get
            Return sNewsPage
        End Get
        Set(ByVal value As String)
            sNewsPage = value
        End Set
    End Property
   
    Private nNewsPageId As Integer
    Public Property NewsPageId() As Integer
        Get
            Return nNewsPageId
        End Get
        Set(ByVal value As Integer)
            nNewsPageId = value
        End Set
    End Property
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        PopulateRoot()
    End Sub
    
    Private Sub PopulateRoot()
        treeCategories.Nodes.Clear()
        
        oConn = New SqlConnection(sConn)
        oConn.Open()
        
        'Without Post Count
        'Dim oCommand As New SqlCommand("select listing_category_id, listing_category_name, (select count(*) FROM listing_categories where parent_id=sc.listing_category_id) AS childnodecount, (select count(*) FROM listing_categories " _
        '  & "where parent_id=sc.listing_category_id) AS childnodecount FROM listing_categories AS sc WHERE parent_id=0 and page_id=@page_id ORDER BY sorting", oConn)
        
        'With Post Count
        Dim oCommand As New SqlCommand("SELECT listing_categories_1.listing_category_id, listing_categories_1.listing_category_name, COUNT(listing_category_map.page_id) AS posts," & _
            "(SELECT COUNT(*) AS Expr1 FROM listing_categories WHERE  parent_id=listing_categories_1.listing_category_id) AS childnodecount " & _
            "FROM pages_published_active AS sc INNER JOIN " & _
            "listing_category_map ON sc.page_id = listing_category_map.page_id RIGHT OUTER JOIN " & _
            "listing_categories AS listing_categories_1 ON listing_category_map.listing_category_id = listing_categories_1.listing_category_id " & _
            "WHERE listing_categories_1.parent_id = 0 AND listing_categories_1.page_id = @page_id " & _
            "GROUP BY listing_categories_1.listing_category_id, listing_categories_1.listing_category_name, listing_categories_1.sorting " & _
            "ORDER BY listing_categories_1.sorting", oConn)
        
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nNewsPageId
        Dim da As New SqlDataAdapter(oCommand)
        Dim dt As New DataTable()
        da.Fill(dt)
        
        PopulateNodes(dt, treeCategories.Nodes)
        treeCategories.ExpandAll()
    End Sub
    
    Private Sub PopulateNodes(ByVal dt As DataTable, ByVal nodes As TreeNodeCollection)
        For Each dr As DataRow In dt.Rows
            Dim tn As New TreeNode()
            tn.Text = HttpUtility.HtmlEncode(dr("listing_category_name").ToString()) & " (" & dr("posts").ToString() & ")"
            tn.Value = dr("listing_category_id").ToString()
            nodes.Add(tn)
            tn.PopulateOnDemand = (CInt(dr("childnodecount")) > 0)
        Next
    End Sub
    
    Private Sub PopulateChild(ByVal nParentId As Integer, ByVal parentNode As TreeNode)
        oConn = New SqlConnection(sConn)
        oConn.Open()

        'Without Post Count
        'Dim oCommand As New SqlCommand("select listing_category_id,listing_category_name,(select count(*) FROM listing_categories " _
        '  & "where parent_id=sc.listing_category_id) childnodecount FROM listing_categories sc where parent_id=@parent_id ORDER BY sorting", _
        '  oConn)
 
        'With Post Count
        Dim oCommand As New SqlCommand("SELECT listing_categories_1.listing_category_id, listing_categories_1.listing_category_name, COUNT(listing_category_map.page_id) AS posts," & _
            "(SELECT COUNT(*) AS Expr1 FROM listing_categories WHERE  parent_id=listing_categories_1.listing_category_id) AS childnodecount " & _
            "FROM pages_published_active AS sc INNER JOIN " & _
            "listing_category_map ON sc.page_id = listing_category_map.page_id RIGHT OUTER JOIN " & _
            "listing_categories AS listing_categories_1 ON listing_category_map.listing_category_id = listing_categories_1.listing_category_id " & _
            "WHERE listing_categories_1.parent_id = @parent_id " & _
            "GROUP BY listing_categories_1.listing_category_id, listing_categories_1.listing_category_name, listing_categories_1.sorting " & _
            "ORDER BY listing_categories_1.sorting", oConn)
        
        oCommand.Parameters.Add("@parent_id", SqlDbType.Int).Value = nParentId
        Dim da As New SqlDataAdapter(oCommand)
        Dim dt As New DataTable()
        da.Fill(dt)
        
        PopulateNodes(dt, parentNode.ChildNodes)
    End Sub
    
    Protected Sub treeCategories_TreeNodePopulate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles treeCategories.TreeNodePopulate
        PopulateChild(CInt(e.Node.Value), e.Node)
    End Sub
    
    Protected Sub treeCategories_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(sNewsPage & "?cat=" & treeCategories.SelectedValue)
    End Sub
</script>

<asp:TreeView ID="treeCategories" PopulateNodesFromClient="true" ShowLines="true" ShowExpandCollapse="true" runat="server" OnSelectedNodeChanged="treeCategories_SelectedNodeChanged">
</asp:TreeView>



