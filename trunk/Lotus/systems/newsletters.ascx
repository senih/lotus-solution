<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsNothing(GetUser()) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
                                
                panelNews.Visible = True

                lnkMailingLists.NavigateUrl = "~/" & Me.LinkWorkspaceNewsLists
                lnkSettings.NavigateUrl = "~/" & Me.LinkWorkspaceNewsSettings
                lnkSubscribers.NavigateUrl = "~/" & Me.LinkWorkspaceNewsSubscribers

                SqlNewsletters.ConnectionString = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
                SqlNewsletters.SelectCommand = "select * from newsletters where root_id=" & Me.RootID & " or root_id is null order by subject"
                SqlNewsletters.DeleteCommand = "--"
            End If
        Else
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelNews.Visible = False
        End If
    End Sub

    Protected Sub grvNewsletters_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles grvNewsletters.PreRender
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvNewsletters.Rows.Count - 1
            CType(grvNewsletters.Rows(i).Cells(5).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub grvNewsletters_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grvNewsletters.RowDeleting
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        Dim NewsId As Integer = grvNewsletters.DataKeys.Item(e.RowIndex).Value
        DeleteNewsletter(grvNewsletters.DataKeys.Item(e.RowIndex).Value)
        'tambahan untuk delete attachment ketika delete message
        '------------------------------------------------------
        Dim sPath As String = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId
        If System.IO.Directory.Exists(sPath) Then
            System.IO.Directory.Delete(sPath, True)
        End If

        grvNewsletters.DataBind()
    End Sub

    'Edit newsletter
    Protected Sub grvNewsletters_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles grvNewsletters.RowEditing
        Response.Redirect(Me.LinkWorkspaceNewsEdit & "?id=" & grvNewsletters.DataKeys.Item(e.NewEditIndex).Value)
    End Sub

    'Send newsletter
    Protected Sub grvNewsletters_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles grvNewsletters.SelectedIndexChanging
        Dim sUrl As String = ""
        Dim oNewsletter As Newsletter = New Newsletter

        Dim NewsId As Integer = grvNewsletters.DataKeys.Item(e.NewSelectedIndex).Value
        oNewsletter = GetNewsletterById(NewsId)

        If oNewsletter.ReceipientsType = 0 Then
            sUrl = Me.LinkWorkspaceNewsConfigure & "?id=" & NewsId.ToString
        Else
            sUrl = Me.LinkWorkspaceNewsSend & "?id=" & NewsId.ToString
        End If
        Response.Redirect(sUrl)
    End Sub

    'Add newsletter
    Protected Sub lnkNewHtml_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewHtml.Click
        Response.Redirect(Me.LinkWorkspaceNewsAdd & "?mode=adv")
    End Sub

    Protected Sub lnkNewText_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewText.Click
        Response.Redirect(Me.LinkWorkspaceNewsAdd)
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelNews" runat="server">
    <p>
    <asp:LinkButton ID="lnkNewHtml" Text="New Html Message" meta:resourcekey="lnkNewHtml" runat="server"></asp:LinkButton>&nbsp;&nbsp; 
    <asp:LinkButton ID="lnkNewText" Text="New Text Message" meta:resourcekey="lnkNewText" runat="server"></asp:LinkButton>&nbsp;&nbsp; 
    <asp:HyperLink ID="lnkMailingLists" meta:resourcekey="lnkMailingLists" runat="server">Mailing Lists</asp:HyperLink>&nbsp;&nbsp; 
    <asp:HyperLink ID="lnkSubscribers" meta:resourcekey="lnkSubscribers" runat="server">Subscribers</asp:HyperLink>&nbsp;&nbsp; 
    <asp:HyperLink ID="lnkSettings" meta:resourcekey="lnkSettings" runat="server">Settings</asp:HyperLink>
    </p>
    
    <asp:GridView ID="grvNewsletters" AlternatingRowStyle-BackColor="#f6f7f8" runat="server"
      HeaderStyle-BackColor="#d6d7d8" CellPadding=7  
      HeaderStyle-HorizontalAlign=Left GridLines=None 
      AutoGenerateColumns="False" 
      AllowPaging="True" AllowSorting="True" 
      DataKeyNames="id" DataSourceID="SqlNewsletters">
    <Columns>
      <asp:BoundField DataField="subject" HeaderText="Subject" meta:resourcekey="subject" SortExpression="subject" />
      <asp:TemplateField HeaderText="Date Created" meta:resourcekey="created_date" SortExpression="created_date">
      <ItemTemplate>
      <%#CDate(Eval("created_date")).AddHours(Me.TimeOffset)%> 
      </ItemTemplate>
      </asp:TemplateField>
      <asp:BoundField DataField="author" HeaderText="Author" meta:resourcekey="author" SortExpression="author" />
      <asp:CommandField EditText="Edit"  ShowEditButton="True" meta:resourcekey="Command" /> 
      <asp:CommandField SelectText="Send" ShowSelectButton="True" meta:resourcekey="Command" /> 
      <asp:CommandField ShowDeleteButton="True" meta:resourcekey="Command"/>
    </Columns>
    <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" />
    <AlternatingRowStyle BackColor="#F6F7F8" />
  </asp:GridView>
      
    <asp:SqlDataSource ID="SqlNewsletters" runat="server" >
    </asp:SqlDataSource>
</asp:Panel>

 

