<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">
  Private sUsername As String = ""
  
  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    panelUserDetail.Visible = False
    panelLogin.Visible = True
    panelLogin.FindControl("Login1").Focus()
    If Me.IsUserLoggedIn Then
      If Me.IsAdministrator Then
        Dim myScript As String
        Dim sSelectedUserName As String = Request.QueryString("username")
        Dim iCount As Integer = Roles.GetRolesForUser(sSelectedUserName).GetLength(0)
        Dim i, x As Integer
        panelLogin.Visible = False
        panelUserDetail.Visible = True
        lblUserName.Text = sSelectedUserName
        btnUpdatePermision.Attributes.Add("onclick", "button=this.id")
        myScript = "<script language=Javascript>var button;<"
        myScript += "/"
        myScript += "script>"
        Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "NewScript", myScript)

        btnAdd.Attributes.Add("onclick", "add(document.getElementById('" & lsbValuableRoles.ClientID & "'),document.getElementById('" & lsbPermision.ClientID & "'));return false;")
        btnRemove.Attributes.Add("onclick", "remove(document.getElementById('" & lsbValuableRoles.ClientID & "'),document.getElementById('" & lsbPermision.ClientID & "'));return false;")
        Page.ClientScript.RegisterOnSubmitStatement(Me.GetType, "OnSubmit", "if(button == '" & btnUpdatePermision.ClientID & "'){transferValues(document.getElementById('" & lsbPermision.ClientID & "'),document.getElementById('" & hidSelRoles.ClientID & "'))}else")

        ListRoles(sSelectedUserName)

        'User profile
        Dim user As MembershipUser = Membership.GetUser(sSelectedUserName)
        Dim userProfile As ProfileCommon = Profile.GetProfile(sSelectedUserName)
        If Not Page.IsPostBack Then ' Kalau tanpa ini, wkt select Grid akan selalu tampil record teratas
          hidUserName.Value = sSelectedUserName
          lblUserName.Text = sSelectedUserName
          txtEmail.Text = user.Email
          hidEmail.Value = user.Email
          cbActive.Checked = user.IsApproved
          'cbLocked.Checked = user.IsLockedOut
          If user.IsLockedOut Then
            btnUnlock.Visible = True
          Else
            btnUnlock.Visible = False
          End If
          'txtFirstName.Text = userProfile.FirstName
          'txtLastName.Text = userProfile.LastName
          'txtCompany.Text = userProfile.Company
          'txtAddress.Text = userProfile.Address
          'txtCity.Text = userProfile.City
          'txtZip.Text = userProfile.Zip
          'txtState.Text = userProfile.State
          'dropCountry.Value = userProfile.Country
          'txtPhone.Text = userProfile.Phone
          'txtAdditionalInfo.Text = userProfile.AdditionalInfo.ToString
          txtFirstName.Text = userProfile.GetPropertyValue("FirstName").ToString
          txtLastName.Text = userProfile.GetPropertyValue("LastName").ToString
          txtCompany.Text = userProfile.GetPropertyValue("Company").ToString
          txtAddress.Text = userProfile.GetPropertyValue("Address").ToString
          txtCity.Text = userProfile.GetPropertyValue("City").ToString
          txtZip.Text = userProfile.GetPropertyValue("Zip").ToString
          txtState.Text = userProfile.GetPropertyValue("State").ToString
          dropCountry.Value = userProfile.GetPropertyValue("Country").ToString
          txtPhone.Text = userProfile.GetPropertyValue("Phone").ToString
          txtAdditionalInfo.Text = userProfile.GetPropertyValue("AdditionalInfo").ToString
        End If
        lblUpdatePasswordStatus.Text = ""
        lblStatus.Text = ""

        'List newsletter category
        cbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
        cbCategories.DataBind()

        'List selected user subscriptions
        Dim colCategories As Collection = GetSubscription(user.Email)
        If Not IsNothing(colCategories) Then
          For x = 1 To colCategories.Count
            sUsername = CType(colCategories(x), Subscription).Name
            For i = 0 To cbCategories.Items.Count - 1
              If cbCategories.Items(i).Value = CType(colCategories(x), Subscription).CategoryId Then
                cbCategories.Items(i).Selected = True
              End If
            Next
          Next
        End If
      End If
    End If
  End Sub

  Protected Sub btnUpdatePermision_click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdatePermision.Click
    If Not Me.IsUserLoggedIn Then Exit Sub

    Dim sSelectedUserName As String = hidUserName.Value
    Dim i As Integer

    'Remove user roles terlebih dahulu kemudian ditambah lagi untuk yang terselect
    If (lsbPermision.Items.Count > 0) Then
      For i = 0 To lsbPermision.Items.Count - 1
        Roles.RemoveUserFromRole(sSelectedUserName, lsbPermision.Items(i).Value)
      Next
    End If

    lsbPermision.Items.Clear()

    Dim Item As String
    If hidSelRoles.Value <> "" Then
      For Each Item In hidSelRoles.Value.Split(",")
        lsbPermision.Items.Add(Item)
        If Not Roles.IsUserInRole(sSelectedUserName, Item) Then
          Roles.AddUserToRole(sSelectedUserName, Item)
        End If
      Next
    End If

    ListRoles(sSelectedUserName)
  End Sub

  Protected Sub btnCancel_click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
    Response.Redirect(Me.LinkAdminUsers)
  End Sub

  Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
    If Not Me.IsUserLoggedIn Then Exit Sub

    Dim sSelectedUserName As String = hidUserName.Value
    Dim muSelectedUser As MembershipUser = Membership.GetUser(sSelectedUserName)
    Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(sSelectedUserName)

    If (Membership.GetUserNameByEmail(txtEmail.Text) IsNot Nothing) Then
      If Not Membership.GetUserNameByEmail(txtEmail.Text) = sSelectedUserName Then
        lblStatus.Text = GetLocalResourceObject("DuplicatedEmail")
        ListRoles(sSelectedUserName)
        Exit Sub
      End If
    End If
       
    muSelectedUser.Email = txtEmail.Text
    muSelectedUser.IsApproved = cbActive.Checked
   
    Membership.UpdateUser(muSelectedUser)

    'pcSelectedProfile.FirstName = txtFirstName.Text
    'pcSelectedProfile.LastName = txtLastName.Text
    'pcSelectedProfile.Company = txtCompany.Text
    'pcSelectedProfile.Address = txtAddress.Text
    'pcSelectedProfile.City = txtCity.Text
    'pcSelectedProfile.Zip = txtZip.Text
    'pcSelectedProfile.State = txtState.Text
    'pcSelectedProfile.Country = dropCountry.Value
    'pcSelectedProfile.Phone = txtPhone.Text
    'pcSelectedProfile.AdditionalInfo = txtAdditionalInfo.Text        
    pcSelectedProfile.SetPropertyValue("FirstName", txtFirstName.Text)
    pcSelectedProfile.SetPropertyValue("LastName", txtLastName.Text)
    pcSelectedProfile.SetPropertyValue("Company", txtCompany.Text)
    pcSelectedProfile.SetPropertyValue("Address", txtAddress.Text)
    pcSelectedProfile.SetPropertyValue("City", txtCity.Text)
    pcSelectedProfile.SetPropertyValue("Zip", txtZip.Text)
    pcSelectedProfile.SetPropertyValue("State", txtState.Text)
    pcSelectedProfile.SetPropertyValue("Country", dropCountry.Value)
    pcSelectedProfile.SetPropertyValue("Phone", txtPhone.Text)
    pcSelectedProfile.SetPropertyValue("AdditionalInfo", txtAdditionalInfo.Text)
    pcSelectedProfile.Save()

    'Update subcription
    Dim i As Integer
    Dim colSubscriptionInfo As Subscription = New Subscription
    For i = 0 To cbCategories.Items.Count - 1
      colSubscriptionInfo = CheckSubscription(hidEmail.Value, cbCategories.Items(i).Value)
      If cbCategories.Items(i).Selected Then
        'check apakah dia sudah terdaftar pad akategory tersebut ? 
        If Not IsNothing(colSubscriptionInfo) Then
          UpdateSubscription(hidEmail.Value, muSelectedUser.Email, cbCategories.Items(i).Value, False)
        Else
          If sUsername = "" Then ' Belum pernah terdaftar pada mailinglist
            sUsername = pcSelectedProfile.FirstName & " " & pcSelectedProfile.LastName
          End If
          AddSubscriber(sUsername, muSelectedUser.Email, cbCategories.Items(i).Value, False)
        End If
        'If Not Roles.IsUserInRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers") Then
        '  Roles.AddUserToRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers")
        'End If
      Else
        If Not IsNothing(colSubscriptionInfo) Then
          UpdateSubscription(hidEmail.Value, muSelectedUser.Email, cbCategories.Items(i).Value, True)
        End If
        'If Roles.IsUserInRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers") Then
        '  Roles.RemoveUserFromRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers")
        'End If
      End If
    Next

    ListRoles(sSelectedUserName)

    lblStatus.Text = GetLocalResourceObject("AccountUpdated")
  End Sub

  Protected Sub ListRoles(ByVal sSelectedUserName As String)
    Dim iCount As Integer = Roles.GetRolesForUser(sSelectedUserName).GetLength(0)
    Dim i As Integer

    'list All Roles
    lsbValuableRoles.DataSource = Roles.GetAllRoles()
    lsbValuableRoles.DataBind()

    If iCount > 0 Then
      For i = 0 To iCount - 1
        lsbValuableRoles.Items.FindByValue(Roles.GetRolesForUser(sSelectedUserName).GetValue(i)).Enabled = False
      Next
    End If

    'List User Roles
    lsbPermision.DataSource = Roles.GetRolesForUser(sSelectedUserName)
    lsbPermision.DataBind()
  End Sub

  Protected Sub btnUpdatePassword_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    If Not Me.IsUserLoggedIn Then Exit Sub

    Dim sSelectedUserName As String = hidUserName.Value

    Try
      GetUser(sSelectedUserName).ChangePassword(GetUser(sSelectedUserName).GetPassword(), txtNewPassword.Text)
    Catch ex As Exception
      GetUser(sSelectedUserName).ChangePassword(GetUser(sSelectedUserName).ResetPassword(), txtNewPassword.Text)
    End Try

    txtNewPassword.Text = ""
    txtConfirmPassword.Text = ""
    lblUpdatePasswordStatus.Text = GetLocalResourceObject("PasswordUpdated")
  End Sub

  Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
    Response.Redirect(HttpContext.Current.Items("_path"))
  End Sub

  Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
    Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
  End Sub

  Protected Sub btnUnlock_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    If Not Me.IsUserLoggedIn Then Exit Sub

    Dim sSelectedUserName As String = hidUserName.Value
    Dim muSelectedUser As MembershipUser = Membership.GetUser(sSelectedUserName)
    muSelectedUser.UnlockUser()
    Response.Redirect(HttpContext.Current.Items("_path"))
  End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:HiddenField ID="hidUserName" runat="server" />
    
