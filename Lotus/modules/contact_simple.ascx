<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">  
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage

        Try
            Dim oMailAddress As MailAddress = New MailAddress(txtEmail.Text, txtEmail.Text)

            oMailMessage.From = oMailAddress
            oMailMessage.To.Add(Me.ModuleData)
            oMailMessage.Subject = txtSubject.Text
            oMailMessage.IsBodyHtml = False
            oMailMessage.Body = HttpUtility.HtmlEncode(txtMessage.Text)

            oSmtpClient.Send(oMailMessage)
            lblStatus.Text = GetLocalResourceObject("MessageSent")
        Catch ex As Exception
            lblStatus.Text = ex.Message
        End Try
    End Sub
</script>
<table>
<tr>
    <td>
        <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email"></asp:Label></td><td>:</td>
    <td>
        <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="contact"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" runat="server" ErrorMessage="*" ValidationGroup="contact"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblSubject" meta:resourcekey="lblSubject" runat="server" Text="Subject"></asp:Label></td><td>:</td>
    <td>
        <asp:TextBox ID="txtSubject" runat="server" ValidationGroup="contact"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtSubject" runat="server" ErrorMessage="*" ValidationGroup="contact"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td valign="top"><asp:Label ID="lblMessage" meta:resourcekey="lblMessage" runat="server" Text="Message"></asp:Label></td><td valign="top">:</td>
    <td>
        <asp:TextBox ID="txtMessage" TextMode=MultiLine Rows=5 Columns=50 runat="server" ValidationGroup="contact"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtMessage" runat="server" ErrorMessage="*" ValidationGroup="contact"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td colspan="2">
    </td>
    <td>
        <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Submit " ValidationGroup="contact" />&nbsp;<asp:Label ID="lblStatus" Font-Bold=true runat="server" Text=""></asp:Label>
    </td>
</tr>
</table>
<br />