<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
 
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsNothing(GetUser()) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
                Dim Setting As NewsletterSetting = New NewsletterSetting
    
                panelLogin.Visible = False
                panelSetting.Visible = True
                Setting = GetSetting(Me.RootID)
                With Setting
                    txtSubject.Text = .ConfirmationSubject
                    txtBody.Text = .ConfirmationBody
                    txtSignature.Text = .UnsubscribeSignature
                    txtSignatureText.Text = .UnsubscribeSignatureText
                End With
            End If
        Else
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelSetting.Visible = False
        End If
        
        lblStatus.Text = ""
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim Setting As NewsletterSetting = New NewsletterSetting
        With Setting
            .ConfirmationSubject = txtSubject.Text
            .ConfirmationBody = txtBody.Text
            .UnsubscribeSignature = txtSignature.Text
            .UnsubscribeSignatureText = txtSignatureText.Text
            .RootId = Me.RootID
        End With

        CreateSetting(Setting)
        lblStatus.Text = GetLocalResourceObject("SavedSuccessfully")
        
        'Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelSetting" runat="server">
  <table>
    <tr valign="top">
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("Subject")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtSubject" runat="server" Width="350"></asp:TextBox></td>
    </tr>
    <tr valign="top">
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("Body")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" Width="350" Height="150"></asp:TextBox></td>
    </tr>
    <tr valign="top">
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("Signature")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtSignature" runat="server" TextMode="MultiLine" Width="350" Height="50"></asp:TextBox>
    <div><%=GetLocalResourceObject("TextVersion")%>:</div>    
    <asp:TextBox ID="txtSignatureText" runat="server" TextMode="MultiLine" Width="350" Height="50"></asp:TextBox>
    </td>
    </tr>
    <tr valign="top">
    <td colspan="3">
        <div style="margin:7px"></div>
        <asp:Button ID="btnSave" runat="server" Text=" Save " meta:resourcekey="btnSave" OnClick="btnSave_Click" />
        <asp:Label ID="lblStatus" Font-Bold="true" runat="server" Text=""></asp:Label>
    </td>
    </tr>
  </table>
</asp:Panel>
