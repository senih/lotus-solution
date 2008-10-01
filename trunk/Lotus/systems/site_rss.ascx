<%@ Control Language="VB" Inherits="BaseUserControl" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        SqlDataSource1.ConnectionString = sConn

        SqlDataSource1.SelectCommand = "SELECT pages_published.page_id, pages_published.title, pages_published.file_name " & _
            "FROM pages_published INNER JOIN " & _
            "listing_templates ON pages_published.listing_template_id = listing_templates.id  " & _
            "WHERE (pages_published.is_hidden = 0) AND (pages_published.is_system = 0) AND (listing_templates.listing_type = 2) AND  " & _
            "(pages_published.channel_permission = 1)"
        
        GridView1.DataBind()
    End Sub
</script>

<asp:GridView ID="GridView1" runat="server" EnableTheming="false" DataSourceID="SqlDataSource1" AllowPaging="False" DataKeyNames="page_id" AutoGenerateColumns="false" ShowHeader="false" GridLines="None" CellPadding="3">
<Columns>
<asp:TemplateField>
<ItemTemplate>
    <a href="<%#Eval("file_name")%>" title=""><%#Eval("title")%></a>&nbsp;&nbsp;
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField>
<ItemTemplate>
    <a href="systems/rss.aspx?pg=<%#Eval("page_id")%>&c=<%#Me.Culture%>" target="_blank" title=""><img src="systems/images/rss.gif" style="border:none" alt=""/></a><br />
</ItemTemplate>
</asp:TemplateField>
</Columns>
</asp:GridView>
<asp:SqlDataSource ID="SqlDataSource1" runat="server">
  <DeleteParameters>
    <asp:Parameter Name="page_id" Type="Int32" />
  </DeleteParameters>
</asp:SqlDataSource>