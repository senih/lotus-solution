<%@ Control Language="VB" Inherits="BaseUserControl" %>
<%@ Import Namespace="system.IO" %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        panelLogin.Visible = True
        panelImport.Visible = False
        If Not (IsNothing(GetUser())) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                
                panelLogin.Visible = False
                panelImport.Visible = True
                
                lstRoles.DataSource = Roles.GetAllRoles()
                lstRoles.DataBind()
                
                lstRoles.Items.Remove(lstRoles.Items.FindByValue("Administrators"))
                If Not IsNothing(lstRoles.Items.FindByValue("General Subscribers")) Then
                    lstRoles.Items.FindByValue("General Subscribers").Selected = True
                End If
            End If
        End If
    End Sub

    Protected Sub btnCreateUser_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim x As Integer
        Dim item As String
        Dim sUserName As String
        Dim sEmail As String
        Dim sPassword As String
        Dim sFirstName As String
        Dim sLastName As String
        Dim sCompany As String
        Dim sAddress As String
        Dim sCity As String
        Dim sZip As String
        Dim sState As String
        Dim sCountry As String
        Dim sPhone As String
        Dim nUser As Integer = 0
        Dim nRoles As Integer = 0
        Dim nError As Integer = 0

        Dim sr As StreamReader
        Dim sFailed As String = ""

        sr = New StreamReader(Fileupload1.PostedFile.InputStream, System.Text.Encoding.Default)
        Dim line As String = ""
        While Not line Is Nothing
            line = sr.ReadLine()
                       
            If Not line = "" Then
                
                sEmail = ""
                sUserName = ""
                sPassword = ""
                sFirstName = ""
                sLastName = ""
                sCompany = ""
                sAddress = ""
                sCity = ""
                sZip = ""
                sState = ""
                sCountry = ""
                sPhone = ""
                
                x = 0
                
                'Format: Email
                If (rblChoice.SelectedValue = "1") Then
                    For Each item In line.Split(",")
                        Select Case x
                            Case 0
                                sUserName = item
                                sEmail = item
                                sPassword = Membership.GeneratePassword(7, 2)
                        End Select
                        x += 1
                    Next
                End If
                
                'Format: User Name, Email
                If (rblChoice.SelectedValue = "2") Then
                    For Each item In line.Split(",")
                        Select Case x
                            Case 0
                                sUserName = item
                                sPassword = Membership.GeneratePassword(7, 2)
                            Case 1
                                sEmail = item
                        End Select
                        x += 1
                    Next
                End If
                
                'Format: Email, Password
                If (rblChoice.SelectedValue = "3") Then
                    For Each item In line.Split(",")
                        Select Case x
                            Case 0
                                sUserName = item
                                sEmail = item
                            Case 1
                                sPassword = item
                        End Select
                        x += 1
                    Next
                End If
                 
                'Format: User Name, Email, First Name, Last Name, Company, Address, City, Zip, State, Country Code, Phone
                If (rblChoice.SelectedValue = "4") Then
                    For Each item In line.Split(",")
                        Select Case x
                            Case 0
                                sUserName = item
                                sPassword = Membership.GeneratePassword(7, 2)
                            Case 1
                                sEmail = item
                            Case 2
                                sFirstName = item
                            Case 3
                                sLastName = item
                            Case 4
                                sCompany = item
                            Case 5
                                sAddress = item
                            Case 6
                                sCity = item
                            Case 7
                                sZip = item
                            Case 8
                                sState = item
                            Case 9
                                sCountry = item
                            Case 10
                                sPhone = item
                        End Select
                        x += 1
                    Next
                End If
              
                Dim sRole As String
                Dim nCount As Integer
                For nCount = 0 To lstRoles.Items.Count - 1
                    If lstRoles.Items(nCount).Selected Then
                        sRole = lstRoles.Items(nCount).Value
                        'Try
                        If Membership.FindUsersByEmail(sEmail).Count = 0 Then
                            'Email not exists
                            If Membership.FindUsersByName(sUserName).Count = 0 Then
                                'UserName not exists
                                Membership.CreateUser(sUserName, sPassword, sEmail)
                                Roles.AddUserToRole(sUserName, sRole)
                                If (rblChoice.SelectedValue = "4") Then
                                    Dim oSelectedProfile As ProfileCommon = Profile.GetProfile(sUserName)
                                    oSelectedProfile.FirstName = sFirstName
                                    oSelectedProfile.LastName = sLastName
                                    oSelectedProfile.Company = sCompany
                                    oSelectedProfile.Address = sAddress
                                    oSelectedProfile.City = sCity
                                    oSelectedProfile.Zip = sZip
                                    oSelectedProfile.State = sState
                                    oSelectedProfile.Country = sCountry
                                    oSelectedProfile.Phone = sPhone
                                    oSelectedProfile.Save()
                                End If
                                'nRoles += 1
                                nUser += 1
                            Else
                                'UserName exists
                                sFailed += line & " (Duplicate User Name)" & vbCrLf
                                nError += 1
                            End If
                        Else
                            'Email exists
                            If Not Membership.FindUsersByEmail(sEmail).Count = 0 Then
                                If sUserName.ToLower = Membership.GetUserNameByEmail(sEmail).ToLower Then
                                    If Not Roles.IsUserInRole(sUserName, sRole) Then
                                        Roles.AddUserToRole(sUserName, sRole)
                                        nRoles += 1
                                    End If
                                Else
                                    sFailed += line & " (Duplicate Email)" & vbCrLf
                                    nError += 1
                                End If
                            Else
                                sFailed += line & " (Duplicate Email.)" & vbCrLf
                                nError += 1
                            End If
                        End If
                    End If
                Next
            End If
        End While
        sr.Close()
        lblNote.Text = nUser & " " & GetLocalResourceObject("imported") & ", " & nRoles & " User(s) updated ," & nError & " " & GetLocalResourceObject("failed")
    
        If nError > 0 Then
            idFailed.Visible = True
            txtFailed.Text = sFailed
        Else
            idFailed.Visible = False
            txtFailed.Text = ""
        End If
        Fileupload1.PostedFile.InputStream.Close()
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkAdminUsers)
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
</asp:Panel> 

