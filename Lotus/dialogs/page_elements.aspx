<%@ Page Language="VB" %>
<%@ OutputCache Location="None" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.IO"%> 
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">
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
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        chkAuthor.Text = GetLocalResourceObject("chkAuthor.text")
        chkAuthorFullName.Text = GetLocalResourceObject("chkAuthorFullName.text")
        chkCalendar.Text = GetLocalResourceObject("chkCalendar.Text")
        chkCategoryInfo.Text = GetLocalResourceObject("chkCategoryInfo.Text")
        chkCategoryList.Text = GetLocalResourceObject("chkCategoryList.Text")
        chkCommentAnonymous.Text = GetLocalResourceObject("chkCommentAnonymous.Text")
        chkComments.Text = GetLocalResourceObject("chkComments.Text")
        chkDisplayDate.Text = GetLocalResourceObject("chkDisplayDate.Text")
        chkFileDownload.Text = GetLocalResourceObject("chkFileDownload.Text")
        chkFileView.Text = GetLocalResourceObject("chkFileView.Text")
        chkLastUpdatedDate.Text = GetLocalResourceObject("chkLastUpdatedDate.Text")
        chkListingOrdering.Text = GetLocalResourceObject("chkListingOrdering.Text")
        chkMonthList.Text = GetLocalResourceObject("chkMonthList.Text")
        chkOrderByAuthor.Text = GetLocalResourceObject("chkOrderByAuthor.Text")
        chkOrderByComments.Text = GetLocalResourceObject("chkOrderByComments.Text")
        chkOrderByDownloadsToday.Text = GetLocalResourceObject("chkOrderByDownloadsToday.Text")
        chkOrderByHitsToday.Text = GetLocalResourceObject("chkOrderByHitsToday.Text")
        chkOrderByLastUpdatedDate.Text = GetLocalResourceObject("chkOrderByLastUpdatedDate.Text")
        chkOrderByPersonLastUpdating.Text = GetLocalResourceObject("chkOrderByPersonLastUpdating.Text")
        chkOrderByPrice.Text = GetLocalResourceObject("chkOrderByPrice.Text")
        chkOrderByPublishDate.Text = GetLocalResourceObject("chkOrderByPublishDate.Text")
        chkOrderByRating.Text = GetLocalResourceObject("chkOrderByRating.Text")
        chkOrderBySize.Text = GetLocalResourceObject("chkOrderBySize.Text")
        chkOrderByTitle.Text = GetLocalResourceObject("chkOrderByTitle.Text")
        chkOrderByTotalDownloads.Text = GetLocalResourceObject("chkOrderByTotalDownloads.Text")
        chkOrderByTotalHits.Text = GetLocalResourceObject("chkOrderByTotalHits.Text")
        chkPersonLastUpdating.Text = GetLocalResourceObject("chkPersonLastUpdating.Text")
        chkPersonLastUpdatingFullName.Text = GetLocalResourceObject("chkPersonLastUpdatingFullName.Text")
        chkPostedBy.Text = GetLocalResourceObject("chkPostedBy.Text")
        chkPostedByFullName.Text = GetLocalResourceObject("chkPostedByFullName.Text")
        chkPublishDate.Text = GetLocalResourceObject("chkPublishDate.Text")
        chkRating.Text = GetLocalResourceObject("chkRating.Text")
        chkStatisticInfo.Text = GetLocalResourceObject("chkStatisticInfo.Text")
        chkSubscribe.Text = GetLocalResourceObject("chkSubscribe.Text")
        chkTitle.Text = GetLocalResourceObject("chkTitle.Text")
        lblVisibleOnListing.Text = GetLocalResourceObject("lblVisibleOnListing.Text")
        lblVisibleOnPage.Text = GetLocalResourceObject("lblVisibleOnPage.Text")
        lblVisibleOnPageAndListing.Text = GetLocalResourceObject("lblVisibleOnPageAndListing.Text")
        
        nPageId = CInt(Request.QueryString("pg"))
                
        If Not Page.IsPostBack Then
            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(nPageId)
            
            Dim sXML As String
            If contentLatest.Elements.ToString = "" Then
                sXML = "<root>" & _
                "<title>True</title>" & _
                "<file_view>True</file_view>" & _
                "<file_download>True</file_download>" & _
                "<author>False</author>" & _
                "<author_full_name>False</author_full_name>" & _
                "<person_last_updating>False</person_last_updating>" & _
                "<person_last_updating_full_name>False</person_last_updating_full_name>" & _
                "<publish_date>False</publish_date>" & _
                "<last_updated_date>False</last_updated_date>" & _
                "<display_date>False</display_date>" & _
                "<statistic_info>False</statistic_info>" & _
                "<category_info>False</category_info>" & _
                "<rating>False</rating>" & _
                "<comments>False</comments>" & _
                "<comments_anonymous>False</comments_anonymous>" & _
                "<listing_ordering>False</listing_ordering>" & _
                "<listing_ordering_by_title>False</listing_ordering_by_title>" & _
                "<listing_ordering_by_author>False</listing_ordering_by_author>" & _
                "<listing_ordering_by_person_last_updating>False</listing_ordering_by_person_last_updating>" & _
                "<listing_ordering_by_publish_date>False</listing_ordering_by_publish_date>" & _
                "<listing_ordering_by_last_updated_date>False</listing_ordering_by_last_updated_date>" & _
                "<listing_ordering_by_size>False</listing_ordering_by_size>" & _
                "<listing_ordering_by_total_downloads>False</listing_ordering_by_total_downloads>" & _
                "<listing_ordering_by_downloads_today>False</listing_ordering_by_downloads_today>" & _
                "<listing_ordering_by_rating>False</listing_ordering_by_rating>" & _
                "<listing_ordering_by_comments>False</listing_ordering_by_comments>" & _
                "<listing_ordering_by_total_hits>False</listing_ordering_by_total_hits>" & _
                "<listing_ordering_by_hits_today>False</listing_ordering_by_hits_today>" & _
                "<listing_ordering_by_price>False</listing_ordering_by_price>" & _
                "<calendar>True</calendar>" & _
                "<month_list>True</month_list>" & _
                "<category_list>False</category_list>" & _
                "<subscribe>True</subscribe>" & _
                "<posted_by>False</posted_by>" & _
                "<posted_by_full_name>False</posted_by_full_name>" & _
                "<display_date>False</display_date>" & _
                "</root>"
            Else
                sXML = contentLatest.Elements.ToString
            End If
            
            If contentLatest.IsListing Then
                
                chkPostedBy.Visible = True
                chkPostedByFullName.Visible = True
                
                If contentLatest.ListingUseCategories Then
                    chkCategoryList.Visible = True
                    chkCategoryInfo.Visible = True
                Else
                    chkCategoryList.Visible = False
                    chkCategoryInfo.Visible = False
                End If
                
                If contentLatest.ListingType = 1 Then 'No Date
                    
                    If contentLatest.ListingProperty = 1 Or contentLatest.ListingProperty = 3 Then
                        chkListingOrdering.Visible = False
                        chkOrderByTitle.Visible = False
                        chkOrderByAuthor.Visible = False
                        chkOrderByPersonLastUpdating.Visible = False
                        chkOrderByPublishDate.Visible = False
                        chkOrderByLastUpdatedDate.Visible = False
                        chkOrderBySize.Visible = False
                        chkOrderByTotalDownloads.Visible = False
                        chkOrderByDownloadsToday.Visible = False
                        chkOrderByRating.Visible = False
                        chkOrderByComments.Visible = False
                        chkOrderByTotalHits.Visible = False
                        chkOrderByHitsToday.Visible = False
                        chkOrderByPrice.Visible = False
                    End If
                    
                    chkCalendar.Visible = False
                    chkMonthList.Visible = False
                    chkSubscribe.Visible = False
                    
                    chkDisplayDate.Visible = False
                    chkPostedBy.Visible = False
                    chkPostedByFullName.Visible = False
                    
                    If Not contentLatest.ListingUseCategories Then
                        'idAlsoOnListing.Visible = False
                        idOnListing.Visible = False
                    End If
                    
                    
                Else 'Use Date
                    chkListingOrdering.Visible = False
                    chkOrderByTitle.Visible = False
                    chkOrderByAuthor.Visible = False
                    chkOrderByPersonLastUpdating.Visible = False
                    chkOrderByPublishDate.Visible = False
                    chkOrderByLastUpdatedDate.Visible = False
                    chkOrderBySize.Visible = False
                    chkOrderByTotalDownloads.Visible = False
                    chkOrderByDownloadsToday.Visible = False
                    chkOrderByRating.Visible = False
                    chkOrderByComments.Visible = False
                    chkOrderByTotalHits.Visible = False
                    chkOrderByHitsToday.Visible = False
                    chkOrderByPrice.Visible = False
                End If
                
            Else
                
                idAlsoOnListing.Visible = False
                idOnListing.Visible = False
                
                chkPostedBy.Visible = False
                chkPostedByFullName.Visible = False
                chkDisplayDate.Visible = False
                
                chkCategoryList.Visible = False
                chkCategoryInfo.Visible = False
                
                chkCalendar.Visible = False
                chkMonthList.Visible = False
                chkCategoryList.Visible = False
                chkSubscribe.Visible = False
                chkPodcast.Visible = False
                
                chkListingOrdering.Visible = False
                chkOrderByTitle.Visible = False
                chkOrderByAuthor.Visible = False
                chkOrderByPersonLastUpdating.Visible = False
                chkOrderByPublishDate.Visible = False
                chkOrderByLastUpdatedDate.Visible = False
                chkOrderBySize.Visible = False
                chkOrderByTotalDownloads.Visible = False
                chkOrderByDownloadsToday.Visible = False
                chkOrderByRating.Visible = False
                chkOrderByComments.Visible = False
                chkOrderByTotalHits.Visible = False
                chkOrderByHitsToday.Visible = False
                chkOrderByPrice.Visible = False
            End If

            '
            
            Dim oXML As XmlDocument = New XmlDocument
            oXML.LoadXml(sXML)
            
            chkTitle.Checked = CBool(oXML.DocumentElement.Item("title").InnerText)
            chkFileView.Checked = CBool(oXML.DocumentElement.Item("file_view").InnerText)
            chkFileDownload.Checked = CBool(oXML.DocumentElement.Item("file_download").InnerText)
            chkAuthor.Checked = CBool(oXML.DocumentElement.Item("author").InnerText)
            chkAuthorFullName.Checked = CBool(oXML.DocumentElement.Item("author_full_name").InnerText)
            chkPersonLastUpdating.Checked = CBool(oXML.DocumentElement.Item("person_last_updating").InnerText)
            chkPersonLastUpdatingFullName.Checked = CBool(oXML.DocumentElement.Item("person_last_updating_full_name").InnerText)
            chkPublishDate.Checked = CBool(oXML.DocumentElement.Item("publish_date").InnerText)
            chkLastUpdatedDate.Checked = CBool(oXML.DocumentElement.Item("last_updated_date").InnerText)
            chkStatisticInfo.Checked = CBool(oXML.DocumentElement.Item("statistic_info").InnerText)
            chkCategoryInfo.Checked = CBool(oXML.DocumentElement.Item("category_info").InnerText)
            chkRating.Checked = CBool(oXML.DocumentElement.Item("rating").InnerText)
            chkComments.Checked = CBool(oXML.DocumentElement.Item("comments").InnerText)
            chkCommentAnonymous.Checked = CBool(oXML.DocumentElement.Item("comments_anonymous").InnerText)
            chkListingOrdering.Checked = CBool(oXML.DocumentElement.Item("listing_ordering").InnerText)
            chkOrderByTitle.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_title").InnerText)
            chkOrderByAuthor.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_author").InnerText)
            chkOrderByPersonLastUpdating.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_person_last_updating").InnerText)
            chkOrderByPublishDate.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_publish_date").InnerText)
            chkOrderByLastUpdatedDate.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_last_updated_date").InnerText)
            chkOrderBySize.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_size").InnerText)
            chkOrderByTotalDownloads.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_total_downloads").InnerText)
            chkOrderByDownloadsToday.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_downloads_today").InnerText)
            chkOrderByRating.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_rating").InnerText)
            chkOrderByComments.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_comments").InnerText)
            chkOrderByTotalHits.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_total_hits").InnerText)
            chkOrderByHitsToday.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_hits_today").InnerText)
            chkOrderByPrice.Checked = CBool(oXML.DocumentElement.Item("listing_ordering_by_price").InnerText)
            chkCalendar.Checked = CBool(oXML.DocumentElement.Item("calendar").InnerText)
            chkMonthList.Checked = CBool(oXML.DocumentElement.Item("month_list").InnerText)
            chkCategoryList.Checked = CBool(oXML.DocumentElement.Item("category_list").InnerText)
            chkSubscribe.Checked = CBool(oXML.DocumentElement.Item("subscribe").InnerText)
            If IsNothing(oXML.GetElementsByTagName("subscribe_podcast")(0)) Then
                chkPodcast.Checked = False
            Else
                chkPodcast.Checked = CBool(oXML.GetElementsByTagName("subscribe_podcast")(0).InnerText)
            End If
            Try
                chkPostedBy.Checked = CBool(oXML.DocumentElement.Item("posted_by").InnerText)
            Catch ex As Exception
            End Try
            Try
                chkPostedByFullName.Checked = CBool(oXML.DocumentElement.Item("posted_by_full_name").InnerText)
            Catch ex As Exception
            End Try
            Try
                chkDisplayDate.Checked = CBool(oXML.DocumentElement.Item("display_date").InnerText)
            Catch ex As Exception
            End Try
            
            btnClose.OnClientClick = "self.close()"
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sWriter As StringWriter = New StringWriter
        Dim sXML As XmlTextWriter = New XmlTextWriter(sWriter)
        sXML.WriteStartElement("root")
        sXML.WriteElementString("title", chkTitle.Checked)
        sXML.WriteElementString("file_view", chkFileView.Checked)
        sXML.WriteElementString("file_download", chkFileDownload.Checked)
        sXML.WriteElementString("author", chkAuthor.Checked)
        sXML.WriteElementString("author_full_name", chkAuthorFullName.Checked)
        sXML.WriteElementString("person_last_updating", chkPersonLastUpdating.Checked)
        sXML.WriteElementString("person_last_updating_full_name", chkPersonLastUpdatingFullName.Checked)
        sXML.WriteElementString("publish_date", chkPublishDate.Checked)
        sXML.WriteElementString("last_updated_date", chkLastUpdatedDate.Checked)
        sXML.WriteElementString("statistic_info", chkStatisticInfo.Checked)
        sXML.WriteElementString("category_info", chkCategoryInfo.Checked)
        sXML.WriteElementString("rating", chkRating.Checked)
        sXML.WriteElementString("comments", chkComments.Checked)
        sXML.WriteElementString("comments_anonymous", chkCommentAnonymous.Checked)
        sXML.WriteElementString("listing_ordering", chkListingOrdering.Checked)
        sXML.WriteElementString("listing_ordering_by_title", chkOrderByTitle.Checked)
        sXML.WriteElementString("listing_ordering_by_author", chkOrderByAuthor.Checked)
        sXML.WriteElementString("listing_ordering_by_person_last_updating", chkOrderByPersonLastUpdating.Checked)
        sXML.WriteElementString("listing_ordering_by_publish_date", chkOrderByPublishDate.Checked)
        sXML.WriteElementString("listing_ordering_by_last_updated_date", chkOrderByLastUpdatedDate.Checked)
        sXML.WriteElementString("listing_ordering_by_size", chkOrderBySize.Checked)
        sXML.WriteElementString("listing_ordering_by_total_downloads", chkOrderByTotalDownloads.Checked)
        sXML.WriteElementString("listing_ordering_by_downloads_today", chkOrderByDownloadsToday.Checked)
        sXML.WriteElementString("listing_ordering_by_rating", chkOrderByRating.Checked)
        sXML.WriteElementString("listing_ordering_by_comments", chkOrderByComments.Checked)
        sXML.WriteElementString("listing_ordering_by_total_hits", chkOrderByTotalHits.Checked)
        sXML.WriteElementString("listing_ordering_by_hits_today", chkOrderByHitsToday.Checked)
        sXML.WriteElementString("listing_ordering_by_price", chkOrderByPrice.Checked)
        sXML.WriteElementString("calendar", chkCalendar.Checked)
        sXML.WriteElementString("month_list", chkMonthList.Checked)
        sXML.WriteElementString("category_list", chkCategoryList.Checked)
        sXML.WriteElementString("subscribe", chkSubscribe.Checked)
        sXML.WriteElementString("subscribe_podcast", chkPodcast.Checked)
        
        sXML.WriteElementString("posted_by", chkPostedBy.Checked)
        sXML.WriteElementString("posted_by_full_name", chkPostedByFullName.Checked)
        sXML.WriteElementString("display_date", chkDisplayDate.Checked)
        
        sXML.WriteEndElement()
        sXML.Close()
       
        Dim content As CMSContent = New CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        content = oContentManager.GetWorkingCopy(nPageId)

        Dim contentLatest As CMSContent
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        'Update record       
        Dim oCommand As New SqlCommand("UPDATE pages SET elements=@elements WHERE page_id=@page_id AND version=@version")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@elements", SqlDbType.NText).Value = sWriter.ToString
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Parameters.Add("@version", SqlDbType.Int).Value = contentLatest.Version
        oConn.Open()
        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()
        oConn.Close()
        oConn = Nothing

        btnClose.OnClientClick = "closeAndRefresh('" & contentLatest.FileName & "');return false"
        
        content = Nothing
        oContentManager = Nothing
        
        lblSaveStatus.Text = "Data Updated." ' GetLocalResourceObject("DataUpdated")
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
        td {white-space:nowrap}
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
<td id="cellContent" valign="top" style="padding:10px">

    <table style="width:250px" cellpadding="1" cellspacing="0">
    <tr>
    <td><asp:Label ID="lblVisibleOnPage" meta:resourcekey="lblVisibleOnPage" Font-Bold="true" runat="server" Text="Visible on this page"></asp:Label></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkTitle" meta:resourcekey="chkTitle" Text="Title" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkFileView" meta:resourcekey="chkFileView" Text="File View" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkFileDownload" meta:resourcekey="chkFileDownload" Text="File Download" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td><asp:CheckBox ID="chkAuthor" meta:resourcekey="chkAuthor" Text="Person First Creating" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td style="padding-left:22px"><asp:CheckBox ID="chkAuthorFullName" meta:resourcekey="chkAuthorFullName" Text="Full Name" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td><asp:CheckBox ID="chkPublishDate" meta:resourcekey="chkPublishDate" Text="Date First Published" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td><asp:CheckBox ID="chkPersonLastUpdating" meta:resourcekey="chkPersonLastUpdating" Text="Person Last Updating" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td style="padding-left:22px"><asp:CheckBox ID="chkPersonLastUpdatingFullName" meta:resourcekey="chkPersonLastUpdatingFullName" Text="Full Name" runat="server" /></td>
    </tr>
    <tr style="display:">
    <td><asp:CheckBox ID="chkLastUpdatedDate" meta:resourcekey="chkLastUpdatedDate" Text="Date Last Updated/Published" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkStatisticInfo" meta:resourcekey="chkStatisticInfo" Text="Statistic Info" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkRating" meta:resourcekey="chkRating" Text="Rating Selection" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkComments" meta:resourcekey="chkComments" Text="Comment Posting" runat="server" /></td>
    </tr>
    <tr>
    <td style="padding-left:22px">
        <asp:CheckBox ID="chkCommentAnonymous" meta:resourcekey="chkCommentAnonymous" Text="Allow Anonymous" runat="server" />
    </td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkListingOrdering" meta:resourcekey="chkListingOrdering" Text="Listing Ordering" runat="server" /></td>
    </tr>
    <tr>
    <td style="padding-left:22px">
        <table>
        <tr>
        <td>
            <div><asp:CheckBox ID="chkOrderByTitle" meta:resourcekey="chkOrderByTitle" Text="By Title" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByAuthor" meta:resourcekey="chkOrderByAuthor" Text="By Author" runat="server" /></div>    
            <div><asp:CheckBox ID="chkOrderByPersonLastUpdating" meta:resourcekey="chkOrderByPersonLastUpdating" Text="By Person Last Updating" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByPublishDate" meta:resourcekey="chkOrderByPublishDate" Text="By Publish Date" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByLastUpdatedDate" meta:resourcekey="chkOrderByLastUpdatedDate" Text="By Last Updated Date" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByRating" meta:resourcekey="chkOrderByRating" Text="By Rating" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByComments" meta:resourcekey="chkOrderByComments" Text="By Comments" runat="server" /></div>
        </td>
        <td>            
            <div><asp:CheckBox ID="chkOrderBySize" meta:resourcekey="chkOrderBySize" Text="By Download Size" runat="server" /></div>    
            <div><asp:CheckBox ID="chkOrderByTotalDownloads" meta:resourcekey="chkOrderByTotalDownloads" Text="By Total Downloads" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByDownloadsToday" meta:resourcekey="chkOrderByDownloadsToday" Text="By Downloads Today" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByTotalHits" meta:resourcekey="chkOrderByTotalHits" Text="By Total Hits" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByHitsToday" meta:resourcekey="chkOrderByHitsToday" Text="By Hits Today" runat="server" /></div>
            <div><asp:CheckBox ID="chkOrderByPrice" meta:resourcekey="chkOrderByPrice" Text="By Price" runat="server" /></div>
        </td>
        </tr>
        </table>&nbsp;
    </td>
    </tr>
    <tr id="idAlsoOnListing" runat="server">
    <td><asp:Label ID="lblVisibleOnPageAndListing" meta:resourcekey="lblVisibleOnPageAndListing" runat="server" Font-Bold="true" Text="Visible on this page and listing entry pages"></asp:Label></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkCalendar" meta:resourcekey="chkCalendar" Text="Calendar" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkMonthList" meta:resourcekey="chkMonthList" Text="Month List" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkCategoryList" meta:resourcekey="chkCategoryList" Text="Category List" runat="server" /></td>
    </tr>
    <tr>
    <td>
        <asp:CheckBox ID="chkSubscribe" meta:resourcekey="chkSubscribe" Text="Rss" runat="server" />
        <asp:CheckBox ID="chkPodcast" meta:resourcekey="chkPodcast" Text="Podcast" runat="server" />
    </td>
    </tr>
    <tr id="idOnListing" runat="server">
    <td style="padding-top:20px">
        <asp:Label ID="lblVisibleOnListing" meta:resourcekey="lblVisibleOnListing" Font-Bold="true" runat="server" Text="Visible on listing entry pages"></asp:Label>
    </td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkPostedBy" meta:resourcekey="chkPostedBy" Text="Posted By (Person Last Updating)" runat="server" /></td>
    </tr>
    <tr>
    <td style="padding-left:22px"><asp:CheckBox ID="chkPostedByFullName" meta:resourcekey="chkPostedByFullName" Text="Full Name" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkDisplayDate" meta:resourcekey="chkDisplayDate" Text="Display Date" runat="server" /></td>
    </tr>
    <tr>
    <td><asp:CheckBox ID="chkCategoryInfo" meta:resourcekey="chkCategoryInfo" Text="Category Info" runat="server" /></td>
    </tr>
    </table>

</td>
</tr>
<tr>
<td align="right" style="border-top:#CCCCCC 3px solid;padding:10px;padding-right:15px">    
    <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold="true"></asp:Label>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
    <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " OnClick="btnSave_Click" />
</td>
</tr>
</table>


</form>
</body>
</html>
