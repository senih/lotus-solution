<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nProductTypeId As Integer
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(GetUser) Then
            panelProductTypes.Visible = False
            panelProductProperties.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelProductTypes.Visible = True
                panelProductProperties.Visible = False
                panelLogin.Visible = False
                
                SqlDataSource1.ConnectionString = sConn
                SqlDataSource1.SelectCommand = "SELECT * FROM [product_types] order by product_type_id desc"
                SqlDataSource1.DeleteCommand = "DELETE FROM [product_types] WHERE [product_type_id] = @product_type_id"
                SqlDataSource1.UpdateCommand = "UPDATE [product_types] SET [description] = @description WHERE [product_type_id] = @product_type_id"
           
                If Not IsNothing(Request.QueryString("ptid")) Then
                    panelProductProperties.Visible = True
                    panelProductTypes.Visible = False
                    
                    nProductTypeId = Request.QueryString("ptid")
                    
                    Dim oReader As SqlDataReader
                    Dim oCommand As SqlCommand = New SqlCommand
                    oCommand.Connection = oConn
                    oCommand.CommandText = "SELECT * FROM product_types WHERE product_type_id=" & nProductTypeId
                    oCommand.Parameters.Add("@description", SqlDbType.NVarChar).Value = txtDescription.Text
                    oConn.Open()
                    oReader = oCommand.ExecuteReader
                    If oReader.Read Then
                        lblProductType.Text = oReader("description")
                    End If
                    oCommand.Dispose()
                    oConn.Close()

                    SqlDataSource2.ConnectionString = sConn
                    SqlDataSource2.SelectCommand = "SELECT * FROM [product_property_definition] WHERE product_type_id=" & nProductTypeId & " order by product_property_id"
                    SqlDataSource2.DeleteCommand = "DELETE FROM [product_property_definition] WHERE [product_property_id] = @product_property_id"
                    SqlDataSource2.UpdateCommand = "UPDATE [product_property_definition] SET [product_property_name]=@product_property_name, [display_name]=@display_name, input_type=@input_type, default_value=@default_value, value1_name=@value1_name, value1_input_type=@value1_input_type, value2_name=@value2_name, value2_input_type=@value2_input_type, value3_name=@value3_name, value3_input_type=@value3_input_type, sorting=@sorting, display_in_product_listing=@display_in_product_listing WHERE [product_property_id] = @product_property_id"
                End If
                
            End If
        End If
    End Sub

    Protected Sub btnAddProductType_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oCommand As SqlCommand = New SqlCommand
        oCommand.Connection = oConn
        oCommand.CommandText = "INSERT INTO product_types ([description]) VALUES (@description)"
        oCommand.Parameters.Add("@description", SqlDbType.NVarChar).Value = txtDescription.Text
        oConn.Open()
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()

        'refresh grid view
        gvProductTypes.DataBind()
        txtDescription.Text = ""
    End Sub

    Protected Sub gvProductTypes_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvProductTypes.Rows.Count - 1
            Try
                CType(gvProductTypes.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub
    
    Protected Sub gvProductTypes_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        gvProductTypes.DataBind()
    End Sub

    Protected Sub gvProductTypes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkShopProductTypes & "?ptid=" & gvProductTypes.SelectedDataKey.Value.ToString)
    End Sub

    Protected Sub gvProductProperties_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm2") & "')){return true;}else {return false;}"
        For i = 0 To gvProductProperties.Rows.Count - 1
            Try
                CType(gvProductProperties.Rows(i).Cells(9).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub

    Protected Sub gvProductProperties_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        gvProductProperties.DataBind()
    End Sub
        
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkShopProductTypes)
    End Sub

    Protected Sub gvProductProperties_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim bDelete As Boolean = True
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        oCmd.Connection = oConn
       
        oCmd.CommandText = "DELETE FROM [product_property_values] WHERE [product_property_id] = @product_property_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@product_property_id", SqlDbType.Int).Value = e.Keys(0)
        oCmd.ExecuteNonQuery()
        
        oCmd.Dispose()
        oConn.Close()
        gvProductProperties.DataBind()
    End Sub

    Protected Sub gvProductProperties_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs)
        SqlDataSource2.UpdateParameters(1).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("ddlInputType"), DropDownList).SelectedValue
        SqlDataSource2.UpdateParameters(1).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("txtPropertyName"), TextBox).Text
        
        SqlDataSource2.UpdateParameters(3).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("txtValue1Name"), TextBox).Text
        SqlDataSource2.UpdateParameters(5).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("txtValue2Name"), TextBox).Text
        SqlDataSource2.UpdateParameters(7).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("txtValue3Name"), TextBox).Text
        
        SqlDataSource2.UpdateParameters(4).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("ddlInputType1"), DropDownList).SelectedValue
        SqlDataSource2.UpdateParameters(6).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("ddlInputType2"), DropDownList).SelectedValue
        SqlDataSource2.UpdateParameters(8).DefaultValue = CType(gvProductProperties.Rows(e.RowIndex).FindControl("ddlInputType3"), DropDownList).SelectedValue
    End Sub

    Protected Sub gvProductProperties_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs)
        'If (CType(gvProductProperties.Rows(e.NewEditIndex).Cells(1).Controls(0), DataBoundLiteralControl).Text = "Slection") Then
        '    gvProductProperties.Rows(e.NewEditIndex).Cells(2).Visible = False
        'End If
    End Sub
    
    Function ShowField(ByVal sName As String, ByVal sType As String) As String
        If sName = "" Then
            Return ""
        Else
            If sType = "" Then
                Return sName
            Else
                Return sName & " (" & sType & ")"
            End If
        End If
    End Function

    Protected Sub btnAddProperty_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oCommand As SqlCommand = New SqlCommand
        oCommand.Connection = oConn
        oCommand.CommandText = "INSERT INTO product_property_definition (product_property_name,display_name,input_type,default_value,value1_name,value2_name,value3_name,value1_input_type,value2_input_type,value3_input_type,sorting,product_type_id,display_in_product_listing) VALUES (@product_property_name,@display_name,@input_type,@default_value,@value1_name,@value2_name,@value3_name,@value1_input_type,@value2_input_type,@value3_input_type,@sorting,@product_type_id,@display_in_product_listing)"
        oCommand.Parameters.Add("@product_property_name", SqlDbType.NVarChar).Value = txtProperty.Text
        oCommand.Parameters.Add("@input_type", SqlDbType.NVarChar).Value = dropPropertyType.SelectedValue
        oCommand.Parameters.Add("@display_name", SqlDbType.NVarChar).Value = txtDisplayName.Text
        oCommand.Parameters.Add("@default_value", SqlDbType.NVarChar).Value = txtDefaultValue.Text
        oCommand.Parameters.Add("@value1_name", SqlDbType.NVarChar).Value = txtOptionalField1.Text
        oCommand.Parameters.Add("@value2_name", SqlDbType.NVarChar).Value = txtOptionalField2.Text
        oCommand.Parameters.Add("@value3_name", SqlDbType.NVarChar).Value = txtOptionalField3.Text
        oCommand.Parameters.Add("@value1_input_type", SqlDbType.NVarChar).Value = dropOptionalField1Type.Text
        oCommand.Parameters.Add("@value2_input_type", SqlDbType.NVarChar).Value = dropOptionalField2Type.Text
        oCommand.Parameters.Add("@value3_input_type", SqlDbType.NVarChar).Value = dropOptionalField3Type.Text
        oCommand.Parameters.Add("@sorting", SqlDbType.Int).Value = txtSorting.Text
        oCommand.Parameters.Add("@product_type_id", SqlDbType.Int).Value = nProductTypeId
        oCommand.Parameters.Add("@display_in_product_listing", SqlDbType.Bit).Value = chkIsOnList.Checked
        oConn.Open()
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()

        'refresh grid view
        gvProductProperties.DataBind()
        txtProperty.Text = ""
        txtDisplayName.Text = ""
        dropPropertyType.SelectedValue = "Text"
        txtDefaultValue.Text = ""
        txtOptionalField1.Text = ""
        txtOptionalField2.Text = ""
        txtOptionalField3.Text = ""
        dropOptionalField1Type.SelectedValue = "Short Text"
        dropOptionalField2Type.SelectedValue = "Short Text"
        dropOptionalField3Type.SelectedValue = "Short Text"
        txtSorting.Text = ""
    End Sub

