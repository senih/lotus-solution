<%@ Page Language="VB" %>
<%@ Import namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
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
        
    Dim NewsId As Integer = CInt(Request.QueryString("id"))
    Dim sMessage As String = ""
    Dim sCSS As String = ""
    Dim oNewsletter As Newsletter = New Newsletter
    
    oNewsletter = GetNewsletterById(NewsId)
    If Not IsNothing(oNewsletter) Then
      sMessage = oNewsletter.Message
      If oNewsletter.Form = "html" Then
        sCSS = "<style type=""text/css"">" & oNewsletter.Css & "</style>"
        Page.Header.Controls.Add(New LiteralControl(sCSS))
      Else
        sMessage = sMessage.Replace(vbCrLf, "<br/>")
      End If
      Page.Title = oNewsletter.Subject & " | " & GetLocalResourceObject("title") '"Newsletter Viewer"
      litMessage.Text = sMessage
    End If
    oNewsletter = Nothing
    
  End Sub
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title runat="server"></title>
</head>
<body>

  <asp:Literal ID="litMessage" runat="server"></asp:Literal>
</body>
</html>
