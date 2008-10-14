<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat=server>
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private arrUserRoles() As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsNothing(GetUser()) Then

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

            Dim nMonth As Integer = Date.Now.Month
            Dim nDay As Integer = Date.Now.Day
            Dim nYear As Integer = Date.Now.Year
            Dim nHour As Integer = Date.Now.Hour
            Dim nMinutes As Integer = Date.Now.Minute
            Dim sName As String = GetUser.UserName.ToString

            panelLogin.Visible = False
            panelNewEvent.Visible = True

            If Roles.IsUserInRole(sName, "Administrators") Or Roles.IsUserInRole(sName, "Events Managers") Then
                ddlType.Enabled = True
            Else
                ddlType.Enabled = False
            End If

            ddlMonth.SelectedValue = nMonth
            ddlDay.SelectedValue = nDay
            ddlYear.SelectedValue = nYear
            ddlMonth2.SelectedValue = nMonth
            ddlDay2.SelectedValue = nDay
            ddlYear2.SelectedValue = nYear
            ddlMonth3.SelectedValue = nMonth
            ddlDay3.SelectedValue = nDay
            ddlYear3.SelectedValue = nYear
            ddlHour.SelectedValue = nHour
            'ddlMinute.SelectedValue = nMinutes
            ddlHour2.SelectedValue = nHour
            'ddlMinute2.SelectedValue = nMinutes

            ddlRepeat.Attributes.Add("onchange", "repeat(document.getElementById('" & ddlDay.ClientID & "'), document.getElementById('" & ddlMonth.ClientID & "'), document.getElementById('" & ddlYear.ClientID & "')," & _
                       " document.getElementById('" & ddlDay2.ClientID & "'), document.getElementById('" & ddlMonth2.ClientID & "'), document.getElementById('" & ddlYear2.ClientID & "')," & _
                       " document.getElementById('" & ddlDay3.ClientID & "'), document.getElementById('" & ddlMonth3.ClientID & "'), document.getElementById('" & ddlYear3.ClientID & "'));" & _
                       "changeRepeat(this.value,document.getElementById('" & panelUntil.ClientID & "'))")

            ddlMonth.Attributes.Add("onchange", "validateDate(document.getElementById('" & ddlDay.ClientID & "'), document.getElementById('" & ddlMonth.ClientID & "'), document.getElementById('" & ddlYear.ClientID & "'));document.getElementById('" & ddlRepeat.ClientID & "').onchange();")
            ddlDay.Attributes.Add("onchange", "document.getElementById('" & ddlMonth.ClientID & "').onchange();")
            ddlYear.Attributes.Add("onchange", "document.getElementById('" & ddlMonth.ClientID & "').onchange();")

            ddlMonth2.Attributes.Add("onchange", "validateDate(document.getElementById('" & ddlDay2.ClientID & "'), document.getElementById('" & ddlMonth2.ClientID & "'), document.getElementById('" & ddlYear2.ClientID & "'));document.getElementById('" & ddlRepeat.ClientID & "').onchange();")
            ddlDay2.Attributes.Add("onchange", "document.getElementById('" & ddlMonth2.ClientID & "').onchange();")
            ddlYear2.Attributes.Add("onchange", "document.getElementById('" & ddlMonth2.ClientID & "').onchange();")

            ddlMonth3.Attributes.Add("onchange", "validateDate(document.getElementById('" & ddlDay3.ClientID & "'), document.getElementById('" & ddlMonth3.ClientID & "'), document.getElementById('" & ddlYear3.ClientID & "'));document.getElementById('" & ddlRepeat.ClientID & "').onchange();")
            ddlDay3.Attributes.Add("onchange", "document.getElementById('" & ddlMonth3.ClientID & "').onchange();")
            ddlYear3.Attributes.Add("onchange", "document.getElementById('" & ddlMonth3.ClientID & "').onchange();")

            ddlHour.Attributes.Add("onchange", "validateTime(document.getElementById('" & ddlHour.ClientID & "'), document.getElementById('" & ddlMinute.ClientID & "'), document.getElementById('" & ddlHour2.ClientID & "'),document.getElementById('" & ddlMinute2.ClientID & "'))")
            ddlMinute.Attributes.Add("onchange", "document.getElementById('" & ddlHour.ClientID & "').onchange();")
            ddlHour2.Attributes.Add("onchange", "document.getElementById('" & ddlHour.ClientID & "').onchange();")
            ddlMinute2.Attributes.Add("onchange", "document.getElementById('" & ddlHour.ClientID & "').onchange();")

            ckbAlldDay.Attributes.Add("onClick", "checkAllDay(document.getElementById('" & ckbAlldDay.ClientID & "'),document.getElementById('" & panelTime.ClientID & "'), document.getElementById('" & panelTime2.ClientID & "'))")
            btnSave.Attributes.Add("onClick", "document.getElementById('" & ddlRepeat.ClientID & "').onchange();")

            panelUntil.Style.Add("display", "none")
        Else
            panelLogin.Visible = True
            panelNewEvent.Visible = False
        End If
    End Sub

  Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sName As String = GetUser.UserName.ToString

        Dim sqlCmd As SqlCommand
        Dim StrSQL As String
        Dim nReminder As Integer = 0
        Dim dtFromDate As DateTime
        Dim dtToDate As DateTime

        If ckbAlldDay.Checked Then 'All day
            dtFromDate = New DateTime(ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlDay.SelectedValue, 0, 0, 0)
            dtToDate = New DateTime(ddlYear2.SelectedValue, ddlMonth2.SelectedValue, ddlDay2.SelectedValue, 23, 55, 55)
        Else
            dtFromDate = New DateTime(ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlDay.SelectedValue, ddlHour.SelectedValue, ddlMinute.SelectedValue, 0)
            dtToDate = New DateTime(ddlYear2.SelectedValue, ddlMonth2.SelectedValue, ddlDay2.SelectedValue, ddlHour2.SelectedValue, ddlMinute2.SelectedValue, 0)
        End If

        Dim dtUntilDate As DateTime = New DateTime(ddlYear3.SelectedValue, ddlMonth3.SelectedValue, ddlDay3.SelectedValue, 23, 59, 0) '23,59,59 tdk bisa krn dibulatkan mjd 24,0,0. Yg penting hrs lebih besar dari 23,55,55
        Dim dtFromDate2 As DateTime = dtFromDate

        'If txtReminder.Text = "" Then
        '    nReminder = 0
        'Else
        '    nReminder = CInt(txtReminder.Text)
        'End If

        Dim sFromDate As String = dtFromDate.Date
        Dim sToDate As String = dtToDate.Date

        oConn.Open()
        StrSQL = "insert into events(title, description, is_allday, from_date,to_date,repeat,until,reminder,reminder_id,page,type,author,parent_id,root_id) " & _
                "values (@title, @description, @is_allday, @from_date, @to_date, @repeat, @until, @reminder,@reminder_id, @page, @type, " & _
                "@author,@parent_id,@root_id) select @@Identity as new_event_id"
        sqlCmd = New SqlCommand(StrSQL, oConn)
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.Parameters.Add("@title", SqlDbType.NVarChar).Value = txtTitle.Text
        sqlCmd.Parameters.Add("@description", SqlDbType.NVarChar).Value = txtDescription.Text
        sqlCmd.Parameters.Add("@is_allday", SqlDbType.Bit).Value = ckbAlldDay.Checked
        sqlCmd.Parameters.Add("@from_date", SqlDbType.DateTime).Value = dtFromDate
        sqlCmd.Parameters.Add("@to_date", SqlDbType.DateTime).Value = dtToDate
        sqlCmd.Parameters.Add("@repeat", SqlDbType.Int).Value = ddlRepeat.SelectedValue
        sqlCmd.Parameters.Add("@until", SqlDbType.DateTime).Value = dtUntilDate
        sqlCmd.Parameters.Add("@reminder", SqlDbType.Int).Value = nReminder
        sqlCmd.Parameters.Add("@reminder_id", SqlDbType.Int).Value = 1 'ddlReminder.SelectedValue
        sqlCmd.Parameters.Add("@page", SqlDbType.NVarChar).Value = txtPage.Text
        sqlCmd.Parameters.Add("@type", SqlDbType.Int).Value = ddlType.SelectedValue
        sqlCmd.Parameters.Add("@author", SqlDbType.NVarChar).Value = sName
        sqlCmd.Parameters.Add("@parent_id", SqlDbType.NVarChar).Value = 0 'Parent Event
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID

        'Get Newly Created Event ID
        Dim nNewEventId As Long = 0
        Dim rowsAffected As Integer
        Dim dataReader As SqlDataReader = sqlCmd.ExecuteReader()
        While dataReader.Read
            nNewEventId = dataReader("new_event_id")
            rowsAffected = 1
        End While
        dataReader.Close()

        If Not (ddlRepeat.SelectedValue = 1) Then 'Selain repeat=none
            'Adjustment??
            'If ckbAlldDay.Checked Then
            '    dtUntilDate = dtUntilDate.AddDays(-1)
            'End If
            'Recursive
            Do While (dtFromDate2 <= dtUntilDate)
                If ddlRepeat.SelectedValue = 2 Then ' daily
                    dtFromDate = dtFromDate.AddDays(1)
                    dtFromDate2 = dtFromDate.AddDays(1)
                    dtToDate = dtToDate.AddDays(1)
                ElseIf ddlRepeat.SelectedValue = 3 Then ' weekly
                    dtFromDate = dtFromDate.AddDays(7)
                    dtFromDate2 = dtFromDate.AddDays(7)
                    dtToDate = dtToDate.AddDays(7)
                ElseIf ddlRepeat.SelectedValue = 4 Then 'monthly
                    dtFromDate = dtFromDate.AddMonths(1)
                    dtFromDate2 = dtFromDate.AddMonths(1)
                    dtToDate = dtToDate.AddMonths(1)
                ElseIf ddlRepeat.SelectedValue = 5 Then 'yearly
                    dtFromDate = dtFromDate.AddYears(1)
                    dtFromDate2 = dtFromDate.AddYears(1)
                    dtToDate = dtToDate.AddYears(1)
                End If
                sqlCmd.Parameters.Item("@root_id").Value = Me.RootID
                sqlCmd.Parameters.Item("@from_date").Value = dtFromDate
                sqlCmd.Parameters.Item("@to_date").Value = dtToDate
                sqlCmd.Parameters.Item("@title").Value = txtTitle.Text
                sqlCmd.Parameters.Item("@description").Value = txtDescription.Text
                sqlCmd.Parameters.Item("@is_allday").Value = ckbAlldDay.Checked
                sqlCmd.Parameters.Item("@repeat").Value = 0
                sqlCmd.Parameters.Item("@until").Value = dtUntilDate
                sqlCmd.Parameters.Item("@reminder").Value = nReminder
                sqlCmd.Parameters.Item("@reminder_id").Value = 1 'ddlReminder.SelectedValue
                sqlCmd.Parameters.Item("@page").Value = txtPage.Text
                sqlCmd.Parameters.Item("@type").Value = ddlType.SelectedValue
                sqlCmd.Parameters.Item("@author").Value = sName
                sqlCmd.Parameters.Item("@parent_id").Value = nNewEventId 'Child Event
                sqlCmd.ExecuteNonQuery()
                sqlCmd.Dispose()
            Loop
        End If
        oConn.Close()
        Response.Redirect(Me.LinkWorkspaceEvents)
 
  End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(Me.LinkWorkspaceEvents)
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

