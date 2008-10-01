Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlClient.SqlParameterCollection
Imports System.Web.Security
Imports System.Web.Security.roles
Imports System.Web.Security.Membership
Imports System.Net.Mail

Public Class CMSContent

    Public Const STATUS_LOCKED As String = "locked"
    Public Const STATUS_UNLOCKED As String = "unlocked"
    Public Const STATUS_WAIT_FOR_EDITOR_APPVR As String = "waiting_for_editor_approval"
    Public Const STATUS_CONTENT_REVISION As String = "need_content_revision_unlocked"
    Public Const STATUS_WAIT_FOR_PUBLISHER_APPVR As String = "waiting_for_publisher_approval"
    Public Const STATUS_PROP_REVISION_LOCKED As String = "need_property_revision_locked"
    Public Const STATUS_PROP_REVISION_UNLOCKED As String = "need_property_revision_unlocked"
    Public Const STATUS_PUBLISHED As String = "published"
    Public Const STATUS_UNPUBLISHED As String = "unpublished"
    Public Const STATUS_ARCHIVED As String = "archived"
    Public Const STATUS_PUBLISHED_ARCHIVED As String = "published_archived"

    Private intPageId As Integer
    Private intVersion As Integer
    Private intParentId As Integer
    Private intSorting As Integer
    Private intChanneld As Integer
    Private bolDefaultTemplate As Boolean
    Private intTemplateId As Integer
    Private strFileName As String = ""
    Private strTitle As String = ""
    Private strSummary As String = ""
    Private monPrice As Nullable(Of Decimal)
    Private monSalePrice As Nullable(Of Decimal)
    Private intDiscountPercentage As Integer
    Private decWeight As Nullable(Of Decimal)
    Private strSKU As String
    Private intUnitsInStock As Integer
    Private strLinkText As String = ""
    Private strLinkPlacement As String = ""
    Private strContentLeft As String = ""
    Private strContentBody As String = ""
    Private strContentRight As String = ""
    Private strFileAttachment As String = ""
    Private strFileView As String = ""
    Private strFileViewListing As String = ""
    Private bolTangible As Boolean = False
    Private intFileSize As Integer = 0
    Private strOwner As String = ""
    Private dtCreatedDate As DateTime = Now
    Private dtLastUpdatedDate As DateTime = Now
    Private strLastUpdatedBy As String = ""
    Private dtPublishStart As DateTime = Nothing
    Private dtPublishEnd As DateTime = Nothing
    Private strMetaTitle As String = ""
    Private strMetaKeywords As String = ""
    Private strMetaDescription As String = ""
    Private strStatus As String = CMSContent.STATUS_LOCKED
    Private bolIsHidden As Boolean
    Private bolIsSystem As Boolean
    Private strPageModule As String = ""
    Private intPageType As Integer
    Private bolUseDiscussion As Boolean
    Private bolUseRating As Boolean
    Private bolUseComments As Boolean
    Private bolAllowLinksCrawled As Boolean
    Private bolAllowPageIndexed As Boolean
    Private bolMarkedForArchival As Boolean
    Private strNotes As String = ""
    Private dtDisplayDate As DateTime = Now
    Private strProperties As String = ""
    Private strProperties2 As String = ""
    Private bolHttps As Boolean
    Private intRootId As Integer
    Private bolEventAllDay As Boolean = False
    Private dtEventStartDate As DateTime = Now
    Private dtEventEndDate As DateTime = Now
    Private bolIsListing As Boolean
    Private intListingType As Integer
    Private intListingProperty As Integer
    Private strListingDatetimeFormat As String
    Private intListingColumns As Integer
    Private intListingPageSize As Integer
    Private intListingTemplateId As Integer
    Private bolListingUseCategories As Boolean
    Private strElements As String
    Private strListingElements As String
    Private strListingDefaultOrder As String = ""
    Private sLink As String = ""
    Private sLinkTarget As String = ""
    Private bolIsLink As Boolean
    Private dtFirstPublishedDate As DateTime

    Public Property IsListing() As Boolean
        Get
            IsListing = bolIsListing
        End Get
        Set(ByVal value As Boolean)
            bolIsListing = value
        End Set
    End Property
    Public Property ListingType() As Integer
        Get
            Return intListingType
        End Get
        Set(ByVal value As Integer)
            intListingType = value
        End Set
    End Property
    Public Property ListingProperty() As Integer
        Get
            Return intListingProperty
        End Get
        Set(ByVal value As Integer)
            intListingProperty = value
        End Set
    End Property
    Public Property ListingDatetimeFormat() As String
        Get
            Return strListingDatetimeFormat
        End Get
        Set(ByVal value As String)
            strListingDatetimeFormat = value
        End Set
    End Property
    Public Property ListingColumns() As Integer
        Get
            Return intListingColumns
        End Get
        Set(ByVal value As Integer)
            intListingColumns = value
        End Set
    End Property
    Public Property ListingPageSize() As Integer
        Get
            Return intListingPageSize
        End Get
        Set(ByVal value As Integer)
            intListingPageSize = value
        End Set
    End Property
    Public Property ListingTemplateId() As Integer
        Get
            Return intListingTemplateId
        End Get
        Set(ByVal value As Integer)
            intListingTemplateId = value
        End Set
    End Property
    Public Property ListingUseCategories() As Boolean
        Get
            Return bolListingUseCategories
        End Get
        Set(ByVal value As Boolean)
            bolListingUseCategories = value
        End Set
    End Property
    Public Property ListingDefaultOrder() As String
        Get
            Return strListingDefaultOrder
        End Get
        Set(ByVal value As String)
            strListingDefaultOrder = value
        End Set
    End Property
    Public Property Elements() As String
        Get
            Return strElements
        End Get
        Set(ByVal value As String)
            strElements = value
        End Set
    End Property

    Public Property ListingElements() As String
        Get
            Return strListingElements
        End Get
        Set(ByVal value As String)
            strListingElements = value
        End Set
    End Property

    Public Property Link() As String
        Get
            Link = sLink
        End Get
        Set(ByVal value As String)
            sLink = value
        End Set
    End Property
    Public Property LinkTarget() As String
        Get
            LinkTarget = sLinkTarget
        End Get
        Set(ByVal value As String)
            sLinkTarget = value
        End Set
    End Property
    Public Property IsLink() As Boolean
        Get
            IsLink = bolIsLink
        End Get
        Set(ByVal value As Boolean)
            bolIsLink = value
        End Set
    End Property

    Public Property PageId() As Integer
        Get
            Return intPageId
        End Get
        Set(ByVal value As Integer)
            intPageId = value
        End Set
    End Property
    Public Property Version() As Integer
        Get
            Return intVersion
        End Get
        Set(ByVal value As Integer)
            intVersion = value
        End Set
    End Property
    Public Property ParentId() As Integer
        Get
            ParentId = intParentId
        End Get
        Set(ByVal value As Integer)
            intParentId = value
        End Set
    End Property
    Public Property Sorting() As Integer
        Get
            Sorting = intSorting
        End Get
        Set(ByVal value As Integer)
            intSorting = value
        End Set
    End Property
    Public Property ChannelId() As Integer
        Get
            ChannelId = intChanneld
        End Get
        Set(ByVal value As Integer)
            intChanneld = value
        End Set
    End Property
    Public Property UseDefaultTemplate() As Boolean
        Get
            UseDefaultTemplate = bolDefaultTemplate
        End Get
        Set(ByVal value As Boolean)
            bolDefaultTemplate = value
        End Set
    End Property
    Public Property TemplateId() As Integer
        Get
            TemplateId = intTemplateId
        End Get
        Set(ByVal value As Integer)
            intTemplateId = value
        End Set
    End Property
    Public Property FileName() As String
        Get
            FileName = strFileName
        End Get
        Set(ByVal value As String)
            strFileName = value
        End Set
    End Property
    Public Property Title() As String
        Get
            Title = strTitle
        End Get
        Set(ByVal value As String)
            strTitle = value
        End Set
    End Property
    Public Property Summary() As String
        Get
            Summary = strSummary
        End Get
        Set(ByVal value As String)
            strSummary = value
        End Set
    End Property
    Public Property Price() As Nullable(Of Decimal)
        Get
            Price = monPrice
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            monPrice = value
        End Set
    End Property
    Public Property SalePrice() As Nullable(Of Decimal)
        Get
            Return monSalePrice
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            monSalePrice = value
        End Set
    End Property
    Public Property DiscountPercentage() As Integer
        Get
            Return intDiscountPercentage
        End Get
        Set(ByVal value As Integer)
            intDiscountPercentage = value
        End Set
    End Property

    Public Property Weight() As Nullable(Of Decimal)
        Get
            Return decWeight
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            decWeight = value
        End Set
    End Property
    Public Property SKU() As String
        Get
            Return strSKU
        End Get
        Set(ByVal value As String)
            strSKU = value
        End Set
    End Property
    Public Property UnitsInStock() As Integer
        Get
            Return intUnitsInStock
        End Get
        Set(ByVal value As Integer)
            intUnitsInStock = value
        End Set
    End Property

    Public Property LinkText() As String
        Get
            LinkText = strLinkText
        End Get
        Set(ByVal value As String)
            strLinkText = value
        End Set
    End Property
    Public Property LinkPlacement() As String
        Get
            LinkPlacement = strLinkPlacement
        End Get
        Set(ByVal value As String)
            strLinkPlacement = value
        End Set
    End Property
    Public Property ContentLeft() As String
        Get
            ContentLeft = strContentLeft
        End Get
        Set(ByVal value As String)
            strContentLeft = value
        End Set
    End Property
    Public Property ContentBody() As String
        Get
            ContentBody = strContentBody
        End Get
        Set(ByVal value As String)
            strContentBody = value
        End Set
    End Property
    Public Property ContentRight() As String
        Get
            ContentRight = strContentRight
        End Get
        Set(ByVal value As String)
            strContentRight = value
        End Set
    End Property
    Public Property FileAttachment() As String
        Get
            Return strFileAttachment
        End Get
        Set(ByVal value As String)
            strFileAttachment = value
        End Set
    End Property
    Public Property FileView() As String
        Get
            Return strFileView
        End Get
        Set(ByVal value As String)
            strFileView = value
        End Set
    End Property
    Public Property FileViewListing() As String
        Get
            Return strFileViewListing
        End Get
        Set(ByVal value As String)
            strFileViewListing = value
        End Set
    End Property
    Public Property Tangible() As Boolean
        Get
            Return bolTangible
        End Get
        Set(ByVal value As Boolean)
            bolTangible = value
        End Set
    End Property
    Public Property FileSize() As Integer
        Get
            Return intFileSize
        End Get
        Set(ByVal value As Integer)
            intFileSize = value
        End Set
    End Property
    Public Property Owner() As String
        Get
            Owner = strOwner
        End Get
        Set(ByVal value As String)
            strOwner = value
        End Set
    End Property
    Public Property CreatedDate() As DateTime
        Get
            CreatedDate = dtCreatedDate
        End Get
        Set(ByVal value As DateTime)
            dtCreatedDate = value
        End Set
    End Property
    Public Property LastUpdatedDate() As DateTime
        Get
            LastUpdatedDate = dtLastUpdatedDate
        End Get
        Set(ByVal value As DateTime)
            dtLastUpdatedDate = value
        End Set
    End Property
    Public Property LastUpdatedBy() As String
        Get
            LastUpdatedBy = strLastUpdatedBy
        End Get
        Set(ByVal value As String)
            strLastUpdatedBy = value
        End Set
    End Property
    Public Property PublishStart() As DateTime
        Get
            PublishStart = dtPublishStart
        End Get
        Set(ByVal value As DateTime)
            dtPublishStart = value
        End Set
    End Property
    Public Property PublishEnd() As DateTime
        Get
            PublishEnd = dtPublishEnd
        End Get
        Set(ByVal value As DateTime)
            dtPublishEnd = value
        End Set
    End Property
    Public Property MetaTitle() As String
        Get
            MetaTitle = strMetaTitle
        End Get
        Set(ByVal value As String)
            strMetaTitle = value
        End Set
    End Property
    Public Property MetaKeywords() As String
        Get
            MetaKeywords = strMetaKeywords
        End Get
        Set(ByVal value As String)
            strMetaKeywords = value
        End Set
    End Property
    Public Property MetaDescription() As String
        Get
            MetaDescription = strMetaDescription
        End Get
        Set(ByVal value As String)
            strMetaDescription = value
        End Set
    End Property
    Public Property Status() As String
        Get
            Status = strStatus
        End Get
        Set(ByVal value As String)
            strStatus = value
        End Set
    End Property
    Public Property IsHidden() As Boolean
        Get
            IsHidden = bolIsHidden
        End Get
        Set(ByVal value As Boolean)
            bolIsHidden = value
        End Set
    End Property
    Public Property IsSystem() As Boolean
        Get
            IsSystem = bolIsSystem
        End Get
        Set(ByVal value As Boolean)
            bolIsSystem = value
        End Set
    End Property
    Public Property PageModule() As String
        Get
            PageModule = strPageModule
        End Get
        Set(ByVal value As String)
            strPageModule = value
        End Set
    End Property
    Public Property PageType() As Integer
        Get
            PageType = intPageType
        End Get
        Set(ByVal value As Integer)
            intPageType = value
        End Set
    End Property
    Public Property UseDiscussion() As Boolean
        Get
            UseDiscussion = bolUseDiscussion
        End Get
        Set(ByVal value As Boolean)
            bolUseDiscussion = value
        End Set
    End Property
    Public Property UseRating() As Boolean
        Get
            UseRating = bolUseRating
        End Get
        Set(ByVal value As Boolean)
            bolUseRating = value
        End Set
    End Property
    Public Property UseComments() As Boolean
        Get
            UseComments = bolUseComments
        End Get
        Set(ByVal value As Boolean)
            bolUseComments = value
        End Set
    End Property
    Public Property AllowLinksCrawled() As Boolean
        Get
            AllowLinksCrawled = bolAllowLinksCrawled
        End Get
        Set(ByVal value As Boolean)
            bolAllowLinksCrawled = value
        End Set
    End Property
    Public Property AllowPageIndexed() As Boolean
        Get
            AllowPageIndexed = bolAllowPageIndexed
        End Get
        Set(ByVal value As Boolean)
            bolAllowPageIndexed = value
        End Set
    End Property
    Public Property MarkedForArchival() As Boolean
        Get
            MarkedForArchival = bolMarkedForArchival
        End Get
        Set(ByVal value As Boolean)
            bolMarkedForArchival = value
        End Set
    End Property
    Public Property Notes() As String
        Get
            Notes = strNotes
        End Get
        Set(ByVal value As String)
            strNotes = value
        End Set
    End Property
    Public Property DisplayDate() As DateTime
        Get
            DisplayDate = dtDisplayDate
        End Get
        Set(ByVal value As DateTime)
            dtDisplayDate = value
        End Set
    End Property
    Public Property Properties() As String
        Get
            Properties = strProperties
        End Get
        Set(ByVal value As String)
            strProperties = value
        End Set
    End Property

    Public Property Properties2() As String
        Get
            Properties2 = strProperties2
        End Get
        Set(ByVal value As String)
            strProperties2 = value
        End Set
    End Property

    Public Property RootId() As Integer
        Get
            RootId = intRootId
        End Get
        Set(ByVal value As Integer)
            intRootId = value
        End Set
    End Property

    Public Property IsHttps() As Boolean
        Get
            Properties2 = bolHttps
        End Get
        Set(ByVal value As Boolean)
            bolHttps = value
        End Set
    End Property

    Public Property EventAllDay() As Boolean
        Get
            EventAllDay = bolEventAllDay
        End Get
        Set(ByVal value As Boolean)
            bolEventAllDay = value
        End Set
    End Property

    Public Property EventStartDate() As DateTime
        Get
            EventStartDate = dtEventStartDate
        End Get
        Set(ByVal value As DateTime)
            dtEventStartDate = value
        End Set
    End Property
    Public Property EventEndDate() As DateTime
        Get
            EventEndDate = dtEventEndDate
        End Get
        Set(ByVal value As DateTime)
            dtEventEndDate = value
        End Set
    End Property
    Public Property FirstPublishedDate() As DateTime
        Get
            Return dtFirstPublishedDate
        End Get
        Set(ByVal value As DateTime)
            dtFirstPublishedDate = value
        End Set
    End Property

    Public Sub New()

    End Sub

    Public Sub New(ByVal intPageId As Integer, ByVal intVersion As Integer)
        Me.PageId = intPageId
        Me.Version = intVersion
    End Sub
