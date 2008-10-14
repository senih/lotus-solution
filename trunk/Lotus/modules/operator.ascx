<%@ Control Language="C#" AutoEventWireup="true" CodeFile="operator.ascx.cs" Inherits="modules_operator" %>
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<div id="operator_module">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table style="width:100%">
            <tr>
                <td>
                    Time: <asp:Label ID="TimeLabel" runat="server"></asp:Label>
                </td>
                <td align="right">
                    <asp:RadioButtonList ID="OperatorRadioButtonList" runat="server" 
                        AutoPostBack="True" RepeatDirection="Horizontal" 
                        onselectedindexchanged="OperatorRadioButtonList_SelectedIndexChanged">
                        <asp:ListItem Selected="True" Value="active">Active bookings</asp:ListItem>
                        <asp:ListItem Value="archive">Archived bookings</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
        </table>
        <br />
        <asp:GridView ID="ResultsGridView" runat="server"
            AutoGenerateColumns="False" SkinID="gridResults"
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
        
        <asp:GridView ID="ArchivesGridView" Visible="false" runat="server" 
            AutoGenerateColumns="false" SkinID="gridResults" DataKeyNames="ID" 
            onselectedindexchanged="ArchivesGridView_SelectedIndexChanged">
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
                    <td valign="top">
                        <asp:GridView ID="DetailsGridView" SkinID="gridResults" runat="server">
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



