<%@ Page Language="VB" ValidateRequest="false"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Collections.Generic" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nPageId As Integer
    Private sCulture As String
    Private sFileName As String
    
    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            'Authorization
            If Not Session(Request.QueryString("pg").ToString) Then
                'Session(nPageId.ToString) akan = true jika page bisa dibuka (di default.aspx/vb)
                Response.Write("Authorization Failed.")
                Response.End()
            End If
        End If
    End Sub
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()
        
        sCulture = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnAddCategory.Text = GetLocalResourceObject("btnAddCategory.Text")
        lblCategoryName.Text = GetLocalResourceObject("lblCategoryName.Text")
        lblSorting.Text = GetLocalResourceObject("lblSorting.Text")
        
        nPageId = CInt(Request.QueryString("pg"))
        
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.SelectCommand = "SELECT * FROM listing_categories WHERE page_id=@page_id order by sorting"
        'SqlDataSource1.SelectParameters.Add("page_id", SqlDbType.Int)
        SqlDataSource1.SelectParameters(0).DefaultValue = nPageId
        
        If Not Page.IsPostBack Then
            PopulateRoot()
            divEdit.Style.Add("display", "none")
        End If
        lblStatus.Text = ""
       
        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)
        sFileName = contentLatest.FileName
        contentLatest = Nothing
        oContentManager = Nothing
        
        btnClose.OnClientClick = "self.close()"
    End Sub
    
    Private Sub PopulateRoot()
        treeCategories.Nodes.Clear()
        
        oConn = New SqlConnection(sConn)
        oConn.Open()
        Dim oCommand As New SqlCommand("select listing_category_id, listing_category_name, (select count(*) FROM listing_categories " _
           & "where parent_id=sc.listing_category_id) AS childnodecount FROM listing_categories AS sc WHERE parent_id=0 and page_id=@page_id", oConn)
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        Dim da As New SqlDataAdapter(oCommand)
        Dim dt As New DataTable()
        da.Fill(dt)
        
        PopulateNodes(dt, treeCategories.Nodes)
        treeCategories.ExpandAll()
    End Sub
    
    Private Sub PopulateNodes(ByVal dt As DataTable, ByVal nodes As TreeNodeCollection)
        For Each dr As DataRow In dt.Rows
            Dim tn As New TreeNode()
            tn.Text = HttpUtility.HtmlEncode(dr("listing_category_name").ToString())
            tn.Value = dr("listing_category_id").ToString()
            nodes.Add(tn)
            tn.PopulateOnDemand = (CInt(dr("childnodecount")) > 0)
        Next
    End Sub
    
    Private Sub PopulateChild(ByVal nParentId As Integer, ByVal parentNode As TreeNode)
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim oCommand As New SqlCommand("select listing_category_id,listing_category_name,(select count(*) FROM listing_categories " _
          & "where parent_id=sc.listing_category_id) childnodecount FROM listing_categories sc where parent_id=@parent_id ORDER BY sorting", _
          oConn)
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
        Dim nCatId As Integer = CInt(treeCategories.SelectedValue)
        
        dropParent2.Items.Clear()
        dropParent2.DataSourceID = "SqlDataSource1"
        dropParent2.DataBind()
        
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim oCommand As New SqlCommand("select * FROM listing_categories where listing_category_id=@listing_category_id", _
          oConn)
        oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = nCatId
        
        Dim oDataReader As SqlDataReader
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            hidCategoryId.Value = CInt(oDataReader("listing_category_id"))
            txtCategoryName2.Text = oDataReader("listing_category_name").ToString
            txtSorting2.Text = CInt(oDataReader("sorting"))
            If CInt(oDataReader("parent_id")) = 0 Then
                dropParent2.SelectedValue = 0
            Else
                dropParent2.SelectedValue = CInt(oDataReader("parent_id"))
            End If
        End If
        oDataReader.Close()
        oConn.Close()
        
        dropParent2.Items.Remove(dropParent2.Items.FindByValue(nCatId))
        btnDelete.OnClientClick = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"

        divEdit.Style.Add("display", "block")
        divAdd.Style.Add("display", "none")
    End Sub
            
    Protected Sub btnAddCategory_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim nSortingNew As Integer = 1
        
        Dim oCmd As SqlCommand
        oConn.Open()
        
        oCmd = New SqlCommand

        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO listing_categories (listing_category_name, sorting, page_id, parent_id) " & _
                           "values (@listing_category_name, @sorting, @page_id, @parent_id)"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.Parameters.Add("@sorting", SqlDbType.Int).Value = txtSorting.Text
        oCmd.Parameters.Add("@listing_category_name", SqlDbType.NVarChar).Value = txtCategoryName.Text
        oCmd.Parameters.Add("@parent_id", SqlDbType.Int).Value = dropParent.SelectedValue
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()

        txtCategoryName.Text = ""
        txtSorting.Text = ""
                
        divEdit.Style.Add("display", "none")
        divAdd.Style.Add("display", "block")
        btnClose.OnClientClick = "closeAndRefresh('" & sFileName & "');return false"
        PopulateRoot()
        dropParent.Items.Clear()
        dropParent.DataSourceID = "SqlDataSource1"
        dropParent.DataBind()
        dropParent.Items.Clear()
        dropParent.DataSourceID = "SqlDataSource1"
        dropParent.DataBind()
        dropParent2.Items.Clear()
        dropParent2.DataSourceID = "SqlDataSource1"
        dropParent2.DataBind()
    End Sub
    
    Protected Sub dropParent_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        dropParent.Items.Insert(0, New ListItem("Root", 0))
    End Sub

    Protected Sub dropParent2_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        dropParent2.Items.Insert(0, New ListItem("Root", 0))
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand
        oConn.Open()

        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "UPDATE listing_categories SET listing_category_name=@listing_category_name, sorting=@sorting, parent_id=@parent_id WHERE listing_category_id=@listing_category_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = hidCategoryId.Value
        oCmd.Parameters.Add("@listing_category_name", SqlDbType.NVarChar).Value = txtCategoryName2.Text
        oCmd.Parameters.Add("@sorting", SqlDbType.Int).Value = txtSorting2.Text
        oCmd.Parameters.Add("@parent_id", SqlDbType.Int).Value = dropParent2.SelectedValue
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()

        divEdit.Style.Add("display", "none")
        divAdd.Style.Add("display", "block")
        btnClose.OnClientClick = "closeAndRefresh('" & sFileName & "');return false"
        PopulateRoot()
        dropParent.Items.Clear()
        dropParent.DataSourceID = "SqlDataSource1"
        dropParent.DataBind()
        dropParent2.Items.Clear()
        dropParent2.DataSourceID = "SqlDataSource1"
        dropParent2.DataBind()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        divEdit.Style.Add("display", "none")
        divAdd.Style.Add("display", "block")
        btnClose.OnClientClick = "closeAndRefresh('" & sFileName & "');return false"
        PopulateRoot()
        dropParent.Items.Clear()
        dropParent.DataSourceID = "SqlDataSource1"
        dropParent.DataBind()
        dropParent2.Items.Clear()
        dropParent2.DataSourceID = "SqlDataSource1"
        dropParent2.DataBind()
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oCommand = New SqlCommand("SELECT * FROM listing_category_map WHERE listing_category_id=@listing_category_id", oConn)
        oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = hidCategoryId.Value

        oConn.Open()
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            lblStatus.Text = GetLocalResourceObject("DeleteFailed")
            
            oDataReader.Close()
            oConn.Close()
            Exit Sub
 
        End If
        oDataReader.Close()
        
        oCommand = New SqlCommand("SELECT * FROM listing_categories WHERE parent_id=@listing_category_id", oConn)
        oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = hidCategoryId.Value

        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            lblStatus.Text = GetLocalResourceObject("DeleteFailed")
            
            oDataReader.Close()
            oConn.Close()
            Exit Sub
 
        End If
        oDataReader.Close()
        
        oCommand = New SqlCommand("DELETE listing_categories WHERE listing_category_id=@listing_category_id", oConn)
        oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = hidCategoryId.Value
        oCommand.ExecuteNonQuery()
        
        oConn.Close()
        
        divEdit.Style.Add("display", "none")
        divAdd.Style.Add("display", "block")
        btnClose.OnClientClick = "closeAndRefresh('" & sFileName & "');return false"
        PopulateRoot()
        dropParent.Items.Clear()
        dropParent.DataSourceID = "SqlDataSource1"
        dropParent.DataBind()
        dropParent2.Items.Clear()
        dropParent2.DataSourceID = "SqlDataSource1"
        dropParent2.DataBind()
    End Sub
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <base target="_self" />
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script type="text/javascript" language="javascript">
    function closeAndRefresh(sFileName)
        {        
        if(navigator.appName.indexOf("Microsoft")!=-1)
            {
            dialogArguments.navigate("../" + sFileName)
            }
        else
            {
            window.opener.location.href="../" + sFileName;
            }
        self.close();
        }
    </script>
