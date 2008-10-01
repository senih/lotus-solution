<%@ Page Language="VB"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Private nPageId As Integer

    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            If Not Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                Response.End()
            End If
        End If
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
        lblChannel.Text = GetLocalResourceObject("lblChannel.Text")
        chkApplyAllSubs.Text = GetLocalResourceObject("chkApplyAllSubs.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        
        Dim oList As ListItem

        nPageId = CInt(Request.QueryString("pg"))

        If Not Page.IsPostBack Then
            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(nPageId)

            Dim oChannelManager As ChannelManager = New ChannelManager
            Dim oDataReader As SqlDataReader
            oDataReader = oChannelManager.GetChannels()
            Do While oDataReader.Read()
                oList = New ListItem
                oList.Value = oDataReader("channel_id").ToString
                oList.Text = oDataReader("channel_name").ToString
                dropChannels.Items.Add(oList)
            Loop
            oDataReader.Close()
            oDataReader = Nothing

            dropChannels.SelectedValue = contentLatest.ChannelId

            btnClose.OnClientClick = "self.close()"
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        lblSaveStatus.Text = ""

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        If chkApplyAllSubs.Checked Then
            oContentManager.ChangePageChannel(nPageId, contentLatest.Version, dropChannels.SelectedValue, True)
        Else
            oContentManager.ChangePageChannel(nPageId, contentLatest.Version, dropChannels.SelectedValue, False)
        End If

        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")

        btnClose.OnClientClick = "closeAndRefresh('" & contentLatest.FileName & "');return false"

        contentLatest = Nothing
        oContentManager = Nothing
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
    function closeAndRefresh(sFileName)
        {        
        if(navigator.appName.indexOf("Microsoft")!=-1)
            {
            dialogArguments.navigate("../" + sFileName)
            }
        else
            {
            window.opener.location.href="../" + sFileName;
            }
        self.close();
        }
    function adjustHeight()
        {
        if(navigator.appName.indexOf('Microsoft')!=-1)
            document.getElementById('cellContent').height=70;
        else
            document.getElementById('cellContent').height=120;
        }        
    </script>
</head>
<body onload="adjustHeight()" style="margin:0px;background-color:#E6E7E8">
<form id="form1" runat="server">

<table cellpadding=0 cellspacing=0 width="100%">
<tr>
<td id=cellContent valign=top>
    <table cellpadding=3 width="100%">
    <tr>
        <td>
            <asp:Label ID="lblChannel" meta:resourcekey="lblChannel" runat="server" Text="Channel"></asp:Label></td><td>:</td>
        <td width=100%>
            <asp:DropDownList ID="dropChannels" runat="server">
            </asp:DropDownList>  
        </td>
    </tr>
    <td colspan=3>
        <asp:CheckBox ID="chkApplyAllSubs" meta:resourcekey="chkApplyAllSubs" runat="server" Text="Apply to all sub pages" />
    </td>
    </table>
</td>
</tr>
<tr>
<td style="padding:10px;padding-right:15px" align=right>
    <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold=true></asp:Label>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
    <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
</td>
</tr>
</table>

</form>
</body>
</html>
