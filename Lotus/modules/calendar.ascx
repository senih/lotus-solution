<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Private nYear As Integer
    Private nMonth As Integer
    Private nDay As Integer
    Private dt As DataTable
    Private sFileName As String
    
    Protected Sub calNews_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Select Case (calNews.SelectedDates.Count)
            Case 0 'None        
            Case 1 'Day
                Response.Redirect(sFileName & "?d=" & calNews.SelectedDate.Year & "-" & calNews.SelectedDate.Month & "-" & calNews.SelectedDate.Day)
            Case 7 'Week
                Response.Redirect(sFileName & "?w=" & calNews.SelectedDate.Year & "-" & calNews.SelectedDate.Month & "-" & calNews.SelectedDate.Day)
            Case Else 'Month
                Response.Redirect(sFileName & "?d=" & calNews.SelectedDate.Year & "-" & calNews.SelectedDate.Month)
        End Select
    End Sub
    
    Protected Sub calNews_VisibleMonthChanged(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MonthChangedEventArgs)
        nYear = calNews.VisibleDate.Year
        nMonth = calNews.VisibleDate.Month
        Dim oContent As Content = New Content
        dt = oContent.GetPagesWithin(Me.ModuleData, 0, 4, Nothing, False, nYear, nMonth)
        oContent = Nothing
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        If Me.PageID = Me.ModuleData Then
            panelCalendar.Visible = False
        End If
        
        Dim oContent As Content = New Content

        nYear = Now.Year
        nMonth = Now.Month
        calNews.SelectedDates.Clear()
        
        '~~~ Get data (to specify selectable dates) ~~~        
        calNews.VisibleDate = New Date(nYear, nMonth, 1)
        dt = oContent.GetPagesWithin(Me.ModuleData, 0, 4, _
            Nothing, False, nYear, nMonth) 'Get all posts on the visible month.

        Dim dt2 As DataTable
        dt2 = oContent.GetPage(Me.ModuleData, True)
        If dt2.Rows.Count > 0 Then
            sFileName = dt2.Rows(0)(3).ToString
            litTitle.Text = dt2.Rows(0)(1).ToString
        Else
            panelCalendar.Visible = False
        End If

        
        oContent = Nothing
        
        '~~~ Rss ~~~
        lnkRss.NavigateUrl = "~/systems/rss.aspx?pg=" & Me.ModuleData & "&c=" & Me.Culture 'Link for Rss
    End Sub

    Protected Sub calNews_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs)
        e.Day.IsSelectable = False
        Dim dr As DataRow
        Dim dtDay As DateTime
        For Each dr In dt.Rows
            dtDay = (CType(dr(5), DateTime))
            If (e.Day.Date = dtDay.Date) And (e.Day.Date <> calNews.SelectedDate) Then
                e.Day.IsSelectable = True
            End If
        Next
    End Sub
</script>

<asp:Panel ID="panelCalendar" runat="server">

<table cellpadding="0" cellspacing="0" class="boxNewsList">
<tr>
    <td class="boxHeaderNewsList">
        <asp:Literal ID="litTitle" runat="server"></asp:Literal>
    </td>
</tr>
<tr>
    <td class="boxContentNewsList">
        <asp:Calendar ID="calNews" runat="server"
            SelectionMode="DayWeekMonth" 
            OnSelectionChanged="calNews_SelectionChanged" 
            OnDayRender="calNews_DayRender" 
            OnVisibleMonthChanged="calNews_VisibleMonthChanged">
        </asp:Calendar>


    </td>
</tr>
</table>
        <div style="padding-left:5px">  
            <asp:HyperLink ID="lnkRss" runat="server" Target="_blank" text="">
                <asp:Image ID="Image1" runat="server" AlternateText="Rss" ImageUrl="~/systems/images/rss.gif" />
            </asp:HyperLink>
            <div style="margin:7px"></div>
        </div>
</asp:Panel>


