<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Literal1.Text = "Hello World!"
    End Sub
</script>

<asp:Literal ID="Literal1" runat="server"></asp:Literal>