</head>
<body style="margin:10px;background-color:#E6E7E8">
<form id="form1" runat="server">
    <div runat="server" id="divScroll" style="height:190px;overflow:auto;background:white;padding:0px;border-bottom:#cccccc 1px solid;margin-bottom:5px">
    <asp:TreeView ID="treeCategories" PopulateNodesFromClient="true" ShowLines="true" ShowExpandCollapse="true" runat="server" OnSelectedNodeChanged="treeCategories_SelectedNodeChanged">
    </asp:TreeView>
    </div>
    
    <div style="height:30px;padding-bottom:7px">
    <asp:Label ID="lblStatus" Font-Bold="true" ForeColor="Red" runat="server" Text=""></asp:Label>
    </div>
    
    <table id="divAdd" runat="server">
    <tr><td colspan="3"><asp:Label ID="lblAdd" meta:resourcekey="lblAdd" runat="server" Font-Bold="true" Text="ADD CATEGORY"></asp:Label></td></tr>
    <tr>
        <td><asp:Label ID="lblCategoryName" meta:resourcekey="lblCategoryName" runat="server" Text="Category Name"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="AddCategory" ControlToValidate="txtCategoryName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblSorting" meta:resourcekey="lblSorting" runat="server" Text="Sorting"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtSorting" runat="server" Text="1"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="AddCategory" ControlToValidate="txtSorting" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblUnder" meta:resourcekey="lblUnder" runat="server" Text="Under"></asp:Label></td><td>:</td>
        <td>
            <asp:DropDownList ID="dropParent" DataKeyNames="listing_category_id" DataTextField="listing_category_name" DataValueField = "listing_category_id" DataSourceID="SqlDataSource1" runat="server" OnDataBound="dropParent_DataBound">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
    <td colspan="3" style="padding-top:12px">
        <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
        <asp:Button ID="btnAddCategory" runat="server" meta:resourcekey="btnAddCategory" ValidationGroup="AddCategory" Text="Add Category" OnClick="btnAddCategory_Click" />&nbsp;
    </td>
    </tr>
    </table>


    <table id="divEdit" runat="server">
    <tr><td colspan="3"><asp:Label ID="lblEdit" meta:resourcekey="lblEdit" runat="server" Font-Bold="true" Text="EDIT CATEGORY"></asp:Label></td></tr>
    <tr>
        <td><asp:Label ID="lblCategoryName2" meta:resourcekey="lblCategoryName" runat="server" Text="Category Name"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:HiddenField ID="hidCategoryId" runat="server" />
            <asp:TextBox ID="txtCategoryName2" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="EditCategory" ControlToValidate="txtCategoryName2" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>    
    </tr>
    <tr>
        <td><asp:Label ID="lblSorting2" meta:resourcekey="lblSorting" runat="server" Text="Sorting"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtSorting2" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="EditCategory" ControlToValidate="txtSorting2" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblUnder2" meta:resourcekey="lblUnder" runat="server" Text="Under"></asp:Label></td><td>:</td>
        <td>
            <asp:DropDownList ID="dropParent2" DataKeyNames="listing_category_id" DataTextField="listing_category_name" DataValueField = "listing_category_id" DataSourceID="SqlDataSource1" runat="server" OnDataBound="dropParent2_DataBound">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
    <td colspan="3" style="padding-top:12px">
        <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="   Cancel   " OnClick="btnCancel_Click" />
        <asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text="   Delete   " OnClick="btnDelete_Click" />
        <asp:Button ID="btnUpdate" runat="server" meta:resourcekey="btnUpdate" ValidationGroup="EditCategory" Text="  Update   " OnClick="btnUpdate_Click" />&nbsp;
    </td>
    </tr>
    </table>
    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server">
        <SelectParameters>
            <asp:Parameter Name="page_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</form>
</body>
</html>
