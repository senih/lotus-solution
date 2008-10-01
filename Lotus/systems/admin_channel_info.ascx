<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="TemplateManager" %> 
<%@ Import Namespace="ChannelManager" %> 

<script runat="server">
    Private sRawUrl As String = Context.Request.RawUrl.ToString
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
     
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelChannels.Visible = True
            End If
        End If

        hidChannelId.Value = Request.QueryString("ChannelId")
        Dim nChannelId As Integer = CInt(hidChannelId.Value)
        Dim oSelectChannel As CMSChannel = New CMSChannel
        Dim oChannel As ChannelManager = New ChannelManager
        oSelectChannel = oChannel.GetChannel(nChannelId)
        Dim oTemplates As TemplateManager = New TemplateManager
        ddlTemplate.DataSource = oTemplates.ListAllTemplates()
        ddlTemplate.DataBind()
        
        txtChannelName.Text = oSelectChannel.ChannelName
        ddlTemplate.SelectedValue = oSelectChannel.DefaultTemplate.ToString
        ddlPermission.SelectedValue = oSelectChannel.Permission.ToString
        chkDisableCollabAuth.Checked = oSelectChannel.DisableCollaboration
        
    End Sub
    
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim nChannelId As Integer = CInt(hidChannelId.Value)
        Dim oUpdateChannel As CMSChannel = New CMSChannel
        Dim oChannel As ChannelManager = New ChannelManager
        
        oUpdateChannel = oChannel.GetChannel(nChannelId)
        oUpdateChannel.ChannelName = txtChannelName.Text
        oUpdateChannel.DefaultTemplate = ddlTemplate.SelectedValue
        oUpdateChannel.Permission = ddlPermission.SelectedValue
        oUpdateChannel.DisableCollaboration = chkDisableCollabAuth.Checked

        If Not IsNothing(oChannel.GetChannelByName(txtChannelName.Text)) Then
            If oChannel.GetChannelByName(txtChannelName.Text).ChannelId = nChannelId Then
                'self update (same id)
                oChannel.UpdateChannel(oUpdateChannel)
            Else
                'do not update, other channel has the same name
            End If
        Else
            oChannel.UpdateChannel(oUpdateChannel)
        End If
        Response.Redirect(Me.LinkAdminChannels)
    End Sub
    
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(Me.LinkAdminChannels)
    End Sub

    Private Function GetFileName() As String
        Dim sFileName As String
        Dim sPath As String
        If sRawUrl.Contains("?") Then
            sPath = sRawUrl.Split(CChar("?"))(0).ToString
        Else
            sPath = sRawUrl
        End If

        sFileName = sPath.Substring(sPath.LastIndexOf("/") + 1) 'All pages are in root
        Return sFileName
    End Function
    
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelChannels" runat="server" Visible="false">
    <asp:HiddenField ID="hidChannelId" runat="server" />
 <table>
    <tr>
        <td align="left" nowrap=nowrap>
           <asp:Label ID="lblChannelName" meta:resourcekey="lblChannelName" runat="server" Text="Name"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">
            :</td>
        <td>
            <asp:TextBox ID="txtChannelName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="*" ControlToValidate="txtChannelName" ValidationGroup="Channel"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td align="left" nowrap=nowrap>
            <asp:Label ID="lblTemplate" meta:resourcekey="lblTemplate" runat="server" Text="Default Template"></asp:Label></td>
        <td align="left" style="width: 3px">
            :</td>
        <td>
            <asp:DropDownList ID="ddlTemplate" runat="server" DataTextField="TemplateName" DataValueField="TemplateId"> 
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left" style="text-align: left; " nowrap=nowrap>
           <asp:Label ID="lblPermission" meta:resourcekey="lblPermission" runat="server" Text="View Permission"></asp:Label></td>
        <td align="left">
            :</td>
        <td>
            <asp:DropDownList ID="ddlPermission" runat="server">
            <asp:ListItem Value="1" meta:resourcekey="ddlPermissionOpt1" Text="Everyone (Anonymous Users)"></asp:ListItem>
            <asp:ListItem Value="2" meta:resourcekey="ddlPermissionOpt2" Text="All Users (Registered)"></asp:ListItem>
            <asp:ListItem Value="3" meta:resourcekey="ddlPermissionOpt3" Text="Channel's Users Only"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td colspan=3 height="10px"></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:CheckBox ID="chkDisableCollabAuth" meta:resourcekey="chkDisableCollabAuth" Text=" Disable Collaborative Authoring" runat="server" />
        </td>
    </tr>
    <tr>
        <td colspan=3 align="left" style="text-align:left;padding-top:10px" nowrap=nowrap>
            <asp:Button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" Update " OnClick="btnUpdate_click" ValidationGroup="Channel" />  
            <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="  Cancel  " OnClick="btnCancel_click"/>  
        </td>
    </tr>
    
</table>
<br />

</asp:Panel>

