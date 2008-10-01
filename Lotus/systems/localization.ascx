<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat=server>
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelSites.Visible = True
                
                SqlDataSource1.ConnectionString = sConn
                SqlDataSource1.SelectCommand = "SELECT * FROM [locales] order by description"
                SqlDataSource1.DeleteCommand = "SELECT * FROM [locales] order by description"
                SqlDataSource1.UpdateCommand = "UPDATE [locales] SET [description] = @description, [instruction_text] = @instruction_text, [culture] = @culture, [active] = @active WHERE [locale_id] = @locale_id"
            
                Dim oList As ListItem
                Dim oChannelManager As ChannelManager = New ChannelManager
                Dim oDataReader As SqlDataReader
                oDataReader = oChannelManager.GetChannels()
                Do While oDataReader.Read()
                    oList = New ListItem
                    oList.Value = oDataReader("channel_id").ToString
                    oList.Text = oDataReader("channel_name").ToString
                    dropChannels.Items.Add(oList)
                Loop
                oDataReader.Close()
                oDataReader = Nothing
                oChannelManager = Nothing
        
                'Dim oList As ListItem
                Dim ci As System.Globalization.CultureInfo
                For Each ci In System.Globalization.CultureInfo.GetCultures(System.Globalization.CultureTypes.SpecificCultures)
                    oList = New ListItem
                    oList.Text = ci.EnglishName.ToString
                    oList.Value = ci.Name.ToString
                    dropCultures.Items.Add(oList)
                Next ci
                dropCultures.SelectedValue = "en-US"
            
            End If
        End If
    End Sub

    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        GridView1.PageIndex = e.NewPageIndex
    End Sub

    Protected Sub GridView1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.PreRender
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For k As Integer = 0 To GridView1.Rows.Count - 1
            If GridView1.Rows.Item(k).Cells(0).Text = Me.RootFile Or GridView1.Rows.Item(k).Cells(0).Text = "default.aspx" Then
                'GridView1.Rows.Item(k).Cells(7).Visible = False
                GridView1.Rows.Item(k).Cells(6).Enabled = False
            Else
                Try
                    
                    CType(GridView1.Rows(k).Cells(6).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
                Catch ex As Exception
                End Try
            End If
        Next k
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sHomePage As String = ""
        Dim nLocaleId As Integer = GridView1.DataKeys.Item(e.RowIndex).Value

        oCommand = New SqlCommand("advcms_DeleteLocale") 'Working
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@locale_id", SqlDbType.Int).Value = nLocaleId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        If Not oDataReader.Read() Then
            'deleted
            Response.Redirect(Me.LinkAdminLocalization)
        Else
            lblStatus.Text = "Delete Failed. The Home Page has one or more sub pages."
        End If
    End Sub

    Protected Sub GridView1_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles GridView1.RowEditing
        lblStatus.Text = ""
    End Sub

    Protected Sub GridView1_RowUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdatedEventArgs) Handles GridView1.RowUpdated
        Response.Redirect(Me.LinkAdminLocalization)
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Response.Redirect(GridView1.Rows.Item(GridView1.SelectedIndex).Cells(0).Text) 'Go To
    End Sub

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oContentManager As ContentManager = New ContentManager
        If oContentManager.IsContentExist(txtHomePage.Text & ".aspx") Then
            'File exists
            lblFileExistsLabel.Visible = True
            oContentManager = Nothing
            Exit Sub
        Else
            lblFileExistsLabel.Visible = False
        End If
        oContentManager = Nothing
        
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        oCmd.Connection = oConn

        oCmd = New SqlCommand("advcms_InsertLocale")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@home_page", SqlDbType.NVarChar, 50).Value = txtHomePage.Text & ".aspx"
        oCmd.Parameters.Add("@description", SqlDbType.NVarChar, 255).Value = txtDescription.Text
        oCmd.Parameters.Add("@instruction_text", SqlDbType.NVarChar, 255).Value = txtInstruction.Text
        oCmd.Parameters.Add("@culture", SqlDbType.NVarChar, 50).Value = dropCultures.SelectedValue 'txtCulture.Text
        oCmd.Parameters.Add("@channel_id", SqlDbType.Int).Value = dropChannels.SelectedValue
        oCmd.Parameters.Add("@active", SqlDbType.Bit).Value = chkActive.Checked
        oCmd.Parameters.Add("@site_name", SqlDbType.NVarChar, 50).Value = txtSiteName.Text
        oCmd.Parameters.Add("@site_address", SqlDbType.NVarChar, 255).Value = txtSiteAddress.Text
        oCmd.Parameters.Add("@site_city", SqlDbType.NVarChar, 100).Value = txtSiteCity.Text
        oCmd.Parameters.Add("@site_state", SqlDbType.NVarChar, 50).Value = txtSiteState.Text
        oCmd.Parameters.Add("@site_country", SqlDbType.NVarChar, 50).Value = txtSiteCountry.Text
        oCmd.Parameters.Add("@site_zip", SqlDbType.NVarChar, 50).Value = txtSiteZip.Text
        oCmd.Parameters.Add("@site_phone", SqlDbType.NVarChar, 50).Value = txtSitePhone.Text
        oCmd.Parameters.Add("@site_fax", SqlDbType.NVarChar, 50).Value = txtSiteFax.Text
        oCmd.Parameters.Add("@site_email", SqlDbType.NVarChar, 50).Value = txtSiteEmail.Text
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()

        oConn.Close()
        oConn = Nothing

        Response.Redirect(Me.LinkAdminLocalization)
    End Sub
        
    Protected Function ShowCulture(ByVal sCulture As String) As String
        'Dim oList As ListItem
        'Dim ci As System.Globalization.CultureInfo
        'For Each ci In System.Globalization.CultureInfo.GetCultures(System.Globalization.CultureTypes.SpecificCultures)
        '    oList = New ListItem
        '    oList.Text = ci.EnglishName.ToString
        '    oList.Value = ci.Name.ToString
        '    dropCultures.Items.Add(oList)
        'Next ci
        Return System.Globalization.CultureInfo.GetCultureInfoByIetfLanguageTag(sCulture).EnglishName
    End Function
    
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelSites" runat="server" Visible="false">

