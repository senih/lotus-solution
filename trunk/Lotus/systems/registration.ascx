<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="Registration" %>

<script runat="server">    
  
    Private sConfirmationSubject As String
    Private sConfirmationBody As String
    Private sConfirmedSubject As String
    Private sConfirmedBody As String
    Private oSetting As RegistrationSetting

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        oSetting = New RegistrationSetting
        oSetting = GetRegistrationSetting(Me.RootID)
        If oSetting.RootId = 0 Then
            oSetting.ConfirmationBody = ""
            oSetting.ConfirmationSubject = ""
            oSetting.ConfirmedBody = ""
            oSetting.ConfirmedSubject = ""
            oSetting.OptionDescription = ""
            oSetting.OptionType = ""
            oSetting.Option1 = ""
            oSetting.Option2 = ""
            oSetting.Option3 = ""
            oSetting.Option4 = ""
            oSetting.Option5 = ""
            oSetting.Channel1 = ""
            oSetting.Channel2 = ""
            oSetting.Channel3 = ""
            oSetting.Channel4 = ""
            oSetting.Channel5 = ""
            oSetting.RootId = Me.RootID
        End If

        With oSetting
            sConfirmationSubject = .ConfirmationSubject
            sConfirmationBody = .ConfirmationBody
            sConfirmedSubject = .ConfirmedSubject
            sConfirmedBody = .ConfirmedBody
        End With

        If Request.QueryString("s") = "activate" Then 'Activate account
            panelActivate.Visible = True
            CreateUserWizard1.Visible = False

            Dim ID As Guid = New Guid(Request.QueryString("uid"))
            Dim user As MembershipUser = Membership.GetUser(ID)
            Dim bSendPassword As Boolean = True

            If IsNothing(user) Then
                lblActivate.Text = GetLocalResourceObject("RegistrationFailed") 'Registration Failed. Please try again.
            Else
                If user.IsApproved Then
                    lblActivate.Text = GetLocalResourceObject("UserAlreadyActivated") 'User is already activated.
                Else
                    user.IsApproved = True
                    Try
                        Membership.UpdateUser(user)
                        lblActivate.Text = ""
                        If bSendPassword Then
                            Dim oSmtpClient As SmtpClient = New SmtpClient
                            Dim oMailMessage As MailMessage = New MailMessage
                            Try
                                'Dim sFrom As String
                                'Dim oSmtpSection As Net.Configuration.SmtpSection = CType(ConfigurationManager.GetSection("system.net/mailSettings/smtp"), Net.Configuration.SmtpSection)
                                'sFrom = oSmtpSection.From.ToString

                                Dim ToMail As MailAddress = New MailAddress(user.Email, user.UserName)
                                'oMailMessage.From = New MailAddress(sFrom, sFrom)
                                sConfirmedBody = sConfirmedBody.Replace("[%UserName%]", user.UserName)
                                sConfirmedBody = sConfirmedBody.Replace("[%Password%]", user.GetPassword())
                                sConfirmedBody = sConfirmedBody.Replace("[%SiteName%]", Me.SiteName)
                                sConfirmedBody = sConfirmedBody.Replace("[%SiteEmail%]", Me.SiteEmail)
                                oMailMessage.Body = "<html><head><style>body {font-family:verdana;font-size:11px}</style></head><body>" & sConfirmedBody & "</body></html>"
                                oMailMessage.To.Clear()
                                oMailMessage.To.Add(ToMail)
                                oMailMessage.Subject = sConfirmedSubject
                                oMailMessage.IsBodyHtml = True
                                oSmtpClient.Send(oMailMessage)
                            Catch ex As Exception
                            End Try
                        End If

                        lblActivate.Text = GetLocalResourceObject("RegistrationCompleted")
                        
                        'Do Login
                        'FormsAuthentication.SetAuthCookie(user.UserName, True)

                    
                    Catch ex As Exception
                        lblActivate.Text = GetLocalResourceObject("RegistrationFailed") 'Registration Failed. Please try again.
                    End Try

 
  
                End If
            End If
        Else
            'Create User
            panelActivate.Visible = False
            CreateUserWizard1.Visible = True
            CreateUserWizard1.ContinueDestinationPageUrl = Request.QueryString("ReturnUrl")

            Dim oOption As RegistrationOption
            Dim colOptions As Collection = New Collection

            If oSetting.Option1 <> "" Then
                oOption = New RegistrationOption
                oOption.Key = oSetting.Option1
                oOption.Value = oSetting.Channel1
                colOptions.Add(oOption)
            End If
            If oSetting.Option2 <> "" Then
                oOption = New RegistrationOption
                oOption.Key = oSetting.Option2
                oOption.Value = oSetting.Channel2
                colOptions.Add(oOption)
            End If

            If oSetting.Option3 <> "" Then
                oOption = New RegistrationOption
                oOption.Key = oSetting.Option3
                oOption.Value = oSetting.Channel3
                colOptions.Add(oOption)
            End If
            If oSetting.Option4 <> "" Then
                oOption = New RegistrationOption
                oOption.Key = oSetting.Option4
                oOption.Value = oSetting.Channel4
                colOptions.Add(oOption)
            End If
            If oSetting.Option5 <> "" Then
                oOption = New RegistrationOption
                oOption.Key = oSetting.Option5
                oOption.Value = oSetting.Channel5
                colOptions.Add(oOption)
            End If
        
            CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("lblOptDescription"), Label).Text = oSetting.OptionDescription.ToString
            If colOptions.Count > 0 Then
                If oSetting.OptionType = "single" Then
                    CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).DataSource = colOptions
                    CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).DataBind()
                Else
                    CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).DataSource = colOptions
                    CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).DataBind()
                End If
            End If
            If colOptions.Count = 1 Then
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("lblOptDescription"), Label).Visible = False
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).Visible = False
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Visible = False
            End If

            If colOptions.Count < 2 Then
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("lblOptDescription"), Label).Visible = False
            Else
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("lblOptDescription"), Label).Visible = True
            End If
            
            colOptions = Nothing
            'oSetting = Nothing
        End If
    End Sub

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sRole As String
        Dim sUserName As String = CreateUserWizard1.UserName
        Dim sEmail As String = CreateUserWizard1.Email
        Dim ID As String = Membership.GetUser(sUserName).ProviderUserKey.ToString.ToUpper
        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(sUserName)

        pcSelectedProfile.UseWYSIWYG = True
        pcSelectedProfile.Save()

        If oSetting.OptionType = "single" Then
            If CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).Items.Count = 1 Then
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).Items(0).Selected = True
            End If
            sRole = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("rbRegOpt"), RadioButtonList).SelectedValue
            If Not sRole = "" Then
                If Roles.RoleExists(sRole) Then
                    If Not Roles.IsUserInRole(sUserName, sRole) Then
                        Roles.AddUserToRole(sUserName, sRole)
                    End If
                End If
            End If

        Else
            If CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Items.Count = 1 Then
                CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Items(0).Selected = True
            End If

            For i = 0 To CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Items.Count - 1
                If CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Items(i).Selected Then
                    sRole = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("cbRegOpt"), CheckBoxList).Items(i).Value
                    If Not sRole = "" Then
                        If Roles.RoleExists(sRole) Then
                            If Not Roles.IsUserInRole(sUserName, sRole) Then
                                Roles.AddUserToRole(sUserName, sRole)
                            End If
                        End If
                    End If

                End If
            Next
        End If

        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage
        Try
            'Dim sFrom As String
            'Dim oSmtpSection As Net.Configuration.SmtpSection = CType(ConfigurationManager.GetSection("system.net/mailSettings/smtp"), Net.Configuration.SmtpSection)
            Dim sLink As String = Me.AppFullPath() & Me.LinkRegistration & "?s=activate&uid=" & ID & "&ReturnUrl=" & Request.QueryString("ReturnUrl")
        
            Dim ToMail As MailAddress = New MailAddress(CreateUserWizard1.Email, sUserName)
            'sFrom = oSmtpSection.From.ToString
            'oMailMessage.From = New MailAddress(sFrom, sFrom)
            oMailMessage.To.Add(ToMail)
            oMailMessage.Subject = sConfirmationSubject 'GetLocalResourceObject("Subject") 'Registration Confirmation
            oMailMessage.IsBodyHtml = True

            'Dim sMessage As String=""
            'Please click the link below to complete your registration
            'sMessage += GetLocalResourceObject("PleaseClickTheLink") & ": <br />" & _
            '    "<a href=""" & sLink & """>" & sLink & "</a><br /><br />" & _
            '    GetLocalResourceObject("BestRegards") & "<br/>" & _
            '    Me.SiteName & "<br />" & _
            '    "<a href=""mailto:" & Me.SiteEmail & """>" & Me.SiteEmail & "</a>"

            sConfirmationBody = sConfirmationBody.Replace("[%LinkConfirm%]", sLink)
            sConfirmationBody = sConfirmationBody.Replace("[%SiteName%]", Me.SiteName)
            sConfirmationBody = sConfirmationBody.Replace("[%SiteEmail%]", Me.SiteEmail)

            oMailMessage.Body = "<html><head><style>body {font-family:verdana;font-size:11px}</style></head><body>" & sConfirmationBody & "</body></html>"
            oSmtpClient.Send(oMailMessage)
        
            CreateUserWizard1.CompleteSuccessText = GetLocalResourceObject("PleaseCheckEmail") 'Please check your email to confirm your registration.
            CompleteWizardStep1.Title = GetLocalResourceObject("SignUp") 'Sign Up for Your New Account
            
            CompleteWizardStep1.ContentTemplateContainer.Controls.Clear()
            CompleteWizardStep1.ContentTemplateContainer.Controls.Add(New LiteralControl("<p><b>" & GetLocalResourceObject("ThankYou") & "</b></p>"))
            CompleteWizardStep1.ContentTemplateContainer.Controls.Add(New LiteralControl("<p>" & GetLocalResourceObject("PleaseCheckEmail") & "</p>"))
        
        Catch ex As Exception
            CreateUserWizard1.CompleteSuccessText = GetLocalResourceObject("RegistrationFailed")
            Membership.DeleteUser(sUserName)
        End Try

    End Sub

    Protected Sub btnContinue_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Request.QueryString("ReturnUrl").ToString <> "" Then
            Response.Redirect(Request.QueryString("ReturnUrl").ToString)
        Else
            Response.Redirect(Me.RootFile)
        End If
    End Sub
