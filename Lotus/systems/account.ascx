<%@ Control Language="VB" Inherits="BaseUserControl" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.sqlClient"%>
<%@ Import Namespace="system.IO" %>
<%@ Import Namespace="System.Drawing"  %>
<%@ Import Namespace="System.Drawing.Imaging"  %>
<%@ Import Namespace="System.Drawing.Drawing2D"  %>

<script runat="server">  
    Private sUsername As String = ""
    Private sAppPath As String = Context.Request.ApplicationPath
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private bPhoto As Boolean
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        panelUpdateAccount.Visible = False
        panelLogin.Visible = True
        panelLogin.FindControl("Login1").Focus()

        If Not IsNothing(GetUser) Then
            panelLogin.Visible = False
            panelUpdateAccount.Visible = True
            Dim muSelectedUser As MembershipUser = Membership.GetUser()

            hidEmail.Value = muSelectedUser.Email
            lblUserName.Text = muSelectedUser.UserName.ToString
            txtEmail.Text = muSelectedUser.Email.ToString
            
            txtFirstName.Text = Profile.GetPropertyValue("FirstName").ToString
            txtLastName.Text = Profile.GetPropertyValue("LastName").ToString
            txtCompany.Text = Profile.GetPropertyValue("Company").ToString
            txtAddress.Text = Profile.GetPropertyValue("Address").ToString
            txtCity.Text = Profile.GetPropertyValue("City").ToString
            txtZip.Text = Profile.GetPropertyValue("Zip").ToString
            txtState.Text = Profile.GetPropertyValue("State").ToString
            dropCountry.Value = Profile.GetPropertyValue("Country").ToString
            txtPhone.Text = Profile.GetPropertyValue("Phone").ToString
            txtAdditionalInfo.Text = Profile.GetPropertyValue("AdditionalInfo").ToString
                        
            lblSucceed.Visible = False

            'list selected subscriptions
            Dim i, x As Integer
            cbCategories.DataSource = GetCategoriesByRootID(Me.RootID, True, True)
            cbCategories.DataBind()

            Dim colCategories As Collection = GetSubscription(muSelectedUser.Email)
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
        
            If cbCategories.Items.Count > 0 Then
                lblSubscriptions.Visible = True
            Else
                lblSubscriptions.Visible = False
            End If
  
            'get photo
            Dim oCmd As SqlCommand
            Dim oReader As SqlDataReader

            oConn.Open()
            oCmd = New SqlCommand("select * from membership_add where user_name=@name")
            oCmd.Parameters.Add("@name", SqlDbType.VarChar, 200).Value = muSelectedUser.UserName
            oCmd.Connection = oConn
            oReader = oCmd.ExecuteReader
            oReader.Read()

            If oReader.HasRows Then
                If sAppPath <> "/" Then
                    imgUser.ImageUrl = sAppPath & "/resources/photos/" & oReader("fileUrl").ToString
                Else
                    imgUser.ImageUrl = "/resources/photos/" & oReader("fileUrl").ToString
                End If
                bPhoto = True
            Else
                If sAppPath <> "/" Then
                    imgUser.ImageUrl = sAppPath & "/resources/photos/blank.gif"
                Else
                    imgUser.ImageUrl = "/resources/photos/blank.gif"
                End If
                bPhoto = False
            End If
                     
            oConn.Close()
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim muSelectedUser As MembershipUser = Membership.GetUser()
        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(muSelectedUser.UserName)

        muSelectedUser.Email = txtEmail.Text
        Membership.UpdateUser(muSelectedUser)

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

        'save photo
        Dim oCmd As SqlCommand
        
        oConn.Open()
        
        If uplImage.FileName <> "" Then
            If Not bPhoto Then
                oCmd = New SqlCommand("Insert into membership_add(user_name,fileUrl) values (@name, @fileUrl)")
                oCmd.Parameters.Add("@name", SqlDbType.VarChar, 200).Value = Membership.GetUser().UserName
                oCmd.Parameters.Add("@fileUrl", SqlDbType.VarChar, 200).Value = Membership.GetUser().UserName & ".jpg"
            Else
                oCmd = New SqlCommand("Update membership_add set fileUrl=@fileUrl where user_name=@name")
                oCmd.Parameters.Add("@name", SqlDbType.VarChar, 200).Value = Membership.GetUser().UserName
                oCmd.Parameters.Add("@fileUrl", SqlDbType.VarChar, 200).Value = Membership.GetUser().UserName & ".jpg"
            End If
            
            oCmd.Connection = oConn
            oCmd.ExecuteNonQuery()
        End If
        
        oConn.Close()
        
        'save image file
        Dim sImagePath As String
        
        If uplImage.FileName <> "" Then
            With uplImage.PostedFile
                If Not (.ContentType.ToString = "application/octet-stream" Or .ContentType.ToString = "application/xml" _
                    Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "cgi" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "pl" _
                    Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "asp" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "aspx") Then
                    
                    If Not Directory.Exists(Server.MapPath("") & "\resources\photos\") Then
                        Directory.CreateDirectory(Server.MapPath("") & "\resources\photos\")
                    End If
                    
                    sImagePath = Server.MapPath("") & "\resources\photos\" & uplImage.FileName
                    
                    uplImage.SaveAs(sImagePath)
                    
                    Dim nSizeThumb, nNewWidth, nNewHeight, nJpegQuality As Integer
                    Dim imgOri As System.Drawing.Image
                                        
                    nSizeThumb = 100
                    nJpegQuality = 90
                        
                    imgOri = System.Drawing.Image.FromFile(sImagePath)
                    nNewWidth = imgOri.Size.Width
                    nNewHeight = imgOri.Size.Height
                    
                    If nNewWidth < nSizeThumb And nNewHeight < nSizeThumb Then
                        'noop
                    ElseIf nNewWidth > nNewHeight Then
                        nNewHeight = nNewHeight * (nSizeThumb / nNewWidth)
                        nNewWidth = nSizeThumb
                    ElseIf nNewWidth < nNewHeight Then
                        nNewWidth = nNewWidth * (nSizeThumb / nNewHeight)
                        nNewHeight = nSizeThumb
                    Else
                        nNewWidth = nSizeThumb
                        nNewHeight = nSizeThumb
                    End If
        
                    Dim imgThumb As System.Drawing.Image = New Bitmap(nNewWidth, nNewHeight)
                    Dim gr As Graphics = Graphics.FromImage(imgThumb)
                    
                    gr.InterpolationMode = InterpolationMode.HighQualityBicubic
                    gr.SmoothingMode = SmoothingMode.HighQuality
                    gr.PixelOffsetMode = PixelOffsetMode.HighQuality
                    gr.CompositingQuality = CompositingQuality.HighQuality
                    gr.DrawImage(imgOri, 0, 0, nNewWidth, nNewHeight)
    
                    Dim info() As ImageCodecInfo = ImageCodecInfo.GetImageEncoders()
                    Dim ePars As EncoderParameters = New EncoderParameters(1)
                    ePars.Param(0) = New EncoderParameter(Imaging.Encoder.Quality, nJpegQuality)
                    Response.ContentType = "image/jpeg"
                    imgThumb.Save(Server.MapPath("") & "\resources\photos\" & Membership.GetUser.UserName & ".jpg", info(1), ePars)
                    imgThumb.Dispose()
                    imgOri.Dispose()
                    
                    File.Delete(sImagePath)
                End If
            End With
        End If
        
        'Update subscriptions
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
                '    Roles.AddUserToRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers")
                'End If

            Else
                If Not IsNothing(colSubscriptionInfo) Then
                    UpdateSubscription(hidEmail.Value, muSelectedUser.Email, cbCategories.Items(i).Value, True)
                End If
                'If Roles.IsUserInRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers") Then
                '    Roles.RemoveUserFromRole(muSelectedUser.UserName, "Mailing List - " & cbCategories.Items(i).Text & " Subscribers")
                'End If
            End If
        Next

        lblSucceed.Visible = True
        Response.Redirect("account.aspx")
    End Sub

    Protected Sub ChangePassword1_ContinueButtonClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles ChangePassword1.ContinueButtonClick
        Response.Redirect(Me.LinkWorkspaceAccount)
    End Sub

    Protected Sub lnkForgot_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        panelUpdateAccount.Visible = False
        panelLogin.Visible = True
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkWorkspace)
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

<asp:Panel ID="panelUpdateAccount" runat="server" Visible="false">

<table border="0" style="margin-top:20px"> 
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblUserNameLabel" meta:resourcekey="lblUserNameLabel" runat="server" Text="User Name"></asp:Label>
        </td>
        <td style="text-align:left;">:</td>
        <td>
            &nbsp;<asp:Label ID="lblUserName" runat="server" Font-Bold="True"></asp:Label>
        </td>
        <td rowspan="12" valign="top">
            <div style="border:#E0E0E0 1px solid;padding:10px;width:205px;margin-left:15px;margin-top:17px">
            <asp:ChangePassword ID="ChangePassword1" meta:resourcekey="ChangePassword1" SuccessText="aaa" runat="server" SuccessTextStyle-Wrap=false>
            <ChangePasswordTemplate>
                <table border="0" cellpadding="0">
                        <tr>
                            <td colspan="2" style="padding-bottom:7px">
                                <asp:Label ID="lblChangePassword" meta:resourcekey="lblChangePassword" runat="server" Font-Bold="true" Text="Change Your Password"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left">
                                <asp:Label ID="lblCurrentPasswordLabel" meta:resourcekey="lblCurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword">Password</asp:Label>:</td>
                            <td style="white-space:nowrap;width:100%">
                                <asp:TextBox ID="CurrentPassword" Width="50" runat="server" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword"
                                    ErrorMessage="*" ValidationGroup="ChangePassword1"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left">
                                <asp:Label ID="lblNewPasswordLabel" meta:resourcekey="lblNewPasswordLabel" runat="server" AssociatedControlID="NewPassword">New Password</asp:Label>:</td>
                            <td style="white-space:nowrap">
                                <asp:TextBox ID="NewPassword" Width="50" runat="server" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword"
                                    ErrorMessage="*" ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left" style="white-space:nowrap">
                                <asp:Label ID="lblConfirmNewPasswordLabel" meta:resourcekey="lblConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword">Confirm New Password</asp:Label>:</td>
                            <td nowrap=nowrap>
                                <asp:TextBox ID="ConfirmNewPassword" Width="50" runat="server" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword"
                                    ErrorMessage="*" ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left" colspan="2">
                                <asp:CompareValidator ID="cvNewPasswordCompare" meta:resourcekey="cvNewPasswordCompare" runat="server" ControlToCompare="NewPassword"
                                    ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="The Confirm New Password must match the New Password entry."
                                    ValidationGroup="ChangePassword1"></asp:CompareValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left" colspan="2" style="color: red">
                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td align="Left" colspan="2">
                                <asp:Button ID="btnChangePassword" meta:resourcekey="btnChangePassword" runat="server" CommandName="ChangePassword"
                                    Text="Change Password" ValidationGroup="ChangePassword1" />
                            </td>
                        </tr>
                    </table>                
            </ChangePasswordTemplate>
            </asp:ChangePassword>
            </div>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblFirstName" meta:resourcekey="lblFirstName" runat="server" Text="First Name"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtFirstName" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtFirstName" runat="server" ControlToValidate="txtFirstName" ValidationGroup="Account"
            ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblLastName" meta:resourcekey="lblLastName" runat="server" Text="Last Name"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtLastName" Width="250" runat="server"></asp:TextBox>&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtEmail" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtEmail" runat="server" ControlToValidate="txtEmail" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblCompany" meta:resourcekey="lblCompany" runat="server" Text="Company"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtCompany" Width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
       <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblAddress" meta:resourcekey="lblAddress" runat="server" Text="Address"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtAddress" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtAddress" runat="server" ControlToValidate="txtAddress" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblCity" meta:resourcekey="lblCity" runat="server" Text="City"></asp:Label>
        </td>
        <td align="left" style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtCity" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtCity" runat="server" ControlToValidate="txtCity" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblZip" meta:resourcekey="lblZip" runat="server" Text="Zip"></asp:Label>
        </td>
        <td style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtZip" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtZip" runat="server" ControlToValidate="txtZip" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblState" meta:resourcekey="lblState" runat="server" Text="State"></asp:Label>
        </td>
        <td style="text-align:left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtState" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtState" runat="server" ControlToValidate="txtState" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblCountry" meta:resourcekey="lblCountry" runat="server" Text="Country"></asp:Label></td>
        <td align="left" style="text-align: left">:</td>
        <td style="white-space:nowrap">
            <select id="dropCountry" runat="server" ValidationGroup="Account" >
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
            <option value="US">United States</option>
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
            <asp:RequiredFieldValidator ControlToValidate="dropCountry" ValidationGroup="Account" ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap">
            <asp:Label ID="lblPhone" meta:resourcekey="lblPhone" runat="server" Text="Phone"></asp:Label></td>
        <td style="text-align: left">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtPhone" Width="250" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vTxtPhone" runat="server" ControlToValidate="txtPhone" ValidationGroup="Account"
                ErrorMessage="*">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap" valign="top">
            <asp:Label ID="lblAdditionalInfo" meta:resourcekey="lblAdditionalInfo" runat="server" Text="Additional Info"></asp:Label></td>
        <td valign="top">:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtAdditionalInfo" TextMode="MultiLine" Width="250" Height="60" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="text-align:left;white-space:nowrap" valign="top">
            <asp:Label ID="lblPhoto" meta:resourcekey="lblPhoto" runat="server" Text="Photo"></asp:Label></td>
        <td valign="top">:</td>
        <td style="white-space:nowrap">
            <asp:Image ID="imgUser" ImageUrl="images/photos/blank.gif" runat="server" BorderColor="#cccccc" BorderStyle="solid" BorderWidth="1px"/>
            <br /><asp:FileUpload ID="uplImage" runat="server" />
        </td>
    </tr>
    <tr>
        <td colspan="4">
            <div style="margin:7px"></div>
            <asp:Label ID="lblSubscriptions" runat="server" Text="Label" meta:resourcekey="Subscriptions"></asp:Label>
            <div style="margin:7px"></div>
            <asp:CheckBoxList ID="cbCategories" runat="server"  DataTextField="category" DataValueField="category_id">
            </asp:CheckBoxList>
        </td>
    </tr>
    <tr>
        <td colspan="4" style="height:4px; border-bottom-style:none; "></td>
    </tr> 
    <tr>
        <td colspan="4">
        <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text=" Save " ValidationGroup="Account" />
        <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " CausesValidation=false OnClick="btnCancel_Click" />
        <asp:Label ID="lblSucceed" meta:resourcekey="lblSucceed" runat="server" Text="Data updated successfully." Font-Bold=true></asp:Label>
        </td>
    </tr>
</table>
<br />
<asp:HiddenField ID="hidEmail" runat="server" />
</asp:Panel>
