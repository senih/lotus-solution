<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">   
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lnkChannels.NavigateUrl = "~/" & Me.LinkAdminChannels
        lnkChannels2.NavigateUrl = "~/" & Me.LinkAdminChannels
        lnkUsers.NavigateUrl = "~/" & Me.LinkAdminUsers
        lnkUsers2.NavigateUrl = "~/" & Me.LinkAdminUsers
        lnkTemplates.NavigateUrl = "~/" & Me.LinkAdminTemplates
        lnkTemplates2.NavigateUrl = "~/" & Me.LinkAdminTemplates
        lnkModules.NavigateUrl = "~/" & Me.LinkAdminModules
        lnkModules2.NavigateUrl = "~/" & Me.LinkAdminModules
        lnkLocalization.NavigateUrl = "~/" & Me.LinkAdminLocalization
        lnkLocalization2.NavigateUrl = "~/" & Me.LinkAdminLocalization
        lnkRegistrationSettings.NavigateUrl = "~/" & Me.LinkAdminRegistrationSettings
        lnkRegistrationSettings2.NavigateUrl = "~/" & Me.LinkAdminRegistrationSettings
        
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelAdmin.Visible = True
            End If
        End If
    End Sub

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

<asp:Panel ID="panelAdmin" runat="server" Visible="false">

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkChannels2" Font-Underline="false" runat="server">
            <asp:Image ID="imgChannels" meta:resourcekey="imgChannels" ImageUrl="images/ico_channels.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkChannels" meta:resourcekey="lnkChannels" runat="server" Font-Size="12px">Channels</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litChannels" meta:resourcekey="litChannels" runat="server">
            Create and manage channels - website divisions that also control user access.<br />
            Channels can be set up to directly reflect the way any organization – large or small – is structured.
            </asp:Literal>
        </div>
    </td>
</tr>
<tr>
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkUsers2" Font-Underline="false" runat="server">
            <asp:Image ID="imgUsers" meta:resourcekey="imgUsers" ImageUrl="images/ico_users.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkUsers" meta:resourcekey="lnkUsers" runat="server" Font-Size="12px">Users</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litUsers" meta:resourcekey="litUsers" runat="server">
            Create, manage and assign users to channels.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr>
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkRegistrationSettings2" Font-Underline="false" runat="server">
            <asp:Image ID="imgRegistrationSettings" meta:resourcekey="imgRegistrationSettings" ImageUrl="images/ico_registration.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkRegistrationSettings" meta:resourcekey="lnkRegistrationSettings" runat="server" Font-Size="12px">Registration Settings</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litRegistrationSettings" meta:resourcekey="litRegistrationSettings" runat="server">
            Provide & configure site user registration.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr>
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkTemplates2" Font-Underline="false" runat="server">
            <asp:Image ID="imgTemplates" meta:resourcekey="imgTemplates" ImageUrl="images/ico_templates.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkTemplates" meta:resourcekey="lnkTemplates" runat="server" Font-Size="12px">Templates</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litTemplates" meta:resourcekey="litTemplates" runat="server">
            Register your templates here.
            </asp:Literal>
        </div>
    </td>
</tr>
<tr>
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkModules2" Font-Underline="false" runat="server">
            <asp:Image ID="imgModules" meta:resourcekey="imgModules" ImageUrl="images/ico_modules.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkModules" meta:resourcekey="lnkModules" runat="server" Font-Size="12px">Modules</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litModules" meta:resourcekey="litModules" runat="server">
            Register your modules here and extend InsiteCreation with custom functions.<br />
            Your modules can be run within any web page.
            </asp:Literal>
        </div>
    </td>
</tr>
<tr>
    <td style="padding-bottom:0px">
        <asp:HyperLink ID="lnkLocalization2" Font-Underline="false" runat="server">
            <asp:Image ID="imgLocalization" meta:resourcekey="imgLocalization" ImageUrl="images/ico_localization.gif" Width="79px" Height="79px" runat="server" /><br />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkLocalization" meta:resourcekey="lnkLocalization" runat="server" Font-Size="12px">Localization</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litLocalization" meta:resourcekey="litLocalization" runat="server">
            Create and manage sites & localization.
            </asp:Literal>
        </div>
    </td>
</tr>
</table>

</asp:Panel>