<asp:Panel ID="panelNewEvent" runat="server" Visible="False">
<table>
<tr>
    <td><asp:Label ID="lblTitle" meta:resourcekey="lblTitle" runat="server" Text="Title"></asp:Label></td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="*" ValidationGroup="Events" ControlToValidate="txtTitle">*</asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td valign=top><asp:Label ID="lblDescription" meta:resourcekey="lblDescription" runat="server" Text="Description"></asp:Label></td>
    <td valign=top>:</td>
    <td valign=top>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="300px" Height="50px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ErrorMessage="*" ValidationGroup="Events" ControlToValidate="txtDescription">*</asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblAllDay" meta:resourcekey="lblAllDay" runat="server" Text="All Day"></asp:Label></td>
    <td>:</td>
   <td><asp:CheckBox ID="ckbAlldDay" runat="server" /></td>
</tr>
<tr>
    <td><asp:Label ID="lblFrom" meta:resourcekey="lblFrom" runat="server" Text="From"></asp:Label></td>
    <td>:</td>
    <td> 
        <table cellpadding=0 cellspacing=0>
        <tr>
        <td></td>
        <td>
        <asp:DropDownList ID="ddlMonth" runat="server">
        <asp:ListItem Text="1" Value="1"></asp:ListItem>
        <asp:ListItem Text="2" Value="2"></asp:ListItem>
        <asp:ListItem Text="3" Value="3"></asp:ListItem>
        <asp:ListItem Text="4" Value="4"></asp:ListItem>
        <asp:ListItem Text="5" Value="5"></asp:ListItem>
        <asp:ListItem Text="6" Value="6"></asp:ListItem>
        <asp:ListItem Text="7" Value="7"></asp:ListItem>
        <asp:ListItem Text="8" Value="8"></asp:ListItem>
        <asp:ListItem Text="9" Value="9"></asp:ListItem>
        <asp:ListItem Text="10" Value="10"></asp:ListItem>
        <asp:ListItem Text="11" Value="11"></asp:ListItem>
        <asp:ListItem Text="12" Value="12"></asp:ListItem>
        </asp:DropDownList>&nbsp;
        </td>
        <td>/&nbsp;</td>
        <td>
        <asp:DropDownList ID="ddlDay" runat="server">
        <asp:ListItem Text="1" Value="1"></asp:ListItem>
        <asp:ListItem Text="2" Value="2"></asp:ListItem>
        <asp:ListItem Text="3" Value="3"></asp:ListItem>
        <asp:ListItem Text="4" Value="4"></asp:ListItem>
        <asp:ListItem Text="5" Value="5"></asp:ListItem>
        <asp:ListItem Text="6" Value="6"></asp:ListItem>
        <asp:ListItem Text="7" Value="7"></asp:ListItem>
        <asp:ListItem Text="8" Value="8"></asp:ListItem>
        <asp:ListItem Text="9" Value="9"></asp:ListItem>
        <asp:ListItem Text="10" Value="10"></asp:ListItem>
        <asp:ListItem Text="11" Value="11"></asp:ListItem>
        <asp:ListItem Text="12" Value="12"></asp:ListItem>
        <asp:ListItem Text="13" Value="13"></asp:ListItem>
        <asp:ListItem Text="14" Value="14"></asp:ListItem>
        <asp:ListItem Text="15" Value="15"></asp:ListItem>
        <asp:ListItem Text="16" Value="16"></asp:ListItem>
        <asp:ListItem Text="17" Value="17"></asp:ListItem>
        <asp:ListItem Text="18" Value="18"></asp:ListItem>
        <asp:ListItem Text="19" Value="19"></asp:ListItem>
        <asp:ListItem Text="20" Value="20"></asp:ListItem>
        <asp:ListItem Text="21" Value="21"></asp:ListItem>
        <asp:ListItem Text="22" Value="22"></asp:ListItem>
        <asp:ListItem Text="23" Value="23"></asp:ListItem>
        <asp:ListItem Text="24" Value="24"></asp:ListItem>
        <asp:ListItem Text="25" Value="25"></asp:ListItem>
        <asp:ListItem Text="26" Value="26"></asp:ListItem>
        <asp:ListItem Text="27" Value="27"></asp:ListItem>
        <asp:ListItem Text="28" Value="28"></asp:ListItem>
        <asp:ListItem Text="29" Value="29"></asp:ListItem>
        <asp:ListItem Text="30" Value="30"></asp:ListItem>
        <asp:ListItem Text="31" Value="31"></asp:ListItem>
        </asp:DropDownList>&nbsp;
        </td>
        <td>/&nbsp;</td>
        <td>
        <asp:DropDownList ID="ddlYear" runat="server">
        <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
        <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
        <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
        <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
        <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
        <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
        <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
        <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
        <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
        <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
        <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
        <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
        <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
        </asp:DropDownList>
        </td>
        <td>
            <asp:Panel ID="panelTime" runat="server">
            <table><tr><td>&nbsp;<asp:Label ID="lblAt" meta:resourcekey="lblAt" runat="server" Text="at"></asp:Label> &nbsp;</td>
            <td>
            <asp:DropDownList ID="ddlHour" runat="server">
                <asp:ListItem Text="00" Value="0"></asp:ListItem>
                <asp:ListItem Text="01" Value="1"></asp:ListItem>
                <asp:ListItem Text="02" Value="2"></asp:ListItem>
                <asp:ListItem Text="03" Value="3"></asp:ListItem>
                <asp:ListItem Text="04" Value="4"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="06" Value="6"></asp:ListItem>
                <asp:ListItem Text="07" Value="7"></asp:ListItem>
                <asp:ListItem Text="08" Value="8"></asp:ListItem>
                <asp:ListItem Text="09" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                <asp:ListItem Text="13" Value="13"></asp:ListItem>
                <asp:ListItem Text="14" Value="14"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="16" Value="16"></asp:ListItem>
                <asp:ListItem Text="17" Value="17"></asp:ListItem>
                <asp:ListItem Text="18" Value="18"></asp:ListItem>
                <asp:ListItem Text="19" Value="19"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="21" Value="21"></asp:ListItem>
                <asp:ListItem Text="22" Value="22"></asp:ListItem>
                <asp:ListItem Text="23" Value="23"></asp:ListItem>
            </asp:DropDownList> 
            </td><td>:</td>
            <td>
            <asp:DropDownList ID="ddlMinute" runat="server">
                <asp:ListItem Text="00" Value="0"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="25" Value="25"></asp:ListItem>
                <asp:ListItem Text="30" Value="30"></asp:ListItem>
                <asp:ListItem Text="35" Value="35"></asp:ListItem>
                <asp:ListItem Text="40" Value="40"></asp:ListItem>
                <asp:ListItem Text="45" Value="45"></asp:ListItem>
                <asp:ListItem Text="50" Value="50"></asp:ListItem>
                <asp:ListItem Text="55" Value="55"></asp:ListItem>
            </asp:DropDownList>
            </td>
            </tr></table>
            </asp:Panel>
        </td>
        </tr>
        </table>
        <script>
            var _daysInMonth=[31,28,31,30,31,30,31,31,30,31,30,31];
            function isLeapYear(year) { return ((year%4) == 0);}
            function validateDate(idDate, idMonth, idYear) 
                {
                var year = idYear.value;
                var month = idMonth.value;
                var day = idDate.value;
                
                var numDate=_daysInMonth[month-1];
                if (month==2 && isLeapYear(year)) numDate++;
                if (idDate.value>numDate) {idDate.value=numDate;}    
                }
        </script>
        <script>
            function checkAllDay(idAllDay,idPanel1,idPanel2)
                {
                if (idAllDay.checked == true)
                    {
                    idPanel1.style.display = "none";
                    idPanel2.style.display = "none";
                    }
                else
                    {
                    idPanel1.style.display = "block";
                    idPanel2.style.display = "block";
                    }
                }
        </script>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblTo" meta:resourcekey="lblTo" runat="server" Text="To"></asp:Label></td>
    <td>:</td>
    <td> 
        <table cellpadding=0 cellspacing=0>
        <tr>
        <td></td>
        <td>
        <asp:DropDownList ID="ddlMonth2" runat="server">
        <asp:ListItem Text="1" Value="1"></asp:ListItem>
        <asp:ListItem Text="2" Value="2"></asp:ListItem>
        <asp:ListItem Text="3" Value="3"></asp:ListItem>
        <asp:ListItem Text="4" Value="4"></asp:ListItem>
        <asp:ListItem Text="5" Value="5"></asp:ListItem>
        <asp:ListItem Text="6" Value="6"></asp:ListItem>
        <asp:ListItem Text="7" Value="7"></asp:ListItem>
        <asp:ListItem Text="8" Value="8"></asp:ListItem>
        <asp:ListItem Text="9" Value="9"></asp:ListItem>
        <asp:ListItem Text="10" Value="10"></asp:ListItem>
        <asp:ListItem Text="11" Value="11"></asp:ListItem>
        <asp:ListItem Text="12" Value="12"></asp:ListItem>
        </asp:DropDownList>&nbsp;
        </td>
        <td>/&nbsp;</td>
        <td>
        <asp:DropDownList ID="ddlDay2" runat="server">
        <asp:ListItem Text="1" Value="1"></asp:ListItem>
        <asp:ListItem Text="2" Value="2"></asp:ListItem>
        <asp:ListItem Text="3" Value="3"></asp:ListItem>
        <asp:ListItem Text="4" Value="4"></asp:ListItem>
        <asp:ListItem Text="5" Value="5"></asp:ListItem>
        <asp:ListItem Text="6" Value="6"></asp:ListItem>
        <asp:ListItem Text="7" Value="7"></asp:ListItem>
        <asp:ListItem Text="8" Value="8"></asp:ListItem>
        <asp:ListItem Text="9" Value="9"></asp:ListItem>
        <asp:ListItem Text="10" Value="10"></asp:ListItem>
        <asp:ListItem Text="11" Value="11"></asp:ListItem>
        <asp:ListItem Text="12" Value="12"></asp:ListItem>
        <asp:ListItem Text="13" Value="13"></asp:ListItem>
        <asp:ListItem Text="14" Value="14"></asp:ListItem>
        <asp:ListItem Text="15" Value="15"></asp:ListItem>
        <asp:ListItem Text="16" Value="16"></asp:ListItem>
        <asp:ListItem Text="17" Value="17"></asp:ListItem>
        <asp:ListItem Text="18" Value="18"></asp:ListItem>
        <asp:ListItem Text="19" Value="19"></asp:ListItem>
        <asp:ListItem Text="20" Value="20"></asp:ListItem>
        <asp:ListItem Text="21" Value="21"></asp:ListItem>
        <asp:ListItem Text="22" Value="22"></asp:ListItem>
        <asp:ListItem Text="23" Value="23"></asp:ListItem>
        <asp:ListItem Text="24" Value="24"></asp:ListItem>
        <asp:ListItem Text="25" Value="25"></asp:ListItem>
        <asp:ListItem Text="26" Value="26"></asp:ListItem>
        <asp:ListItem Text="27" Value="27"></asp:ListItem>
        <asp:ListItem Text="28" Value="28"></asp:ListItem>
        <asp:ListItem Text="29" Value="29"></asp:ListItem>
        <asp:ListItem Text="30" Value="30"></asp:ListItem>
        <asp:ListItem Text="31" Value="31"></asp:ListItem>
        </asp:DropDownList>&nbsp;
        </td>
        <td>/&nbsp;</td>
        <td>
        <asp:DropDownList ID="ddlYear2" runat="server">
        <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
        <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
        <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
        <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
        <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
        <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
        <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
        <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
        <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
        <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
        <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
        <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
        <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
        </asp:DropDownList>
        </td>
        <td>
            <asp:Panel ID="panelTime2" runat="server" >
            <table><tr>
             <td>&nbsp;<asp:Label ID="lblAt2" meta:resourcekey="lblAt" runat="server" Text="at"></asp:Label> &nbsp;</td>
        <td>
            <asp:DropDownList ID="ddlHour2" runat="server">
                <asp:ListItem Text="00" Value="0"></asp:ListItem>
                <asp:ListItem Text="01" Value="1"></asp:ListItem>
                <asp:ListItem Text="02" Value="2"></asp:ListItem>
                <asp:ListItem Text="03" Value="3"></asp:ListItem>
                <asp:ListItem Text="04" Value="4"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="06" Value="6"></asp:ListItem>
                <asp:ListItem Text="07" Value="7"></asp:ListItem>
                <asp:ListItem Text="08" Value="8"></asp:ListItem>
                <asp:ListItem Text="09" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                <asp:ListItem Text="13" Value="13"></asp:ListItem>
                <asp:ListItem Text="14" Value="14"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="16" Value="16"></asp:ListItem>
                <asp:ListItem Text="17" Value="17"></asp:ListItem>
                <asp:ListItem Text="18" Value="18"></asp:ListItem>
                <asp:ListItem Text="19" Value="19"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="21" Value="21"></asp:ListItem>
                <asp:ListItem Text="22" Value="22"></asp:ListItem>
                <asp:ListItem Text="23" Value="23"></asp:ListItem>
                
            </asp:DropDownList>
        </td><td>:</td>
        <td>
            <asp:DropDownList ID="ddlMinute2" runat="server">
                <asp:ListItem Text="00" Value="0"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="25" Value="25"></asp:ListItem>
                <asp:ListItem Text="30" Value="30"></asp:ListItem>
                <asp:ListItem Text="35" Value="35"></asp:ListItem>
                <asp:ListItem Text="40" Value="40"></asp:ListItem>
                <asp:ListItem Text="45" Value="45"></asp:ListItem>
                <asp:ListItem Text="50" Value="50"></asp:ListItem>
                <asp:ListItem Text="55" Value="55"></asp:ListItem>
            </asp:DropDownList>
        </td>
        </tr>
        </table>
        </asp:Panel>
        </td>
        </tr>
        </table>
     </td>
