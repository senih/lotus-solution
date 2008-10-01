<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">  
    
    Private sUserId As String
    Private bAllowAnonymous As Boolean = True

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Public Property AllowAnonymous() As Boolean
        Get
            Return bAllowAnonymous
        End Get
        Set(ByVal value As Boolean)
            bAllowAnonymous = value
        End Set
    End Property
  
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
         
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.DeleteCommand = "DELETE FROM [page_comments] WHERE [id] = @id"
        SqlDataSource1.SelectCommand = "SELECT * from page_comments where page_id = @page_id"
        SqlDataSource1.SelectCommandType = SqlDataSourceCommandType.Text
        SqlDataSource1.SelectParameters("page_id").DefaultValue = Me.PageID
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
        
        Dim sqlCmd As SqlCommand
        Dim StrSQL As String
        
        oConn.Open()
        
        StrSQL = "insert into page_comments(page_id, posted_by, message,posted_date,email,url) " & _
                "values (@page_id, @posted_by, @message, GetDate(),@email,@url)"
        sqlCmd = New SqlCommand(StrSQL, oConn)
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        sqlCmd.Parameters.Add("@posted_by", SqlDbType.NVarChar).Value = txtName.Text
        sqlCmd.Parameters.Add("@message", SqlDbType.NText).Value = txtMessage.Text
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = txtEmail.Text
        If txtURL.Text = "http://" Then
            sqlCmd.Parameters.Add("@url", SqlDbType.NVarChar).Value = ""
        Else
            sqlCmd.Parameters.Add("@url", SqlDbType.NVarChar).Value = txtURL.Text
        End If
        
        sqlCmd.ExecuteNonQuery()
        oConn.Close()
        
        'refresh grid
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub gvDiscussion_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvDiscussion.Rows.Count - 1
            If Me.ParentPageType = 10 Or Me.PageType = 10 Then
                If Me.IsOwner Or Me.IsAdministrator Then
                    CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
                Else
                    gvDiscussion.Columns(1).Visible = False
                End If
            Else
                If Me.IsAdministrator Or Me.IsAuthor Then
                    CType(gvDiscussion.Rows(i).Cells(1).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
                Else
                    gvDiscussion.Columns(1).Visible = False
                End If
            End If
        Next
    End Sub

    Protected Sub gvDiscussion_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)
        gvDiscussion.PageIndex = e.NewPageIndex
        gvDiscussion.DataBind()
    End Sub

    Protected Sub gvDiscussion_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        'refresh grid
        Response.Redirect(HttpContext.Current.Items("_path"))
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
    <asp:GridView ID="gvDiscussion" EnableTheming="false" 
    Width="100%" DataKeyNames="id" runat="server" GridLines="None" CellPadding="0"
    AutoGenerateColumns="false" ShowHeader="false"  DataSourceID="SqlDataSource1" 
    OnPreRender="gvDiscussion_PreRender" AllowPaging="true" OnPageIndexChanging="gvDiscussion_PageIndexChanging" OnRowDeleted="gvDiscussion_RowDeleted">
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
      <asp:CommandField meta:resourcekey="lblCommand" DeleteText="Delete" ShowDeleteButton="true"  ButtonType="link" /> 
    </Columns>
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    <DeleteParameters>
      <asp:Parameter Name="id" Type="Int32" />
    </DeleteParameters>
    <SelectParameters>
      <asp:Parameter Name="page_id" Type="Int32" />
    </SelectParameters>
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

