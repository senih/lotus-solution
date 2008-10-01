<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">   
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oContent As Content = New Content
 
        Dim dt As DataTable
        dt = oContent.GetPage(Me.ModuleData, True)
        If dt.Rows.Count > 0 Then
            litTitle.Text = dt.Rows(0).Item(1).ToString
            lnkMore.NavigateUrl = "~/" & dt.Rows(0).Item(3).ToString
            
            Dim sListingDefaultOrder As String
            sListingDefaultOrder = dt.Rows(0).Item("listing_default_order").ToString
            If Convert.ToBoolean(dt.Rows(0).Item("is_listing")) Then
                Dim nListingType As Integer = dt.Rows(0).Item("listing_type")
                Dim sSortType As String = "DESC"
                If nListingType = 1 Then
                    'General    
                    If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                        sSortType = "ASC"
                    End If
                    oContent.SortingBy = sListingDefaultOrder
                    oContent.SortingType = sSortType
                        
                    Dim nListingProperty As Integer = dt.Rows(0).Item("listing_property")
                    If nListingProperty = 1 Or nListingProperty = 3 Then
                        oContent.ManualOrder = True
                    End If
                Else
                    'Calendar-based
                    oContent.SortingBy = "display_date"
                    oContent.SortingType = "DESC"
                End If
            Else
                oContent.ManualOrder = True
            End If
        Else
            lnkMore.Visible = False
        End If
        
        dlPagesWithin.DataSource = oContent.GetPagesWithin(Me.ModuleData, 5, 2)
        dlPagesWithin.DataBind()
        
        If dlPagesWithin.Items.Count = 0 Then
            boxNewsList.Style.Add("display", "none")
        End If
        
        oContent = Nothing

        Dim cLiteral As New LiteralControl
        cLiteral = New LiteralControl("<" & "script language=""javascript"" src=""systems/nlsscroller/nlsscroller.js"" type=""text/javascript""></" & "script>")
        Page.Master.Page.Header.Controls.Add(cLiteral)
        
        cLiteral = New LiteralControl("<script language=""javascript"" type=""text/javascript""> var n = new NlsScroller(""scroll" & scrContents.ClientID & """); var isIE=(window.navigator.appName==""Microsoft Internet Explorer""); n.setContents(NlsGetElementById(""" & scrContents.ClientID & """).innerHTML); n.scrollerWidth=""100%""; n.scrollerHeight=120; n.showToolbar=false; n.setEffect(new NlsEffContinuous(""direction=up,speed=50,step=1,delay=0"")); n.render(); n.start(); </" & "script>")
        divHelp.Controls.Add(cLiteral)
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
    <div id="scrContents" style="display:none;" runat="server">
    
        <asp:Repeater ID="dlPagesWithin" runat="server">
        <ItemTemplate>  
            <div style="height:100%;margin-bottom:8px;"> 
                <div><%#FormatDateTime(Eval("display_date"), DateFormat.LongDate)%></div>
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

