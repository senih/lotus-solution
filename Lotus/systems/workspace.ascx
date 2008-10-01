<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
      
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
        lnkAccount.NavigateUrl = "~/" & Me.LinkWorkspaceAccount
        lnkAccount2.NavigateUrl = "~/" & Me.LinkWorkspaceAccount
        lnkPreferences.NavigateUrl = "~/" & Me.LinkWorkspacePreferences
        lnkPreferences2.NavigateUrl = "~/" & Me.LinkWorkspacePreferences
        lnkPages.NavigateUrl = "~/" & Me.LinkWorkspacePages
        lnkPages2.NavigateUrl = "~/" & Me.LinkWorkspacePages
        lnkResources.NavigateUrl = "~/" & Me.LinkWorkspaceResources
        lnkResources2.NavigateUrl = "~/" & Me.LinkWorkspaceResources
        lnkApproval.NavigateUrl = "~/" & Me.LinkWorkspaceApproval
        lnkApproval2.NavigateUrl = "~/" & Me.LinkWorkspaceApproval
        lnkEvents.NavigateUrl = "~/" & Me.LinkWorkspaceEvents
        lnkEvents2.NavigateUrl = "~/" & Me.LinkWorkspaceEvents
        lnkPolls.NavigateUrl = "~/" & Me.LinkWorkspacePolls
        lnkPolls2.NavigateUrl = "~/" & Me.LinkWorkspacePolls
        lnkNewsletters.NavigateUrl = "~/" & Me.LinkWorkspaceNewsletters
        lnkNewsletters2.NavigateUrl = "~/" & Me.LinkWorkspaceNewsletters
        lnkShop.NavigateUrl = "~/" & Me.LinkWorkspaceShop
        lnkShop2.NavigateUrl = "~/" & Me.LinkWorkspaceShop
        lnkCustomListing.NavigateUrl = "~/" & Me.LinkCustomListing
        lnkCustomListing2.NavigateUrl = "~/" & Me.LinkCustomListing
                
        If Not IsNothing(GetUser) Then

            Dim bShowResourceLink As Boolean = False
            Dim bShowApprovalLink As Boolean = False
            Dim bShowPagesLink As Boolean = False
            Dim bShowPrefLink As Boolean = False
            Dim bShowPollLink As Boolean = False
            Dim bShowEventLink As Boolean = False
            Dim bShowNewsletterLink As Boolean = False
            Dim bShowShopLink As Boolean = False
            Dim bShowCustomListingLink As Boolean = False

            Dim Item As String

            Dim arrUserRoles() As String
            arrUserRoles = Roles.GetRolesForUser(GetUser.UserName)

            For Each Item In arrUserRoles
                If Item.Contains("Authors") Then
                    If Item.Substring(Item.IndexOf("Authors")) = "Authors" Then
                        bShowPagesLink = True
                        bShowPrefLink = True
                        'bShowEventLink = True
                    End If
                End If

                If Item.Contains("Editors") Then
                    If Item.Substring(Item.IndexOf("Editors")) = "Editors" Then
                        bShowApprovalLink = True
                        bShowPagesLink = True
                        'bShowEventLink = True
                    End If
                End If

                If Item.Contains("Publishers") Then
                    If Item.Substring(Item.IndexOf("Publishers")) = "Publishers" Then
                        bShowApprovalLink = True
                        bShowPagesLink = True
                        'bShowEventLink = True
                    End If
                End If

                If Item.Contains("Resource Managers") Then
                    If Item.Substring(Item.IndexOf("Resource Managers")) = "Resource Managers" Then
                        bShowResourceLink = True
                        'bShowPagesLink = True
                        'bShowEventLink = True
                    End If
                End If

                If Item = "Polls Managers" Then
                    bShowPollLink = True
                End If

                If Item = "Events Managers" Then
                    bShowEventLink = True
                End If
                
                If Item = "Newsletters Managers" Then
                    bShowNewsletterLink = True
                End If

                If Item = "Administrators" Then
                    bShowApprovalLink = True
                    bShowResourceLink = True
                    bShowPagesLink = True
                    bShowPrefLink = True
                    bShowPollLink = True
                    bShowEventLink = True
                    bShowNewsletterLink = True
                    bShowShopLink = True
                    bShowCustomListingLink = True
                End If
            Next
             
            If Not bShowApprovalLink Then
                idApproval.Visible = False
            End If
            If Not bShowResourceLink Then
                idResources.Visible = False
            End If
            If Not bShowPagesLink Then
                idPages.Visible = False
            End If
            If Not bShowPrefLink Then
                idPreferences.Visible = False
            End If
            If Not bShowPollLink Then
                idPolls.Visible = False
            End If
            If Not bShowEventLink Then
                idEvents.Visible = False
            End If
            If Not bShowNewsletterLink Then
                idNewsletters.Visible = False
            End If
            If Not bShowShopLink Then
                idShop.Visible = False
            End If
            If Not bShowCustomListingLink Then
                idCustomListing.Visible = False
            End If

            panelWorkspace.Visible = True
            panelLogin.Visible = False
            
        Else
            panelWorkspace.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        End If
        
        'Hide Shop
        If ConfigurationManager.AppSettings("Shop") = "no" Then
            idShop.Visible = False
        End If
        
        'Hide Events
        idEvents.Visible = False
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
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

