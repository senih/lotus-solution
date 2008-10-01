<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()

        '~~~~~ Statistic Info ~~~~~
        Dim nThisMonth As Integer = 0
        Dim nLastMonth As Integer = 0
        Dim nOverall As Integer = 0
        oCommand = New SqlCommand("SET LANGUAGE us_english select sum(count) as tot, 'this' as mo from pages_views_count_daily where month(date_stamp) = @thismonth and year(date_stamp)=@year1 and page_id=@page_id " & _
            "union " & _
            "select sum(count) as tot, 'last' as mo from pages_views_count_daily where month(date_stamp) = @lastmonth and year(date_stamp)=@year2 and page_id=@page_id " & _
            "union " & _
            "select total as tot, 'overall' as mo from pages_views_count where page_id=@page_id", oConn)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCommand.Parameters.Add("@thismonth", SqlDbType.Int).Value = Now.Month
        oCommand.Parameters.Add("@year1", SqlDbType.Int).Value = Now.Year
        If Now.Month = 1 Then
            oCommand.Parameters.Add("@lastmonth", SqlDbType.Int).Value = 12
            oCommand.Parameters.Add("@year2", SqlDbType.Int).Value = Now.Year - 1
        Else
            oCommand.Parameters.Add("@lastmonth", SqlDbType.Int).Value = Now.Month - 1
            oCommand.Parameters.Add("@year2", SqlDbType.Int).Value = Now.Year
        End If
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read
            If oDataReader("mo").ToString = "this" Then 'this month
                If Not IsDBNull(oDataReader("tot")) Then
                    nThisMonth = CInt(oDataReader("tot"))
                End If
            End If
            If oDataReader("mo").ToString = "last" Then 'last month
                If Not IsDBNull(oDataReader("tot")) Then
                    nLastMonth = CInt(oDataReader("tot"))
                End If
            End If
            If oDataReader("mo").ToString = "overall" Then 'overall
                If Not IsDBNull(oDataReader("tot")) Then
                    nOverall = CInt(oDataReader("tot"))
                End If
            End If
        End While
        oDataReader.Close()

        Dim dStatDate As Date
        Dim nStatCount As Integer
        Dim nC(7) As Integer
        Dim dD(7) As Date
        oCommand = New SqlCommand("SET LANGUAGE us_english SELECT date_stamp,count FROM pages_views_count_daily WHERE page_id=@page_id and date_stamp>=@start order by date_stamp", oConn)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.PageID
        oCommand.Parameters.Add("@start", SqlDbType.DateTime).Value = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(6))
        oDataReader = oCommand.ExecuteReader()
        Dim nTop As Integer = 0
        Dim n As Integer = 0
        Dim nToday As Integer
        Dim nYesterday As Integer
        While oDataReader.Read
            dStatDate = CDate(oDataReader("date_stamp"))
            nStatCount = CInt(oDataReader("count"))
            If nStatCount >= nTop Then
                nTop = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(6)) Then
                nC(6) = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(5)) Then
                nC(5) = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(4)) Then
                nC(4) = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(3)) Then
                nC(3) = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(2)) Then
                nC(2) = nStatCount
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(1)) Then
                nC(1) = nStatCount
                nYesterday = nC(1)
            End If
            If dStatDate = New Date(Now.Year, Now.Month, Now.Day) Then
                nC(0) = nStatCount
                nToday = nC(0)
            End If
            n = n + 1
        End While
        oDataReader.Close()

        For n = 0 To 6
            dD(n) = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(n))
        Next

        Dim sStatistic As String = ""
        Dim sChart As String = ""
        Dim sBar As String = ""
        Dim sDate As String = ""
        Dim sAlt As String = ""

        Dim sScale As String
        Dim nTopRange As Integer
        nTopRange = nTop + (10 - nTop.ToString.Substring(nTop.ToString.Length - 1))
        sScale = "<div style=""position:relative;top:-3px;text-align:right;line-height:10px"">" & nTopRange & "</div>" & _
            "<div style=""position:relative;top:2px;text-align:right;line-height:10px"">" & (nTopRange / 2) & "</div>" & _
            "<div style=""position:relative;top:7px;text-align:right;line-height:10px"">0</div>"

        For n = 0 To 6
            If n = 0 Then
                sAlt = nC(n) & " " & GetLocalResourceObject("times_today")
            ElseIf n = 1 Then
                sAlt = nC(n) & " " & GetLocalResourceObject("times_yesterday")
            Else
                sAlt = nC(n) & " " & GetLocalResourceObject("times") & " (" & MonthName(dD(n).Month, True) & " " & dD(n).Day & ")"
            End If

            If nC(n) = 0 Then
                sBar = "<div style=""height:30px;width:20px;cursor:default;"">&nbsp;</div>"
            Else
                sBar = "<div class=""barStat"" style=""cursor:default;height:" & CInt((nC(n) / nTopRange) * 30) & "px;width:20px;""></div>"
            End If
            sChart = "<td class=""barStatArea"" valign=""bottom"" style=""height:30px;font-size:8px;text-align:center"" title=""" & sAlt & """>" & _
                sBar & "</td>" & sChart

            If n = 1 Then
                sDate = "<td colspan=""2"" style=""font-size:9px;font-family:arial;text-align:right;padding-right:0px;"">" & MonthName(dD(0).Month, True) & " " & dD(0).Day & "</td>" & sDate
            ElseIf n = 2 Or n = 3 Or n = 4 Then
                sDate = "<td style=""font-size:6pt;"">&nbsp;</td>" & sDate
            ElseIf n = 6 Then
                sDate = "<td colspan=""2"" style=""font-size:9px;font-family:arial;text-align:left;padding-left:0px;"">" & MonthName(dD(n).Month, True) & " " & dD(n).Day & "</td>" & sDate
            End If
        Next

        Dim bStatHorizontal As Boolean = False
        If bStatHorizontal Then
            sStatistic = "<table cellpadding=""0"" cellspacing=""0"">" & _
                "<tr>" & _
                    "<td></td>" & _
                    "<td colspan=""7"" class=""boxStatHeader"" style=""padding-bottom:2px;padding-top:2px;font-weight:bold;font-size:9px;font-family:verdana;text-align:center;line-height:9px;color:white"">" & GetLocalResourceObject("page_views") & "</td>" & _
                    "<td rowspan=""2"" class=""boxStatDetailsHorizontal"">" & _
                        "<div style=""font-size:7pt;font-family:verdana;padding:1px;padding-right:7px;padding-left:7px"">" & _
                        nToday & " " & GetLocalResourceObject("times_today") & ", " & nYesterday & " " & GetLocalResourceObject("times_yesterday") & "<br />" & _
                        nThisMonth & " " & GetLocalResourceObject("times_thismonth") & ", " & nLastMonth & " " & GetLocalResourceObject("times_lastmonth") & "<br /><b>" & GetLocalResourceObject("Overall") & " " & nOverall & " " & GetLocalResourceObject("times") & "</b>" & _
                        "</div>" & _
                    "</td>" & _
                "</tr>" & _
                "<tr>" & _
                    "<td valign=""top"" rowspan=""2"" style=""font-size:6pt;padding-right:3px;padding-top:0px;"">" & sScale & "</td>" & _
                    sChart & _
                "</tr>" & _
                "<tr>" & _
                    sDate & _
                    "<td></td>" & _
                "</tr>" & _
                "</table>"
            panelStat.Controls.Add(New LiteralControl(sStatistic))
        Else
            sStatistic = "<table cellpadding=""0"" cellspacing=""0"">" & _
                "<tr>" & _
                    "<td></td>" & _
                    "<td colspan=""7"" class=""boxStatHeader"" style=""padding-bottom:2px;padding-top:2px;font-weight:bold;font-size:9px;font-family:verdana;text-align:center;line-height:9px;color:white"">" & GetLocalResourceObject("page_views") & "</td>" & _
                "</tr>" & _
                "<tr>" & _
                    "<td valign=""top"" rowspan=""2"" style=""font-size:6pt;padding-right:3px;padding-top:0px;"">" & sScale & "</td>" & _
                    sChart & _
                "</tr>" & _
                "<tr>" & _
                    sDate & _
                 "</tr>" & _
                "</tr>" & _
                    "<td></td>" & _
                    "<td colspan=""7"" class=""boxStatDetailsVertical"">" & _
                        "<div style=""font-size:7pt;font-family:verdana;padding:1px;padding-right:7px;"">" & _
                        nToday & " " & GetLocalResourceObject("times_today") & "<br />" & nYesterday & " " & GetLocalResourceObject("times_yesterday") & "<br />" & nThisMonth & " " & GetLocalResourceObject("times_thismonth") & "<br />" & nLastMonth & " " & GetLocalResourceObject("times_lastmonth") & "<br /><b>" & GetLocalResourceObject("Overall") & " " & nOverall & " " & GetLocalResourceObject("times") & "</b>" & _
                        "</div>" & _
                    "</td>" & _
                "</tr>" & _
                "</table>"
            panelStat.Controls.Add(New LiteralControl(sStatistic))
        End If
    End Sub
</script>

<asp:Panel ID="panelStat" CssClass="boxStatVertical" runat="server">
</asp:Panel>
