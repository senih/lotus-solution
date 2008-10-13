<%@ Page Language="VB"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private intPageId As Integer
    Private nTimeOffset As Double = 0
    
    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            'Authorization
            If Not Session(Request.QueryString("pg").ToString) Then
                'Session(nPageId.ToString) akan = true jika page bisa dibuka (di default.aspx/vb)
                Response.Write("Authorization Failed.")
                Response.End()
            End If
        End If
    End Sub
    
    
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs)
        intPageId = CInt(Request.QueryString("pg"))
        
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        
        oConn = New SqlConnection(sConn)
        oConn.Open()
        
        Dim nRootId As Integer
        sSQL = "SELECT * FROM pages_working where page_id=" & intPageId
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            nRootId = oDataReader("root_id")
        End If
        oDataReader.Close()
        
        sSQL = "SELECT locales.time_offset FROM pages_working INNER JOIN locales ON pages_working.file_name = locales.home_page WHERE pages_working.root_id=" & nRootId
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            nTimeOffset = oDataReader("time_offset")
        End If
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RedirectForLogin()
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        lblStartPublishing.Text = GetLocalResourceObject("lblStartPublishing.Text")
        rdoStartImmediately.Text = GetLocalResourceObject("rdoStartImmediately.Text")
        lblStopPublishing.Text = GetLocalResourceObject("lblStopPublishing.Text")
        rdoStopNever.Text = GetLocalResourceObject("rdoStopNever.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        
        intPageId = CInt(Request.QueryString("pg"))
        
        If Not Page.IsPostBack Then
            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(intPageId)
            Dim nullDate As DateTime = Nothing

            Dim dStart As Date
            Dim dStop As Date
            If (Not contentLatest.PublishStart.Equals(nullDate)) Then
                dStart = contentLatest.PublishStart.AddHours(nTimeOffset)
                calStart.SelectedDate = New Date(dStart.Year, dStart.Month, dStart.Day)
                rdoStartSpecified.Checked = True
            Else
                dStart = DateTime.Today.AddHours(nTimeOffset)
                calStart.SelectedDate = New Date(dStart.Year, dStart.Month, dStart.Day)
                rdoStartImmediately.Checked = True
            End If
            If (Not contentLatest.PublishEnd.Equals(nullDate)) Then
                dStop = contentLatest.PublishEnd.AddHours(nTimeOffset)
                calStop.SelectedDate = New Date(dStop.Year, dStop.Month, dStop.Day)
                rdoStopSpecified.Checked = True
            Else
                dStop = DateTime.Today.AddHours(nTimeOffset)
                calStop.SelectedDate = New Date(dStop.Year, dStop.Month, dStop.Day)
                rdoStopNever.Checked = True
            End If

            contentLatest = Nothing
            oContentManager = Nothing
        End If
    End Sub

    Protected Sub calStart_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles calStart.SelectionChanged
        rdoStartSpecified.Checked = True
    End Sub

    Protected Sub calStop_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles calStop.SelectionChanged
        rdoStopSpecified.Checked = True
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(intPageId)

        Dim publishStart As DateTime = Nothing
        Dim publishEnd As DateTime = Nothing

        If rdoStartImmediately.Checked Then
            publishStart = Nothing
        ElseIf rdoStartSpecified.Checked Then
            publishStart = calStart.SelectedDate.AddHours(-nTimeOffset)
        End If
        If rdoStopNever.Checked Then
            publishEnd = Nothing
        ElseIf rdoStopSpecified.Checked Then
            publishEnd = calStop.SelectedDate.AddHours(-nTimeOffset)
        End If
        oContentManager.SetPublishingDate(intPageId, contentLatest.Version, publishStart, publishEnd)

        contentLatest = Nothing
        oContentManager = Nothing

        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")
    End Sub

</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script>
    function adjustHeight()
        {
        if(navigator.appName.indexOf('Microsoft')!=-1)
            document.getElementById('cellContent').height=200;
        else
            document.getElementById('cellContent').height=460;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:0px;background-color:#E6E7E8">
<form id="form1" runat="server">

<table style="width:100%;" cellpadding=0 cellspacing=0>
<tr>
<td id=cellContent valign=top>

    <table width="100%" cellpadding=3>
    <tr>
        <td nowrap="nowrap"><asp:Label ID="lblStartPublishing" meta:resourcekey="lblStartPublishing" runat="server" Text="Start Publishing"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:RadioButton ID="rdoStartImmediately" GroupName="groupStart" Checked=true meta:resourcekey="rdoStartImmediately" runat="server" Text="Immediately" />
        </td>
    </tr>
    <tr>
        <td colspan=2></td>
        <td>
            <asp:RadioButton ID="rdoStartSpecified" Enabled=false GroupName="groupStart" runat="server" Text="" />
            <div style="margin:5px"></div>
            <asp:Calendar ID="calStart" runat="server"></asp:Calendar>
        </td>
    </tr>
    <tr>
        <td nowrap="nowrap"><asp:Label ID="lblStopPublishing" meta:resourcekey="lblStopPublishing" runat="server" Text="Stop Publishing"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:RadioButton ID="rdoStopNever" GroupName="groupStop" Checked=true meta:resourcekey="rdoStopNever" runat="server" Text="Never" />
        </td>
    </tr>
    <tr>
        <td colspan=2></td>
        <td>
            <asp:RadioButton ID="rdoStopSpecified" Enabled=false GroupName="groupStop" runat="server" Text="" />
            <div style="margin:5px"></div>
            <asp:Calendar ID="calStop" runat="server" ></asp:Calendar>
        </td>
    </tr>
</table>

</td>
</tr>
<tr>
<td align=right style="padding:10px;padding-right:15px">  
    <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold=true></asp:Label>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" OnClientClick="parent.icCloseDlg();return false;" Text=" Close " />
    <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
</td>
</tr>
</table>

</form>
</body>
</html>