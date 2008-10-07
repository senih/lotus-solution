﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="booking.ascx.cs" Inherits="modules_booking" %>

<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:GridView ID="BookingsGridView" runat="server" SkinID="gridResults" 
            AutoGenerateColumns="False" 
            onselectedindexchanged="ResultsGridView_SelectedIndexChanged" 
            DataKeyNames="ID">
        <Columns>
            <asp:BoundField DataField="ID" HeaderText="ID" />
            <asp:BoundField DataField="User" HeaderText="User" />
            <asp:BoundField DataField="Service" HeaderText="Service" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:BoundField DataField="Date" HeaderText="Date" />
            <asp:CommandField ButtonType="Button" ShowSelectButton="true" SelectText="Details" />            
        </Columns>
        </asp:GridView>
        <asp:Panel ID="DetailsPanel" runat="server" Visible="false">
            <table>
                <tr>
                    <td valign="top">
                        <asp:DetailsView ID="DetailsView" runat="server" Height="50px" Width="125px">
                        </asp:DetailsView>
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td>
                        <asp:GridView ID="DetailsGridView" runat="server">
                        </asp:GridView>
                        <asp:Panel ID="ReplyPanel" runat="server" Visible="false">
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <asp:Button ID="BackButton" runat="server" Text="Back" 
                onclick="BackButton_Click" />
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
