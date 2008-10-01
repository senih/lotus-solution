<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">   
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SqlDataSource1.ConnectionString = sConn

        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelModules.Visible = True

                SqlDataSource1.DeleteCommand = "DELETE FROM [modules] WHERE [module_file] = @module_file"
                SqlDataSource1.SelectCommand = "SELECT * FROM [modules] order by [display_name]"
            End If
        End If
    End Sub

    Protected Sub gridModules_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gridModules.PageIndexChanging
        Dim iIndex As Integer = e.NewPageIndex()
        gridModules.PageIndex = iIndex
    End Sub

    Protected Sub gridModules_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gridModules.RowDeleting
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim iIndex As Integer
        Dim sModuleFile As String
        iIndex = e.RowIndex()
        sModuleFile = gridModules.Rows.Item(iIndex).Cells(1).Text

        oConn.Open()
        Dim sSQL As String
        sSQL = "DELETE FROM page_modules " & _
            "WHERE module_file=@module_file "
        Dim oCmd As SqlCommand = New SqlCommand(sSQL)
        oCmd.Parameters.Add("@module_file", SqlDbType.NVarChar).Value = sModuleFile

        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
    End Sub

    Protected Sub gridModules_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gridModules.SelectedIndexChanged
        Dim sSelectedModuleFile As String = gridModules.SelectedValue.ToString()
        Response.Redirect(Me.LinkAdminModulePages & "?file=" & sSelectedModuleFile)
    End Sub

    Protected Sub gridModules_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gridModules.Rows.Count - 1
            CType(gridModules.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
    Protected Sub btnRegisterModule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegisterModule.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oCmd As SqlCommand = New SqlCommand

        oCmd.CommandText = "INSERT INTO [modules] ([module_file], [display_name], [owner]) VALUES (@module_file, @display_name, @owner)"
        oCmd.CommandType = CommandType.Text

        oCmd.Parameters.Add("@module_file", SqlDbType.NVarChar).Value = txtModuleFile.Text
        oCmd.Parameters.Add("@display_name", SqlDbType.NVarChar).Value = txtDisplayName.Text
        oCmd.Parameters.Add("@owner", SqlDbType.NVarChar).Value = GetUser.UserName

        Try
            oConn.Open()
            oCmd.Connection = oConn
            oCmd.ExecuteNonQuery()
            oConn.Close()
            Response.Redirect(Me.LinkAdminModules)
        Catch ex As Exception
            lblStatus.Visible = True
        End Try
    End Sub
    
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelModules" runat="server" Wrap=false Visible="false">

<asp:GridView ID="gridModules" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" AllowPaging="True" PageSize="30" HeaderStyle-HorizontalAlign=Left AutoGenerateColumns="False" DataSourceID="SqlDataSource1" AllowSorting="True" DataKeyNames="module_file" OnPreRender="gridModules_PreRender">
    <Columns>
        <asp:BoundField meta:resourcekey="lblName" HeaderText="Name" DataField="display_name" />   
        <asp:BoundField meta:resourcekey="lblFile" HeaderText="File" DataField="module_file" />         
        <asp:CommandField meta:resourcekey="lblEmbed" ShowSelectButton="True" SelectText="Embed to Pages" />
        <asp:CommandField meta:resourcekey="lblDelete" DeleteText="Delete"  ShowDeleteButton="True" />
    </Columns> 
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    <DeleteParameters>
        <asp:Parameter Name="module_file" Type="String" />
    </DeleteParameters>
</asp:SqlDataSource>
<br />

<div style="border:#E0E0E0 1px solid;padding:10px;width:290px;margin-top:15px">
<table>
    <tr>
        <td colspan="3" style="padding-bottom:10px">
            <asp:Label ID="lblNewModule" meta:resourcekey="lblNewModule" Font-Bold=true runat="server" Text="New Module"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblDisplayName" meta:resourcekey="lblDisplayName" runat="server" Text="Name"></asp:Label>
        </td>
        <td>:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtDisplayName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv2" runat="server" ErrorMessage="*" ControlToValidate="txtDisplayName"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblModuleFile" meta:resourcekey="lblModuleFile" runat="server" Text="File"></asp:Label>
        </td>
        <td>:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtModuleFile" runat="server"></asp:TextBox> (eg. rssfeed.ascx)
            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="*" ControlToValidate="txtModuleFile"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="padding-top:7px" valign="top">
            <asp:Button ID="btnRegisterModule" meta:resourcekey="btnRegisterModule" runat="server" Text=" Register " />
            <asp:Label ID="lblStatus" meta:resourcekey="lblStatus" Font-Bold=true runat="server" Text="Registration failed. Please check if file already exists." Visible="false"></asp:Label>       
        </td>
    </tr>
</table>
</div>

</asp:Panel>