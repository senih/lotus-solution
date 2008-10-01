<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private dt As DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Me.IsAdministrator Or Me.IsAuthor Then
            panelAuthor.Visible = True
            btnEditEvent.Visible = True
            btnDelEvent.Visible = True
            btnEditEvent.Style.Add("display", "none")
            btnDelEvent.Style.Add("display", "none")
        End If
        
        If Not IsPostBack Then
            If Not IsNothing(Request.QueryString("d")) Then
                Dim qs As String = Request.QueryString("d")
                ShowDayView(qs.Split("-")(0), qs.Split("-")(1), qs.Split("-")(2))
            ElseIf Not IsNothing(Request.QueryString("m")) Then
                Dim qs As String = Request.QueryString("m")
                ShowMonthView(qs.Split("-")(0), qs.Split("-")(1))
            Else
                ShowMonthView(Now.Year, Now.Month)
            End If
        End If
    End Sub
    
    Protected Function FormatTime(ByVal dTime As DateTime) As String
        Dim sTime As String = ""
        Dim sMinute As String = dTime.Minute
        If sMinute.Length = 1 Then sMinute = "0" & sMinute
        If dTime.Hour = 0 Then
            sTime = "12:" & sMinute & " AM"
        ElseIf dTime.Hour = 23 And dTime.Minute = 59 Then
            sTime = "12:00 AM"
        ElseIf dTime.Hour < 12 Then
            sTime = dTime.Hour & ":" & sMinute & " AM"
        ElseIf dTime.Hour = 12 Then
            sTime = dTime.Hour & ":" & sMinute & " PM"
        Else
            sTime = dTime.Hour - 12 & ":" & sMinute & " PM"
        End If
        Return sTime
    End Function

    Protected Sub Calendar1_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs)
        If IsNothing(dt) Then Exit Sub
        
        If Me.IsAdministrator Or Me.IsAuthor Then
            
        Else
            e.Day.IsSelectable = False
        End If
                
        Dim sCell As String = ""
        Dim sId As String
        Dim sSubject As String
        Dim sTime As String
        Dim dr As DataRow
        Dim dtDay As DateTime
        For Each dr In dt.Rows
            dtDay = (CType(dr(2), DateTime))
            If (e.Day.Date = dtDay.Date) Then
                If e.Day.Date <> Calendar1.SelectedDate Then
                    e.Day.IsSelectable = True
                End If
                If CBool(dr(5)) Then
                    sTime = "(All Day)"
                Else
                    sTime = FormatTime(dr(3)) & " - " & FormatTime(dr(4))
                End If
                
                sId = "idCal" & dtDay.Month & "_" & dtDay.Day & "_" & dr(0)
                If dr(9).ToString = "" Then
                    sSubject = "<span style=""font-size:9px;"">" & Server.HtmlEncode(dr(1)) & "</span>"
                Else
                    sSubject = "<a style=""font-size:9px;"" href=""" & dr(9).ToString & """>" & Server.HtmlEncode(dr(1)) & "</a>"
                End If
                
                sCell = "<div onmouseover=""document.getElementById('" & sId & "').style.display='block'"" onmouseout=""document.getElementById('" & sId & "').style.display='none'"" style=""cursor:default;padding:7px;font-size:9px;margin:4px;border:#D3C7E2 1px solid;border-right:#A58CC4 1px solid;border-bottom:#A58CC4 1px solid;background:url('" & Me.AppPath & "modules/images/bg_event.gif') #D9CFE7;"">" + sSubject + "</div>"
                sCell += "<div id=""" & sId & """ style=""display:none;font-size:9px;padding:8px;border:#777777 1px dotted;background:#f7f8f9;position:absolute;""><b>" & Server.HtmlEncode(dr(1)) & "</b><div>" & sTime & "</div><div>" & dr(7) & "</div><div>" & dr(8) & "</div></div>"
                e.Cell.Controls.Add(New LiteralControl(sCell))
            End If
        Next
    End Sub

    Protected Sub Calendar1_VisibleMonthChanged(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MonthChangedEventArgs)
        'Alternatif 1:
        'ShowMonthView(Calendar1.VisibleDate.Year, Calendar1.VisibleDate.Month)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & Calendar1.VisibleDate.Year & "-" & Calendar1.VisibleDate.Month)
    End Sub

    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'Alternatif 1:
        'ShowDayView(Calendar1.SelectedDate.Year, Calendar1.SelectedDate.Month, Calendar1.SelectedDate.Day)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & Calendar1.SelectedDate.Year & "-" & Calendar1.SelectedDate.Month & "-" & Calendar1.SelectedDate.Day)
    End Sub

    Protected Sub lnkNewEvent_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Show hide panels
        panelCalendar.Visible = False
        panelDayView.Visible = False
        panelEvent.Visible = True
        panelRecurrence.Visible = False
        panelBackToCalendar.Visible = True
        
        'Set defaults
        Dim nDefaultYear As Integer = hidDYear.Value
        Dim nDefaultMonth As Integer = hidDMonth.Value
        Dim nDefaultDay As Integer = hidDDay.Value
        txtStartDate.Text = nDefaultYear & "/" & nDefaultMonth & "/" & nDefaultDay
        txtEndDate.Text = nDefaultYear & "/" & nDefaultMonth & "/" & nDefaultDay
        
        txtSubject.Text = ""
        txtLocation.Text = ""
        chkAllDay.Checked = False
        txtNotes.Text = ""
        txtURL.Text = ""
        hidID.Value = ""
    End Sub

    Protected Sub lnkNewRecurrence_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Show hide panels
        panelCalendar.Visible = False
        panelDayView.Visible = False
        panelEvent.Visible = False
        panelRecurrence.Visible = True
        panelBackToCalendar.Visible = True

        'Form's scripts
        panelDaily.Style.Add("display", "block")
        panelWeekly.Style.Add("display", "none")
        panelMonthly.Style.Add("display", "none")
        panelYearly.Style.Add("display", "none")
        rdoRecTypeDaily.Attributes.Add("onclick", "if(this.checked){showHideRec('D','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
        rdoRecTypeWeekly.Attributes.Add("onclick", "if(this.checked){showHideRec('W','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
        rdoRecTypeMonthly.Attributes.Add("onclick", "if(this.checked){showHideRec('M','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
        rdoRecTypeYearly.Attributes.Add("onclick", "if(this.checked){showHideRec('Y','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
    
        'Set defaults
        Dim nDefaultYear As Integer = hidDYear.Value
        Dim nDefaultMonth As Integer = hidDMonth.Value
        Dim nDefaultDay As Integer = hidDDay.Value
        txtRecStart.Text = nDefaultYear & "/" & nDefaultMonth & "/" & nDefaultDay
        txtRecEnd.Text = nDefaultYear & "/" & nDefaultMonth & "/" & Date.DaysInMonth(nDefaultYear, nDefaultMonth)
        
        txtRecSubject.Text = ""
        txtRecLocation.Text = ""

        rdoRecTypeDaily.Checked = True
        rdoRecTypeWeekly.Checked = False
        rdoRecTypeMonthly.Checked = False
        rdoRecTypeYearly.Checked = False

        rdoDOpt1.Checked = True
        rdoDOpt2.Checked = False
        txtDOpt1_Every.Text = 1

        txtW_Every.Text = 1
        chkW_Sunday.Checked = False
        chkW_Monday.Checked = True
        chkW_Tuesday.Checked = False
        chkW_Wednesday.Checked = False
        chkW_Thursday.Checked = False
        chkW_Friday.Checked = False
        chkW_Saturday.Checked = False
       
        rdoMOpt1.Checked = True
        rdoMOpt2.Checked = False
        txtMOpt1_Day.Text = 1
        txtMOpt1_Every.Text = 1
        ddlMOpt2_Nth.SelectedValue = 1
        ddlMOpt2_Day.SelectedValue = 0
        txtMOpt2_Every.Text = 1
        
        rdoYOpt1.Checked = True
        rdoYOpt2.Checked = False
        ddlYOpt1_Month.SelectedValue = 1
        txtYOpt1_Day.Text = 8
        ddlYOpt2_Nth.SelectedValue = 1
        ddlYOpt2_Day.SelectedValue = 0
        ddlYOpt2_Month.SelectedValue = 1

        rdoForever.Checked = True
        rdoEndAfter.Checked = False
        rdoUntil.Checked = False
        txtRecOccurs.Text = 10
        txtRecNotes.Text = ""
        txtRecURL.Text = ""
        hidRecID.Value = ""
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sSQL As String
        If hidID.Value = "" Then
            'INSERT
            sSQL = "INSERT INTO calendar (subject,location,start_time,end_time,all_day,is_rec,notes,url,page_id) VALUES (@subject,@location,@start_time,@end_time,@all_day,@is_rec,@notes,@url,@page_id)"
        Else
            'UPDATE
            sSQL = "UPDATE calendar SET subject=@subject, location=@location, start_time=@start_time, end_time=@end_time, all_day=@all_day, is_rec=@is_rec, notes=@notes, url=@url WHERE id=@id"
        End If

        Dim oCmd As SqlCommand
        oCmd = New SqlCommand(sSQL)
        
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = txtSubject.Text
        oCmd.Parameters.Add("@location", SqlDbType.NText).Value = txtLocation.Text
        oCmd.Parameters.Add("@start_time", SqlDbType.DateTime).Value = New Date(txtStartDate.Text.Split("/")(0), txtStartDate.Text.Split("/")(1), txtStartDate.Text.Split("/")(2), txtStartTime.Text.Split(":")(0), txtStartTime.Text.Split(":")(1), 0)
        oCmd.Parameters.Add("@end_time", SqlDbType.DateTime).Value = New Date(txtEndDate.Text.Split("/")(0), txtEndDate.Text.Split("/")(1), txtEndDate.Text.Split("/")(2), txtEndTime.Text.Split(":")(0), txtEndTime.Text.Split(":")(1), 0)
        oCmd.Parameters.Add("@all_day", SqlDbType.Bit).Value = chkAllDay.Checked
        oCmd.Parameters.Add("@is_rec", SqlDbType.Bit).Value = False
        oCmd.Parameters.Add("@notes", SqlDbType.NText).Value = txtNotes.Text
        oCmd.Parameters.Add("@url", SqlDbType.NText).Value = txtURL.Text
        If Not hidID.Value = "" Then
            oCmd.Parameters.Add("@id", SqlDbType.Int).Value = hidID.Value
        Else
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        End If
        
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        
        'Back
        If hidLastView.Value = "D" Then
            'Alternatif 1:
            'ShowDayView(txtStartDate.Text.Split("/")(0), txtStartDate.Text.Split("/")(1), txtStartDate.Text.Split("/")(2))
        
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & txtStartDate.Text.Split("/")(0) & "-" & txtStartDate.Text.Split("/")(1) & "-" & txtStartDate.Text.Split("/")(2))
        Else
            'Alternatif 1:
            'ShowMonthView(txtStartDate.Text.Split("/")(0), txtStartDate.Text.Split("/")(1))
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & txtStartDate.Text.Split("/")(0) & "-" & txtStartDate.Text.Split("/")(1))
        End If
    End Sub

    Protected Sub btnRecSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sSQL As String
        If hidRecID.Value = "" Then
            'INSERT
            sSQL = "INSERT INTO calendar (subject,location,start_time,end_time,all_day,is_rec,rec_end_type,rec_start,rec_end,rec_occurs,rec_type,rec_every,rec_days_in_week,nth_day_in_month,nth_day,weekday,month,notes,url,page_id) VALUES (@subject,@location,@start_time,@end_time,@all_day,@is_rec,@rec_end_type,@rec_start,@rec_end,@rec_occurs,@rec_type,@rec_every,@rec_days_in_week,@nth_day_in_month,@nth_day,@weekday,@month,@notes,@url,@page_id)"
        Else
            'UPDATE
            sSQL = "UPDATE calendar SET subject=@subject,location=@location,start_time=@start_time,end_time=@end_time,all_day=@all_day,is_rec=@is_rec,rec_end_type=@rec_end_type,rec_start=@rec_start,rec_end=@rec_end,rec_occurs=@rec_occurs,rec_type=@rec_type,rec_every=@rec_every,rec_days_in_week=@rec_days_in_week,nth_day_in_month=@nth_day_in_month,nth_day=@nth_day,weekday=@weekday,month=@month,notes=@notes,url=@url WHERE id=@id"
        End If

        Dim oCmd As SqlCommand
        oCmd = New SqlCommand(sSQL)
        
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = txtRecSubject.Text
        oCmd.Parameters.Add("@location", SqlDbType.NText).Value = txtRecLocation.Text
        oCmd.Parameters.Add("@all_day", SqlDbType.Bit).Value = False
        oCmd.Parameters.Add("@notes", SqlDbType.NText).Value = txtRecNotes.Text
        oCmd.Parameters.Add("@url", SqlDbType.NText).Value = txtRecURL.Text
        oCmd.Parameters.Add("@is_rec", SqlDbType.Bit).Value = True
        oCmd.Parameters.Add("@start_time", SqlDbType.DateTime).Value = New Date(Now.Year, Now.Month, Now.Day, txtRecStartTime.Text.Split(":")(0), txtRecStartTime.Text.Split(":")(1), 0)
        oCmd.Parameters.Add("@end_time", SqlDbType.DateTime).Value = New Date(Now.Year, Now.Month, Now.Day, txtRecEndTime.Text.Split(":")(0), txtRecEndTime.Text.Split(":")(1), 0)
        If Not hidRecID.Value = "" Then
            oCmd.Parameters.Add("@id", SqlDbType.Int).Value = hidRecID.Value
        Else
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        End If
        
        'Recurrence
        If rdoRecTypeDaily.Checked Then
            oCmd.Parameters.Add("@rec_type", SqlDbType.NVarChar, 1).Value = "D"
            If rdoDOpt2.Checked Then
                oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = 0
            Else
                oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = txtDOpt1_Every.Text
            End If
            oCmd.Parameters.Add("@rec_days_in_week", SqlDbType.NVarChar, 50).Value = "" 'Not Used
            oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = 0 'Not Used
            oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = 1 'Not Used
            oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = 0 'Not Used
            oCmd.Parameters.Add("@month", SqlDbType.Int).Value = 1 'Not Used
        ElseIf rdoRecTypeWeekly.Checked Then
            oCmd.Parameters.Add("@rec_type", SqlDbType.NVarChar, 1).Value = "W"
            oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = txtW_Every.Text
            Dim sW As String = ""
            If chkW_Sunday.Checked Then
                sW += "," & 0
            End If
            If chkW_Monday.Checked Then
                sW += "," & 1
            End If
            If chkW_Tuesday.Checked Then
                sW += "," & 2
            End If
            If chkW_Wednesday.Checked Then
                sW += "," & 3
            End If
            If chkW_Thursday.Checked Then
                sW += "," & 4
            End If
            If chkW_Friday.Checked Then
                sW += "," & 5
            End If
            If chkW_Saturday.Checked Then
                sW += "," & 6
            End If
            
            oCmd.Parameters.Add("@rec_days_in_week", SqlDbType.NVarChar, 50).Value = sW.Substring(1)
            oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = 0 'Not Used
            oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = 1 'Not Used
            oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = 0 'Not Used
            oCmd.Parameters.Add("@month", SqlDbType.Int).Value = 1 'Not Used
        ElseIf rdoRecTypeMonthly.Checked Then
            oCmd.Parameters.Add("@rec_type", SqlDbType.NVarChar, 1).Value = "M"
            If rdoMOpt1.Checked Then
                oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = txtMOpt1_Every.Text
                oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = txtMOpt1_Day.Text
                oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = 1 'Not Used
                oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = 0 'Not Used
            Else
                oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = txtMOpt2_Every.Text
                oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = 0
                oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = ddlMOpt2_Nth.SelectedValue
                oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = ddlMOpt2_Day.SelectedValue
            End If
            oCmd.Parameters.Add("@rec_days_in_week", SqlDbType.NVarChar, 50).Value = "" 'Not Used
            oCmd.Parameters.Add("@month", SqlDbType.Int).Value = 1 'Not Used
        Else
            oCmd.Parameters.Add("@rec_type", SqlDbType.NVarChar, 1).Value = "Y"
            oCmd.Parameters.Add("@rec_every", SqlDbType.Int).Value = 0 'Not Used
            oCmd.Parameters.Add("@rec_days_in_week", SqlDbType.NVarChar, 50).Value = "" 'Not Used
            If rdoYOpt1.Checked Then
                oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = txtYOpt1_Day.Text
                oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = 1 'Not Used
                oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = 0 'Not Used
                oCmd.Parameters.Add("@month", SqlDbType.Int).Value = ddlYOpt1_Month.SelectedValue
            Else
                oCmd.Parameters.Add("@nth_day_in_month", SqlDbType.Int).Value = 0
                oCmd.Parameters.Add("@nth_day", SqlDbType.Int).Value = ddlYOpt2_Nth.SelectedValue
                oCmd.Parameters.Add("@weekday", SqlDbType.Int).Value = ddlYOpt2_Day.SelectedValue
                oCmd.Parameters.Add("@month", SqlDbType.Int).Value = ddlYOpt2_Month.SelectedValue
            End If
        End If
            
        'Range
        oCmd.Parameters.Add("@rec_start", SqlDbType.DateTime).Value = New Date(txtRecStart.Text.Split("/")(0), txtRecStart.Text.Split("/")(1), txtRecStart.Text.Split("/")(2))
        If rdoForever.Checked Then
            oCmd.Parameters.Add("@rec_end_type", SqlDbType.Int).Value = 0
            oCmd.Parameters.Add("@rec_occurs", SqlDbType.Int).Value = 10 'Not Used
            oCmd.Parameters.Add("@rec_end", SqlDbType.DateTime).Value = Now 'Not Used
        ElseIf rdoEndAfter.Checked Then
            oCmd.Parameters.Add("@rec_end_type", SqlDbType.Int).Value = 1
            oCmd.Parameters.Add("@rec_occurs", SqlDbType.Int).Value = txtRecOccurs.Text
            oCmd.Parameters.Add("@rec_end", SqlDbType.DateTime).Value = Now 'Not Used
        Else
            oCmd.Parameters.Add("@rec_end_type", SqlDbType.Int).Value = 2
            oCmd.Parameters.Add("@rec_occurs", SqlDbType.Int).Value = 10 'Not Used
            oCmd.Parameters.Add("@rec_end", SqlDbType.DateTime).Value = New Date(txtRecEnd.Text.Split("/")(0), txtRecEnd.Text.Split("/")(1), txtRecEnd.Text.Split("/")(2))
        End If

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        
        'Back
        If hidLastView.Value = "D" Then
            'Alternatif 1:
            'ShowDayView(txtRecStart.Text.Split("/")(0), txtRecStart.Text.Split("/")(1), txtRecStart.Text.Split("/")(2))
        
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & hidDYear.Value & "-" & hidDMonth.Value & "-" & hidDDay.Value)
        Else
            'Alternatif 1:
            'ShowMonthView(txtRecStart.Text.Split("/")(0), txtRecStart.Text.Split("/")(1))
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & hidDYear.Value & "-" & hidDMonth.Value)
        End If
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If hidLastView.Value = "D" Then
            'Alternatif 1:
            'ShowDayView(hidDYear.Value, hidDMonth.Value, hidDDay.Value)
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & hidDYear.Value & "-" & hidDMonth.Value & "-" & hidDDay.Value)
        Else
            'Alternatif 1:
            'ShowMonthView(hidDYear.Value, hidDMonth.Value)
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & hidDYear.Value & "-" & hidDMonth.Value)
        End If
    End Sub

    Protected Sub btnRecCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If hidLastView.Value = "D" Then
            'Alternatif 1:
            'ShowDayView(hidDYear.Value, hidDMonth.Value, hidDDay.Value)
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & hidDYear.Value & "-" & hidDMonth.Value & "-" & hidDDay.Value)
        Else
            'Alternatif 1:
            'ShowMonthView(hidDYear.Value, hidDMonth.Value)
            
            'Alternatif 2:
            Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & hidDYear.Value & "-" & hidDMonth.Value)
        End If
    End Sub
    
    Protected Sub lnkBackToCalendar_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Alternatif 1:
        'ShowMonthView(hidDYear.Value, hidDMonth.Value)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?m=" & hidDYear.Value & "-" & hidDMonth.Value)
    End Sub
    
    Protected Sub ShowDayView(ByVal nYear As Integer, ByVal nMonth As Integer, ByVal nDay As Integer)
        'Show hide panels
        panelCalendar.Visible = False
        panelDayView.Visible = True
        panelEvent.Visible = False
        panelRecurrence.Visible = False
        panelBackToCalendar.Visible = True
                 
        'Render
        Dim oCalendar As calendar = New calendar()
        Dim dView As Date = New Date(nYear, nMonth, nDay)
        dt = oCalendar.GetDates(dView, New Date(dView.Year, dView.Month, dView.Day, 23, 59, 59), Me.PageID)
        lblDate.Text = FormatDateTime(dView, DateFormat.LongDate)
        If Me.IsAdministrator Or Me.IsAuthor Then
            lblDayView.Text = oCalendar.RenderDayView(dt, dView, True, GetLocalResourceObject("Edit"), GetLocalResourceObject("Delete"))
        Else
            lblDayView.Text = oCalendar.RenderDayView(dt, dView, False, "", "")
        End If
        oCalendar = Nothing
        
        'Store viewed date
        hidDYear.Value = nYear
        hidDMonth.Value = nMonth
        hidDDay.Value = nDay
        hidLastView.Value = "D"
    End Sub
    
    Protected Sub ShowMonthView(ByVal nYear As Integer, ByVal nMonth As Integer)
        panelBackToCalendar.Visible = False
        Calendar1.SelectedDates.Clear()
        
        lnkRss.NavigateUrl = "events_rss.aspx?pg=" & Me.PageID
        imgRss.ImageUrl = "~/systems/images/rss.gif"
        If Not Me.ChannelPermission = 1 Then
            imgRss.Visible = False
        End If
        
        'Show hide panels
        panelCalendar.Visible = True
        panelDayView.Visible = False
        panelEvent.Visible = False
        panelRecurrence.Visible = False
        
        Dim oCalendar As calendar = New calendar()
        Calendar1.VisibleDate = New Date(nYear, nMonth, 1)
        dt = oCalendar.GetDates(New Date(nYear, nMonth, 1).Subtract(System.TimeSpan.FromDays(8)), New Date(nYear, nMonth, Date.DaysInMonth(nYear, nMonth)).Add(System.TimeSpan.FromDays(8)), Me.PageID)
        oCalendar = Nothing
        
        'Store viewed date
        hidDYear.Value = nYear
        hidDMonth.Value = nMonth
        hidDDay.Value = 1
        hidLastView.Value = "M"
    End Sub
    
    Protected Sub btnEditEvent_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand("SELECT * FROM calendar WHERE id=@id")
        oCmd.Connection = oConn
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = hidEventID.Value
        oDataReader = oCmd.ExecuteReader
        While oDataReader.Read

            
            If CBool(oDataReader("is_rec")) Then
                panelEvent.Visible = False
                panelRecurrence.Visible = True
                
                hidRecID.Value = hidEventID.Value
                txtRecSubject.Text = oDataReader("subject").ToString
                txtRecLocation.Text = oDataReader("location").ToString
                txtRecNotes.Text = oDataReader("notes").ToString
                txtRecURL.Text = oDataReader("url").ToString
                
                Dim dStart As DateTime = CDate(oDataReader("start_time"))
                Dim dEnd As DateTime = CDate(oDataReader("end_time"))
                Dim sStart As String
                If dStart.Minute.ToString.Length = 1 Then
                    sStart = "0" & dStart.Minute
                Else
                    sStart = dStart.Minute
                End If
                Dim sEnd As String
                If dEnd.Minute.ToString.Length = 1 Then
                    sEnd = "0" & dEnd.Minute
                Else
                    sEnd = dEnd.Minute
                End If
                txtRecStartTime.Text = dStart.Hour & ":" & sStart
                txtRecEndTime.Text = dEnd.Hour & ":" & sEnd
                
                'Recurrence
                Select Case oDataReader("rec_type").ToString
                    Case "D"
                        rdoRecTypeDaily.Checked = True
                        panelDaily.Style.Add("display", "block")
                        panelWeekly.Style.Add("display", "none")
                        panelMonthly.Style.Add("display", "none")
                        panelYearly.Style.Add("display", "none")
                        
                        If oDataReader("rec_every") = 0 Then
                            rdoDOpt2.Checked = True
                            txtDOpt1_Every.Text = 1
                        Else
                            rdoDOpt1.Checked = True
                            txtDOpt1_Every.Text = CInt(oDataReader("rec_every"))
                        End If
                  
                    Case "W"
                        rdoRecTypeWeekly.Checked = True
                        panelDaily.Style.Add("display", "none")
                        panelWeekly.Style.Add("display", "block")
                        panelMonthly.Style.Add("display", "none")
                        panelYearly.Style.Add("display", "none")
                        
                        txtW_Every.Text = CInt(oDataReader("rec_every"))
                        Dim sW As String = oDataReader("rec_days_in_week").ToString()
                        For Each item As String In sW.Split(",")
                            Select Case item
                                Case 0
                                    chkW_Sunday.Checked = True
                                Case 1
                                    chkW_Monday.Checked = True
                                Case 2
                                    chkW_Tuesday.Checked = True
                                Case 3
                                    chkW_Wednesday.Checked = True
                                Case 4
                                    chkW_Thursday.Checked = True
                                Case 5
                                    chkW_Friday.Checked = True
                                Case 6
                                    chkW_Saturday.Checked = True
                            End Select
                        Next
                        
                    Case "M"
                        rdoRecTypeMonthly.Checked = True
                        panelDaily.Style.Add("display", "none")
                        panelWeekly.Style.Add("display", "none")
                        panelMonthly.Style.Add("display", "block")
                        panelYearly.Style.Add("display", "none")
                        
                        If CInt(oDataReader("nth_day_in_month")) = 0 Then
                            rdoMOpt2.Checked = True
                            txtMOpt2_Every.Text = CInt(oDataReader("rec_every"))
                            ddlMOpt2_Nth.SelectedValue = CInt(oDataReader("nth_day"))
                            ddlMOpt2_Day.SelectedValue = CInt(oDataReader("weekday"))
                        Else
                            rdoMOpt1.Checked = True
                            txtMOpt1_Every.Text = CInt(oDataReader("rec_every"))
                            txtMOpt1_Day.Text = CInt(oDataReader("nth_day_in_month"))
                        End If
                        
                    Case "Y"
                        rdoRecTypeYearly.Checked = True
                        panelDaily.Style.Add("display", "none")
                        panelWeekly.Style.Add("display", "none")
                        panelMonthly.Style.Add("display", "none")
                        panelYearly.Style.Add("display", "block")
                        
                        If CInt(oDataReader("nth_day_in_month")) = 0 Then
                            rdoYOpt2.Checked = True
                            ddlYOpt2_Nth.SelectedValue = CInt(oDataReader("nth_day"))
                            ddlYOpt2_Day.SelectedValue = CInt(oDataReader("weekday"))
                            ddlYOpt2_Month.SelectedValue = CInt(oDataReader("month"))
                        Else
                            rdoYOpt1.Checked = True
                            txtMOpt1_Day.Text = CInt(oDataReader("nth_day_in_month"))
                        End If
                        
                End Select
                
                'Range
                Dim dRecStart As Date = CDate(oDataReader("rec_start"))
                txtRecStart.Text = dRecStart.Year & "/" & dRecStart.Month & "/" & dRecStart.Day
                Select Case CInt(oDataReader("rec_end_type"))
                    Case 0
                        rdoForever.Checked = True
                    Case 1
                        rdoEndAfter.Checked = True
                        txtRecOccurs.Text = CInt(oDataReader("rec_occurs"))
                    Case 2
                        rdoUntil.Checked = True
                        Dim dRecEnd As Date = CDate(oDataReader("rec_end"))
                        txtRecEnd.Text = dRecEnd.Year & "/" & dRecEnd.Month & "/" & dRecEnd.Day
                End Select
                
                rdoRecTypeDaily.Attributes.Add("onclick", "if(this.checked){showHideRec('D','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
                rdoRecTypeWeekly.Attributes.Add("onclick", "if(this.checked){showHideRec('W','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
                rdoRecTypeMonthly.Attributes.Add("onclick", "if(this.checked){showHideRec('M','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")
                rdoRecTypeYearly.Attributes.Add("onclick", "if(this.checked){showHideRec('Y','" & panelDaily.ClientID & "','" & panelWeekly.ClientID & "','" & panelMonthly.ClientID & "','" & panelYearly.ClientID & "')}")

            Else
                panelEvent.Visible = True
                panelRecurrence.Visible = False
                
                hidID.Value = hidEventID.Value
                txtSubject.Text = oDataReader("subject").ToString
                txtLocation.Text = oDataReader("location").ToString
                txtNotes.Text = oDataReader("notes").ToString
                txtURL.Text = oDataReader("url").ToString
                
                Dim dStart As DateTime = CDate(oDataReader("start_time"))
                Dim dEnd As DateTime = CDate(oDataReader("end_time"))
                txtStartDate.Text = dStart.Year & "/" & dStart.Month & "/" & dStart.Day
                txtEndDate.Text = dEnd.Year & "/" & dEnd.Month & "/" & dEnd.Day
                
                Dim sStart As String
                If dStart.Minute.ToString.Length = 1 Then
                    sStart = "0" & dStart.Minute
                Else
                    sStart = dStart.Minute
                End If
                Dim sEnd As String
                If dEnd.Minute.ToString.Length = 1 Then
                    sEnd = "0" & dEnd.Minute
                Else
                    sEnd = dEnd.Minute
                End If
                txtStartTime.Text = dStart.Hour & ":" & sStart
                txtEndTime.Text = dEnd.Hour & ":" & sEnd
            End If
        End While
        oDataReader.Close()
        oCmd = Nothing
        oConn.Close()
        
        panelCalendar.Visible = False
        panelDayView.Visible = False
    End Sub

    Protected Sub btnDelEvent_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand
        oConn.Open()
        oCmd = New SqlCommand("DELETE FROM calendar WHERE id=@id")
        oCmd.Connection = oConn
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = hidEventID.Value
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        
        'Alternatif 1:
        ShowDayView(hidDYear.Value, hidDMonth.Value, hidDDay.Value)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & hidDYear.Value & "-" & hidDMonth.Value & "-" & hidDDay.Value)
    End Sub

    Protected Sub lnkYesterday_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim d As Date = New Date(hidDYear.Value, hidDMonth.Value, hidDDay.Value)
        
        d = d.Subtract(System.TimeSpan.FromDays(1))
        
        'Alternatif 1:
        ShowDayView(d.Year, d.Month, d.Day)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & d.Year & "-" & d.Month & "-" & d.Day)
    End Sub

    Protected Sub lnkTomorrow_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim d As Date = New Date(hidDYear.Value, hidDMonth.Value, hidDDay.Value)
        
        d = d.Add(System.TimeSpan.FromDays(1))
        
        'Alternatif 1:
        ShowDayView(d.Year, d.Month, d.Day)
        
        'Alternatif 2:
        Response.Redirect(HttpContext.Current.Items("_page") & "?d=" & d.Year & "-" & d.Month & "-" & d.Day)
    End Sub
</script>

<script language="javascript">
function showHideRec(sVal,sDaily,sWeekly,sMonthly,sYearly)
    {
    var idDaily=document.getElementById(sDaily);
    var idWeekly=document.getElementById(sWeekly);
    var idMonthly=document.getElementById(sMonthly);
    var idYearly=document.getElementById(sYearly);
    
    switch(sVal)
        {
        case "D":
            idDaily.style.display='block';
            idWeekly.style.display='none';
            idMonthly.style.display='none';
            idYearly.style.display='none';
            break;
        case "W":
            idDaily.style.display='none';
            idWeekly.style.display='block';
            idMonthly.style.display='none';
            idYearly.style.display='none';
            break;
        case "M":
            idDaily.style.display='none';
            idWeekly.style.display='none';
            idMonthly.style.display='block';
            idYearly.style.display='none';
            break;
        case "Y":
            idDaily.style.display='none';
            idWeekly.style.display='none';
            idMonthly.style.display='none';
            idYearly.style.display='block';
            break;
        }
    }
function _editEvent(id)
    {
    document.getElementById('<%=hidEventID.ClientID%>').value=id;
    document.getElementById('<%=btnEditEvent.ClientID%>').click();      
    }
function _deleteEvent(id)
    {
    if(confirm('<%=GetLocalResourceObject("EventDeleteConfirm")%>'))
        {
        document.getElementById('<%=hidEventID.ClientID%>').value=id;
        document.getElementById('<%=btnDelEvent.ClientID%>').click();  
        }
    return false; 
    }
</script>

<div style="margin-bottom:15px">
<span ID="panelBackToCalendar" runat="server">
    <asp:LinkButton ID="lnkBackToCalendar" meta:resourcekey="lnkBackToCalendar" runat="server" OnClick="lnkBackToCalendar_Click">Back to Calendar</asp:LinkButton>&nbsp;
</span>

<span id="panelAuthor" runat="server" visible="false">
    <asp:LinkButton ID="lnkNewEvent" meta:resourcekey="lnkNewEvent" runat="server" OnClick="lnkNewEvent_Click">New Event</asp:LinkButton>&nbsp;
    <asp:LinkButton ID="lnkNewRecurrence" meta:resourcekey="lnkNewRecurrence" runat="server" OnClick="lnkNewRecurrence_Click">New Recurrence</asp:LinkButton>
</span>
</div>


<asp:HiddenField ID="hidDYear" runat="server" />
<asp:HiddenField ID="hidDMonth" runat="server" />
<asp:HiddenField ID="hidDDay" runat="server" />
<asp:HiddenField ID="hidLastView" runat="server" />
<asp:HiddenField ID="hidEventID" runat="server" />
<asp:Button ID="btnEditEvent" runat="server" Text="Button" Visible=false OnClick="btnEditEvent_Click" />
<asp:Button ID="btnDelEvent" runat="server" Text="Button" Visible=false OnClick="btnDelEvent_Click" />
    
<asp:Panel ID="panelCalendar" runat="server">
    <asp:Calendar ID="Calendar1" runat="server"     
        ShowGridLines="true"
        BorderWidth="1"
        BorderColor="#F0F0F0"
        BorderStyle="Solid"
        EnableTheming=false
        Font-Names="Verdana"
        Font-Size="9px"
        Width="550px"
        TitleStyle-Font-Size="12px"
        TitleStyle-Font-Bold="true"            
        TitleStyle-BackColor="#e6e7e8"  
        DayStyle-VerticalAlign="Top"
        DayStyle-Height="55px"
        DayStyle-Width="14%"
        NextPrevStyle-Font-Size="10px"
        NextPrevFormat="ShortMonth"          
        ToolTip="" UseAccessibleHeader="False" OnDayRender="Calendar1_DayRender" OnVisibleMonthChanged="Calendar1_VisibleMonthChanged" OnSelectionChanged="Calendar1_SelectionChanged">
    </asp:Calendar>
    <div style="text-align:center;margin-top:15px;width:550px">
        <asp:HyperLink ID="lnkRss" Target="_blank" runat="server">
            <asp:Image ID="imgRss" runat="server" />
        </asp:HyperLink>
    </div>
</asp:Panel>

<asp:Panel ID="panelDayView" runat="server">
    <table cellpadding="0" cellspacing="0" style="width:519px">
    <tr style="background:#E6E7E8">
        <td style="padding:5px;font-weight:bold">
            <asp:LinkButton ID="lnkYesterday" ForeColor="black" Font-Size="10px" runat="server" OnClick="lnkYesterday_Click">&lt;</asp:LinkButton>
        </td>
        <td style="padding:5px;font-weight:bold;text-align:center">
            <asp:Label ID="lblDate" runat="server" Font-Size="12px" Text=""></asp:Label>
        </td>
        <td style="padding:5px;font-weight:bold;text-align:right">
            <asp:LinkButton ID="lnkTomorrow" ForeColor="black" Font-Size="10px" runat="server" OnClick="lnkTomorrow_Click">&gt;</asp:LinkButton>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <div style="width:517px;height:470px;overflow-y:scroll;border:#C0C0C0 1px solid;">
                <asp:Label ID="lblDayView" runat="server" Text=""></asp:Label>
            </div>        
        </td>
    </tr>
    </table>
</asp:Panel>

<asp:Panel ID="panelEvent" Visible=false runat="server">
    <table cellpadding="4">
    <tr>
        <td><asp:Label ID="lblSubject" meta:resourcekey="lblSubject" runat="server" Text="Subject"></asp:Label></td><td>:</td>
        <td>
            <asp:TextBox ID="txtSubject" Width="200" ValidationGroup="formEvent" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv1" ValidationGroup="formEvent" ControlToValidate="txtSubject" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblLocation" meta:resourcekey="lblLocation" runat="server" Text="Location"></asp:Label></td><td valign="top">:</td>
        <td><asp:TextBox ID="txtLocation" Width="200" TextMode="MultiLine" Rows="3" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblStart" meta:resourcekey="lblStart" runat="server" Text="Start Time"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtStartDate" Width="65" runat="server"></asp:TextBox>&nbsp;
        <asp:TextBox ID="txtStartTime" Width="35" Text="8:00" runat="server"></asp:TextBox> 
        <i>(YYYY/MM/DD hh:mm)</i>
        <asp:CheckBox ID="chkAllDay" meta:resourcekey="chkAllDay" Text="All day event" runat="server" />
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblEnd" meta:resourcekey="lblEnd" runat="server" Text="End Time"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtEndDate" Width="65" runat="server"></asp:TextBox>&nbsp;
        <asp:TextBox ID="txtEndTime" Width="35" Text="10:00" runat="server"></asp:TextBox> 
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblNotes" meta:resourcekey="lblNotes" runat="server" Text="Notes"></asp:Label></td><td valign="top">:</td>
        <td><asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="200" Rows="3" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblURL" meta:resourcekey="lblURL" runat="server" Text="URL"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtURL" Width="200" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:HiddenField ID="hidID" runat="server" />
            <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " ValidationGroup="formEvent" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " OnClick="btnCancel_Click" />
        </td>
    </tr>
    </table>
</asp:Panel>

<asp:Panel ID="panelRecurrence" Visible=false runat="server">
    <table cellpadding="4">
    <tr>
        <td><asp:Label ID="lblRecSubject" meta:resourcekey="lblSubject" runat="server" Text="Subject"></asp:Label></td><td>:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtRecSubject" Width="200" ValidationGroup="formRecurrence" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv2" ValidationGroup="formRecurrence" ControlToValidate="txtRecSubject" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblRecLocation" meta:resourcekey="lblLocation" runat="server" Text="Location"></asp:Label></td><td valign="top">:</td>
        <td><asp:TextBox ID="txtRecLocation" Width="200" TextMode="MultiLine" Rows="3" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblRecStart" meta:resourcekey="lblStart" runat="server" Text="Start Time"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtRecStartTime" Width="35" Text="8:00" runat="server"></asp:TextBox> 
        <i>(hh:mm)</i>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblRecEnd" meta:resourcekey="lblEnd" runat="server" Text="End Time"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtRecEndTime" Width="35" Text="10:00" runat="server"></asp:TextBox> 
        <i>(hh:mm)</i>
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblRecRecurrence" meta:resourcekey="lblRecRecurrence" runat="server" Text="Recurrence"></asp:Label></td><td valign="top">:</td>
        <td>
            <table cellpadding="0" cellspacing="0">
            <tr>
            <td style="width:100px">
                <asp:RadioButton ID="rdoRecTypeDaily" meta:resourcekey="rdoRecTypeDaily" Text="Daily" GroupName="RecType" Checked="true" runat="server" /><br />
                <asp:RadioButton ID="rdoRecTypeWeekly" meta:resourcekey="rdoRecTypeWeekly" Text="Weekly" GroupName="RecType" runat="server" /><br />
                <asp:RadioButton ID="rdoRecTypeMonthly" meta:resourcekey="rdoRecTypeMonthly" Text="Monthly" GroupName="RecType" runat="server" /><br />
                <asp:RadioButton ID="rdoRecTypeYearly" meta:resourcekey="rdoRecTypeYearly" Text="Yearly" GroupName="RecType" runat="server" />
            </td>
            <td style="border-left:#cccccc 1px solid">&nbsp;&nbsp;&nbsp;</td>
            <td valign="top">
            
                <asp:Panel ID="panelDaily" runat="server">
                    <asp:RadioButton ID="rdoDOpt1" meta:resourcekey="rdoDOpt1" Text="Every" GroupName="Daily" Checked="true" runat="server" />
                    <asp:TextBox ID="txtDOpt1_Every" Width="20" Text="1" runat="server"></asp:TextBox> 
                    <asp:Label ID="lblDOpt1_Days" meta:resourcekey="lblDOpt1_Days" runat="server" Text="day(s)"></asp:Label>
                    <div style="margin:7px"></div>
                    <asp:RadioButton ID="rdoDOpt2" meta:resourcekey="rdoDOpt2" Text="Every weekday" GroupName="Daily" runat="server" />
                </asp:Panel>
                
                <asp:Panel ID="panelWeekly" runat="server">
                    <asp:Label ID="lblW_RecurEvery" meta:resourcekey="lblW_RecurEvery" runat="server" Text="Recur every"></asp:Label>  
                    <asp:TextBox ID="txtW_Every" Width="20" Text="1" runat="server"></asp:TextBox> 
                    <asp:Label ID="lblW_WeeksOn" meta:resourcekey="lblW_WeeksOn" runat="server" Text="week(s) on:"></asp:Label>
                    <div style="margin:7px"></div>
                    <asp:CheckBox ID="chkW_Sunday" meta:resourcekey="Sunday" Text="Sunday" runat="server" />
                    <asp:CheckBox ID="chkW_Monday" meta:resourcekey="Monday" Text="Monday" Checked="true" runat="server" />
                    <asp:CheckBox ID="chkW_Tuesday" meta:resourcekey="Tuesday" Text="Tuesday" runat="server" />
                    <asp:CheckBox ID="chkW_Wednesday" meta:resourcekey="Wednesday" Text="Wednesday" runat="server" /><br />
                    <asp:CheckBox ID="chkW_Thursday" meta:resourcekey="Thursday" Text="Thursday" runat="server" />
                    <asp:CheckBox ID="chkW_Friday" meta:resourcekey="Friday" Text="Friday" runat="server" />
                    <asp:CheckBox ID="chkW_Saturday" meta:resourcekey="Saturday" Text="Saturday" runat="server" />
                </asp:Panel>
                
                <asp:Panel ID="panelMonthly" runat="server">
                    <asp:RadioButton ID="rdoMOpt1" meta:resourcekey="rdoMOpt1" Text="Day" GroupName="Monthly" Checked="true" runat="server" />
                    <asp:TextBox ID="txtMOpt1_Day" Width="20" Text="1" runat="server"></asp:TextBox>
                    <asp:Label ID="lblMOpt1_OfEvery" meta:resourcekey="lblMOpt1_OfEvery" runat="server" Text="of every"></asp:Label>
                    <asp:TextBox ID="txtMOpt1_Every" Width="20" Text="1" runat="server"></asp:TextBox>
                    <asp:Label ID="lblMOpt1_Months" meta:resourcekey="lblMOpt1_Months" runat="server" Text="month(s)"></asp:Label>
                    <div style="margin:7px"></div>
                    <asp:RadioButton ID="rdoMOpt2" meta:resourcekey="rdoMOpt2" Text="The" GroupName="Monthly" runat="server" />
                    <asp:DropDownList ID="ddlMOpt2_Nth" runat="server">
                        <asp:ListItem meta:resourcekey="first" Value="1" Text="first"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="second" Value="2" Text="second"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="third" Value="3" Text="third"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="fourth" Value="4" Text="fourth"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="last" Value="5" Text="last"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlMOpt2_Day" runat="server">
<%--                                <asp:ListItem Value="day" Text="day"></asp:ListItem>
                        <asp:ListItem Value="weekday" Text="weekday"></asp:ListItem>
                        <asp:ListItem Value="weekend_day" Text="weekend day"></asp:ListItem>
--%>                                <asp:ListItem meta:resourcekey="Sunday" Value="0" Text="Sunday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Monday" Value="1" Text="Monday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Tuesday" Value="2" Text="Tuesday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Wednesday" Value="3" Text="Wednesday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Thursday" Value="4" Text="Thursday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Friday" Value="5" Text="Friday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Saturday" Value="6" Text="Saturday"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="lblMOpt2_OfEvery" meta:resourcekey="lblMOpt2_OfEvery" runat="server" Text="of every"></asp:Label>
                    <asp:TextBox ID="txtMOpt2_Every" Width="20" Text="1" runat="server"></asp:TextBox>
                    <asp:Label ID="lblMOpt2_Months" meta:resourcekey="lblMOpt2_Months" runat="server" Text="month(s)"></asp:Label>
                </asp:Panel>
                
                <asp:Panel ID="panelYearly" runat="server">
                    <asp:RadioButton ID="rdoYOpt1" meta:resourcekey="rdoYOpt1" Text="Every" GroupName="Yearly" Checked="true" runat="server" />
                    <asp:DropDownList ID="ddlYOpt1_Month" runat="server">
                        <asp:ListItem meta:resourcekey="January" Value="1" Text="January"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="February" Value="2" Text="February"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="March" Value="3" Text="March"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="April" Value="4" Text="April"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="May" Value="5" Text="May"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="June" Value="6" Text="June"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="July" Value="7" Text="July"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="August" Value="8" Text="August"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="September" Value="9" Text="September"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="October" Value="10" Text="October"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="November" Value="11" Text="November"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="December" Value="12" Text="December"></asp:ListItem>
                    </asp:DropDownList>&nbsp;
                    <asp:TextBox ID="txtYOpt1_Day" Width="20" Text="8" runat="server"></asp:TextBox>
                    <div style="margin:7px"></div>
                    <asp:RadioButton ID="rdoYOpt2" meta:resourcekey="rdoYOpt2" Text="The" GroupName="Yearly" runat="server" />
                    <asp:DropDownList ID="ddlYOpt2_Nth" runat="server">
                        <asp:ListItem meta:resourcekey="first" Value="1" Text="first"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="second" Value="2" Text="second"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="third" Value="3" Text="third"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="fourth" Value="4" Text="fourth"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="last" Value="5" Text="last"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlYOpt2_Day" runat="server">
<%--                 
                        <asp:ListItem Value="day" Text="day"></asp:ListItem>
                        <asp:ListItem Value="weekday" Text="weekday"></asp:ListItem>
                        <asp:ListItem Value="weekend_day" Text="weekend day"></asp:ListItem>
--%>                            
                        <asp:ListItem meta:resourcekey="Sunday" Value="0" Text="Sunday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Monday" Value="1" Text="Monday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Tuesday" Value="2" Text="Tuesday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Wednesday" Value="3" Text="Wednesday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Thursday" Value="4" Text="Thursday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Friday" Value="5" Text="Friday"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="Saturday" Value="6" Text="Saturday"></asp:ListItem>
                    </asp:DropDownList> 
                    <asp:Label ID="lblYOpt2_Of" meta:resourcekey="lblYOpt2_Of" runat="server" Text="of"></asp:Label>
                    <asp:DropDownList ID="ddlYOpt2_Month" runat="server">
                        <asp:ListItem meta:resourcekey="January" Value="1" Text="January"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="February" Value="2" Text="February"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="March" Value="3" Text="March"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="April" Value="4" Text="April"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="May" Value="5" Text="May"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="June" Value="6" Text="June"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="July" Value="7" Text="July"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="August" Value="8" Text="August"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="September" Value="9" Text="September"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="October" Value="10" Text="October"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="November" Value="11" Text="November"></asp:ListItem>
                        <asp:ListItem meta:resourcekey="December" Value="12" Text="December"></asp:ListItem>
                    </asp:DropDownList>
                </asp:Panel>    
                                
            </td>
            </tr>
            </table>
            
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblRecRange" meta:resourcekey="lblRecRange" runat="server" Text="Range"></asp:Label></td><td valign="top">:</td>
        <td>
            <table cellpadding="0" cellspacing="0">
            <tr>
            <td style="width:100px" valign="top">
                <asp:Label ID="lblRecRangeStart" meta:resourcekey="lblRecRangeStart" runat="server" Text="Start:"></asp:Label>
                <div style="margin:7px"></div>
                <asp:TextBox ID="txtRecStart" Width="65" runat="server"></asp:TextBox>
                <div style="margin:3px"></div>
                <i>(YYYY/MM/DD)</i>
            </td>
            <td style="border-left:#cccccc 1px solid">&nbsp;&nbsp;&nbsp;</td>
            <td>
                <asp:Label ID="lblRecRangeEnd" meta:resourcekey="lblRecRangeEnd" runat="server" Text="End:"></asp:Label>
                <div style="margin:7px"></div>
                <asp:RadioButton ID="rdoForever" meta:resourcekey="rdoForever" Text="Forever" GroupName="RangeEnd" Checked="true" runat="server" /><br />
                <asp:RadioButton ID="rdoEndAfter" meta:resourcekey="rdoEndAfter" Text="End after : " GroupName="RangeEnd" runat="server" />
                    <asp:TextBox ID="txtRecOccurs" Width="20" Text="10" runat="server"></asp:TextBox>&nbsp;occurences<br />
                <asp:RadioButton ID="rdoUntil" meta:resourcekey="rdoUntil" Text="Until : " GroupName="RangeEnd" runat="server" />
                    <asp:TextBox ID="txtRecEnd" Width="65" runat="server"></asp:TextBox> 
                    <i>(YYYY/MM/DD)</i>
                
            </td>
            </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top"><asp:Label ID="lblRecNotes" meta:resourcekey="lblNotes" runat="server" Text="Notes"></asp:Label></td><td valign="top">:</td>
        <td><asp:TextBox ID="txtRecNotes" TextMode="MultiLine" Width="200" Rows="3" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblRecURL" meta:resourcekey="lblURL" runat="server" Text="URL"></asp:Label></td><td>:</td>
        <td><asp:TextBox ID="txtRecURL" Width="200" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:HiddenField ID="hidRecID" runat="server" />
            <asp:Button ID="btnRecSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " ValidationGroup="formRecurrence" OnClick="btnRecSave_Click" />
            <asp:Button ID="btnRecCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " OnClick="btnRecCancel_Click" />
        </td>
    </tr>
    </table>
</asp:Panel>