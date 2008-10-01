<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private arrUserRoles() As String
    Private bEnableDeleteFacility As Boolean = False
    
    Private bAllowAnonymous As Boolean = True
    Public Property AllowAnonymous() As Boolean
        Get
            Return bAllowAnonymous
        End Get
        Set(ByVal value As Boolean)
            bAllowAnonymous = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.DeleteCommand = "DELETE FROM [page_comments] WHERE [id] = @id"
        SqlDataSource1.SelectCommand = "SELECT * from page_comments where (hide is null or hide = 0) and page_id=" & Me.PageID & " order by posted_date desc"
        
        '~~~ If not subscriber, enable hide & delete facility ~~~
        If Not IsNothing(GetUser()) Then
            arrUserRoles = Roles.GetRolesForUser(GetUser.UserName)
            Dim sItem As String
            For Each sItem In arrUserRoles
                If sItem.Contains(" Authors") Or _
                    sItem.Contains(" Editors") Or _
                    sItem.Contains(" Publishers") Or _
                    sItem.Contains(" Resource Managers") Or _
                    sItem = "Administrators" Then
                    bEnableDeleteFacility = True
                    gvDiscussion.Columns(1).Visible = True
                    gvDiscussion.Columns(2).Visible = True
                    
                    SqlDataSource1.SelectCommand = "select * from page_comments where page_id=" & Me.PageID & " order by posted_date desc"

                    Exit For
                End If
            Next
        End If
        
        gvDiscussion.DataBind()
        If gvDiscussion.Rows.Count > 0 Then
            panelTitle.Visible = True
            panelComments.Visible = True
        Else
            panelTitle.Visible = False
            panelComments.Visible = False
        End If
        
        If bAllowAnonymous Then
            panelPleaseLogin.Visible = False
            panelPostMessage.Visible = True
            If Not IsNothing(GetUser) Then
                txtName.Text = GetUser.UserName
                txtName.ReadOnly = True
                txtEmail.Text = GetUser.Email
                txtEmail.ReadOnly = True
            End If
        Else
            If Not IsNothing(GetUser) Then
                panelPleaseLogin.Visible = False
                panelPostMessage.Visible = True
                txtName.Text = GetUser.UserName
                txtName.ReadOnly = True
                txtEmail.Text = GetUser.Email
                txtEmail.ReadOnly = True
            Else
                panelPleaseLogin.Visible = True
                panelPostMessage.Visible = False

                If gvDiscussion.Rows.Count = 0 Then 'kalau blm login (blm bisa posting) & blm ada comments
                    panelTitle.Visible = True
                End If
            End If
        End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not bAllowAnonymous Then
            If Not Me.IsUserLoggedIn Then Exit Sub
        End If
        
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "insert into page_comments(page_id, posted_by, message,posted_date,email,url,hide) " & _
                "values (@page_id, @posted_by, @message, GetDate(),@email,@url,@hide)"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCmd.Parameters.Add("@posted_by", SqlDbType.NVarChar).Value = txtName.Text
        oCmd.Parameters.Add("@message", SqlDbType.NText).Value = txtMessage.Text
        oCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = txtEmail.Text
        If txtURL.Text = "http://" Then
            oCmd.Parameters.Add("@url", SqlDbType.NVarChar).Value = ""
        Else
            oCmd.Parameters.Add("@url", SqlDbType.NVarChar).Value = txtURL.Text
        End If
        oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = True
        oCmd.ExecuteNonQuery()
        
        Dim sChannelName As String = ""
        oCmd.CommandText = "select channel_name from pages_working where page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        'oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        Dim oDataReader As SqlDataReader
        oDataReader = oCmd.ExecuteReader()
        While oDataReader.Read()
            sChannelName = oDataReader("channel_name").ToString()
        End While
        oDataReader.Close()
        oCmd.Dispose()
        oConn.Close()
        
        Dim sTitle As String = ""
        Dim sLink As String = ""
        Dim sBody As String = ""
        Dim oContent As Content = New Content
        Dim dt As DataTable
        dt = oContent.GetPage(Me.PageID, True)
        If dt.Rows.Count > 0 Then
            sTitle = dt.Rows(0).Item("title").ToString
            sLink = "<a href=""" & Me.AppFullPath & "/" & dt.Rows(0).Item("file_name").ToString & """>" & sTitle & "</a>"
        End If
        oContent = Nothing
        sBody = "<html><head></head><body style=""font-family:verdana;font-size:11px"">" & sLink & "<br /><br />" & Server.HtmlEncode(txtMessage.Text) & "</body></html>"
        
        Dim sSubject As String = GetLocalResourceObject("MessageSubject")
                
        Dim allUsers() As String = Roles.GetUsersInRole(sChannelName & " Authors")
        'Dim allUsers() As String = Roles.GetUsersInRole("Administrators")
        Dim i As Integer
        Dim mailTo(UBound(allUsers)) As String
        For i = LBound(allUsers) To UBound(allUsers)
            mailTo(i) = GetUser(allUsers(i)).Email
        Next
        SendMail(Nothing, mailTo, sSubject, sBody)

        panelTitle.Visible = False
        panelComments.Visible = False
        panelPostMessage.Visible = False
        Page.Master.FindControl("placeholderBody").FindControl("panelBody").Visible = False
        
        If Not IsNothing(Page.Master.FindControl("placeholderPublishingInfo")) Then
            Page.Master.FindControl("placeholderPublishingInfo").Visible = False
        End If
        Page.Master.FindControl("placeholderBodyTop").Visible = False
        Page.Master.FindControl("placeholderBodyBottom").Visible = False
        Page.Master.FindControl("placeholderFileView").Visible = False
        Page.Master.FindControl("placeholderFileDownload").Visible = False
        Page.Master.FindControl("placeholderListing").Visible = False
        Page.Master.FindControl("placeholderCategoryInfo").Visible = False
        Page.Master.FindControl("placeholderContentRating").Visible = False
        'Page.Master.FindControl("placeholderComments").Visible = False
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews")) Then
            Page.Master.FindControl("placeholderStatPageViews").Visible = False
        End If
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews_Vertical")) Then
            Page.Master.FindControl("placeholderStatPageViews_Vertical").Visible = False
        End If
        
        panelThankYou.Visible = True
        lblStatus.Text = GetLocalResourceObject("Status")
    End Sub
    
    Private Function SendMail(ByVal maFrom As MailAddress, ByVal mailTo() As String, ByVal strSubject As String, ByVal strBody As String) As Boolean
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage

        Try
            Dim i As Integer
            For i = 0 To UBound(mailTo)
                oMailMessage.To.Add(mailTo(i))
            Next

            oMailMessage.Subject = strSubject
            oMailMessage.IsBodyHtml = True
            oMailMessage.Body = strBody

            oSmtpClient.Send(oMailMessage)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Protected Sub gvDiscussion_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvDiscussion.Rows.Count - 1
            If Me.ParentPageType = 10 Or Me.PageType = 10 Then
                If Me.IsOwner Or Me.IsAdministrator Then
                    CType(gvDiscussion.Rows(i).Cells(2).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
                    If CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = "True" Then
                        CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = GetLocalResourceObject("Show")
                    Else
                        CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = GetLocalResourceObject("Hide")
                    End If
                Else
                    gvDiscussion.Columns(1).Visible = False
                End If
            Else
                If Me.IsAdministrator Or Me.IsAuthor Then
                    CType(gvDiscussion.Rows(i).Cells(2).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
                    If CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = "True" Then
                        CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = GetLocalResourceObject("Show")
                    Else
                        CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Text = GetLocalResourceObject("Hide")
                    End If
                Else
                    gvDiscussion.Columns(1).Visible = False
                End If
            End If
        Next
    End Sub
    
    Protected Sub gvDiscussion_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        gvDiscussion.DataBind()
    End Sub

    Protected Sub gvDiscussion_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If (e.CommandName.Equals("select")) Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim keyID As DataKey = gvDiscussion.DataKeys(index)

            Dim oCmd As SqlCommand = New SqlCommand
            oConn.Open()
            oCmd.Connection = oConn
            oCmd.CommandText = "UPDATE page_comments set hide=@hide where id=@id"
            oCmd.Parameters.Add("@id", SqlDbType.Int).Value = keyID.Value
            If CType(gvDiscussion.Rows(index).Cells(1).Controls(0), LinkButton).Text = "True" Then
                oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = False
            Else
                oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = True
            End If
            oCmd.CommandType = CommandType.Text
            oCmd.ExecuteNonQuery()
       
            oCmd.Dispose()
            oConn.Close()
            gvDiscussion.DataBind()
        End If
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_page"))
    End Sub
    
    Protected Function ShowPostedBy(ByVal sPostedBy As String, ByVal sURL As String) As String
        If sURL = "" Then
            Return Server.HtmlEncode(sPostedBy)
        Else
            Return "<a href=""" & sURL & """ target=""_blank"">" & Server.HtmlEncode(sPostedBy) & "</a>"
        End If
    End Function
</script>

<div class="comments_page_separator" style="border-top:#d0d0d0 1px solid;margin-top:7px;"></div>

<asp:Panel ID="panelTitle" runat="server">
    <div style="margin:7px"></div>
    <asp:Label ID="lblComments" meta:resourcekey="lblComments" runat="server" Font-Bold="true" Text="Comments"></asp:Label>
</asp:Panel>

<asp:Panel ID="panelComments" runat="server">
    <div style="margin:15px"></div>
    <asp:GridView ID="gvDiscussion" EnableTheming="false" PageSize="10"
    Width="100%" DataKeyNames="id" runat="server" GridLines="None" CellPadding="0"
    AutoGenerateColumns="false" ShowHeader="false"  DataSourceID="SqlDataSource1" 
    OnPreRender="gvDiscussion_PreRender" AllowPaging="true" OnRowDeleted="gvDiscussion_RowDeleted" OnRowCommand="gvDiscussion_RowCommand">
    <Columns>
      <asp:TemplateField>
        <ItemTemplate>
          <table class="comments" cellpadding="0" cellspacing="0">
            <tr>
              <td class="commentbody">
                <%#Server.HtmlEncode(Eval("Message")).Replace(Chr(10), "<br/>")%>
              </td>
            </tr>
            <tr >
              <td class="commentinfo">
              <%=GetLocalResourceObject("PostedBy")%> : <%#ShowPostedBy(Eval("posted_by"), Eval("url", ""))%> - <%#FormatDateTime(Eval("posted_date"), DateFormat.LongDate)%>
              </td>
            </tr>
          </table>
        </ItemTemplate>
      </asp:TemplateField>
        <asp:ButtonField CommandName="select" Visible=false ButtonType=Link DataTextField="hide"  />
        <asp:CommandField meta:resourcekey="lblDelete" DeleteText="Delete" Visible=false ShowDeleteButton="True" />    
    </Columns>
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    <DeleteParameters>
      <asp:Parameter Name="id" Type="Int32" />
    </DeleteParameters>
  </asp:SqlDataSource>
  <div style="margin:15px"></div>
</asp:Panel>

<asp:Panel ID="panelPleaseLogin" runat="server">
<div style="margin:7px"></div>
<asp:Label ID="lblPleaseLogin" meta:resourcekey="lblPleaseLogin" runat="server" Text="Please login to post a comment."></asp:Label>
<div style="margin:7px"></div>
</asp:Panel>

<asp:Panel ID="panelPostMessage" runat="server">
    <div style="margin:7px"></div>
    <asp:Label ID="lblPostComment" meta:resourcekey="lblPostComment" runat="server" Text="Post a Comment" Font-Bold="true"></asp:Label>
    <div style="margin:15px"></div>

    <asp:Label ID="lblName" meta:resourcekey="lblName" runat="server"></asp:Label>:<br />
    <asp:TextBox ID="txtName" Width="300" runat="server"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtName"  ValidationGroup="comment" ErrorMessage="*"></asp:RequiredFieldValidator>
    <div style="margin:7px"></div
    
    <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server"></asp:Label>:<br />
    <asp:TextBox ID="txtEmail" Width="300" runat="server"></asp:TextBox> 
    <asp:Label ID="lblOptional" meta:resourcekey="lblOptional" Font-Italic="true" runat="server"></asp:Label>
    <div style="margin:7px"></div
    
    <asp:Label ID="lblURL" meta:resourcekey="lblURL" runat="server"></asp:Label>:<br />
    <asp:TextBox ID="txtURL" Width="300" runat="server" Text="http://"></asp:TextBox>
    <asp:Label ID="lblOptional2" meta:resourcekey="lblOptional" Font-Italic="true" runat="server"></asp:Label>
    <div style="margin:7px"></div

    <asp:Label ID="lblCommentsLabel" meta:resourcekey="lblComments" runat="server" Text="Comments"></asp:Label>:<br />
    <asp:TextBox ID="txtMessage" runat="server" Height="150px" 
        TextMode="MultiLine" Width="90%"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtMessage" ValidationGroup="comment"  ErrorMessage="*"></asp:RequiredFieldValidator>
    <div style="margin:7px"></div>

    <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Submit " ValidationGroup="comment"  OnClick="btnSubmit_Click" />
</asp:Panel>

<asp:Panel ID="panelThankYou" runat="server" Visible="false">
<p>
    <asp:Label ID="lblStatus" runat="server" Font-Bold=true Text=""></asp:Label>
</p>
<p>
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text="Back To Page" OnClick="btnBack_Click" />
</p>
</asp:Panel>
