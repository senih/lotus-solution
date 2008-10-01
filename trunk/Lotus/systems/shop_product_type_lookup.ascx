<%@ Control Language="VB" AutoEventWireup="false" CodeFile="shop_product_type_lookup.ascx.vb" Inherits="systems_product_type_lookup" %>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="pnlProdType" runat="server">    
    <asp:Label ID="lblSelectProductType" meta:resourcekey="lblSelectProductType" runat="server" Text="Select Product Type:">
    </asp:Label>&nbsp;
    <asp:DropDownList ID="ddProdType" runat="server" AutoPostBack=true>
    </asp:DropDownList>
    <br><br>
    <asp:GridView ID="grdTypeProp" runat="server" AutoGenerateColumns=false HeaderStyle-HorizontalAlign="left" RowStyle-HorizontalAlign="left" CellPadding="7" GridLines=None >
        <Columns >
            <asp:TemplateField meta:resourcekey="lblLookup" HeaderText="Lookup">
                <ItemTemplate >
                    <a href="<%#GetcurrentPage() & "?propid=" & eval("product_property_id") %>"><%#Eval("product_property_name")%></a>
                </ItemTemplate>
            </asp:TemplateField>
            
            <%--
            <asp:BoundField DataField="sorting" headerText="Sorting" ItemStyle-HorizontalAlign="center"/>
            <asp:BoundField DataField="default_value" headerText="Default"/>
            <asp:BoundField DataField="value1_name" headerText="Value 1 Name" />
            <asp:BoundField DataField="value2_name" headerText="Value 2 Name"/>
            <asp:BoundField DataField="value3_name" headerText="Value 3 Name"/>
            <asp:BoundField DataField="value1_input_type" headerText="Input Type 1" />
            <asp:BoundField DataField="value2_input_type" headerText="Input Type 2"/>
            <asp:BoundField DataField="value3_input_type" headerText="Input Type 3"/>
            --%>
            
        </Columns>

    </asp:GridView>

</asp:Panel>

<asp:Panel ID="pnlLookup" runat="server" Visible=false Width="100%">

    <asp:Label ID="lblPropertyName" runat="server" Font-Bold=true Text=""></asp:Label>
    <br /><br />
    <asp:HyperLink runat="server" ID="lnkNew" meta:resourcekey="lnkNew" Text="Add New"></asp:HyperLink>
    <div style="margin:15px"></div>
    <asp:GridView ID="grdLookups" runat="server" AutoGenerateColumns=false HeaderStyle-HorizontalAlign="left" RowStyle-HorizontalAlign="left" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 AllowPaging=true PageSize=10 Width="100%" PagerSettings-Mode="NumericFirstLast">
        <Columns>
            <asp:BoundField DataField="code" HeaderText="Code" ItemStyle-VerticalAlign="top" />
            <asp:BoundField DataField="display_value" HeaderText ="Name" ItemStyle-VerticalAlign="top"/>
            <asp:BoundField DataField="value1" HeaderText ="Name" ItemStyle-VerticalAlign="top"/>
            <asp:BoundField DataField="value2" HeaderText ="Name" ItemStyle-VerticalAlign="top"/>
            <asp:BoundField DataField="value3" HeaderText ="Name" ItemStyle-VerticalAlign="top"/>
            <asp:BoundField DataField="is_default" HeaderText ="Is Default" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top"/>
            <asp:TemplateField ItemStyle-Wrap="true" ItemStyle-VerticalAlign="top">
                <ItemTemplate>
                    <a href="<%#GetcurrentPage() & "?mode=edit&propid=" & eval("product_property_id") & "&code=" & eval("code") %>">Edit</a>
                    <a href="<%#GetcurrentPage() & "?mode=del&propid=" & eval("product_property_id") & "&code=" & eval("code") %>">Delete</a>
                </ItemTemplate>
            </asp:TemplateField>            
        </Columns>
    </asp:GridView>
    <div style="margin:15px"></div>
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text=" Back " CausesValidation="false" OnClick="btnBack_Click" />
</asp:Panel>

<asp:Panel ID="pnlCreate" runat="server" Width="100%" Visible=false >
    <asp:HiddenField ID="hdPropId"  runat="server" Value="" />
    <asp:HiddenField ID="hidCode" runat="server" />
    <asp:table runat="server" Width="100%" ID="tabCreate">
        <asp:TableRow>
            <asp:TableCell Width="100px" VerticalAlign=Top ><asp:Literal ID="litCode" meta:resourcekey="litCode" Text="Code" runat="server"></asp:Literal></asp:TableCell>
            <asp:TableCell Width="10px" Text=":"  VerticalAlign=Top></asp:TableCell>
            <asp:TableCell>                
                <asp:TextBox runat="server" ID="txtCode"></asp:TextBox>
            </asp:TableCell>
        </asp:TableRow>
        
        <asp:TableRow>
            <asp:TableCell  VerticalAlign=Top><asp:Literal runat="server" ID="litDispVal"></asp:Literal></asp:TableCell>
            <asp:TableCell  VerticalAlign=Top Text=":"></asp:TableCell>
            <asp:TableCell>
                <asp:TextBox runat="server" ID="txtDispVal"></asp:TextBox>
            </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow ID="trVal1">
            <asp:TableCell  VerticalAlign=Top><asp:Literal runat="server" ID="litVal1"></asp:Literal></asp:TableCell>
            <asp:TableCell  VerticalAlign=Top Text=":"></asp:TableCell>
            <asp:TableCell>
                <asp:TextBox runat="server" ID="txtVal1"></asp:TextBox>
            </asp:TableCell>
        </asp:TableRow>
        
        <asp:TableRow ID="trVal2">
            <asp:TableCell VerticalAlign=Top><asp:Literal runat="server" ID="litVal2"></asp:Literal></asp:TableCell>
            <asp:TableCell VerticalAlign=Top Text=":"></asp:TableCell>
            <asp:TableCell>
                <asp:TextBox runat="server" ID="txtVal2"></asp:TextBox>
            </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow ID="trVal3">
            <asp:TableCell VerticalAlign=Top><asp:Literal runat="server" ID="litVal3"></asp:Literal></asp:TableCell>
            <asp:TableCell VerticalAlign=Top Text=":"></asp:TableCell>
            <asp:TableCell>
                <asp:TextBox runat="server" ID="txtVal3"></asp:TextBox>
            </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
            <asp:TableCell VerticalAlign=Top><asp:Literal ID="litIsDefault" meta:resourcekey="litIsDefault" Text="Is Default" runat="server"></asp:Literal></asp:TableCell>
            <asp:TableCell VerticalAlign=Top Text=":"></asp:TableCell>
            <asp:TableCell>
                <asp:CheckBox runat="server" ID="chkIsDefault" />
            </asp:TableCell>
        </asp:TableRow>
        
        <asp:TableRow >
            <asp:TableCell ColumnSpan=2>&nbsp;</asp:TableCell>
            <asp:TableCell>
                <br>
                <asp:Button id="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Create " />
                <asp:Button id="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" Save " Visible=false/>
                <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " />            
            </asp:TableCell>
        </asp:TableRow>
    </asp:table>
</asp:Panel>
