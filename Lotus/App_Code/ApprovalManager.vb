Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlClient.SqlParameterCollection
Imports System.Web.Security
Imports System.Web.Security.roles
Imports System.Web.Security.Membership
Imports System.Net.Mail

Public Class WorkflowManager
    Private sConn As String
    Private oConn As SqlConnection

    Public Function GetEditorApprovalList(ByVal strEditor As String) As Collection
        Dim sql As String = "SELECT * FROM pages WHERE status=@status ORDER BY channel_id ASC, last_updated_date DESC "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        Dim content As CMSContent
        Dim colContent As Collection = New Collection
        While reader.Read
            content = New CMSContent
            ReadContentFromReader(reader, content)
            colContent.Add(content, CStr(content.PageId))
        End While
        reader.Close()
        oConn.Close()

        Return colContent
    End Function

    Public Function GetEditorApprovalDataSet(ByVal strEditor As String) As DataSet
        Dim sql As String = "SELECT * FROM pages WHERE status=@status ORDER BY channel_id ASC, last_updated_date DESC "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR
        oConn.Open()
        oCmd.Connection = oConn
        Dim da As SqlDataAdapter = New SqlDataAdapter(oCmd)
        Dim ds As DataSet = New DataSet
        da.Fill(ds)
        oConn.Close()
        Return ds
    End Function

    Public Function GetPublisherApprovalList(ByVal strEditor As String) As Collection
        Dim sql As String = "SELECT * FROM pages WHERE status=@status ORDER BY channel_id ASC, last_updated_date DESC "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        Dim content As CMSContent
        Dim colContent As Collection = New Collection
        While reader.Read
            content = New CMSContent
            ReadContentFromReader(reader, content)
            colContent.Add(content, CStr(content.PageId))
        End While
        reader.Close()
        oConn.Close()

        Return colContent
    End Function

    Public Function GetPublisherApprovalDataSet(ByVal strEditor As String) As DataSet
        Dim sql As String = "SELECT * FROM pages WHERE status=@status ORDER BY channel_id ASC, last_updated_date DESC "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR
        oConn.Open()
        oCmd.Connection = oConn
        Dim da As SqlDataAdapter = New SqlDataAdapter(oCmd)
        Dim ds As DataSet = New DataSet
        da.Fill(ds)
        oConn.Close()
        Return ds
    End Function

    Public Function EditorApprove(ByVal strEditor As String, ByVal intPageId As Integer) As Boolean
        Dim contentMgr As ContentManager = New ContentManager
        Dim channelMgr As ChannelManager = New ChannelManager
        Dim content As CMSContent = contentMgr.GetLatestVersion(intPageId)
        'If (Not channelMgr.IsEditorInChannel(strEditor, content.ChannelId)) Then
        '    'user not authorized
        '    Return False
        'End If

        If (Not content.Status = CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR) Then
            'status not valid anymore
            Return False
        End If

        'mail to
        Dim mailTo As String() = New String() {GetUser(content.LastUpdatedBy).Email}
        Dim body As String = ""

        'approve the content
        SetEditorReview(content.PageId, content.Version)
        If (channelMgr.NeedPublisherApproval(content.ChannelId)) Then
            SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") has been approved by Editor and submitted for Publisher review "
        Else
            'publish content
            If (content.MarkedForArchival) Then
                contentMgr.ArchiveContent(content.PageId, content.Version)
                body = "Content (" & content.FileName & ", title: " & content.Title & ") marked for archival has been approved by Editor"

            Else
                contentMgr.PublishContent(content.PageId, content.Version)
                body = "Content (" & content.FileName & ", title: " & content.Title & ") has been approved by Editor and published "
            End If
        End If

        'send email
        If ConfigurationManager.AppSettings("UseWorkflowEmailNotification") = "yes" Then
            SendMail(Nothing, mailTo, "Editor Approved", body)
        End If

        Return True
    End Function

    Public Function EditorReject(ByVal strEditor As String, ByVal intPageId As Integer) As Boolean
        Dim contentMgr As ContentManager = New ContentManager
        Dim channelMgr As ChannelManager = New ChannelManager
        Dim content As CMSContent = contentMgr.GetLatestVersion(intPageId)
        'If (Not channelMgr.IsEditorInChannel(strEditor, content.ChannelId)) Then
        '    'user not authorized
        '    Return False
        'End If

        If (Not content.Status = CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR) Then
            'status not valid anymore
            Return False
        End If

        'mail to
        Dim mailTo As String() = New String() {GetUser(content.LastUpdatedBy).Email}
        Dim body As String = ""

        'reject the content
        SetEditorReview(content.PageId, content.Version)
        If (content.MarkedForArchival) Then
            'if mark for archival, set mark for archival to false and set the status to unlock.
            contentMgr.MarkForArchival(content.PageId, content.Version, False)
            SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_UNLOCKED)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") marked for archival has been declined by Editor"
        Else
            SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_CONTENT_REVISION)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") has been declined by Editor"
        End If

        'send email
        If ConfigurationManager.AppSettings("UseWorkflowEmailNotification") = "yes" Then
            SendMail(Nothing, mailTo, "Editor Declined", body)
        End If
        Return (True)
    End Function

    Public Function PublisherApprove(ByVal strPub As String, ByVal intPageId As Integer) As Boolean
        Dim contentMgr As ContentManager = New ContentManager
        Dim channelMgr As ChannelManager = New ChannelManager
        Dim content As CMSContent = contentMgr.GetLatestVersion(intPageId)
        'If (Not channelMgr.IsPublisherInChannel(strPub, content.ChannelId)) Then
        '    'user not authorized
        '    Return False
        'End If

        If (Not content.Status = CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR) Then
            'status not valid anymore
            Return False
        End If

        'mail to
        Dim mailTo As String() = New String() {GetUser(content.LastUpdatedBy).Email}
        Dim body As String = ""

        'approve content
        SetPublisherReview(content.PageId, content.Version)
        If (content.MarkedForArchival) Then
            contentMgr.ArchiveContent(content.PageId, content.Version)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") marked for archival has been approved by Publisher"
        Else
            contentMgr.PublishContent(content.PageId, content.Version)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") has been approved by Publisher and published "
        End If

        'send email
        If ConfigurationManager.AppSettings("UseWorkflowEmailNotification") = "yes" Then
            SendMail(Nothing, mailTo, "Publisher Approved", body)
        End If
        Return True
    End Function

    Public Function PublisherReject(ByVal strPub As String, ByVal intPageId As Integer) As Boolean
        Dim contentMgr As ContentManager = New ContentManager
        Dim channelMgr As ChannelManager = New ChannelManager
        Dim content As CMSContent = contentMgr.GetLatestVersion(intPageId)
        'If (Not channelMgr.IsPublisherInChannel(strPub, content.ChannelId)) Then
        '    'user not authorized
        '    Return False
        'End If

        If (Not content.Status = CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR) Then
            'status not valid anymore
            Return False
        End If

        'mail to
        Dim mailTo As String() = New String() {GetUser(content.LastUpdatedBy).Email}
        Dim body As String = ""

        'reject the content
        SetPublisherReview(content.PageId, content.Version)
        If (content.MarkedForArchival) Then
            'if mark for archival, set mark for archival to false and set the status to unlock.
            contentMgr.MarkForArchival(content.PageId, content.Version, False)
            SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_UNLOCKED)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") marked for archival has been declined by Publisher"
        Else
            SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_PROP_REVISION_UNLOCKED)
            body = "Content (" & content.FileName & ", title: " & content.Title & ") has been declined by Publisher"
        End If

        'send email
        If ConfigurationManager.AppSettings("UseWorkflowEmailNotification") = "yes" Then
            SendMail(Nothing, mailTo, "Publisher Declined", body)
        End If
    End Function

    Private Function SetEditorReview(ByVal intPageId As Integer, ByVal intVersion As Integer) As Boolean
        Dim sql As String = "UPDATE pages SET editor_review_by=@editor_review_by, " & _
            "last_updated_date=@last_updated_date WHERE page_id=@page_id AND version=@version"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@editor_review_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        oCmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
    End Function

    Private Function SetPublisherReview(ByVal intPageId As Integer, ByVal intVersion As Integer) As Boolean
        Dim sql As String = "UPDATE pages SET publisher_review_by=@publisher_review_by, " & _
            "last_updated_date=@last_updated_date WHERE page_id=@page_id AND version=@version"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@publisher_review_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        oCmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
    End Function

    Private Sub SetLastUpdateProp(ByVal intPageId As Integer, ByVal intVersion As Integer)
        Dim sql As String = "UPDATE pages SET last_updated_by=@last_updated_by, " & _
            "last_updated_date=@last_updated_date WHERE page_id=@page_id AND version=@version"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        oCmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
    End Sub

    Private Function SetContentStatus(ByVal pageId As Integer, ByVal version As Integer, ByVal status As String) As Boolean
        Dim sql As String = "UPDATE pages SET status=@status, " & _
            "last_updated_date=@last_updated_date " & _
            "WHERE page_id=@page_id AND version=@version "

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = status
        'cmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        cmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = pageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = version

        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()

        Return True
    End Function

    Private Function SendMail(ByVal maFrom As MailAddress, ByVal mailTo() As String, ByVal strSubject As String, ByVal strBody As String) As Boolean
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage

        Try
            Dim i As Integer
            For i = 0 To UBound(mailTo)
                oMailMessage.To.Add(mailTo(i))
            Next

            oMailMessage.Subject = strSubject
            oMailMessage.IsBodyHtml = False
            oMailMessage.Body = strBody

            oSmtpClient.Send(oMailMessage)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub ReadContentFromReader(ByVal reader As SqlDataReader, ByRef content As CMSContent)
        If reader.Read() Then
            With content
                .PageId = Convert.ToInt32(reader("page_id"))
                .Version = Convert.ToInt32(reader("version"))
                .ParentId = Convert.ToInt32(reader("parent_id"))
                .Sorting = Convert.ToInt32(reader("sorting"))
                .ChannelId = Convert.ToInt32(reader("channel_id"))
                .UseDefaultTemplate = Convert.ToBoolean(reader("use_default_template"))
                If (IsDBNull(reader("template_id"))) Then
                    .TemplateId = Nothing
                Else
                    .TemplateId = Convert.ToInt32(reader("template_id"))
                End If
                .FileName = reader("file_name").ToString
                .Title = reader("title").ToString
                .Summary = reader("summary").ToString
                If (IsDBNull(reader("price"))) Then
                    .Price = Nothing
                Else
                    .Price = Convert.ToDecimal(reader("price"))
                End If
                If (IsDBNull(reader("sale_price"))) Then
                    .SalePrice = Nothing
                Else
                    .SalePrice = Convert.ToDecimal(reader("sale_price"))
                End If
                If (IsDBNull(reader("discount_percentage"))) Then
                    .DiscountPercentage = Nothing
                Else
                    .DiscountPercentage = Convert.ToInt32(reader("discount_percentage"))
                End If
                If (IsDBNull(reader("weight"))) Then
                    .Weight = Nothing
                Else
                    .Weight = Convert.ToDecimal(reader("weight"))
                End If
                .SKU = reader("sku").ToString
                If (IsDBNull(reader("units_in_stock"))) Then
                    .UnitsInStock = Nothing
                Else
                    .UnitsInStock = Convert.ToInt32(reader("units_in_stock"))
                End If
                .LinkText = reader("link_text").ToString
                .LinkPlacement = reader("link_placement").ToString
                .ContentLeft = reader("content_left").ToString
                .ContentBody = reader("content_body").ToString
                .ContentRight = reader("content_right").ToString
                .FileAttachment = reader("file_attachment").ToString
                .FileView = reader("file_view").ToString
                .FileViewListing = reader("file_view_listing").ToString
                If (IsDBNull(reader("tangible"))) Then
                    .Tangible = False
                Else
                    .Tangible = Convert.ToBoolean(reader("tangible"))
                End If
                .FileSize = Convert.ToInt32(reader("file_size"))
                .Owner = reader("owner").ToString
                .CreatedDate = Convert.ToDateTime(reader("created_date"))
                .LastUpdatedDate = Convert.ToDateTime(reader("last_updated_date"))
                .LastUpdatedBy = reader("last_updated_by").ToString
                If (IsDBNull(reader("published_start_date"))) Then
                    .PublishStart = Nothing
                Else
                    .PublishStart = Convert.ToDateTime(reader("published_start_date"))
                End If
                If (IsDBNull(reader("published_end_date"))) Then
                    .PublishEnd = Nothing
                Else
                    .PublishEnd = Convert.ToDateTime(reader("published_end_date"))
                End If
                .MetaTitle = reader("meta_title").ToString
                .MetaKeywords = reader("meta_keywords").ToString
                .MetaDescription = reader("meta_description").ToString
                .Status = reader("status").ToString
                .IsHidden = Convert.ToBoolean(reader("is_hidden"))
                .IsSystem = Convert.ToBoolean(reader("is_system"))
                .PageModule = reader("page_module").ToString
                .PageType = Convert.ToInt32(reader("page_type"))
                .UseDiscussion = Convert.ToBoolean(reader("use_discussion"))
                .UseRating = Convert.ToBoolean(reader("use_rating"))
                If (IsDBNull(reader("use_comments"))) Then
                    .UseComments = Nothing
                Else
                    .UseComments = Convert.ToBoolean(reader("use_comments"))
                End If
                .AllowLinksCrawled = Convert.ToBoolean(reader("allow_links_crawled"))
                .AllowPageIndexed = Convert.ToBoolean(reader("allow_page_indexed"))
                .Notes = reader("notes").ToString
                .MarkedForArchival = Convert.ToBoolean(reader("is_marked_for_archival"))
                If (IsDBNull(reader("display_date"))) Then
                    .DisplayDate = Nothing
                Else
                    .DisplayDate = Convert.ToDateTime(reader("display_date"))
                End If
                .Properties = reader("properties").ToString
                .Properties2 = reader("properties2").ToString
                .IsHttps = Convert.ToBoolean(reader("https"))
                .RootId = Convert.ToInt32(reader("root_id"))
                If (IsDBNull(reader("event_start_date"))) Then
                    .EventStartDate = Nothing
                Else
                    .EventStartDate = Convert.ToDateTime(reader("event_start_date"))
                End If
                If (IsDBNull(reader("event_end_date"))) Then
                    .EventEndDate = Nothing
                Else
                    .EventEndDate = Convert.ToDateTime(reader("event_end_date"))
                End If
                If (IsDBNull(reader("event_all_day"))) Then
                    .EventAllDay = False
                Else
                    .EventAllDay = Convert.ToBoolean(reader("event_all_day"))
                End If

                If (IsDBNull(reader("is_listing"))) Then
                    .IsListing = Nothing
                Else
                    .IsListing = Convert.ToBoolean(reader("is_listing"))
                End If
                If (IsDBNull(reader("listing_type"))) Then
                    .ListingType = Nothing
                Else
                    .ListingType = Convert.ToInt32(reader("listing_type"))
                End If
                If (IsDBNull(reader("listing_property"))) Then
                    .ListingProperty = Nothing
                Else
                    .ListingProperty = Convert.ToInt32(reader("listing_property"))
                End If
                If (IsDBNull(reader("listing_datetime_format"))) Then
                    .ListingDatetimeFormat = Nothing
                Else
                    .ListingDatetimeFormat = Convert.ToString(reader("listing_datetime_format"))
                End If
                If (IsDBNull(reader("listing_columns"))) Then
                    .ListingColumns = Nothing
                Else
                    .ListingColumns = Convert.ToInt32(reader("listing_columns"))
                End If
                If (IsDBNull(reader("listing_page_size"))) Then
                    .ListingPageSize = Nothing
                Else
                    .ListingPageSize = Convert.ToInt32(reader("listing_page_size"))
                End If
                If (IsDBNull(reader("listing_template_id"))) Then
                    .ListingTemplateId = Nothing
                Else
                    .ListingTemplateId = Convert.ToInt32(reader("listing_template_id"))
                End If
                If (IsDBNull(reader("listing_use_categories"))) Then
                    .ListingUseCategories = Nothing
                Else
                    .ListingUseCategories = Convert.ToBoolean(reader("listing_use_categories"))
                End If
                If (IsDBNull(reader("elements"))) Then
                    .Elements = Nothing
                Else
                    .Elements = Convert.ToString(reader("elements"))
                End If
                If (IsDBNull(reader("listing_elements"))) Then
                    .ListingElements = Nothing
                Else
                    .ListingElements = Convert.ToString(reader("listing_elements"))
                End If

                If (IsDBNull(reader("link"))) Then
                    .Link = Nothing
                Else
                    .Link = Convert.ToString(reader("link"))
                End If
                If (IsDBNull(reader("link_target"))) Then
                    .LinkTarget = Nothing
                Else
                    .LinkTarget = Convert.ToString(reader("link_target"))
                End If
                If (IsDBNull(reader("is_link"))) Then
                    .IsLink = Nothing
                Else
                    .IsLink = Convert.ToBoolean(reader("is_link"))
                End If
                .ListingDefaultOrder = reader("listing_default_order").ToString
                If (IsDBNull(reader("first_published_date"))) Then
                    .FirstPublishedDate = Nothing
                Else
                    .FirstPublishedDate = Convert.ToDateTime(reader("first_published_date"))
                End If
            End With
        Else
            content = Nothing
        End If

    End Sub

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub
End Class
