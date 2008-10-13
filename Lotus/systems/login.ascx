<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">
    Private sReturnUrl As String
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(Request.QueryString("ReturnUrl")) Then
            If HttpContext.Current.Items("_page").ToString.Contains("login") Then 'contains login.aspx
                sReturnUrl = Me.RootFile
            Else
                sReturnUrl = HttpContext.Current.Items("_path")
            End If
        Else
            sReturnUrl = Request.QueryString("ReturnUrl")
        End If
        
        CType(Login1.FindControl("PasswordRecoveryLink"), HyperLink).NavigateUrl = "~/password.aspx?ReturnUrl=" & sReturnUrl
        CType(Login1.FindControl("UserName"), TextBox).Focus()
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(Request.QueryString("ReturnUrl")) Then
            If HttpContext.Current.Items("_page").ToString.Contains("login") Then 'contains login.aspx
                sReturnUrl = Me.RootFile
            Else
                sReturnUrl = HttpContext.Current.Items("_path")
            End If
        Else
            sReturnUrl = Request.QueryString("ReturnUrl")
        End If
        
        Response.Redirect(sReturnUrl) 'Used For Login
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        CType(Login1.FindControl("PasswordRecoveryLink"), HyperLink).NavigateUrl = "~/password.aspx?ReturnUrl=" & sReturnUrl
        CType(Login1.FindControl("UserName"), TextBox).Focus()
    End Sub

    Protected Sub Login1_Authenticate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.AuthenticateEventArgs)
        If Login1.UserName.Contains("@") Then
            Dim sUserName As String
            sUserName = Membership.GetUserNameByEmail(Login1.UserName)
            If Not IsNothing(sUserName) Then
                If Membership.ValidateUser(sUserName, Login1.Password) Then
                    Login1.UserName = sUserName
                    e.Authenticated = True
                Else
                    e.Authenticated = False
                End If
            Else
                e.Authenticated = False
            End If
        Else
            If Membership.ValidateUser(Login1.UserName, Login1.Password) Then
                e.Authenticated = True
            Else
                e.Authenticated = False
            End If
        End If
    End Sub

</script>


<asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" TextLayout="TextOnTop" TextBoxStyle-Width="150" LoginButtonStyle-Width="150" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender" OnAuthenticate="Login1_Authenticate">
    <LoginButtonStyle Width="150px" />
    <LayoutTemplate>
        <asp:Panel ID="Panel1" DefaultButton="LoginButton" runat="server">
        <table border="0" cellpadding="0" cellspacing="0" 
            style="border-collapse:collapse;">
            <tr>
                <td>
                    <table border="0" cellpadding="1" cellspacing="0">
                        <tr>
                            <td align="left" style="white-space:nowrap;">
                                <asp:Label ID="UserNameLabel" meta:resourcekey="UserNameLabel" runat="server" AssociatedControlID="UserName">User 
                                Name:</asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="UserName" runat="server" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                                    ControlToValidate="UserName" ErrorMessage="*" 
                                    ToolTip="User Name is required." ValidationGroup="ctl00$Login1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="white-space:nowrap;">
                                <asp:Label ID="PasswordLabel" meta:resourcekey="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                                    ControlToValidate="Password" ErrorMessage="*" 
                                    ToolTip="Password is required." ValidationGroup="ctl00$Login1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="RememberMe" meta:resourcekey="RememberMe" runat="server" Text="Remember me next time." />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:Red;">
                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="LoginButton" meta:resourcekey="LoginButton" runat="server" CommandName="Login" Text="Log In" 
                                    ValidationGroup="ctl00$Login1" Width="158px" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top:7px">
                                <asp:HyperLink ID="PasswordRecoveryLink" meta:resourcekey="PasswordRecoveryLink" runat="server">Password Recovery</asp:HyperLink>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </asp:Panel>
    </LayoutTemplate>
    <TextBoxStyle Width="150px" />
    <LabelStyle HorizontalAlign="Left" Wrap="False" />
</asp:Login>


<br />




