<%@ Control Language="C#" AutoEventWireup="true" CodeFile="service.ascx.cs" Inherits="modules_service" %>

<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<asp:Panel ID="AnonymousPanel" runat="server" Visible="false">
    
    <table style="width:720px;">
    <tr>
        <td style="width:50%;">
            <asp:Label ID="lblLogin" meta:resourcekey="lblLogin" runat="server" Text="Login" CssClass="subTitle"></asp:Label>
        </td>
        <td style="width:50%;">
           <asp:Label ID="lblRegister" runat="server" meta:resourcekey="lblRegister" Text="Create profile" CssClass="subTitle"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            
             <asp:Label ID="lblLogintxt" meta:resourcekey="lblLogintxt" runat="server" Text="If you have profile with us, please login below:"></asp:Label>
             <br />
        </td>
        <td rowspan="2">
            <asp:Label ID="lblregistertxt" meta:resourcekey="lblRegistertxt" runat="server" Text="Tuka treba da pishuva neshto kako Doklolku nemate profil, ve molime kreirajte so shto ke ni ovozmozite podobar, bla bla ..."></asp:Label>
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <asp:HyperLink ID="hlRegister" runat="server" meta:resourcekey="hlRegistertxt" NavigateUrl="~/register.aspx">Register</asp:HyperLink>
        </td>
    </tr>
    <tr>
        <td>

    <asp:Login ID="BookingLogin" runat="server" PasswordRecoveryText="Password Recovery" 
        PasswordRecoveryUrl="~/password.aspx" TitleText="">
    </asp:Login>
        </td>
    </tr>
