<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat=server>
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private arrUserRoles() As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (IsNothing(GetUser())) Then

            '~~~ If just subscriber, disable event facility ~~~
            arrUserRoles = Roles.GetRolesForUser(GetUser.UserName)
            Dim sItem As String
            Dim bEnableEventFacility As Boolean = False
            For Each sItem In arrUserRoles
                If sItem.Contains(" Authors") Or _
                    sItem.Contains(" Editors") Or _
                    sItem.Contains(" Publishers") Or _
                    sItem.Contains(" Resource Managers") Or _
                    sItem = "Administrators" Then
                    bEnableEventFacility = True
                    Exit For
                End If
            Next
            If Not bEnableEventFacility Then
                Exit Sub
            End If
            '~~~~~~~~

            panelLogin.Visible = False
            panelEvents.Visible = True

            '~~~ Only Administrators & Events Managers can embed Public Events ~~~
            If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName.ToString(), "Events Managers")) Then
                lnkEmbedEvent.Visible = True
            Else
                lnkEmbedEvent.Visible = False
            End If
        
            SqlDataSource1.ConnectionString = sConn
            SqlDataSource1.SelectParameters(0).DefaultValue = Now ' perubahan
            SqlDataSource1.SelectCommand = "SELECT * FROM events WHERE (repeat <> 0 AND (author = '" & GetUser().ToString & "' OR type=2)) AND (root_id=@root_id or root_id is null)" & _
                                            " ORDER BY from_date desc"
            SqlDataSource1.SelectParameters(1).DefaultValue = Me.RootID
            gridviewEvents.DataBind()
            If Not IsPostBack Then
                Calendar1.TodayDayStyle.ForeColor = Drawing.Color.Blue
                Calendar1.SelectedDates.Clear()
            End If
        Else
            panelLogin.Visible = True
            panelEvents.Visible = False
        End If
    End Sub

    Protected Sub lnkNewEvent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewEvent.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Response.Redirect(Me.LinkWorkspaceEventNew)
    End Sub

    Protected Sub lnkLatest_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLatest.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.SelectParameters(0).DefaultValue = Now ' perubahan
        SqlDataSource1.SelectParameters(1).DefaultValue = Me.RootID
        SqlDataSource1.SelectCommand = "SELECT * FROM events WHERE (repeat <> 0 AND (author = '" & GetUser().ToString & "' OR type=2)) AND (root_id=@root_id or root_id is null) ORDER BY from_date desc"
        gridviewEvents.DataSourceID = "SqlDataSource1"
        gridviewEvents.PageSize = 10
        gridviewEvents.DataBind()
        Calendar1.TodayDayStyle.ForeColor = Drawing.Color.Blue
        Calendar1.SelectedDates.Clear()
    End Sub

    Protected Sub Calendar1_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs) Handles Calendar1.DayRender
        e.Day.IsSelectable = False
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim sqlCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        Dim dtDay As DateTime
        sqlCmd = New SqlCommand("SELECT * FROM events WHERE ((author = '" & GetUser().ToString & "') OR type=2 )  AND (root_id=@root_id or root_id is null)", oConn)
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID

        oConn.Open()
        oDataReader = sqlCmd.ExecuteReader()
        Do While oDataReader.Read()
            dtDay = (CType(oDataReader("from_date"), DateTime))
            If (e.Day.Date = dtDay.Date) And (e.Day.Date <> Calendar1.SelectedDate) Then
                e.Day.IsSelectable = True
            End If
        Loop
        oDataReader.Close()
        oConn.Close()
    End Sub

    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Calendar1.SelectionChanged
        If Not Me.IsUserLoggedIn Then Exit Sub
      
        Dim sDate As DateTime = Calendar1.SelectedDate
        SqlDataSource1.SelectParameters(0).DefaultValue = sDate.Date
        Dim nDayOfWeek As Integer = Calendar1.SelectedDate.DayOfWeek + 1
        Dim nMonth As Integer = Calendar1.SelectedDate.Month
        Dim nYear As Integer = Calendar1.SelectedDate.Year
        Dim nDay As Integer = Calendar1.SelectedDate.Day
        Dim sSQL1 As String = "(DATEPART(year, from_date) = DATEPART(year, @date) AND DATEPART(month, from_date) = DATEPART(month, @date) AND DATEPART(day, from_date) = DATEPART(day, @date))"
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource1.SelectParameters(1).DefaultValue = Me.RootID
        SqlDataSource1.SelectCommand = "SELECT * FROM events WHERE ((" & sSQL1 & " AND (author = '" & GetUser().ToString & "')) OR (" & sSQL1 & " AND type=2))  AND (root_id=@root_id or root_id is null)" & _
                                              " ORDER BY from_date desc "
        gridviewEvents.DataSourceID = "SqlDataSource1"
        gridviewEvents.DataBind()
        If gridviewEvents.PageCount > 0 Then
            gridviewEvents.PageSize = gridviewEvents.PageCount * 10
        End If
    End Sub

    Function ShowMore(ByVal link As String) As String
        If Not (link = "") Then
            Return ("&nbsp;&nbsp;<a href=""" & link & """>" & GetLocalResourceObject("More") & "</a>")
        Else
            Return ("")
        End If
    End Function

    Function ShowEdit(ByVal sEventID As String, ByVal sAuthor As String) As String
        Dim sEdit As String = ""
        If Not (IsNothing(GetUser())) Then
            If Not (sEventID = "") Then
                If GetUser.UserName = sAuthor Then
                    Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){"
                    sEdit = "&nbsp;&nbsp;<a href=""" & Me.LinkWorkspaceEventEdit & "?id=" & sEventID & """>" & GetLocalResourceObject("Edit") & "</a>" & _
                            "&nbsp;&nbsp;<a id=""" & sEventID & """ " & _
                            "href=""javascript:" & sScript & "document.getElementById('" & hidEventID.ClientID & "').value=" & sEventID & ";" & _
                            "document.getElementById('" & btnDelete.ClientID & "').onclick()}"" />" & GetLocalResourceObject("Delete") & "</a>"
                End If
            End If
        Else
            sEdit = ""
        End If
        Return sEdit
    End Function

    Function ShowEvent(ByVal sTitle As String, _
        ByVal sDescription As String, _
        ByVal bIsAllDay As Boolean, _
        ByVal dFrom As Date, ByVal dTo As Date, ByVal nType As Integer) As String

        Dim sReturn As String = ""
        Dim sType As String = ""
        If nType = 2 Then
            'Public Event
            sType = " <i>(public)</i>"
        Else
            'Private Event
        End If

        If bIsAllDay Then
            'do not show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                sReturn = "<b>" & sTitle & "</b>" & sType & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate)
            Else
                sReturn = "<b>" & sTitle & "</b>" & sType & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " - " & "<br />" & _
                    FormatDateTime(dTo, DateFormat.LongDate)
            End If
        Else
            'show time
            If Year(dFrom) = Year(dTo) And _
                Month(dFrom) = Month(dTo) And _
                Day(dFrom) = Day(dTo) Then
                sReturn = "<b>" & sTitle & "</b>" & sType & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            Else
                sReturn = "<b>" & sTitle & "</b>" & sType & _
                    "<br />" & sDescription & "<br />" & _
                    FormatDateTime(dFrom, DateFormat.LongDate) & " " & _
                    FormatDateTime(dFrom, DateFormat.ShortTime) & " - " & "<br />" & _
                    FormatDateTime(dTo, DateFormat.LongDate) & " " & _
                    FormatDateTime(dTo, DateFormat.ShortTime)
            End If
        End If
        Return sReturn
    End Function

    'Function ShowRepeat(ByVal sRepeat As String) As String
    '    If CInt(sRepeat = 2) Then
    '        Return ("<strong>Daily</strong><br/>")
    '    ElseIf CInt(sRepeat = 3) Then
    '        Return ("<strong>Weekly</strong><br/>")
    '    ElseIf CInt(sRepeat = 4) Then
    '        Return ("<strong>Monthly</strong><br/>")
    '    ElseIf CInt(sRepeat = 5) Then
    '        Return ("<strong>Yearly</strong><br/>")
    '    Else
    '        Return ("<br/>")
    '    End If
    'End Function

    Protected Sub lnkEmbedEvent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEmbedEvent.Click
        Response.Redirect(Me.LinkWorkspaceEventEmbed)
    End Sub

    Protected Sub gridviewEvents_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gridviewEvents.PageIndexChanging
        gridviewEvents.PageIndex = e.NewPageIndex
    End Sub

    Protected Sub btnDelete_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.ServerClick
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sID As String = hidEventID.Value
        Dim sqlCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        Dim nRepeat As Integer
        sqlCmd = New SqlCommand("SELECT * FROM events WHERE ((author = '" & GetUser().ToString & "') AND (event_id= '" & sID & "')) ", oConn)
        oConn.Open()
        oDataReader = sqlCmd.ExecuteReader()
        If oDataReader.Read() Then
            nRepeat = (CType(oDataReader("repeat"), Integer))
        Else
            Response.Redirect(Me.LinkWorkspaceEvents)
        End If
        oDataReader.Close()

        If nRepeat = 0 Then
            sqlCmd.CommandText = "DELETE FROM events WHERE event_id = @event_id "
            sqlCmd.CommandType = CommandType.Text
            sqlCmd.Parameters.Add("@event_id", SqlDbType.Int).Value = sID
            sqlCmd.ExecuteNonQuery()
            sqlCmd.Dispose()
        Else
            'Delete
            sqlCmd.CommandText = "DELETE FROM events WHERE event_id = @parent_event_id OR parent_id = @parent_event_id"
            sqlCmd.CommandType = CommandType.Text
            sqlCmd.Parameters.Add("@parent_event_id", SqlDbType.Int).Value = sID
            sqlCmd.ExecuteNonQuery()
            sqlCmd.Dispose()
        End If

        oConn.Close()

        Response.Redirect(Me.LinkWorkspaceEvents)
    End Sub

    Protected Sub gridviewEvents_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
</asp:Panel> 

<asp:Panel ID="panelEvents" runat="server" Visible=false>
<table>
<tr>
<td valign="top">
    <asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="#999999" Font-Names="Verdana" Font-Size="8pt" 
         ForeColor="Black" Height="180px" Width="200px" CellPadding="4" DayNameFormat="Shortest" SelectionMode="Day" Font-Bold="True"  >
        <SelectedDayStyle ForeColor="White" Font-Bold="True" BackColor="Orange" />
        <TodayDayStyle BackColor="#CCCCCC" />
        <OtherMonthDayStyle ForeColor="#8f8f8f" Font-Bold="False"    />
        <NextPrevStyle VerticalAlign="Bottom" />
        <DayHeaderStyle Font-Bold="True" Font-Size="7pt" BackColor="#CCCCCC" />
        <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
        <SelectorStyle BackColor="#CCCCCC" />
    </asp:Calendar>
</td>
<td>&nbsp;</td>
<td valign="top" style="width:400px">
    <asp:LinkButton ID="lnkNewEvent" meta:resourcekey="lnkNewEvent" runat="server" Text="New Event" ></asp:LinkButton> &nbsp;&nbsp;
    <asp:LinkButton ID="lnkLatest" meta:resourcekey="lnkLatest" runat="server" Text="Latest"></asp:LinkButton> &nbsp;&nbsp;
    <asp:LinkButton ID="lnkEmbedEvent" meta:resourcekey="lnkEmbedEvent" runat="server" Text="Embed Upcoming Event List"></asp:LinkButton> 
    <br /><br />
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    <SelectParameters>
    <asp:Parameter Name="date" Type="DateTime" /> 
    <asp:Parameter Name="root_id" Type="Int64"  /> 
    </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="gridviewEvents" DataSourceID="SqlDataSource1" PageSize="10" runat="server" AutoGenerateColumns=false ShowHeader="false" 
        GridLines="None" CellPadding="3" AllowPaging="true" PagerSettings-Visible="true" OnPreRender="gridviewEvents_PreRender">
        <Columns>
        <asp:TemplateField >
        <ItemTemplate>
            <%--<%#ShowRepeat(Eval("repeat", ""))%><br />--%><div style="margin:5px"></div>
            <%#ShowEvent(Eval("title", ""), Eval("description", ""), Eval("is_allday", ""), Eval("from_date", ""), Eval("to_date", ""), Eval("type", ""))%>
            <%#ShowMore(Eval("page","")) %>
            <%#ShowEdit(Eval("event_id", ""), Eval("author", ""))%><div style="margin:5px"></div>
        </ItemTemplate>  
        </asp:TemplateField>
        </Columns>
   </asp:GridView>
</td>
</tr>
</table>
<asp:HiddenField ID="hidEventID" runat="server" />
<input id="btnDelete" type="button" runat="server" style="display:none;" value="button" />
<br /><br />
</asp:Panel>
