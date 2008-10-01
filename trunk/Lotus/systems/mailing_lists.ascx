<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        litMsg.Text = ""
       
        panelLogin.Visible = True
        panelConfigure.Visible = False
        
        If Not (IsNothing(GetUser())) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
                Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

                panelLogin.Visible = False
                panelConfigure.Visible = True

                SqlNewsletters.ConnectionString = sConn
                SqlNewsletters.SelectCommand = "select * from newsletters_categories where root_id=" & Me.RootID & " or root_id is null order by category"
                SqlNewsletters.UpdateCommand = "update newsletters_categories set category=@category, active=@active, private=@private where category_id=@category_id"
                SqlNewsletters.DeleteCommand = "DELETE FROM newsletters_categories where category_id=0 " 'not use,just for delete command
                'SqlNewsletters.DeleteCommand = "DELETE FROM newsletters_categories where category_id=@category_id ; delete newsletters_map where category_id=@category_id; " & _
                '                               "Update newsletters_subscribers set unsubscribe=1 where category_id=@category_id "
                SqlNewsletters.UpdateParameters.Add("category", SqlDbType.NVarChar)
                SqlNewsletters.UpdateParameters.Add("category_id", SqlDbType.Int)
                SqlNewsletters.UpdateParameters.Add("active", SqlDbType.Bit)
                SqlNewsletters.UpdateParameters.Add("private", SqlDbType.Bit)
                'SqlNewsletters.DeleteParameters.Add("category_id", SqlDbType.Int)
                gvCategories.DataBind()
            End If
        End If
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim oCategory As Category = New Category
        oCategory.IsPrivate = chkPrivate.Checked
        oCategory.RootId = Me.RootID
        oCategory.Title = txtCategory.Text
        oCategory.Active = chkActive.Checked
        InsertCategory(oCategory)
        oCategory = Nothing

        'If Not Roles.RoleExists("Mailing List - " & txtCategory.Text & " Subscribers") Then
        '  Roles.CreateRole("Mailing List - " & txtCategory.Text & " Subscribers")
        'End If
    
        txtCategory.Text = ""
        gvCategories.DataBind()
        chkActive.Checked = False
        chkPrivate.Checked = False
    End Sub

    Protected Sub gvCategories_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim CategoryID As Integer = gvCategories.DataKeys.Item(e.RowIndex).Value
        Dim Category As String = gvCategories.Rows(e.RowIndex).Cells(0).Text
        If ListSubscribers(CategoryID) Then
            DeleteCategory(CategoryID)
  
            'If Roles.RoleExists("Mailing List - " & Category & " Subscribers") Then
            '  Try '
            '    Roles.DeleteRole("Mailing List - " & Category & " Subscribers")
            '  Catch ex As Exception
            '  End Try
            'End If

            'SqlNewsletters.DeleteParameters("category_id").DefaultValue = gvCategories.DataKeys.Item(e.RowIndex).Value
            gvCategories.DataBind()
  
        Else
            litMsg.Text = GetLocalResourceObject("DeleteFail")
        End If
    End Sub

    Protected Sub gvCategories_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs)
        gvCategories.DataBind()
    End Sub

    Protected Sub gvCategories_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs)
        gvCategories.DataBind()
    End Sub

    Protected Sub gvCategories_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs)
        SqlNewsletters.UpdateParameters("category_id").DefaultValue = gvCategories.DataKeys.Item(e.RowIndex).Value
        SqlNewsletters.UpdateParameters("category").DefaultValue = e.NewValues.Item(0)
        SqlNewsletters.UpdateParameters("active").DefaultValue = e.NewValues.Item(1)
        SqlNewsletters.UpdateParameters("private").DefaultValue = e.NewValues.Item(2)
        gvCategories.DataBind()
    End Sub

    Protected Sub gvCategories_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)
        gvCategories.DataBind()
    End Sub

    Protected Sub gvCategories_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvCategories.Rows.Count - 1
            Try
                CType(gvCategories.Rows(i).Cells(4).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelConfigure" runat="server" Visible="false">
<asp:GridView ID="gvCategories" AlternatingRowStyle-BackColor="#f6f7f8" runat="server"
    HeaderStyle-BackColor="#d6d7d8" CellPadding=7 
    HeaderStyle-HorizontalAlign=Left GridLines=None AutoGenerateColumns="False" 
    AllowPaging="True" AllowSorting="True" DataKeyNames="category_id" DataSourceID="SqlNewsletters" 
    OnRowDeleting="gvCategories_RowDeleting" OnPreRender="gvCategories_PreRender" OnRowEditing="gvCategories_RowEditing" OnRowCancelingEdit="gvCategories_RowCancelingEdit" OnRowUpdating="gvCategories_RowUpdating" OnSorting="gvCategories_Sorting">
  <Columns>
    <asp:BoundField DataField="category" HeaderText="List" SortExpression="category" meta:resourcekey="category" />
    <asp:CheckBoxField  DataField="private" HeaderText="Private" SortExpression="private" meta:resourcekey="private"/>
    <asp:CheckBoxField  DataField="active" HeaderText="Active" SortExpression="active" meta:resourcekey="active"/>
    <asp:CommandField EditText="Edit"  ShowEditButton="True" meta:resourcekey="Command" /> 
    <asp:CommandField ShowDeleteButton="True" meta:resourcekey="Command"/>
  </Columns>
  <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" />
  <AlternatingRowStyle BackColor="#F6F7F8" />
</asp:GridView><p></p>
  <asp:Literal ID="litMsg" runat="server"></asp:Literal>
  
<asp:SqlDataSource ID="SqlNewsletters" runat="server" >
</asp:SqlDataSource>

<div style="border:#E0E0E0 1px solid;padding:10px;width:270px;margin-top:20px">
    <table>
    <tr>
    <td colspan="3" style="padding-bottom:7px">
        <asp:Label ID="lblAddNew" meta:resourcekey="lblAddNew" runat="server" Font-Bold="true" Text="Add New"></asp:Label>
    </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblList" meta:resourcekey="lblList" runat="server" Text="List"></asp:Label></td>
        <td>:</td>
        <td><asp:TextBox ID="txtCategory" Width="200" runat="server"></asp:TextBox><asp:RequiredFieldValidator ID="rfvcategory" ControlToValidate="txtCategory" ValidationGroup="category" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <td colspan="3"><asp:CheckBox ID="chkPrivate" meta:resourcekey="chkPrivate" Text="Private" runat="server" /></td>
    </tr>
    <tr>
        <td colspan="3"><asp:CheckBox ID="chkActive" meta:resourcekey="chkActive" Text="Active" runat="server" /></td>
    </tr>
    <tr>
    <td colspan="3" style="padding-top:7px">
        <asp:Button ID="btnCreate" runat="server" Text="  Create  " meta:resourcekey="btnCreate" OnClick="btnCreate_Click" ValidationGroup="category"/>
    </td>
    </tr>
    </table>

    
</div>
<br />
</asp:Panel>