</table>
</asp:Panel>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
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
                            <asp:BoundField DataField="div_id" HeaderText="Container" />
                            <asp:CommandField ShowSelectButton="true" ButtonType="Link" />
                        </Columns>
                    </asp:GridView>
                    <br />
                    <hr style="width:730px" />
                    <asp:LinqDataSource ID="LinqDataSource1" runat="server" 
                        ContextTypeName="Services.LotusDataContext" EnableDelete="True" 
                        EnableInsert="True" EnableUpdate="True" OrderBy="sorting" 
                        TableName="containers">
                    </asp:LinqDataSource>
                    <br />
                    <table ID="ControlOptions" runat="server">
                        <tr>
                            <td align="right">
                                Control Name
                            </td>
                            <td>&nbsp;:&nbsp;</td>
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
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Control type
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:DropDownList ID="ControlTypeDropDownList" runat="server" Width="205px" 
                                    AutoPostBack="True" 
                                    onselectedindexchanged="ControlTypeDropDownList_SelectedIndexChanged">
                                    <asp:ListItem Value="label">Label</asp:ListItem>
                                    <asp:ListItem Value="txtBox">Text box</asp:ListItem>
                                    <asp:ListItem Value="txtArea">Text area</asp:ListItem>
                                    <asp:ListItem Value="ddList">Drop down list</asp:ListItem>
                                    <asp:ListItem Value="chkBox">Check box</asp:ListItem>
                                    <asp:ListItem Value="chkBoxList">Check box list</asp:ListItem>
                                    <asp:ListItem Value="radioBtnList">Radio button list</asp:ListItem>
                                    <asp:ListItem Value="datePicker">Date picker</asp:ListItem>
                                    <asp:ListItem Value="timePicker">Time picker</asp:ListItem>
                                    <asp:ListItem Value="addressCtrl">Address</asp:ListItem>                                    
                                    <asp:ListItem Value="header">Header</asp:ListItem>
                                    <asp:ListItem Value="lblNoName">Label (without name)</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:LinkButton ID="AddValuesLinkButton" runat="server" 
                                    CausesValidation="False" onclick="AddValuesLinkButton_Click" Visible="False">Edit values</asp:LinkButton>
                            </td>
                            <td>
                                <asp:Panel ID="WidthPanel" runat="server" Visible="False">
                                    Width: 
                                    <asp:TextBox ID="WidthTextBox" runat="server" Width="50px"></asp:TextBox>
                                </asp:Panel>
                            </td>
                            <td>
                                &nbsp;</td>
                            <td>
                                Container:
                                <asp:DropDownList ID="ContainerDropDownList" runat="server" DataSourceID="LinqDataSource1" 
                                DataTextField="name" DataValueField="id">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Sorting
                            </td>
                            <td>&nbsp;:&nbsp;</td>
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
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Default value</td>
                            <td>
                                &nbsp;:&nbsp;
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
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Is required
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:CheckBox ID="RequiredCheckBox" runat="server" />
                            </td>
                            <td></td>
                            <td>
                            </td>
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
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="AddControlButton" runat="server" 
                                    onclick="AddControlButton_Click" Text="Add Control" />
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="UpdateControlButton" runat="server" 
                                    onclick="UpdateControlButton_Click" Text="Update Control" Visible="False" />

                            </td>
                            <td>
                                <asp:Button ID="DeleteControlButton" runat="server"
                                    onclick="DeleteControlButton_Click" Text="Delete Control" Visible="False" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="CancelUpdateButton" runat="server" 
                                    onclick="CancelUpdateButton_Click" Text="Cancel" Visible="False" />
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="ValuesPanel" runat="server" Visible="false">
                        <asp:LinqDataSource ID="LinqDataSource2" runat="server" 
                            ContextTypeName="Services.LotusDataContext" 
                            TableName="form_field_values" EnableDelete="True" EnableUpdate="True" 
                            OrderBy="form_field_value_id">
                        </asp:LinqDataSource>
                        <asp:GridView ID="ValuesGridView" runat="server" AutoGenerateColumns="False" 
                            DataKeyNames="form_field_value_id" DataSourceID="LinqDataSource2" 
                            SkinID="gridControls">
                            <Columns>
                                <asp:BoundField DataField="form_field_value_id" HeaderText="ID" InsertVisible="False" ReadOnly="True"/>
                                <asp:BoundField DataField="display_value" HeaderText="Value" />
                                <asp:CheckBoxField DataField="is_default" HeaderText="Default" />
                                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                            </Columns>
                        </asp:GridView>
                        <br />
                        <hr style="width:730px"/>
                        <br />
                        <table>
                            <tr>
                                <td>
                                    Value:
                                </td>
                                <td>&nbsp;:&nbsp;</td>
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
                                <td>&nbsp;:&nbsp;</td>
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
                    <asp:GridView ID="ContainersGridView" runat="server" SkinID="gridControls" 
                        AutoGenerateColumns="False" DataSourceID="LinqDataSource1" 
                        DataKeyNames="id">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="name" HeaderText="Name" />
                            <asp:BoundField DataField="sorting" HeaderText="Sorting" />
                            <asp:BoundField DataField="page_id" HeaderText="Page ID" ReadOnly="true" />
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                        </Columns>
                    </asp:GridView>
                    <br />
                    <hr style="width:730px"/>
                    <br />
                    <table>
                        <tr>
                            <td align="right">
                                Conteiner name
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:TextBox ID="ContainerNameTextBox" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ContainerNameTextBox"
                                 ErrorMessage="*" ValidationGroup="AddContainerButton"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Sorting
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:TextBox ID="ContainerSortingTextBox" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" 
                                ControlToValidate="ContainerSortingTextBox" 
                                    ValidationGroup="AddContainerButton"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:Button ID="AddContainerButton" runat="server" Text="Add Container" OnClick="AddContainerButton_Click" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <hr style="width:730px" />
                    <br />
                    <table>
                        <tr>
                            <td align="right">
                                Header
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:TextBox ID="HeaderTextBox" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Footer
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:TextBox ID="FooterTextBox" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Mail message:
                            </td>
                            <td>&nbsp;:&nbsp;</td>
                            <td>
                                <asp:TextBox ID="ThankYouTextBox" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td align="right">
                                <asp:Button ID="SaveSettingsButton" runat="server" Text="Save" 
                                    onclick="SaveSettingsButton_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </asp:Panel>
        </div>
    </div>
</asp:Panel>

<asp:Panel ID="LogedinPanel" runat="server" Visible="false">
    <asp:Panel ID="ThankYouPanel" runat="server" Visible="false">
            <asp:Label ID="ThankYouLabel" runat="server" Text="Thank you for using our services. 
            We recived your booking and soon our operartor will contact you."></asp:Label>
    </asp:Panel>
    <asp:Panel ID="SubmitPanel" runat="server">
    <div id="form">
        <table>
        <tr>
            <td>
                <div class="form_header">
                    <asp:Label ID="HeaderLabel" runat="server"></asp:Label>
                </div>
            </td>
        </tr>
        <tr>
        <td>
            <asp:PlaceHolder ID="ControlsPlaceHolder" runat="server"></asp:PlaceHolder>
        </td>
        </tr>
        <tr>
            <td>
                <div class="form_footer">
                    <asp:Label ID="FooterLabel" runat="server"></asp:Label>
                </div>
            </td>
        </tr>
        <tr>
        <td align="right">
            <asp:Button ID="SubmitButton" runat="server" Text="Submit booking" 
                onclick="SubmitButton_Click" />
            <asp:LinkButton ID="SubmitTaxiButton" runat="server" Visible="false"
                onclick="SubmitTaxiButton_Click">Submit booking</asp:LinkButton>
        </td>
        </tr>
        </table>
    </div>
    </asp:Panel>
</asp:Panel>
</ContentTemplate>
</asp:UpdatePanel>