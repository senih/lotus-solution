<%@ Control Language="C#" AutoEventWireup="true" CodeFile="address_to.ascx.cs" Inherits="modules_address_to" %>

<table>
    <tr>
        <td align="left">
            <asp:Label ID="CityToLabel" runat="server" Text="City to"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:DropDownList ID="cityTo" runat="server" 
                onselectedindexchanged="cityTo_SelectedIndexChanged" Width="150px" 
                AutoPostBack="True">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="RegionToLabel" runat="server" Text="Region to"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:DropDownList ID="regionTo" runat="server" Enabled="False" Width="150px">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="AddressToLabel" runat="server" Text="Address to"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:TextBox ID="addressTo" TextMode="MultiLine" Width="150px" runat="server"></asp:TextBox>
        </td>
    </tr>
</table>