<asp:GridView ID="GridView1" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server" 
      AllowPaging="false" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="locale_id" DataSourceID="SqlDataSource1">
  <Columns>
    <asp:BoundField meta:resourcekey="lblHomePage" DataField="home_page" ReadOnly=true ItemStyle-Wrap=false HeaderStyle-Wrap="false" HeaderText="Home Page" SortExpression="home_page" />
    <asp:BoundField meta:resourcekey="lblDescription" DataField="description" ItemStyle-Wrap=false HeaderText="Description" SortExpression="description" />
<%--    <asp:BoundField meta:resourcekey="lblInstruction" DataField="instruction_text" ItemStyle-Wrap=false HeaderStyle-Wrap="false" HeaderText="Instruction Text" SortExpression="instruction_text" />--%>
    <%--<asp:BoundField meta:resourcekey="lblCulture" DataField="culture" ItemStyle-Wrap=false HeaderText="Culture" SortExpression="culture" />--%>
    <asp:TemplateField  meta:resourcekey="lblCulture" ItemStyle-Wrap="false" HeaderText="Culture" SortExpression="culture">
    <ItemTemplate>
    <%#ShowCulture(Eval("Culture", ""))%>
     </ItemTemplate>
    </asp:TemplateField>
    <asp:CheckBoxField meta:resourcekey="lblActive" DataField="active" HeaderText="Active" SortExpression="active"/>
    <asp:CommandField meta:resourcekey="lblGoTo" ShowSelectButton="True" ItemStyle-Wrap=false SelectText="Go to"/>
    <asp:TemplateField ItemStyle-Wrap="false">
    <ItemTemplate>
    &nbsp;&nbsp;<a href="<%# Me.LinkAdminSite & "?id=" & Eval("locale_id") %>"><%#GetLocalResourceObject("Edit")%></a>&nbsp;&nbsp;
    </ItemTemplate>
    </asp:TemplateField>
    <%--<asp:CommandField meta:resourcekey="lblEdit" ShowEditButton="True" />--%>
    <asp:CommandField meta:resourcekey="lblDelete" ShowDeleteButton="True" />
  </Columns>
