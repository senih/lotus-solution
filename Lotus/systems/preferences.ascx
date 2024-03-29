<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        If Not IsNothing(GetUser) Then
            panelUpdatePreferences.Visible = True
            
            If Profile.UseWYSIWYG Then
                If Profile.UseAdvancedEditor Then
                    rdoEditor.SelectedValue = "Advanced"
                Else
                    rdoEditor.SelectedValue = "Quick"
                End If
            Else
                rdoEditor.SelectedValue = "Source"
            End If
            chkAdvSave.Checked = Profile.UseAdvancedSaveOptions
            'chkURLEdit.Checked = Profile.EditablePageURL
            chkMove.Checked = Profile.UseAdvancedMove

            lblSucceed.Text = ""
        Else
            panelUpdatePreferences.Visible = False
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
        End If
        
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim muSelectedUser As MembershipUser = Membership.GetUser()
        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(muSelectedUser.UserName)

        If rdoEditor.SelectedValue = "Quick" Then
            pcSelectedProfile.UseWYSIWYG = True
            pcSelectedProfile.UseAdvancedEditor = False
        ElseIf rdoEditor.SelectedValue = "Advanced" Then
            pcSelectedProfile.UseWYSIWYG = True
            pcSelectedProfile.UseAdvancedEditor = True
        Else
            pcSelectedProfile.UseWYSIWYG = False
        End If

        pcSelectedProfile.UseAdvancedSaveOptions = chkAdvSave.Checked
        'pcSelectedProfile.EditablePageURL = chkURLEdit.Checked
        pcSelectedProfile.UseAdvancedMove = chkMove.Checked
        pcSelectedProfile.Save()

        lblSucceed.Text = GetLocalResourceObject("DataUpdated")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelUpdatePreferences" runat="server" Visible=false>
    
    <asp:Label ID="lblDefaultEditor" meta:resourcekey="lblDefaultEditor" runat="server" Text="Default Editor"></asp:Label> :
    
    <table><tr><td style="padding-left:20px">
        <asp:RadioButtonList ID="rdoEditor" runat="server">
            <asp:ListItem meta:resourcekey="optQuick" Text="Quick WYSIWYG Editor" Value="Quick"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optAdv" Text="Advanced WYSIWYG Editor" Value="Advanced"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optSource" Text="Source Editor" Value="Source"></asp:ListItem>  
        </asp:RadioButtonList>
    </td></tr></table>
    
    <asp:CheckBox ID="chkAdvSave" meta:resourcekey="chkAdvSave" runat="server" Text="Use advanced save options." />
    <br />
<%--    <asp:CheckBox ID="chkURLEdit" meta:resourcekey="chkURLEdit" runat="server" Text="Edit page name (URL) when creating a new page." />
    <br />--%>
    <asp:CheckBox ID="chkMove" meta:resourcekey="chkMove" runat="server" Text="Use advanced page move facility." />

    <br /><br />
    <asp:Button ID="btnSave" runat="server" meta:resourcekey="btnSave" Text=" Save " CausesValidation=false OnClick="btnSave_Click" />
    <asp:Label ID="lblSucceed" runat="server" Font-Bold=true></asp:Label>
    <br /><br />
</asp:Panel>