<asp:Panel ID="panelUserDetail" runat="server" Visible="false">

    <table>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblUserNameLabel" meta:resourcekey="lblUserNameLabel" runat="server" Text="User Name"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:Label ID="lblUserName" runat="server" Font-Bold="True"></asp:Label>
        </td>
        <td rowspan="12" valign="top">
        
            <div style="border:#E0E0E0 1px solid;padding:10px;width:205px;margin-left:15px;margin-top:17px">
            <table>
            <tr>
                <td colspan=3>
                    <asp:Label ID="lblUpdatePassword" meta:resourcekey="lblUpdatePassword" runat="server" Font-Bold=true Text="Update Password"></asp:Label>:
                </td>
            </tr>
            <tr>
                <td nowrap=nowrap>
                    <asp:Label ID="lblNewPassword" meta:resourcekey="lblNewPassword" runat="server" Text="New Password"></asp:Label></td><td>:</td>
                <td nowrap=nowrap><asp:TextBox ID="txtNewPassword" TextMode=Password Width="50" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtNewPassword" ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td nowrap=nowrap><asp:Label ID="lblConfirm" runat="server" Text="Confirm New Password"></asp:Label></td><td>:</td>
                <td nowrap=nowrap><asp:TextBox ID="txtConfirmPassword" TextMode=Password Width="50" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtConfirmPassword" ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword" Type="String" Operator="Equal" Display="Dynamic" ID="CompareValidator1"  runat="server" ErrorMessage="*"></asp:CompareValidator>
                </td>
            </tr>
            <tr>
                 <td nowrap="nowrap" colspan="3">
                    <asp:Button ID="btnUpdatePassword" meta:resourcekey="btnUpdatePassword" runat="server" Text=" Update " OnClick="btnUpdatePassword_Click" />
                    <div style="margin-top:7px"><asp:Label ID="lblUpdatePasswordStatus" runat="server" Font-Bold="true" Text=""></asp:Label></div>
                </td>               
            </tr>
            </table>
            </div>
            
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblFirstName" meta:resourcekey="lblFirstName" runat="server" Text="First Name"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtFirstName" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblLastName" meta:resourcekey="lblLastName" runat="server" Text="Last Name"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtLastName" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email"></asp:Label>
        </td>
        <td>:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtEmail" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtEmail" runat="server" ControlToValidate="txtEmail" ValidationGroup="user_info"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblCompany" meta:resourcekey="lblCompany" runat="server" Text="Company"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtCompany" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblAddress" meta:resourcekey="lblAddress" runat="server" Text="Address"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtAddress" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblCity" meta:resourcekey="lblCity" runat="server" Text="City"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtCity" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblZip" meta:resourcekey="lblZip" runat="server" Text="Zip"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtZip" Width="250" runat="server" ></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblState" meta:resourcekey="lblState" runat="server" Text="State"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtState" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblCountry" meta:resourcekey="lblCountry" runat="server" Text="Country"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <select id="dropCountry" runat="server">
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
                <option value="IO">British Indian Ocean Territory</option>
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
                <option value="FK">Falkland Islands (Islas Malvinas)</option>
                <option value="FO">Faroe Islands</option>
                <option value="FJ">Fiji Islands</option>
                <option value="FI">Finland</option>
                <option value="FR">France</option>
                <option value="GF">French Guiana</option>
                <option value="PF">French Polynesia</option>
                <option value="TF">French Southern and Antarctic Lands</option>
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
                <option value="HM">Heard Island and McDonald Islands</option>
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
                <option value="MK">Macedonia, Former Yugoslav Republic of</option>
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
                <option value="GS">South Georgia and the South Sandwich Islands</option>
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
                <option value="US" selected=selected>United States</option>
                <option value="UM">United States Minor Outlying Islands</option>
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
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
              <asp:Label ID="lblPhone" meta:resourcekey="lblPhone" runat="server" Text="Phone"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtPhone" Width="250" runat="server" ></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap" valign="top">
            <asp:Label ID="lblAdditionalInfo" meta:resourcekey="lblAdditionalInfo" runat="server" Text="Additional Info"></asp:Label></label></td>
        <td valign="top">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtAdditionalInfo" TextMode="MultiLine" Width="250" Height="60" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
              <asp:Label ID="lblActive" meta:resourcekey="lblActive" runat="server" Text="Active"></asp:Label>
        </td>
        <td>:</td>
        <td>
          <asp:CheckBox ID="cbActive" runat="server" />
        </td>
    </tr>
   <%-- <tr>
        <td style="text-align:left;white-space:nowrap">
              <asp:Label ID="lblLocked" meta:resourcekey="lblActive" runat="server" Text="Locked"></asp:Label>
        </td>
        <td>:</td>
        <td>
          <asp:CheckBox ID="cbLocked" runat="server" />
        </td>
    </tr>--%>
 
    <tr>
        <td colspan="4">
            <div style="margin:7px"></div>
            <%=GetLocalResourceObject("Subscriptions")%>
            <div style="margin:7px"></div>
            <asp:CheckBoxList ID="cbCategories" runat="server"  DataTextField="category" DataValueField="category_id">
            </asp:CheckBoxList>
        </td>
    </tr>
    <tr>
        <td style="text-align: left;padding-top:5px;white-space:nowrap" colspan="4">                        
            <asp:Button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text="Update Account" ValidationGroup="user_info" />
          <asp:Button ID="btnUnlock" meta:resourcekey="btnUnlock" runat="server" Text="Unlock" Visible="false" OnClick="btnUnlock_Click" ValidationGroup="user_info" />
            <asp:Label ID="lblStatus" runat="server" Font-Bold="True"></asp:Label>&nbsp;
        </td>
    </tr>
