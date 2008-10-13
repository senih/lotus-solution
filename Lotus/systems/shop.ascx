<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
        panelShop.Visible = False
        panelLogin.Visible = True
        Dim oUC1 As Control = LoadControl("login.ascx")
        panelLogin.Controls.Add(oUC1)

        If Not IsNothing(GetUser) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                panelShop.Visible = True
                panelLogin.Visible = False

                lnkConfig.NavigateUrl = "~/" & Me.LinkShopConfig
                lnkProductTypes.NavigateUrl = "~/" & Me.LinkShopProductTypes
                lnkLookup.NavigateUrl = "~/" & Me.LinkShopProductTypeLookup
                lnkShipments.NavigateUrl = "~/" & Me.LinkShopShipments
                lnkTaxes.NavigateUrl = "~/" & Me.LinkShopTaxes
                lnkCoupons.NavigateUrl = "~/" & Me.LinkShopCoupons
                lnkOrderReport.NavigateUrl = "~/" & Me.LinkShopOrders
                
                idProductTypes.Visible = False
                idLookup.Visible = False
            End If
        End If

    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelShop" runat="server" Visible="False">
    <table cellpadding="0" cellspacing="0" style="">
    <tr>
    <td style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkConfig" meta:resourcekey="lnkConfig" runat="server" Text="Configuration"></asp:HyperLink>
    </td>
    <td id="idProductTypes" runat="server" style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkProductTypes" meta:resourcekey="lnkProductTypes" runat="server" Text="Product Types"></asp:HyperLink>
    </td>
    <td id="idLookup" runat="server" style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkLookup" meta:resourcekey="lnkLookup" runat="server" Text="Lookup"></asp:HyperLink>
    </td>
    <td style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkShipments" meta:resourcekey="lnkShipments" runat="server" Text="Shipments"></asp:HyperLink>
    </td>
    <td style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkTaxes" meta:resourcekey="lnkTaxes" runat="server" Text="Taxes"></asp:HyperLink>
    </td>
    <td style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkCoupons" meta:resourcekey="lnkCoupons" runat="server" Text="Coupons"></asp:HyperLink>
    </td>
    <td style="padding-left:0px;padding-right:15px">
        <asp:HyperLink ID="lnkOrderReport" meta:resourcekey="lnkOrderReport" runat="server" Text="Orders"></asp:HyperLink>
    </td>
    </tr>
    </table>
</asp:Panel>