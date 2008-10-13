<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">   
    'Param: Title, Number of News items, News Page IDs
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oContent As Content = New Content
 
        litTitle.Text = ""
        lnkMore.NavigateUrl = ""
        lnkMore.Visible = False
        
        'Calendar-based
        oContent.SortingBy = "display_date"
        oContent.SortingType = "DESC"
        dlPagesWithin.DataSource = oContent.GetMultiplePagesWithin(Me.ModuleData, 5)
        dlPagesWithin.DataBind()
        
        If dlPagesWithin.Items.Count = 0 Then
            boxNewsList.Style.Add("display", "none")
        End If
        
        oContent = Nothing

        'scrContents.Style.Add("display", "none")
        'Dim cLiteral As New LiteralControl
        'cLiteral = New LiteralControl("<" & "script language=""javascript"" src=""systems/nlsscroller/nlsscroller.js"" type=""text/javascript""></" & "script>")
        'Page.Master.Page.Header.Controls.Add(cLiteral)
        'cLiteral = New LiteralControl("<script language=""javascript"" type=""text/javascript""> var n = new NlsScroller(""scroll" & scrContents.ClientID & """); var isIE=(window.navigator.appName==""Microsoft Internet Explorer""); n.setContents(NlsGetElementById(""" & scrContents.ClientID & """).innerHTML); n.scrollerWidth=""100%""; n.scrollerHeight=120; n.showToolbar=false; n.setEffect(new NlsEffContinuous(""direction=up,speed=50,step=1,delay=0"")); n.render(); n.start(); </" & "script>")
        'divHelp.Controls.Add(cLiteral)
    End Sub
</script>

<table cellpadding="0" cellspacing="0" class="scrollNewsList" id="boxNewsList" runat=server>
<tr>
    <td class="scrollHeaderNewsList">
        <asp:Literal ID="litTitle" runat="server"></asp:Literal>
    </td>
</tr>
<tr>
    <td class="scrollContentNewsList">
    <div id="scrContents" runat="server">
        <asp:Repeater ID="dlPagesWithin" runat="server">
        <ItemTemplate>  
            <div style="height:100%;margin-bottom:8px;"> 
                <div><%#FormatDateTime(CDate(Eval("display_date")).AddHours(Me.TimeOffset), DateFormat.LongDate)%></div>
                <b><%#HttpUtility.HtmlEncode(Eval("title"))%></b>
                <div><%#Eval("summary") %></div>
                <div><a target="<%#Eval("link_target")%>" href="<%#Eval("file_name")%>">
                <asp:Literal ID="litMore" meta:resourcekey="litMore" runat="server" Text="More"></asp:Literal></a><br /><br />
                </div>
            </div>
        </ItemTemplate>        
        </asp:Repeater>

    </div>
    <div id="divHelp" runat="server"></div>
    </td>
</tr>
<tr>
    <td class="scrollFooterNewsList">
        <asp:HyperLink ID="lnkMore" meta:resourcekey="lnkMore" runat="server">More</asp:HyperLink>
    </td>
</tr>
</table>

