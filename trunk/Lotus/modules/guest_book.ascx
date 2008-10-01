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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        SqlDataSource1.ConnectionString = sConn

        SqlDataSource1.SelectCommand = "select * from guest_book where (hide is null or hide = 0) and page_id=" & Me.PageID & " order by posted_date desc"
        SqlDataSource1.DeleteCommand = "DELETE FROM [guest_book] WHERE [guest_book_id] = @guest_book_id"

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
                    
                    GridView1.Columns(0).Visible = True
                    GridView1.Columns(2).Visible = True
                    
                    'Uncomment this to enable Delete link.
                    'GridView1.Columns(3).Visible = True
                    
                    btnDeleteEntry.Visible = True
                    
                    SqlDataSource1.SelectCommand = "select * from guest_book where page_id=" & Me.PageID & " order by posted_date desc"

                    Exit For
                End If
            Next
        End If
        
        GridView1.DataBind()
        
        If GridView1.Rows.Count = 0 Then
            btnDeleteEntry.Visible = False
        End If

        oConn.Close()
            
        For idx As Integer = 0 To GridView1.Rows.Count - 1
            Dim cb As CheckBox = CType(GridView1.Rows(idx).FindControl("chkDelete"), CheckBox)
            Page.ClientScript.RegisterArrayDeclaration("CheckBoxIDs", String.Concat("'", cb.ClientID, "'"))
        Next
        Dim scheck As String = "function isItemSelected() { var cb, itemChecked=false; for(var i=0;i<CheckBoxIDs.length;i++) {cb=document.getElementById(CheckBoxIDs[i]); if(cb && cb.checked) itemChecked=true; } return itemChecked;}"
        Page.ClientScript.RegisterClientScriptBlock(GetType(UserControl), "CheckSelected", scheck, True)
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO guest_book (name, email,message,posted_date,page_id,hide) " & _
                           "values (@name,@email,@message,GetDate(),@page_id,@hide)"

        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = txtName.Text
        oCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = txtEmail.Text
        oCmd.Parameters.Add("@message", SqlDbType.NText).Value = txtMessage.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = True
        oCmd.ExecuteNonQuery()
       
        oCmd.Dispose()
        oConn.Close()
        GridView1.DataBind()
        
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage
        Try
            'Dim oSmtpSection As Net.Configuration.SmtpSection = CType(ConfigurationManager.GetSection("system.net/mailSettings/smtp"), Net.Configuration.SmtpSection)
            'Dim ToMail As MailAddress = New MailAddress(oSmtpSection.From.ToString, oSmtpSection.From.ToString)
            Dim ToMail As MailAddress = New MailAddress(Me.ModuleData, Me.ModuleData)
            oMailMessage.From = New MailAddress(txtEmail.Text, txtName.Text)
            oMailMessage.To.Add(ToMail)

            oMailMessage.Subject = GetLocalResourceObject("MessageSubject")

            oMailMessage.IsBodyHtml = False

            oMailMessage.Body = txtMessage.Text

            oSmtpClient.Send(oMailMessage)
        Catch ex As Exception

        End Try
        
        If Not IsNothing(Page.Master.FindControl("placeholderPublishingInfo")) Then
            Page.Master.FindControl("placeholderPublishingInfo").Visible = False
        End If
        Page.Master.FindControl("placeholderBodyTop").Visible = False
        Page.Master.FindControl("placeholderBodyBottom").Visible = False
        Page.Master.FindControl("placeholderFileView").Visible = False
        Page.Master.FindControl("placeholderFileDownload").Visible = False
        Page.Master.FindControl("placeholderListing").Visible = False
        Page.Master.FindControl("placeholderCategoryInfo").Visible = False
        'Page.Master.FindControl("placeholderContentRating").Visible = False
        Page.Master.FindControl("placeholderComments").Visible = False
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews")) Then
            Page.Master.FindControl("placeholderStatPageViews").Visible = False
        End If
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews_Vertical")) Then
            Page.Master.FindControl("placeholderStatPageViews_Vertical").Visible = False
        End If
        
        'txtName.Text = ""
        'txtEmail.Text = ""
        'txtMessage.Text = ""
        panelGuestBook.Visible = False
        panelThankYou.Visible = True
        lblStatus.Text = GetLocalResourceObject("Status")
        'Response.Redirect(HttpContext.Current.Items("_page"))
    End Sub

    Protected Sub GridView1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To GridView1.Rows.Count - 1
            CType(GridView1.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            If CType(GridView1.Rows(i).Cells(2).Controls(0), LinkButton).Text = "True" Then
                CType(GridView1.Rows(i).Cells(2).Controls(0), LinkButton).Text = GetLocalResourceObject("Show")
            Else
                CType(GridView1.Rows(i).Cells(2).Controls(0), LinkButton).Text = GetLocalResourceObject("Hide")
            End If
        Next
        sScript = "if(!isItemSelected()) {alert('" & GetLocalResourceObject("SelectItemToDelete") & "'); return false; } " & sScript
        btnDeleteEntry.Attributes.Add("onclick", sScript)
    End Sub

    Protected Sub GridView1_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        GridView1.DataBind()
    End Sub

    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If (e.CommandName.Equals("select")) Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim keyID As DataKey = GridView1.DataKeys(index)

            Dim oCmd As SqlCommand = New SqlCommand
            oConn.Open()
            oCmd.Connection = oConn
            oCmd.CommandText = "UPDATE guest_book set hide=@hide where guest_book_id=@guest_book_id"
            oCmd.Parameters.Add("@guest_book_id", SqlDbType.Int).Value = keyID.Value
            If CType(GridView1.Rows(index).Cells(2).Controls(0), LinkButton).Text = "True" Then
                oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = False
            Else
                oCmd.Parameters.Add("@hide", SqlDbType.Bit).Value = True
            End If
            oCmd.CommandType = CommandType.Text
            oCmd.ExecuteNonQuery()
       
            oCmd.Dispose()
            oConn.Close()
            GridView1.DataBind()
        End If
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_page"))
    End Sub

    Protected Sub btnDeleteEntry_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim gbId As Integer
        
        For idx As Integer = 0 To GridView1.Rows.Count - 1
            Dim cb As CheckBox = CType(GridView1.Rows(idx).FindControl("chkDelete"), CheckBox)
            If cb.Checked Then
                gbId = GridView1.DataKeys(idx).Value
                SqlDataSource1.DeleteParameters("guest_book_id").DefaultValue = gbId
                SqlDataSource1.Delete()
            End If
        Next
        GridView1.DataBind()
    End Sub
    
</script>


<asp:Panel ID="panelGuestBook" runat="server">


<asp:GridView ID="GridView1" runat="server" EnableTheming=false Width="100%" DataSourceID="SqlDataSource1" AllowPaging="True" DataKeyNames="guest_book_id" AutoGenerateColumns="false" ShowHeader="false" GridLines="None" CellPadding="5" OnPreRender="GridView1_PreRender" OnRowDeleted="GridView1_RowDeleted" OnRowCommand="GridView1_RowCommand">
<Columns>
<asp:TemplateField ItemStyle-Width="10px" ItemStyle-VerticalAlign="Top" Visible="false">
    <ItemTemplate>
        <asp:CheckBox runat="server" ID="chkDelete"/>
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField>
    <ItemTemplate>
        <table class="comments" cellpadding="0" cellspacing="0">
        <tr>
            <td class="commentbody">
            <%#Server.HtmlEncode(Eval("message"))%>
            </td>
        </tr>
        <tr >
            <td class="commentinfo">
            <asp:Literal ID="litPostedBy" meta:resourcekey="litPostedBy" runat="server" Text="Posted by:"></asp:Literal> <%#Server.HtmlEncode(Eval("name"))%> - <%#FormatDateTime(Eval("posted_date"), DateFormat.ShortDate)%>
            </td>
        </tr>
        </table>
    </ItemTemplate>
</asp:TemplateField>
<asp:ButtonField CommandName="select" Visible=false ButtonType=Link DataTextField="hide"  />
<asp:CommandField meta:resourcekey="lblDelete" DeleteText="Delete" Visible=false ShowDeleteButton="True" />
</Columns>
</asp:GridView>
<asp:SqlDataSource ID="SqlDataSource1" runat="server">
  <DeleteParameters>
    <asp:Parameter Name="guest_book_id" Type="Int32" />
  </DeleteParameters>
</asp:SqlDataSource>

<asp:Button ID="btnDeleteEntry" runat="server" Visible="false" meta:resourcekey="btnDelete" Text="Delete" OnClick="btnDeleteEntry_Click" />

<table>
<tr>
<td colspan="3" style="padding-top:7px;padding-bottom:7px">
    <asp:Label ID="lblPostAComment" meta:resourcekey="lblPostAComment" Font-Bold=true runat="server" Text="Post a Comment"></asp:Label>
</td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblName" meta:resourcekey="lblName" runat="server" Text="Name"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtName" runat="server" Width="200"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="message" ID="RequiredFieldValidator1" ControlToValidate="txtName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap">
       <asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email"></asp:Label>
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtEmail" runat="server" Width="200"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="message" ID="RequiredFieldValidator2" ControlToValidate="txtEmail" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td style="text-align:left;white-space:nowrap" valign="top">
       <asp:Label ID="lblMessage" meta:resourcekey="lblMessage" runat="server" Text="Message"></asp:Label>
    </td>
    <td valign="top">:</td>
    <td>
        <asp:TextBox ID="txtMessage" runat="server" Width="300" TextMode=MultiLine Height="150"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="message" ID="RequiredFieldValidator3" ControlToValidate="txtMessage" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td colspan="2"></td>
    <td>
        <asp:Button ID="btnSubmit" ValidationGroup="message" meta:resourcekey="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
        
    </td>
</tr>
</table>

</asp:Panel>

<asp:Panel ID="panelThankYou" runat="server" Visible="false">
<p>
    <asp:Label ID="lblStatus" runat="server" Font-Bold=true Text=""></asp:Label>
</p>
<p>
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text="Back To Guest Book" OnClick="btnBack_Click" />
</p>
</asp:Panel>