</asp:GridView>
    
<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>">
  <UpdateParameters>
    <asp:Parameter Name="description" Type="String" />
    <asp:Parameter Name="instruction_text" Type="String" />
    <asp:Parameter Name="culture" Type="String" />
    <asp:Parameter Name="active" Type="Boolean" />
    <asp:Parameter Name="locale_id" Type="Int32" />
  </UpdateParameters>
</asp:SqlDataSource>
    
<div style="padding-top:5px;padding-bottom:5px">
<asp:Label ID="lblStatus" Font-Bold=true runat="server" Text=""></asp:Label>
</div>

<div style="border:#E0E0E0 1px solid;padding:10px;width:470px;margin-top:15px">
<table>
<tr>
    <td colspan="3" style="padding-bottom:10px">
        <asp:Label ID="lblNewLocale" meta:resourcekey="lblNewLocale" runat="server" Font-Bold="true" Text="New Locale"></asp:Label>
    </td>
</tr>
<tr>
    <td style="white-space:nowrap">
        <asp:Label ID="lblHomePage" meta:resourcekey="lblHomePage2" runat="server" Text="Home Page"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtHomePage" runat="server"></asp:TextBox> .aspx 
        <asp:Label ID="lblFileExistsLabel" meta:resourcekey="lblFileExistsLabel" runat="server" Text="File already exists." ForeColor="red" Visible="false"></asp:Label>           
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtHomepage" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblDescription" meta:resourcekey="lblDescription2" runat="server" Text="Description"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtDescription" Width="200px" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtDescription" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td style="white-space:nowrap">
        <asp:Label ID="lblInstruction" meta:resourcekey="lblInstruction2" runat="server" Text="Instruction Text"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtInstruction" Width="200px" Text="Select Country/Region" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblCulture" meta:resourcekey="lblCulture2" runat="server" Text="Culture"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:DropDownList ID="dropCultures" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblChannel" meta:resourcekey="lblChannel" runat="server" Text="Channel"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:DropDownList ID="dropChannels" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td style="white-space:nowrap">
        <asp:Label ID="lblSetActive" meta:resourcekey="lblSetActive" runat="server" Text="Set Active"></asp:Label>
    </td>
    <td>:</td>
    <td>
    <asp:CheckBox ID="chkActive" runat="server" />
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteName" meta:resourcekey="lblSiteName" runat="server" Text="Site/Company Name"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteName" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteAddress" meta:resourcekey="lblSiteAddress" runat="server" Text="Address"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteAddress" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteCity" meta:resourcekey="lblSiteCity" runat="server" Text="City"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteCity" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteState" meta:resourcekey="lblSiteState" runat="server" Text="State"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteState" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteCountry" meta:resourcekey="lblSiteCountry" runat="server" Text="Country"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteCountry" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteZip" meta:resourcekey="lblSiteZip" runat="server" Text="Zip"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteZip" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSitePhone" meta:resourcekey="lblSitePhone" runat="server" Text="Phone"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSitePhone" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteFax" meta:resourcekey="lblSiteFax" runat="server" Text="Fax"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteFax" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblSiteEmail" meta:resourcekey="lblSiteEmail" runat="server" Text="Email"></asp:Label>
    </td>
    <td align="left" style="width: 3px; text-align: left">:</td>
    <td>
        <asp:TextBox ID="txtSiteEmail" runat="server" Width="200px"></asp:TextBox>
    </td>
</tr>
<tr>
    <td colspan="3" style="padding-top:7px">
    <asp:Button ID="btnCreate" meta:resourcekey="btnCreate" runat="server" Text=" Create " /> 
    </td>
</tr>
</table>
</div>

</asp:Panel>
