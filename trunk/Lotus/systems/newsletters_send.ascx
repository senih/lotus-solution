<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">
    Private NewsId As Integer
    Private sMessage As String
    Private sSubject As String
    Private sUnsubscribeSignature As String = ""
    Private sUnsubscribeSignatureText As String = ""
    Private sCSS As String
    Private nTotal As Integer
    Private nSent As Integer
    Private sForm As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (IsNothing(GetUser())) Then
            panelLogin.Visible = True
            panelSend.Visible = False
        Else
            '~~~ Only Administrators  ~~~
            If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators")) Then
                panelLogin.Visible = False
                panelSend.Visible = True

                'Dim oMasterPage As BaseMaster = CType(Parent.Page.Master, BaseMaster)
                txtDisplayName.Text = Me.SiteName
                txtEmail.Text = Me.SiteEmail

                Dim bExist As Boolean = False

                'if Request.QueryString("id") not number redirect to newsletters.aspx
                Try
                    NewsId = CInt(Request.QueryString("id"))
                Catch ex As Exception
                    Response.Redirect(Me.LinkWorkspaceNewsletters)
                End Try


                Dim oNewsletter As Newsletter = New Newsletter
                oNewsletter = GetNewsletterById(NewsId)

                If Not IsNothing(oNewsletter) Then
                    If oNewsletter.ReceipientsType = 1 Then
                        Dim sTemp As String = oNewsletter.SendTo
                        Dim sTmp As String = ""
                        Dim sEmail As String = ""
                        Dim tdEmails As String = ""
                        Dim nCount As Integer = 0
                        If Not sTemp = "" Then
                            For Each sTmp In sTemp.Split(";")
                                sEmail += sTmp & ";"
                                nCount += 1
                                If nCount = 5 Then
                                    tdEmails = tdEmails & "<tr><td>" & sEmail & "</tr></td>"
                                    nCount = 0
                                    sEmail = ""
                                End If
                            Next
                            If nCount <> 0 Then
                                sEmail = sEmail.Substring(0, sEmail.Length - 1)
                                tdEmails = tdEmails & "<tr><td>" & sEmail & "</tr></td>"
                            End If
                            litReceipt.Text = "<table>" & tdEmails & "</table>"
                        End If

                        ' if subscription

                    ElseIf Not oNewsletter.ReceipientsType = 1 Then
                        litReceipt.Text = oNewsletter.SendTo

                        If oNewsletter.ReceipientsType = 5 Then
                            Dim Setting As NewsletterSetting = New NewsletterSetting
                            Setting = GetSetting(Me.RootID)
                            With Setting
                                sUnsubscribeSignature = .UnsubscribeSignature
                                sUnsubscribeSignatureText = .UnsubscribeSignatureText
                            End With
                            Setting = Nothing
                        End If
                    End If

                    sForm = oNewsletter.Form
                    If sForm = "html" Then
                        sMessage = oNewsletter.Message.ToString
                        sCSS = oNewsletter.Css
                    Else
                        sMessage = oNewsletter.Message.ToString
                    End If
                    hidReceipients.Value = oNewsletter.SendTo
                    sSubject = oNewsletter.Subject

                Else
                    Response.Redirect(Me.LinkWorkspaceNewsletters)
                End If

                oNewsletter = Nothing

                lnkView.Attributes.Add("onclick", "window.open('" & Me.AppPath & "systems/newsletter_viewer.aspx?c=" & Me.Culture & "&id=" & NewsId & "',""_blank"",""width=700,height=500,top=100,left=100,scrollbars=yes,resizable=yes"");return false;")
                lnkReport.OnClientClick = "window.open('" & Me.AppPath & "systems/newsletter_report.aspx?c=" & Me.Culture & "&id=" & NewsId & "',""_blank"",""width=450,height=405,top=150,left=150,scrollbars=yes"");return false;"

                'Get Total receipient and total send mail
                Dim i As Integer
                Dim colReceipients As Collection = New Collection
                colReceipients = GetReceipients(NewsId)
                nTotal = colReceipients.Count
                For i = 1 To nTotal
                    If CType(colReceipients(i), Receipient).Status <> "0" Then
                        nSent += 1
                    End If
                Next
                lblReport.Text = nSent & " " & GetLocalResourceObject("of") & " " & nTotal & "  " & GetLocalResourceObject("completed")

                If nTotal = nSent Then
                    btnSend.Enabled = False
                    btnSendToAll.Enabled = False
                End If
            End If
        End If
    End Sub


    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBack.Click
        Response.Redirect(Me.LinkWorkspaceNewsletters)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub lnkConfigure_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConfigure.Click
        Response.Redirect(Me.LinkWorkspaceNewsConfigure & "?id=" & NewsId.ToString)
    End Sub

    Protected Sub btnSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSend.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Try
            Dim n As Integer = CInt(txtCount.Text)
        Catch ex As Exception
            txtCount.Text = ""
            Exit Sub
        End Try
        SendMessage(txtCount.Text)
    End Sub

    Protected Sub btnSendToAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendToAll.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        SendMessage("All")
    End Sub

    Protected Sub SendMessage(ByVal sPartial As String)
        Dim sEmails As String = ""
        Dim sEmail As String
        Dim colReceipients As Collection = New Collection

        'select email --> output [sEmails]
        '-----------------------
        If sPartial = "All" Then
            colReceipients = GetReceipients(NewsId, True)
        Else
            If sPartial = "" Then
                sPartial = "1"
            End If
            colReceipients = GetReceipients(NewsId, True, sPartial)
        End If

        Dim i As Integer
        For i = 1 To colReceipients.Count
            sEmails += ";" & CType(colReceipients(i), Receipient).Email
        Next
        '------------------------

        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailAddress As MailAddress

        Try
            oMailAddress = New MailAddress(txtEmail.Text, txtDisplayName.Text)
        Catch ex As Exception
            txtEmail.Text = ""
            rfv2.IsValid = False
            Exit Sub
        End Try

        If sForm = "html" Then
            sMessage = "<html><head><style>" & sCSS & "</style><title>" & sSubject & "</title></head><body>" & sMessage & "</body></html>"
        End If

        Dim sPath, sPathFile As String
        Dim bSend As Boolean
        Dim sErrorMessage As String = ""
        Dim oMailMessage As MailMessage = New MailMessage
        Dim sMessageSend As String
        Dim sUsername As String = ""
        If Not sEmails = "" Then
            sEmails = sEmails.Substring(1)
            For Each sEmail In sEmails.Split(";")
    
                oMailMessage = New MailMessage
                sMessageSend = sMessage
                If Not IsNothing(GetSubscription(sEmail)) Then
                    sUsername = CType(GetSubscription(sEmail).Item(1), Subscription).Name.ToString
                Else
                    sUsername = ""
                End If
                sMessageSend = sMessageSend.Replace("[%Name%]", sUsername)
                sMessageSend = sMessageSend.Replace("[%SiteName%]", Me.SiteName)
                sMessageSend = sMessageSend.Replace("[%SiteEmail%]", Me.SiteEmail)
                
                If sForm = "html" Then
                    sMessageSend = sMessageSend.Replace("[%UnsubscribeSignature%]", sUnsubscribeSignature)
                Else
                    sMessageSend = sMessageSend.Replace("[%UnsubscribeSignature%]", sUnsubscribeSignatureText)
                End If
                
                sMessageSend = sMessageSend.Replace("[%LinkUnsubscribe%]", Me.AppFullPath & Me.LinkSubscriptionUpdate & "?uid=" & HttpUtility.UrlEncode((IDEncode(sUsername & ";" & sEmail))))
                'Note: [%LinkUnsubscribe%] adanya di [%UnsubscribeSignature%]
                
                If sForm = "html" Then
                    oMailMessage.IsBodyHtml = True
                Else
                    oMailMessage.IsBodyHtml = False
                End If

                Try
                    oMailMessage.From = oMailAddress
                    oMailMessage.Subject = sSubject
                    oMailMessage.Body = sMessageSend
                    oMailMessage.To.Clear()
                    oMailMessage.To.Add(sEmail)
                    'tambahan dari andi untuk bisa send file attachment
                    '--------------------------------------------------
                    sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId
                    sPathFile = ""

                    If System.IO.Directory.Exists(sPath) Then
                        For Each item As String In System.IO.Directory.GetFiles(sPath)
                            If Not item.Substring(item.LastIndexOf("\") + 1).ToLower = "thumbs.db" Then
                                sPathFile = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                            End If
                        Next
                    End If

                    If Not sPathFile = "" Then
                        oMailMessage.Attachments.Add(New Attachment(sPathFile))
                    End If
                    '--------------------------------------------------
                    oSmtpClient.Send(oMailMessage)
                    bSend = True
                Catch ex As Exception
                    bSend = False
                    sErrorMessage = ex.Message.ToString
                End Try

                If bSend Then
                    UpdateReceipients(NewsId, sEmail, "sent")
                Else
                    UpdateReceipients(NewsId, sEmail, "Error: " & sErrorMessage)
                End If
                nSent += 1
                lblReport.Text = nSent & " " & GetLocalResourceObject("of") & " " & nTotal & "  " & GetLocalResourceObject("completed")
            Next
        End If

        If nTotal = nSent Then
            btnSend.Enabled = False
            btnSendToAll.Enabled = False
        End If
    End Sub
 </script>

<p></p>
<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelSend" runat="server">
<table >
  <tr>
    <td>
      <b>      
      <asp:Label ID="lblSender" runat="server" Text="Sender" meta:resourcekey="lblSender"  ></asp:Label>
    </b>
    </td>
  </tr>
  <tr>
    <td width=120px>
      <asp:Label ID="lblName" runat="server" Text="Display name" meta:resourcekey="lblName"  ></asp:Label>
    </td><td>:</td>
    <td>
      <asp:TextBox ID="txtDisplayName" runat="server" ValidationGroup="Email" ></asp:TextBox>
      <asp:RequiredFieldValidator ID="rfv1" ValidationGroup="Email" ControlToValidate="txtDisplayName" runat="server" ErrorMessage="*">*</asp:RequiredFieldValidator>
    </td>
  </tr>
  <tr>
    <td>
      <asp:Label ID="lblEmail" runat="server" Text="Sender email" meta:resourcekey="lblEmail" ></asp:Label>
    </td><td>:</td>
    <td>
      <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="Email" ></asp:TextBox>
      <asp:RequiredFieldValidator ID="rfv2" ValidationGroup="Email" ControlToValidate="txtEmail" runat="server" ErrorMessage="*">*</asp:RequiredFieldValidator>
    </td>
  </tr>
</table>
<div style=" border-bottom:#d0d0d0 1px solid;width:350px;margin-bottom:3px;margin-top:3px;"></div>
<table>
  <tr>
    <td valign="top" width=120px>
      <asp:Label runat="server" ID="lblReceipients" Font-Bold=true Text="Send message to" meta:resourcekey="lblReceipients" ></asp:Label>
    </td><td valign="top">:</td>
    <td valign="top">  
      <asp:Literal ID="litReceipt" runat="server"></asp:Literal>
    </td>
  </tr>
    <tr>
    <td></td><td></td>
    <td>
      <asp:LinkButton runat="server" ID="lnkConfigure" Text="Reconfigure" meta:resourcekey="lnkConfigure" ></asp:LinkButton>
    </td>
  </tr>
  <tr>
  <td>
  <div style="margin:10px"></div>
  <asp:Label runat="server" ID="lblReport" meta:resourcekey="lblReport" ></asp:Label>
  </td><td></td>
  <td><div style="margin:10px"></div>
  <asp:LinkButton runat="server" ID="lnkView" Text="View Message"  meta:resourcekey="lnkView" ></asp:LinkButton>&nbsp;&nbsp;
  <asp:LinkButton runat="server" ID="lnkReport" Text="Report"  meta:resourcekey="lnkReport" ></asp:LinkButton>
  </td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" style="margin-top:15px">
<tr>
  <td style="white-space:nowrap;background-image:url('systems/images/bg_box2.gif');border-left:#d4d6dd 1px solid;border-right:#d4d6dd 1px solid;border-bottom:#d4d6dd 1px solid;padding:15px">
    <asp:Label runat="server" ID="lblPartial" Font-Bold="true" Text="Partial sending :"  meta:resourcekey="lblPartial"></asp:Label>
    <div style="margin:10px"></div>
    <table cellpadding="0" cellspacing="0">
    <tr>
    <td style="white-space:nowrap;">
    <asp:Label runat="server" ID="lblCount" Text="Number of receipients per mailing:" meta:resourcekey="lblCount"></asp:Label>
    &nbsp;
    </td>
    <td style="white-space:nowrap">
    <asp:TextBox runat="server" id="txtCount" Width="30px" Text="25"></asp:TextBox>
    <asp:Button runat="server" Text=" Send " ID="btnSend" ValidationGroup="Email" meta:resourcekey="btnSend"/>
    </td>
    </tr>
    </table>
  </td>
  <td>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
  <td style="white-space:nowrap;background-image:url('systems/images/bg_box2.gif');border-left:#d4d6dd 1px solid;border-right:#d4d6dd 1px solid;border-bottom:#d4d6dd 1px solid;padding:15px">
    <asp:Label runat="server" ID="lblSendToAll" Font-Bold=true Text=" Send to all :"  meta:resourcekey="lblSendToAll" ></asp:Label>
    <div style="margin:10px"></div>
    <asp:Button runat="server" Text=" Send to All " ID="btnSendToAll" ValidationGroup="Email"  meta:resourcekey="btnSendToAll"/>
  </td>
</tr>
</table>

<asp:Button Text="Back to Newslettter List" ID="btnBack" runat="server" Visible="false"  meta:resourcekey="btnBack"></asp:Button>

<asp:HiddenField ID="hidReceipients" runat="server" />
</asp:Panel>
