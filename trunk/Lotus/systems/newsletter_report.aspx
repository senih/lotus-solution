<%@ Page Language="VB" ClassName="systems_newsletters_report" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">

  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    If IsNothing(GetUser()) Then
      Exit Sub
    Else
      If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Or _
              Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
        'Continue
      Else
        Exit Sub
      End If
    End If
        
    Dim sCulture As String = Request.QueryString("c")
    If Not sCulture = "" Then
      Dim ci As New CultureInfo(sCulture)
      Thread.CurrentThread.CurrentCulture = ci
      Thread.CurrentThread.CurrentUICulture = ci
    End If
    idTitle.Text = GetLocalResourceObject("idTitle.Text")
    
    Dim sEmails As String = ""
    Dim nError As Integer = 0
    Dim nSuccess As Integer = 0
    Dim NewsId As Integer = CInt(Request.QueryString("id"))
    

    'Get send mail and error mail
    Dim i As Integer
    Dim colReceipients As Collection = New Collection
    colReceipients = GetReceipients(NewsId)

    For i = 1 To colReceipients.Count
      If CType(colReceipients(i), Receipient).Status = "sent" Then
        nSuccess += 1
      ElseIf CType(colReceipients(i), Receipient).Status.Contains("Error:") Then
        nError += 1
        sEmails += CType(colReceipients(i), Receipient).Email & ". " & CType(colReceipients(i), Receipient).Status & "<br />"
      End If
    Next
    
    
    litReport.Text = "<table width=100% align=center><tr><td>"
    If nSuccess < 2 Then
      litReport.Text += "<b>" & nSuccess & " " & GetLocalResourceObject("message_sent") & "</b></td></tr>"
    Else
      litReport.Text += "<b>" & nSuccess & " " & GetLocalResourceObject("messages_sent") & "</b></td></tr>"
    End If

    If nError > 0 Then
      litReport.Text += "<tr><td>"
      If nError > 1 Then
        litReport.Text += "<b>" & nError & " " & GetLocalResourceObject("errors") & " :</b></td>"
      Else
        litReport.Text += "<b>" & nError & " " & GetLocalResourceObject("error") & " :</b><td>"
      End If
      litReport.Text += "<tr><td><div name=""txtEmails"" style=""background:white;border:#cccccc 1px solid;padding:2px;width:395px;height:330px;overflow:auto;white-space:nowrap;font-family:Courier New;"">"
            
      'For Each sEmail In sEmails.Split(vbCrLf)
      '    litReport.Text += sEmail & "<br />"
      'Next
      litReport.Text += sEmails & "</div>"
    End If
    litReport.Text += "</td></tr></table>"

  End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server">Report</title>
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
</head>
<body style="margin:10px;background-color:#E6E7E8">
    <form id="form1" runat="server">
      <asp:Literal ID="litReport" runat="server" ></asp:Literal> 
    </form>
</body>
</html>
