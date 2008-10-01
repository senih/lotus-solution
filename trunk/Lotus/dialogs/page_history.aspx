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
        btnRestore.Text = GetLocalResourceObject("btnRestore.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        lblTitleLabel.Text = GetLocalResourceObject("lblTitleLabel.Text")
        lblContentLabel.Text = GetLocalResourceObject("lblContentLabel.Text")
        lblMetaKeywordsLabel.Text = GetLocalResourceObject("lblMetaKeywordsLabel.Text")
        lblMetaDescriptionLabel.Text = GetLocalResourceObject("lblMetaDescriptionLabel.Text")
        
        lblFileDownload.Text = GetLocalResourceObject("lblFileDownload.Text")
        lblPreviewOnListing.Text = GetLocalResourceObject("lblPreviewOnListing.Text")
        lblPreviewOnPage.Text = GetLocalResourceObject("lblPreviewOnPage.Text")
        litSelectAttr.Text = GetLocalResourceObject("litSelectAttr.Text")
        cbListOption1.Items.FindByValue("title").Text = GetLocalResourceObject("cbTitle.Text")
        cbListOption1.Items.FindByValue("content").Text = GetLocalResourceObject("cbContent.Text")
        cbListOption1.Items.FindByValue("keywords").Text = GetLocalResourceObject("cbKeyWords.Text")
        cbListOption1.Items.FindByValue("description").Text = GetLocalResourceObject("cbDescription.Text")
        cbListOption2.Items.FindByValue("file").Text = GetLocalResourceObject("cbFile.Text")
        cbListOption2.Items.FindByValue("fileview").Text = GetLocalResourceObject("cbFileView.Text")
        cbListOption2.Items.FindByValue("fileviewlisting").Text = GetLocalResourceObject("cbFileViewListing.Text")

        intPageId = CInt(Request.QueryString("pg"))
        Dim Item As ListItem
        Dim sText As String
        Dim sStatus As String

        If Not Page.IsPostBack Then
            dropVersions.Items.Clear()
            Item = New ListItem
            Item.Text = GetLocalResourceObject("SelectVersionDate") '
            Item.Value = ""
            dropVersions.Items.Add(Item)

            Dim oContentManager As ContentManager = New ContentManager
            Dim oDataReader As SqlDataReader
            oDataReader = oContentManager.GetContentVersions(intPageId)
            Do While oDataReader.Read()
                Item = New ListItem
                sText = oDataReader("last_updated_date").ToString() & " - By: " & oDataReader("last_updated_by").ToString()
                sStatus = oDataReader("status").ToString()

                If sStatus = "published_archived" Or sStatus = "published" Then
                    Item.Text = sText & " - published"
                Else
                    Item.Text = sText
                End If

                Item.Value = oDataReader("version").ToString()
                dropVersions.Items.Add(Item)
            Loop
            dropVersions.Items.RemoveAt(1)

            dropVersions.SelectedValue = ""

            oDataReader.Close()
            oContentManager = Nothing
        End If

        dropVersions.Attributes.Add("onchange", "if(this.value=='')return false;")
        btnRestore.Attributes.Add("onclick", "if(document.getElementById('" & dropVersions.ClientID & "').value=='')return false;")
    End Sub

    Protected Sub dropVersions_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dropVersions.SelectedIndexChanged

        panelContent.Visible = True

        Dim content As CMSContent = New CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        content = oContentManager.GetContent(intPageId, dropVersions.SelectedValue)

        With content
            lblTitle.Text = .Title

            If Not .ContentLeft = "" Then
                tdContentLeft.Style.Add("padding-right", "5px")
                tdContentLeft.Style.Add("border-right", "#aaaaaa 1px solid")
                tdContentBody.Style.Add("padding-left", "5px")

                divContentLeft.InnerHtml = .ContentLeft
            End If

            If Not .ContentBody = "" Then
                divContentBody.InnerHtml = .ContentBody
            End If

            If Not .ContentRight = "" Then
                tdContentBody.Style.Add("padding-right", "5px")
                tdContentBody.Style.Add("border-right", "#aaaaaa 1px solid")
                tdContentRight.Style.Add("padding-left", "5px")

                divContentRight.InnerHtml = .ContentRight
            End If

            lblMetaKeywords.Text = .MetaKeywords
            lblMetaDescription.Text = .MetaDescription
            
            If (.FileAttachment <> "") Then
                lblDownloadFileName.Text = .FileAttachment.Substring(.FileAttachment.IndexOf("_") + 1)
                Dim sExt As String = (.FileAttachment.Substring(.FileAttachment.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litDownloadThumb.Text = "<img alt="""" title="""" src=""../systems/image_thumbnail3_fileattach.aspx?file=" & .PageId  & "\" & .FileAttachment & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litDownloadThumb.Text = ""
                End If
                lblDownloadFile.Text = "<a target=""_blank"" href=""" & "../systems/file_download.aspx?pg=" & .PageId & "&ver=" & .Version & """>" & GetLocalResourceObject("lblDownloadFileLinkText") & "</a> (" & FormatNumber((.FileSize / 1024), 0) & " KB" & ")"
            End IF

            If .FileView <> "" Then
                lblViewFileName.Text = .FileView.Substring(.FileView.IndexOf("_") + 1)
                Dim sExt As String = (.FileView.Substring(.FileView.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewThumb.Text = "<img alt="""" title="""" src=""../systems/image_thumbnail3_fileview.aspx?file=" & .PageId  & "\" & .FileView & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewThumb.Text = ""
                End If
            End If

            'File View Listing
            If .FileViewListing <> "" Then
                lblViewListingFileName.Text = .FileViewListing.Substring(.FileViewListing.IndexOf("_") + 1)
                Dim sExt As String = (.FileViewListing.Substring(.FileViewListing.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewListingThumb.Text = "<img alt="""" title="""" src=""../systems/image_thumbnail3_listview.aspx?file=" & .PageId  & "\" & .FileViewListing & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewListingThumb.Text = ""
                End If
            End If
          
        End With

        oContentManager = Nothing

        lblRestoreStatus.Text = ""
    End Sub

    Protected Sub btnRestore_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRestore.Click
        RedirectForLogin()
        
        Dim rbOptions as ArrayList = new ArrayList (8)
        For Each item as ListItem in cbListOption1.Items
            if item.Selected then rbOptions.Add(item.Value)
        Next
        For Each item as ListItem in cbListOption2.Items
            if item.Selected then rbOptions.Add(item.Value)
        Next
        
        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        oContentManager.RollbackContent(intPageId, dropVersions.SelectedValue, rbOptions)
        contentLatest = oContentManager.GetLatestVersion(intPageId)

        btnClose.OnClientClick = "closeAndRefresh('" & contentLatest.FileName & "');return false"

        contentLatest = Nothing
        oContentManager = Nothing

        lblRestoreStatus.Text = GetLocalResourceObject("VersionRestored")
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
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
    </script>
</head>
<body style="margin:10px;background-color:#E6E7E8">
<form id="form1" runat="server">
<asp:DropDownList ID="dropVersions" AutoPostBack="true" runat="server">
</asp:DropDownList>
<asp:Button ID="btnRestore" meta:resourcekey="btnRestore" runat="server" Text=" Restore This Version " />
<asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " OnClientClick="self.close()" />
<asp:Label ID="lblRestoreStatus" runat="server" Text="" Font-Bold="true"></asp:Label>
<asp:Panel runat="server" ID="panelOptions">
<table cellpadding="2" cellspacing="2">
  <tr>
    <td colspan="2" style="padding-top:10px"><asp:Literal runat="server" ID="litSelectAttr" meta:resourcekey="litSelectAttr" Text="Select page attributes to rollback:"></asp:Literal></td>
  </tr>
  <tr>
    <td valign="top">
        <asp:CheckBoxList runat="server" ID="cbListOption1">
            <asp:ListItem meta:resourcekey="cbTitle" Text="Title" Value="title" Selected="True"></asp:ListItem>
            <asp:ListItem meta:resourcekey="cbContent" Text="Content" Value="content" Selected="True"></asp:ListItem>
            <asp:ListItem meta:resourcekey="cbKeyWords" Text="Meta Keywords" Value="keywords" Selected="True"></asp:ListItem>
            <asp:ListItem meta:resourcekey="cbDescription" Text="Meta Description" Value="description" Selected="True"></asp:ListItem>
        </asp:CheckBoxList>
    </td>
    <td style="padding-left:20px" valign="top">
        <asp:CheckBoxList runat="server" ID="cbListOption2">
            <asp:ListItem meta:resourcekey="cbFile" Text="File Attachment" Value="file" Selected="True"></asp:ListItem>
            <asp:ListItem meta:resourcekey="cbFileView" Text="File View" Value="fileview" Selected="True"></asp:ListItem>
            <asp:ListItem meta:resourcekey="cbFileViewListing" Text="File View Listing" Value="fileviewlisting" Selected="True"></asp:ListItem>
        </asp:CheckBoxList>    
    </td>
  </tr>
</table>
</asp:Panel>

<asp:Panel ID="panelContent" runat="server" Visible="false">

<table cellpadding=5 style="border:#cccccc 1px solid;margin-top:10px" bgcolor="white" width="100%">
<tr>
    <td><asp:Label ID="lblTitleLabel" meta:resourcekey="lblTitleLabel" runat="server" Text="Title" Font-Bold=true></asp:Label></td><td>:</td>
    <td width="100%"><asp:Label ID="lblTitle" runat="server" Text=""></asp:Label></td>
</tr>
<tr>
    <td><asp:Label ID="lblContentLabel" meta:resourcekey="lblContentLabel" runat="server" Text="Content" Font-Bold="true"></asp:Label></td><td>:</td><td></td>
</tr>
<tr>
    <td colspan=3>
        <table cellpadding=0 cellspacing=0 width="100%">
        <tr>
            <td id="tdContentLeft" runat="server" valign="top"><div id="divContentLeft" runat="server"></div></td>
            <td id="tdContentBody" runat="server" valign="top"><div id="divContentBody" runat="server"></div></td>
            <td id="tdContentRight" runat="server" valign="top"><div id="divContentRight" runat="server"></div></td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <td valign=top nowrap="nowrap"><asp:Label ID="lblMetaKeywordsLabel" meta:resourcekey="lblMetaKeywordsLabel" runat="server" Text="Meta Keywords" Font-Bold=true></asp:Label></td><td valign=top>:</td>
    <td><asp:Label ID="lblMetaKeywords" runat="server" Text=""></asp:Label></td>
</tr>
<tr>
    <td valign=top nowrap="nowrap"><asp:Label ID="lblMetaDescriptionLabel" meta:resourcekey="lblMetaDescriptionLabel" runat="server" Text="Meta Description" Font-Bold=true></asp:Label></td><td valign=top>:</td>
    <td><asp:Label ID="lblMetaDescription" runat="server" Text=""></asp:Label></td>
</tr>
</table>
<div>&nbsp;</div>
<table>
    <tr>
        <td valign="top" style="padding-right:10px;">
            <div style="padding-bottom:3px">
                <asp:Label id="lblFileDownload" meta:resourcekey="lblFileDownload" Text="FILE DOWNLOAD" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
            </div>
            <div>                    
                <asp:Literal ID="litDownloadThumb" runat="server"></asp:Literal>
            </div>
            <div>
                <asp:Label ID="lblDownloadFileName" runat="server"></asp:Label>
            </div>
            <div>
                <asp:Label ID="lblDownloadFile" runat="server"></asp:Label>
            </div>                            
        </td>
        <td valign="top" style="padding-right:10px;padding-left:10px;border-left:#cccccc 1px solid">
            <div style="padding-bottom:3px">
                <asp:Label id="lblPreviewOnPage" meta:resourcekey="lblPreviewOnPage" Text="PREVIEW ON PAGE" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
                <span style="font-size:9px">(FLV, MP3, JPG, GIF, PNG)</span>
            </div>
            <div>                    
                <asp:Literal ID="litViewThumb" runat="server"></asp:Literal>
            </div>
            <div>
                <asp:Label ID="lblViewFileName" runat="server"></asp:Label>
            </div>                
        </td>
        <td id="idPreviewOnListing" runat="server" valign="top" style="padding-left:10px;border-left:#cccccc 1px solid">
            <div style="padding-bottom:3px">
                <asp:Label id="lblPreviewOnListing" meta:resourcekey="lblPreviewOnListing" Text="PREVIEW ON LISTING" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
                <span style="font-size:9px">(JPG, GIF, PNG)</span>
            </div>
            <div>                    
                <asp:Literal ID="litViewListingThumb" runat="server"></asp:Literal>
            </div>
            <div>
                <asp:Label ID="lblViewListingFileName" runat="server"></asp:Label>
            </div>                           
        </td>    
    </tr>
</table>
</asp:Panel>

</form>
</body>
</html>