</tr>
<tr>
    <td><asp:Label ID="lblRepeat" meta:resourcekey="lblRepeat" runat="server" Text="Repeat"></asp:Label></td>
    <td>:</td>
    <td>
        <table cellpadding=0 cellspacing=0>
        <tr>
        <td>
            <asp:DropDownList ID="ddlRepeat" runat="server">
                <asp:ListItem meta:resourcekey="optNone" Value="1" Text="None" ></asp:ListItem>
                <asp:ListItem meta:resourcekey="optEveryDay" Value="2" Text="Every day" ></asp:ListItem>
                <asp:ListItem meta:resourcekey="optEveryWeek" Value="3" Text="Every week" ></asp:ListItem>
                <asp:ListItem meta:resourcekey="optEveryMonth" Value="4" Text="Every month" ></asp:ListItem>
                <asp:ListItem meta:resourcekey="optEveryYear" Value="5" Text="Every year" ></asp:ListItem>
            </asp:DropDownList> &nbsp;    
            <script language=javascript>
            function changeRepeat(val,panelUntil)
                {
                if(val==1)
                    {
                    panelUntil.style.display="none";
                    }
                else
                    {
                    panelUntil.style.display="";
                    }
                }            
            </script>  
        </td>
        <td>
            <asp:Panel ID="panelUntil" runat="server">
            <table cellpadding=0 cellspacing=0>
            <tr>
            <td><asp:Label ID="lblUntil" meta:resourcekey="lblUntil" runat="server" Text="Until"></asp:Label> :&nbsp;</td>
            <td>
                 <table cellpadding=0 cellspacing=0>
                <tr>
                <td></td>
                <td>
                <asp:DropDownList ID="ddlMonth3" runat="server">
                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                <asp:ListItem Text="9" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                </asp:DropDownList>&nbsp;
                </td>
                <td>/&nbsp;</td>
                <td>
                <asp:DropDownList ID="ddlDay3" runat="server">
                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                <asp:ListItem Text="9" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                <asp:ListItem Text="13" Value="13"></asp:ListItem>
                <asp:ListItem Text="14" Value="14"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="16" Value="16"></asp:ListItem>
                <asp:ListItem Text="17" Value="17"></asp:ListItem>
                <asp:ListItem Text="18" Value="18"></asp:ListItem>
                <asp:ListItem Text="19" Value="19"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="21" Value="21"></asp:ListItem>
                <asp:ListItem Text="22" Value="22"></asp:ListItem>
                <asp:ListItem Text="23" Value="23"></asp:ListItem>
                <asp:ListItem Text="24" Value="24"></asp:ListItem>
                <asp:ListItem Text="25" Value="25"></asp:ListItem>
                <asp:ListItem Text="26" Value="26"></asp:ListItem>
                <asp:ListItem Text="27" Value="27"></asp:ListItem>
                <asp:ListItem Text="28" Value="28"></asp:ListItem>
                <asp:ListItem Text="29" Value="29"></asp:ListItem>
                <asp:ListItem Text="30" Value="30"></asp:ListItem>
                <asp:ListItem Text="31" Value="31"></asp:ListItem>
                </asp:DropDownList>&nbsp;
                </td>
                <td>/&nbsp;</td>
                <td>
                <asp:DropDownList ID="ddlYear3" runat="server">
                <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
                <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
                <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
                <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
                <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
                <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
                <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
                <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
                <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
                <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
                <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                </asp:DropDownList>
                </td>
                </tr>
                </table>        
            </td>
            </tr>
            </table>  
            </asp:Panel>      
        </td>
        </tr>
        </table>
        
        <script>
            function repeat(idDay1,idMonth1,idYear1,idDay2,idMonth2,idYear2,idDay3,idMonth3,idYear3)
                {
                if (parseInt(idYear1.value) >= parseInt(idYear2.value))
                    {
                    idYear2.value = idYear1.value;
                    if (parseInt(idMonth1.value) >= parseInt(idMonth2.value))
                        {
                        idMonth2.value = idMonth1.value; 
                        if (parseInt(idDay1.value) >= parseInt(idDay2.value))
                            {idDay2.value = idDay1.value;}
                        }
                    }
                 if (parseInt(idYear2.value) >= parseInt(idYear3.value))
                    {
                    idYear3.value = idYear2.value;
                    if (parseInt(idMonth2.value) >= parseInt(idMonth3.value))
                        {
                        idMonth3.value = idMonth2.value; 
                        if (parseInt(idDay2.value) >= parseInt(idDay3.value))
                            {idDay3.value = idDay2.value;}
                        }
                    }   
                }
        </script>
        
        <script>
            function validateTime(idHour,idMinute,idHour2,idMinute2)
                {
                if (parseInt(idHour.value) >= parseInt(idHour2.value))
                    {
                    idHour2.value = idHour.value;
                    if (parseInt(idMinute.value) >= parseInt(idMinute2.value))
                        idMinute2.value = idMinute.value; 
                    }
                }
        </script>        
    </td>
