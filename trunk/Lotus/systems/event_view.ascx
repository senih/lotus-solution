<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat=server>
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.SelectCommand = "SELECT * FROM events WHERE (repeat <> 0 AND type = 2)" & _
                    " and to_date>getdate() ORDER BY from_date desc"
        gridviewEvents.DataBind()
    End Sub

    Function ShowEvent(ByVal sTitle As String, _
    ByVal sDescription As String, _
    ByVal bIsAllDay As Boolean, _
    ByVal dFrom As Date, ByVal dTo As Date) As String

        Dim sReturn As String = ""

        If bIsAllDay Then
            'do not show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                sReturn = "<b>" & sTitle & "</b>" & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate)
            Else
                sReturn = "<b>" & sTitle & "</b>" & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " - " & _
                    FormatDateTime(dTo, DateFormat.LongDate)
            End If
        Else
            'show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                sReturn = "<b>" & sTitle & "</b>" & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            Else
                sReturn = "<b>" & sTitle & "</b>" & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " " & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & _
                    FormatDateTime(dTo, DateFormat.LongDate) & " " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            End If
        End If
        Return sReturn
    End Function

    Function ShowMore(ByVal link As String) As String
        If Not (link = "") Then
            Return ("&nbsp;&nbsp;<a href=""" & link & """>" & GetLocalResourceObject("More") & "</a>")
        Else
            Return ("")
        End If
    End Function

    Protected Sub gridviewEvents_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gridviewEvents.PageIndexChanging
        gridviewEvents.PageIndex = e.NewPageIndex
    End Sub
</script>


<asp:Panel ID="panelUpcomingEvents" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    </asp:SqlDataSource>
    <asp:GridView ID="gridviewEvents" runat="server" DataSourceID="SqlDataSource1" PageSize="10" AutoGenerateColumns=false ShowHeader="false" 
        GridLines="None" CellPadding="3" AllowPaging="true" PagerSettings-Visible="true">
        <Columns>
        <asp:TemplateField >
        <ItemTemplate>
            <div style="margin:5px"></div>
            <%#ShowEvent(Eval("title", ""), Eval("description", ""), Eval("is_allday", ""), Eval("from_date", ""), Eval("to_date", ""))%>
            <%#ShowMore(Eval("page","")) %><div style="margin:5px"></div>
        </ItemTemplate>  
        </asp:TemplateField>
        </Columns>
   </asp:GridView>
</asp:Panel>