<asp:Panel ID="panelWorkspace" runat="server" Visible="false">

<table cellpadding="0" cellspacing="0" style="width:100%">
<tr>
<td valign="top">

<table cellpadding="0" cellspacing="0" style="width:100%">
<tr runat="server" id="idAccount">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkAccount2" Font-Underline="false" runat="server">
            <asp:Image ID="imgAccount" meta:resourcekey="imgAccount" ImageUrl="images/ico_account.gif" Width="79px" Height="79px" runat="server"  />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px;width:100%">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkAccount" meta:resourcekey="lnkAccount" runat="server" Font-Size="12px">Account</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litAccount" meta:resourcekey="litAccount" runat="server">
            Update your profile.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idPreferences">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkPreferences2" Font-Underline="false" runat="server">
            <asp:Image ID="imgPreferences" meta:resourcekey="imgPreferences" ImageUrl="images/ico_preferences.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkPreferences" meta:resourcekey="lnkPreferences" runat="server" Font-Size="12px">Preferences</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litPreferences" meta:resourcekey="litPreferences" runat="server">
            Customize your working panels.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idPages">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkPages2" Font-Underline="false" runat="server">
            <asp:Image ID="imgPages" meta:resourcekey="imgPages" ImageUrl="images/ico_pages.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkPages" meta:resourcekey="lnkPages" runat="server" Font-Size="12px">Pages</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litPages" meta:resourcekey="litPages" runat="server">
            List of pages in your channels.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idResources">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkResources2" Font-Underline=false  runat="server">
            <asp:Image ID="imgResources" meta:resourcekey="imgResources" ImageUrl="images/ico_resources.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkResources" meta:resourcekey="lnkResources" runat="server" Font-Size="12px">Resources</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litResources" meta:resourcekey="litResources" runat="server">
            Manage images & multimedia files.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idApproval">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkApproval2" Font-Underline=false  runat="server">
            <asp:Image ID="imgApproval" meta:resourcekey="imgApproval" ImageUrl="images/ico_approval.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkApproval" meta:resourcekey="lnkApproval" runat="server" Font-Size="12px">Approval</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litApproval" meta:resourcekey="litApproval" runat="server">
            List of pages waiting for your approval.
            </asp:Literal>            
        </div>
    </td>
</tr>
</table>


</td>
<td valign="top">


<table cellpadding="0" cellspacing="0" style="width:100%">
<tr runat="server" id="idEvents">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkEvents2" Font-Underline=false runat="server">
            <asp:Image ID="imgEvents" meta:resourcekey="imgEvents" ImageUrl="images/ico_events.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkEvents" meta:resourcekey="lnkEvents" runat="server" Font-Size="12px">Events</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litEvents" meta:resourcekey="litEvents" runat="server">
            Create and manage events.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idPolls">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkPolls2" Font-Underline=false runat="server">
            <asp:Image ID="imgPolls" meta:resourcekey="imgPolls" ImageUrl="images/ico_polls.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkPolls" meta:resourcekey="lnkPolls" runat="server" Font-Size="12px">Polls</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litPolls" meta:resourcekey="litPolls" runat="server">
            Create and manage polls.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idNewsletters">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkNewsletters2" Font-Underline=false runat="server">
            <asp:Image ID="imgNewsletters" meta:resourcekey="imgNewsletters" ImageUrl="images/ico_newsletters.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkNewsletters" meta:resourcekey="lnkNewsletters" runat="server" Font-Size="12px">Newsletters</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litNewsletters" meta:resourcekey="litNewsletters" runat="server">
            Create and manage email newsletters.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idCustomListing">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkCustomListing2" Font-Underline=false runat="server">
            <asp:Image ID="imgCustomListing" meta:resourcekey="imgCustomListing" ImageUrl="images/ico_shop.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkCustomListing" meta:resourcekey="lnkCustomListing" runat="server" Font-Size="12px">Custom Listing</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litCustomListing" meta:resourcekey="litCustomListing" runat="server">
            Create & Embed Custom Listing
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr runat="server" id="idShop">
    <td style="padding-bottom:5px">
        <asp:HyperLink ID="lnkShop2" Font-Underline=false runat="server">
            <asp:Image ID="imgShop" meta:resourcekey="imgShop" ImageUrl="images/ico_shop.gif" Width="79px" Height="79px" runat="server" />
        </asp:HyperLink>
    </td>
    <td valign="top" style="padding-top:9px;padding-left:20px">
        <div style="border-top:#aaaaaa 1px dotted;width:100%;padding-top:3px">
            <asp:HyperLink ID="lnkShop" meta:resourcekey="lnkShop" runat="server" Font-Size="12px">Shop</asp:HyperLink>
            <div style="margin:3px"></div>
            <asp:Literal ID="litShop" meta:resourcekey="litShop" runat="server">
            Manage Online Shop.
            </asp:Literal>            
        </div>
    </td>
</tr>
<tr><td colspan="2"></td></tr>
</table>


</td>
</tr>
</table>


</asp:Panel>
