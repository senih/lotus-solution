<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient"%>

<script runat="server">    
	Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim sMessage As MailMessage = New MailMessage
        Dim oSmtpClient As SmtpClient = New SmtpClient
				
        Try
            Dim sToEmails As String = txtToEmail.Text
            Dim sItem As String
            
            If chkCopyMe.checked Then
                sToEmails = txtSenderEmail.Text & ";" & sToEmails
            End If
            
            For Each sItem In sToEmails.Split(";")
                sMessage = New MailMessage
                'sMessage.From = New MailAddress(txtSenderEmail.Text, txtSenderName.Text)
                sMessage.To.Clear()
                sMessage.To.Add(sItem)
                sMessage.Subject = txtSenderName.Text & GetLocalResourceObject("Subject")
                sMessage.Body = GetLocalResourceObject("YourFriendOrColleague") & txtSenderName.Text & " (" & txtSenderEmail.Text & ")" & GetLocalResourceObject("ToughtThatYouWouldLike") & vbCrLf & vbCrLf _
                    & GetAppFullPath() & HttpContext.Current.Items("_page") & vbCrLf & vbCrLf _
                    & GetLocalResourceObject("Message") & vbCrLf _
                    & "-------------------------------" & vbCrLf _
                    & HttpUtility.HtmlEncode(txtMessage.Text) & vbCrLf _
                    & "-------------------------------"
                oSmtpClient.Send(sMessage)
            Next

            lblStatus.Text = GetLocalResourceObject("MessageSent")
        Catch ex As Exception
            lblStatus.Text = ex.Message
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader
        Dim sTitle As String
        
        oDataReader = oContentManager.GetPublishedContentByFileName(HttpContext.Current.Items("_page"))
        If oDataReader.Read() Then
            sTitle = oDataReader("title").ToString
            lblPage.Text = sTitle
        End If
        oDataReader.Close()
        oContentManager = Nothing
        
        txtMessage.Attributes.Add("onfocus", "if(this.value=='" & GetLocalResourceObject("txtMessage.Text") & "'){this.value=''}")
        txtMessage.Attributes.Add("onblur", "if(this.value==''){this.value='" & GetLocalResourceObject("txtMessage.Text") & "'}")
    End Sub
    
    Private Function GetAppFullPath() As String
        'returns:
        ' http://localhost/ 
        ' http://localhost/apppath/
        '(Selalu ada "/" di akhir)
        Dim sPort As String = Request.ServerVariables("SERVER_PORT")
        If IsNothing(sPort) Or sPort = "80" Or sPort = "443" Then
            sPort = ""
        Else
            sPort = ":" & sPort
        End If

        Dim sProtocol As String = Request.ServerVariables("SERVER_PORT_SECURE")
        If IsNothing(sProtocol) Or sProtocol = "0" Then
            sProtocol = "http://"
        Else
            sProtocol = "https://"
        End If

        Dim sAppPath As String = Request.ApplicationPath
        If sAppPath = "/" Then
            'App is installed in root
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & sAppPath
        Else
            'App is installed in virtual directory
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & sAppPath & "/"
        End If
    End Function
</script>

<div style="border-top:#d0d0d0 1px solid;margin-top:7px;margin-bottom:7px;"></div>

<div style="margin-top:7px;margin-bottom:7px">
    <asp:Label ID="lblTitle" meta:resourcekey="lblTitle" Font-Bold="true" runat="server" Text="Tell a Friend"></asp:Label>
    &nbsp;-&nbsp; <asp:Label ID="lblPage" Font-Bold="true" runat="server" Text="Home"></asp:Label>
</div>
   
<table style="margin-top:12px">
<tr>	  
<td valign="top" style="width:240px">
    <div style="padding-bottom:6px">
    <asp:Label ID="lblSenderName" meta:resourcekey="lblSenderName" runat="server" Text="Sender Name:"></asp:Label><br />
	<asp:TextBox id="txtSenderName" size="30" runat="server" MaxLength="50" Columns="35" />            
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtSenderName" ErrorMessage="*" Display="Dynamic" runat="server"></asp:RequiredFieldValidator>
    </div>
    
    <div style="padding-bottom:6px">
    <asp:Label ID="lblSenderEmail" meta:resourcekey="lblSenderEmail" runat="server" Text="Sender Email:"></asp:Label><br />
    <asp:TextBox id="txtSenderEmail" size="30" runat="server" MaxLength="50" Columns="35" />            
    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtSenderEmail" ErrorMessage="*" Display="Dynamic" runat="server"></asp:RequiredFieldValidator>            
    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtSenderEmail" ErrorMessage="*" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" runat="server"></asp:RegularExpressionValidator>
    </div>
    
    <div style="padding-bottom:6px">
    <asp:Label ID="lblToEmail" meta:resourcekey="lblToEmail" runat="server" Text="Friend's Email:"></asp:Label><br />
	<asp:TextBox id="txtToEmail" size="30" runat="server" MaxLength="200" Columns="35" />            
    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtToEmail" ErrorMessage="*" Display="Dynamic" runat="server"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" ControlToValidate="txtToEmail" ErrorMessage="*" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" runat="server"></asp:RegularExpressionValidator>
    <%--<br /><i>Separate multiple addresses using a semi-colon (;)</i>--%>
    </div>
</td>
    <td valign="top">
        <asp:Label ID="lblMessage2" meta:resourcekey="lblMessage" runat="server" Text="Message:"></asp:Label><br />
        <asp:TextBox ID="txtMessage" meta:resourcekey="txtMessage" TextMode="MultiLine" Rows="7" runat="server" Columns="45" Text="Provide a short message to your friend" />
    </td>
</tr>
<tr>
	<td><asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Submit " />
	<asp:CheckBox ID="chkCopyMe" meta:resourcekey="chkCopyMe" Text="Copy Me" runat="server" />
	</td>
    <td style="font-size:9px">
        <asp:Literal ID="litPrivacy" meta:resourcekey="litPrivacy" runat="server"></asp:Literal>	
    </td>	
</tr>
<tr>
    <td colspan="2"><asp:Label ID="lblStatus" Font-Bold="true" runat="server" Text=""></asp:Label></td>
</tr>
</table>