</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelProductTypes" runat="server">

    <asp:GridView ID="gvProductTypes" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server" 
          AllowPaging="false" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="product_type_id" DataSourceID="SqlDataSource1" OnRowDeleted="gvProductTypes_RowDeleted" OnPreRender="gvProductTypes_PreRender" OnSelectedIndexChanged="gvProductTypes_SelectedIndexChanged">
      <Columns>
        <asp:BoundField meta:resourcekey="lblDescription" DataField="description" ItemStyle-Wrap=false HeaderText="Description" SortExpression="description" />
        <asp:CommandField meta:resourcekey="lblProperties" SelectText="Properties" ShowSelectButton="true" />
        <asp:CommandField meta:resourcekey="lblEdit" EditText="Edit" ShowEditButton="True" />
        <asp:CommandField meta:resourcekey="lblDelete" DeleteText="Delete" ShowDeleteButton="True" />
      </Columns>
    </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>">
      <UpdateParameters>
        <asp:Parameter Name="description" Type="String" />
      </UpdateParameters>
    </asp:SqlDataSource>
    <div style="margin:15px"></div>
    <table>
    <tr>
        <td><%=GetLocalResourceObject("Description")%></td>
        <td>:</td>
        <td>
        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rv" runat="server" ErrorMessage="*" ControlToValidate="txtDescription" ValidationGroup="ProductType"></asp:RequiredFieldValidator>
        </td>
    </tr>
    </table>
    <div style="margin:5px"></div>
    <asp:Button ID="btnAddProductType" runat="server" meta:resourcekey="btnAddProductType" Text="Add Product Type" ValidationGroup="ProductType" OnClick="btnAddProductType_Click" />

