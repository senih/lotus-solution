<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">
    Private sReturnUrl As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(Request.QueryString("ReturnUrl")) Then
            sReturnUrl = Me.RootFile
        Else
            sReturnUrl = Request.QueryString("ReturnUrl")
        End If
        
        Login1.PasswordRecoveryUrl = "~/password.aspx?ReturnUrl=" & sReturnUrl
        Login1.Focus()
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(sReturnUrl) 'Used For Login
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & sReturnUrl
    End Sub
</script>

<asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
    <LabelStyle HorizontalAlign="Left" Wrap="False" />
</asp:Login>
<br />




