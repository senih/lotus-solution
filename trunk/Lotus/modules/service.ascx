<%@ Control Language="C#" AutoEventWireup="true" CodeFile="service.ascx.cs" Inherits="modules_service" %>

<style type="text/css">
    .style1
    {
        width: 100%;
        border-style: solid;
        border-width: 3px;
    }
</style>

<asp:Panel ID="AnonymousPanel" runat="server" Visible="false">
    <asp:Label ID="WelcomeLabel" runat="server" Text="Please login to book a ride"></asp:Label><br /><br />
    <asp:Login ID="BookingLogin" runat="server" PasswordRecoveryText="Password Recovery" 
        PasswordRecoveryUrl="~/password.aspx" TitleText="">
    </asp:Login>
</asp:Panel>

<asp:Panel ID="AdministrationPanel" runat="server" Visible="false">
    <div class="admin_panel">
        <div class="admin_menu">
            <asp:RadioButtonList ID="OptionsRadioButtonList" runat="server" 
                AutoPostBack="True" 
                onselectedindexchanged="OptionsRadioButtonList_SelectedIndexChanged" 
                RepeatDirection="Horizontal">
                <asp:ListItem Selected="True">Edit</asp:ListItem>
                <asp:ListItem>Settings</asp:ListItem>
                <asp:ListItem>Preview</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <br />
        <div class="admin_options">
            <asp:Panel ID="AdminOptionsPanel" runat="server">
                <asp:Panel ID="EditPanel" runat="server">
                    <asp:GridView ID="FormControlsGridView" runat="server" 
                        AutoGenerateColumns="False" DataKeyNames="form_field_definition_id" 
                        SkinID="gridControls" Width="730px" 
                        onselectedindexchanged="FormControlsGridView_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="form_field_definition_id" HeaderText="Field ID" Visible="false" />
                            <asp:BoundField DataField="form_field_name" HeaderText="Field name" />
                            <asp:BoundField DataField="input_type" HeaderText="Input type" />
                            <asp:BoundField DataField="sorting" HeaderText="Sorting" />
                            <asp:BoundField DataField="width" HeaderText="Width" />
                            <asp:BoundField DataField="height" HeaderText="Height" />
                            <asp:BoundField DataField="default_value" HeaderText="Default value" />
                            <asp:BoundField DataField="page_id" HeaderText="Page ID" />
                            <asp:BoundField DataField="is_required" HeaderText="Required" />
                            <asp:CommandField ShowSelectButton="true" ButtonType="Link" />
                        </Columns>
                    </asp:GridView>
                    <br />
                    <hr style="width:730px" />
                    <br />
                    <table ID="ControlOptions" runat="server">
                        <tr>
                            <td>
                                Control Name
                            </td>
                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="ControlNameTextBox" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="ControlNameTextBox" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td >
                                Control type
                            </td>
                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <asp:DropDownList ID="ControlTypeDropDownList" runat="server" Width="205px" 
                                    AutoPostBack="True" 
                                    onselectedindexchanged="ControlTypeDropDownList_SelectedIndexChanged">
                                    <asp:ListItem Value="label">Label</asp:ListItem>
                                    <asp:ListItem Value="txtBox">Text Box</asp:ListItem>
                                    <asp:ListItem Value="txtArea">Text area</asp:ListItem>
                                    <asp:ListItem Value="ddList">Drop down list</asp:ListItem>
                                    <asp:ListItem Value="chkBox">Check box</asp:ListItem>
                                    <asp:ListItem Value="chkBoxList">Check box list</asp:ListItem>
                                    <asp:ListItem Value="radioBtnList">Radio button list</asp:ListItem>
                                    <asp:ListItem Value="datePicker">Date picker</asp:ListItem>
                                    <asp:ListItem Value="timePicker">Time picker</asp:ListItem>
                                    <asp:ListItem Value="addressCtrl">Address</asp:ListItem>                                    
                                </asp:DropDownList>
                            </td>
                            <td>
                                &nbsp;</td>
                            <td>
                                <asp:Panel ID="WidthPanel" runat="server" Visible="False">
                                    Width: 
                                    <asp:TextBox ID="WidthTextBox" runat="server" Width="50px"></asp:TextBox>
                                </asp:Panel>
                                <asp:LinkButton ID="AddValuesLinkButton" runat="server" 
                                    CausesValidation="False" onclick="AddValuesLinkButton_Click" 
                                    Visible="False">Edit values</asp:LinkButton>
                            </td>
                            <td>
                                <asp:DropDownList ID="ContainerDropDownList" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Sorting
                            </td>
                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="SortingTextBox" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="SortingTextBox" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Default value</td>
                            <td>
                                &nbsp;&nbsp;:&nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:TextBox ID="DefaultValueTextBox" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>
                                
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Is required
                            </td>
                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <asp:CheckBox ID="RequiredCheckBox" runat="server" />
                            </td>
                            <td></td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="AddControlButton" runat="server" 
                                    onclick="AddControlButton_Click" Text="Add Control" />
                                <asp:Button ID="UpdateControlButton" runat="server" 
                                    onclick="UpdateControlButton_Click" Text="Update Control" Visible="False" />
                            </td>
                            <td>
                                &nbsp;</td>
                            <td>
                                <asp:Button ID="DeleteControlButton" runat="server" 
                                    onclick="DeleteControlButton_Click" Text="Delete Control" Visible="False" />
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="CancelUpdateButton" runat="server" 
                                    onclick="CancelUpdateButton_Click" Text="Cancel" Visible="False" />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="ValuesPanel" runat="server" Visible="false">
                        <table>
                            <tr>
                                <td>
                                    Value:
                                </td>
                                <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="ValueTextBox" runat="server"></asp:TextBox>
                                </td>
                                <td>                            
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                        ErrorMessage="*" ControlToValidate="ValueTextBox"></asp:RequiredFieldValidator>                            
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Is default:
                                </td>
                                <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                <td>
                                    <asp:CheckBox ID="DefaultValueCheckBox" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="2">
                                    <asp:Button ID="AddValueButton" runat="server" Text="Add Value" 
                                        onclick="AddValueButton_Click" />
                                    <asp:Button ID="BackButton" runat="server" Text="Back" 
                                        onclick="BackButton_Click" CausesValidation="False" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </asp:Panel>
                <asp:Panel ID="SettingsPanel" runat="server" Visible="false">
                    settings
                </asp:Panel>
            </asp:Panel>
        </div>
    </div>
</asp:Panel>

<asp:Panel ID="LogedinPanel" runat="server" Visible="false">
    <asp:PlaceHolder ID="ControlsPlaceHolder" runat="server"></asp:PlaceHolder>
</asp:Panel>
