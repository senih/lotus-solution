<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsNothing(Request.QueryString("item_number")) Then
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            oCommand = New SqlCommand("UPDATE orders set status='CONFIRMED' where order_id=@order_id AND status='WAITING_FOR_PAYMENT'")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = Convert.ToInt32(Request.QueryString("item_number"))
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()
            oConn.Close()
            oConn = Nothing
            
            'Empty shopping cart
            Session("cart") = Nothing
        End If
        lnkBack.NavigateUrl = "~/" & Me.RootFile
    End Sub
</script>

<p>
    <asp:Label ID="lblThankYou" meta:resourcekey="lblThankYou" Font-Bold="true" runat="server" Text="Thank you for your order!"></asp:Label>
</p>
<p>
    <asp:Label ID="lblYourOrder" meta:resourcekey="lblYourOrder" runat="server" Text="Your order is currently being processed. You'll receive your order info email shortly."></asp:Label>
</p>
<p>
    <asp:Label ID="lblImportant" meta:resourcekey="lblImportant" runat="server" Font-Bold="true" Text="Important:"></asp:Label>
    <asp:Literal ID="litImportant" meta:resourcekey="litImportant" runat="server"></asp:Literal>
</p>
<asp:HyperLink ID="lnkBack" meta:resourcekey="lnkBack" Text="Back to Home Page" runat="server"></asp:HyperLink>