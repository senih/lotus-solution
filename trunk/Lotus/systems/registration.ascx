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
        Dim sFirstName As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("FirstName"), TextBox).Text
        Dim sLastName As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("LastName"), TextBox).Text
        Dim sCompany As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("Company"), TextBox).Text
        Dim sPhone As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("Phone"), TextBox).Text
        Dim sAddress As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("Address"), TextBox).Text
        Dim sCity As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("City"), TextBox).Text
        Dim sPostalCode As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("PostalCode"), TextBox).Text
        Dim sCountry As String = CType(CreateUserWizardStep1.ContentTemplateContainer.FindControl("Country"), HtmlSelect).Value
        Dim ID As String = Membership.GetUser(sUserName).ProviderUserKey.ToString.ToUpper
        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(sUserName)

        pcSelectedProfile.UseWYSIWYG = True
        pcSelectedProfile.FirstName = sFirstName
        pcSelectedProfile.LastName = sLastName
        pcSelectedProfile.Company = sCompany
        pcSelectedProfile.Phone = sPhone
        pcSelectedProfile.Address = sAddress
        pcSelectedProfile.City = sCity
        pcSelectedProfile.Zip = sPostalCode
        pcSelectedProfile.Country = sCountry
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
            CreateUserWizard1.CompleteSuccessText = GetLocalResourceObject("RegistrationFailed") & ex.Message
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

