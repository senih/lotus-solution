﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="operator.ascx.cs" Inherits="modules_operator" %>
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<div id="operator_module">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        Time:
        <asp:Label ID="TimeLabel" runat="server"></asp:Label>
        <br /><br /><br />
        <asp:GridView ID="ResultsGridView" runat="server"
            AutoGenerateColumns="False" 
            onselectedindexchanged="ResultsGridView_SelectedIndexChanged" 
            DataKeyNames="ID" CellPadding="4" ForeColor="#333333" GridLines="Horizontal">
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <Columns>
            <asp:BoundField DataField="ID" HeaderText="ID" />
            <asp:BoundField DataField="User" HeaderText="User" />
            <asp:BoundField DataField="Service" HeaderText="Service" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:BoundField DataField="Date" HeaderText="Date" />
            <asp:CommandField ButtonType="Button" ShowSelectButton="true" SelectText="Details" />            
        </Columns>
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <EditRowStyle BackColor="#999999" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
        <asp:Panel ID="DetailsPanel" runat="server" Visible="false">
            <table>
                <tr>
                    <td valign="top">
                        <asp:DetailsView ID="DetailsView" runat="server" Height="50px" Width="195px" 
                            CellPadding="4" ForeColor="#333333" GridLines="Horizontal">
                            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                            <CommandRowStyle BackColor="#C5BBAF" Font-Bold="True" />
                            <RowStyle BackColor="#E3EAEB" />
                            <FieldHeaderStyle BackColor="#D0D0D0" Font-Bold="True" />
                            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                            <EditRowStyle BackColor="#7C6F57" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:DetailsView>
                        <br />
                        <table>
                            <tr>
                                <td valign="top">
                                    <asp:Button ID="BackButton" runat="server" onclick="BackButton_Click" Text="Back" />
                                </td>
                                <td>
                                    <asp:Button ID="AcceptedButton" runat="server" Text="Accept" Width="100px" 
                                        onclick="AcceptedButton_Click" />                                    
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="DeclineButton" runat="server" Text="Decline" Width="100px" 
                                        onclick="DeclineButton_Click" />
                                </td>
                            </tr>
                        </table>

                    </td>
                    <td>
                        <asp:GridView ID="DetailsGridView" runat="server" CellPadding="4" 
                            ForeColor="#333333" GridLines="Horizontal">
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <EditRowStyle BackColor="#999999" />
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:Panel ID="ReplyPanel" runat="server" Visible="false">
                            <table>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="ReplyTextBox" runat="server" TextMode="MultiLine" 
                                            Width="295px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Button ID="ReplyButton" runat="server" Text="Reply" onclick="ReplyButton_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="Timer1" />
    </Triggers>
</asp:UpdatePanel>
<asp:Timer ID="Timer1" runat="server" Interval="30000">
</asp:Timer>
</div>



