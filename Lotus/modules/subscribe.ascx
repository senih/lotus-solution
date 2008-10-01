<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
  End Sub
    
  Protected Sub btnSubscribe_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    Response.Redirect(Me.LinkActivate & "?un=" & txtName.Text & "&ue=" & txtEmail.Text & "&ReturnUrl=" & HttpContext.Current.Items("_page"))
  End Sub

</script>


<asp:Panel ID="panelSubscribe" DefaultButton="btnSubscribe" runat="server">

<table cellpadding="0" cellspacing="0" class="boxSubscribe">
    <tr>
        <td class="boxHeaderSubscribe">
            <asp:Literal ID="litSubscribeTitle" meta:resourcekey="litSubscribeTitle" runat="server" Text="Subscribe to our Mailing list"></asp:Literal>
        </td>
    </tr>
    <tr>
        <td class="boxFormSubscribe" style="white-space:nowrap">
          <asp:Label ID="lblName" text="Name" runat="server" meta:resourcekey="lblName"></asp:Label><br />
          <asp:TextBox ID="txtName" runat="server" Width="120" ></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtName" ValidationGroup="subscribe" ErrorMessage=""></asp:RequiredFieldValidator>
          <br />
          <asp:Label ID="lblEmail" text="Email" runat="server" meta:resourcekey="lblEmail"></asp:Label><br />
          <asp:TextBox ID="txtEmail" runat="server" Width="120" ></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtEmail" ValidationGroup="subscribe" ErrorMessage=""></asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator ID="rfv3" ControlToValidate="txtEmail" ValidationGroup="subscribe" ErrorMessage="*" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" runat="server"></asp:RegularExpressionValidator>
        </td>
    </tr>
    <tr>
        <td class="boxButtonSubscribe">
            <asp:Button ID="btnSubscribe" CssClass="btnSubscribe" SkinID="btnSubscribe" meta:resourcekey="btnSubscribe" runat="server" ValidationGroup="subscribe" Text="Subscribe" OnClick="btnSubscribe_Click"  />
        </td>
    </tr>
</table>

</asp:Panel>
