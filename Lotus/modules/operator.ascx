<%@ Control Language="C#" AutoEventWireup="true" CodeFile="operator.ascx.cs" Inherits="modules_operator" %>

<%@ Register assembly="EclipseWebSolutions.DatePicker" namespace="EclipseWebSolutions.DatePicker" tagprefix="cc1" %>

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
                        <asp:ListItem Value="users">Users</asp:ListItem>
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
        <asp:Panel ID="ArchivesPanel" runat="server" Visible="false">
            <table>
                <tr>
                    <td>User</td><td>Service</td><td>Date from</td><td>Date to</td>
                </tr>
                <tr>
                    <td>
                        <asp:DropDownList ID="UsersDropDownList" runat="server" Width="100px">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:DropDownList ID="ServiceDropDownList" runat="server" Width="100px">
                            <asp:ListItem Value="All" Text="All"></asp:ListItem>
                            <asp:ListItem Value="Taxi" Text="Taxi"></asp:ListItem>
                            <asp:ListItem Value="Airport" Text="Airport"></asp:ListItem>
                            <asp:ListItem Value="Children" Text="Children"></asp:ListItem>
                            <asp:ListItem Value="VIP" Text="VIP"></asp:ListItem>
                            <asp:ListItem Value="Pets" Text="Pets"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <cc1:DatePicker ID="FromDatePicker" runat="server" 
                            CalendarPosition="DisplayBelow" />
                    </td>
                    <td>
                        <cc1:DatePicker ID="ToDatePicker" runat="server" 
                            CalendarPosition="DisplayBelow" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                    <asp:Button ID="SearchButton" runat="server" onclick="SearchButton_Click" 
                        Text="Search" Width="100px" />
                    </td>
                    <td colspan="3">
                        <asp:Label ID="SearchResultsLabel" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
            <br /><br />
            <table>
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="PreviousLinkButton" runat="server" 
                            onclick="PreviousLinkButton_Click"><< Previous</asp:LinkButton>
                    </td>
                    <td align="right">
                        <asp:LinkButton ID="NextLinkButton" runat="server" 
                            onclick="NextLinkButton_Click">Next >></asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:GridView ID="ArchivesGridView" runat="server" 
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
                    </td>
                </tr>
            </table>
        </asp:Panel>
        
        <asp:GridView ID="UsersGridView" runat="server" SkinID="gridResults" 
            AutoGenerateColumns="False" DataKeyNames="UserName" 
            onselectedindexchanged="UsersGridView_SelectedIndexChanged" Visible="false" >
            <Columns>
                <asp:BoundField DataField="UserName" HeaderText="User" />
                <asp:BoundField DataField="Email" HeaderText="E-mail" />
                <asp:TemplateField HeaderText="Online">
                    <ItemTemplate>
                        <asp:RadioButton ID="RadioButton1" runat="server"
                            Checked='<%# Bind("IsOnline") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ButtonType="Button" ShowSelectButton="true" SelectText="Details" />
            </Columns>
        </asp:GridView>
        
        <br /><br />
        <asp:DetailsView ID="UserDetailsView" runat="server" Visible="false" AutoGenerateRows="false" Height="50px" Width="195px" 
                            CellPadding="4" ForeColor="#333333" GridLines="Horizontal">
                            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                            <CommandRowStyle BackColor="#C5BBAF" Font-Bold="True" />
                            <RowStyle BackColor="#E3EAEB" />
                            <FieldHeaderStyle BackColor="#D0D0D0" Font-Bold="True" />
                            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                            <EditRowStyle BackColor="#7C6F57" />
                            <AlternatingRowStyle BackColor="White"/>
            <Fields>
                <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                <asp:BoundField DataField="Company" HeaderText="Company" />
                <asp:BoundField DataField="Address" HeaderText="Address" />
                <asp:BoundField DataField="City" HeaderText="City" />
                <asp:BoundField DataField="Zip" HeaderText="Zip" />
                <asp:BoundField DataField="Country" HeaderText="First Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" />
            </Fields>
        </asp:DetailsView>
        
        <asp:Panel ID="DetailsPanel" runat="server" Visible="false">
            <table>
                <tr>
                    <td valign="top">
                        <asp:DetailsView ID="DetailsView" runat="server" Height="50px" Width="210px" 
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
                                    <asp:Button ID="BackButton" runat="server" onclick="BackButton_Click" 
                                        Text="Back" Width="100px" />
                                </td>
                                <td>
                                    <asp:Button ID="AcceptedButton" runat="server" Text="Accept" Width="100px" 
                                        onclick="AcceptedButton_Click" />                                    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="ChatLogButton" runat="server" Text="Chat log" Visible="False" 
                                        Width="100px" onclick="ChatLogButton_Click" />
                                </td>
                                <td>
                                    <asp:Button ID="DeclineButton" runat="server" Text="Decline" Width="100px" 
                                        onclick="DeclineButton_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="ChatButton" runat="server" Text="Chat" Visible="false" 
                                        Width="100px" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                        </table>

                    </td>
                    <td valign="top" align="center">
                        <asp:GridView ID="DetailsGridView" SkinID="gridResults" runat="server">
                        </asp:GridView><br /><br />
                        <asp:DataList ID="ChatLogDataList" runat="server" Visible="false">
                            <ItemTemplate>                
                                <asp:Label ID="Label1" runat="server" Text='<%# Container.DataItem %>'></asp:Label>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>

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



