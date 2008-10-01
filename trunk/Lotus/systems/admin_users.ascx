<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.sqlClient"%>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sconn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sconn)
    Private sRawUrl As String = Context.Request.RawUrl.ToString
    Private iIndex As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                CreateUserWizard1.Visible = True
                DataUser.Visible = True
                If Not IsPostBack Then
                    Users.DataSource = Membership.GetAllUsers(0, 100, Membership.GetAllUsers.Count)
                    Users.DataBind()
                    lnkImport.NavigateUrl = "~/" & Me.LinkAdminUsersImport
  
                    Dim lsbRoles As ListBox
  
                    lsbRoles = CreateUserWizardStep1.ContentTemplateContainer.FindControl("lsbRoles")
  
                    lsbRoles.DataSource = Roles.GetAllRoles()
                    lsbRoles.DataBind()
                End If
            
                dropUserRoles.DataSource = Roles.GetAllRoles()
                dropUserRoles.DataBind()

            End If
        End If
    End Sub

    Protected Sub Users_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles Users.RowDeleting
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sSelectedUserName As String = Server.HtmlDecode(Users.Rows(e.RowIndex).Cells(0).Text)
        Membership.DeleteUser(sSelectedUserName)
        Users.DataSource = Membership.GetAllUsers()
        Users.DataBind()
    End Sub

    Protected Sub Users_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles Users.PageIndexChanging
        iIndex = e.NewPageIndex()
        Users.PageIndex = iIndex
        If Not txtName.Text = "" Then
            btnSearch_Click(Nothing, Nothing)
        Else
            Users.DataSource = Membership.GetAllUsers()
        End If
        Users.DataBind()
    End Sub

    Protected Sub Users_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Users.PageIndex = iIndex
    End Sub

    Protected Sub Users_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Users.SelectedIndexChanged
        Dim sSelectedUserName As String = Users.SelectedValue.ToString()
        Response.Redirect(Me.LinkAdminUserInfo & "?username=" & sSelectedUserName)
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sqlDS1 As SqlDataSource = New SqlDataSource
        sqlDS1.ConnectionString = sconn

        If dropSearchUser.SelectedValue = "Name" Then
            Dim sUserName As String = txtName.Text.ToLower
            sqlDS1.SelectCommand = "select aspnet_Membership.*,users.UserName from aspnet_Membership Inner Join (" & _
              " select * from aspnet_Users" & _
              " where aspnet_Users.LoweredUserName like '%" & sUserName & "%' or aspnet_Users.LoweredUserName like '%" & sUserName & "' or aspnet_Users.LoweredUserName like '" & sUserName & "%' or aspnet_Users.LoweredUserName like '" & sUserName & "'" & _
              " ) as users ON (users.UserId = aspnet_Membership.UserId) " & _
              " Inner join (select aspnet_Applications.ApplicationId from aspnet_Applications where aspnet_Applications.LoweredApplicationName= '" & ApplicationName & "') as app on (app.ApplicationId=aspnet_Membership.ApplicationId)"
            Users.DataSource = sqlDS1
            Users.DataBind()
        Else
            Dim sEmail As String = txtName.Text.ToLower
            sqlDS1.SelectCommand = "select users.*,aspnet_Users.UserName from aspnet_Users Inner Join (" & _
              " select * from aspnet_Membership" & _
              " where aspnet_Membership.LoweredEmail like '%" & sEmail & "%' or aspnet_Membership.LoweredEmail like '%" & sEmail & "' or aspnet_Membership.LoweredEmail like '" & sEmail & "%' or aspnet_Membership.LoweredEmail like '" & sEmail & "'" & _
              " ) as users ON (users.UserId = aspnet_Users.UserId) " & _
              " Inner join (select aspnet_Applications.ApplicationId from aspnet_Applications where aspnet_Applications.LoweredApplicationName= '" & ApplicationName & "') as app on (app.ApplicationId=aspnet_Users.ApplicationId)"
            Users.DataSource = sqlDS1
            Users.DataBind()
        End If
        If Users.Rows.Count = 0 Then
            lblSearchStatus.Text = GetLocalResourceObject("NoUsersFound")
        Else
            lblSearchStatus.Text = ""
        End If
    End Sub
 
    Protected Sub btnListAllUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnListAllUsers.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        txtName.Text = ""

        Users.DataSource = Membership.GetAllUsers()
        Users.DataBind()
        lblSearchStatus.Text = ""
    End Sub

    Private Function GetFileName() As String
        Dim sFileName As String
        If sRawUrl.Contains("?") Then
            sRawUrl = sRawUrl.Substring(sRawUrl.LastIndexOf("/") + 1)
            sFileName = sRawUrl.Substring(0, sRawUrl.LastIndexOf("?"))
        Else
            sFileName = sRawUrl.Substring(sRawUrl.LastIndexOf("/") + 1)
        End If
        Return sFileName
    End Function

    Protected Sub Users_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To Users.Rows.Count - 1
            CType(Users.Rows(i).Cells(4).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub CreateUserWizard1_ContinueButtonClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.ContinueButtonClick
        Response.Redirect(Me.LinkAdminUsers)
    End Sub

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.CreatedUser
        'Dim sPath As String = Server.MapPath(ConfigurationManager.AppSettings("InstallPath") & "/assets/members/" & CreateUserWizard1.UserName.ToString)
    
        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(CreateUserWizard1.UserName)
        pcSelectedProfile.UseWYSIWYG = True
        pcSelectedProfile.Save()

        Dim i As Integer
        Dim lsbRoles As ListBox
      
        lsbRoles = CreateUserWizardStep1.ContentTemplateContainer.FindControl("lsbRoles") '

        For i = 0 To lsbRoles.Items.Count - 1
            If lsbRoles.Items(i).Selected Then
                Roles.AddUserToRole(CreateUserWizard1.UserName, lsbRoles.Items(i).Text)
            End If
        Next

        lsbRoles.Visible = False
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub CreateUserWizard1_CreatingUser(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.LoginCancelEventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub btnShowUsersInRole_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sqlDS1 As SqlDataSource = New SqlDataSource
        sqlDS1.ConnectionString = sconn

        Dim sRole As String = dropUserRoles.SelectedValue
        
        sqlDS1.SelectCommand = "SELECT aspnet_Membership.UserId, aspnet_Users.UserName, aspnet_Membership.Email, aspnet_Membership.IsApproved " & _
            "FROM aspnet_UsersInRoles INNER JOIN " & _
            "aspnet_Roles ON aspnet_UsersInRoles.RoleId = aspnet_Roles.RoleId INNER JOIN " & _
            "aspnet_Membership ON aspnet_UsersInRoles.UserId = aspnet_Membership.UserId INNER JOIN " & _
            "aspnet_Users ON aspnet_UsersInRoles.UserId = aspnet_Users.UserId AND aspnet_Membership.UserId = aspnet_Users.UserId INNER JOIN " & _
            "(SELECT ApplicationId FROM aspnet_Applications WHERE (LoweredApplicationName = '" & ApplicationName & "')) AS app ON app.ApplicationId = aspnet_Membership.ApplicationId " & _
            "WHERE (aspnet_Roles.RoleName = N'" & sRole & "')"

        Users.DataSource = sqlDS1
        Users.DataBind()
        If Users.Rows.Count = 0 Then
            lblSearchStatus.Text = GetLocalResourceObject("NoUsersFound")
        Else
            lblSearchStatus.Text = ""
        End If
    End Sub

    Protected Sub CreateUserWizard1_CreateUserError(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CreateUserErrorEventArgs)
        Dim lblError As Label = CreateUserWizardStep1.CustomNavigationTemplateContainer.FindControl("lblError")
        If e.CreateUserError.ToString = "DuplicateUserName" Then
            lblError.Text = GetLocalResourceObject("DuplicateUserName")
        End If
        If e.CreateUserError.ToString = "DuplicateEmail" Then
            lblError.Text = GetLocalResourceObject("DuplicateEmail")
        End If
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="DataUser" runat="server" Visible="false">

<table cellpadding="0" cellspacing="0">
<tr>
<td valign="top">

    <table>
    <tr>
    <td colspan="2" style="padding-bottom:20px">
        <asp:HyperLink ID="lnkImport" meta:resourcekey="lnkImport" Text="Import Users" runat="server"></asp:HyperLink>
    </td>
    </tr>
    <tr>
        <td align="left" style="white-space:nowrap">
            <asp:Label ID="lblSearchUser" meta:resourcekey="lblSearchUser" runat="server" Text="Search User By"></asp:Label>
        </td>
        <td>:</td>
        <td style="padding-top:2px">
            <asp:DropDownList ID="dropSearchUser" runat="server">
                <asp:ListItem meta:resourcekey="liName" Value="Name" Text="User Name"></asp:ListItem>
                <asp:ListItem meta:resourcekey="liEmail" Value="Email" Text="Email" Selected="True"></asp:ListItem>
            </asp:DropDownList>
        </td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtName" ValidationGroup="Search" runat="server"></asp:TextBox>
        </td>
        <td style="white-space:nowrap">
            <asp:Button ID="btnSearch" Width="80px" meta:resourcekey="btnSearch" ValidationGroup="Search" runat="server" Text="Search" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ValidationGroup="Search" ControlToValidate="txtName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblShowUsersInRole" meta:resourcekey="lblShowUsersInRole" runat="server" Text="Show Users in Role"></asp:Label>
        </td>
        <td>:</td>
        <td colspan="2">
            <asp:DropDownList ID="dropUserRoles" runat="server">
            </asp:DropDownList>
        </td>
        <td>
            <asp:Button ID="btnShowUsersInRole" meta:resourcekey="btnShowUsersInRole" Width="80px" runat="server" Text="Show" OnClick="btnShowUsersInRole_Click" />
        </td>
    </tr>
    </table>
    <br />
    <asp:GridView ID="Users" GridLines=None Width="100%" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server" DataKeyNames="UserName" AllowPaging="True" AutoGenerateColumns="False" AllowSorting="False" OnPreRender="Users_PreRender" OnPageIndexChanged="Users_PageIndexChanged">
            <Columns>
                <asp:BoundField meta:resourcekey="lblUserName" DataField="UserName" HeaderText="User Name" SortExpression="UserName" HeaderStyle-Wrap="False" />
                <asp:BoundField meta:resourcekey="lblEmail" DataField="Email" HeaderText="Email" SortExpression="Email" />
                <asp:CheckBoxField  meta:resourcekey="lblApproved" DataField="IsApproved" HeaderText="Approved" SortExpression="IsApproved"/>
                <asp:CommandField meta:resourcekey="lblCommand" ShowSelectButton="true" SelectText="Edit" />
                <asp:CommandField meta:resourcekey="lblCommand" DeleteText="Delete" ShowDeleteButton="true"  ButtonType="link" />
            </Columns>
    </asp:GridView>  
    <div style="margin-top:7px;text-align:right">
        <asp:Label ID="lblSearchStatus" runat="server" Font-Bold="true" Text=""></asp:Label>
        <asp:Button ID="btnListAllUsers" meta:resourcekey="btnListAllUsers" runat="server" Text="List All Users" CausesValidation=false />                
    </div>  
</td>
<td valign="top" style="padding-top:100px">

<!-- sblmnya New User di sini -->
<!--<div style="border:#E0E0E0 1px solid;padding:10px;width:255px;margin-left:15px;">-->

</td>
</tr>
</table>

<div style="border:#E0E0E0 1px solid;padding:10px;width:255px;margin-left:0px;margin-top:15px">
    <asp:CreateUserWizard meta:resourcekey="CreateUserWizard" 
        UserNameLabelText="User Name:" 
        PasswordLabelText="Password:" 
        ConfirmPasswordLabelText="Confirm Password:" 
        EmailLabelText="Email:"
        CreateUserButtonText="Create User"
        CompleteSuccessText="New user has been successfully created."
        ContinueButtonText="Continue"
        ID="CreateUserWizard1" runat="server" LoginCreatedUser="False" Visible=false OnCreatingUser="CreateUserWizard1_CreatingUser" OnCreateUserError="CreateUserWizard1_CreateUserError">
        <TitleTextStyle HorizontalAlign=Left Font-Bold=True  />
        <LabelStyle HorizontalAlign=Left />
        <WizardSteps>
            <asp:CreateUserWizardStep meta:resourcekey="CreateUserWizardStep" Title="Sign Up for Your New Account" ID="CreateUserWizardStep1" runat="server">
            <ContentTemplate>
              <table>
                <tr>
                  <td colspan="2" style="padding-bottom:10px">
                    <asp:Label ID="Title" meta:resourcekey="Title" Font-Bold=True runat="server" Text="New User"></asp:Label>
                  </td>
                </tr>
                <tr>
                  <td><asp:Label ID="UserNameLabelText" meta:resourcekey="UserNameLabelText" runat="server" Text="User:"></asp:Label></td>
                  <td style="white-space:nowrap">
                    <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="CreateUserWizard1" ControlToValidate="UserName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                  </td>
                </tr>
                <tr>
                  <td><asp:Label ID="PasswordLabelText" meta:resourcekey="PasswordLabelText" runat="server" Text="Password:"></asp:Label></td>
                  <td style="white-space:nowrap">
                    <asp:TextBox ID="Password" TextMode="Password" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="CreateUserWizard1" ControlToValidate="Password" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                  </td>
                </tr>               
                <tr>
                  <td style="white-space:nowrap"><asp:Label ID="ConfirmPasswordLabelText" meta:resourcekey="ConfirmPasswordLabelText" runat="server" Text="Confirm Password:"></asp:Label></td>
                  <td style="white-space:nowrap">
                    <asp:TextBox ID="ConfirmPassword" TextMode="Password" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="CreateUserWizard1" ControlToValidate="ConfirmPassword" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                      Display="Dynamic" ErrorMessage="*"
                      ID="PasswordCompare" runat="server" ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
                  </td>
                </tr>
                <tr>
                  <td><asp:Label ID="EmailLabelText" meta:resourcekey="EmailLabelText" runat="server" Text="Email:"></asp:Label></td>
                  <td style="white-space:nowrap">
                    <asp:TextBox ID="Email" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="CreateUserWizard1" ControlToValidate="Email" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                  </td>
                </tr>
                <tr>
                  <td colspan="2" style="padding-top:10px"><asp:Label ID="lblSelRoles" runat="server" meta:resourcekey="lblSelRoles" Text="Selected Roles:"></asp:Label></td>
                </tr>
                <tr>
                  <td colspan="2">
                    <asp:ListBox ID="lsbRoles" runat="server"  Rows="5" SelectionMode="Multiple" Width="225"></asp:ListBox>   
                  </td>
                </tr>
              </table>  
            </ContentTemplate>
            <CustomNavigationTemplate>
            <div style="margin-top:10px;margin-bottom:3px;white-space:nowrap;text-align:left">                
                <asp:Button ID="btnCreateUser" meta:resourcekey="btnCreateUser" runat="server" CommandName="MoveNext" Text="Create User" ValidationGroup="CreateUserWizard1" />
                &nbsp;<asp:Label ID="lblError" runat="server" Font-Bold=true ForeColor=red Text=""></asp:Label>
            </div>
            </CustomNavigationTemplate>
            </asp:CreateUserWizardStep>
            <asp:CompleteWizardStep meta:resourcekey="CompleteWizardStep" Title="Complete" ID="CompleteWizardStep1" runat="server">
            </asp:CompleteWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
</div>

</asp:Panel>

