<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="Registration" %>

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.IsUserLoggedIn Then
            If Me.IsAdministrator Then
                panelLogin.Visible = False
                PanelSettings.Visible = True
                Dim Channels As Collection = New Collection
                Dim Role As String
                For Each Role In Roles.GetAllRoles
                    If (Role <> "Administrators") And (Role <> "Polls Managers") And (Role <> "Newsletters Managers") And (Role <> "Events Managers") And (Not Role.Contains("Mailing List")) Then
                        Channels.Add(Role)
                    End If
                Next
                
                dropChannel1.DataSource = Channels
                dropChannel2.DataSource = Channels
                dropChannel3.DataSource = Channels
                dropChannel4.DataSource = Channels
                dropChannel5.DataSource = Channels
                dropChannel1.DataBind()
                dropChannel2.DataBind()
                dropChannel3.DataBind()
                dropChannel4.DataBind()
                dropChannel5.DataBind()
                dropChannel1.Items.Insert(0, "")
                dropChannel2.Items.Insert(0, "")
                dropChannel3.Items.Insert(0, "")
                dropChannel4.Items.Insert(0, "")
                dropChannel5.Items.Insert(0, "")
                
                Dim oSetting As RegistrationSetting = New RegistrationSetting
                oSetting = GetRegistrationSetting(Me.RootID)
                'Harus Ada Jangan dihapus 
                'Sebagai inisialisasi jika Root id belum pernah di isi registrtion setting
                If oSetting.RootId = 0 Then
                    oSetting.Channel1 = ""
                    oSetting.Channel2 = ""
                    oSetting.Channel3 = ""
                    oSetting.Channel4 = ""
                    oSetting.Channel5 = ""
                End If
                
                txtConfirmationBody.Text = oSetting.ConfirmationBody
                txtConfirmationSubject.Text = oSetting.ConfirmationSubject
                txtConfirmedBody.Text = oSetting.ConfirmedBody
                txtConfirmedSubject.Text = oSetting.ConfirmedSubject
                txtDescription.Text = oSetting.OptionDescription
                dropType.SelectedValue = oSetting.OptionType
                txtOption1.Text = oSetting.Option1
                txtOption2.Text = oSetting.Option2
                txtOption3.Text = oSetting.Option3
                txtOption4.Text = oSetting.Option4
                txtOption5.Text = oSetting.Option5
                dropChannel1.SelectedValue = oSetting.Channel1
                dropChannel2.SelectedValue = oSetting.Channel2
                dropChannel3.SelectedValue = oSetting.Channel3
                dropChannel4.SelectedValue = oSetting.Channel4
                dropChannel5.SelectedValue = oSetting.Channel5
                                   
                Channels = Nothing
                oSetting = Nothing
            End If
        Else
            panelLogin.Visible = True
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim oSetting As RegistrationSetting = New RegistrationSetting
        oSetting.ConfirmationBody = txtConfirmationBody.Text
        oSetting.ConfirmationSubject = txtConfirmationSubject.Text
        oSetting.ConfirmedBody = txtConfirmedBody.Text
        oSetting.ConfirmedSubject = txtConfirmedSubject.Text
        oSetting.OptionDescription = txtDescription.Text
        oSetting.OptionType = dropType.SelectedValue
        oSetting.Option1 = txtOption1.Text
        oSetting.Option2 = txtOption2.Text
        oSetting.Option3 = txtOption3.Text
        oSetting.Option4 = txtOption4.Text
        oSetting.Option5 = txtOption5.Text
        oSetting.Channel1 = dropChannel1.SelectedValue
        oSetting.Channel2 = dropChannel2.SelectedValue
        oSetting.Channel3 = dropChannel3.SelectedValue
        oSetting.Channel4 = dropChannel4.SelectedValue
        oSetting.Channel5 = dropChannel5.SelectedValue
        oSetting.RootId = Me.RootID
        InsertRegistrationSetting(oSetting)

        'SAVE HERE
        oSetting = Nothing

        'lblStatus.Text = GetLocalResourceObject("SavedSuccessfully")
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub


    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("~/" & Me.LinkAdmin)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="PanelSettings" runat="server" Visible="False">
<table>
<tr>
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("ConfirmationSubject")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtConfirmationSubject" runat="server" Width="350"></asp:TextBox></td>
</tr>
<tr>
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("ConfirmationBody")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtConfirmationBody" TextMode="MultiLine" runat="server" Width="350" Height="150"></asp:TextBox></td>
</tr>
<tr>
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("ConfirmedSubject")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtConfirmedSubject" runat="server" Width="350"></asp:TextBox></td>
</tr>
<tr>
    <td style="white-space:nowrap" valign="top"><%=GetLocalResourceObject("ConfirmedBody")%></td><td valign="top">:</td>
    <td><asp:TextBox ID="txtConfirmedBody" TextMode="MultiLine" runat="server" Width="350" Height="150"></asp:TextBox></td>
</tr>
<tr>
    <td colspan="3"><b><%=GetLocalResourceObject("RegistrationOptions")%></b></td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Type")%></td><td>:</td>
    <td>
        <asp:DropDownList ID="dropType" runat="server">
        <asp:ListItem Selected="True" Text="Single Selection" Value="single"></asp:ListItem>
        <asp:ListItem Text="Multiple Selection" Value="multiple"></asp:ListItem>
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Description")%></td><td>:</td>
    <td><asp:TextBox ID="txtDescription" runat="server" Width="350"></asp:TextBox></td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Option1")%></td><td>:</td>
    <td><asp:TextBox ID="txtOption1" runat="server"></asp:TextBox>    
        <asp:DropDownList ID="dropChannel1" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Option2")%></td><td>:</td>
    <td><asp:TextBox ID="txtOption2" runat="server"></asp:TextBox>
        <asp:DropDownList ID="dropChannel2" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Option3")%></td><td>:</td>
    <td><asp:TextBox ID="txtOption3" runat="server"></asp:TextBox>
        <asp:DropDownList ID="dropChannel3" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Option4")%></td><td>:</td>
    <td><asp:TextBox ID="txtOption4" runat="server"></asp:TextBox>
        <asp:DropDownList ID="dropChannel4" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td><%=GetLocalResourceObject("Option5")%></td><td>:</td>
    <td><asp:TextBox ID="txtOption5" runat="server"></asp:TextBox>
        <asp:DropDownList ID="dropChannel5" runat="server">
        </asp:DropDownList>
    </td>
</tr>
<tr valign="top">
    <td colspan="3">
    <div style="margin:7px"></div>
      <asp:Button ID="btnSave" runat="server" Text=" Save " meta:resourcekey="btnSave" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text=" Cancel " meta:resourcekey="btnCancel" OnClick="btnCancel_Click" />
        <asp:Label ID="lblStatus" Font-Bold="true" runat="server" Text=""></asp:Label>
    </td>
    </tr>
</table>
</asp:Panel>
