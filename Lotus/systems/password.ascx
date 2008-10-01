<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">
    Private sReturnUrl As String
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsNothing(Request("ReturnUrl")) Then
            sReturnUrl = Request("ReturnUrl").ToString
        Else
            sReturnUrl = Me.RootFile
        End If
        
    End Sub
    
    Protected Sub btnSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSend.Click
        Dim sEmail As String = txtEmail.Text
        If Not IsNothing(GetUserNameByEmail(sEmail)) Then
            Dim sUserName As String = GetUserNameByEmail(sEmail)
            Dim oSmtpClient As SmtpClient = New SmtpClient
            Dim oMailMessage As MailMessage = New MailMessage
            Try
                oMailMessage.To.Add(sEmail)
                oMailMessage.Subject = GetLocalResourceObject("Subject") 'Password Recovery
                oMailMessage.IsBodyHtml = False
                Try
                    oMailMessage.Body = GetLocalResourceObject("PleaseReturn") & vbCrLf & _
                                        GetLocalResourceObject("UserName") & " : " & sUserName & vbCrLf & _
                                        GetLocalResourceObject("Password") & " : " & GetUser(sUserName).GetPassword().ToString()
                Catch ex As Exception
                    oMailMessage.Body = GetLocalResourceObject("PleaseReturn") & vbCrLf & _
                    GetLocalResourceObject("UserName") & " : " & sUserName & vbCrLf & _
                    GetLocalResourceObject("Password") & " : " & GetUser(sUserName).ResetPassword().ToString()
                End Try

                'oMailMessage.Body = "Please return to the site and log in using the following information." & vbCrLf & _
                '                    "UserName : " & sUserName & vbCrLf & _
                '                    "Password : " & GetUser(sUserName).GetPassword().ToString()

                oSmtpClient.Send(oMailMessage)

                panelPasswordRecovery.Visible = False
                panelPasswordSent.Visible = True
            Catch ex As Exception
                panelPasswordRecovery.Visible = True
                panelPasswordSent.Visible = False
                lblMessage.Text = ex.Message
            End Try
        Else
            lblMessage.Text = GetLocalResourceObject("EmailAddressNotFound")
        End If
    End Sub

    Protected Sub btnBackToPage_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(sReturnUrl)
    End Sub
</script>

<asp:Panel ID="panelPasswordRecovery" runat="server">
    <asp:Label ID="lblEnterEmail" meta:resourcekey="lblEnterEmail" runat="server" Text="Enter your email to receive your password."></asp:Label>
    <br /><br />
    <table cellpadding=0 cellspacing=0>
    <tr>
    <td style="padding:3px;padding-left:0">
        <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email"></asp:Label>
    </td>
    <td style="padding:3px;">
        <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="Recovery"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ErrorMessage="*" ID="rfvEmail" ValidationGroup="Recovery" ControlToValidate="txtEmail">*</asp:RequiredFieldValidator>
        
    </td>
    </tr>
    <tr><td style="padding:3px;padding-top:10px" colspan="2">
        <asp:Button ID="btnSend" meta:resourcekey="btnSend" runat="server" Text=" Send Password " ValidationGroup="Recovery" />
        <asp:Button ID="btnBackToPage" meta:resourcekey="btnBackToPage" runat="server" Text="Back to page" OnClick="btnBackToPage_Click" />
        <div style="margin:8px"></div>
        <asp:Label ID="lblMessage" runat="server" Font-Bold=true Text=""></asp:Label>
    </td>
    </tr>
    </table>
    <br />
</asp:Panel>

<asp:Panel ID="panelPasswordSent" runat="server" Visible=false>
<asp:Label ID="lblPasswordEmailed" meta:resourcekey="lblPasswordEmailed" runat="server" Font-Bold="true" Text="Your password has been emailed."></asp:Label>
<p><asp:Button ID="btnBackToPage2" meta:resourcekey="btnBackToPage" runat="server" Text="Back to page" OnClick="btnBackToPage_Click" />
</p>
<br /><br />
</asp:Panel>


