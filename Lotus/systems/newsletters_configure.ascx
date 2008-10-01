<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">
    Private NewsId As Integer
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (IsNothing(GetUser())) Then
            panelLogin.Visible = True
        Else
            '~~~ Only Administrators  ~~~
            If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators")) Then
                Dim myScript As String
    
                'if Request.QueryString("id") not number redirect to newsletters.aspx
                Try
                    NewsId = CInt(Request.QueryString("id"))
                Catch ex As Exception
                    Response.Redirect(Me.LinkWorkspaceNewsletters)
                End Try
    
    
                PanelConfigure.Visible = True
                lsbValuableRoles.DataSource = Roles.GetAllRoles()
                lsbValuableRoles.DataBind()

    

                btnNext.Attributes.Add("onclick", "button=this.id")
                myScript = "<script language=Javascript>var button;<"
                myScript += "/"
                myScript += "script>"
                Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "NewScript", myScript)
                Page.ClientScript.RegisterOnSubmitStatement(Me.GetType, "OnSubmit", "if(button == '" & btnNext.ClientID & "'){transferValues(document.getElementById('" & lsbValuableRoles.ClientID & "'),document.getElementById('" & hidRoles.ClientID & "'))}else")


                If Not IsPostBack Then
                    'Render ddlCategories
                    ddlCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                    ddlCategories.DataBind()
      
                    'check exist
                    Dim oNewsletter As Newsletter = New Newsletter
                    oNewsletter = GetNewsletterById(NewsId)
    
                    If Not IsNothing(oNewsletter) Then
        

                        If oNewsletter.ReceipientsType = 1 Then
                            rbUsers.Checked = True
                            txtEmail.Text = oNewsletter.SendTo
          
                        ElseIf oNewsletter.ReceipientsType = 2 Then
                            Dim sItem As String = ""
                            rbRoles.Checked = True
                            For Each sItem In oNewsletter.SendTo.Split(";")
                                Dim i As Integer = 0
                                Do While i < lsbValuableRoles.Items.Count
                                    If lsbValuableRoles.Items(i).Text = sItem Then
                                        lsbValuableRoles.Items(i).Selected = True
                                    End If
                                    i += 1
                                Loop
                            Next
          
                        ElseIf oNewsletter.ReceipientsType = 3 Then
                            rbAllUsers.Checked = True
          
                        ElseIf oNewsletter.ReceipientsType = 4 Then
                            rbNoRole.Checked = True
          
                        ElseIf oNewsletter.ReceipientsType = 5 Then
                            rbSubscribers.Checked = True
                        End If
        
                    Else
                        Response.Redirect(Me.LinkWorkspaceNewsletters)
                    End If
                End If
            End If
        End If

    End Sub

    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim iReceipientType As Integer = 0
        Dim sEmails As String = ""
        Dim sEmail As String
        Dim sItem As String = ""
        Dim sUser As String
        Dim nCount As Integer = 0

        Dim sName As String = GetUser.UserName.ToString
        Dim sqlCmd As SqlCommand
        Dim StrSQL As String
        Dim sqlReader As SqlDataReader

        'update data to newsletters & delete newsletters_receipients
        StrSQL = "update newsletters set receipients_type=@type , send_to=@send_to where id=@news_id ;" & _
                 "delete from newsletters_receipients where newsletters_id=@news_id "
        sqlCmd = New SqlCommand(StrSQL, oConn)
        sqlCmd.CommandType = CommandType.Text
  
        'Users
        If rbUsers.Checked Then
            iReceipientType = 1
            sEmails = txtEmail.Text
            If Not sEmails = "" Then
                For Each sItem In sEmails.Split(";")
                    nCount += 1
                Next
            End If
            sqlCmd.Parameters.Add("@send_to", SqlDbType.NText).Value = sEmails

            'Roles
        ElseIf rbRoles.Checked Then
            Dim bEmailExist As Boolean = False
            iReceipientType = 2
            For Each sItem In hidRoles.Value.Split(";")
                For Each sUser In Roles.GetUsersInRole(sItem)
                    For Each sEmail In sEmails.Split(";")
                        bEmailExist = False
                        If sEmail = GetUser(sUser).Email Then
                            bEmailExist = True
                        End If
                    Next

                    If Not bEmailExist Then
                        sEmails += ";" & GetUser(sUser).Email
                        nCount += 1
                    End If
                Next
            Next
            If Not sEmails = "" Then
                sEmails = sEmails.Substring(1)
            End If
            sqlCmd.Parameters.Add("@send_to", SqlDbType.NText).Value = hidRoles.Value
    
            'AllUsers
        ElseIf rbAllUsers.Checked Then
            Dim oUser As MembershipUser
            iReceipientType = 3
            For Each oUser In GetAllUsers()
                sEmails += ";" & oUser.Email
                nCount += 1
            Next
            If Not sEmails = "" Then
                sEmails = sEmails.Substring(1)
            End If
            sqlCmd.Parameters.Add("@send_to", SqlDbType.NText).Value = GetLocalResourceObject("all") '"all users"

            ' NoRoles
        ElseIf rbNoRole.Checked Then
            Dim oUser As MembershipUser
            Dim bNoRole As Boolean
            iReceipientType = 4
            For Each oUser In GetAllUsers()
                bNoRole = True
                For Each sItem In Roles.GetAllRoles()
                    If Roles.IsUserInRole(oUser.UserName, sItem) Then
                        bNoRole = False
                    End If
                Next
                If bNoRole Then
                    sEmails += ";" & oUser.Email
                End If
            Next
            If Not sEmails = "" Then
                sEmails = sEmails.Substring(1)
            End If
            sqlCmd.Parameters.Add("@send_to", SqlDbType.NText).Value = GetLocalResourceObject("noRole")
   
            'Subscribers
        ElseIf rbSubscribers.Checked Then
            sqlCmd.Parameters.Add("@send_to", SqlDbType.NText).Value = ddlCategories.SelectedItem.Text
            iReceipientType = 5
  
        End If
        sqlCmd.Parameters.Add("@type", SqlDbType.Int).Value = iReceipientType
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId

        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()

        'select receipients from newsletters_subscribers
        If rbSubscribers.Checked Then
            sEmails = ""
            StrSQL = "select * from newsletters_subscribers where category_id=@category_id AND status=1 and unsubscribe=0"
            sqlCmd = New SqlCommand(StrSQL, oConn)
            sqlCmd.CommandType = CommandType.Text
            sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = ddlCategories.SelectedValue
            sqlReader = sqlCmd.ExecuteReader
            Do While sqlReader.Read()
                sEmails += ";" & sqlReader("email")
            Loop
            If Not sEmails = "" Then
                sEmails = sEmails.Substring(1)
            End If
            sqlReader.Close()
            sqlCmd.Dispose()
        End If
  
        'insert recipient to newsletters_receipients
        If Not sEmails = "" Then
            StrSQL = "insert into newsletters_receipients (newsletters_id,email,status) " & _
                                    "values (@newsletters_id,@email,'0') "
            sqlCmd = New SqlCommand(StrSQL, oConn)
            sqlCmd.CommandType = CommandType.Text
            sqlCmd.Parameters.Add("@newsletters_id", SqlDbType.Int)
            sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar)
            For Each sItem In sEmails.Split(";")
                sqlCmd.Parameters.Item("@newsletters_id").Value = NewsId
                sqlCmd.Parameters.Item("@email").Value = sItem
                sqlCmd.ExecuteNonQuery()
                sqlCmd.Dispose()
            Next
        End If
        'end insert receipients
        oConn.Close()

        Response.Redirect(Me.LinkWorkspaceNewsSend & "?id=" & NewsId)
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(Me.LinkWorkspaceNewsletters)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="PanelConfigure" runat="server" Visible="False">
<p></p>
<table >
  <tr  valign=top>
    <td >
      <asp:RadioButton ID="rbUsers"  GroupName="rb" Checked="true" Text="Send to specified users" meta:resourcekey="rbUsers" runat="server" />
    </td>
    <td>:</td>
    <td>
      <asp:TextBox ID="txtEmail" runat="server" TextMode="MultiLine" Width="220" Height="50px"></asp:TextBox>
    </td>
  </tr>
  <tr valign=top>
    <td>
      <asp:RadioButton ID="rbRoles" GroupName="rb" Text="Send to specified roles" meta:resourcekey="rbRoles" runat="server" />
    </td>
    <td>:</td>
    <td>
      <asp:ListBox ID="lsbValuableRoles" runat="server"  Rows="5" SelectionMode="Multiple" Width="225"    >
      </asp:ListBox>
    </td></tr>
    <tr valign=top>
    <td style="white-space:nowrap" colspan="3">
      <asp:RadioButton ID="rbNoRole" GroupName="rb" Text="Send to all users with no role" meta:resourcekey="rbNoRole" runat="server" />
    </td>
  </tr>
  <tr valign=top>
    <td colspan="3" style="white-space:nowrap">
      <asp:RadioButton ID="rbAllUsers" GroupName="rb" Text="Send to all users" meta:resourcekey="rbAllUsers" runat="server" />
    </td>
  </tr>
    <tr valign=top>
    <td style="white-space:nowrap">
      <asp:RadioButton ID="rbSubscribers" GroupName="rb" Text="Send to subscribers of " meta:resourcekey="rbSubscribers" runat="server" />
    </td><td valign="baseline">:</td>
    <td>
      <asp:DropDownList ID="ddlCategories" runat="server" DataTextField="category" DataValueField="category_id">
      </asp:DropDownList><br />
        <asp:Label ID="lblIncludeUnsubscribe" meta:resourcekey="lblIncludeUnsubscribe" runat="server" Text=""></asp:Label>
      </td>
  </tr>
</table>

 <asp:HiddenField ID="hidRoles" runat="server" /> 
 <script language="javascript">
    function transferValues(oList,oHid)
        {
		    var sTmp="";
		    var count = parseInt(oList.length);
		    for (var i = 0; i < count; i++)
		      {
		      if ( oList.options[i].selected)
		        {
		        oList.options[i].selected = false;
		        sTmp+=";"+oList.options[i].value;
		        } 
		      }
		      
		oHid.value=sTmp.substring(1);
		//alert(oHid.value);
	  }
</script>
 <p></p>
  <asp:Button ID="btnNext" runat="server" Text=" Next " meta:resourcekey="btnNext"/>
  <asp:Button ID="btnCancel" runat="server" Text=" Cancel " meta:resourcekey="btnCancel"/>
</asp:Panel>
