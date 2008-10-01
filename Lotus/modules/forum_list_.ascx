<%@ Control Language="VB" inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Dim forumURL As String
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        If Me.ModuleData Is Nothing Or Me.ModuleData = "" Then
            lblMsg.Text = "Module data is empty, please specify module data when embeding forum list."
            lblMsg.Visible = True
            Return
        End If

        forumURL = GetForumUrl()
        
        dsForumList.ConnectionString = sConn

        Dim sb As StringBuilder = New StringBuilder()
        sb.Append("select distinct top 5 ")
        sb.Append("t1.subject_id as topic_id, t1.subject, ")
        sb.Append("isnull(t2.posted_date, t1.posted_date) as last_post_date, ")
        sb.Append("isnull(t3.subject, t1.subject) as forum_subject, ")
        sb.Append("isnull(t3.category, t1.category) as forum_category ")
        sb.Append("from discussion as t1 left join ( ")
        sb.Append("     select parent_id as topic_id, max(posted_date) as posted_date ")
        sb.Append("     from discussion ")
        sb.Append("     where type in ('R', 'Q') and page_id=" & Me.ModuleData & " group by parent_id ")
        sb.Append(") as t2 on t1.subject_id=t2.topic_id ")
        sb.Append("left join discussion as t3 on t1.parent_id=t3.subject_id ")
        sb.Append("where t1.type in ('T', 'F') and t1.page_id=" & Me.ModuleData & " order by last_post_date desc ")
        'use this if forum to be excluded.
        'sb.Append("where t1.type in ('T') and t1.page_id=" & Me.ModuleData & " order by last_post_date desc ")
        
        dsForumList.SelectCommand = sb.ToString()
        gvForumList.DataBind()
        
        litTitle.Text = GetLocalResourceObject("Title")

    End Sub
    
    Protected Sub gvForumList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
            Dim forum As Literal = DirectCast(e.Row.FindControl("litForum"), Literal)
            forum.Text = "<a href=""" & forumURL & "?did=" & drv("topic_id") & """>" & drv("subject") & "</a>"
        End If

    End Sub

    Private Function GetForumUrl() As String
        Dim pId As String = Me.ModuleData
        Dim mgr As ContentManager = New ContentManager
        Dim page As CMSContent = mgr.GetLatestVersion(pId)
        
        Dim strAppPath As String = (Context.Request.ApplicationPath)
        If (Not strAppPath.EndsWith("/")) Then
            strAppPath = strAppPath & "/"
        End If
        Return strAppPath & page.FileName
    End Function
    
</script>

<asp:SqlDataSource ID="dsForumList" runat="server"></asp:SqlDataSource>

<table cellpadding="0" cellspacing="0" class="scrollNewsList" id="boxNewsList" runat=server>
<tr>
    <td class="scrollHeaderNewsList">
        <asp:Literal ID="litTitle" runat="server"></asp:Literal>
    </td>
</tr>
<tr>
    <td class="scrollContentNewsList">
    <asp:Label ID="lblMsg" runat="server" Visible="False"></asp:Label>
    <asp:GridView ID="gvForumList" runat="server" DataSourceID="dsForumList"  EnableTheming="False" Width="100%" AutoGenerateColumns="False" ShowHeader="True" GridLines="None" CellPadding="5" CellSpacing="1" OnRowDataBound="gvForumList_RowDataBound">
    <Columns>
        <asp:TemplateField>
            <HeaderStyle Width="70%"  />
            <HeaderTemplate><%=GetLocalResourceObject("hdrTopics")%></HeaderTemplate>
            <ItemTemplate><asp:Literal ID="litForum" runat="server"></asp:Literal></ItemTemplate>        
        </asp:TemplateField>
        <asp:BoundField HeaderText="Category" meta:resourcekey="hdrCategory" DataField="forum_category" HeaderStyle-Width="10%" HeaderStyle-Wrap="False" ItemStyle-Wrap="false"/>
        <asp:BoundField HeaderText="Post Date" meta:resourcekey="hdrPosted" DataField="last_post_date" HeaderStyle-Width="10%" HeaderStyle-Wrap="False" ItemStyle-Wrap="false" DataFormatString="{0:d}" HtmlEncode="False"  />
    </Columns>
    </asp:GridView>

    </td>
</tr>
</table>
