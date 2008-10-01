<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">   
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsPostBack Then
            SqlDataSource1.ConnectionString = sConn
            'Shows upcoming events
            SqlDataSource1.SelectCommand = "SELECT * FROM calendar WHERE is_rec=0 AND " & _
                "start_time>getdate() AND page_id=" & Me.ModuleData & " ORDER BY start_time desc"
            'SqlDataSource1.SelectParameters.Add("root_id", SqlDbType.Int)
            'SqlDataSource1.SelectParameters(0).DefaultValue = Me.RootID
            dlPagesWithin.DataSourceID = "SqlDataSource1"
            dlPagesWithin.DataBind()
            
            If dlPagesWithin.Items.Count = 0 Then
                boxNewsList.Style.Add("display", "none")
                        

            End If
        End If
        
        Dim oContent As Content = New Content
        Dim dt As DataTable
        dt = oContent.GetPage(Me.ModuleData, True)
        If dt.Rows.Count > 0 Then
            litTitle.Text = dt.Rows(0).Item(1).ToString
            lnkMore.NavigateUrl = "~/" & dt.Rows(0).Item(3).ToString
        Else
            lnkMore.Visible = False
        End If
        oContent = Nothing
        
        Dim cLiteral As New LiteralControl
        cLiteral = New LiteralControl("<" & "script language=""javascript"" src=""systems/nlsscroller/nlsscroller.js"" type=""text/javascript""></" & "script>")
        Page.Master.Page.Header.Controls.Add(cLiteral)
        
        cLiteral = New LiteralControl("<script language=""javascript"" type=""text/javascript""> var n = new NlsScroller(""scroll" & scrContents.ClientID & """); var isIE=(window.navigator.appName==""Microsoft Internet Explorer""); n.setContents(NlsGetElementById(""" & scrContents.ClientID & """).innerHTML); n.scrollerWidth=""100%""; n.scrollerHeight=150; n.showToolbar=false; n.setEffect(new NlsEffContinuous(""direction=up,speed=50,step=1,delay=0"")); n.render(); n.start(); </" & "script>")
        divHelp.Controls.Add(cLiteral)
    End Sub
    
    Function ShowURL(ByVal sURL As String) As String
        If sURL = "" Then
            Return ""
        Else
            Return "<a href=""" & sURL & """>" & GetLocalResourceObject("More") & "</a><br />"
        End If
    End Function
 
</script>
<asp:SqlDataSource ID="SqlDataSource1" runat="server" >
</asp:SqlDataSource>
<table cellpadding="0" cellspacing="0" class="scrollNewsList" id="boxNewsList" runat=server>
<tr>
    <td class="scrollHeaderNewsList">
        <asp:Literal ID="litTitle" runat="server"></asp:Literal>
    </td>
</tr>
<tr>
    <td class="scrollContentNewsList">
    <div id="scrContents" style="display:none;" runat="server">
    
        <asp:Repeater ID="dlPagesWithin" runat="server">
        <ItemTemplate>  
            <div style="height:100%;margin-bottom:8px;"> 
                <div><%#FormatDateTime(Eval("start_time"), DateFormat.ShortDate)%></div>
                <b><%#Eval("subject")%></b>
                <div><%#Eval("location")%></div>
                <div><%#ShowURL(Eval("url", ""))%><br /></div>
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