End Class

Public Class ContentManager
    Private sConn As String
    Private oConn As SqlConnection

    Private Function ValidateContent() As Boolean
        'validate the record before insert
    End Function

    Private Function SetContentStatus(ByVal pageId As Integer, ByVal version As Integer, ByVal status As String) As Boolean
        Dim sql As String = "UPDATE pages SET status=@status, " & _
            "last_updated_by=@last_updated_by, last_updated_date=@last_updated_date " & _
            "WHERE page_id=@page_id AND version=@version "

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = status
        cmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
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

    'Public Function SubmitContent(ByVal pageId As Integer, ByVal version As Integer, ByVal directPublish As Boolean, Optional ByVal repeatApproval As Boolean = True) As CMSContent
    Public Function SubmitContent(ByVal pageId As Integer, ByVal version As Integer, Optional ByVal repeatApproval As Boolean = True) As CMSContent

        'check of the content needs approval
        Dim content As CMSContent = GetContent(pageId, version)
        Dim chMgr As ChannelManager = New ChannelManager
        Dim needApprovalBy As Integer = chMgr.NeedApproval(content.ChannelId)
        If needApprovalBy <> CMSChannel.APPROVAL_NONE Then
            'submit the content for approval
            Select Case content.Status
                Case CMSContent.STATUS_LOCKED, CMSContent.STATUS_UNLOCKED, CMSContent.STATUS_CONTENT_REVISION
                    If needApprovalBy = CMSChannel.APPROVAL_BY_EDITOR Or needApprovalBy = CMSChannel.APPROVAL_BY_ALL Then
                        SetContentStatus(pageId, version, CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR)
                        SendEmailTo(content.ChannelId, "Editors", content)
                    Else
                        SetContentStatus(pageId, version, CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR)
                        SendEmailTo(content.ChannelId, "Publishers", content)
                    End If
                    SetLastUpdateProp(pageId, version)
                Case CMSContent.STATUS_PROP_REVISION_LOCKED, CMSContent.STATUS_PROP_REVISION_UNLOCKED
                    If repeatApproval And (needApprovalBy = CMSChannel.APPROVAL_BY_EDITOR Or needApprovalBy = CMSChannel.APPROVAL_BY_ALL) Then
                        SetContentStatus(pageId, version, CMSContent.STATUS_WAIT_FOR_EDITOR_APPVR)
                        SendEmailTo(content.ChannelId, "Editors", content)
                    ElseIf needApprovalBy = CMSChannel.APPROVAL_BY_PUBLISHER Or needApprovalBy = CMSChannel.APPROVAL_BY_ALL Then
                        SetContentStatus(pageId, version, CMSContent.STATUS_WAIT_FOR_PUBLISHER_APPVR)
                        SendEmailTo(content.ChannelId, "Publishers", content)
                    End If
            End Select
            Return Nothing
        End If

        'If directPublish Then
        PublishContent(pageId, version)
        SetLastUpdateProp(pageId, version)
        'End If

        Return GetContent(pageId, version)
    End Function

    Private Function SendEmailTo(ByVal channelId As Integer, ByVal roleType As String, ByVal content As CMSContent) As Boolean
        If ConfigurationManager.AppSettings("UseWorkflowEmailNotification") = "no" Then Return False

        Dim channelMgr As ChannelManager = New ChannelManager()
        Dim channel As CMSChannel = channelMgr.GetChannel(channelId)

        Dim allUsers() As String = GetUsersInRole(channel.ChannelName & " " & roleType)
        Dim i As Integer
        Dim mailTo(UBound(allUsers)) As String
        For i = LBound(allUsers) To UBound(allUsers)
            mailTo(i) = GetUser(allUsers(i)).Email
        Next
        Dim subject As String = "Waiting For Approval"
        Dim body As String = "Content (" & content.FileName & ", title: " & content.Title & ") has been submitted for your review."
        Return SendMail(Nothing, mailTo, subject, body)
    End Function

    Public Function PublishContent(ByVal pageId As Integer, ByVal version As Integer) As CMSContent

        'update previous version status to archived and publish latest version
        Dim cmd As SqlCommand

        cmd = New SqlCommand("advcms_PublishContent")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = pageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = version

        oConn.Open()
        cmd.Connection = oConn
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        cmd = Nothing
        oConn.Close()

        'SetLastUpdateProp(pageId, version)

        Return GetContent(pageId, version)
    End Function

    Public Function CreateContent(ByVal pg As CMSContent, ByVal intRefPage As Integer, ByVal strRefPos As String, Optional ByVal isListing As Boolean = False) As CMSContent

        Dim cmd As SqlCommand
        Dim pars As SqlParameterCollection

        cmd = New SqlCommand("advcms_InsertContent")
        cmd.CommandType = CommandType.StoredProcedure
        pars = cmd.Parameters
        With pars
            .Add("@refpageid", SqlDbType.Int).Value = intRefPage
            .Add("@refposition", SqlDbType.NVarChar, 50).Value = strRefPos
            .Add("@islisting", SqlDbType.Bit).Value = isListing

            .Add("@page_id", SqlDbType.Int).Value = pg.PageId
            .Add("@version", SqlDbType.Int).Value = 1
            .Add("@channel_id", SqlDbType.Int).Value = pg.ChannelId
            .Add("@use_default_template", SqlDbType.Bit).Value = True
            .Add("@template_id", SqlDbType.Int).Value = pg.TemplateId
            .Add("@file_name", SqlDbType.NVarChar, 50).Value = pg.FileName & ".aspx"
            .Add("@title", SqlDbType.NVarChar, 255).Value = pg.Title
            .Add("@summary", SqlDbType.NText).Value = pg.Summary
            .Add("@price", SqlDbType.Money).Value = pg.Price
            .Add("@sale_price", SqlDbType.Money).Value = pg.SalePrice
            .Add("@discount_percentage", SqlDbType.Int).Value = pg.DiscountPercentage
            .Add("@link_text", SqlDbType.NVarChar, 50).Value = pg.LinkText
            .Add("@link_placement", SqlDbType.NVarChar, 50).Value = pg.LinkPlacement
            .Add("@content_left", SqlDbType.NText).Value = pg.ContentLeft
            .Add("@content_body", SqlDbType.NText).Value = pg.ContentBody
            .Add("@content_right", SqlDbType.NText).Value = pg.ContentRight
            .Add("@file_attachment", SqlDbType.NVarChar, 255).Value = pg.FileAttachment
            .Add("@file_view", SqlDbType.NVarChar, 255).Value = pg.FileView
            .Add("@file_view_listing", SqlDbType.NVarChar, 255).Value = pg.FileViewListing
            .Add("@tangible", SqlDbType.Bit).Value = False
            .Add("@file_size", SqlDbType.Int).Value = pg.FileSize
            .Add("@owner", SqlDbType.NVarChar, 50).Value = pg.Owner
            .Add("@created_date", SqlDbType.DateTime).Value = Now
            .Add("@last_updated_date", SqlDbType.DateTime).Value = Now
            .Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = pg.LastUpdatedBy
            .Add("@published_start_date", SqlDbType.DateTime).Value = Nothing
            .Add("@published_end_date", SqlDbType.DateTime).Value = Nothing
            .Add("@meta_keywords", SqlDbType.NText).Value = pg.MetaKeywords
            .Add("@meta_description", SqlDbType.NText).Value = pg.MetaDescription
            .Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_LOCKED
            .Add("@is_hidden", SqlDbType.Bit).Value = False
            .Add("@is_system", SqlDbType.Bit).Value = False
            .Add("@page_module", SqlDbType.NVarChar, 255).Value = pg.PageModule
            .Add("@page_type", SqlDbType.Int).Value = pg.PageType
            .Add("@use_discussion", SqlDbType.Bit).Value = False
            .Add("@use_rating", SqlDbType.Bit).Value = False
            .Add("@use_comments", SqlDbType.Bit).Value = False
            .Add("@allow_links_crawled", SqlDbType.Bit).Value = True
            .Add("@allow_page_indexed", SqlDbType.Bit).Value = True
            .Add("@is_marked_for_archival", SqlDbType.Bit).Value = False
            .Add("@notes", SqlDbType.NText).Value = pg.Notes
            .Add("@display_date", SqlDbType.DateTime).Value = pg.DisplayDate
            .Add("@properties", SqlDbType.NVarChar, 255).Value = pg.Properties
            .Add("@properties2", SqlDbType.NText).Value = pg.Properties2
            .Add("@https", SqlDbType.Bit).Value = pg.IsHttps
            .Add("@root_id", SqlDbType.Int).Value = pg.RootId
            .Add("@event_all_day", SqlDbType.Bit).Value = pg.EventAllDay
            .Add("@event_start_date", SqlDbType.DateTime).Value = pg.EventStartDate
            .Add("@event_end_date", SqlDbType.DateTime).Value = pg.EventEndDate
            .Add("@is_listing", SqlDbType.Bit).Value = pg.IsListing
            .Add("@listing_template_id", SqlDbType.Int).Value = pg.ListingTemplateId
            .Add("@elements", SqlDbType.NText).Value = ""
            .Add("@listing_elements", SqlDbType.NText).Value = ""
            .Add("@link", SqlDbType.NText).Value = pg.Link
            .Add("@link_target", SqlDbType.NVarChar, 50).Value = pg.LinkTarget
            .Add("@is_link", SqlDbType.Bit, 50).Value = pg.IsLink
        End With

        oConn.Open()
        cmd.Connection = oConn
        Dim reader As SqlDataReader = cmd.ExecuteReader()

        Dim newContent As New CMSContent
        ReadContentFromReader(reader, newContent)

        cmd = Nothing
        oConn.Close()

        Return newContent
    End Function

    Public Function UnlockContent(ByVal intPageId As Integer, ByVal intVersion As Integer) As CMSContent
        Dim currContent As CMSContent = Nothing
        currContent = GetContent(intPageId, intVersion)
        Dim status As String = IIf(currContent.Status = CMSContent.STATUS_PROP_REVISION_LOCKED, _
                        CMSContent.STATUS_PROP_REVISION_UNLOCKED, _
                        CMSContent.STATUS_UNLOCKED).ToString

        Dim sql As String = "UPDATE pages SET status=@status, " & _
            "last_updated_date=@last_updated_date " & _
            "WHERE page_id=@page_id AND version=@version "

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = status
        cmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion

        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()

        Return GetContent(intPageId, intVersion)
    End Function

    Public Function MoveContent(ByVal intPageId As Integer, ByVal intRefPage As Integer, ByVal strRefPos As String, Optional ByVal strLinkPlacement As String = "") As CMSContent
        Dim content As CMSContent = GetWorkingCopy(intPageId)
        If content Is Nothing Then Return Nothing

        Dim oCmd As SqlCommand = New SqlCommand("advcms_MOVE_CONTENT")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = content.PageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = content.Version
        oCmd.Parameters.Add("@refpageid", SqlDbType.Int).Value = intRefPage
        oCmd.Parameters.Add("@refposition", SqlDbType.NVarChar, 10).Value = strRefPos
        oCmd.Parameters.Add("@link_placement", SqlDbType.NVarChar, 50).Value = strLinkPlacement
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        ReadContentFromReader(reader, content)
        reader.Close()
        oConn.Close()

        Dim status As String = IIf(content.Status = CMSContent.STATUS_PROP_REVISION_LOCKED, _
                        CMSContent.STATUS_PROP_REVISION_UNLOCKED, _
                        CMSContent.STATUS_UNLOCKED).ToString
        SetContentStatus(content.PageId, content.Version, status)
        SetLastUpdateProp(content.PageId, content.Version)
        Return GetContent(content.PageId, content.Version)

    End Function

    Public Function SaveContent(ByVal content As CMSContent, Optional ByVal unlock As Boolean = False) As CMSContent
        Dim currContent As CMSContent = New CMSContent
        currContent = GetContent(content.PageId, content.Version)

        'if current content is already modified and status has changed then save nothing
        If (currContent.Status <> CMSContent.STATUS_LOCKED And currContent.Status <> CMSContent.STATUS_PROP_REVISION_LOCKED) Then
            Return Nothing 'do nothing
        Else
            If currContent.LastUpdatedBy.ToLower <> GetUser.UserName.ToLower Then
                Return Nothing
            End If
        End If

        Dim sql As String

        sql = "UPDATE pages SET title=@title, " & _
            "content_body=@content_body, status=@status, summary=@summary, file_attachment=@file_attachment, file_view=@file_view, file_view_listing=@file_view_listing, file_size=@file_size, display_date=@display_date, " & _
            "last_updated_by=@last_updated_by, last_updated_date=@last_updated_date, event_all_day=@event_all_day, event_start_date=@event_start_date, event_end_date=@event_end_date, is_listing=@is_listing, listing_template_id=@listing_template_id, link=@link, link_target=@link_target, is_link=@is_link " & _
            "WHERE page_id=@page_id AND version=@version "

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@title", SqlDbType.NVarChar, 255).Value = content.Title
        cmd.Parameters.Add("@content_body", SqlDbType.NText).Value = content.ContentBody
        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = _
            CStr(IIf(unlock, _
                    IIf(currContent.Status = CMSContent.STATUS_PROP_REVISION_LOCKED, _
                        CMSContent.STATUS_PROP_REVISION_UNLOCKED, _
                        CMSContent.STATUS_UNLOCKED), _
                    currContent.Status) _
                )
        cmd.Parameters.Add("@summary", SqlDbType.NText).Value = content.Summary
        cmd.Parameters.Add("@file_attachment", SqlDbType.NVarChar, 255).Value = content.FileAttachment
        cmd.Parameters.Add("@file_view", SqlDbType.NVarChar, 255).Value = content.FileView
        cmd.Parameters.Add("@file_view_listing", SqlDbType.NVarChar, 255).Value = content.FileViewListing
        cmd.Parameters.Add("@file_size", SqlDbType.Int).Value = content.FileSize

        'If Not IsNothing(content.Price) Then
        '    cmd.Parameters.Add("@price", SqlDbType.Money).Value = content.Price
        'End If

        cmd.Parameters.Add("@display_date", SqlDbType.DateTime).Value = content.DisplayDate
        cmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 100).Value = GetUser.UserName
        cmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = content.PageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = content.Version
        cmd.Parameters.Add("@event_all_day", SqlDbType.Bit).Value = content.EventAllDay
        cmd.Parameters.Add("@event_start_date", SqlDbType.DateTime).Value = content.EventStartDate
        cmd.Parameters.Add("@event_end_date", SqlDbType.DateTime).Value = content.EventEndDate
        cmd.Parameters.Add("@is_listing", SqlDbType.Bit).Value = content.IsListing
        cmd.Parameters.Add("@listing_template_id", SqlDbType.Int).Value = content.ListingTemplateId
        cmd.Parameters.Add("@link", SqlDbType.NText).Value = content.Link
        cmd.Parameters.Add("@link_target", SqlDbType.NVarChar, 50).Value = content.LinkTarget
        cmd.Parameters.Add("@is_link", SqlDbType.Bit).Value = content.IsLink

        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()

        Return GetContent(content.PageId, content.Version)
    End Function

    Public Function SaveContent(ByVal intPageId As Integer, ByVal strAddContentLeft As String, ByVal strLeftRight As String) As Boolean
        Dim currContent As CMSContent = GetLatestVersion(intPageId)
        Dim sql As String
        If strLeftRight = "Left" Then
            sql = "UPDATE pages SET content_left=@content_left WHERE page_id=@page_id AND version=@version "
        Else
            sql = "UPDATE pages SET content_right=@content_right WHERE page_id=@page_id AND version=@version "
        End If
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        If strLeftRight = "Left" Then
            oCmd.Parameters.Add("@content_left", SqlDbType.NText).Value = strAddContentLeft
        Else
            oCmd.Parameters.Add("@content_right", SqlDbType.NText).Value = strAddContentLeft
        End If
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = currContent.Version
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
        Return True
    End Function

    Public Function SaveContentProperties(ByVal content As CMSContent) As CMSContent
        Dim sql As String
        sql = "UPDATE pages SET use_default_template=@use_default_template, " & _
            "properties=@properties, template_id=@template_id, link_text=@link_text, " & _
            "meta_title=@meta_title, meta_keywords=@meta_keywords, meta_description=@meta_description, " & _
            "is_hidden=@is_hidden, use_discussion=@use_discussion, use_rating=@use_rating, use_comments=@use_comments, " & _
            "allow_links_crawled=@allow_links_crawled, allow_page_indexed=@allow_page_indexed, " & _
            "last_updated_by=@last_updated_by, last_updated_date=@last_updated_date " & _
            "WHERE page_id=@page_id AND version=@version"

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@use_default_template", SqlDbType.Bit).Value = content.UseDefaultTemplate
        If (content.UseDefaultTemplate) Then
            cmd.Parameters.Add("@template_id", SqlDbType.Int).Value = DBNull.Value
        Else
            cmd.Parameters.Add("@template_id", SqlDbType.Int).Value = content.TemplateId
        End If

        cmd.Parameters.Add("@properties", SqlDbType.NVarChar, 50).Value = content.Properties

        cmd.Parameters.Add("@link_text", SqlDbType.NVarChar, 50).Value = content.LinkText
        cmd.Parameters.Add("@meta_title", SqlDbType.NText).Value = content.MetaTitle
        cmd.Parameters.Add("@meta_keywords", SqlDbType.NText).Value = content.MetaKeywords
        cmd.Parameters.Add("@meta_description", SqlDbType.NText).Value = content.MetaDescription
        cmd.Parameters.Add("@is_hidden", SqlDbType.Bit).Value = content.IsHidden
        cmd.Parameters.Add("@use_discussion", SqlDbType.Bit).Value = content.UseDiscussion
        cmd.Parameters.Add("@use_rating", SqlDbType.Bit).Value = content.UseRating
        cmd.Parameters.Add("@use_comments", SqlDbType.Bit).Value = content.UseComments
        cmd.Parameters.Add("@allow_links_crawled", SqlDbType.Bit).Value = content.AllowLinksCrawled
        cmd.Parameters.Add("@allow_page_indexed", SqlDbType.Bit).Value = content.AllowPageIndexed
        cmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        cmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now

        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = content.PageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = content.Version

        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()

        Return GetContent(content.PageId, content.Version)
    End Function

    Public Sub SetPublishingDate(ByVal intPageId As Integer, ByVal intVersion As Integer, ByVal dtPubStart As DateTime, ByVal dtPubEnd As DateTime)
        Dim sql As String = "UPDATE pages SET published_start_date=@pub_start, " & _
            "published_end_date=@pub_end, " & _
            "last_updated_by=@last_updated_by, last_updated_date=@last_updated_date " & _
            "WHERE page_id=@page_id AND version=@version"

        Dim cmd As SqlCommand

        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        Dim nullDate As DateTime = Nothing
        If (dtPubStart.Equals(nullDate)) Then
            cmd.Parameters.Add("@pub_start", SqlDbType.DateTime).Value = DBNull.Value
        Else
            cmd.Parameters.Add("@pub_start", SqlDbType.DateTime).Value = dtPubStart
        End If
        If (dtPubEnd.Equals(nullDate)) Then
            cmd.Parameters.Add("@pub_end", SqlDbType.DateTime).Value = DBNull.Value
        Else
            cmd.Parameters.Add("@pub_end", SqlDbType.DateTime).Value = dtPubEnd
        End If
        cmd.Parameters.Add("@last_updated_by", SqlDbType.NVarChar, 50).Value = GetUser().UserName
        cmd.Parameters.Add("@last_updated_date", SqlDbType.DateTime).Value = Now

        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        cmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion

        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()
        SetLastUpdateProp(intPageId, intVersion)
    End Sub

    Public Function GetWorkingCopy(ByVal pageId As Integer) As CMSContent
        'get latest version
        Dim cmd As SqlCommand

        cmd = New SqlCommand("advcms_GET_LATEST_CONTENT_VERSION")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@page_id", SqlDbType.Int)
        cmd.Parameters("@page_id").Value = pageId

        oConn.Open()
        cmd.Connection = oConn
        Dim reader As SqlDataReader = cmd.ExecuteReader
        Dim content As New CMSContent
        ReadContentFromReader(reader, content)
        reader.Close()
        cmd = Nothing
        oConn.Close()

        Select Case content.Status
            Case CMSContent.STATUS_PUBLISHED, CMSContent.STATUS_UNLOCKED
                'create a working copy.
                cmd = New SqlCommand("advcms_CHECKOUT_CONTENT")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = pageId
                cmd.Parameters.Add("@version", SqlDbType.Int).Value = content.Version
                cmd.Parameters.Add("@checkout_by", SqlDbType.NVarChar, 50).Value = GetUser.UserName

                oConn.Open()
                cmd.Connection = oConn
                reader = cmd.ExecuteReader
                ReadContentFromReader(reader, content)
                reader.Close()
                cmd = Nothing
                oConn.Close()
            Case CMSContent.STATUS_CONTENT_REVISION
                'set status to locked
                SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_LOCKED)
                content.Status = CMSContent.STATUS_LOCKED
            Case CMSContent.STATUS_PROP_REVISION_UNLOCKED
                'set status to moderator reject and lock
                SetContentStatus(content.PageId, content.Version, CMSContent.STATUS_PROP_REVISION_LOCKED)
                content.Status = CMSContent.STATUS_PROP_REVISION_LOCKED
            Case CMSContent.STATUS_LOCKED, CMSContent.STATUS_PROP_REVISION_LOCKED
                'do nothing, just return the original record
            Case Else
                'invalid state, return nothing
                Return Nothing
        End Select
        Return content
    End Function

    Public Function GetLatestVersion(ByVal intPageId As Integer) As CMSContent
        Dim cmd As SqlCommand

        cmd = New SqlCommand("advcms_GET_LATEST_CONTENT_VERSION")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId

        oConn.Open()
        cmd.Connection = oConn
        Dim reader As SqlDataReader = cmd.ExecuteReader
        Dim content As New CMSContent
        ReadContentFromReader(reader, content)
        cmd = Nothing
        reader.Close()
        oConn.Close()
        Return content
    End Function

    Public Function GetPublishedCopy(ByVal pageId As Integer) As CMSContent
        Dim content As CMSContent = New CMSContent

        oConn.Open()
        Dim sql As String = "SELECT * FROM pages WHERE page_id=@page_id AND status=@status"

        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = pageId
        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_PUBLISHED

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        ReadContentFromReader(reader, content)

        reader.Close()
        oConn.Close()
        Return content
    End Function

    Public Function DeleteContent(ByVal intPageId As Integer) As Integer
        'if the page is never published, delete it
        'if the page not require approval, change the status to archived
        'if the page required approval, change marked for archival=true

        If (IsPreviouslyPublished(intPageId)) Then
            'get latest version
            Dim contentMgr As New ContentManager
            Dim channelMgr As New ChannelManager

            Dim content As CMSContent = contentMgr.GetWorkingCopy(intPageId)
            Dim intNeedAppvr As Integer = channelMgr.NeedApproval(content.ChannelId)
            If intNeedAppvr = CMSChannel.APPROVAL_NONE Then
                'set status to arcive, and published content status to published_archived.
                ArchiveContent(content.PageId, content.Version)
            Else
                'mark for approval
                MarkForArchival(content.PageId, content.Version, True)
                'SubmitContent(content.PageId, content.Version, False)
                SubmitContent(content.PageId, content.Version)
            End If
            Return 1
        Else
            'delete all
            Dim sql As String = "DELETE FROM pages WHERE page_id=@page_id"
            Dim oCmd As SqlCommand = New SqlCommand(sql)
            oCmd.CommandType = CommandType.Text
            oConn.Open()
            oCmd.Connection = oConn
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
            oCmd.ExecuteNonQuery()

            oConn.Close()

            Return 0
        End If
    End Function

    Public Function ArchiveContent(ByVal intPageId As Integer, ByVal intVersion As Integer) As Boolean
        Dim oCmd As SqlCommand = New SqlCommand("advcms_ArchiveContent")
        oCmd.CommandType = CommandType.StoredProcedure
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oCmd.ExecuteNonQuery()
        oConn.Close()
        SetLastUpdateProp(intPageId, intVersion)
    End Function

    Public Function MarkForArchival(ByVal intPageId As Integer, ByVal intVersion As Integer, ByVal archive As Boolean) As Boolean
        Dim sql As String = "UPDATE pages SET is_marked_for_archival=@marked WHERE page_id=@page_id AND version=@version"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.Parameters.Add("@marked", SqlDbType.Bit).Value = archive
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oCmd.ExecuteNonQuery()
        oConn.Close()
        'SetLastUpdateProp(intPageId, intVersion)
        Return True
    End Function

    Public Function IsPreviouslyPublished(ByVal intPageId As Integer) As Boolean
        Dim sql As String = "SELECT * FROM pages WHERE page_id=@page_id and status in (@status1, @status2)"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@status1", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_PUBLISHED
        oCmd.Parameters.Add("@status2", SqlDbType.NVarChar, 50).Value = CMSContent.STATUS_PUBLISHED_ARCHIVED

        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        If (reader.Read) Then
            reader.Close()
            oConn.Close()
            Return True
        End If
        reader.Close()
        oConn.Close()
        Return False
    End Function

    Public Function IsEditableByAuthor(ByVal strUser As String, ByVal intPageId As Integer) As Boolean
        Dim content As CMSContent = GetLatestVersion(intPageId)

        With content
            If .Status = CMSContent.STATUS_PUBLISHED Or _
               .Status = CMSContent.STATUS_UNLOCKED Or _
               ((.LastUpdatedBy = strUser) And (.Status = CMSContent.STATUS_PROP_REVISION_LOCKED Or .Status = CMSContent.STATUS_LOCKED)) Then
                'do nothing
            Else
                Return False
            End If
        End With

        Dim chMgr As ChannelManager = New ChannelManager
        If Not chMgr.IsAuthorInChannel(strUser, content.ChannelId) Then
            Return False
        End If

        Return True
    End Function

    Public Function GetContent(ByVal pageId As Integer, ByVal version As Integer) As CMSContent
        Dim content As CMSContent = New CMSContent

        oConn.Open()
        Dim sql As String = "SELECT * FROM pages WHERE page_id=@page_id AND version=@version"

        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int)
        cmd.Parameters("@page_id").Value = pageId
        cmd.Parameters.Add("@version", SqlDbType.Int)
        cmd.Parameters("@version").Value = version

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        ReadContentFromReader(reader, content)

        reader.Close()
        oConn.Close()
        Return content
    End Function

    Public Function GetFirstPublishedContent(ByVal pageId As Integer) As CMSContent
        Dim content As CMSContent = New CMSContent

        oConn.Open()
        Dim sql As String = "SELECT top 1 * FROM (SELECT top 1 * FROM pages WHERE page_id=@page_id and status='published_archived' UNION ALL SELECT top 1 * FROM pages WHERE page_id=@page_id and status='published') AS TEMP ORDER BY TEMP.version asc"
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int)
        cmd.Parameters("@page_id").Value = pageId

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        ReadContentFromReader(reader, content)

        reader.Close()
        oConn.Close()
        Return content
    End Function

    Public Function GetContentsWithin(ByVal ParentId As Integer, ByVal LinkPlacement As String) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()
        'Dim Cms As SqlDataReader

        Dim sSQL As String
        sSQL = "Select page_id,parent_id,sorting,page_type,title,link_text,file_name,link_placement,is_hidden,is_system,published_start_date,published_end_date, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2 " & _
            "From pages_working Where " & _
            "parent_id=" & ParentId & " And " & _
            "link_placement='" & LinkPlacement & "' And Not is_system=1 ORDER BY sorting"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetWorkingContentByFileName(ByVal FileName As String) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        'sSQL = "SELECT * from pages_working where file_name='" & FileName & "'"
        sSQL = "SELECT pages_working.*, pages_working_1.parent_id AS parent_parent_id, pages_working_1.is_listing AS parent_is_listing, pages_working_1.listing_property AS parent_listing_property, pages_working_1.elements AS parent_elements, pages_working_1.listing_type AS parent_listing_type, pages_working_1.listing_use_categories AS parent_listing_use_categories, pages_working_1.page_type AS parent_page_type, pages_working_1.file_name AS parent_file_name, " & _
            "pages_working_1.properties AS parent_properties, pages_working_1.channel_name AS parent_channel_name " & _
            "FROM pages_working LEFT OUTER JOIN " & _
            "pages_working AS pages_working_1 ON pages_working.parent_id = pages_working_1.page_id " & _
            "WHERE pages_working.file_name = '" & FileName & "'"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetPublishedContentByFileName(ByVal FileName As String) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        'sSQL = "SELECT * from pages_published where file_name='" & FileName & "'"

        sSQL = "SELECT pages_published.*, pages_published_1.parent_id AS parent_parent_id, pages_published_1.is_listing AS parent_is_listing, pages_published_1.listing_property AS parent_listing_property, pages_published_1.elements AS parent_elements, pages_published_1.listing_type AS parent_listing_type, pages_published_1.listing_use_categories AS parent_listing_use_categories, pages_published_1.page_type AS parent_page_type, pages_published_1.file_name AS parent_file_name, " & _
            "pages_published_1.properties AS parent_properties, pages_published_1.channel_name AS parent_channel_name " & _
            "FROM pages_published LEFT OUTER JOIN " & _
            "pages_published AS pages_published_1 ON pages_published.parent_id = pages_published_1.page_id " & _
            "WHERE pages_published.file_name = '" & FileName & "'"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetPublishedContentById(ByVal page_id As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT * from pages_published where page_id='" & page_id & "'"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetWorkingContentById(ByVal page_id As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT * from pages_working where page_id='" & page_id & "'"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function RetrieveWorkingListing(ByVal intPageId As Integer, ByVal nSortBy As Integer) As SqlDataReader
        '1. Sort by Display Date
        '2. Sort by Last Updated Date
        '3. Sort by Date Created
        '4. Sort by Title
        '5. Sort by Pricing (Asc)
        '6. Sort by Pricing (Desc)

        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String = ""
        If nSortBy = 1 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by display_date desc, created_date desc"
        ElseIf nSortBy = 2 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by last_updated_date desc"
        ElseIf nSortBy = 3 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by created_date desc"
        ElseIf nSortBy = 4 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by title"
        ElseIf nSortBy = 5 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by price asc"
        ElseIf nSortBy = 6 Then
            sSQL = "SELECT * FROM pages_working where parent_id=" & intPageId & " order by price desc"
        End If

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function RetrievePublishedListing(ByVal intPageId As Integer, ByVal nSortBy As Integer) As SqlDataReader
        '1. Sort by Display Date
        '2. Sort by Last Updated Date
        '3. Sort by Date Created
        '4. Sort by Title
        '5. Sort by Pricing (Asc)
        '6. Sort by Pricing (Desc)

        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String = ""
        If nSortBy = 1 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 order by display_date desc, created_date desc"
        ElseIf nSortBy = 2 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) order by last_updated_date desc"
        ElseIf nSortBy = 3 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) order by created_date desc"
        ElseIf nSortBy = 4 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) order by title"
        ElseIf nSortBy = 5 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) order by price asc"
        ElseIf nSortBy = 6 Then
            sSQL = "SELECT * FROM pages_published where parent_id=" & intPageId & " and sorting=0 and is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) order by price desc"
        End If

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function ChangePageChannel(ByVal intPageId As Integer, ByVal intVersion As Integer, ByVal intChannelId As Integer, ByVal incSubContents As Boolean) As Boolean
        Dim sql As String
        Dim oCmd As SqlCommand
        If incSubContents Then
            sql = "advcms_UpdateChannel"
            oCmd = New SqlCommand(sql)
            oCmd.CommandType = CommandType.StoredProcedure
        Else
            sql = "UPDATE pages SET channel_id=@channel_id WHERE page_id=@page_id AND version=@version "
            oCmd = New SqlCommand(sql)
            oCmd.CommandType = CommandType.Text
        End If
        oCmd.Parameters.Add("@channel_id", SqlDbType.Int).Value = intChannelId
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = intVersion
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
        SetLastUpdateProp(intPageId, intVersion)
        Return True
    End Function


    Public Function RollbackContent(ByVal intPageId As Integer, ByVal toVersion As Integer, _
    ByVal rlbTitle As Boolean, ByVal rlbContent As Boolean, ByVal rlbFile As Boolean, _
    ByVal rlbFileView As Boolean, ByVal rlbFileViewListing As Boolean, _
    ByVal rlbMetaKey As Boolean, ByVal rlbMetaDesc As Boolean) As CMSContent

        Dim rbOptions As ArrayList = New ArrayList(8)
        If (rlbTitle) Then
            rbOptions.Add("title")
        End If
        If (rlbContent) Then
            rbOptions.Add("content")
        End If
        If (rlbFile) Then
            rbOptions.Add("file")
        End If
        If (rlbFileView) Then
            rbOptions.Add("fileview")
        End If
        If (rlbFileViewListing) Then
            rbOptions.Add("fileviewlisting")
        End If
        If (rlbMetaKey) Then
            rbOptions.Add("keywords")
        End If
        If (rlbMetaDesc) Then
            rbOptions.Add("description")
        End If

        Return RollbackContent(intPageId, toVersion, rbOptions)
    End Function

    Public Function RollbackContent(ByVal intPageId As Integer, ByVal toVersion As Integer, _
    ByVal rbOptions As ArrayList) As CMSContent

        Dim prevContent As CMSContent = GetContent(intPageId, toVersion)
        If prevContent Is Nothing Then Return Nothing

        Dim workingContent As CMSContent = GetWorkingCopy(intPageId)

        Dim sql As String = ""
        Dim oCmd As SqlCommand = New SqlCommand()

        Dim item As String
        Dim rbGallery As Boolean = False
        For Each item In rbOptions
            Select Case item
                Case "title"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " title=@title "
                    oCmd.Parameters.Add("@title", SqlDbType.NVarChar, 255).Value = prevContent.Title
                Case "content"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " content_left=@content_left, content_body=@content_body, content_right=@content_right "
                    oCmd.Parameters.Add("@content_left", SqlDbType.NText).Value = prevContent.ContentLeft
                    oCmd.Parameters.Add("@content_body", SqlDbType.NText).Value = prevContent.ContentBody
                    oCmd.Parameters.Add("@content_right", SqlDbType.NText).Value = prevContent.ContentRight
                Case "file"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " file_attachment=@file_attachment, file_size=@file_size "
                    oCmd.Parameters.Add("@file_attachment", SqlDbType.NVarChar, 255).Value = prevContent.FileAttachment
                    oCmd.Parameters.Add("@file_size", SqlDbType.Int).Value = prevContent.FileSize
                Case "fileview"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " file_view=@file_view "
                    oCmd.Parameters.Add("@file_view", SqlDbType.NVarChar, 255).Value = prevContent.FileView
                Case "fileviewlisting"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " file_view_listing=@file_view_listing "
                    oCmd.Parameters.Add("@file_view_listing", SqlDbType.NVarChar, 255).Value = prevContent.FileViewListing
                Case "keywords"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " meta_keywords=@meta_keywords "
                    oCmd.Parameters.Add("@meta_keywords", SqlDbType.NText).Value = prevContent.MetaKeywords
                Case "description"
                    If (sql <> "") Then sql = sql & ", "
                    sql = sql & " meta_description=@meta_description "
                    oCmd.Parameters.Add("@meta_description", SqlDbType.NText).Value = prevContent.MetaDescription
            End Select
        Next

        If (sql <> "") Then
            sql = "UPDATE pages SET " & sql & " WHERE page_id=@page_id AND version=@version "
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = workingContent.PageId
            oCmd.Parameters.Add("@version", SqlDbType.Int).Value = workingContent.Version
            oCmd.CommandText = sql
            oCmd.CommandType = CommandType.Text
            oConn.Open()
            oCmd.Connection = oConn
            oCmd.ExecuteNonQuery()
            oConn.Close()
        End If

        Return GetContent(workingContent.PageId, workingContent.Version)
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
                If Not (IsDBNull(reader("tangible"))) Then
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
                .ListingDefaultOrder = reader("listing_default_order").ToString
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

    Public Function GetContentVersions(ByVal intPageId As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT page_id, version, last_updated_date, last_updated_by, status from pages where page_id=" & intPageId & " order by version desc"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function IsContentExist(ByVal intPageId As Integer) As Boolean
        Dim sql As String = "SELECT * FROM pages_working WHERE page_id=@page_id"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        Dim retVal As Boolean = False
        If (reader.Read) Then
            retVal = True
        Else
            retVal = False
        End If
        reader.Close()
        oConn.Close()
        Return retVal
    End Function

    Public Function IsContentExist(ByVal strFileName As String) As Boolean
        Dim sql As String = "SELECT * FROM pages_working WHERE file_name=@file_name"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.Parameters.Add("@file_name", SqlDbType.NVarChar, 50).Value = strFileName
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        Dim retVal As Boolean = False
        If (reader.Read) Then
            retVal = True
        Else
            retVal = False
        End If
        reader.Close()
        oConn.Close()
        Return retVal

    End Function

    Public Function IsSubContentExist(ByVal intPageId As Integer) As Boolean
        Dim sql As String = "SELECT * FROM pages_working WHERE parent_id=@page_id"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = intPageId
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        Dim retVal As Boolean = False
        If (reader.Read) Then
            retVal = True
        Else
            retVal = False
        End If
        reader.Close()
        oConn.Close()
        Return retVal

    End Function

    Public Function ResetSorting(ByVal nPageId As Integer, ByVal nVersion As Integer) As Boolean
        Dim sql As String = "UPDATE pages SET sorting=0 WHERE page_id=@page_id AND version=@version"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = nVersion
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
        Return True
    End Function

    Public Function GetPageModules(ByVal nTemplateId As Integer, ByVal FileName As String) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "Select * from page_modules where template_id=" & nTemplateId & " OR embed_in='" & FileName & "' Or embed_in='*' Or CharIndex('*',embed_in,0)=1"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
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

    Public Function GetPageCategories(ByVal nPageId As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT TOP 100 percent listing_categories.listing_category_id, listing_categories.listing_category_name " & _
            "FROM listing_categories INNER JOIN listing_category_map ON listing_categories.listing_category_id = listing_category_map.listing_category_id " & _
            "WHERE (listing_category_map.page_id = " & nPageId & ") ORDER BY listing_categories.sorting"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetPageCategoriesWorking(ByVal nPageId As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT TOP 100 PERCENT listing_categories.listing_category_id, listing_categories.listing_category_name, COUNT(listing_category_map.page_id) " & _
              "AS posts " & _
              "FROM listing_categories LEFT JOIN " & _
              "listing_category_map ON listing_categories.listing_category_id = listing_category_map.listing_category_id " & _
              "WHERE (listing_categories.page_id = " & nPageId & ") " & _
              "GROUP BY listing_categories.listing_category_id, listing_categories.listing_category_name, listing_categories.sorting " & _
              "ORDER BY listing_categories.sorting"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function
    Public Function GetPageCategoriesPublished(ByVal nPageId As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT TOP 100 PERCENT listing_categories.listing_category_id, listing_categories.listing_category_name, COUNT(listing_category_map.page_id)  " & _
            "AS posts " & _
            "FROM pages_published INNER JOIN " & _
            "listing_category_map ON pages_published.page_id = listing_category_map.page_id RIGHT OUTER JOIN " & _
            "listing_categories ON listing_category_map.listing_category_id = listing_categories.listing_category_id " & _
            "WHERE (listing_categories.page_id = " & nPageId & ") " & _
            "GROUP BY listing_categories.listing_category_id, listing_categories.listing_category_name, listing_categories.sorting " & _
            "ORDER BY listing_categories.sorting"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function
    Public Function GetFirstPost(ByVal nPageId As Integer) As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT TOP 1 * FROM pages_working WHERE parent_id=" & nPageId & _
          " ORDER BY display_date ASC"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub

End Class
