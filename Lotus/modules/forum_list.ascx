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

        If Not Me.IsUserAuthorised Then
            boxNewsList.Visible = False
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
    
    Private Function IsUserAuthorised() As Boolean

        IsUserAuthorised = False

        ' Get the channel of the page where the forum resides
        Dim pId As String = Me.ModuleData
        Dim mgr As ContentManager = New ContentManager
        Dim page As CMSContent = mgr.GetLatestVersion(pId)
        Dim chMgr As ChannelManager = New ChannelManager
        Dim channel As CMSChannel = chMgr.GetChannel(page.ChannelId)

        ' Check if this is a public channel
        If channel.Permission = 1 Then
            Return True
            ' If this is a registered users only channel, check that the user is logged in
        ElseIf channel.Permission = 2 And Me.IsUserLoggedIn Then
            Return True
        ElseIf channel.Permission = 3 And Me.IsUserLoggedIn Then
            ' If a members-only channel, check the logged-in user's roles for access
            Dim arrUserRoles() As String = Roles.GetRolesForUser(Me.UserName) 'Check User's Roles
            For Each sItem As String In arrUserRoles
                If sItem = channel.ChannelName + " Subscribers" Or _
                    sItem = channel.ChannelName + " Authors" Or _
                    sItem = channel.ChannelName + " Editors" Or _
                    sItem = channel.ChannelName + " Publishers" Or _
                    sItem = channel.ChannelName + " Resource Managers" Or _
                    sItem = "Administrators" Then
                    Return True
                End If
            Next
        End If
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
<%--        <asp:BoundField HeaderText="Post Date" meta:resourcekey="hdrPosted" DataField="last_post_date" HeaderStyle-Width="10%" HeaderStyle-Wrap="False" ItemStyle-Wrap="false" DataFormatString="{0:d}" HtmlEncode="False"  />
--%>        <asp:TemplateField HeaderText="Post Date" meta:resourcekey="hdrPosted" HeaderStyle-Width="10%" HeaderStyle-Wrap="False" ItemStyle-Wrap="false">
            <ItemTemplate>
            <%#FormatDateTime(CDate(Eval("last_post_date")).AddHours(Me.TimeOffset), DateFormat.ShortDate)%>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    </asp:GridView>

    </td>
</tr>
</table>
