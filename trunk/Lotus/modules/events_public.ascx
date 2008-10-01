<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SqlDataSource1.ConnectionString = sConn
            'Shows 5 upcoming events
            SqlDataSource1.SelectCommand = "SELECT top 5 * FROM events WHERE ((repeat <> 0 AND type = 2)" & _
                                  " and to_date>getdate()) And (root_id=" & Me.RootID & " or root_id is null) ORDER BY from_date desc"
            'SqlDataSource1.SelectParameters.Add("root_id", SqlDbType.Int)
            'SqlDataSource1.SelectParameters(0).DefaultValue = Me.RootID
            gridviewEvents.DataSourceID = "SqlDataSource1"
            gridviewEvents.DataBind()

            If gridviewEvents.Rows.Count > 0 Then
                lblEvents.Visible = True
                idMoreEvents.Visible = True
                lnkMoreEvents.NavigateUrl = "~/" & Me.LinkEvents
                panelEventsPublic.Visible = True
            Else
                panelEventsPublic.Visible = False
            End If
        End If
    End Sub

    Function ShowMore(ByVal link As String) As String
        If Not (link = "") Then
            Return ("<a href=""" & link & """>" & GetLocalResourceObject("More") & "</a>")
        Else
            Return ("")
        End If
    End Function

    Function ShowTitle(ByVal sTitle As String) As String
        If Not (sTitle = "") Then
            Return ("<strong>" & sTitle & "</strong><br/>")
        Else
            Return ("<br/>")
        End If
    End Function

    Function ShowTooltip(ByVal sTitle As String, _
    ByVal sDescription As String, _
    ByVal bIsAllDay As Boolean, _
    ByVal dFrom As Date, ByVal dTo As Date) As String
        If bIsAllDay Then
            'do not show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                Return sTitle & vbCrLf & sDescription & vbCrLf & _
                    FormatDateTime(dFrom, DateFormat.LongDate)
            Else
                Return sTitle & vbCrLf & sDescription & vbCrLf & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " - " & vbCrLf & _
                    FormatDateTime(dTo, DateFormat.LongDate)
            End If
        Else
            'show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                Return sTitle & vbCrLf & sDescription & vbCrLf & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & vbCrLf & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            Else
                Return sTitle & vbCrLf & sDescription & vbCrLf & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " " & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & vbCrLf & _
                    FormatDateTime(dTo, DateFormat.LongDate) & " " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            End If
        End If
    End Function
</script>

<asp:Panel ID="panelEventsPublic" runat="server" >
<table cellpadding="0" cellspacing="0" class="boxEvents">
<tr>
<td class="boxHeaderEvents">
    <asp:Label ID="lblEvents" meta:resourcekey="lblEvents" runat="server" Text="Events" Visible=false Font-Bold=true></asp:Label>
</td>
</tr>
<tr>
<td class="boxListEvents">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    </asp:SqlDataSource>
    <asp:GridView ID="gridviewEvents" runat="server" Width="100%" SkinID="gridEventsBox"
        AutoGenerateColumns=false
        ShowHeader="false" 
        GridLines="None" 
        CellPadding="5" 
        AllowPaging="true" 
        PagerSettings-Visible="false">
        <Columns>
            <asp:TemplateField >
            <ItemTemplate>
                <div style="cursor:default" title="<%#ShowTooltip(Eval("title", ""),Eval("description", ""),Eval("is_allday", ""),Eval("from_date", ""),Eval("to_date", ""))%>">
                <%#ShowTitle(Eval("title", ""))%>
                <%#Eval("description", "")%><br />
                <%#FormatDateTime(Eval("from_date", ""), DateFormat.LongDate)%><br />
                <%#ShowMore(Eval("page","")) %>
                </div>
            </ItemTemplate>  
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</td>
</tr>
<tr id="idMoreEvents" runat="server" visible="false">
<td class="boxFooterEvents">
    <asp:HyperLink ID="lnkMoreEvents" meta:resourcekey="lnkMoreEvents" runat="server">More Events</asp:HyperLink>
</td>
</tr>
</table>
</asp:Panel>
