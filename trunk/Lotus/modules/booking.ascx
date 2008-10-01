<%@ Control Language="C#" AutoEventWireup="true" CodeFile="booking.ascx.cs" Inherits="modules_booking" %>

<asp:Panel ID="AnonymousPanel" runat="server">
    <asp:Label ID="WelcomeLabel" runat="server" Text="Please login to book a ride"></asp:Label><br /><br />
    <asp:Login ID="BookingLogin" runat="server" PasswordRecoveryText="Password Recovery" 
        PasswordRecoveryUrl="~/password.aspx" TitleText="">
    </asp:Login>
</asp:Panel>

<asp:Panel ID="BookingPanel" runat="server" Visible="false">
    Booking description
</asp:Panel>

<asp:Panel ID="TaxiPanel" runat="server" Visible="false">
    <table style="width:100%">
        <tr>
            <td>
                Start</td>
            <td>
                &nbsp;</td>
            <td>
                
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                Destination</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                City:
            </td>
            <td>
                <asp:DropDownList ID="StartCityDropDownList" runat="server">
                    <asp:ListItem Text="Skopje" Value="Skopje"></asp:ListItem>
                    <asp:ListItem Text="Delcevo" Value="Delcevo"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
            </td>
            <td>
                &nbsp;</td>
            <td>
                City:</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Region:
            </td>
            <td>
                <asp:DropDownList ID="StartRegionDropDownList" runat="server">
                <asp:ListItem Text="Karpos" Value="Karpos"></asp:ListItem>
                <asp:ListItem Text="Centar" Value="Centar"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                
            </td>
            <td>
                &nbsp;</td>
            <td>
                Region:</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Address:
            </td>
            <td>
                <asp:TextBox ID="StartAddressTextBox" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ErrorMessage="Required field" ControlToValidate="StartAddressTextBox"></asp:RequiredFieldValidator>
            </td>
            <td>
                &nbsp;</td>
            <td>
                Address:</td>
            <td>
                <asp:TextBox ID="DestinationAddressTextBox" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="DestinationAddressTextBox" ErrorMessage="Required field"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Date:
            </td>
            <td>
                Date picker
            </td>
            <td></td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Time:
            </td>
            <td>
                <asp:DropDownList ID="HourDropDownList" runat="server">
                </asp:DropDownList>:
                <asp:DropDownList ID="MinutsDropDownList" runat="server">
                </asp:DropDownList>
            </td>
            <td>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Passengers:
            </td>
            <td>
                <asp:TextBox ID="PassengersTextBox" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Required field" ControlToValidate="PassengersTextBox">
                </asp:RequiredFieldValidator>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</asp:Panel>

<asp:Panel ID="AirportPanel" runat="server" Visible="false">
    Airport
</asp:Panel>

<asp:Panel ID="ChildrenPanel" runat="server" Visible="false">
    Children
</asp:Panel>

<asp:Panel ID="VIPPanel" runat="server" Visible="false">
    VIP
</asp:Panel>