</table>
<div style="margin:10px"></div>
<hr />
<div style="margin:10px"></div>

<table>
    <tr>
        <td><asp:Label ID="lblAvailableRoles" meta:resourcekey="lblAvailableRoles" runat="server" Text="Available Roles" ></asp:Label>:</td>
        <td></td>
        <td><asp:Label ID="lblCurrentRoles" meta:resourcekey="lblCurrentRoles" runat="server" Text="Selected Roles" ></asp:Label>:<br /></td>
    </tr>
    <tr>
        <td><asp:ListBox ID="lsbValuableRoles" runat="server"  Rows="5" SelectionMode="Multiple" Width="225"></asp:ListBox></td>
        <td>
            <table>
                <tr>
                    <td><asp:Button ID="btnAdd" meta:resourcekey="btnAdd" width="100px" Text="Add" runat="server" UseSubmitBehavior="false"  /></td>
                </tr>
                <tr>
                    <td><asp:Button ID="btnRemove" meta:resourcekey="btnRemove" width="100px" Text="Remove" runat="server" UseSubmitBehavior="false" /></td>
                </tr>
            </table>
        </td>
        <td><asp:ListBox ID="lsbPermision" runat="server"  Rows="5" SelectionMode="Multiple" Width="225"> </asp:ListBox></td>
    </tr>
    <tr><td colspan="3"><asp:Label ID="lblSelectionNote" meta:resourcekey="lblSelectionNote" runat="server" Text="Use CTRL to select multiple Roles." ></asp:Label></td></tr>
    <tr>
        <td colspan="3" style="padding-top:10px">
            <asp:Button ID="btnUpdatePermision" meta:resourcekey="btnUpdatePermision" runat="server" Text="Update User's Roles"  
                OnClick="btnUpdatePermision_click" CausesValidation=false  />
             <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " CausesValidation=false OnClick="btnCancel_click" />
             <br /><br />
        </td>
    </tr>
