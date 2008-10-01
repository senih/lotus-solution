<%@ Page Language="VB" AutoEventWireup="false" %>
<%@ Import Namespace="System.Web.Security.Membership" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
        If Not Roles.RoleExists("Administrators") Then
            Roles.CreateRole("Administrators")
        End If
        If Not Roles.RoleExists("General Subscribers") Then
            Roles.CreateRole("General Subscribers")
        End If
        If Not Roles.RoleExists("General Authors") Then
            Roles.CreateRole("General Authors")
        End If
        If Not Roles.RoleExists("General Editors") Then
            Roles.CreateRole("General Editors")
        End If
        If Not Roles.RoleExists("General Publishers") Then
            Roles.CreateRole("General Publishers")
        End If
        If Not Roles.RoleExists("General Resource Managers") Then
            Roles.CreateRole("General Resource Managers")
        End If
        If Not Roles.RoleExists("Polls Managers") Then
            Roles.CreateRole("Polls Managers")
        End If
        If Not Roles.RoleExists("Events Managers") Then
            Roles.CreateRole("Events Managers")
        End If
        If Not Roles.RoleExists("Newsletters Managers") Then
            Roles.CreateRole("Newsletters Managers")
        End If

        'fix typo "Newsleters Managers"
        If Roles.RoleExists("Newsleters Managers") Then
            If Not Roles.GetUsersInRole("Newsleters Managers").Length = 0 Then
                Roles.AddUsersToRole(Roles.GetUsersInRole("Newsleters Managers"), "Newsletters Managers")
                Roles.RemoveUsersFromRole(Roles.GetUsersInRole("Newsleters Managers"), "Newsleters Managers")
            End If
            Roles.DeleteRole("Newsleters Managers")
        End If
        
        lblStorageConfig.Text = Server.MapPath(".")
        lblStorageConfig.Style.Add("display", "none")
    End Sub
    
    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.CreatedUser
        Roles.AddUserToRole(CreateUserWizard1.UserName, "Administrators")

        Dim pcSelectedProfile As ProfileCommon = Profile.GetProfile(CreateUserWizard1.UserName)
        pcSelectedProfile.UseWYSIWYG = True
        pcSelectedProfile.Save()
    End Sub

    Protected Sub ContinueButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("../default.aspx")
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Sign Up for Administrator Account</title>
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;margin:20px;}
        td{font-family:verdana;font-size:11px;color:#666666}
    </style>
</head>
<body>
<form id="form1" runat="server">

<h3>Sign Up for Administrator Account</h3>
    <asp:CreateUserWizard UserName="admin" ID="CreateUserWizard1" runat="server">
        <WizardSteps>
            <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                <ContentTemplate>
                    <table border="0">
                        <tr>
                            <td align="right">
                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="UserName" runat="server" ReadOnly="False">admin</asp:TextBox>
                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                    ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                    ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">Confirm Password:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                    ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required."
                                    ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">E-mail:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="Email" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                                    ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="QuestionLabel" runat="server" AssociatedControlID="Question">Security Question:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="Question" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question"
                                    ErrorMessage="Security question is required." ToolTip="Security question is required."
                                    ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Security Answer:</asp:Label></td>
                            <td>
                                <asp:TextBox ID="Answer" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer"
                                    ErrorMessage="Security answer is required." ToolTip="Security answer is required."
                                    ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                    ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match."
                                    ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
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
            <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                <ContentTemplate>
                    <table border="0">
                        <tr>
                            <td align="center" colspan="2">
                                Complete</td>
                        </tr>
                        <tr>
                            <td>
                                Your account has been successfully created.</td>
                        </tr>
                        <tr>
                            <td align="right" colspan="2">
                                <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue"
                                    OnClick="ContinueButton_Click" Text="Continue" ValidationGroup="CreateUserWizard1" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:CompleteWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
    <asp:Label ID="lblStorageConfig" runat="server" Text=""></asp:Label>
</form>
</body>
</html>