<asp:CreateUserWizard ID="CreateUserWizard1" 
    meta:resourcekey="CreateUserWizard" runat="server" 
    CreateUserButtonText="Create User"
    ContinueButtonText="Continue"    
    OnCreatedUser="CreateUserWizard1_CreatedUser" 
    ContinueDestinationPageUrl="~/default.aspx"
    DisableCreatedUser="true" Width="98%">
    <TitleTextStyle HorizontalAlign=Left Font-Bold=True Height=30px />
    <LabelStyle HorizontalAlign=Left />
    <WizardSteps>
        <asp:CreateUserWizardStep ID="CreateUserWizardStep1" meta:resourcekey="CreateUserWizardStep" runat="server" EnableViewState="False">
          <ContentTemplate>
            <table border="0" style="width:736px;">
              <tr>
                  <td align="left" colspan="4">
                      <asp:Label ID="lblSignUp" runat="server" meta:resourcekey="lblSignUp" 
                          Text="Sign Up for Your New Account" CssClass="subTitle"></asp:Label>
                  </td>
              </tr>
                <tr>
                    <td align="left" style="width: 25%">
                        <asp:Label ID="FirstNameLabel" runat="server" AssociatedControlID="FirstName">
                        <asp:Label ID="lblFirstName" runat="server" meta:resourcekey="lblFirstName" 
                            Text="First Name:"></asp:Label>
                        </asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="FirstName" runat="server" TabIndex=0></asp:TextBox>
                        <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" 
                            ControlToValidate="FirstName" ErrorMessage="*" 
                            ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                    </td>
                    <td align="left" style="width: 25%">
                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">
                        <asp:Label ID="lblUserName" runat="server" meta:resourcekey="lblUserName" 
                            Text="User Name:"></asp:Label>
                        </asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="UserName" runat="server" TabIndex=9></asp:TextBox>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                            ControlToValidate="UserName" ErrorMessage="*" 
                            ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
              <tr>
                  <td >
                      <asp:Label ID="LastNameLabel" runat="server" AssociatedControlID="LastName">
                      <asp:Label ID="lblLastName" runat="server" meta:resourcekey="lbllastName" 
                          Text="Last Name:"></asp:Label>
                      </asp:Label>
                  </td>
                  <td >
                      <asp:TextBox ID="LastName" runat="server" TabIndex=1></asp:TextBox>
                      <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" 
                          ControlToValidate="LastName" ErrorMessage="*" 
                          ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                  </td>
                <td align="left">
                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">
                    <asp:Label ID="lblPassword" runat="server" meta:resourcekey="lblPassword" 
                        Text="Password:"></asp:Label>
                    </asp:Label>
                  </td>
                <td >
                    <asp:TextBox ID="Password" runat="server" TextMode="Password" TabIndex=10></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                        ControlToValidate="Password" ErrorMessage="*" 
                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                  <td ><asp:Label ID="CompanyLabel" runat="server" AssociatedControlID="Company">
                      <asp:Label ID="lblCompany" runat="server" meta:resourcekey="lblCompany" 
                          Text="Company:"></asp:Label>
                      </asp:Label></td>
                  <td ><asp:TextBox ID="Company" runat="server" TabIndex=2></asp:TextBox></td>
                <td align="left">
                    <asp:Label ID="ConfirmPasswordLabel" runat="server" 
                        AssociatedControlID="ConfirmPassword" meta:resourcekey="ConfirmPasswordLabel" 
                        Text="Confirm Password:"></asp:Label>
                  </td>
                <td >
                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" TabIndex=11></asp:TextBox>
                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" 
                        ControlToValidate="ConfirmPassword" ErrorMessage="*" 
                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
                        ErrorMessage="*" ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
                </td>
              </tr>
              <tr>
                  <td><asp:Label ID="PhoneLabel" runat="server" AssociatedControlID="Phone">
                      <asp:Label ID="lblPhone" runat="server" meta:resourcekey="lblPhone" 
                          Text="Phone:"></asp:Label>
                      </asp:Label>
                  </td>
                  <td><asp:TextBox ID="Phone" runat="server" TabIndex=3></asp:TextBox>
                      <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" 
                          ControlToValidate="Phone" ErrorMessage="*" 
                          ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator></td>
                <td align="left">
                    <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">
                    <asp:Label ID="lblEmail" runat="server" meta:resourcekey="lblEmail" 
                        Text="Email:"></asp:Label>
                    </asp:Label>
                  </td>
                <td>
                    <asp:TextBox ID="Email" runat="server" TabIndex=12></asp:TextBox>
                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" 
                        ControlToValidate="Email" ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                  <td  valign="top">
                     <asp:Label ID="AddressLabel" runat="server" AssociatedControlID="Address">
                    <asp:Label ID="lblAddress" runat="server" meta:resourcekey="lblAddress" 
                        Text="Address:"></asp:Label>
                    </asp:Label>
                  </td>
                  <td>
                      <asp:TextBox ID="Address" runat="server" TabIndex=5></asp:TextBox>
                    <asp:RequiredFieldValidator ID="AddressRequired" runat="server" 
                        ControlToValidate="Address" ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                  </td>
                <td align="left" valign="top">
                    <asp:Label ID="lblOptDescription" runat="server"></asp:Label>
                  </td>
                <td style="width: 201px">
                    <asp:CheckBoxList ID="cbRegOpt" runat="server" DataTextField="Key" 
                        DataValueField="Value">
                    </asp:CheckBoxList>
                    <asp:RadioButtonList ID="rbRegOpt" runat="server" DataTextField="Key" 
                        DataValueField="Value">
                    </asp:RadioButtonList>
                </td>
              </tr>
              <tr>
                  <td  valign="top">
                     <asp:Label ID="CityLabel" runat="server" AssociatedControlID="City">
                    <asp:Label ID="lblCity" runat="server" meta:resourcekey="lblCity" 
                        Text="City:"></asp:Label>
                    </asp:Label>
                  </td>
                  <td>
                      <asp:TextBox ID="City" runat="server" TabIndex=6></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CityRequiredField" runat="server" 
                        ControlToValidate="City" ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                  </td>
                <td align="left" valign="top">
                    &nbsp;</td>
                <td style="width: 201px;">
                    &nbsp;</td>
              </tr>
                <tr>
                    <td  valign="top">
                     <asp:Label ID="PostalCodeLabel" runat="server" AssociatedControlID="PostalCode">
                    <asp:Label ID="lblPostalCode" runat="server" meta:resourcekey="lblPostalCode" 
                        Text="Postal Code:"></asp:Label>
                    </asp:Label>
                  </td>
                  <td>
                      <asp:TextBox ID="PostalCode" runat="server" TabIndex=7></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" 
                        ControlToValidate="PostalCode" ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                  </td>
                    <td align="left" valign="top">
                        &nbsp;</td>
                    <td >
                        &nbsp;</td>
                </tr>
                <tr>
                    <td  valign="top">
                     <asp:Label ID="CountryLabel" runat="server" AssociatedControlID="Country">
                    <asp:Label ID="lblCountry" runat="server" meta:resourcekey="lblCountry" 
                        Text="Country:"></asp:Label>
                    </asp:Label>
                  </td>
                  <td>
                    <select id="Country" runat="server" TabIndex=8>
                        <option value=""></option>
                        <option value="AF">Afghanistan</option>
                        <option value="AL">Albania</option>
                        <option value="DZ">Algeria</option>
                        <option value="AS">American Samoa</option>
                        <option value="AD">Andorra</option>
                        <option value="AO">Angola</option>
                        <option value="AI">Anguilla</option>
                        <option value="AQ">Antarctica</option>
                        <option value="AG">Antigua and Barbuda</option>
                        <option value="AR">Argentina</option>
                        <option value="AM">Armenia</option>
                        <option value="AW">Aruba</option>
                        <option value="AC">Ascension Island</option>
                        <option value="AU">Australia</option>
                        <option value="AT">Austria</option>
                        <option value="AZ">Azerbaijan</option>
                        <option value="BS">Bahamas</option>
                        <option value="BH">Bahrain</option>
                        <option value="BD">Bangladesh</option>
                        <option value="BB">Barbados</option>
                        <option value="BY">Belarus</option>
                        <option value="BE">Belgium</option>
                        <option value="BZ">Belize</option>
                        <option value="BJ">Benin</option>
                        <option value="BM">Bermuda</option>
                        <option value="BT">Bhutan</option>
                        <option value="BO">Bolivia</option>
                        <option value="BA">Bosnia and Herzegovina</option>
                        <option value="BW">Botswana</option>
                        <option value="BV">Bouvet Island</option>
                        <option value="BR">Brazil</option>
                        <option value="IO">British Indian</option>
                        <option value="BN">Brunei</option>
                        <option value="BG">Bulgaria</option>
                        <option value="BF">Burkina Faso</option>
                        <option value="BI">Burundi</option>
                        <option value="KH">Cambodia</option>
                        <option value="CM">Cameroon</option>
                        <option value="CA">Canada</option>
                        <option value="CV">Cape Verde</option>
                        <option value="KY">Cayman Islands</option>
                        <option value="CF">Central African Republic</option>
                        <option value="TD">Chad</option>
                        <option value="CL">Chile</option>
                        <option value="CN">China</option>
                        <option value="CX">Christmas Island</option>
                        <option value="CC">Cocos (Keeling) Islands</option>
                        <option value="CO">Colombia</option>
                        <option value="KM">Comoros</option>
                        <option value="CD">Congo (DRC)</option>
                        <option value="CG">Congo</option>
                        <option value="CK">Cook Islands</option>
                        <option value="CR">Costa Rica</option>
                        <option value="CI">Côte d'Ivoire</option>
                        <option value="HR">Croatia</option>
                        <option value="CU">Cuba</option>
                        <option value="CY">Cyprus</option>
                        <option value="CZ">Czech Republic</option>
                        <option value="DK">Denmark</option>
                        <option value="DJ">Djibouti</option>
                        <option value="DM">Dominica</option>
                        <option value="DO">Dominican Republic</option>
                        <option value="EC">Ecuador</option>
                        <option value="EG">Egypt</option>
                        <option value="SV">El Salvador</option>
                        <option value="GQ">Equatorial Guinea</option>
                        <option value="ER">Eritrea</option>
                        <option value="EE">Estonia</option>
                        <option value="ET">Ethiopia</option>
                        <option value="FK">Falkland Islands</option>
                        <option value="FO">Faroe Islands</option>
                        <option value="FJ">Fiji Islands</option>
                        <option value="FI">Finland</option>
                        <option value="FR">France</option>
                        <option value="GF">French Guiana</option>
                        <option value="PF">French Polynesia</option>
                        <option value="TF">French Southern</option>
                        <option value="GA">Gabon</option>
                        <option value="GM">Gambia, The</option>
                        <option value="GE">Georgia</option>
                        <option value="DE">Germany</option>
                        <option value="GH">Ghana</option>
                        <option value="GI">Gibraltar</option>
                        <option value="GR">Greece</option>
                        <option value="GL">Greenland</option>
                        <option value="GD">Grenada</option>
                        <option value="GP">Guadeloupe</option>
                        <option value="GU">Guam</option>
                        <option value="GT">Guatemala</option>
                        <option value="GG">Guernsey</option>
                        <option value="GN">Guinea</option>
                        <option value="GW">Guinea-Bissau</option>
                        <option value="GY">Guyana</option>
                        <option value="HT">Haiti</option>
                        <option value="HM">Heard Island</option>
                        <option value="HN">Honduras</option>
                        <option value="HK">Hong Kong SAR</option>
                        <option value="HU">Hungary</option>
                        <option value="IS">Iceland</option>
                        <option value="IN">India</option>
                        <option value="ID">Indonesia</option>
                        <option value="IR">Iran</option>
                        <option value="IQ">Iraq</option>
                        <option value="IE">Ireland</option>
                        <option value="IM">Isle of Man</option>
                        <option value="IL">Israel</option>
                        <option value="IT">Italy</option>
                        <option value="JM">Jamaica</option>
                        <option value="JP">Japan</option>
                        <option value="JO">Jordan</option>
                        <option value="JE">Jersey</option>
                        <option value="KZ">Kazakhstan</option>
                        <option value="KE">Kenya</option>
                        <option value="KI">Kiribati</option>
                        <option value="KR">Korea</option>
                        <option value="KW">Kuwait</option>
                        <option value="KG">Kyrgyzstan</option>
                        <option value="LA">Laos</option>
                        <option value="LV">Latvia</option>
                        <option value="LB">Lebanon</option>
                        <option value="LS">Lesotho</option>
                        <option value="LR">Liberia</option>
                        <option value="LY">Libya</option>
                        <option value="LI">Liechtenstein</option>
                        <option value="LT">Lithuania</option>
                        <option value="LU">Luxembourg</option>
                        <option value="MO">Macao SAR</option>
                        <option value="MK">Macedonia</option>
                        <option value="MG">Madagascar</option>
                        <option value="MW">Malawi</option>
                        <option value="MY">Malaysia</option>
                        <option value="MV">Maldives</option>
                        <option value="ML">Mali</option>
                        <option value="MT">Malta</option>
                        <option value="MH">Marshall Islands</option>
                        <option value="MQ">Martinique</option>
                        <option value="MR">Mauritania</option>
                        <option value="MU">Mauritius</option>
                        <option value="YT">Mayotte</option>
                        <option value="MX">Mexico</option>
                        <option value="FM">Micronesia</option>
                        <option value="MD">Moldova</option>
                        <option value="MC">Monaco</option>
                        <option value="MN">Mongolia</option>
                        <option value="MS">Montserrat</option>
                        <option value="MA">Morocco</option>
                        <option value="MZ">Mozambique</option>
                        <option value="MM">Myanmar</option>
                        <option value="NA">Namibia</option>
                        <option value="NR">Nauru</option>
                        <option value="NP">Nepal</option>
                        <option value="AN">Netherlands Antilles</option>
                        <option value="NL">Netherlands, The</option>
                        <option value="NC">New Caledonia</option>
                        <option value="NZ">New Zealand</option>
                        <option value="NI">Nicaragua</option>
                        <option value="NE">Niger</option>
                        <option value="NG">Nigeria</option>
                        <option value="NU">Niue</option>
                        <option value="NF">Norfolk Island</option>
                        <option value="KP">North Korea</option>
                        <option value="MP">Northern Mariana Islands</option>
                        <option value="NO">Norway</option>
                        <option value="OM">Oman</option>
                        <option value="PK">Pakistan</option>
                        <option value="PW">Palau</option>
                        <option value="PS">Palestinian Authority</option>
                        <option value="PA">Panama</option>
                        <option value="PG">Papua New Guinea</option>
                        <option value="PY">Paraguay</option>
                        <option value="PE">Peru</option>
                        <option value="PH">Philippines</option>
                        <option value="PN">Pitcairn Islands</option>
                        <option value="PL">Poland</option>
                        <option value="PT">Portugal</option>
                        <option value="PR">Puerto Rico</option>
                        <option value="QA">Qatar</option>
                        <option value="RE">Reunion</option>
                        <option value="RO">Romania</option>
                        <option value="RU">Russia</option>
                        <option value="RW">Rwanda</option>
                        <option value="WS">Samoa</option>
                        <option value="SM">San Marino</option>
                        <option value="ST">São Tomé and Príncipe</option>
                        <option value="SA">Saudi Arabia</option>
                        <option value="SN">Senegal</option>
                        <option value="YU">Serbia and Montenegro</option>
                        <option value="SC">Seychelles</option>
                        <option value="SL">Sierra Leone</option>
                        <option value="SG">Singapore</option>
                        <option value="SK">Slovakia</option>
                        <option value="SI">Slovenia</option>
                        <option value="SB">Solomon Islands</option>
                        <option value="SO">Somalia</option>
                        <option value="ZA">South Africa</option>
                        <option value="GS">South Georgia</option>
                        <option value="ES">Spain</option>
                        <option value="LK">Sri Lanka</option>
                        <option value="SH">St. Helena</option>
                        <option value="KN">St. Kitts and Nevis</option>
                        <option value="LC">St. Lucia</option>
                        <option value="PM">St. Pierre and Miquelon</option>
                        <option value="VC">St. Vincent and the Grenadines</option>
                        <option value="SD">Sudan</option>
                        <option value="SR">Suriname</option>
                        <option value="SJ">Svalbard and Jan Mayen</option>
                        <option value="SZ">Swaziland</option>
                        <option value="SE">Sweden</option>
                        <option value="CH">Switzerland</option>
                        <option value="SY">Syria</option>
                        <option value="TW">Taiwan</option>
                        <option value="TJ">Tajikistan</option>
                        <option value="TZ">Tanzania</option>
                        <option value="TH">Thailand</option>
                        <option value="TP">Timor-Leste</option>
                        <option value="TG">Togo</option>
                        <option value="TK">Tokelau</option>
                        <option value="TO">Tonga</option>
                        <option value="TT">Trinidad and Tobago</option>
                        <option value="TA">Tristan da Cunha</option>
                        <option value="TN">Tunisia</option>
                        <option value="TR">Turkey</option>
                        <option value="TM">Turkmenistan</option>
                        <option value="TC">Turks and Caicos Islands</option>
                        <option value="TV">Tuvalu</option>
                        <option value="UG">Uganda</option>
                        <option value="UA">Ukraine</option>
                        <option value="AE">United Arab Emirates</option>
                        <option value="UK">United Kingdom</option>
                        <option value="US">United States</option>
                        <option value="UM">United States Minor</option>
                        <option value="UY">Uruguay</option>
                        <option value="UZ">Uzbekistan</option>
                        <option value="VU">Vanuatu</option>
                        <option value="VA">Vatican City</option>
                        <option value="VE">Venezuela</option>
                        <option value="VN">Vietnam</option>
                        <option value="VI">Virgin Islands</option>
                        <option value="VG">Virgin Islands, British</option>
                        <option value="WF">Wallis and Futuna</option>
                        <option value="YE">Yemen</option>
                        <option value="ZM">Zambia</option>
                        <option value="ZW">Zimbabwe</option>
                        </select>
                      
                    <asp:RequiredFieldValidator ID="CountryRequired" runat="server" 
                        ControlToValidate="Country" ErrorMessage="*" ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                  </td>
                    <td align="left" valign="top">
                        &nbsp;</td>
                    <td >
                        &nbsp;</td>
                </tr>
              <tr>
                <td align="center" colspan="4" style="color: red">
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
