<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        litText.Text = GetLocalResourceObject("PageNotFound")
        litText2.Text = GetLocalResourceObject("PageNotFound2")
    End Sub

</script>
<p style="font-weight:bold">
<asp:Literal ID="litText" runat="server"></asp:Literal>
</p>
<p>
<asp:Literal ID="litText2" runat="server"></asp:Literal>
</p>



