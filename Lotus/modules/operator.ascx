<%@ Control Language="C#" AutoEventWireup="true" CodeFile="operator.ascx.cs" Inherits="modules_operator" %>
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        Time:
        <asp:Label ID="TimeLabel" runat="server"></asp:Label>
        <br /><br /><br />
        <asp:GridView ID="ResultsGridView" runat="server" SkinID="gridResults" 
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
                            <asp:TextBox ID="ReplyTextBox" runat="server" TextMode="MultiLine"></asp:TextBox>
                            <asp:Button ID="ReplyButton" runat="server" Text="Reply" 
                                onclick="ReplyButton_Click" />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <asp:Button ID="BackButton" runat="server" Text="Back" 
                onclick="BackButton_Click" />
        </asp:Panel>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="Timer1" />
    </Triggers>
</asp:UpdatePanel>
<asp:Timer ID="Timer1" runat="server">
</asp:Timer>