</table>         
           
<asp:HiddenField ID="hidSelRoles" runat="server" />
<asp:HiddenField ID="hidEmail" runat="server" />
</asp:Panel>
        
<script type="text/javascript" language="javascript">
	function add(El,El2)
		{
		 var oList1 = El;
		 var oList2 = El2;
		 var w =0;
		 var count = parseInt(oList1.length);
		 for (var i = 0; i < count; i++)
		    {
		    if ( oList1.options[w].selected)
		        {
		        var sText = oList1.options[w].value;
		        oList2.options[El2.length] = new Option(sText,sText,false,false); 
		        oList1.options[w]=null;
		        } 
		     else
		        w++;
		     }
	    }
	
	function remove(El2,El)
		{
		 var oList1 = El;
		 var oList2 = El2;
		 var w =0;
		 var count = parseInt(oList1.length);
		 for (var i = 0; i < count; i++)
		    {
		    if ( oList1.options[w].selected)
		        {
		        var sText = oList1.options[w].value;
		        oList2.options[El2.length] = new Option(sText,sText,false,false); 
		        oList1.options[w]=null;
		        } 
		     else
		        w++;
		     }
	    }
		    
    function transferValues(oList,oHid)
        {
        var sTmp="";
        for (var i = 0; i < oList.length; i++)
		    {
		    oList.options[i].selected = false;
		    sTmp+=","+oList.options[i].value;
		    } 
		oHid.value=sTmp.substring(1);
	  }
</script>
