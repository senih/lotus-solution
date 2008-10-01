Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.sqlClient
Imports IC.Lib.Util
Imports System.Collections.Generic

Public Class calendar
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Public Function GetDates(ByVal dStart As DateTime, ByVal dEnd As DateTime, ByVal nPageId As Integer) As DataTable
        Dim dt As DataTable
        dt = GetDatesRecurrence(dStart, dEnd, nPageId)
        dt.Merge(GetDatesNoRecurrence(dStart, dEnd, nPageId))
        Return dt
    End Function

    Public Function GetDatesNoRecurrence(ByVal dStart As DateTime, ByVal dEnd As DateTime, ByVal nPageId As Integer) As DataTable
        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("id", GetType(Integer)))
        dt.Columns.Add(New DataColumn("subject", GetType(String)))
        dt.Columns.Add(New DataColumn("date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("start_time", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("end_time", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("all_day", GetType(Boolean)))
        dt.Columns.Add(New DataColumn("is_rec", GetType(Boolean)))
        dt.Columns.Add(New DataColumn("location", GetType(String)))
        dt.Columns.Add(New DataColumn("notes", GetType(String)))
        dt.Columns.Add(New DataColumn("url", GetType(String)))

        Dim sSQL As String
        'sSQL = "SELECT * FROM calendar WHERE is_rec=0 AND ((start_time BETWEEN @start AND @end+1) OR (end_time BETWEEN @start AND @end+1) OR (start_time<=@start AND end_time>=@end))"
        sSQL = "SELECT * FROM calendar WHERE page_id=@page_id AND is_rec=0 AND ((start_time>=@start AND start_time<=@end) OR (end_time>=@start AND end_time<=@end) OR (start_time<=@start AND end_time>=@end))"

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@start", SqlDbType.DateTime).Value = dStart
        oCommand.Parameters.Add("@end", SqlDbType.DateTime).Value = dEnd
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            Dim dr As DataRow

            If Date.Compare(GetDate(CDate(oDataReader("start_time"))), dStart) >= 0 And _
                Date.Compare(GetDate(CDate(oDataReader("start_time"))), dEnd) <= 0 Then

                If Date.Compare(GetDate(CDate(oDataReader("end_time"))), dStart) >= 0 And _
                    Date.Compare(GetDate(CDate(oDataReader("end_time"))), dEnd) <= 0 Then

                    Dim d As Date = GetDate(CDate(oDataReader("start_time")))
                    While Date.Compare(d, GetDate(CDate(oDataReader("end_time")))) <= 0
                        dr = dt.NewRow()
                        dr("id") = CInt(oDataReader("id"))
                        dr("subject") = oDataReader("subject").ToString
                        dr("date") = d
                        dr("start_time") = oDataReader("start_time")
                        If Not IsDBNull(oDataReader("end_time")) Then
                            dr("end_time") = oDataReader("end_time")
                        End If
                        dr("all_day") = CBool(oDataReader("all_day"))
                        dr("is_rec") = False
                        dr("location") = oDataReader("location").ToString
                        dr("notes") = oDataReader("notes").ToString
                        dr("url") = oDataReader("url").ToString
                        dt.Rows.Add(dr)

                        d = d.AddDays(1)
                    End While

                Else

                    Dim d As DateTime = GetDate(CDate(oDataReader("start_time")))
                    While Date.Compare(d, dEnd) <= 0 'Use End
                        dr = dt.NewRow()
                        dr("id") = CInt(oDataReader("id"))
                        dr("subject") = oDataReader("subject").ToString
                        dr("date") = d
                        dr("start_time") = oDataReader("start_time")
                        If Not IsDBNull(oDataReader("end_time")) Then
                            dr("end_time") = oDataReader("end_time")
                        End If
                        dr("all_day") = CBool(oDataReader("all_day"))
                        dr("is_rec") = False
                        dr("location") = oDataReader("location").ToString
                        dr("notes") = oDataReader("notes").ToString
                        dr("url") = oDataReader("url").ToString
                        dt.Rows.Add(dr)

                        d = d.AddDays(1)
                    End While

                End If

            ElseIf Date.Compare(GetDate(CDate(oDataReader("end_time"))), dStart) >= 0 And _
                 Date.Compare(GetDate(CDate(oDataReader("end_time"))), dEnd) <= 0 Then

                If Date.Compare(CDate(oDataReader("start_time")), dStart) >= 0 And _
                    Date.Compare(CDate(oDataReader("start_time")), dEnd) <= 0 Then

                    'DONE

                Else

                    Dim d As Date = dStart 'Use Start
                    While Date.Compare(d, GetDate(CDate(oDataReader("end_time")))) <= 0
                        dr = dt.NewRow()
                        dr("id") = CInt(oDataReader("id"))
                        dr("subject") = oDataReader("subject").ToString
                        dr("date") = d
                        dr("start_time") = oDataReader("start_time")
                        If Not IsDBNull(oDataReader("end_time")) Then
                            dr("end_time") = oDataReader("end_time")
                        End If
                        dr("all_day") = CBool(oDataReader("all_day"))
                        dr("is_rec") = False
                        dr("location") = oDataReader("location").ToString
                        dr("notes") = oDataReader("notes").ToString
                        dr("url") = oDataReader("url").ToString
                        dt.Rows.Add(dr)

                        d = d.AddDays(1)
                    End While

                End If

            ElseIf Date.Compare(GetDate(CDate(oDataReader("start_time"))), dStart) < 0 And _
                Date.Compare(GetDate(CDate(oDataReader("end_time"))), dEnd) > 0 Then

                Dim d As Date = dStart 'Use Start
                While Date.Compare(d, dEnd) <= 0
                    dr = dt.NewRow()
                    dr("id") = CInt(oDataReader("id"))
                    dr("subject") = oDataReader("subject").ToString
                    dr("date") = d
                    dr("start_time") = oDataReader("start_time")
                    If Not IsDBNull(oDataReader("end_time")) Then
                        dr("end_time") = oDataReader("end_time")
                    End If
                    dr("all_day") = CBool(oDataReader("all_day"))
                    dr("is_rec") = False
                    dr("location") = oDataReader("location").ToString
                    dr("notes") = oDataReader("notes").ToString
                    dr("url") = oDataReader("url").ToString
                    dt.Rows.Add(dr)

                    d = d.AddDays(1)
                End While
            End If

        End While
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing

        Return dt
    End Function

    Public Function GetDate(ByVal d As DateTime) As Date
        Return New Date(d.Year, d.Month, d.Day)
    End Function

    Public Function GetWeekStart(ByVal d As DateTime, ByVal bFromSunday As Boolean) As Date
        If bFromSunday Then
            Return d.Subtract(System.TimeSpan.FromDays(Weekday(GetDate(d)) - 1))
        Else 'From Monday
            Return d.Subtract(System.TimeSpan.FromDays(Weekday(GetDate(d)) - 1)).Add(System.TimeSpan.FromDays(1))
        End If
    End Function

    Public Function GetDatesRecurrence(ByVal dStart As DateTime, ByVal dEnd As DateTime, ByVal nPageId As Integer) As DataTable
        dStart = New Date(dStart.Year, dStart.Month, dStart.Day, 0, 0, 0)
        dEnd = New Date(dEnd.Year, dEnd.Month, dEnd.Day, 23, 59, 59)

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("id", GetType(Integer)))
        dt.Columns.Add(New DataColumn("subject", GetType(String)))
        dt.Columns.Add(New DataColumn("date", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("start_time", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("end_time", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("all_day", GetType(Boolean)))
        dt.Columns.Add(New DataColumn("is_rec", GetType(Boolean)))
        dt.Columns.Add(New DataColumn("location", GetType(String)))
        dt.Columns.Add(New DataColumn("notes", GetType(String)))
        dt.Columns.Add(New DataColumn("url", GetType(String)))

        Dim sSQL As String
        sSQL = "Select * from calendar Where is_rec=1 and page_id=@page_id"

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()

        While oDataReader.Read()

            Dim rec As Recurrence = Nothing

            '-----------
            Dim sRecType As String = oDataReader("rec_type").ToString
            Dim nRecEvery As Integer
            Dim nNthDayInMonth As Integer
            Dim nNthDay As Integer
            Dim nWeekday As Integer
            Dim nMonth As Integer

            If sRecType = "D" Then
                nRecEvery = CInt(oDataReader("rec_every"))
                If nRecEvery = 0 Then
                    rec = New DailyRecurrence()
                Else
                    rec = New DailyRecurrence(nRecEvery)
                End If
            ElseIf sRecType = "W" Then
                nRecEvery = CInt(oDataReader("rec_every"))
                Dim sRecDaysInWeek As String = oDataReader("rec_days_in_week").ToString

                Dim oList As New List(Of DayOfWeek)
                For Each item As Integer In sRecDaysInWeek.Split(",")
                    oList.Add(item)
                Next

                rec = New WeeklyRecurrence(nRecEvery, oList)
            ElseIf sRecType = "M" Then
                nRecEvery = CInt(oDataReader("rec_every"))
                If Not oDataReader("nth_day_in_month") = 0 Then
                    nNthDayInMonth = CInt(oDataReader("nth_day_in_month"))
                    rec = New MonthlyRecurrence(nNthDayInMonth, nRecEvery)
                Else
                    nNthDay = CInt(oDataReader("nth_day"))
                    nWeekday = CInt(oDataReader("weekday"))
                    rec = New MonthlyRecurrence(nNthDay, nWeekday, nRecEvery)
                End If
            ElseIf sRecType = "Y" Then
                nMonth = CInt(oDataReader("month"))
                If Not oDataReader("nth_day_in_month") = 0 Then
                    nNthDayInMonth = CInt(oDataReader("nth_day_in_month"))
                    rec = New YearlyRecurrence(nNthDayInMonth, nMonth)
                Else
                    nNthDay = CInt(oDataReader("nth_day"))
                    nWeekday = CInt(oDataReader("weekday"))
                    rec = New YearlyRecurrence(nNthDay, nWeekday, nMonth)
                End If
            End If

            '-----------
            Dim nRecEndType As Integer = oDataReader("rec_end_type").ToString
            Dim dRecStart As DateTime = CDate(oDataReader("rec_start"))
            Dim dRecEnd As DateTime
            Dim nRecOccurs As Integer

            rec.StartDate = dRecStart
            If nRecEndType = 0 Then
                rec.RecurrenceRangeType = RecurrenceRangeEnum.NO_END
            ElseIf nRecEndType = 1 Then
                rec.RecurrenceRangeType = RecurrenceRangeEnum.END_BY_OCCURENCES
                nRecOccurs = CInt(oDataReader("rec_occurs"))
                rec.NumOfOccurrences = nRecOccurs
            ElseIf nRecEndType = 2 Then
                rec.RecurrenceRangeType = RecurrenceRangeEnum.END_BY_DATE
                dRecEnd = CDate(oDataReader("rec_end"))
                rec.EndDate = dRecEnd
            End If

            '----------- 
            Dim dates As List(Of Date) = rec.GetRecurrences(dStart, dEnd)

            For Each it As Date In dates
                Dim dr As DataRow = dt.NewRow()
                dr("id") = CInt(oDataReader("id"))
                dr("subject") = oDataReader("subject").ToString
                dr("date") = it
                dr("start_time") = oDataReader("start_time")
                If Not IsDBNull(oDataReader("end_time")) Then
                    dr("end_time") = oDataReader("end_time")
                End If
                dr("all_day") = CBool(oDataReader("all_day"))
                dr("is_rec") = True
                dr("location") = oDataReader("location").ToString
                dr("notes") = oDataReader("notes").ToString
                dr("url") = oDataReader("url").ToString
                dt.Rows.Add(dr)
            Next

        End While

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing

        Return dt
    End Function

    Public Function RenderDayView(ByVal dt As DataTable, ByVal dDayView As Date, ByVal bShowEditDelLink As Boolean, ByVal sEditText As String, ByVal sDelText As String) As String
        Dim dr As DataRow
        Dim time(48, 10) As String
        Dim info(48, 10) As String
        Dim tm As DateTime = New Date(2007, 1, 1, 0, 0, 0)
        Dim n As Integer = 0
        Dim nEvent As Integer = 0
        Dim nColumns As Integer = 0
        While n <= 48
            For Each dr In dt.Rows

                If dr(6) = False Then
                    'If not recurrence
                    If CDate(dr(3)).Day < CDate(dDayView).Day Then
                        dr(3) = New Date(CDate(dr(4)).Year, CDate(dr(4)).Month, CDate(dr(4)).Day, 0, 0, 0)
                    End If

                    If CDate(dr(4)).Day > CDate(dDayView).Day Then
                        dr(4) = New Date(CDate(dr(3)).Year, CDate(dr(3)).Month, CDate(dr(3)).Day, 23, 59, 59)
                    End If
                End If

                If CBool(dr(5)) Then
                    'All Day
                    dr(3) = New Date(CDate(dr(4)).Year, CDate(dr(4)).Month, CDate(dr(4)).Day, 0, 0, 0)
                    dr(4) = New Date(CDate(dr(3)).Year, CDate(dr(3)).Month, CDate(dr(3)).Day, 23, 59, 59)
                End If

                If New Date(2007, 1, 1, CDate(dr(3)).Hour, CDate(dr(3)).Minute, 0) >= tm And _
                    New Date(2007, 1, 1, CDate(dr(3)).Hour, CDate(dr(3)).Minute, 0) < tm.AddMinutes(30) Then

                    Dim nTimeSpan As Double = Math.Ceiling((New Date(2007, 1, 1, CDate(dr(4)).Hour, CDate(dr(4)).Minute, 0) - New Date(2007, 1, 1, CDate(dr(3)).Hour, CDate(dr(3)).Minute, 0)).TotalMinutes / 30)

                    'Check space
                    nEvent = 0
                    For nEvent = 0 To 10
                        Dim bOk As Boolean = True
                        For k As Integer = 0 To nTimeSpan - 1
                            If time(n + k, nEvent) <> "" Then
                                bOk = False
                            End If
                        Next
                        If bOk Then
                            Exit For
                        End If
                    Next

                    If nEvent >= nColumns Then
                        nColumns = nEvent
                    End If

                    Dim sEditDel As String = ""
                    If bShowEditDelLink Then
                        sEditDel = " <span onclick=""_editEvent('" & dr(0) & "')"" style=""cursor:pointer;font-size:9px;text-decoration:underline"">" & sEditText & "</span>&nbsp;<span onclick=""_deleteEvent('" & dr(0) & "')"" style=""cursor:pointer;font-size:9px;text-decoration:underline"">" & sDelText & "</span>" '" <span onclick=""_editEvent('" & dr(0) & "')"" style=""cursor:pointer;font-size:8px;text-decoration:underline"">Edit</span>&nbsp;<span onclick=""_deleteEvent('" & dr(0) & "')"" style=""cursor:pointer;font-size:8px;text-decoration:underline>Del</span>"
                    End If

                    If CBool(dr(5)) Then
                        info(n, nEvent) = "<div style=""margin:4px;"">" + dr(1) + sEditDel + "<br />(All Day)" + "</div>"
                    Else
                        Dim dStartTime As DateTime = CDate(dr(3))
                        Dim sStartTime As String = ""
                        Dim sStartMinute As String = dStartTime.Minute
                        If sStartMinute.Length = 1 Then sStartMinute = "0" & sStartMinute
                        If dStartTime.Hour = 0 Then
                            sStartTime = "12:" & sStartMinute & " AM"
                        ElseIf dStartTime.Hour = 23 And dStartTime.Minute = 59 Then
                            sStartTime = "12:00 AM"
                        ElseIf dStartTime.Hour < 12 Then
                            sStartTime = dStartTime.Hour & ":" & sStartMinute & " AM"
                        ElseIf dStartTime.Hour = 12 Then
                            sStartTime = dStartTime.Hour & ":" & sStartMinute & " PM"
                        Else
                            sStartTime = dStartTime.Hour - 12 & ":" & sStartMinute & " PM"
                        End If

                        Dim dEndTime As DateTime = CDate(dr(4))
                        Dim sEndTime As String = ""
                        Dim sEndMinute As String = dEndTime.Minute
                        If sEndMinute.Length = 1 Then sEndMinute = "0" & sEndMinute
                        If dEndTime.Hour = 0 Then
                            sEndTime = "12:" & sEndMinute & " AM"
                        ElseIf dEndTime.Hour = 23 And dEndTime.Minute = 59 Then
                            sEndTime = "12:00 AM"
                        ElseIf dEndTime.Hour < 12 Then
                            sEndTime = dEndTime.Hour & ":" & sEndMinute & " AM"
                        ElseIf dEndTime.Hour = 12 Then
                            sEndTime = dEndTime.Hour & ":" & sEndMinute & " PM"
                        Else
                            sEndTime = dEndTime.Hour - 12 & ":" & sEndMinute & " PM"
                        End If

                        Dim sSubject As String
                        If dr(9).ToString = "" Then
                            sSubject = dr(1)
                        Else
                            sSubject = "<a href=""" & dr(9).ToString & """>" & dr(1) & "</a>"
                        End If

                        Dim sLocation As String
                        If dr(7).ToString = "" Then
                            sLocation = ""
                        Else
                            sLocation = "<div style=""margin-top:3px"">" + dr(7) + "</div>"
                        End If

                        info(n, nEvent) = "<div style=""margin:4px;"">" + sSubject + sEditDel + sLocation + "<div style=""margin-top:3px"">" + sStartTime + " - " + sEndTime + "</div></div>"
                    End If

                    time(n, nEvent) = nTimeSpan
                    For k As Integer = 1 To nTimeSpan - 1
                        time(n + k, nEvent) = 0
                    Next

                    nEvent = nEvent + 1
                End If

            Next
            tm = tm.AddMinutes(30)
            n = n + 1
        End While

        tm = New Date(2007, 1, 1, 0, 0, 0)
        Dim i As Integer
        Dim j As Integer
        Dim s As String = "<table border=""0"" style=""width:500px;BORDER-COLLAPSE: collapse"" cellpadding=""3"" cellspacing=""0"">"
        For i = 0 To 47
            s += "<tr>"

            Dim sNoTop As String = ""
            If tm.Hour = 0 Then
                sNoTop = "border-top:none"
            End If
            Dim sGrayBg As String = ""
            If tm.Hour <= 7 Or tm.Hour >= 17 Then
                sGrayBg = "background-color:#F0F0F0"
            End If

            If tm.Minute = 30 Then
                s += "<td style=""width:50px;border-right:#D5D8DC 1px solid"">&nbsp;</td>"
            Else
                Dim sHour As String

                If tm.Hour = 0 Then
                    sHour = "12 AM"
                ElseIf tm.Hour < 12 Then
                    sHour = tm.Hour & " AM"
                ElseIf tm.Hour = 12 Then
                    sHour = tm.Hour & " PM"
                Else
                    sHour = tm.Hour - 12 & " PM"
                End If
                s += "<td style=""width:50px;font-size:12px;font-weight:bold;color:#a1a2a3;text-align:right;border-top:#D5D8DC 1px solid;border-right:#D5D8DC 1px solid;" & sNoTop & """>" & sHour & "</td>"
            End If

            For j = 0 To nColumns
                If time(i, j) = "" Then
                    If tm.Minute = 0 Then
                        s += "<td style=""border-top:#D5D8DC 1px solid;" & sNoTop & ";" & sGrayBg & """>&nbsp;</td>"
                    Else
                        s += "<td style=""border-top:#F2F4F5 1px solid;" & sNoTop & ";" & sGrayBg & """>&nbsp;</td>"
                    End If

                ElseIf time(i, j) >= 1 Then
                    s += "<td rowspan=""" & time(i, j) & """ valign=""middle"" style=""cursor:default;padding:0px;border:#909090 1px solid;background-color:#D7CEE8;padding-left:3px;line-height:10px"">" & info(i, j) & "</td>"
                ElseIf time(i, j) = 0 Then
                    'noop
                End If
            Next
            tm = tm.AddMinutes(30)
            s += "</tr>"
        Next
        s += "</table>"
        Return s
    End Function
End Class
