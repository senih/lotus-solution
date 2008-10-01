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
    
    Private bIsEntry As Boolean = False
    Public Property IsEntry() As Boolean
        Get
            Return bIsEntry
        End Get
        Set(ByVal value As Boolean)
            bIsEntry = value
        End Set
    End Property
    
    Protected Sub calBlog_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If bIsEntry Then
            Select Case (calBlog.SelectedDates.Count)
                Case 0 'None        
                Case 1 'Day
                    Response.Redirect(Me.ParentFileName & "?d=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month & "-" & calBlog.SelectedDate.Day)
                Case 7 'Week
                    Response.Redirect(Me.ParentFileName & "?w=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month & "-" & calBlog.SelectedDate.Day)
                Case Else 'Month
                    Response.Redirect(Me.ParentFileName & "?d=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month)
            End Select
        Else
            Select Case (calBlog.SelectedDates.Count)
                Case 0 'None        
                Case 1 'Day
                    Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month & "-" & calBlog.SelectedDate.Day)
                Case 7 'Week
                    Response.Redirect(HttpContext.Current.Items("_page") & "?w=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month & "-" & calBlog.SelectedDate.Day)
                Case Else 'Month
                    Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & calBlog.SelectedDate.Year & "-" & calBlog.SelectedDate.Month)
            End Select
        End If

    End Sub
    
    Protected Sub calBlog_VisibleMonthChanged(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MonthChangedEventArgs)
        nYear = calBlog.VisibleDate.Year
        nMonth = calBlog.VisibleDate.Month
        Dim oContent As Content = New Content
        If bIsEntry Then
            dt = oContent.GetPagesWithin(Me.ParentID, 0, 4, Nothing, False, nYear, nMonth)
        Else
            dt = oContent.GetPagesWithin(Me.PageID, 0, 4, Nothing, False, nYear, nMonth)
        End If
       
        oContent = Nothing
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsPostBack Then
            calBlog.SelectedDates.Clear()
        End If
        
        Dim oContent As Content = New Content

        '~~~ Mark Selection ~~~
        If Not IsNothing(Request.QueryString("d")) Then
            nYear = Request.QueryString("d").Split("-")(0)
            nMonth = Request.QueryString("d").Split("-")(1)
            
            If Request.QueryString("d").Split("-").Length = 3 Then
                'Date
                nDay = Request.QueryString("d").Split("-")(2)
                calBlog.SelectedDate = New Date(nYear, nMonth, nDay)
            Else
                'Month
                calBlog.SelectedDates.Clear()
            End If
        ElseIf Not IsNothing(Request.QueryString("w")) Then
            'Week
            nYear = Request.QueryString("w").Split("-")(0)
            nMonth = Request.QueryString("w").Split("-")(1)
            nDay = Request.QueryString("w").Split("-")(2)
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(1)))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(2)))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(3)))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(4)))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(5)))
            calBlog.SelectedDates.Add(New Date(nYear, nMonth, nDay).Add(System.TimeSpan.FromDays(6)))
        Else
            'No Selection
            nYear = Now.Year
            nMonth = Now.Month
            calBlog.SelectedDates.Clear()
        End If
        
        '~~~ Get data (to specify selectable dates) ~~~        
        calBlog.VisibleDate = New Date(nYear, nMonth, 1)
        If bIsEntry Then
            dt = oContent.GetPagesWithin(Me.ParentID, 0, 4, _
                Nothing, False, nYear, nMonth) 'Get all posts on the visible month.
        Else
            dt = oContent.GetPagesWithin(Me.PageID, 0, 4, _
                Nothing, False, nYear, nMonth) 'Get all posts on the visible month.       
        End If

        oContent = Nothing
        
        'To fire SelectionChanged event, walaupun selection sama. 
        calBlog.SelectedDates.Add(New Date(2000, 1, 1))
    End Sub

    Protected Sub calBlog_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs)
        e.Day.IsSelectable = False
        Dim dr As DataRow
        Dim dtDay As DateTime
        For Each dr In dt.Rows
            dtDay = (CType(dr(5), DateTime))
            If (e.Day.Date = dtDay.Date) And (e.Day.Date <> calBlog.SelectedDate) Then
                e.Day.IsSelectable = True
            End If
        Next
    End Sub
</script>

<asp:Calendar ID="calBlog" runat="server"
    SelectionMode="DayWeekMonth" 
    OnSelectionChanged="calBlog_SelectionChanged" 
    OnDayRender="calBlog_DayRender" 
    OnVisibleMonthChanged="calBlog_VisibleMonthChanged">
</asp:Calendar>