<asp:Panel ID="panelImport" runat="server" style="width:100%">

<table cellpadding="3" cellspacing="0">
<tr>
    <td style="padding-left:0px;white-space:nowrap"><asp:Label ID="lblImportFromFile" meta:resourcekey="lblImportFromFile" runat="server" Text="Import from a file"></asp:Label></td>
    <td>:&nbsp;</td>
    <td style="width:100%">
    <asp:fileupload ID="Fileupload1" runat="server" ></asp:fileupload>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="Fileupload1" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td colspan="3" style="padding-left:0px;">
    <asp:Label ID="lblFormat" meta:resourcekey="lblFormat" runat="server" Text="Specify the format of the data"></asp:Label> :
    <div style="margin:5px"></div>
    <asp:RadioButtonList ID="rblChoice" runat="server">
      <asp:ListItem Value="1" meta:resourcekey="listEmail"></asp:ListItem>
      <asp:ListItem Value="2" Selected=True meta:resourcekey="listUserName"></asp:ListItem>
      <asp:ListItem Value="3" meta:resourcekey="listEmailPassword"></asp:ListItem>
      <asp:ListItem Value="4" meta:resourcekey="listAll"></asp:ListItem>
    </asp:RadioButtonList>  
    </td>
</tr>
<tr>
    <td style="padding-left:0px;white-space:nowrap"><asp:Label ID="lblRole" meta:resourcekey="lblRole" runat="server" Text="Select a role for the users"></asp:Label></td>
    <td>:&nbsp;</td>
    <td>
<%--    <asp:DropDownList ID="ddlRoles" runat="server"></asp:DropDownList><br />--%>
    <asp:ListBox ID="lstRoles" runat="server"  Rows="5" SelectionMode="Multiple" Width="225"></asp:ListBox>
    </td>
</tr>
<tr>
    <td colspan="3" style="height:5px"></td>
</tr>
<tr>
    <td colspan="3" style="padding-left:0px;">
    <asp:Button ID="btnCreateUser" runat="server" meta:resourcekey="btnCreateUser" OnClick="btnCreateUser_Click" /> 
    <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " CausesValidation=false OnClick="btnCancel_Click" />
    <asp:Label ID="lblNote" Font-Bold=true runat="server" Text=""></asp:Label>   
    </td>
</tr>
<tr runat=server id="idFailed" visible=false>
    <td colspan="3" style="height:5px">
    <hr />
    <asp:Label ID="lblFailed" runat="server" Text="Failed:"></asp:Label>
    <div style="margin:5px"></div>
    <asp:TextBox ID="txtFailed" Height="100px" Wrap=false Width="350px" TextMode=MultiLine runat="server"></asp:TextBox>
    </td>
</tr>
</table>
 
 </asp:Panel>