</tr>
<%--<tr>
    <td>Reminder</td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtReminder" runat="server" Width="30px" Visible=false></asp:TextBox>&nbsp;
        <asp:DropDownList ID="ddlReminder" runat="server" Visible=false>
            <asp:ListItem Value="1" Text="minutes before"></asp:ListItem>
            <asp:ListItem Value="2" Text="hours before"></asp:ListItem>
            <asp:ListItem Value="3" Text="days before"></asp:ListItem>
        </asp:DropDownList>
    </td>
</tr>--%>
<tr>
    <td><asp:Label ID="lblLinkToPage" meta:resourcekey="lblLinkToPage" runat="server" Text="Link to page"></asp:Label></td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtPage" runat="server"></asp:TextBox>
        <asp:Label ID="lblEg" meta:resourcekey="lblEg" runat="server" Text="(eg. page.aspx)"></asp:Label>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblType" meta:resourcekey="lblType" runat="server" Text="Type"></asp:Label></td>
    <td>:</td>
    <td>
        <asp:DropDownList ID="ddlType" runat="server" >
            <asp:ListItem meta:resourcekey="optPrivate" Value="1" Text="Private"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optPublic" Value="2" Text="Public"></asp:ListItem>
        </asp:DropDownList>
    </td>
</tr>
</table>
<br />
<asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " ValidationGroup="Events" />
<asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " CausesValidation=false />
<br /><br />
</asp:Panel>
