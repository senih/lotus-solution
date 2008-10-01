<%@ Control Language="VB" Inherits="BaseUserControl" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>


<script runat="server">
  Private sConfirmationSubject As String
  Private sConfirmationBody As String
  Private sUnsubscribeSignature As String

  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
    panelPleaseCheckEmail.Visible = False
    panelActivate.Visible = False

    Dim Setting As NewsletterSetting = New NewsletterSetting
    Setting = GetSetting(Me.RootID)
    With Setting
      sConfirmationSubject = .ConfirmationSubject
      sConfirmationBody = .ConfirmationBody
      sUnsubscribeSignature = .UnsubscribeSignature
    End With
    Setting = Nothing

    If Request.QueryString("s") = "ok" Then
      panelPleaseCheckEmail.Visible = True
    ElseIf Request.QueryString("s") = "activate" Then 'Activate account
      panelActivate.Visible = True

      'Extract Encripted name & email
      
      Dim Id As String = IDDecode(Request.QueryString("uid"))
      Dim sUserName As String = Id.Split(";").GetValue(0)
      Dim sUserEmail As String = id.Split(";").GetValue(1)
      
      ' Get Info from subscriber
      Dim colSubscriberInfo As Collection = GetSubscriberInfo(sUserEmail)
      If Not IsNothing(colSubscriberInfo) Then
        If CType(colSubscriberInfo(colSubscriberInfo.Count), Subscription).Status Then
          lblActivate.Text = GetLocalResourceObject("UserAlreadyActivated") 'Subscription is already confirmed.
        Else
          ActivateSubscriber(sUserEmail) 'update status newsleters
          lblActivate.Text = GetLocalResourceObject("RegistrationCompleted") 'Subscription Completed.
        End If
      Else
        lblActivate.Text = GetLocalResourceObject("RegistrationFailed") 'Subscription Failed.
      End If
            
    ElseIf Not Request.QueryString("un") = "" Then

      ' Check if user already exists / has confirmed and is still subscriber
      Dim sUserEmail As String = Request.QueryString("ue")
      Dim colSubscriberInfo As Collection = GetSubscriberInfo(sUserEmail)
      If Not IsNothing(colSubscriberInfo) Then
        If CType(colSubscriberInfo(colSubscriberInfo.Count), Subscription).Status And _
            Not CType(colSubscriberInfo(colSubscriberInfo.Count), Subscription).Unssubscribe Then
          panelActivate.Visible = True
          lblActivate.Text = GetLocalResourceObject("RegistrationFailed") 'Subscription Failed.
          Exit Sub
        End If
      End If
            
      ' Subscribe
      cbCategories.DataSource = GetCategoriesByRootID(Me.RootID, True, True)
      cbCategories.DataBind()
    
      panelPleaseCheckEmail.Visible = False
      If cbCategories.Items.Count > 1 Then
        panelCategories.Visible = True
      Else
        panelCategories.Visible = False
        btnSubmit_Click(sender, Nothing)
      End If

    End If
  End Sub

  Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    Response.Redirect(Request.QueryString("ReturnUrl"))
  End Sub

  Protected Sub btnReturnToHome_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    Response.Redirect(Me.RootFile)
  End Sub

  Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    Dim i As Integer
    Dim sUserName As String = Request.QueryString("un")
    Dim sUserEmail As String = Request.QueryString("ue")
    Dim Url As String = Request.QueryString("ReturnUrl")

    Dim ID As String = HttpUtility.UrlEncode(IDEncode(sUserName & ";" & sUserEmail))
    'Response.Write(Me.AppFullPath() & Me.LinkActivate & "?s=activate&uid=" & ID)
    'Exit Sub

    Dim oSmtpClient As SmtpClient = New SmtpClient
    Dim oMailMessage As MailMessage = New MailMessage
    Try
      'Dim sFrom As String
      'Dim oSmtpSection As Net.Configuration.SmtpSection = CType(ConfigurationManager.GetSection("system.net/mailSettings/smtp"), Net.Configuration.SmtpSection)
      'sFrom = oSmtpSection.From.ToString
      Dim ToMail As MailAddress = New MailAddress(sUserEmail, sUserName)
      'oMailMessage.From = New MailAddress(sFrom, sFrom)
      oMailMessage.To.Add(ToMail)

      oMailMessage.Subject = sConfirmationSubject 'Registration Confirmation

      oMailMessage.IsBodyHtml = True
      Dim sLink As String = Me.AppFullPath() & Me.LinkActivate & "?s=activate&uid=" & ID
      sConfirmationBody = sConfirmationBody.Replace("[%LinkConfirm%]", sLink)
      sConfirmationBody = sConfirmationBody.Replace("[%SiteName%]", Me.SiteName)
      sConfirmationBody = sConfirmationBody.Replace("[%SiteEmail%]", Me.SiteEmail)

      oMailMessage.Body = "<html><head><style>body {font-family:verdana;font-size:11px}</style></head><body>" & sConfirmationBody & "</body></html>"

      oSmtpClient.Send(oMailMessage)
    Catch ex As Exception
      '  Response.Redirect(Me.LinkActivate & "?s=fail2&ReturnUrl=" & Url)
    End Try

    If cbCategories.Items.Count = 1 Then
      cbCategories.SelectedIndex = 0
      GoTo selected
    End If

    For i = 0 To cbCategories.Items.Count - 1
      If cbCategories.Items(i).Selected Then
        'jika ada salah satu atau lebih yang terselect
        GoTo selected
      End If
    Next
    Response.Redirect(Me.LinkActivate & "?s=ok&ReturnUrl=" & Url)

selected:
       
    'Insert UserName & Email to newsletters_subscribers each category
    For i = 0 To cbCategories.Items.Count - 1
      If cbCategories.Items(i).Selected Then 'subscribe
        AddSubscriber(sUserName, sUserEmail, cbCategories.Items(i).Value, False, False)
        'Else 'unsubscribe
        '    UpdateSubscription(sUserName, sUserEmail, cbCategories.Items(i).Value, True, False)
      End If
    Next

    'harus ditaruh setelah try
    Response.Redirect(Me.LinkActivate & "?s=ok&ReturnUrl=" & Url)

  End Sub

</script>

<asp:Panel ID="panelPleaseCheckEmail" runat="server" Visible="false">
    <asp:Label ID="lblPleaseCheckEmail" meta:resourcekey="lblPleaseCheckEmail" runat="server"></asp:Label>
    <div style="margin:20px"></div>
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text=" Back " OnClick="btnBack_Click" />
</asp:Panel>

<asp:Panel ID="panelActivate" runat="server">
    <asp:Label ID="lblActivate" runat="server" Text=""></asp:Label>
    <div style="margin:20px"></div>
    <asp:Button ID="btnReturnToHome" meta:resourcekey="btnReturnToHome" runat="server" Text=" Return to Home " OnClick="btnReturnToHome_Click" />
</asp:Panel>

<asp:Panel ID="panelCategories" runat="server" Visible="false" >
  <%=GetLocalResourceObject("Choose")%> 
  <div style="margin:7px"></div>
  <asp:CheckBoxList ID="cbCategories" runat="server" DataTextField="category" DataValueField="category_id">
  </asp:CheckBoxList>
  <div style="margin:10px"></div>
  <asp:Button ID="btnSubmit" runat="server" Text="Submit" meta:resourcekey="btnSubmit" OnClick="btnSubmit_Click" />
</asp:Panel>
