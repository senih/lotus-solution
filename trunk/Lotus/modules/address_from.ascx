<%@ Control Language="C#" AutoEventWireup="true" CodeFile="address_from.ascx.cs" Inherits="modules_address" %>

<table>
    <tr>
        <td align="left">
            <asp:Label ID="CityFromLabel" runat="server" Text="City from"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:DropDownList ID="cityFrom" runat="server" 
                onselectedindexchanged="cityFrom_SelectedIndexChanged" Width="150px" 
                AutoPostBack="True">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="RegionFromLabel" runat="server" Text="Region from"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:DropDownList ID="regionFrom" runat="server" Enabled="False" Width="150px">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="AddressFromLabel" runat="server" Text="Address from"></asp:Label>
        </td>
        <td>&nbsp;:&nbsp;</td>
        <td>
            <asp:TextBox ID="addressFrom" TextMode="MultiLine" Width="150px" runat="server"></asp:TextBox>
        </td>
    </tr>
</table>
