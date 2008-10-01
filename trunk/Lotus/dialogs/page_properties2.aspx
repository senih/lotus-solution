<%@ Page Language="VB" ValidateRequest="false"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat=server>
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nPageId As Integer
    
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RedirectForLogin()
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        lblField1.Text = GetLocalResourceObject("lblField1.Text")
        lblField2.Text = GetLocalResourceObject("lblField2.Text")
        lblField3.Text = GetLocalResourceObject("lblField3.Text")
        lblField4.Text = GetLocalResourceObject("lblField4.Text")
        lblField5.Text = GetLocalResourceObject("lblField5.Text")
        lblField6.Text = GetLocalResourceObject("lblField6.Text")
        lblField7.Text = GetLocalResourceObject("lblField7.Text")
        lblField8.Text = GetLocalResourceObject("lblField8.Text")
        lblField9.Text = GetLocalResourceObject("lblField9.Text")
        lblField10.Text = GetLocalResourceObject("lblField10.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        
        nPageId = CInt(Request.QueryString("pg"))
        
        If Not Page.IsPostBack Then

            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(nPageId)

            Dim nCount As Integer = Split(contentLatest.Properties2, "#||#").Length
            If nCount > 0 Then txtField1.Text = Split(contentLatest.Properties2, "#||#")(0)
            If nCount > 1 Then txtField2.Text = Split(contentLatest.Properties2, "#||#")(1)
            If nCount > 2 Then txtField3.Text = Split(contentLatest.Properties2, "#||#")(2)
            If nCount > 3 Then txtField4.Text = Split(contentLatest.Properties2, "#||#")(3)
            If nCount > 4 Then txtField5.Text = Split(contentLatest.Properties2, "#||#")(4)
            If nCount > 5 Then txtField6.Text = Split(contentLatest.Properties2, "#||#")(5)
            If nCount > 6 Then txtField7.Text = Split(contentLatest.Properties2, "#||#")(6)
            If nCount > 7 Then txtField8.Text = Split(contentLatest.Properties2, "#||#")(7)
            If nCount > 8 Then txtField9.Text = Split(contentLatest.Properties2, "#||#")(8)
            If nCount > 9 Then txtField10.Text = Split(contentLatest.Properties2, "#||#")(9)

           
            contentLatest = Nothing
            oContentManager = Nothing

            btnClose.OnClientClick = "self.close()"
        End If

    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)
        
        Dim sSQL As String
        sSQL = "UPDATE pages set properties2=@properties2 WHERE page_id=@page_id AND version=@version"

        Dim oCmd As SqlCommand
        oCmd = New SqlCommand(sSQL)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = contentLatest.PageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = contentLatest.Version
        oCmd.Parameters.Add("@properties2", SqlDbType.NText).Value = txtField1.Text & "#||#" & _
            txtField2.Text & "#||#" & _
            txtField3.Text & "#||#" & _
            txtField4.Text & "#||#" & _
            txtField5.Text & "#||#" & _
            txtField6.Text & "#||#" & _
            txtField7.Text & "#||#" & _
            txtField8.Text & "#||#" & _
            txtField9.Text & "#||#" & _
            txtField10.Text

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        
        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")

        contentLatest = Nothing
        oContentManager = Nothing
    End Sub
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <base target="_self" />
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script type="text/javascript" language="javascript">
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
            document.getElementById('cellContent').height=245;
        else
            document.getElementById('cellContent').height=333;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:0px;background-color:#E6E7E8">
<form id="form1" runat="server">

<table style="width:100%;" cellpadding="0" cellspacing="0">
<tr>
<td id="cellContent" valign="top" style="padding:5px;padding-top:8px">
    <table width="100%" cellpadding="1" cellspacing="0">
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField1" meta:resourcekey="lblField1" runat="server" Text="Value 1"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField1" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField2" meta:resourcekey="lblField2" runat="server" Text="Value 2"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField2" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField3" meta:resourcekey="lblField3" runat="server" Text="Value 3"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField3" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField4" meta:resourcekey="lblField4" runat="server" Text="Value 4"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField4" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField5" meta:resourcekey="lblField5" runat="server" Text="Value 5"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField5" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField6" meta:resourcekey="lblField6" runat="server" Text="Value 6"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField6" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField7" meta:resourcekey="lblField7" runat="server" Text="Value 7"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField7" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField8" meta:resourcekey="lblField8" runat="server" Text="Value 8"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField8" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField9" meta:resourcekey="lblField9" runat="server" Text="Value 9"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField9" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblField10" meta:resourcekey="lblField10" runat="server" Text="Value 10"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtField10" Width="300px" runat="server"></asp:TextBox></td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td align="right" style="padding:10px;padding-right:15px">    
    <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold="true"></asp:Label>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
    <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
</td>
</tr>
</table>

</form>
</body>
</html>