</script>

<asp:Panel ID="panelActivate" runat="server" Visible="false" >
    <asp:Label ID="lblActivate" runat="server" Text=""></asp:Label>
    <div style="margin:20px"></div>
    <asp:Button ID="btnContinue" runat="server" meta:resourcekey="btnContinue" OnClick="btnContinue_Click" />
</asp:Panel>

<asp:CreateUserWizard ID="CreateUserWizard1" meta:resourcekey="CreateUserWizard" runat="server" 
    CreateUserButtonText="Create User"
    ContinueButtonText="Continue"    
    OnCreatedUser="CreateUserWizard1_CreatedUser" 
    ContinueDestinationPageUrl="~/default.aspx"
    DisableCreatedUser="true">
    <TitleTextStyle HorizontalAlign=Left Font-Bold=True Height=30px />
    <LabelStyle HorizontalAlign=Left />
    <WizardSteps>
        <asp:CreateUserWizardStep ID="CreateUserWizardStep1" meta:resourcekey="CreateUserWizardStep" runat="server" EnableViewState="False">
          <ContentTemplate>
            <table border="0">
              <tr>
                <td align="left" colspan="2" style="font-weight: bold; height: 30px">
                    <asp:Label ID="lblSignUp" meta:resourcekey="lblSignUp" runat="server" Text="Sign Up for Your New Account"></asp:Label>
                  </td>
              </tr>
              <tr>
                <td align="left">
                  <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">
                      <asp:Label ID="lblUserName" meta:resourcekey="lblUserName" runat="server" Text="User Name:"></asp:Label></asp:Label></td>
                <td style="width: 201px">
                  <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                    ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                <td align="left">
                  <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">
                      <asp:Label ID="lblPassword" meta:resourcekey="lblPassword" runat="server" Text="Password:"></asp:Label></asp:Label></td>
                <td style="width: 201px">
                  <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                    ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                <td align="left">
                  <asp:Label ID="ConfirmPasswordLabel" meta:resourcekey="ConfirmPasswordLabel" runat="server" Text="Confirm Password:" AssociatedControlID="ConfirmPassword"></asp:Label></td>
                <td style="width: 201px">
                  <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                    ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ValidationGroup="CreateUserWizard1" ControlToValidate="ConfirmPassword" ControlToCompare="Password" ErrorMessage="*"></asp:CompareValidator>
                </td>
              </tr>
              <tr>
                <td align="left">
                  <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">
                      <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email:"></asp:Label></asp:Label></td>
                <td style="width: 201px">
                  <asp:TextBox ID="Email" runat="server"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                    ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                <td align="left" valign="top">
                  <asp:Label ID="lblOptDescription" runat="server"></asp:Label></td>
                <td style="width: 201px;">
                  <asp:CheckBoxList ID="cbRegOpt" runat="server" DataTextField="Key" DataValueField="Value">
                  </asp:CheckBoxList>
                  <asp:RadioButtonList ID="rbRegOpt" runat="server" DataTextField="Key" DataValueField="Value">
                  </asp:RadioButtonList>
                </td>
              </tr>
              <tr>
                <td align="center" colspan="2" style="color: red">
                  <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                </td>
              </tr>
            </table>
          </ContentTemplate>
        </asp:CreateUserWizardStep>       
        <asp:CompleteWizardStep ID="CompleteWizardStep1" meta:resourcekey="CompleteWizardStep" runat="server"  >
        </asp:CompleteWizardStep>
    </WizardSteps>
</asp:CreateUserWizard>