</asp:Panel>

<asp:Panel ID="panelProductProperties" runat="server" Visible="false">
    <asp:Label ID="lblProductTypeLabel" runat="server" Text="Product Type:"></asp:Label> <asp:Label ID="lblProductType" runat="server" Font-Bold="true" Text=""></asp:Label>
    <div style="margin:15px"></div>
    <asp:GridView ID="gvProductProperties" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server" 
          AllowPaging="false" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="product_property_id" DataSourceID="SqlDataSource2" OnPreRender="gvProductProperties_PreRender" OnRowDeleted="gvProductProperties_RowDeleted" OnRowDeleting="gvProductProperties_RowDeleting" OnRowUpdating="gvProductProperties_RowUpdating" OnRowEditing="gvProductProperties_RowEditing">
      <Columns>
        <asp:TemplateField meta:resourcekey="lblProperty" HeaderText="Property" ItemStyle-Wrap="false" HeaderStyle-VerticalAlign="Top">
            <ItemTemplate>
            <%#ShowField(Eval("product_property_name"), Eval("input_type", ""))%>
            </ItemTemplate>
            <EditItemTemplate>
            <asp:TextBox ID="txtPropertyName" runat="server" Width="70" Text='<%#Bind("product_property_name")%>'></asp:TextBox>
            <asp:DropDownList runat="server" ID="ddlInputType" selectedValue='<%#Bind("input_type")%>'>
            <asp:ListItem Text="Text" Value="Text"></asp:ListItem>
            <asp:ListItem Text="Selection" Value="Selection"></asp:ListItem>
            </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:BoundField meta:resourcekey="lblDisplayName" DataField="display_name" ControlStyle-Width="70" ItemStyle-Wrap=false HeaderStyle-VerticalAlign="Top" HeaderText="Display Name" />
        <asp:BoundField meta:resourcekey="lblDefaultValue" DataField="default_value" ControlStyle-Width="70" ItemStyle-Wrap=false HeaderStyle-VerticalAlign="Top" HeaderText="Default Value" />
        <asp:BoundField meta:resourcekey="lblSorting" DataField="sorting" ControlStyle-Width="30" ItemStyle-Wrap=false HeaderStyle-VerticalAlign="Top" HeaderText="Sorting" />
        <asp:CheckBoxField meta:resourcekey="lblDisplayInProdList" DataField="display_in_product_listing" ControlStyle-Width="30" ItemStyle-Wrap=false HeaderStyle-VerticalAlign="Top" HeaderText="Listing Display" />
        <asp:TemplateField meta:resourcekey="lblOptionalField1" HeaderText="Optional Field1" ItemStyle-Wrap="false" HeaderStyle-VerticalAlign="Top">
            <ItemTemplate>
            <%#ShowField(Eval("value1_name", ""),Eval("value1_input_type", ""))%>
            </ItemTemplate>
            <EditItemTemplate>
            <asp:TextBox ID="txtValue1Name" runat="server" Width="70" Text='<%#Bind("value1_name")%>'></asp:TextBox>
            <asp:DropDownList runat="server" ID="ddlInputType1" selectedValue='<%#Bind("value1_input_type")%>'>
            <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
            <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField meta:resourcekey="lblOptionalField2" HeaderText="Optional Field2" ItemStyle-Wrap="false" HeaderStyle-VerticalAlign="Top">
            <ItemTemplate>
            <%#ShowField(Eval("value2_name", ""), Eval("value2_input_type", ""))%>
            </ItemTemplate>
            <EditItemTemplate>
            <asp:TextBox ID="txtValue2Name" runat="server" Width="70" Text='<%#Bind("value2_name")%>'></asp:TextBox>
            <asp:DropDownList runat="server" ID="ddlInputType2" selectedValue='<%#Bind("value2_input_type")%>'>
            <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
            <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField meta:resourcekey="lblOptionalField3" HeaderText="Optional Field3" ItemStyle-Wrap="false" HeaderStyle-VerticalAlign="Top">
            <ItemTemplate>
            <%#ShowField(Eval("value3_name", ""),Eval("value3_input_type", ""))%>
            </ItemTemplate>
            <EditItemTemplate>
            <asp:TextBox ID="txtValue3Name" runat="server" Width="70" Text='<%#Bind("value3_name")%>'></asp:TextBox>
            <asp:DropDownList runat="server" ID="ddlInputType3" selectedValue='<%#Bind("value3_input_type")%>'>
            <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
            <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:CommandField meta:resourcekey="lblEdit" EditText="Edit" ShowEditButton="True" />
        <asp:CommandField meta:resourcekey="lblDelete" DeleteText="Delete" ShowDeleteButton="True" />
      </Columns>
    </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>">
      <UpdateParameters>
        <asp:Parameter Name="product_property_name" Type="String" />
        <asp:Parameter Name="input_type" Type="String" />
        <asp:Parameter Name="default_value" Type="String" />
        <asp:Parameter Name="value1_name" Type="String" />
        <asp:Parameter Name="value1_input_type" Type="String" />
        <asp:Parameter Name="value2_name" Type="String" />
        <asp:Parameter Name="value2_input_type" Type="String" />
        <asp:Parameter Name="value3_name" Type="String" />
        <asp:Parameter Name="value3_input_type" Type="String" />
        <asp:Parameter Name="sorting" Type="Int32" />
        <asp:Parameter Name="display_in_product_listing" Type="Boolean" />        
      </UpdateParameters>
    </asp:SqlDataSource>    
    <div style="margin:15px"></div>
    <table>
    <tr>
        <td><asp:Label ID="lblPropertyLabel" meta:resourcekey="lblPropertyLabel" runat="server" Text="Property"></asp:Label></td><td>:</td>
        <td>
            <asp:TextBox ID="txtProperty" runat="server"></asp:TextBox>
            <asp:DropDownList runat="server" ID="dropPropertyType">
            <asp:ListItem Text="Text" Value="Text"></asp:ListItem>
            <asp:ListItem Text="Selection" Value="Selection"></asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="New" ControlToValidate="txtProperty" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblDisplayNameLabel" meta:resourcekey="lblDisplayNameLabel" runat="server" Text="Display Name"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtDisplayName" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblDefaultValueLabel" meta:resourcekey="lblDefaultValueLabel" runat="server" Text="Default Value"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtDefaultValue" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblSortingLabel" meta:resourcekey="lblSortingLabel" runat="server" Text="Sorting"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtSorting" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtSorting" ValidationGroup="New" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblIsOnList" meta:resourcekey="lblIsOnList" runat="server" Text="Display in Product Listing"></asp:Label></td><td>:</td>
        <td>
            <asp:CheckBox ID="chkIsOnList" Checked="true" runat="server" />
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblOptionalField1Label" meta:resourcekey="lblOptionalField1Label" runat="server" Text="Optional Field1"></asp:Label></td><td>:</td>
        <td>
            <asp:TextBox ID="txtOptionalField1" runat="server"></asp:TextBox>
            <asp:DropDownList ID="dropOptionalField1Type" runat="server">
                <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
                <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblOptionalField2Label" meta:resourcekey="lblOptionalField2Label" runat="server" Text="Optional Field2"></asp:Label></td><td>:</td>
        <td>
            <asp:TextBox ID="txtOptionalField2" runat="server"></asp:TextBox>
            <asp:DropDownList ID="dropOptionalField2Type" runat="server">
                <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
                <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblOptionalField3Label" meta:resourcekey="lblOptionalField3Label" runat="server" Text="Optional Field3"></asp:Label></td><td>:</td>
        <td>
            <asp:TextBox ID="txtOptionalField3" runat="server"></asp:TextBox>
            <asp:DropDownList ID="dropOptionalField3Type" runat="server">
                <asp:ListItem Text="Short Text" Value="Short Text"></asp:ListItem>
                <asp:ListItem Text="Long Text" Value="Long Text"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    </table>
    <div style="margin:5px"></div>
    <asp:Button ID="btnAddProperty" runat="server" meta:resourcekey="btnAddProperty"  ValidationGroup="New" Text="Add Property" OnClick="btnAddProperty_Click" />
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text=" Back " CausesValidation="false" OnClick="btnBack_Click" />
</asp:Panel>
