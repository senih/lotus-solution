<%@ Page Language="VB" ValidateRequest="false" %>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server">
    Private intPageId As Integer

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
        lblLinkText.Text = GetLocalResourceObject("lblLinkText.Text")
        lblTemplate.Text = GetLocalResourceObject("lblTemplate.Text")
        dropTemplate.Items(0).Text = GetLocalResourceObject("optUseDefault.Text")
        lblMetaTitle.Text = GetLocalResourceObject("lblMetaTitle.Text")
        lblMetaDescription.Text = GetLocalResourceObject("lblMetaDescription.Text")
        lblMetaKeywords.Text = GetLocalResourceObject("lblMetaKeywords.Text")
        chkAllowLinksCrawled.Text = GetLocalResourceObject("chkAllowLinksCrawled.Text")
        chkAllowPageIndexed.Text = GetLocalResourceObject("chkAllowPageIndexed.Text")
        chkHideFromSiteNavigation.Text = GetLocalResourceObject("chkHideFromSiteNavigation.Text")

        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        
        intPageId = CInt(Request.QueryString("pg"))
        
  
        If Not Page.IsPostBack Then

            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(intPageId)

            Dim colTemplate As Collection
            Dim templateMgr As TemplateManager = New TemplateManager
            colTemplate = templateMgr.ListAllTemplates()

            For Each template As CMSTemplate In colTemplate
                dropTemplate.Items.Add(New ListItem(template.TemplateName, template.TemplateId.ToString))
            Next

            dropTemplate.SelectedValue = IIf(contentLatest.UseDefaultTemplate, "0", contentLatest.TemplateId.ToString).ToString
            txtLinkText.Text = contentLatest.LinkText
            txtMetaTitle.Text = contentLatest.MetaTitle
            txtMetaDescription.Text = contentLatest.MetaDescription
            txtMetaKeyword.Text = contentLatest.MetaKeywords

            chkHideFromSiteNavigation.Checked = contentLatest.IsHidden
            chkAllowLinksCrawled.Checked = contentLatest.AllowLinksCrawled
            chkAllowPageIndexed.Checked = contentLatest.AllowPageIndexed

            contentLatest = Nothing
            oContentManager = Nothing

            btnClose.OnClientClick = "self.close()"
        End If

        dropTemplate.Attributes.Add("onchange", "alert('" & GetLocalResourceObject("ChangeTemplateWarning") & "')")
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(intPageId)

        Dim content As CMSContent = New CMSContent
        With content
            .PageId = intPageId
            .Version = contentLatest.Version 'intVersion
            .LinkText = txtLinkText.Text
            .MetaTitle = txtMetaTitle.Text
            .MetaDescription = txtMetaDescription.Text
            .MetaKeywords = txtMetaKeyword.Text
            
            .IsHidden = chkHideFromSiteNavigation.Checked
            .AllowLinksCrawled = chkAllowLinksCrawled.Checked
            .AllowPageIndexed = chkAllowPageIndexed.Checked

            If contentLatest.UseDefaultTemplate = True And dropTemplate.SelectedValue = 0 Then
                'not changed
                btnClose.OnClientClick = "self.close()"
            ElseIf contentLatest.UseDefaultTemplate = False And contentLatest.TemplateId = CInt(dropTemplate.SelectedValue) Then
                'not changed
                btnClose.OnClientClick = "self.close()"
            Else
                'changed
                btnClose.OnClientClick = "closeAndRefresh('" & contentLatest.FileName & "');return false"
            End If

            If (dropTemplate.SelectedValue = "0") Then
                .UseDefaultTemplate = True
                '.TemplateId = Nothing
            Else
                .UseDefaultTemplate = False
                .TemplateId = CInt(dropTemplate.SelectedValue)
            End If
                        
            oContentManager.SaveContentProperties(content)

        End With

        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")

        content = Nothing
        contentLatest = Nothing
        oContentManager = Nothing
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

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

<table style="width:100%" cellpadding="0" cellspacing="0">
<tr>
<td id="cellContent" valign="top">
    <table width="100%" cellpadding="3">
    <tr>
        <td style="white-space:nowrap"><asp:Label ID="lblLinkText" meta:resourcekey="lblLinkText" runat="server" Text="Display Link"></asp:Label></td>
        <td>:</td>
        <td><asp:TextBox ID="txtLinkText" Width="250px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td><asp:Label ID="lblTemplate" meta:resourcekey="lblTemplate" runat="server" Text="Page Template"></asp:Label></td>
        <td>:</td>
        <td>     
            <asp:DropDownList ID="dropTemplate" Width="250px" runat="server">
            <asp:ListItem meta:resourcekey="optUseDefault" Text="Use default" Value="0"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap" valign=top><asp:Label ID="lblMetaTitle" meta:resourcekey="lblMetaTitle" runat="server" Text="Meta Title"></asp:Label></td>
        <td valign=top>:</td>
        <td><asp:TextBox ID="txtMetaTitle" Width="250px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap" valign=top><asp:Label ID="lblMetaDescription" meta:resourcekey="lblMetaDescription" runat="server" Text="Meta Description"></asp:Label></td>
        <td valign=top>:</td>
        <td><asp:TextBox ID="txtMetaDescription" Rows=3 Width="250px" TextMode=MultiLine runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap" valign=top><asp:Label ID="lblMetaKeywords" meta:resourcekey="lblMetaKeywords" runat="server" Text="Meta Keywords"></asp:Label></td>
        <td valign=top>:</td>
        <td><asp:TextBox ID="txtMetaKeyword" Rows=3 Width="250px" TextMode=MultiLine runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan=3>
            <hr />
            <table cellpadding=3 cellspacing=0>
            <tr>
            <td valign=top style="padding-left:0px;white-space:nowrap">
                <asp:CheckBox ID="chkAllowLinksCrawled" meta:resourcekey="chkAllowLinksCrawled" runat="server" Text="Allow Web Robots to Crawl Links." /><br />
                <asp:CheckBox ID="chkAllowPageIndexed" meta:resourcekey="chkAllowPageIndexed" runat="server" Text="Allow Web Robots to Index This Page." /><br />
                <asp:CheckBox ID="chkHideFromSiteNavigation" meta:resourcekey="chkHideFromSiteNavigation" runat="server" Text="Hide This Page From the Site Navigation." />
            </td>            
            </tr>
            </table>
        </td>
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
