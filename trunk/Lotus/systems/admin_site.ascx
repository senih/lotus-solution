<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data" %> 
<%@ Import Namespace="System.Data.SqlClient" %> 

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private sRawUrl As String = Context.Request.RawUrl.ToString
    Private nLocaleId As Integer
        
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelSite.Visible = True
            End If
        End If

        nLocaleId = Request.QueryString("id")
        
        Dim oList As ListItem
        Dim ci As System.Globalization.CultureInfo
        For Each ci In System.Globalization.CultureInfo.GetCultures(System.Globalization.CultureTypes.SpecificCultures)
            oList = New ListItem
            oList.Text = ci.EnglishName.ToString
            oList.Value = ci.Name.ToString
            dropCultures.Items.Add(oList)
        Next ci
        
        
        oConn.Open()
        Dim sSQL As String = "SELECT * FROM locales WHERE locale_id=@locale_id"

        Dim oCmd As New SqlCommand(sSQL, oConn)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@locale_id", SqlDbType.Int).Value = nLocaleId
        Dim oReader As SqlDataReader = oCmd.ExecuteReader()
        While oReader.Read()
            lblHomePage.Text = oReader("home_page").ToString
            txtDescription.Text = oReader("description").ToString
            txtInstructionText.Text = oReader("instruction_text").ToString
            dropCultures.SelectedValue = oReader("culture").ToString
            chkActive.Checked = CBool(oReader("active"))
            txtSiteName.Text = oReader("site_name").ToString
            txtSiteAddress.Text = oReader("site_address").ToString
            txtSiteCity.Text = oReader("site_city").ToString
            txtSiteState.Text = oReader("site_state").ToString
            txtSiteCountry.Text = oReader("site_country").ToString
            txtSiteZip.Text = oReader("site_zip").ToString
            txtSitePhone.Text = oReader("site_phone").ToString
            txtSiteFax.Text = oReader("site_fax").ToString
            txtSiteEmail.Text = oReader("site_email").ToString
        End While
        oReader.Close()
        oConn.Close()

    End Sub
    
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim sSQL As String = "UPDATE locales SET site_name=@site_name, " & _
            "description=@description, instruction_text=@instruction_text, " & _
            "culture=@culture, active=@active, " & _
            "site_address=@site_address, site_city=@site_city, " & _
            "site_state=@site_state, site_country=@site_country, " & _
            "site_zip=@site_zip, site_phone=@site_phone, " & _
            "site_fax=@site_fax, site_email=@site_email " & _
            "WHERE locale_id=@locale_id"

        Dim oCmd As SqlCommand
        oCmd = New SqlCommand(sSQL)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@site_name", SqlDbType.NVarChar, 50).Value = txtSiteName.Text
        oCmd.Parameters.Add("@description", SqlDbType.NVarChar, 255).Value = txtDescription.Text
        oCmd.Parameters.Add("@instruction_text", SqlDbType.NVarChar, 255).Value = txtInstructionText.Text
        oCmd.Parameters.Add("@culture", SqlDbType.NVarChar, 50).Value = dropCultures.SelectedValue
        oCmd.Parameters.Add("@active", SqlDbType.Bit).Value = chkActive.Checked
        oCmd.Parameters.Add("@site_address", SqlDbType.NVarChar, 255).Value = txtSiteAddress.Text
        oCmd.Parameters.Add("@site_city", SqlDbType.NVarChar, 100).Value = txtSiteCity.Text
        oCmd.Parameters.Add("@site_state", SqlDbType.NVarChar, 50).Value = txtSiteState.Text
        oCmd.Parameters.Add("@site_country", SqlDbType.NVarChar, 50).Value = txtSiteCountry.Text
        oCmd.Parameters.Add("@site_zip", SqlDbType.NVarChar, 50).Value = txtSiteZip.Text
        oCmd.Parameters.Add("@site_phone", SqlDbType.NVarChar, 50).Value = txtSitePhone.Text
        oCmd.Parameters.Add("@site_fax", SqlDbType.NVarChar, 50).Value = txtSiteFax.Text
        oCmd.Parameters.Add("@site_email", SqlDbType.NVarChar, 50).Value = txtSiteEmail.Text
        oCmd.Parameters.Add("@locale_id", SqlDbType.NVarChar, 50).Value = nLocaleId
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        
        lblStatus.Text = GetLocalResourceObject("DataUpdated")
        Response.Redirect(Me.LinkAdminLocalization)
    End Sub
    
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(Me.LinkAdminLocalization)
    End Sub
   
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
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

<asp:Panel ID="panelSite" runat="server" Visible="false">

 <table>
     <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblHomePageLabel" meta:resourcekey="lblHomePageLabel" runat="server" Text="Home Page"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">:</td>
        <td>
            <asp:Label ID="lblHomePage" runat="server" Text=""></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="height:5px"></td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblDescription" meta:resourcekey="lblDescription" runat="server" Text="Description"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">:</td>
        <td>
            <asp:TextBox ID="txtDescription" runat="server" Width="200px"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblInstructionText" meta:resourcekey="lblInstructionText" runat="server" Text="Instruction Text"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">:</td>
        <td>
            <asp:TextBox ID="txtInstructionText" runat="server" Width="200px"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblCulture" meta:resourcekey="lblCulture" runat="server" Text="Culture"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">:</td>
        <td>
            <%--<asp:TextBox ID="txtCulture" runat="server" Width="200px"></asp:TextBox>--%>
            <asp:DropDownList ID="dropCultures" runat="server">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblSetActive" meta:resourcekey="lblSetActive" runat="server" Text="Set Active"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">:</td>
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
        <td colspan="3" style="text-align:left;white-space:nowrap;padding-top:7px">
            <asp:Button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" Update " OnClick="btnUpdate_click" ValidationGroup="Channel" />  
            <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="  Cancel  " OnClick="btnCancel_click"/>  
            &nbsp;&nbsp;<asp:Label ID="lblStatus" Font-Bold="true" runat="server" Text=""></asp:Label>
        </td>
    </tr>
    
</table>
<br />

</asp:Panel>