'***********************************
'   InsiteCreation 2008 ver.1.7.3
'***********************************
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security.Membership
Imports System.Collections.Generic
Imports System.Globalization
Imports System.Threading
Imports System.Xml
'Imports System.IO
'Imports System.Resources
'Imports System.Drawing
'Imports System.Drawing.Imaging
'Imports System.Drawing.Drawing2D

Partial Class _Default
    Inherits System.Web.UI.Page

    'Protected Overrides ReadOnly Property PageStatePersister() As System.Web.UI.PageStatePersister
    '    Get
    '        Return New SessionPageStatePersister(Me)
    '    End Get
    'End Property

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private sRawUrl As String = Context.Request.RawUrl.ToString
    Private sAppPath As String = Context.Request.ApplicationPath
    Private sUrlAuthority As String

    Private nTemplateId As Integer
    Private sTemplateName As String
    Private sTemplateFolderName As String
    Private nLayoutType As Integer
    Private sTitle As String
    Private sSummary As String
    Private nPrice As Decimal
    Private nSalePrice As Decimal
    Private nDiscountPercentage As Integer
    Private nPageId As Integer
    Private nParentId As Integer
    Private nSorting As Integer
    Private sLinkPlacement As String
    Private nChannelId As Integer
    Private nVersion As Integer
    Private sContentBody As String
    Private sContentLeft As String
    Private sContentRight As String
    Private sFileDownload As String
    Private sFileView As String
    Private nFileSize As Integer
    Private dDisplayDate As DateTime
    Private bIsSystem As Boolean
    Private sMetaTitle As String
    Private sMetaKeywords As String
    Private sMetaDescription As String
    Private sPageModule As String
    Private sStatus As String
    Private sOwner As String
    Private dtLastUpdatedDate As Date
    Private sLastUpdatedBy As String
    Private sChannelName As String
    Private bDisableCollaboration As Boolean
    Private bMarkedForArchival As Boolean
    Private bLinksCrawled As Boolean
    Private bPageIndexed As Boolean
    Private nChannelPermission As Integer
    Private dStartDate As Date
    Private dEndDate As Date
    Private bUseStartDate As Boolean
    Private bUseEndDate As Boolean
    Private sCustomProperties As String 'Custom Properties
    Private bHttps As Boolean

    Private bIsListing As Boolean
    Private nListingTemplateId As Integer
    Private sListingScript As String
    Private nListingType As Integer
    Private nListingProperty As Integer
    Private sListingDateTimeFormat As String
    Private nListingColumns As Integer
    Private nListingPageSize As Integer
    Private bListingUseCategories As Boolean
    Private sListingDefaultOrder As String

    Dim sListingTemplateName As String = ""
    Dim sListingTemplateItem As String = ""
    Dim sListingTemplateHeader As String = ""
    Dim sListingTemplateFooter As String = ""

    Private dtFirstPublishedDate As DateTime
    Private bHasPublished As Boolean

    Private sElements As String

    Private sLink As String
    Private sLinkTarget As String
    Private bIsLink As Boolean

    Private nRootId As Integer
    Private sRootFile As String
    Private sRootTitle As String
    Private bRedirectToHome As Boolean = False

    Private nParentParentId As Integer
    Private sParentChannelName As String
    Private sParentFileName As String

    Private bParentIsListing As Boolean
    Private nParentListingType As Integer
    Private nParentListingProperty As Integer
    Private bParentListingUseCategories As Boolean
    Private sParentElements As String

    Private bUserLoggedIn As Boolean
    Private arrUserRoles() As String
    Private bShowWorking As Boolean
    Private sUserName As String

    Private bIsSubscriber As Boolean
    Private bIsAuthor As Boolean
    Private bIsEditor As Boolean
    Private bIsPublisher As Boolean
    Private bIsResourceManager As Boolean
    Private bIsAdministrator As Boolean
    Private bIsReader As Boolean 'Not an Admin, Author, Editor or Publisher                 
    Private bIsOwner As Boolean

    Private bInitialPage As Boolean

    Private placeholderTopMenu As ContentPlaceHolder
    Private placeholderTopMenu_VerticalMenu As ContentPlaceHolder
    Private placeholderBottomMenu As ContentPlaceHolder
    Private placeholderSearch As ContentPlaceHolder
    Private placeholderMainMenu_DropMenu As ContentPlaceHolder
    Private placeholderMainMenu_DropDown As ContentPlaceHolder
    Private placeholderMainMenu_Links As ContentPlaceHolder
    Private placeholderMainMenu_VerticalMenu As ContentPlaceHolder
    Private placeholderBreadcrumb As ContentPlaceHolder
    Private placeholderTitle As ContentPlaceHolder
    Private placeholderLeftTop As ContentPlaceHolder
    Private placeholderLeft As ContentPlaceHolder
    Private placeholderLeftBottom As ContentPlaceHolder
    Private placeholderBody As ContentPlaceHolder
    Private placeholderBodyTop As ContentPlaceHolder
    Private placeholderBodyBottom As ContentPlaceHolder
    Private placeholderRightTop As ContentPlaceHolder
    Private placeholderRight As ContentPlaceHolder
    Private placeholderRightBottom As ContentPlaceHolder
    Private placeholderPageInfo As ContentPlaceHolder
    Private placeholderAuthoring As ContentPlaceHolder
    Private placeholderContentRating As ContentPlaceHolder
    Private placeholderComments As ContentPlaceHolder
    Private placeholderPrint As ContentPlaceHolder
    Private placeholderPagesWithin As ContentPlaceHolder
    Private placeholderSameLevelPages As ContentPlaceHolder
    Private placeholderCountrySelect As ContentPlaceHolder
    Private placeholderLoginForm As ContentPlaceHolder
    Private placeholderWelcome As ContentPlaceHolder
    Private placeholderAdminWorkspaceLink As ContentPlaceHolder
    Private placeholderLoginLogout As ContentPlaceHolder
    Private placeholderRegister As ContentPlaceHolder
    Private placeholderLogout As ContentPlaceHolder
    Private placeholderMainMenu_Tabs As ContentPlaceHolder
    Private placeholderMainMenu_Side As ContentPlaceHolder
    Private placeholderMenu_Tree As ContentPlaceHolder
    Private placeholderScript As ContentPlaceHolder
    Private placeholderOrderNow As ContentPlaceHolder
    Private placeholderCartInfo As ContentPlaceHolder
    Private placeholderFileView As ContentPlaceHolder
    Private placeholderFileDownload As ContentPlaceHolder
    Private placeholderArchives As ContentPlaceHolder
    Private placeholderCategoryList As ContentPlaceHolder
    Private placeholderSubscribe As ContentPlaceHolder
    Private placeholderListing As ContentPlaceHolder

    Private placeholderPublishingInfo As ContentPlaceHolder
    Private placeholderStatPageViews As ContentPlaceHolder
    Private placeholderStatPageViews_Vertical As ContentPlaceHolder
    Private placeholderStatPageViews_Private As ContentPlaceHolder
    Private placeholderStatPageViews_Vertical_Private As ContentPlaceHolder
    Private placeholderCategoryInfo As ContentPlaceHolder

    Private placeholderPageTools As ContentPlaceHolder
    Private placeholderSiteRss As ContentPlaceHolder

    Private sCulture As String
    Private sSiteName As String
    Private sSiteAddress As String
    Private sSiteCity As String
    Private sSiteState As String
    Private sSiteCountry As String
    Private sSiteZip As String
    Private sSitePhone As String
    Private sSiteFax As String
    Private sSiteEmail As String

    Private sLinkPageNotFound As String = "pagenotfound.aspx"
    Private sLinkShoppingCart As String = "shoppingcart.aspx"
    Private sLinkLogin As String = "login.aspx"
    Private sLinkRegistration As String = "registration.aspx"
    Private sLinkAdmin As String = "admin.aspx"
    Private sLinkWorkspace As String = "workspace.aspx"
    Private sLinkSearch As String = "search.aspx"
    Private sLinkPassword As String = "password.aspx"
    Private sLinkApproval As String = "approval.aspx"
    Private sLinkTellAFriend As String = "tell_a_friend.aspx"
    Private sLinkSiteRss As String = "site_rss.aspx"

    Private sCurrencySymbol As String

    Private sResourcesInternal_FileDownload As String
    Private sResourcesInternal_FileView As String
    Private sResourcesInternal_FileViewListing As String

    Private bForceShowSummaryEditor As Boolean = False 'Only for Editing if required (e.g. when editing product page)

    Protected Sub RedirectForLogin()
        If Not bUserLoggedIn Then Response.Redirect(GetFileName())
    End Sub

    Protected Sub Stat()
        If Not (bIsReader Or bIsSubscriber) Then
            Exit Sub
        End If
        Dim qs As String = ""
        If sRawUrl.Contains("?") Then
            qs = sRawUrl.Split(CChar("?"))(1).ToString
        End If
        Dim sql As String = "INSERT INTO page_views (page_id,query_string,ip,referer,user_agent,date_stamp,datetime_stamp) VALUES (@page_id,@query_string,@ip,@referer,@user_agent,@date_stamp,@datetime_stamp)"
        Dim cmd As SqlCommand
        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        cmd.Parameters.Add("@query_string", SqlDbType.NVarChar, 500).Value = qs
        cmd.Parameters.Add("@ip", SqlDbType.NVarChar, 50).Value = Request.ServerVariables("REMOTE_ADDR").ToString
        If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
            cmd.Parameters.Add("@referer", SqlDbType.NVarChar, 500).Value = Request.ServerVariables("HTTP_REFERER").ToString
        Else
            cmd.Parameters.Add("@referer", SqlDbType.NVarChar, 500).Value = ""
        End If

        cmd.Parameters.Add("@user_agent", SqlDbType.NVarChar, 50).Value = Request.ServerVariables("HTTP_USER_AGENT").ToString
        cmd.Parameters.Add("@date_stamp", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)
        cmd.Parameters.Add("@datetime_stamp", SqlDbType.DateTime).Value = Now
        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()
    End Sub

    Protected Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit

        If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"

        'sUrlAuthority = Context.Request.Url.Authority
        Dim sPort As String
        sPort = Request.ServerVariables("SERVER_PORT")
        If IsNothing(sPort) Or sPort = "80" Or sPort = "443" Then
            sPort = ""
        Else
            sPort = ":" & sPort
        End If
        sUrlAuthority = Request.ServerVariables("SERVER_NAME") & sPort

        If Not IsNothing(Session("local")) Then 'Page Not Found 
            sLinkPageNotFound = "pagenotfound_" & Session("local") & ".aspx"
            If Session("local") = 1 Then
                sLinkPageNotFound = "pagenotfound.aspx"
            End If
        End If


        LoadPageData()
        Stat()

        'Apply template
        If sRawUrl.Contains("print=Y") Then
            Page.MasterPageFile = sAppPath & "templates/" & sTemplateFolderName & "/print.master"
        Else
            Page.MasterPageFile = sAppPath & "templates/" & sTemplateFolderName & "/default.master"
        End If

        'Apply Skin
        If My.Computer.FileSystem.DirectoryExists(Server.MapPath("~/App_Themes/" & sTemplateFolderName & "/")) Then
            Page.Theme = sTemplateFolderName
        Else 'downgrade compatible
            Page.Theme = "global"
        End If

        'Internationalization & Localization
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        '***  GET ROOT ***
        Dim sSQL As String
        If bUserLoggedIn Then 'yus
            sSQL = "Select * From pages_working where page_id=@page_id"
        Else
            sSQL = "Select * From pages_published where page_id=@page_id"
        End If
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nRootId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            nRootId = CInt(oDataReader("page_id"))
            sRootFile = oDataReader("file_name").ToString
            Dim sLnkText As String
            sLnkText = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnkText <> "" Then
                sRootTitle = sLnkText
            Else
                sRootTitle = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If
        End While
        oDataReader.Close()

        Session("local") = nRootId 'Page Not Found

        'Links
        If Not nRootId = 1 Then sLinkPageNotFound = "pagenotfound_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShoppingCart = "shoppingcart_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkLogin = "login_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkRegistration = "registration_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdmin = "admin_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspace = "workspace_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkSearch = "search_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkPassword = "password_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkApproval = "approval_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkTellAFriend = "tell_a_friend_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkSiteRss = "site_rss_" & nRootId & ".aspx"


        '*** Locale Setting utk Frontend, depend on root
        oCommand = New SqlCommand("SELECT * FROM locales WHERE home_page='" & sRootFile & "'", oConn)
        oCommand.CommandType = CommandType.Text
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read Then
            sCulture = oDataReader("culture").ToString
            sSiteName = oDataReader("site_name").ToString
            sSiteAddress = oDataReader("site_address").ToString
            sSiteCity = oDataReader("site_city").ToString
            sSiteState = oDataReader("site_state").ToString
            sSiteCountry = oDataReader("site_country").ToString
            sSiteZip = oDataReader("site_zip").ToString
            sSitePhone = oDataReader("site_phone").ToString
            sSiteFax = oDataReader("site_fax").ToString
            sSiteEmail = oDataReader("site_email").ToString
        Else
            sCulture = "en-US"
            sSiteName = ""
            sSiteAddress = ""
            sSiteCity = ""
            sSiteState = ""
            sSiteCountry = ""
            sSiteZip = ""
            sSitePhone = ""
            sSiteFax = ""
            sSiteEmail = ""
        End If
        oDataReader.Close()
        Try
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        Catch ex As Exception
            sCulture = "en-US"
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End Try

        ''Kalau User logged-in dan punya preference culture
        'If Not IsNothing(GetUser) Then
        '    If Not Profile.CultureName = "" Then
        '        Try
        '            Dim ci As New CultureInfo(Profile.CultureName)
        '            Thread.CurrentThread.CurrentCulture = ci
        '            Thread.CurrentThread.CurrentUICulture = ci
        '        Catch ex As Exception

        '        End Try
        '    End If
        'End If

        oCommand.Dispose()
        oConn.Close()
        oConn = Nothing
    End Sub

    Protected Sub LoadPageData_Published()

        Dim bCheckIfPageExists As Boolean = False

        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader
        oDataReader = oContentManager.GetPublishedContentByFileName(GetFileName()) 'Get published copy
        If oDataReader.Read() Then
            ProcessPageData(oDataReader)
        Else
            'Page tdk ketemu di pages_published, cek di pages_working
            bCheckIfPageExists = True
        End If
        oDataReader.Close()

        Dim bToHome As Boolean = False
        If bCheckIfPageExists Then
            oDataReader = oContentManager.GetWorkingContentByFileName(GetFileName())
            If oDataReader.Read() Then
                'Record Ada => redirect to home
                nRootId = oDataReader("root_id")
                bToHome = True
            Else
                'Record Tdk Ada
                oDataReader.Close()
                oContentManager = Nothing
                Response.Redirect(sLinkPageNotFound & "?page=" & GetFileName())
            End If
            oDataReader.Close()
        End If
        If bToHome Then
            oDataReader = oContentManager.GetWorkingContentById(nRootId)
            If oDataReader.Read() Then
                Dim sFileName As String
                sFileName = oDataReader("file_name").ToString
                If sFileName.ToLower = GetFileName().ToLower Then
                    'Sudah di home => Ini tdk mungkin terjadi (disiapan utk jaga2)
                    oDataReader.Close()
                    Response.Redirect(sLinkPageNotFound & "?page=" & GetFileName())
                Else
                    oDataReader.Close()
                    Response.Redirect(sFileName)
                End If
            End If
            oDataReader.Close()
        End If
    End Sub

    Protected Sub LoadPageData()
        bShowWorking = False
        If IsNothing(GetUser) Then
            bUserLoggedIn = False
            bIsReader = True

            LoadPageData_Published()
            Exit Sub
        Else
            bUserLoggedIn = True
            bIsReader = False
        End If

        sUserName = GetUser.UserName.ToString
        arrUserRoles = Roles.GetRolesForUser(sUserName) 'Check User's Roles

        bIsAdministrator = False
        bIsSubscriber = False
        bIsAuthor = False
        bIsEditor = False
        bIsPublisher = False
        bIsResourceManager = False
        bIsOwner = False

        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader
        oDataReader = oContentManager.GetWorkingContentByFileName(GetFileName())
        If oDataReader.Read() Then
            sChannelName = oDataReader("channel_name")
            bDisableCollaboration = oDataReader("disable_collaboration")
            sOwner = oDataReader("owner").ToString
            sChannelName = oDataReader("channel_name")
            sLastUpdatedBy = oDataReader("last_updated_by")
            sStatus = oDataReader("status").ToString

            nParentId = oDataReader("parent_id").ToString

            If sUserName.ToLower = sOwner.ToLower Then
                bIsOwner = True
            End If

            Dim sItem As String
            For Each sItem In arrUserRoles
                If sItem = "Administrators" Then
                    bIsAdministrator = True
                End If
                If sItem = sChannelName & " Subscribers" Then
                    bIsSubscriber = True
                End If
                If sItem = sChannelName & " Authors" Then
                    bIsAuthor = True
                End If
                If sItem = sChannelName & " Editors" Then
                    bIsEditor = True
                End If
                If sItem = sChannelName & " Publishers" Then
                    bIsPublisher = True
                End If
                If sItem = sChannelName & " Resource Managers" Then
                    bIsResourceManager = True
                End If
            Next
            If Not (bIsAdministrator = True Or _
                bIsAuthor = True Or _
                bIsEditor = True Or _
                bIsPublisher = True) Then
                bIsReader = True
            End If
            'NOTE:If user has role: 
            'Authors, Editors, Publishers, Resource Managers or Administrators
            'in the CURRENT CHANNEL => Show Working Content
            'User which has only "Subscribers" role should be provided with published Content
            For Each sItem In arrUserRoles
                If sItem = sChannelName & " Authors" Or _
                    sItem = sChannelName & " Editors" Or _
                    sItem = sChannelName & " Publishers" Or _
                    sItem = sChannelName & " Resource Managers" Or _
                    sItem = "Administrators" Then
                    bShowWorking = True
                    Exit For
                End If
            Next

            '********************************
            '   Disable Collaboration Feature
            '********************************
            If bDisableCollaboration And bIsAuthor And Not sOwner.ToLower = sUserName.ToLower Then
                bShowWorking = False
            End If
            If bDisableCollaboration And sLastUpdatedBy.ToLower = sUserName.ToLower And (sStatus.Contains("locked") And Not sStatus.Contains("unlocked")) Then
                'Jika User bukan Owner, tapi dia sedang me-lock page tsb
                'Ini mungkin terjadi saat admin mengganti channel atau bDisableCollaboration
                bShowWorking = True
            End If

            'Check Parent Page 
            If Not IsDBNull(oDataReader("parent_listing_type")) Then
                nParentListingType = CInt(oDataReader("parent_listing_type"))
            End If
            If Not IsDBNull(oDataReader("parent_listing_property")) Then
                nParentListingProperty = CInt(oDataReader("parent_listing_property"))
            End If
            If Not IsDBNull(oDataReader("parent_listing_use_categories")) Then
                bParentListingUseCategories = Convert.ToBoolean(oDataReader("parent_listing_use_categories"))
            End If

            If Not IsDBNull(oDataReader("parent_is_listing")) Then
                bParentIsListing = Convert.ToBoolean(oDataReader("parent_is_listing"))
            End If
            sParentElements = oDataReader("parent_elements").ToString

            If bShowWorking Then
                ProcessPageData(oDataReader)
            Else
                'Show published
                LoadPageData_Published()
            End If
        Else
            'Record Tdk Ada
            'Kemungkinan:
            '1. memang tdk ada
            '2. User login sbg subscriber, sementara page sudah di-rename oleh author tapi blm dipublish. Misal:
            '   published: test1.aspx, working:test2.aspx
            '   User login sbg subscriber, jadi yg di-request: test1.aspx.
            '   Tapi krn dia logged-in yg di-call : GetWorkingContentByFileName() shg page not found
            '   Krn itu, utk kemungkinan no 2, set bShowWorking=false, lalu panggil LoadPageData_Published()
            bShowWorking = False
            LoadPageData_Published()

            'oDataReader.Close()
            'oContentManager = Nothing
            'Response.Redirect(sLinkPageNotFound & "?page=" & GetFileName())
        End If
        oDataReader.Close()

        oContentManager = Nothing
    End Sub

    Protected Sub ProcessPageData(ByVal oDataReader As SqlDataReader)
        nTemplateId = oDataReader("template_id").ToString
        sTemplateName = oDataReader("template_name").ToString
        sTemplateFolderName = oDataReader("folder_name").ToString
        sTitle = HttpUtility.HtmlEncode(oDataReader("title").ToString)
        If IsDBNull(oDataReader("price")) Then
            nPrice = 0
        Else
            nPrice = Convert.ToDecimal(oDataReader("price"))
        End If
        If IsDBNull(oDataReader("sale_price")) Then
            nSalePrice = 0
        Else
            nSalePrice = Convert.ToDecimal(oDataReader("sale_price"))
        End If
        If IsDBNull(oDataReader("discount_percentage")) Then
            nDiscountPercentage = 0
        Else
            nDiscountPercentage = Convert.ToDecimal(oDataReader("discount_percentage"))
        End If
        sSummary = oDataReader("summary").ToString
        nPageId = CInt(oDataReader("page_id"))
        nParentId = CInt(oDataReader("parent_id"))
        'sorting tdk seharusnya null (ini buat jaga2 krn code2 lama)
        If oDataReader("sorting").ToString = "" Then
            nSorting = 0
        Else
            nSorting = CInt(oDataReader("sorting"))
        End If
        sLinkPlacement = oDataReader("link_placement").ToString
        nChannelId = CInt(oDataReader("channel_id"))
        nVersion = CInt(oDataReader("version"))
        sContentBody = oDataReader("content_body").ToString
        sContentLeft = oDataReader("content_left").ToString
        sContentRight = oDataReader("content_right").ToString
        sFileDownload = oDataReader("file_attachment").ToString
        sFileView = oDataReader("file_view").ToString
        dDisplayDate = oDataReader("display_date")
        nFileSize = CInt(oDataReader("file_size"))
        bIsSystem = CBool(oDataReader("is_system"))
        sMetaTitle = oDataReader("meta_title").ToString
        sMetaKeywords = oDataReader("meta_keywords").ToString
        sMetaDescription = oDataReader("meta_description").ToString
        sPageModule = oDataReader("page_module").ToString
        sStatus = oDataReader("status").ToString
        sOwner = oDataReader("owner").ToString
        dtLastUpdatedDate = oDataReader("last_updated_date")
        sLastUpdatedBy = oDataReader("last_updated_by")
        sChannelName = oDataReader("channel_name")
        bDisableCollaboration = oDataReader("disable_collaboration")
        bMarkedForArchival = oDataReader("is_marked_for_archival")
        bLinksCrawled = oDataReader("allow_links_crawled")
        bPageIndexed = oDataReader("allow_page_indexed")
        nChannelPermission = oDataReader("channel_permission")

        sCustomProperties = oDataReader("properties2").ToString 'Custom Properties
        If IsDBNull(oDataReader("https")) Then
            bHttps = False
        Else
            bHttps = CBool(oDataReader("https"))
        End If
        nRootId = CInt(oDataReader("root_id"))

        If IsDBNull(oDataReader("is_listing")) Then
            bIsListing = False
        Else
            bIsListing = Convert.ToBoolean(oDataReader("is_listing"))
        End If
        If IsDBNull(oDataReader("first_published_date")) Then
            bHasPublished = False
        Else
            dtFirstPublishedDate = Convert.ToDateTime(oDataReader("first_published_date"))
            bHasPublished = True
        End If

        sElements = oDataReader("elements").ToString()

        If IsDBNull(oDataReader("listing_datetime_format")) Then
            sListingDateTimeFormat = False
        Else
            sListingDateTimeFormat = Convert.ToString(oDataReader("listing_datetime_format"))
        End If

        If IsDBNull(oDataReader("listing_template_id")) Then
            nListingTemplateId = False
        Else
            nListingTemplateId = Convert.ToInt32(oDataReader("listing_template_id"))
        End If
        sListingScript = oDataReader("listing_script").ToString
        If IsDBNull(oDataReader("listing_type")) Then
            nListingType = False
        Else
            nListingType = Convert.ToInt32(oDataReader("listing_type"))
        End If
        If IsDBNull(oDataReader("listing_property")) Then
            nListingProperty = False
        Else
            nListingProperty = Convert.ToInt32(oDataReader("listing_property"))
        End If
        If IsDBNull(oDataReader("listing_columns")) Then
            nListingColumns = False
        Else
            nListingColumns = Convert.ToInt32(oDataReader("listing_columns"))
        End If
        If IsDBNull(oDataReader("listing_page_size")) Then
            nListingPageSize = False
        Else
            nListingPageSize = Convert.ToInt32(oDataReader("listing_page_size"))
        End If
        If IsDBNull(oDataReader("listing_use_categories")) Then
            bListingUseCategories = False
        Else
            bListingUseCategories = Convert.ToBoolean(oDataReader("listing_use_categories"))
        End If
        sListingDefaultOrder = oDataReader("listing_default_order").ToString

        If IsDBNull(oDataReader("link")) Then
            sLink = False
        Else
            sLink = Convert.ToString(oDataReader("link"))
        End If
        If IsDBNull(oDataReader("link_target")) Then
            sLinkTarget = False
        Else
            sLinkTarget = Convert.ToString(oDataReader("link_target"))
        End If
        If IsDBNull(oDataReader("is_link")) Then
            bIsLink = False
        Else
            bIsLink = Convert.ToBoolean(oDataReader("is_link"))
        End If

        'If bShowWorking Then
        'Check Parent Page
        If Not IsDBNull(oDataReader("parent_parent_id")) Then
            nParentParentId = CInt(oDataReader("parent_parent_id"))
        Else
            nParentParentId = Nothing
        End If

        If Not IsDBNull(oDataReader("parent_is_listing")) Then
            bParentIsListing = Convert.ToBoolean(oDataReader("parent_is_listing"))
        Else
            bParentIsListing = Nothing
        End If

        If Not IsDBNull(oDataReader("parent_listing_type")) Then
            nParentListingType = CInt(oDataReader("parent_listing_type"))
        Else
            nParentListingType = Nothing
        End If
        If Not IsDBNull(oDataReader("parent_listing_property")) Then
            nParentListingProperty = CInt(oDataReader("parent_listing_property"))
        Else
            nParentListingProperty = Nothing
        End If
        If Not IsDBNull(oDataReader("parent_listing_use_categories")) Then
            bParentListingUseCategories = Convert.ToBoolean(oDataReader("parent_listing_use_categories"))
        Else
            bParentListingUseCategories = Nothing
        End If

        sParentElements = oDataReader("parent_elements").ToString
        sParentFileName = oDataReader("parent_file_name").ToString
        sParentChannelName = oDataReader("parent_channel_name").ToString
        If sChannelName = sParentChannelName Then
            bInitialPage = False
        Else
            bInitialPage = True
        End If
        'End If

        '~~~ HTTPS handling ~~~
        Dim sScriptName As String
        sScriptName = sAppPath & GetFileName()
        'Response.Buffer = True
        If Not Request.ServerVariables("HTTPS") = "on" And bHttps Then
            Dim sHttpsUrl As String = ""
            Dim sQueryString As String = ""
            sHttpsUrl = "https://" & sUrlAuthority & Response.ApplyAppPathModifier(sScriptName)
            sQueryString = Request.ServerVariables("QUERY_STRING")
            If Not sQueryString = "" Then
                sHttpsUrl = sHttpsUrl & "?" & sQueryString
            End If
            oDataReader.Close()
            'oContentManager = Nothing
            Response.Redirect(sHttpsUrl)
        End If

        If Request.ServerVariables("HTTPS") = "on" And Not bHttps Then
            Dim sHttpsUrl As String = ""
            Dim sQueryString As String = ""
            sHttpsUrl = "http://" & sUrlAuthority & Response.ApplyAppPathModifier(sScriptName)
            sQueryString = Request.ServerVariables("QUERY_STRING")
            If Not sQueryString = "" Then
                sHttpsUrl = sHttpsUrl & "?" & sQueryString
            End If
            oDataReader.Close()
            'oContentManager = Nothing
            Response.Redirect(sHttpsUrl)
        End If
        '~~~ /HTTPS handling ~~~

        'If IsDBNull(oDataReader("price")) Then
        '    nPrice = Nothing
        'Else
        '    nPrice = Convert.ToDecimal(oDataReader("price"))
        'End If

        If oDataReader("published_start_date").ToString = "" Then
            bUseStartDate = False
        Else
            bUseStartDate = True
            dStartDate = oDataReader("published_start_date")
        End If
        If oDataReader("published_end_date").ToString = "" Then
            bUseEndDate = False
        Else
            bUseEndDate = True
            dEndDate = oDataReader("published_end_date")
        End If

        'Check Schedule
        'Not that if today is outside the scheduled date,
        'content won't be displayed in sitemap/navigation, so this checking is just 
        'for protection only incase the content url is accessed directly.
        If bUseStartDate Then
            If Now < dStartDate Then
                'Do not display content before the scheduled date
                If Not bShowWorking Then
                    oDataReader.Close()
                    Response.End()
                End If
            End If
        End If
        If bUseEndDate Then
            If Now > dEndDate Then
                'Do not display content after the scheduled date
                If Not bShowWorking Then
                    oDataReader.Close()
                    Response.End()
                End If
            End If
        End If

        'User Authorization based-on Channel Permission
        'There are 3 types of channel viewing permission:
        '   1. Anonymous (content within the channel accessible to public)
        '   2. Registered Users (content within the channel can be viewed by all logged-in users)
        '   3. Channel Users Only (Only users assigned to the channel as Subscribers, Authors, Editors, Publishers, Resource Managers
        '   and Administrators are able to view content)
        'If the current page/content has channel 1, user is allowed to view.
        'If the current page/content has channel 2, the page is displayed with login for (later in Page_Load)
        If nChannelPermission = 3 Then
            If Not (bIsAdministrator = True Or _
                bIsSubscriber = True Or _
                bIsAuthor = True Or _
                bIsEditor = True Or _
                bIsPublisher = True Or _
                bIsResourceManager = True) Then

                'Not Authorized => redirect to home (berguna waktu logout)
                bRedirectToHome = True
                If nParentId = 0 Then 'kalau page saat ini sudah home
                    oDataReader.Close()
                    Response.Redirect(sLinkPageNotFound & "?page=" & GetFileName())
                End If
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If Me.IsPostBack And hidModule.Value <> "" Then
        '    btnModulePosition_Click(sender, e)
        'End If

        sResourcesInternal_FileDownload = ConfigurationManager.AppSettings("FileStorage")
        If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
            sResourcesInternal_FileView = ConfigurationManager.AppSettings("FileStorage")
            sResourcesInternal_FileViewListing = ConfigurationManager.AppSettings("FileStorage")
            lblPreviewOnPage_FileType.Text = "(JPG, GIF, PNG)"
        Else
            sResourcesInternal_FileView = Server.MapPath("resources") & "\internal"
            sResourcesInternal_FileViewListing = Server.MapPath("resources") & "\internal"
            lblPreviewOnPage_FileType.Text = "(FLV, MP3, JPG, GIF, PNG)"
        End If

        lblRawUrl.Text = HttpContext.Current.Items("action")
        lblRawUrl.Style.Add("display", "none")

        If bRedirectToHome Then
            Response.Redirect(sRootFile)
        End If

        If bIsLink And bIsReader Then
            Response.Redirect(sLink)
        End If

        '*** PREPARATION ***
        placeholderTopMenu = Page.Master.FindControl("placeholderTopMenu")
        placeholderTopMenu_VerticalMenu = Page.Master.FindControl("placeholderTopMenu_VerticalMenu")
        placeholderBottomMenu = Page.Master.FindControl("placeholderBottomMenu")
        placeholderSearch = Page.Master.FindControl("placeholderSearch")
        placeholderMainMenu_DropMenu = Page.Master.FindControl("placeholderMainMenu_DropMenu")
        placeholderMainMenu_DropDown = Page.Master.FindControl("placeholderMainMenu_DropDown")
        placeholderMainMenu_Links = Page.Master.FindControl("placeholderMainMenu_Links")
        placeholderMainMenu_VerticalMenu = Page.Master.FindControl("placeholderMainMenu_VerticalMenu")
        placeholderBreadcrumb = Page.Master.FindControl("placeholderBreadcrumb")
        placeholderTitle = Page.Master.FindControl("placeholderTitle")
        placeholderLeftTop = Page.Master.FindControl("placeholderLeftTop")
        placeholderLeft = Page.Master.FindControl("placeholderLeft")
        placeholderLeftBottom = Page.Master.FindControl("placeholderLeftBottom")
        placeholderBody = Page.Master.FindControl("placeholderBody")
        placeholderBodyTop = Page.Master.FindControl("placeholderBodyTop")
        placeholderBodyBottom = Page.Master.FindControl("placeholderBodyBottom")
        placeholderRightTop = Page.Master.FindControl("placeholderRightTop")
        placeholderRight = Page.Master.FindControl("placeholderRight")
        placeholderRightBottom = Page.Master.FindControl("placeholderRightBottom")
        placeholderPageInfo = Page.Master.FindControl("placeholderPageInfo")
        placeholderAuthoring = Page.Master.FindControl("placeholderAuthoring")
        placeholderContentRating = Page.Master.FindControl("placeholderContentRating")
        placeholderComments = Page.Master.FindControl("placeholderComments")
        placeholderPrint = Page.Master.FindControl("placeholderPrint")
        placeholderPagesWithin = Page.Master.FindControl("placeholderPagesWithin")
        placeholderSameLevelPages = Page.Master.FindControl("placeholderSameLevelPages")
        placeholderCountrySelect = Page.Master.FindControl("placeholderCountrySelect")
        placeholderLoginForm = Page.Master.FindControl("placeholderLoginForm")
        placeholderWelcome = Page.Master.FindControl("placeholderWelcome")
        placeholderAdminWorkspaceLink = Page.Master.FindControl("placeholderAdminWorkspaceLink")
        placeholderLoginLogout = Page.Master.FindControl("placeholderLoginLogout")
        placeholderRegister = Page.Master.FindControl("placeholderRegister")
        placeholderLogout = Page.Master.FindControl("placeholderLogout")
        placeholderMainMenu_Tabs = Page.Master.FindControl("placeholderMainMenu_Tabs")
        placeholderMainMenu_Side = Page.Master.FindControl("placeholderMainMenu_Side")
        placeholderMenu_Tree = Page.Master.FindControl("placeholderMenu_Tree")
        placeholderScript = Page.Master.FindControl("placeholderScript")
        placeholderOrderNow = Page.Master.FindControl("placeholderOrderNow")
        placeholderCartInfo = Page.Master.FindControl("placeholderCartInfo")
        placeholderFileView = Page.Master.FindControl("placeholderFileView")
        placeholderFileDownload = Page.Master.FindControl("placeholderFileDownload")
        placeholderArchives = Page.Master.FindControl("placeholderArchives")
        placeholderCategoryList = Page.Master.FindControl("placeholderCategoryList")
        placeholderSubscribe = Page.Master.FindControl("placeholderSubscribe")
        placeholderListing = Page.Master.FindControl("placeholderListing")

        placeholderPublishingInfo = Page.Master.FindControl("placeholderPublishingInfo")
        placeholderStatPageViews = Page.Master.FindControl("placeholderStatPageViews")
        placeholderStatPageViews_Vertical = Page.Master.FindControl("placeholderStatPageViews_Vertical")
        placeholderStatPageViews_Private = Page.Master.FindControl("placeholderStatPageViews_Private")
        placeholderStatPageViews_Vertical_Private = Page.Master.FindControl("placeholderStatPageViews_Vertical_Private")
        placeholderCategoryInfo = Page.Master.FindControl("placeholderCategoryInfo")

        placeholderPageTools = Page.Master.FindControl("placeholderPageTools")
        placeholderSiteRss = Page.Master.FindControl("placeholderSiteRss")

        '~~~ Template Object ~~~
        Dim oMasterPage As BaseMaster = CType(Me.Master, BaseMaster)
        Dim dictSiteMap As New Dictionary(Of String, ArrayList)
        Dim dictMainMenu As New Dictionary(Of String, ArrayList)
        Dim dictTopMenu As New Dictionary(Of String, ArrayList)
        Dim dictBottomMenu As New Dictionary(Of String, ArrayList)
        Dim dictSameLevelPages As New Dictionary(Of String, ArrayList)
        Dim dictLocales As New Dictionary(Of String, ArrayList)
        Dim dictPagesWithin As New Dictionary(Of String, ArrayList)
        Dim dictFixedMenu As New Dictionary(Of String, ArrayList)
        Dim arrItem As ArrayList
        '~~~ /Template Object ~~~

        sCurrencySymbol = oMasterPage.CurrencySymbol 'Thread.CurrentThread.CurrentUICulture.NumberFormat.CurrencySymbol

        '~~~ Template Object (Shopping Cart) ~~~
        oMasterPage.ShoppingCartLink = sLinkShoppingCart
        oMasterPage.ShoppingCartTitle = GetLocalResourceObject("Shopping Cart") 'krn hardcoded di SQL
        '~~~ /Template Object ~~~

        '~~~ Template Object (Home Link) ~~~
        oMasterPage.HomeLink = sRootFile
        oMasterPage.HomeLinkTitle = sRootTitle
        '~~~ /Template Object ~~~

        '~~~ Template Object (General Purpose BodyStart & BodyEnd) ~~~
        litBodyStart.Text = oMasterPage.BodyStart
        litBodyEnd.Text = oMasterPage.BodyEnd
        '~~~ /Template Object ~~~

        '~~~ Template Object (Custom Properties) ~~~
        Dim nCount As Integer = Split(sCustomProperties, "#||#").Length
        If nCount > 0 Then oMasterPage.CustomValue1 = Split(sCustomProperties, "#||#")(0)
        If nCount > 1 Then oMasterPage.CustomValue2 = Split(sCustomProperties, "#||#")(1)
        If nCount > 2 Then oMasterPage.CustomValue3 = Split(sCustomProperties, "#||#")(2)
        If nCount > 3 Then oMasterPage.CustomValue4 = Split(sCustomProperties, "#||#")(3)
        If nCount > 4 Then oMasterPage.CustomValue5 = Split(sCustomProperties, "#||#")(4)
        If nCount > 5 Then oMasterPage.CustomValue6 = Split(sCustomProperties, "#||#")(5)
        If nCount > 6 Then oMasterPage.CustomValue7 = Split(sCustomProperties, "#||#")(6)
        If nCount > 7 Then oMasterPage.CustomValue8 = Split(sCustomProperties, "#||#")(7)
        If nCount > 8 Then oMasterPage.CustomValue9 = Split(sCustomProperties, "#||#")(8)
        If nCount > 9 Then oMasterPage.CustomValue10 = Split(sCustomProperties, "#||#")(9)
        '~~~~

        '~~~ Template Object (Site Info) ~~~
        oMasterPage.SiteName = sSiteName
        oMasterPage.SiteAddress = sSiteAddress
        oMasterPage.SiteCity = sSiteCity
        oMasterPage.SiteState = sSiteState
        oMasterPage.SiteCountry = sSiteCountry
        oMasterPage.SiteZip = sSiteZip
        oMasterPage.SitePhone = sSitePhone
        oMasterPage.SiteFax = sSiteFax
        oMasterPage.SiteEmail = sSiteEmail
        '~~~~

        'Common variables
        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String 'eg.default.aspx, mysite/default.aspx
        Dim sFileUrl As String 'eg. /default.aspx, /mysite/default.aspx
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nLevel As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean
        Dim sTarget As String
        Dim bUseWindowOpen As Boolean

        Dim bIsLnk As Boolean 'tdk perlu bIsLnk krn pasti sama
        Dim sLnkTrgt As String = ""
        Dim sLnkTrgt2 As String = ""

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        'Used for Approval Link
        lnkApprovalAssistant.NavigateUrl = sLinkApproval
        lnkApprovalAssistant2.NavigateUrl = sLinkApproval

        'Floating My Workspace & Admin
        ShowWorkspace()
        ShowAdmin()

        '~~~ Template Object (Login Link) ~~~
        oMasterPage.LoginLink = sLinkLogin
        oMasterPage.LoginLinkTitle = GetLocalResourceObject("LoginLinkText")
        oMasterPage.LogoutLinkTitle = GetLocalResourceObject("LogoutLinkText")
        '~~~ /Template Object ~~~

        'Include js script utility for dialogs
        ClientScript.RegisterClientScriptInclude("js1", "dialogs/dialog.js")

        'Print Link
        If Not IsNothing(placeholderPrint) Then
            Dim lnkPrint As HyperLink = New HyperLink
            'Specify querystring "print=Y" for printer friendly url
            If sRawUrl.Contains("?") Then
                lnkPrint.NavigateUrl = Request.RawUrl.ToString & "&print=Y"
            Else
                lnkPrint.NavigateUrl = Request.RawUrl.ToString & "?print=Y"
            End If
            lnkPrint.Target = "_blank"
            lnkPrint.Text = GetLocalResourceObject("Print this page")
            lnkPrint.CssClass = "print"
            placeholderPrint.Controls.Add(lnkPrint)
        End If

        '~~~ Template Object (Login Link) ~~~
        If sRawUrl.Contains("?") Then
            oMasterPage.PrintLink = Request.RawUrl.ToString & "&print=Y"
        Else
            oMasterPage.PrintLink = Request.RawUrl.ToString & "?print=Y"
        End If
        oMasterPage.PrintLinkTitle = GetLocalResourceObject("Print this page")
        '~~~ /Template Object ~~~

        If Not IsNothing(placeholderSearch) Then
            If Not placeholderSearch.Visible = False Then
                lblSearch.Text = GetLocalResourceObject("Search")
                lblSearch.Style.Add("display", "none")
                btnSearch.Attributes.Add("onkeypress", "this.onclick")
                If Not Page.IsPostBack Then
                    txtSearch.Text = GetLocalResourceObject("Search")
                    txtSearch.Attributes.Add("onfocus", "if(this.value=='" & GetLocalResourceObject("Search") & "'){this.value=''}")
                    txtSearch.Attributes.Add("onblur", "if(this.value==''){this.value='" & GetLocalResourceObject("Search") & "'}")
                End If
            End If
        End If

        If Not IsNothing(placeholderLoginForm) Then
            If Not placeholderLoginForm.Visible = False Then
                Dim sLoginBefore As String = ""
                Dim sLoginAfter As String = ""
                If bUserLoggedIn Then
                    Dim oLoginStatus As New LoginStatus
                    oLoginStatus.LogoutPageUrl = HttpContext.Current.Items("_path")
                    oLoginStatus.LogoutAction = LogoutAction.Redirect
                    oLoginStatus.CssClass = "logout"
                    oLoginStatus.LogoutText = GetLocalResourceObject("Logout_LogoutText")

                    sLoginBefore = "<table cellpadding=""0"" cellspacing=""0"" class=""boxLogout""><tr><td class=""boxFormLogout"">"
                    placeholderLoginForm.Controls.Add(New LiteralControl(sLoginBefore))

                    placeholderLoginForm.Controls.Add(oLoginStatus)

                    sLoginAfter = "</td></tr></table>"
                    placeholderLoginForm.Controls.Add(New LiteralControl(sLoginAfter))
                Else
                    Dim oLogin As New Login
                    oLogin.ID = "Login"
                    oLogin.FailureText = GetLocalResourceObject("Login_FailureText")
                    oLogin.LoginButtonText = GetLocalResourceObject("Login_LoginButtonText")
                    oLogin.PasswordLabelText = GetLocalResourceObject("Login_PasswordLabelText")
                    oLogin.PasswordRecoveryText = GetLocalResourceObject("Login_PasswordRecoveryText")
                    oLogin.RememberMeText = GetLocalResourceObject("Login_RememberMeText")
                    oLogin.UserNameLabelText = GetLocalResourceObject("Login_UserNameLabelText")
                    oLogin.LabelStyle.HorizontalAlign = HorizontalAlign.Left
                    oLogin.LabelStyle.Wrap = False
                    oLogin.PasswordRecoveryUrl = "~/" & sLinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
                    oLogin.TitleText = ""
                    oLogin.TextBoxStyle.CssClass = "txtLogin"
                    oLogin.LoginButtonStyle.CssClass = "btnLogin"
                    oLogin.LabelStyle.CssClass = "labelLogin"
                    oLogin.SkinID = "lgnLogin"
                    oLogin.DestinationPageUrl = HttpContext.Current.Items("_path")

                    Dim oPanel As New Panel
                    oPanel.DefaultButton = "Login$LoginButton"

                    sLoginBefore = "<table cellpadding=""0"" cellspacing=""0"" class=""boxLogin"">"
                    sLoginBefore += "<tr><td class=""boxHeaderLogin"">" & GetLocalResourceObject("Login") & "</td></tr>"
                    sLoginBefore += "<tr><td class=""boxFormLogin"">"
                    oPanel.Controls.Add(New LiteralControl(sLoginBefore))

                    oPanel.Controls.Add(oLogin)

                    sLoginAfter = "</td></tr></table>"
                    oPanel.Controls.Add(New LiteralControl(sLoginAfter))

                    placeholderLoginForm.Controls.Add(oPanel)
                End If
            End If
        End If

        If Not IsNothing(placeholderWelcome) Then
            If Not placeholderWelcome.Visible = False Then
                If bUserLoggedIn Then
                    placeholderWelcome.Controls.Add(New LiteralControl("" & GetLocalResourceObject("Welcome") & " <b>" & sUserName & "</b>&nbsp;&nbsp;|"))
                End If
            End If
        End If

        If Not IsNothing(placeholderAdminWorkspaceLink) Then
            If Not placeholderAdminWorkspaceLink.Visible = False Then
                If bUserLoggedIn Then
                    Dim sAdminLink As String = "<a class=""admin"" href=""" & sLinkAdmin & """ onmouseover=""float.doShow(event, 'popAdmin')"" onmouseout=""float.doHide('popAdmin')"">" & GetLocalResourceObject("AdminLinkText") & "</a>"
                    If bIsAdministrator Then
                        placeholderAdminWorkspaceLink.Controls.Add(New LiteralControl("<a class=""myworkspace"" href=""" & sLinkWorkspace & """ onmouseover=""float.doShow(event, 'popWorkspace')"" onmouseout=""float.doHide('popWorkspace')"">" & GetLocalResourceObject("MyWorkspaceLinkText") & "</a>&nbsp;" & sAdminLink))
                    Else
                        placeholderAdminWorkspaceLink.Controls.Add(New LiteralControl("<a class=""myworkspace"" href=""" & sLinkWorkspace & """ onmouseover=""float.doShow(event, 'popWorkspace')"" onmouseout=""float.doHide('popWorkspace')"">" & GetLocalResourceObject("MyWorkspaceLinkText") & "</a>"))
                    End If
                End If
            End If
        End If

        If Not IsNothing(placeholderLoginLogout) Then
            If Not placeholderLoginLogout.Visible = False Then

                Dim lsLogin As HyperLink = New HyperLink
                lsLogin.CssClass = "login"
                lsLogin.Text = GetLocalResourceObject("LoginLinkText")
                lsLogin.NavigateUrl = "~/" & sLinkLogin & "?ReturnUrl=" & HttpContext.Current.Items("_path")

                If bUserLoggedIn Then
                    lsLogin.Visible = False
                Else
                    lsLogin.Visible = True
                End If

                placeholderLoginLogout.Controls.Add(lsLogin)

                Dim lsLogout As LoginStatus = New LoginStatus
                lsLogout.LogoutAction = LogoutAction.Redirect
                lsLogout.LogoutPageUrl = HttpContext.Current.Items("_path")
                lsLogout.CssClass = "logout"
                lsLogout.LogoutText = GetLocalResourceObject("LogoutLinkText")

                If bUserLoggedIn Then
                    placeholderLoginLogout.Controls.Add(lsLogout)
                End If

            End If
        End If

        If Not IsNothing(placeholderLogout) Then
            If Not placeholderLogout.Visible = False Then

                Dim lsLogout As LoginStatus = New LoginStatus
                lsLogout.LogoutAction = LogoutAction.Redirect
                lsLogout.LogoutPageUrl = HttpContext.Current.Items("_path")
                lsLogout.CssClass = "logout"
                lsLogout.LogoutText = GetLocalResourceObject("LogoutLinkText")

                If bUserLoggedIn Then
                    placeholderLogout.Controls.Add(lsLogout)
                End If

            End If
        End If

        If Not IsNothing(placeholderRegister) Then
            If Not placeholderRegister.Visible = False Then
                If Not bUserLoggedIn Then
                    Dim lnkRegistration As HyperLink = New HyperLink
                    lnkRegistration.CssClass = "register"
                    lnkRegistration.Text = GetLocalResourceObject("RegisterLinkText")
                    lnkRegistration.NavigateUrl = "~/" & sLinkRegistration & "?ReturnUrl=" & HttpContext.Current.Items("_path")
                    placeholderRegister.Controls.Add(lnkRegistration)
                End If
            End If
        End If

        'Layout Type
        If placeholderLeft.Visible = True And _
            placeholderRight.Visible = False Then
            nLayoutType = 1
        ElseIf placeholderLeft.Visible = False And _
            placeholderRight.Visible = True Then
            nLayoutType = 2
        Else
            nLayoutType = 3
        End If

        '*** BREADCRUMBS ***
        Dim oColPath As Collection
        oColPath = colPath()
        Dim sPathInfo As String = ""
        Dim sTmpItem() As String

        Dim sBreadcrumbLinkSeparator As String = ">"

        '~~~ Template Object ~~~
        If Not oMasterPage.BreadcrumbLinkSeparator = "" Then
            sBreadcrumbLinkSeparator = oMasterPage.BreadcrumbLinkSeparator
        End If
        '~~~ /Template Object ~~~

        For Each sTmpItem In oColPath

            'Database Stored Title Localization
            Dim sTmpTitle As String = sTmpItem(1).ToString
            Dim sTmpTitle2 As String = GetLocalResourceObject(sTmpTitle)
            If Not sTmpTitle2 = "" Then
                sTmpTitle = sTmpTitle2
            End If

            If sTmpItem(2).ToString = "0" Then 'root
                If nParentId = 0 Then
                    sPathInfo = "" 'Do not show breadcrumb on home page
                Else
                    sPathInfo += "<a class=""breadcrumb"" href=""" & sTmpItem(0).ToString & """>" & sTmpTitle & "</a>"
                End If
            Else
                If sTmpItem(0).ToString.ToLower = GetFileName().ToLower Then
                    sPathInfo += " " & sBreadcrumbLinkSeparator & " " & sTmpTitle
                Else
                    sPathInfo += " " & sBreadcrumbLinkSeparator & " <a class=""breadcrumb"" href=""" & sTmpItem(0).ToString & """>" & sTmpTitle & "</a>"
                End If
            End If
        Next

        If Not IsNothing(placeholderBreadcrumb) Then
            If Not placeholderBreadcrumb.Visible = False Then
                placeholderBreadcrumb.Controls.Add(New LiteralControl("<div class=""breadcrumb"">" & sPathInfo & "</div>"))
            End If
        End If

        'Hide Home link
        Dim bHideHomeLink As Boolean = False
        If oMasterPage.HideHomeLink Then
            bHideHomeLink = True
        End If

        '*** MAIN MENU (VERTICAL) ***
        If Not IsNothing(placeholderMainMenu_VerticalMenu) Then
            If Not placeholderMainMenu_VerticalMenu.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_vertical.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("ColPath").SetValue(oUC, oColPath, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                oUCType.GetProperty("LinkPlacement").SetValue(oUC, "main", Nothing)
                placeholderMainMenu_VerticalMenu.Controls.Add(oUC)
            End If
        End If

        '*** TOP MENU (VERTICAL) ***
        If Not IsNothing(placeholderTopMenu_VerticalMenu) Then
            If Not placeholderTopMenu_VerticalMenu.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_vertical.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("ColPath").SetValue(oUC, oColPath, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                oUCType.GetProperty("LinkPlacement").SetValue(oUC, "top", Nothing)
                placeholderTopMenu_VerticalMenu.Controls.Add(oUC)
            End If
        End If

        '*** MAIN MENU (TABS) ***
        If Not IsNothing(placeholderMainMenu_Tabs) Then
            If Not placeholderMainMenu_Tabs.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_tabs.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("ColPath").SetValue(oUC, oColPath, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                placeholderMainMenu_Tabs.Controls.Add(oUC)
            End If
        End If

        '*** MAIN MENU (LINKS) ***
        If Not IsNothing(placeholderMainMenu_Links) Then
            If Not placeholderMainMenu_Links.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_links.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                placeholderMainMenu_Links.Controls.Add(oUC)
            End If
        End If

        '*** MAIN MENU (SIDE) ***
        If Not IsNothing(placeholderMainMenu_Side) Then
            If Not placeholderMainMenu_Side.Visible = False And oColPath.Count > 1 Then
                Dim oUC As Control = LoadControl("systems/menu_side.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("ColPath").SetValue(oUC, oColPath, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                oUCType.GetProperty("LinkPlacement").SetValue(oUC, sLinkPlacement, Nothing)
                placeholderMainMenu_Side.Controls.Add(oUC)
            End If
        End If

        '*** MENU (TREE) ***
        If Not IsNothing(placeholderMenu_Tree) Then
            If Not placeholderMenu_Tree.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_tree.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                placeholderMenu_Tree.Controls.Add(oUC)
            End If
        End If

        '*** MAIN MENU (DROP MENU) ***
        If Not IsNothing(placeholderMainMenu_DropMenu) Then
            If Not placeholderMainMenu_DropMenu.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_dropmenu.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                placeholderMainMenu_DropMenu.Controls.Add(oUC)
            End If
        End If

        '*** MAIN MENU (DROPDOWN/FLOAT MENU) ***
        If Not IsNothing(placeholderMainMenu_DropDown) Then
            If Not placeholderMainMenu_DropDown.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_dropdown.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                placeholderMainMenu_DropDown.Controls.Add(oUC)
            End If
        End If

        '***  TOP/BOTTOM MENU ***
        If Not IsNothing(placeholderTopMenu) Or Not IsNothing(placeholderBottomMenu) Then
            Dim oUC As Control = LoadControl("systems/menu_topbottom.ascx")
            Dim oUCType As Type = oUC.GetType
            oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
            oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
            oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
            If Not IsNothing(placeholderTopMenu) Then
                If Not placeholderTopMenu.Visible = False Then
                    placeholderTopMenu.Controls.Add(New LiteralControl(oUCType.GetProperty("TopMenu").GetValue(oUC, Nothing)))
                End If
            End If
            If Not IsNothing(placeholderBottomMenu) Then
                If Not placeholderBottomMenu.Visible = False Then
                    placeholderBottomMenu.Controls.Add(New LiteralControl(oUCType.GetProperty("BottomMenu").GetValue(oUC, Nothing)))
                End If
            End If
        End If

        '*** COUNTRY SELECTION ***
        'my code
        Dim currentCountryID As Integer
        'end mycode
        Dim sSelectInstruction As String = ""
        oCommand = New SqlCommand("advcms_GetRegion")
        oCommand.CommandType = CommandType.StoredProcedure
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            sSelectInstruction = oDataReader("instruction_text").ToString
            'my code
            currentCountryID = oDataReader("locale_id")
            'end mycode
        End If
        oDataReader.Close()
        If sSelectInstruction = "" Then
            sSelectInstruction = "- Select Country/Region -"
        Else
            sSelectInstruction = "- " & sSelectInstruction & " -"
        End If
        '~~~~~~~

        Dim oList As ListItem
        Dim oDropDownList As DropDownList = New DropDownList
        Dim sLocaleHomePage As String
        Dim sLocaleDescription As String
        'my code
        Dim sLangTabs As String = ""
        'end my code

        oList = New ListItem
        oList.Text = sSelectInstruction
        oList.Value = ""
        oList.Selected = True
        oDropDownList.Items.Add(oList)

        Dim sSQL As String = "SELECT * FROM locales where active=@active order by description"
        oCommand = New SqlCommand(sSQL, oConn)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@active", SqlDbType.Bit).Value = True
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            sLocaleDescription = oDataReader("description")
            sLocaleHomePage = oDataReader("home_page")
            sFileUrl = sAppPath & sLocaleHomePage

            If oDataReader("locale_id") <> currentCountryID Then
                sLangTabs += "<a  href=""" & sFileUrl & """>" & sLocaleDescription & "</a>&nbsp;&nbsp;|&nbsp;&nbsp;"
            End If

            oList = New ListItem
            oList.Text = sLocaleDescription
            oList.Value = sFileUrl 'sLocaleHomePage
            oDropDownList.Items.Add(oList)

            '~~~ Template Object ~~~
            arrItem = New ArrayList
            arrItem.Add(sLocaleHomePage)
            arrItem.Add(sLocaleDescription)
            If sRootFile = sLocaleHomePage Then
                arrItem.Add(True)
            Else
                arrItem.Add(False)
            End If
            dictLocales.Add(sLocaleHomePage, arrItem)
            '~~~ /Template Object ~~~
        End While
        oDataReader.Close()
        If oDropDownList.Items.Count = 1 Then 'cuma ada instruction saja
            oDropDownList.Visible = False
        End If
        oDropDownList.Attributes.Add("onchange", "if(this.value!='')window.location.href=this.value;")

        If Not IsNothing(placeholderCountrySelect) Then
            If Not placeholderCountrySelect.Visible = False Then
                'placeholderCountrySelect.Controls.Add(oDropDownList)
                placeholderCountrySelect.Controls.Add(New LiteralControl(sLangTabs))
            End If
        End If

        '~~~ Template Object ~~~
        oMasterPage.Locales = dictLocales
        '~~~ /Template Object ~~~

        '*** USER AUTHENTICATION ***

        'Check URL
        Dim sServerUrl As String = sRawUrl
        If sRawUrl.Contains("?") Then
            sServerUrl = sRawUrl.Split(CChar("?"))(0).ToString
        End If

        If nChannelPermission = 2 Then 'nChannelPermission=3 tdk perlu krn lgs di-redirect ke home (lihat Page_PreInit) 
            If Not bUserLoggedIn Then
                'Show Login
                panelLogin.Visible = True

                'Required (krn bagian ini lgs exit. Lihat code selanjutnya for details)
                placeholderPageInfo.Visible = False
                btnModulePosition.Style.Add("display", "none")

                '~~~~ Title ~~~~
                'Database Stored Title Localization
                If bIsSystem Then
                    If Not GetLocalResourceObject(sTitle) = "" Then
                        sTitle = GetLocalResourceObject(sTitle)
                    End If
                End If
                litTitle.Text = "<div class=""title"">" & sTitle & "</div>"
                Page.Master.Page.Title = Page.Master.Page.Title & sTitle
                '~~~~ /Title ~~~~

                'Float scripts
                Page.Master.Page.Header.Controls.Add(New LiteralControl("<script language=""javascript"" type=""text/javascript"" src=""systems/float/float.js""></script>"))

                Exit Sub
            End If
        End If

        '*** PAGE WITHIN & SAME LEVEL PAGES MENU ***
        If Not IsNothing(placeholderPagesWithin) Or Not IsNothing(placeholderSameLevelPages) Then
            If Not placeholderPagesWithin.Visible = False Or Not placeholderSameLevelPages.Visible = False Then
                Dim oUC As Control = LoadControl("systems/menu_pageswithin.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("ParentID").SetValue(oUC, nParentId, Nothing)
                oUCType.GetProperty("ParentParentID").SetValue(oUC, nParentParentId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                If Not placeholderPagesWithin.Visible = False Then
                    placeholderPagesWithin.Controls.Add(New LiteralControl(oUCType.GetProperty("PagesWithin").GetValue(oUC, Nothing)))
                End If
                If Not placeholderSameLevelPages.Visible = False Then
                    placeholderSameLevelPages.Controls.Add(New LiteralControl(oUCType.GetProperty("SameLevelPages").GetValue(oUC, Nothing)))
                End If
            End If
        End If

        '************************************************
        '   Listing Templates
        '************************************************

        If bIsListing Then
            oCommand = New SqlCommand("SELECT * FROM listing_templates WHERE id=@id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@id", SqlDbType.Int).Value = nListingTemplateId
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            While oDataReader.Read()
                sListingTemplateName = oDataReader("template_name").ToString()
                sListingTemplateItem = oDataReader("template").ToString()
                sListingTemplateHeader = oDataReader("template_header").ToString()
                sListingTemplateFooter = oDataReader("template_footer").ToString()
            End While
            oDataReader.Close()
        End If

        '************************************************
        '   Show / Hide Status & Authoring Links
        '************************************************

        ShowHideAuthoringLink(False)

        Dim sBaseHref As String = Request.Url.Scheme & "://" & sUrlAuthority & sAppPath
        Page.Master.Page.Header.Controls.AddAt(0, New LiteralControl("<base href=""" & sBaseHref & """ />"))

        txtSummary.scriptPath = sAppPath & "systems/editor/scripts/"
        txtBody.scriptPath = sAppPath & "systems/editor/scripts/"

        '*** SHOW CONTENT ***

        Dim sDefaultElements As String = "<root>" & _
                "<title>True</title>" & _
                "<file_view>True</file_view>" & _
                "<file_download>True</file_download>" & _
                "<author>False</author>" & _
                "<author_full_name>False</author_full_name>" & _
                "<person_last_updating>False</person_last_updating>" & _
                "<person_last_updating_full_name>False</person_last_updating_full_name>" & _
                "<publish_date>False</publish_date>" & _
                "<last_updated_date>False</last_updated_date>" & _
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

        If sElements = "" Then
            sElements = sDefaultElements
        End If
        Dim oXML As XmlDocument = New XmlDocument
        oXML.LoadXml(sElements)

        If sParentElements = "" Then
            sParentElements = sDefaultElements
        End If
        Dim oXMLParent As XmlDocument = New XmlDocument
        oXMLParent.LoadXml(sParentElements)


        If Not CBool(oXML.DocumentElement.Item("title").InnerText) Then
            litTitle.Visible = False
        End If
        Dim bUseRating As Boolean = False
        If CBool(oXML.DocumentElement.Item("rating").InnerText) Then
            bUseRating = True
        End If
        Dim bUseComments As Boolean = False
        Dim bCommentsAnonymous As Boolean = False
        If CBool(oXML.DocumentElement.Item("comments").InnerText) Then
            bUseComments = True
        End If
        If CBool(oXML.DocumentElement.Item("comments_anonymous").InnerText) Then
            bCommentsAnonymous = True
        End If

        If Not CBool(oXML.DocumentElement.Item("listing_ordering").InnerText) Then
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        If bIsListing And nListingType = 2 Then
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If
        If bIsListing And nListingType = 1 And (nListingProperty = 1 Or nListingProperty = 3) Then
            dropListingOrdering.Visible = False
            litOrderBy.Visible = False
        End If

        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_title").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("title"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_author").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("owner"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_person_last_updating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_by"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_publish_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("first_published_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_last_updated_date").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("last_updated_date"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_rating").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("rating"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_comments").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("comments"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_size").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("file_size"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_downloads").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_downloads"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_downloads_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("downloads_today"))
        End If

        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_total_hits").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("total_hits"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_hits_today").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("hits_today"))
        End If
        If Not CBool(oXML.DocumentElement.Item("listing_ordering_by_price").InnerText) Then
            dropListingOrdering.Items.Remove(dropListingOrdering.Items.FindByValue("current_price"))
        End If

        '~~~~~ Author (Person First Creating) & Date First Published
        Dim sPublishingInfo As String = ""
        Dim bUsePublishingInfo As Boolean = False
        If CBool(oXML.DocumentElement.Item("author").InnerText) Then
            sPublishingInfo += "<div class=""author_date_first_published"" >"
            If CBool(oXML.DocumentElement.Item("author_full_name").InnerText) Then
                Dim userProfile As ProfileCommon = Profile.GetProfile(sOwner)
                If CBool(oXML.DocumentElement.Item("publish_date").InnerText) And bHasPublished Then
                    sPublishingInfo += "Added by " & userProfile.FirstName & " " & userProfile.LastName & " - Publish date: " & FormatDateTime(dtFirstPublishedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtFirstPublishedDate, DateFormat.ShortTime)
                Else
                    sPublishingInfo += "Added by " & userProfile.FirstName & " " & userProfile.LastName
                End If
            Else
                If CBool(oXML.DocumentElement.Item("publish_date").InnerText) And bHasPublished Then
                    sPublishingInfo += "Added by " & sOwner & " - Publish date: " & FormatDateTime(dtFirstPublishedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtFirstPublishedDate, DateFormat.ShortTime)
                Else
                    sPublishingInfo += "Added by " & sOwner
                End If
            End If
            sPublishingInfo += "</div>"
            bUsePublishingInfo = True
        Else
            If CBool(oXML.DocumentElement.Item("publish_date").InnerText) And bHasPublished Then
                sPublishingInfo += "<div class=""author_date_first_published"" >"
                sPublishingInfo += "Publish date: " & FormatDateTime(dtFirstPublishedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtFirstPublishedDate, DateFormat.ShortTime)
                sPublishingInfo += "</div>"
                bUsePublishingInfo = True
            End If
        End If

        '~~~~~ Person Last Updating & Date Last Updated/Published
        If CBool(oXML.DocumentElement.Item("person_last_updating").InnerText) Then
            sPublishingInfo += "<div class=""person_last_updating_and_date"" >"
            If CBool(oXML.DocumentElement.Item("person_last_updating_full_name").InnerText) Then
                Dim userProfile As ProfileCommon = Profile.GetProfile(sLastUpdatedBy)
                If CBool(oXML.DocumentElement.Item("last_updated_date").InnerText) Then
                    sPublishingInfo += "Last updated by " & userProfile.FirstName & " " & userProfile.LastName & " - " & FormatDateTime(dtLastUpdatedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtLastUpdatedDate, DateFormat.ShortTime)
                Else
                    sPublishingInfo += "Last updated by " & userProfile.FirstName & " " & userProfile.LastName
                End If
            Else
                If CBool(oXML.DocumentElement.Item("last_updated_date").InnerText) Then
                    sPublishingInfo += "Last updated by " & sLastUpdatedBy & " - " & FormatDateTime(dtLastUpdatedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtLastUpdatedDate, DateFormat.ShortTime)
                Else
                    sPublishingInfo += "Last updated by " & sLastUpdatedBy
                End If
            End If
            sPublishingInfo += "</div>"
            bUsePublishingInfo = True
        Else
            If CBool(oXML.DocumentElement.Item("last_updated_date").InnerText) Then
                sPublishingInfo += "<div class=""person_last_updating_and_date"" >"
                sPublishingInfo += "Last updated: " & FormatDateTime(dtLastUpdatedDate, DateFormat.LongDate) & " - " & FormatDateTime(dtLastUpdatedDate, DateFormat.ShortTime)
                sPublishingInfo += "</div>"
                bUsePublishingInfo = True
            End If
        End If

        '~~~~~ Posted By (Person Last Updating) & Display Date
        Dim sTime As String
        If dDisplayDate.Hour = 0 And dDisplayDate.Minute = 0 Then
            sTime = ""
        Else
            sTime = " - " & FormatDateTime(dDisplayDate, DateFormat.ShortTime)
        End If

        If CBool(oXMLParent.DocumentElement.Item("posted_by").InnerText) And _
            bParentIsListing And nParentListingType = 2 Then

            sPublishingInfo += "<div class=""posted_by_and_date"" >"
            If CBool(oXMLParent.DocumentElement.Item("posted_by_full_name").InnerText) Then
                Dim userProfile As ProfileCommon = Profile.GetProfile(sLastUpdatedBy)
                If CBool(oXMLParent.DocumentElement.Item("display_date").InnerText) And _
                    nParentListingType = 2 Then
                    sPublishingInfo += "Posted by " & userProfile.FirstName & " " & userProfile.LastName & " - " & FormatDateTime(dDisplayDate, DateFormat.LongDate) & sTime
                Else
                    sPublishingInfo += "Posted by " & userProfile.FirstName & " " & userProfile.LastName
                End If
            Else
                If CBool(oXMLParent.DocumentElement.Item("display_date").InnerText) And _
                    nParentListingType = 2 Then

                    sPublishingInfo += "Posted by " & sLastUpdatedBy & " - " & FormatDateTime(dDisplayDate, DateFormat.LongDate) & sTime
                Else
                    sPublishingInfo += "Posted by " & sLastUpdatedBy
                End If
            End If
            sPublishingInfo += "</div>"
            bUsePublishingInfo = True
        Else
            If CBool(oXMLParent.DocumentElement.Item("display_date").InnerText) And _
                bParentIsListing And nParentListingType = 2 Then

                sPublishingInfo += "<div class=""posted_by_and_date"" >"
                sPublishingInfo += FormatDateTime(dDisplayDate, DateFormat.LongDate) & sTime
                sPublishingInfo += "</div>"
                bUsePublishingInfo = True
            End If
        End If
        If bUsePublishingInfo Then
            sPublishingInfo = "<div class=""publishing_info"">" & sPublishingInfo & "</div>"
            If Not IsNothing(placeholderPublishingInfo) Then
                placeholderPublishingInfo.Controls.Add(New LiteralControl(sPublishingInfo))
            End If
        End If

        Dim oContentManager As ContentManager = New ContentManager

        '~~~~~ Category Info ~~~~~~
        If CBool(oXMLParent.DocumentElement.Item("category_info").InnerText) And _
            bParentIsListing And bParentListingUseCategories Then

            Dim oReaderCategories As SqlDataReader
            Dim sCategories As String = ""
            oReaderCategories = oContentManager.GetPageCategories(nPageId)
            Dim bIsUncategorized As Boolean = True
            While oReaderCategories.Read()
                bIsUncategorized = False
                If Not sCategories = "" Then sCategories += ", "
                sCategories = sCategories & oReaderCategories("listing_category_name").ToString
            End While
            oReaderCategories.Close()
            If bIsUncategorized Then
                sCategories = GetLocalResourceObject("Uncategorized")
            End If
            If Not IsNothing(placeholderCategoryInfo) Then
                placeholderCategoryInfo.Controls.Add(New LiteralControl("<div class=""category_info"">" & GetLocalResourceObject("Category") & " " & sCategories & "</div>"))
            End If
            oReaderCategories = Nothing
        End If
        '~~~~~ /Category Info ~~~~~~

        '~~~~~ Archives ~~~~~~
        Dim sArchivesStart As String = "<table cellpadding=""0"" cellspacing=""0"" class=""boxArchives"">" & _
            "<tr><td class=""boxHeaderArchives"">" & _
            GetLocalResourceObject("Archives") & _
            "</td></tr>"
        Dim bUseCal As Boolean = False
        Dim bUseMonths As Boolean = False

        'Calendar
        If (CBool(oXML.DocumentElement.Item("calendar").InnerText) And bIsListing And nListingType = 2) Or _
           (CBool(oXMLParent.DocumentElement.Item("calendar").InnerText) And _
            bParentIsListing And nParentListingType = 2) Then

            If Not IsNothing(placeholderArchives) Then
                Dim bIsEntry As Boolean = False
                If CBool(oXMLParent.DocumentElement.Item("month_list").InnerText) And _
                    bParentIsListing And nParentListingType = 2 Then
                    bIsEntry = True
                End If

                Dim oUC As Control = LoadControl("systems/news_calendar.ascx")
                Dim oUCType As Type = oUC.GetType
                oUCType.GetProperty("IsEntry").SetValue(oUC, bIsEntry, Nothing)
                oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                oUCType.GetProperty("RootFile").SetValue(oUC, sRootFile, Nothing)
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("ParentID").SetValue(oUC, nParentId, Nothing)
                oUCType.GetProperty("ParentFileName").SetValue(oUC, sParentFileName, Nothing)
                oUCType.GetProperty("TemplateID").SetValue(oUC, nTemplateId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsPublisher").SetValue(oUC, bIsPublisher, Nothing)
                oUCType.GetProperty("IsSubscriber").SetValue(oUC, bIsSubscriber, Nothing)
                oUCType.GetProperty("IsAuthor").SetValue(oUC, bIsAuthor, Nothing)
                oUCType.GetProperty("IsEditor").SetValue(oUC, bIsEditor, Nothing)
                oUCType.GetProperty("IsResourceManager").SetValue(oUC, bIsResourceManager, Nothing)
                oUCType.GetProperty("IsAdministrator").SetValue(oUC, bIsAdministrator, Nothing)
                oUCType.GetProperty("IsReader").SetValue(oUC, bIsReader, Nothing)
                oUCType.GetProperty("IsOwner").SetValue(oUC, bIsOwner, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                oUCType.GetProperty("UserName").SetValue(oUC, sUserName, Nothing)

                placeholderArchives.Controls.Add(New LiteralControl(sArchivesStart & "<tr><td class=""boxContentArchives"">"))
                placeholderArchives.Controls.Add(oUC)

                bUseCal = True
            End If
        End If

        'Month List
        If (CBool(oXML.DocumentElement.Item("month_list").InnerText) And bIsListing And nListingType = 2) Or _
           (CBool(oXMLParent.DocumentElement.Item("month_list").InnerText) And _
            bParentIsListing And nParentListingType = 2) Then

            If Not IsNothing(placeholderArchives) Then
                Dim bIsEntry As Boolean = False
                If CBool(oXMLParent.DocumentElement.Item("month_list").InnerText) And _
                    bParentIsListing And nParentListingType = 2 Then
                    bIsEntry = True
                End If

                Dim nFirstPostMonth As Integer
                Dim nFirstPostYear As Integer
                Dim oReaderTmp As SqlDataReader
                If bIsEntry Then
                    oReaderTmp = oContentManager.GetFirstPost(nParentId)
                Else
                    oReaderTmp = oContentManager.GetFirstPost(nPageId)
                End If
                While oReaderTmp.Read()
                    nFirstPostMonth = CDate(oReaderTmp("display_date")).Month
                    nFirstPostYear = CDate(oReaderTmp("display_date")).Year
                End While
                oReaderTmp.Close()
                oReaderTmp = Nothing

                Dim i As Integer
                Dim sMonth As String = ""
                Dim nCurrMonth As Integer = Now.Month
                Dim nCurrYear As Integer = Now.Year
                For i = 1 To 12
                    If (nFirstPostMonth = 0) Then Exit For
                    If bIsEntry Then
                        sMonth += "<div><a href=""" & sParentFileName & "?d=" & nCurrYear & "-" & nCurrMonth & """>" & MonthName(nCurrMonth) & " " & nCurrYear & "</a></div>"
                    Else
                        sMonth += "<div><a href=""" & HttpContext.Current.Items("_page") & "?d=" & nCurrYear & "-" & nCurrMonth & """>" & MonthName(nCurrMonth) & " " & nCurrYear & "</a></div>"
                    End If

                    If nFirstPostYear = nCurrYear And nFirstPostMonth = nCurrMonth Then
                        Exit For
                    End If

                    nCurrMonth = nCurrMonth - 1
                    If nCurrMonth = 0 Then
                        nCurrMonth = 12
                        nCurrYear = nCurrYear - 1
                    End If
                Next
                'If Not sMonth = "" Then
                '    sMonth = "<div class=""month_list"">" & sMonth & "</div>"
                'End If


                If bUseCal Then
                    placeholderArchives.Controls.Add(New LiteralControl("</td></tr><tr><td class=""boxMonthList"">"))
                Else
                    placeholderArchives.Controls.Add(New LiteralControl(sArchivesStart & "<tr><td class=""boxMonthList"">"))
                End If
                placeholderArchives.Controls.Add(New LiteralControl(sMonth))

                bUseMonths = True
            End If
        End If

        Dim sArchivesEnd As String = "</td></tr></table>"
        If bUseCal Or bUseMonths Then
            If Not IsNothing(placeholderArchives) Then
                placeholderArchives.Controls.Add(New LiteralControl(sArchivesEnd))
            End If
        End If
        '~~~~~ /Archives ~~~~~~

        '~~~~~ Category List ~~~~~~
        If (CBool(oXML.DocumentElement.Item("category_list").InnerText) And bIsListing And bListingUseCategories) Or _
           (CBool(oXMLParent.DocumentElement.Item("category_list").InnerText) And _
            bParentIsListing And bParentListingUseCategories) Then

            If Not IsNothing(placeholderCategoryList) Then
                Dim bIsEntry As Boolean = False
                If CBool(oXMLParent.DocumentElement.Item("category_list").InnerText) And _
                    bParentIsListing Then
                    bIsEntry = True
                End If

                Dim sHTML As String = ""

                'Dim oReaderCategInfo As SqlDataReader

                'If bIsEntry Then
                '    If bIsReader Then
                '        oReaderCategInfo = oContentManager.GetPageCategoriesPublished(nParentId)
                '    Else
                '        oReaderCategInfo = oContentManager.GetPageCategoriesWorking(nParentId)
                '    End If
                'Else
                '    If bIsReader Then
                '        oReaderCategInfo = oContentManager.GetPageCategoriesPublished(nPageId)
                '    Else
                '        oReaderCategInfo = oContentManager.GetPageCategoriesWorking(nPageId)
                '    End If
                'End If

                'While oReaderCategInfo.Read()
                '    If bIsEntry Then
                '        sHTML += "<div><a href=""" & sParentFileName & "?cat=" & oReaderCategInfo("listing_category_id") & """>" & oReaderCategInfo("listing_category_name") & " (" & oReaderCategInfo("posts") & ")</a></div>"
                '    Else
                '        sHTML += "<div><a href=""" & HttpContext.Current.Items("_page") & "?cat=" & oReaderCategInfo("listing_category_id") & """>" & oReaderCategInfo("listing_category_name") & " (" & oReaderCategInfo("posts") & ")</a></div>"
                '    End If
                'End While
                'oReaderCategInfo.Close()
                'oReaderCategInfo = Nothing

                'sHTML = "<table cellpadding=""0"" cellspacing=""0"" class=""boxCategories"">" & _
                '"<tr><td class=""boxHeaderCategories"">" & _
                'GetLocalResourceObject("Categories") & _
                '"</td></tr>" & _
                '"<tr><td class=""boxContentCategories"">" & sHTML

                'TREE STYLE
                sHTML = "<table cellpadding=""0"" cellspacing=""0"" class=""boxCategories"">" & _
                "<tr><td class=""boxHeaderCategories"">" & _
                GetLocalResourceObject("Categories") & _
                "</td></tr>" & _
                "<tr><td class=""boxContentCategories"">" & sHTML
                placeholderCategoryList.Controls.Add(New LiteralControl(sHTML))

                Dim oUC As Control = LoadControl("systems/news_categories.ascx")
                Dim oUCType As Type = oUC.GetType
                If bIsEntry Then
                    oUCType.GetProperty("NewsPage").SetValue(oUC, sParentFileName, Nothing)
                Else
                    oUCType.GetProperty("NewsPage").SetValue(oUC, HttpContext.Current.Items("_page"), Nothing)
                End If
                If bIsEntry Then
                    oUCType.GetProperty("NewsPageId").SetValue(oUC, nParentId, Nothing)
                Else
                    oUCType.GetProperty("NewsPageId").SetValue(oUC, nPageId, Nothing)
                End If
                oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                oUCType.GetProperty("RootFile").SetValue(oUC, sRootFile, Nothing)
                oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                oUCType.GetProperty("ParentID").SetValue(oUC, nParentId, Nothing)
                oUCType.GetProperty("ParentFileName").SetValue(oUC, sParentFileName, Nothing)
                oUCType.GetProperty("TemplateID").SetValue(oUC, nTemplateId, Nothing)
                oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                oUCType.GetProperty("IsPublisher").SetValue(oUC, bIsPublisher, Nothing)
                oUCType.GetProperty("IsSubscriber").SetValue(oUC, bIsSubscriber, Nothing)
                oUCType.GetProperty("IsAuthor").SetValue(oUC, bIsAuthor, Nothing)
                oUCType.GetProperty("IsEditor").SetValue(oUC, bIsEditor, Nothing)
                oUCType.GetProperty("IsResourceManager").SetValue(oUC, bIsResourceManager, Nothing)
                oUCType.GetProperty("IsAdministrator").SetValue(oUC, bIsAdministrator, Nothing)
                oUCType.GetProperty("IsReader").SetValue(oUC, bIsReader, Nothing)
                oUCType.GetProperty("IsOwner").SetValue(oUC, bIsOwner, Nothing)
                oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                oUCType.GetProperty("UserName").SetValue(oUC, sUserName, Nothing)
                placeholderCategoryList.Controls.Add(oUC)
                '/TREE STYLE

                sHTML = "" 'Added for TREE STYLE

                If lnkEdit.Visible Then
                    If bIsEntry Then
                        Session(nParentId.ToString) = True
                        sHTML += "<div style=""margin-top:20px""><a href=""javascript:modalDialog('" & sAppPath & "dialogs/page_categories.aspx?c=" & sCulture & "&pg=" & nParentId & "',450,400)"">" & GetLocalResourceObject("ManageCategories") & "</a></div>"
                    Else
                        Session(nPageId.ToString) = True
                        sHTML += "<div style=""margin-top:20px""><a href=""javascript:modalDialog('" & sAppPath & "dialogs/page_categories.aspx?c=" & sCulture & "&pg=" & nPageId & "',450,400)"">" & GetLocalResourceObject("ManageCategories") & "</a></div>"
                    End If
                End If

                sHTML += "</td></tr></table>"
                placeholderCategoryList.Controls.Add(New LiteralControl(sHTML))
            End If
        End If
        '~~~~~ /Category List ~~~~~~

        '~~~~~ Subscribe ~~~~~~
        Dim sSubscribe As String = ""
        If (CBool(oXML.DocumentElement.Item("subscribe").InnerText) And bIsListing And nListingType = 2) Or _
            (CBool(oXMLParent.DocumentElement.Item("subscribe").InnerText) And _
            bParentIsListing And nParentListingType = 2) Then

            If Not IsNothing(placeholderSubscribe) Then
                Dim bIsEntry As Boolean = False
                If CBool(oXMLParent.DocumentElement.Item("subscribe").InnerText) And _
                    bParentIsListing And nParentListingType = 2 Then
                    bIsEntry = True
                End If

                If bIsEntry Then
                    sSubscribe = "<a href=""" & sAppPath & "systems/rss.aspx?pg=" & nParentId & "&c=" & sCulture & """ target=""_blank""><img src=""" & sAppPath & "systems/images/rss.gif"" style=""border:none"" alt=""""/></a>&nbsp;"
                Else
                    sSubscribe = "<a href=""" & sAppPath & "systems/rss.aspx?pg=" & nPageId & "&c=" & sCulture & """ target=""_blank""><img src=""" & sAppPath & "systems/images/rss.gif"" style=""border:none"" alt=""""/></a>&nbsp;"
                End If

            End If
        End If

        Dim sPodcast As String = ""
        Dim bUsePodcast As Boolean = False
        If Not IsNothing(oXML.GetElementsByTagName("subscribe_podcast")(0)) Then
            bUsePodcast = CBool(oXML.DocumentElement.Item("subscribe_podcast").InnerText)
        End If
        Dim bParentUsePodcast As Boolean
        If Not IsNothing(oXMLParent.GetElementsByTagName("subscribe_podcast")(0)) Then
            bParentUsePodcast = CBool(oXMLParent.DocumentElement.Item("subscribe_podcast").InnerText)
        End If
        If (bUsePodcast And bIsListing) Or _
            (bParentUsePodcast And bParentIsListing) Then

            If Not IsNothing(placeholderSubscribe) Then
                Dim bIsEntry As Boolean = False
                If bParentUsePodcast And _
                    bParentIsListing Then
                    bIsEntry = True
                End If

                If bIsEntry Then
                    sPodcast = "<a href=""" & sAppPath & "systems/listing_podcast.aspx?pg=" & nParentId & "&c=" & sCulture & """ target=""_blank""><img src=""" & sAppPath & "systems/images/pod.gif"" style=""border:none"" alt=""""/></a>&nbsp;"
                Else
                    sPodcast = "<a href=""" & sAppPath & "systems/listing_podcast.aspx?pg=" & nPageId & "&c=" & sCulture & """ target=""_blank""><img src=""" & sAppPath & "systems/images/pod.gif"" style=""border:none"" alt=""""/></a>&nbsp;"
                End If

            End If

        End If

        If sSubscribe <> "" Or sPodcast <> "" Then
            Dim sHTML As String = "<table cellpadding=""0"" cellspacing=""0"" class=""boxNewsFeedSubscribe"">" & _
                "<tr><td class=""boxHeaderNewsFeedSubscribe"">" & _
                GetLocalResourceObject("Subscribe") & _
                "</td></tr>" & _
                "<tr><td class=""boxContentNewsFeedSubscribe"">" & _
                sSubscribe & sPodcast & _
                "</td></tr></table>"

            placeholderSubscribe.Controls.Add(New LiteralControl(sHTML))
        End If

        '~~~~~ /Subscribe ~~~~~~

        '~~~~~ Shop Config ~~~~~~
        Dim sCurrSymbol As String = ""
        Dim sCurrSeparator As String = ""
        Dim sPaypalCartPage As String = ""
        Dim sOrderNowTemplate As String = ""
        If ConfigurationManager.AppSettings("Shop") = "yes" Then
            If Not IsNothing(placeholderOrderNow) Or Not IsNothing(placeholderCartInfo) Then
                oCommand = New SqlCommand("SELECT * FROM config_shop WHERE root_id=@root_id", oConn)
                oCommand.CommandType = CommandType.Text
                oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
                oDataReader = oCommand.ExecuteReader()
                While oDataReader.Read
                    sCurrSymbol = oDataReader("currency_symbol").ToString
                    sCurrSeparator = oDataReader("currency_separator").ToString
                    If sCurrSymbol.Length > 1 Then
                        sCurrSymbol = sCurrSymbol.Substring(0, 1).ToUpper() & sCurrSymbol.Substring(1).ToString
                    End If
                    sCurrSymbol = sCurrSymbol & sCurrSeparator
                    If nRootId = 1 Then
                        sPaypalCartPage = "shop_pcart.aspx"
                    Else
                        sPaypalCartPage = "shop_pcart_" & nRootId & ".aspx"
                    End If
                    sOrderNowTemplate = oDataReader("order_now_template").ToString
                End While
                oDataReader.Close()
            End If
        End If
        '~~~~~ /Shop Config ~~~~~~

        '~~~~~ Order Now ~~~~~~
        If ConfigurationManager.AppSettings("Shop") = "yes" Then
            If Not IsNothing(placeholderOrderNow) Then
                If Not placeholderOrderNow.Visible = False And Not nPrice = 0 Then

                    bForceShowSummaryEditor = True

                    Dim nCurrentPrice As Decimal
                    If nSalePrice > 0 Then
                        nCurrentPrice = nSalePrice
                    ElseIf nDiscountPercentage > 0 Then
                        nCurrentPrice = nPrice - (nPrice * (nDiscountPercentage / 100))
                    Else
                        nCurrentPrice = nPrice
                    End If

                    Dim sOrderNow As String = sOrderNowTemplate
                    sOrderNow = sOrderNow.Replace("[%TITLE%]", sTitle)
                    sOrderNow = sOrderNow.Replace("[%SUMMARY%]", sSummary)
                    sOrderNow = sOrderNow.Replace("[%PRICE%]", sCurrSymbol & FormatNumber(nPrice, 2))
                    sOrderNow = sOrderNow.Replace("[%CURRENT_PRICE%]", sCurrSymbol & FormatNumber(nCurrentPrice, 2))
                    If nCurrentPrice = nPrice Then
                        sOrderNow = sOrderNow.Replace("[%HIDE_PRICE%]", "display:none;")
                    End If
                    sOrderNow = sOrderNow.Replace("[%PAYPAL_ADD_TO_CART_URL%]", sAppPath & sPaypalCartPage & "?item=" & nPageId)
                    placeholderOrderNow.Controls.Add(New LiteralControl(sOrderNow))
                End If
            End If
        End If
        '~~~~~ /Order Now ~~~~~~

        '~~~~~ Cart Info ~~~~~~
        If ConfigurationManager.AppSettings("Shop") = "yes" Then
            If Not IsNothing(placeholderCartInfo) Then
                If Not placeholderCartInfo.Visible = False Then
                    Dim sCartInfo As String
                    sCartInfo = "<img src=""" & sAppPath & "systems/images/add_to_cart.gif"" /> <a class=""cart"" href=""" & sAppPath & sPaypalCartPage & """>" & GetLocalResourceObject("ViewCart") & "</a>"
                    placeholderCartInfo.Controls.Add(New LiteralControl(sCartInfo))
                End If
            End If
        End If
        '~~~~~ /Cart Info ~~~~~~

        '~~~~~ Page Tools ~~~~~~
        If Not IsNothing(placeholderPageTools) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
            If Not placeholderPageTools.Visible = False Then
                Dim sPageTools As String = ""

                'Print this page
                Dim sPrintLink As String
                If sRawUrl.Contains("?") Then
                    sPrintLink = Request.RawUrl.ToString & "&print=Y"
                Else
                    sPrintLink = Request.RawUrl.ToString & "?print=Y"
                End If
                sPageTools += "<a href=""" & sPrintLink & """ target=""_blank""><img src=""" & sAppPath & "systems/images/pg_print.gif"" style=""border:none"" alt=""" & GetLocalResourceObject("Print this Page") & """ /></a>"

                'Tell A Friend
                If Not nChannelPermission = 3 Then
                    sPageTools += " <a href=""" & sLinkTellAFriend & "?id=" & nPageId & """ ><img src=""" & sAppPath & "systems/images/pg_tell.gif"" style=""border:none"" alt=""" & GetLocalResourceObject("Tell a Friend") & """ /></a>"
                End If

                'Bookmark
                Dim sBookmark As String = ""
                sBookmark += "<script language=""javascript"" type=""text/javascript"">" & vbCrLf & _
                "<!--" & vbCrLf & _
                "function bookmarkThis()" & vbCrLf & _
                "   {" & vbCrLf & _
                "   var url = """ & sRawUrl & """;" & vbCrLf & _
                "   var title = """ & sTitle & """;" & vbCrLf & _
                "   if (document.all) " & vbCrLf & _
                "       {" & vbCrLf & _
                "       window.external.AddFavorite(location.href,title) " & vbCrLf & _
                "       } " & vbCrLf & _
                "   else if (window.sidebar) " & vbCrLf & _
                "       { " & vbCrLf & _
                "       window.sidebar.addPanel(title, location.href, """") " & vbCrLf & _
                "       } " & vbCrLf & _
                "   else " & vbCrLf & _
                "       { " & vbCrLf & _
                "       //alert(""Sorry! Your browser doesn't support this function."") " & vbCrLf & _
                "       } " & vbCrLf & _
                "   }" & vbCrLf & _
                "// -->" & vbCrLf & _
                "</script>"
                sPageTools += sBookmark & " <a href=""javascript:bookmarkThis()""><img src=""" & sAppPath & "systems/images/pg_bookmark.gif"" style=""border:none"" alt=""" & GetLocalResourceObject("Add to Favorites") & """ /></a>"

                ''Site Rss
                'sPageTools += " <a href=""" & sLinkSiteRss & """ ><img src=""" & sAppPath & "systems/images/pg_rss.gif"" style=""border:none"" alt=""" & GetLocalResourceObject("Site Rss") & """ /></a>"

                placeholderPageTools.Controls.Add(New LiteralControl(sPageTools))
            End If
        End If
        If Not IsNothing(placeholderSiteRss) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
            If Not placeholderSiteRss.Visible = False Then
                Dim sSiteRss As String = " <a href=""" & sLinkSiteRss & """ ><img src=""" & sAppPath & "systems/images/pg_rss.gif"" style=""border:none"" alt=""" & GetLocalResourceObject("Site Rss") & """ /></a>"
                placeholderSiteRss.Controls.Add(New LiteralControl(sSiteRss))
            End If
        End If
        '~~~~~ /Page Tools ~~~~~~


        '~~~~~ File Download ~~~~~~
        Dim sFileDownloadTemplate As String = ""
        Dim sFileDownloadURL As String = ""
        If CBool(oXML.DocumentElement.Item("file_download").InnerText) And Not sFileDownload = "" Then

            sFileDownloadTemplate = _
                "<table cellpadding=""5"" cellspacing=""0"" border=""0"">" & _
                "<tr>" & _
                "<td style=""padding-left:0px"">" & _
                "	<img src=""[%FILE_DOWNLOAD_ICON%]"" />" & _
                "</td>" & _
                "<td style=""padding-left:5px;padding-right:15px"">" & _
                "	<b>Download</b>" & _
                "	<br /><br />" & _
                "	<a href=""[%FILE_DOWNLOAD_URL%]"">[%FILE_DOWNLOAD%]</a>" & _
                "	([%FILE_DOWNLOAD_SIZE%])" & _
                "</td>" & _
                "</tr>" & _
                "</table>"

            sFileDownloadTemplate = sFileDownloadTemplate.Replace("[%FILE_DOWNLOAD%]", sFileDownload.Substring(sFileDownload.IndexOf("_") + 1))

            Dim sIcon As String
            Dim sFileDownloadExt As String = sFileDownload.Substring(sFileDownload.LastIndexOf(".") + 1).ToLower
            If sFileDownloadExt = "bmp" Or _
                sFileDownloadExt = "gif" Or _
                sFileDownloadExt = "jpg" Or _
                sFileDownloadExt = "jpeg" Or _
                sFileDownloadExt = "png" Then
                sIcon = "systems/images/files/ico_image.gif"
            ElseIf sFileDownloadExt = "mov" Or _
                sFileDownloadExt = "mpg" Or _
                sFileDownloadExt = "mpeg" Or _
                sFileDownloadExt = "wmv" Or _
                sFileDownloadExt = "avi" Then
                sIcon = "systems/images/files/ico_video.gif"
            ElseIf sFileDownloadExt = "mp3" Or _
                sFileDownloadExt = "wav" Or _
                sFileDownloadExt = "mid" Or _
                sFileDownloadExt = "wma" Then
                sIcon = "systems/images/files/ico_audio.gif"
            ElseIf sFileDownloadExt = "exe" Then
                sIcon = "systems/images/files/ico_exe.gif"
            ElseIf sFileDownloadExt = "doc" Then
                sIcon = "systems/images/files/ico_doc.gif"
            ElseIf sFileDownloadExt = "mdb" Then
                sIcon = "systems/images/files/ico_mdb.gif"
            ElseIf sFileDownloadExt = "ppt" Then
                sIcon = "systems/images/files/ico_ppt.gif"
            ElseIf sFileDownloadExt = "xls" Then
                sIcon = "systems/images/files/ico_xls.gif"
            ElseIf sFileDownloadExt = "pdf" Then
                sIcon = "systems/images/files/ico_pdf.gif"
            ElseIf sFileDownloadExt = "swf" Or _
                sFileDownloadExt = "flv" Then
                sIcon = "systems/images/files/ico_swf.gif"
            ElseIf sFileDownloadExt = "txt" Then
                sIcon = "systems/images/files/ico_txt.gif"
            ElseIf sFileDownloadExt = "zip" Then
                sIcon = "systems/images/files/ico_zip.gif"
            Else
                sIcon = "systems/images/files/ico_txt.gif"
            End If
            sFileDownloadTemplate = sFileDownloadTemplate.Replace("[%FILE_DOWNLOAD_ICON%]", sIcon)

            If nFileSize < 1024 Then
                sFileDownloadTemplate = sFileDownloadTemplate.Replace("[%FILE_DOWNLOAD_SIZE%]", nFileSize & " bytes")
            Else
                sFileDownloadTemplate = sFileDownloadTemplate.Replace("[%FILE_DOWNLOAD_SIZE%]", FormatNumber((nFileSize / 1024), 0) & " KB")
            End If

            sFileDownloadTemplate = sFileDownloadTemplate.Replace("[%FILE_DOWNLOAD_URL%]", "systems/file_download.aspx?pg=" & nPageId & "&ver=" & nVersion)
            sFileDownloadURL = "systems/file_download.aspx?pg=" & nPageId & "&ver=" & nVersion

            If nFileSize = 0 Then 'jaga2 saja
                sFileDownloadTemplate = ""
            End If

            If Not IsNothing(placeholderFileDownload) Then
                If Not sContentBody.Contains("[%FILE_DOWNLOAD%]") And Not sContentBody.Contains("[%FILE_DOWNLOAD_URL%]") Then
                    placeholderFileDownload.Controls.Add(New LiteralControl(sFileDownloadTemplate))
                End If
            End If

        End If
        '~~~~~ /File Download ~~~~~~

        '~~~~~ File View ~~~~~~
        Dim sFileViewTemplate As String = ""
        Dim sFileViewURL As String = ""
        If CBool(oXML.DocumentElement.Item("file_view").InnerText) And Not sFileView = "" Then

            Dim sFileViewExt As String = sFileView.Substring(sFileView.LastIndexOf(".") + 1).ToLower

            If ConfigurationManager.AppSettings("UseSecureFileStorageForViewing") = "yes" Then
                'Access Using ASPX

                If sFileViewExt = "flv" Then
                    'Requires IIS setting
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                        "<p id=""player1"">" & vbCrLf & _
                        "<a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player." & _
                        "</p>" & vbCrLf & _
                        "<script type=""text/javascript"">" & vbCrLf & _
                        "var s1 = new SWFObject(""" & sAppPath & "systems/media/flvplayer.swf"",""single"",""320"",""240"",""7"");" & vbCrLf & _
                        "s1.addParam(""allowfullscreen"",""true"");" & vbCrLf & _
                        "s1.addVariable(""file"",""../../dynamic-" & nPageId & "-" & nVersion & "-" & ".flv"");" & vbCrLf & _
                        "s1.addVariable(""image"",""" & sAppPath & "systems/images/blank.gif"");" & vbCrLf & _
                        "s1.addVariable(""width"",""275"");" & vbCrLf & _
                        "s1.addVariable(""height"",""210"");" & vbCrLf & _
                        "s1.write(""player1"");" & vbCrLf & _
                        "</script>" 'pakai ../../ krn swf diletakkan di systems/media/
                    sFileViewURL = "../../dynamic-" & nPageId & "-" & nVersion & "-" & ".flv"
                ElseIf sFileViewExt = "mp3" Then
                    'Requires IIS setting
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                            "<p id=""player3""><a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player.</p>" & vbCrLf & _
                            "<script type=""text/javascript"">" & vbCrLf & _
                            "var s3 = new SWFObject(""" & sAppPath & "systems/media/mp3player.swf"", ""line"", ""240"", ""20"", ""7"");" & vbCrLf & _
                            "s3.addVariable(""file"",""dynamic-" & nPageId & "-" & nVersion & "-" & ".mp3"");" & vbCrLf & _
                            "s3.addVariable(""repeat"",""true"");" & vbCrLf & _
                            "s3.addVariable(""showdigits"",""false"");" & vbCrLf & _
                            "s3.addVariable(""width"",""240"");" & vbCrLf & _
                            "s3.addVariable(""height"",""20"");" & vbCrLf & _
                            "s3.write(""player3"");" & vbCrLf & _
                            "</script>"
                    sFileViewURL = "dynamic-" & nPageId & "-" & nVersion & "-" & ".mp3"
                ElseIf sFileViewExt = "jpg" Or sFileViewExt = "jpeg" Or sFileViewExt = "gif" Or sFileViewExt = "png" Or sFileViewExt = "bmp" Then
                    Dim sBigImage As String = Server.UrlEncode("systems/file_view.aspx?pg=" & nPageId & "&ver=" & nVersion)
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                        "<p id=""player1"">" & vbCrLf & _
                        "<a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player." & _
                        "</p>" & vbCrLf & _
                        "<script type=""text/javascript"">" & vbCrLf & _
                        "var s1 = new SWFObject(""" & sAppPath & "systems/media/imgviewer.swf?imageFileName=" & sBigImage & "&Mode=3"",""single"",""470"",""350"",""7"");" & vbCrLf & _
                        "s1.addParam(""allowfullscreen"",""true"");" & vbCrLf & _
                        "s1.addParam(""src"",""" & sAppPath & "systems/media/imgviewer.swf?imageFileName=" & sBigImage & "&mode=3"");" & vbCrLf & _
                        "s1.write(""player1"");" & vbCrLf & _
                        "</script>"
                    sFileViewURL = "systems/file_view.aspx?pg=" & nPageId & "&ver=" & nVersion
                Else
                    sFileViewURL = "systems/file_view.aspx?pg=" & nPageId & "&ver=" & nVersion
                End If

            Else
                'Access File Directly

                If sFileViewExt = "flv" Then
                    Dim sBigFlv As String = sAppPath & "resources/internal/file_views/" & nPageId & "/" & sFileView
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                        "<p id=""player1"">" & vbCrLf & _
                        "<a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player." & _
                        "</p>" & vbCrLf & _
                        "<script type=""text/javascript"">" & vbCrLf & _
                        "var s1 = new SWFObject(""" & sAppPath & "systems/media/flvplayer.swf"",""single"",""320"",""240"",""7"");" & vbCrLf & _
                        "s1.addParam(""allowfullscreen"",""true"");" & vbCrLf & _
                        "s1.addVariable(""file"",""" & sBigFlv & """);" & vbCrLf & _
                        "s1.addVariable(""image"",""" & sAppPath & "systems/images/blank.gif"");" & vbCrLf & _
                        "s1.addVariable(""width"",""275"");" & vbCrLf & _
                        "s1.addVariable(""height"",""210"");" & vbCrLf & _
                        "s1.write(""player1"");" & vbCrLf & _
                        "</script>" 'pakai ../../ krn swf diletakkan di systems/media/
                    sFileViewURL = sBigFlv
                ElseIf sFileViewExt = "mp3" Then
                    Dim sBigMp3 As String = sAppPath & "resources/internal/file_views/" & nPageId & "/" & sFileView
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                            "<p id=""player3""><a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player.</p>" & vbCrLf & _
                            "<script type=""text/javascript"">" & vbCrLf & _
                            "var s3 = new SWFObject(""" & sAppPath & "systems/media/mp3player.swf"", ""line"", ""240"", ""20"", ""7"");" & vbCrLf & _
                            "s3.addVariable(""file"",""" & sBigMp3 & """);" & vbCrLf & _
                            "s3.addVariable(""repeat"",""true"");" & vbCrLf & _
                            "s3.addVariable(""showdigits"",""false"");" & vbCrLf & _
                            "s3.addVariable(""width"",""240"");" & vbCrLf & _
                            "s3.addVariable(""height"",""20"");" & vbCrLf & _
                            "s3.write(""player3"");" & vbCrLf & _
                            "</script>"
                    sFileViewURL = sBigMp3
                ElseIf sFileViewExt = "jpg" Or sFileViewExt = "jpeg" Or sFileViewExt = "gif" Or sFileViewExt = "png" Or sFileViewExt = "bmp" Then
                    Dim sBigImage As String = sAppPath & "resources/internal/file_views/" & nPageId & "/" & sFileView
                    sFileViewTemplate = "<script type=""text/javascript"" src=""" & sAppPath & "systems/media/swfobject.js""></script>" & vbCrLf & _
                        "<p id=""player1"">" & vbCrLf & _
                        "<a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player." & _
                        "</p>" & vbCrLf & _
                        "<script type=""text/javascript"">" & vbCrLf & _
                        "var s1 = new SWFObject(""" & sAppPath & "systems/media/imgviewer.swf?imageFileName=" & sBigImage & "&Mode=3"",""single"",""470"",""350"",""7"");" & vbCrLf & _
                        "s1.addParam(""allowfullscreen"",""true"");" & vbCrLf & _
                        "s1.addParam(""src"",""" & sAppPath & "systems/media/imgviewer.swf?imageFileName=" & sBigImage & "&mode=3"");" & vbCrLf & _
                        "s1.write(""player1"");" & vbCrLf & _
                        "</script>"
                    sFileViewURL = sBigImage
                Else
                    sFileViewURL = sAppPath & "resources/internal/file_views/" & nPageId & "/" & sFileView
                End If

            End If

            If Not IsNothing(placeholderFileView) Then
                If Not sContentBody.Contains("[%FILE_VIEW%]") And Not sContentBody.Contains("[%FILE_VIEW_URL%]") Then
                    placeholderFileView.Controls.Add(New LiteralControl(sFileViewTemplate))
                End If
            End If

        End If
        '~~~~~ /File View ~~~~~~

        '~~~~~ Statistic Info ~~~~~
        Dim bStatHorizontal As Boolean = False
        Dim bStatVertical As Boolean = False
        If CBool(oXML.DocumentElement.Item("statistic_info").InnerText) Then
            If Not IsNothing(placeholderStatPageViews) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                If Not placeholderStatPageViews.Visible = False Then
                    bStatHorizontal = True
                End If
            End If
            If Not IsNothing(placeholderStatPageViews_Vertical) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                If Not placeholderStatPageViews_Vertical.Visible = False Then
                    bStatVertical = True
                End If
            End If

            If Not IsNothing(placeholderStatPageViews_Private) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                If Not placeholderStatPageViews_Private.Visible = False Then
                    If bIsAuthor Or bIsAdministrator Then
                        bStatHorizontal = True
                    End If
                End If
            End If
            If Not IsNothing(placeholderStatPageViews_Vertical_Private) And Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                If Not placeholderStatPageViews_Vertical_Private.Visible = False Then
                    If bIsAuthor Or bIsAdministrator Then
                        bStatVertical = True
                    End If
                End If
            End If
        End If

        If bStatHorizontal Or bStatVertical Then

            Dim nThisMonth As Integer = 0
            Dim nLastMonth As Integer = 0
            Dim nOverall As Integer = 0
            oCommand = New SqlCommand("SET LANGUAGE us_english select sum(count) as tot, 'this' as mo from pages_views_count_daily where month(date_stamp) = @thismonth and year(date_stamp)=@year1 and page_id=@page_id " & _
                "union " & _
                "select sum(count) as tot, 'last' as mo from pages_views_count_daily where month(date_stamp) = @lastmonth and year(date_stamp)=@year2 and page_id=@page_id " & _
                "union " & _
                "select total as tot, 'overall' as mo from pages_views_count where page_id=@page_id", oConn)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@thismonth", SqlDbType.Int).Value = Now.Month
            oCommand.Parameters.Add("@year1", SqlDbType.Int).Value = Now.Year
            If Now.Month = 1 Then
                oCommand.Parameters.Add("@lastmonth", SqlDbType.Int).Value = 12
                oCommand.Parameters.Add("@year2", SqlDbType.Int).Value = Now.Year - 1
            Else
                oCommand.Parameters.Add("@lastmonth", SqlDbType.Int).Value = Now.Month - 1
                oCommand.Parameters.Add("@year2", SqlDbType.Int).Value = Now.Year
            End If
            oDataReader = oCommand.ExecuteReader()
            While oDataReader.Read
                If oDataReader("mo").ToString = "this" Then 'this month
                    If Not IsDBNull(oDataReader("tot")) Then
                        nThisMonth = CInt(oDataReader("tot"))
                    End If
                End If
                If oDataReader("mo").ToString = "last" Then 'last month
                    If Not IsDBNull(oDataReader("tot")) Then
                        nLastMonth = CInt(oDataReader("tot"))
                    End If
                End If
                If oDataReader("mo").ToString = "overall" Then 'overall
                    If Not IsDBNull(oDataReader("tot")) Then
                        nOverall = CInt(oDataReader("tot"))
                    End If
                End If
            End While
            oDataReader.Close()

            Dim dStatDate As Date
            Dim nStatCount As Integer
            Dim nC(7) As Integer
            Dim dD(7) As Date
            oCommand = New SqlCommand("SET LANGUAGE us_english SELECT date_stamp,count FROM pages_views_count_daily WHERE page_id=@page_id and date_stamp>=@start order by date_stamp", oConn)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@start", SqlDbType.DateTime).Value = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(6))
            oDataReader = oCommand.ExecuteReader()
            Dim nTop As Integer = 0
            Dim n As Integer = 0
            Dim nToday As Integer
            Dim nYesterday As Integer
            While oDataReader.Read
                dStatDate = CDate(oDataReader("date_stamp"))
                nStatCount = CInt(oDataReader("count"))
                If nStatCount >= nTop Then
                    nTop = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(6)) Then
                    nC(6) = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(5)) Then
                    nC(5) = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(4)) Then
                    nC(4) = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(3)) Then
                    nC(3) = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(2)) Then
                    nC(2) = nStatCount
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(1)) Then
                    nC(1) = nStatCount
                    nYesterday = nC(1)
                End If
                If dStatDate = New Date(Now.Year, Now.Month, Now.Day) Then
                    nC(0) = nStatCount
                    nToday = nC(0)
                End If
                n = n + 1
            End While
            oDataReader.Close()

            For n = 0 To 6
                dD(n) = New Date(Now.Year, Now.Month, Now.Day).Subtract(System.TimeSpan.FromDays(n))
            Next

            Dim sStatistic As String = ""
            Dim sChart As String = ""
            Dim sBar As String = ""
            Dim sDate As String = ""
            Dim sAlt As String = ""

            Dim sScale As String
            Dim nTopRange As Integer
            nTopRange = nTop + (10 - nTop.ToString.Substring(nTop.ToString.Length - 1))
            sScale = "<div style=""position:relative;top:-3px;text-align:right;line-height:10px"">" & nTopRange & "</div>" & _
                "<div style=""position:relative;top:2px;text-align:right;line-height:10px"">" & (nTopRange / 2) & "</div>" & _
                "<div style=""position:relative;top:7px;text-align:right;line-height:10px"">0</div>"

            For n = 0 To 6
                If n = 0 Then
                    sAlt = nC(n) & " " & GetLocalResourceObject("times_today")
                ElseIf n = 1 Then
                    sAlt = nC(n) & " " & GetLocalResourceObject("times_yesterday")
                Else
                    sAlt = nC(n) & " " & GetLocalResourceObject("times") & " (" & MonthName(dD(n).Month, True) & " " & dD(n).Day & ")"
                End If

                If nC(n) = 0 Then
                    sBar = "<div style=""height:30px;width:20px;cursor:default;"">&nbsp;</div>"
                Else
                    sBar = "<div class=""barStat"" style=""cursor:default;height:" & (nC(n) / nTop) * 30 & "px;width:20px;""></div>"
                End If
                sChart = "<td class=""barStatArea"" valign=""bottom"" style=""height:30px;font-size:8px;text-align:center"" title=""" & sAlt & """>" & _
                    sBar & "</td>" & sChart

                If n = 1 Then
                    sDate = "<td colspan=""2"" style=""font-size:9px;font-family:arial;text-align:right;padding-right:0px;"">" & MonthName(dD(0).Month, True) & " " & dD(0).Day & "</td>" & sDate
                ElseIf n = 2 Or n = 3 Or n = 4 Then
                    sDate = "<td style=""font-size:6pt;"">&nbsp;</td>" & sDate
                ElseIf n = 6 Then
                    sDate = "<td colspan=""2"" style=""font-size:9px;font-family:arial;text-align:left;padding-left:0px;"">" & MonthName(dD(n).Month, True) & " " & dD(n).Day & "</td>" & sDate
                End If
            Next

            If bStatHorizontal Then
                sStatistic = "<table cellpadding=""0"" cellspacing=""0"">" & _
                    "<tr>" & _
                        "<td></td>" & _
                        "<td colspan=""7"" class=""boxStatHeader"" style=""padding-bottom:2px;padding-top:2px;font-weight:bold;font-size:9px;font-family:verdana;text-align:center;line-height:9px;color:white"">" & GetLocalResourceObject("page_views") & "</td>" & _
                        "<td rowspan=""2"" class=""boxStatDetailsHorizontal"">" & _
                            "<div style=""font-size:7pt;font-family:verdana;padding:1px;padding-right:7px;padding-left:7px"">" & _
                            nToday & " " & GetLocalResourceObject("times_today") & ", " & nYesterday & " " & GetLocalResourceObject("times_yesterday") & "<br />" & _
                            nThisMonth & " " & GetLocalResourceObject("times_thismonth") & ", " & nLastMonth & " " & GetLocalResourceObject("times_lastmonth") & "<br /><b>" & GetLocalResourceObject("Overall") & " " & nOverall & " " & GetLocalResourceObject("times") & "</b>" & _
                            "</div>" & _
                        "</td>" & _
                    "</tr>" & _
                    "<tr>" & _
                        "<td valign=""top"" rowspan=""2"" style=""font-size:6pt;padding-right:3px;padding-top:0px;"">" & sScale & "</td>" & _
                        sChart & _
                    "</tr>" & _
                    "<tr>" & _
                        sDate & _
                        "<td></td>" & _
                    "</tr>" & _
                    "</table>"

                If Not IsNothing(placeholderStatPageViews) Then
                    placeholderStatPageViews.Controls.Add(New LiteralControl("<div class=""boxStatHorizontal"">" & sStatistic & "</div>"))
                End If
                If Not IsNothing(placeholderStatPageViews_Private) Then
                    placeholderStatPageViews_Private.Controls.Add(New LiteralControl("<div class=""boxStatHorizontal"">" & sStatistic & "</div>"))
                End If
            End If

            If bStatVertical Then
                sStatistic = "<table cellpadding=""0"" cellspacing=""0"">" & _
                    "<tr>" & _
                        "<td></td>" & _
                        "<td colspan=""7"" class=""boxStatHeader"" style=""padding-bottom:2px;padding-top:2px;font-weight:bold;font-size:9px;font-family:verdana;text-align:center;line-height:9px;color:white"">" & GetLocalResourceObject("page_views") & "</td>" & _
                    "</tr>" & _
                    "<tr>" & _
                        "<td valign=""top"" rowspan=""2"" style=""font-size:6pt;padding-right:3px;padding-top:0px;"">" & sScale & "</td>" & _
                        sChart & _
                    "</tr>" & _
                    "<tr>" & _
                        sDate & _
                     "</tr>" & _
                    "</tr>" & _
                        "<td></td>" & _
                        "<td colspan=""7"" class=""boxStatDetailsVertical"">" & _
                            "<div style=""font-size:7pt;font-family:verdana;padding:1px;padding-right:7px;"">" & _
                            nToday & " " & GetLocalResourceObject("times_today") & "<br />" & nYesterday & " " & GetLocalResourceObject("times_yesterday") & "<br />" & nThisMonth & " " & GetLocalResourceObject("times_thismonth") & "<br />" & nLastMonth & " " & GetLocalResourceObject("times_lastmonth") & "<br /><b>" & GetLocalResourceObject("Overall") & " " & nOverall & " " & GetLocalResourceObject("times") & "</b>" & _
                            "</div>" & _
                        "</td>" & _
                    "</tr>" & _
                    "</table>"

                If Not IsNothing(placeholderStatPageViews_Vertical) Then
                    placeholderStatPageViews_Vertical.Controls.Add(New LiteralControl("<div class=""boxStatVertical"">" & sStatistic & "</div>"))
                End If
                If Not IsNothing(placeholderStatPageViews_Vertical_Private) Then
                    placeholderStatPageViews_Vertical_Private.Controls.Add(New LiteralControl("<div class=""boxStatVertical"">" & sStatistic & "</div>"))
                End If
            End If

        End If
        '~~~~~ /Statistic Info ~~~~~

        '~~~~ Title ~~~~
        'Database Stored Title Localization
        If bIsSystem Then
            If Not GetLocalResourceObject(sTitle) = "" Then
                sTitle = GetLocalResourceObject(sTitle)
            End If
        End If
        litTitle.Text = "<div class=""title"">" & sTitle & "</div>"
        If sMetaTitle <> "" Then
            Page.Master.Page.Title = Page.Master.Page.Title & sMetaTitle
        Else
            Page.Master.Page.Title = Page.Master.Page.Title & sTitle
        End If
        '~~~~ /Title ~~~~

        '~~~~~ HEAD Content ~~~~~ 
        Dim sHeadContent As String = ""
        If sMetaDescription <> "" Then
            sHeadContent = "<meta name=""description"" content=""" & sMetaDescription & """ />"
        End If
        If sMetaKeywords <> "" Then
            sHeadContent = sHeadContent & "<meta name=""keywords"" content=""" & sMetaKeywords & """ />"
        End If
        If bLinksCrawled Then
            If bPageIndexed Then
                sHeadContent = sHeadContent & "<meta name=""ROBOTS"" content=""FOLLOW, INDEX"" />"
            Else
                sHeadContent = sHeadContent & "<meta name=""ROBOTS"" content=""FOLLOW, NOINDEX"" />"
            End If
        Else
            If bPageIndexed Then
                sHeadContent = sHeadContent & "<meta name=""ROBOTS"" content=""INDEX, NOFOLLOW"" />"
            Else
                sHeadContent = sHeadContent & "<meta name=""ROBOTS"" content=""NOFOLLOW, NOINDEX"" />"
            End If
        End If
        If Page.Master.Page.Header.Controls.Count >= 2 Then
            'place meta keys/desc after base & title (in the head)
            Page.Master.Page.Header.Controls.AddAt(2, New LiteralControl(sHeadContent))
        Else
            'jaga2 saja.
            Page.Master.Page.Header.Controls.Add(New LiteralControl(sHeadContent))
        End If

        'Float scripts
        Page.Master.Page.Header.Controls.Add(New LiteralControl("<script language=""javascript"" type=""text/javascript"" src=""systems/float/float.js""></script>"))
        '~~~~~ /HEAD Content ~~~~~ 

        '~~~~ Channel ~~~~
        lblChannelName.Text = sChannelName
        '~~~~ /Channel ~~~~

        '~~~~ Page Elements ~~~~
        If lnkEdit.Visible Then
            Session(nPageId.ToString) = True

            If bIsListing Then
                If bListingUseCategories Then
                    If nListingType = 1 Then
                        If nListingProperty = 1 Or nListingProperty = 3 Then
                            'manual order
                            lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',365,534);return false;"
                        Else
                            lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',365,696);return false;"
                        End If
                    Else 'uses date
                        lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',345,622);return false;"
                    End If
                Else
                    If nListingType = 1 Then
                        If nListingProperty = 1 Or nListingProperty = 3 Then
                            'manual order
                            lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',365,442);return false;"
                        Else
                            lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',365,602);return false;"
                        End If
                    Else 'uses date
                        lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',345,580);return false;"
                    End If
                End If
            Else
                lnkPageElements.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_elements.aspx?c=" & sCulture & "&pg=" & nPageId & "',325,407);return false;"
            End If

        Else
            lnkPageElements.Visible = False
        End If
        '~~~~ /Page Elements ~~~~

        '~~~~ Content ~~~~
        If Not sContentBody = "" Then
            If bIsLink Then
                Dim sLinkToInfo As String
                sLinkToInfo = "<br /><b>URL</b>: <a href=""" & sLink & """ target=""" & sLinkTarget & """ >" & sLink & "</a>"
                panelBody.Controls.Add(New LiteralControl(sLinkToInfo))
            Else
                sContentBody = sContentBody.Replace("[%FILE_VIEW%]", sFileViewTemplate)
                sContentBody = sContentBody.Replace("[%FILE_DOWNLOAD%]", sFileDownloadTemplate)
                sContentBody = sContentBody.Replace("[%FILE_VIEW_URL%]", sFileViewURL)
                sContentBody = sContentBody.Replace("[%FILE_DOWNLOAD_URL%]", sFileDownloadURL)
                sContentBody = sContentBody.Replace("href=""#", "href=""" & GetFileName() & "#") 'Bookmark handling

                'Body Content
                'MsgBox(sContentBody.Split("[%BREAK%]")(0)) '=> FAILED
                'MsgBox(Split(sContentBody, "[%BREAK%]")(0)) '=> OK

                Dim sFirst As String = Split(sContentBody, "[%BREAK%]")(0)
                If sFirst.Contains("[%LISTING%]") Then
                    PlaceListing(sFirst)
                Else
                    panelBody.Controls.Add(New LiteralControl(sFirst))
                End If

            End If
        End If

        'Additional Content
        If nLayoutType = 1 Then
            placeholderLeft.Controls.Add(New LiteralControl(Split(sContentLeft, "[%BREAK%]")(0)))
        ElseIf nLayoutType = 2 Then
            placeholderRight.Controls.Add(New LiteralControl(Split(sContentRight, "[%BREAK%]")(0)))
        Else
            placeholderLeft.Controls.Add(New LiteralControl(Split(sContentLeft, "[%BREAK%]")(0)))
            placeholderRight.Controls.Add(New LiteralControl(Split(sContentRight, "[%BREAK%]")(0)))
        End If
        '~~~~ /Content ~~~~

        '~~~~ LISTING ~~~~
        If bIsListing Then
            If Not Page.IsPostBack Then
                'sListingScript = "<scr" & "ipt type=""text/javascript"" src=""[%APP_PATH%]systems/media/swfobject.js""></scr" & "ipt>" & vbCrLf & _
                '    "<p id=""[%UNIQUE_ID%]""><a href=""http" & "://www.macromedia.com/go/getflashplayer"">Get the Flash Player</a> to see this player.</p>" & vbCrLf & _
                '    "<script type=""text/javascript"">" & vbCrLf & _
                '    "var s3 = new SWFObject(""[%APP_PATH%]systems/media/mediaplayer.swf"", ""playlist"", ""300"", ""312"", ""7"");" & vbCrLf & _
                '    "s3.addVariable(""file"",""[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]"");" & vbCrLf & _
                '    "s3.addVariable(""allowfullscreen"",""true"");" & vbCrLf & _
                '    "s3.addVariable(""backcolor"",""0x00000"");" & vbCrLf & _
                '    "s3.addVariable(""frontcolor"",""0xD9CFE7"");" & vbCrLf & _
                '    "s3.addVariable(""lightcolor"",""0xB5A0D3"");" & vbCrLf & _
                '    "s3.addVariable(""linktarget"",""_self"");" & vbCrLf & _
                '    "s3.addVariable(""width"",""300"");" & vbCrLf & _
                '    "s3.addVariable(""height"",""312"");" & vbCrLf & _
                '    "s3.addVariable(""displayheight"",""200"");" & vbCrLf & _
                '    "s3.write(""[%UNIQUE_ID%]"");" & vbCrLf & _
                '    "</scr" & "ipt>"
                sListingScript = sListingScript.Replace("[%APP_PATH%]", sAppPath)
                sListingScript = sListingScript.Replace("[%UNIQUE_ID%]", litPlayer.ClientID & "abc")
                sListingScript = sListingScript.Replace("[%PAGE_ID%]", nPageId)
                litPlayer.Text = sListingScript
                ShowListing(0)
            End If
            If lnkEdit.Visible Then
                panelQuickAdd.Visible = True
                If dlDataList.Items.Count = 0 Then
                    idListingEmpty.Visible = True
                End If
            Else
                panelQuickAdd.Visible = False
            End If
        End If
        '~~~~ /LISTING ~~~~

        '************************************************
        '   Modules
        '************************************************

        'System Module
        If Not sPageModule.ToString = "" Then
            Dim oUC1 As Control = LoadControl(sPageModule)
            Dim oUCType As Type = oUC1.GetType
            oUCType.GetProperty("RootID").SetValue(oUC1, nRootId, Nothing)
            oUCType.GetProperty("RootFile").SetValue(oUC1, sRootFile, Nothing)
            oUCType.GetProperty("PageID").SetValue(oUC1, nPageId, Nothing)
            oUCType.GetProperty("ParentID").SetValue(oUC1, nParentId, Nothing)
            oUCType.GetProperty("ParentFileName").SetValue(oUC1, sParentFileName, Nothing)
            oUCType.GetProperty("TemplateID").SetValue(oUC1, nTemplateId, Nothing)
            oUCType.GetProperty("TemplateFolderName").SetValue(oUC1, sTemplateFolderName, Nothing)
            oUCType.GetProperty("IsPublisher").SetValue(oUC1, bIsPublisher, Nothing)
            oUCType.GetProperty("IsSubscriber").SetValue(oUC1, bIsSubscriber, Nothing)
            oUCType.GetProperty("IsAuthor").SetValue(oUC1, bIsAuthor, Nothing)
            oUCType.GetProperty("IsEditor").SetValue(oUC1, bIsEditor, Nothing)
            oUCType.GetProperty("IsResourceManager").SetValue(oUC1, bIsResourceManager, Nothing)
            oUCType.GetProperty("IsAdministrator").SetValue(oUC1, bIsAdministrator, Nothing)
            oUCType.GetProperty("IsReader").SetValue(oUC1, bIsReader, Nothing)
            oUCType.GetProperty("IsOwner").SetValue(oUC1, bIsOwner, Nothing)
            oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC1, bUserLoggedIn, Nothing)
            oUCType.GetProperty("UserName").SetValue(oUC1, sUserName, Nothing)
            oUCType.GetProperty("ChannelPermission").SetValue(oUC1, nChannelPermission, Nothing)

            'Site Info
            oUCType.GetProperty("SiteName").SetValue(oUC1, sSiteName, Nothing)
            oUCType.GetProperty("SiteAddress").SetValue(oUC1, sSiteAddress, Nothing)
            oUCType.GetProperty("SiteCity").SetValue(oUC1, sSiteCity, Nothing)
            oUCType.GetProperty("SiteState").SetValue(oUC1, sSiteState, Nothing)
            oUCType.GetProperty("SiteCountry").SetValue(oUC1, sSiteCountry, Nothing)
            oUCType.GetProperty("SiteZip").SetValue(oUC1, sSiteZip, Nothing)
            oUCType.GetProperty("SitePhone").SetValue(oUC1, sSitePhone, Nothing)
            oUCType.GetProperty("SiteFax").SetValue(oUC1, sSiteFax, Nothing)
            oUCType.GetProperty("SiteEmail").SetValue(oUC1, sSiteEmail, Nothing)

            oUCType.GetProperty("CurrencySeparator").SetValue(oUC1, oMasterPage.CurrencySeparator, Nothing)

            panelBody.Controls.Add(oUC1)
        End If

        'Content Rating
        If bUseRating Then
            If Not IsNothing(placeholderContentRating) Then
                Dim oUC1 As Control = LoadControl("systems/page_rating.ascx")
                Dim oUC1Type As Type = oUC1.GetType
                oUC1Type.GetProperty("RootID").SetValue(oUC1, nRootId, Nothing)
                oUC1Type.GetProperty("RootFile").SetValue(oUC1, sRootFile, Nothing)
                oUC1Type.GetProperty("PageID").SetValue(oUC1, nPageId, Nothing)
                oUC1Type.GetProperty("ParentID").SetValue(oUC1, nParentId, Nothing)
                oUC1Type.GetProperty("ParentFileName").SetValue(oUC1, sParentFileName, Nothing)
                oUC1Type.GetProperty("TemplateID").SetValue(oUC1, nTemplateId, Nothing)
                oUC1Type.GetProperty("TemplateFolderName").SetValue(oUC1, sTemplateFolderName, Nothing)
                oUC1Type.GetProperty("IsPublisher").SetValue(oUC1, bIsPublisher, Nothing)
                oUC1Type.GetProperty("IsSubscriber").SetValue(oUC1, bIsSubscriber, Nothing)
                oUC1Type.GetProperty("IsAuthor").SetValue(oUC1, bIsAuthor, Nothing)
                oUC1Type.GetProperty("IsEditor").SetValue(oUC1, bIsEditor, Nothing)
                oUC1Type.GetProperty("IsResourceManager").SetValue(oUC1, bIsResourceManager, Nothing)
                oUC1Type.GetProperty("IsAdministrator").SetValue(oUC1, bIsAdministrator, Nothing)
                oUC1Type.GetProperty("IsReader").SetValue(oUC1, bIsReader, Nothing)
                oUC1Type.GetProperty("IsOwner").SetValue(oUC1, bIsOwner, Nothing)
                oUC1Type.GetProperty("IsUserLoggedIn").SetValue(oUC1, bUserLoggedIn, Nothing)
                oUC1Type.GetProperty("UserName").SetValue(oUC1, sUserName, Nothing)
                oUC1Type.GetProperty("ChannelPermission").SetValue(oUC1, nChannelPermission, Nothing)

                'Site Info
                oUC1Type.GetProperty("SiteName").SetValue(oUC1, sSiteName, Nothing)
                oUC1Type.GetProperty("SiteAddress").SetValue(oUC1, sSiteAddress, Nothing)
                oUC1Type.GetProperty("SiteCity").SetValue(oUC1, sSiteCity, Nothing)
                oUC1Type.GetProperty("SiteState").SetValue(oUC1, sSiteState, Nothing)
                oUC1Type.GetProperty("SiteCountry").SetValue(oUC1, sSiteCountry, Nothing)
                oUC1Type.GetProperty("SiteZip").SetValue(oUC1, sSiteZip, Nothing)
                oUC1Type.GetProperty("SitePhone").SetValue(oUC1, sSitePhone, Nothing)
                oUC1Type.GetProperty("SiteFax").SetValue(oUC1, sSiteFax, Nothing)
                oUC1Type.GetProperty("SiteEmail").SetValue(oUC1, sSiteEmail, Nothing)

                oUC1Type.GetProperty("CurrencySeparator").SetValue(oUC1, oMasterPage.CurrencySeparator, Nothing)

                placeholderContentRating.Controls.Add(oUC1)
            End If
        End If

        'Comments
        If bUseComments Then
            If Not IsNothing(placeholderComments) Then
                Dim oUC2 As Control = LoadControl("systems/page_comments.ascx")
                Dim oUC2Type As Type = oUC2.GetType
                oUC2Type.GetProperty("RootID").SetValue(oUC2, nRootId, Nothing)
                oUC2Type.GetProperty("RootFile").SetValue(oUC2, sRootFile, Nothing)
                oUC2Type.GetProperty("PageID").SetValue(oUC2, nPageId, Nothing)
                oUC2Type.GetProperty("ParentID").SetValue(oUC2, nParentId, Nothing)
                oUC2Type.GetProperty("ParentFileName").SetValue(oUC2, sParentFileName, Nothing)
                oUC2Type.GetProperty("TemplateID").SetValue(oUC2, nTemplateId, Nothing)
                oUC2Type.GetProperty("TemplateFolderName").SetValue(oUC2, sTemplateFolderName, Nothing)
                oUC2Type.GetProperty("IsPublisher").SetValue(oUC2, bIsPublisher, Nothing)
                oUC2Type.GetProperty("IsSubscriber").SetValue(oUC2, bIsSubscriber, Nothing)
                oUC2Type.GetProperty("IsAuthor").SetValue(oUC2, bIsAuthor, Nothing)
                oUC2Type.GetProperty("IsEditor").SetValue(oUC2, bIsEditor, Nothing)
                oUC2Type.GetProperty("IsResourceManager").SetValue(oUC2, bIsResourceManager, Nothing)
                oUC2Type.GetProperty("IsAdministrator").SetValue(oUC2, bIsAdministrator, Nothing)
                oUC2Type.GetProperty("IsReader").SetValue(oUC2, bIsReader, Nothing)
                oUC2Type.GetProperty("IsOwner").SetValue(oUC2, bIsOwner, Nothing)
                oUC2Type.GetProperty("IsUserLoggedIn").SetValue(oUC2, bUserLoggedIn, Nothing)
                oUC2Type.GetProperty("UserName").SetValue(oUC2, sUserName, Nothing)
                oUC2Type.GetProperty("ChannelPermission").SetValue(oUC2, nChannelPermission, Nothing)

                'Site Info
                oUC2Type.GetProperty("SiteName").SetValue(oUC2, sSiteName, Nothing)
                oUC2Type.GetProperty("SiteAddress").SetValue(oUC2, sSiteAddress, Nothing)
                oUC2Type.GetProperty("SiteCity").SetValue(oUC2, sSiteCity, Nothing)
                oUC2Type.GetProperty("SiteState").SetValue(oUC2, sSiteState, Nothing)
                oUC2Type.GetProperty("SiteCountry").SetValue(oUC2, sSiteCountry, Nothing)
                oUC2Type.GetProperty("SiteZip").SetValue(oUC2, sSiteZip, Nothing)
                oUC2Type.GetProperty("SitePhone").SetValue(oUC2, sSitePhone, Nothing)
                oUC2Type.GetProperty("SiteFax").SetValue(oUC2, sSiteFax, Nothing)
                oUC2Type.GetProperty("SiteEmail").SetValue(oUC2, sSiteEmail, Nothing)

                oUC2Type.GetProperty("CurrencySeparator").SetValue(oUC2, oMasterPage.CurrencySeparator, Nothing)

                If bCommentsAnonymous Then
                    oUC2Type.GetProperty("AllowAnonymous").SetValue(oUC2, True, Nothing)
                Else
                    oUC2Type.GetProperty("AllowAnonymous").SetValue(oUC2, False, Nothing)
                End If

                placeholderComments.Controls.Add(oUC2)
            End If
        End If

        'Custom Module (table page_modules)
        Dim sPlaceholder As String
        Dim nPageModuleId As Integer
        Dim sModuleFile As String
        Dim sModuleData As String

        'ADDITIONAL
        oCommand = New SqlCommand("EXEC advcms_Modules @file", oConn)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@file", SqlDbType.NVarChar).Value = GetFileName()
        oCommand.Connection = oConn
        Dim oReader As SqlDataReader
        oReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)

        'Body Content
        Dim nContentBody As Integer = 0

        'Additional Content
        Dim nAddContentLeft As Integer = 0
        Dim nAddContentRight As Integer = 0

        Do
            Do While oReader.Read

                nPageModuleId = CInt(oReader("page_module_id"))
                sModuleFile = oReader("module_file").ToString()
                sModuleData = oReader("module_data").ToString()
                sPlaceholder = oReader("placeholder_id").ToString()

                Dim oPlaceholder As ContentPlaceHolder = Page.Master.FindControl(sPlaceholder)
                If Not IsNothing(oPlaceholder) Then
                    Dim oUC As Control = LoadControl("modules/" & sModuleFile)
                    Dim oUCType As Type = oUC.GetType

                    Try
                        oUCType.GetProperty("ModuleData").SetValue(oUC, sModuleData, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("RootID").SetValue(oUC, nRootId, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("RootFile").SetValue(oUC, sRootFile, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("PageID").SetValue(oUC, nPageId, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("ParentID").SetValue(oUC, nParentId, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("ParentFileName").SetValue(oUC, sParentFileName, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("TemplateID").SetValue(oUC, nTemplateId, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("TemplateFolderName").SetValue(oUC, sTemplateFolderName, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsPublisher").SetValue(oUC, bIsPublisher, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsSubscriber").SetValue(oUC, bIsSubscriber, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsAuthor").SetValue(oUC, bIsAuthor, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsEditor").SetValue(oUC, bIsEditor, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsResourceManager").SetValue(oUC, bIsResourceManager, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsAdministrator").SetValue(oUC, bIsAdministrator, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsReader").SetValue(oUC, bIsReader, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsOwner").SetValue(oUC, bIsOwner, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("IsUserLoggedIn").SetValue(oUC, bUserLoggedIn, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("UserName").SetValue(oUC, sUserName, Nothing)
                    Catch ex As Exception
                    End Try

                    Try
                        oUCType.GetProperty("ChannelPermission").SetValue(oUC, nChannelPermission, Nothing)
                    Catch ex As Exception
                    End Try

                    'Site Info
                    Try
                        oUCType.GetProperty("SiteName").SetValue(oUC, sSiteName, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteAddress").SetValue(oUC, sSiteAddress, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteCity").SetValue(oUC, sSiteCity, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteState").SetValue(oUC, sSiteState, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteCountry").SetValue(oUC, sSiteCountry, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteZip").SetValue(oUC, sSiteZip, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SitePhone").SetValue(oUC, sSitePhone, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteFax").SetValue(oUC, sSiteFax, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("SiteEmail").SetValue(oUC, sSiteEmail, Nothing)
                    Catch ex As Exception
                    End Try
                    Try
                        oUCType.GetProperty("CurrencySeparator").SetValue(oUC, oMasterPage.CurrencySeparator, Nothing)
                    Catch ex As Exception
                    End Try

                    Dim oButtonUp As ImageButton = New ImageButton
                    oButtonUp.ImageUrl = "~/systems/images/module_up.gif"
                    oButtonUp.AlternateText = GetLocalResourceObject("Move Up")
                    oButtonUp.OnClientClick = "document.getElementById('" & hidPlaceHolder.ClientID & "').value='" & sPlaceholder & "';" & _
                        "document.getElementById('" & hidModule.ClientID & "').value='" & nPageModuleId & "';" & _
                        "document.getElementById('" & hidMove.ClientID & "').value='up';" & _
                        "document.getElementById('" & btnModulePosition.ClientID & "').click();return false;"
                    Dim oButtonDown As ImageButton = New ImageButton
                    oButtonDown.ImageUrl = "~/systems/images/module_down.gif"
                    oButtonDown.AlternateText = GetLocalResourceObject("Move Down")
                    oButtonDown.OnClientClick = "document.getElementById('" & hidPlaceHolder.ClientID & "').value='" & sPlaceholder & "';" & _
                        "document.getElementById('" & hidModule.ClientID & "').value='" & nPageModuleId & "';" & _
                        "document.getElementById('" & hidMove.ClientID & "').value='down';" & _
                        "document.getElementById('" & btnModulePosition.ClientID & "').click();return false;"

                    Dim oButtonDel As ImageButton = New ImageButton
                    oButtonDel.ImageUrl = "~/systems/images/module_detach.gif"
                    oButtonDel.Style.Add("margin-left", "3px")
                    oButtonDel.AlternateText = GetLocalResourceObject("Detach")
                    oButtonDel.OnClientClick = "if(confirm('" & GetLocalResourceObject("DetachModuleConfirm") & "')){" & _
                        "document.getElementById('" & hidPlaceHolder.ClientID & "').value='" & sPlaceholder & "';" & _
                        "document.getElementById('" & hidModule.ClientID & "').value='" & nPageModuleId & "';" & _
                        "document.getElementById('" & hidMove.ClientID & "').value='';" & _
                        "document.getElementById('" & btnModulePosition.ClientID & "').click()};return false;"

                    If Not bIsSystem Then
                        If sPlaceholder.ToLower = "placeholderbody" Then
                            If bIsAdministrator And Not sRawUrl.Contains("print=Y") Then 'sebelumnya panelModule
                                panelBody.Controls.Add(New LiteralControl("<div style=""margin-top:3px;margin-bottom:1px"">"))
                                panelBody.Controls.Add(oButtonUp)
                                panelBody.Controls.Add(oButtonDown)
                                panelBody.Controls.Add(oButtonDel)
                                panelBody.Controls.Add(New LiteralControl("</div>"))
							End If
                            panelBody.Controls.Add(oUC)

                            'Body Content
                            nContentBody = nContentBody + 1
                            If Split(sContentBody, "[%BREAK%]").Length >= nContentBody + 1 Then
                                Dim sNext As String = Split(sContentBody, "[%BREAK%]")(nContentBody)
                                If sNext.Contains("[%LISTING%]") Then
                                    PlaceListing(sNext)
                                Else
                                    panelBody.Controls.Add(New LiteralControl(sNext))
                                End If
                            End If

                        Else
                            If bIsAdministrator And Not sRawUrl.Contains("print=Y") Then
                                oPlaceholder.Controls.Add(New LiteralControl("<div style=""margin-top:3px;margin-bottom:1px"">"))
                                oPlaceholder.Controls.Add(oButtonUp)
                                oPlaceholder.Controls.Add(oButtonDown)
                                oPlaceholder.Controls.Add(oButtonDel)
                                oPlaceholder.Controls.Add(New LiteralControl("</div>"))
                            End If
                            oPlaceholder.Controls.Add(oUC)

                            'Additional Content
                            If sPlaceholder = "placeholderLeft" Then
                                nAddContentLeft = nAddContentLeft + 1
                                If Split(sContentLeft, "[%BREAK%]").Length >= nAddContentLeft + 1 Then
                                    oPlaceholder.Controls.Add(New LiteralControl(Split(sContentLeft, "[%BREAK%]")(nAddContentLeft)))
                                End If
                            End If
                            If sPlaceholder = "placeholderRight" Then
                                nAddContentRight = nAddContentRight + 1
                                If Split(sContentRight, "[%BREAK%]").Length >= nAddContentRight + 1 Then
                                    oPlaceholder.Controls.Add(New LiteralControl(Split(sContentRight, "[%BREAK%]")(nAddContentRight)))
                                End If
                            End If

                        End If
                    End If

                End If

            Loop
            If Not oReader.NextResult() Then Exit Do
        Loop
        oReader.Close()
        oReader = Nothing

        'Body Content (Sisanya)
        Dim j As Integer

        If Split(sContentBody, "[%BREAK%]").Length >= nContentBody Then
            For j = nContentBody + 1 To Split(sContentBody, "[%BREAK%]").Length - 1
                Dim sRest As String = Split(sContentBody, "[%BREAK%]")(j)
                If sRest.Contains("[%LISTING%]") Then
                    PlaceListing(sRest)
                Else
                    panelBody.Controls.Add(New LiteralControl(sRest))
                End If
            Next
        End If

        'Additional Content (Sisanya)
        If Split(sContentLeft, "[%BREAK%]").Length >= nAddContentLeft Then
            For j = nAddContentLeft + 1 To Split(sContentLeft, "[%BREAK%]").Length - 1
                placeholderLeft.Controls.Add(New LiteralControl(Split(sContentLeft, "[%BREAK%]")(j)))
            Next
        End If

        If Split(sContentRight, "[%BREAK%]").Length >= nAddContentRight Then
            For j = nAddContentRight + 1 To Split(sContentRight, "[%BREAK%]").Length - 1
                placeholderRight.Controls.Add(New LiteralControl(Split(sContentRight, "[%BREAK%]")(j)))
            Next
        End If

        If sSummary <> "" Then
            If bIsAuthor Or bIsEditor Or bIsPublisher Or bIsAdministrator Then
                panelBody.Controls.Add(New LiteralControl("<fieldset style=""padding:12px;padding-top:0px;margin-top:12px;-moz-border-radius:7pt;""><legend><b>" & GetLocalResourceObject("lblSummary.Text") & "</b></legend><div style=""padding-top:7px"">" & sSummary & "</div></fieldset><div style=""font-size:8pt;font-style:italic;margin-bottom:12px;text-align:right"">" & GetLocalResourceObject("SummaryNote") & "</div>"))
            End If
        End If

        btnModulePosition.Style.Add("display", "none")

        '~~~ Template Object ~~~
        oMasterPage.IsPublisher = bIsPublisher
        oMasterPage.IsSubscriber = bIsSubscriber
        oMasterPage.IsAuthor = bIsAuthor
        oMasterPage.IsEditor = bIsEditor
        oMasterPage.IsResourceManager = bIsResourceManager
        oMasterPage.IsAdministrator = bIsAdministrator
        oMasterPage.IsReader = bIsReader
        '~~~ /Template Object ~~~

        oCommand = Nothing
        oConn.Close()
        oConn = Nothing
        oContentManager = Nothing
    End Sub

    Protected Sub PlaceListing(ByVal sContent As String)
        Dim sC1 As String = Split(sContent, "[%LISTING%]")(0)
        Dim sC2 As String = Split(sContent, "[%LISTING%]")(1)
        panelBody.Controls.Add(New LiteralControl(sC1))
        panelBody.Controls.Add(idListing)
        panelBody.Controls.Add(New LiteralControl(sC2))
    End Sub

    Protected Sub ShowHideAuthoringLink(ByVal bReloadPageData As Boolean)

        If bReloadPageData Then
            LoadPageData()
        End If

        '************************************************
        '   Show / Hide Status & Authoring Links
        '************************************************
        placeholderPageInfo.Visible = False
        panelAuthoringLinks.Visible = False
        idAddNewTop.Visible = False
        idAddNewBottom.Visible = False
        lnkNewPage.Visible = False
        lnkEdit.Visible = False
        lnkRename.Visible = False

        lnkSubmit.Visible = False
        Dim oChannelManager As ChannelManager = New ChannelManager
        If oChannelManager.NeedApproval(nChannelId) <> CMSChannel.APPROVAL_NONE Then
            'Send for Review
            lnkSubmit.ImageUrl = GetLocalResourceObject("imgSubmitImageUrl1") ' "systems/images/btnSendForReview.gif"
            lnkSubmit.AlternateText = GetLocalResourceObject("imgSubmitAlt1")
        Else
            'Publish
            lnkSubmit.ImageUrl = GetLocalResourceObject("imgSubmitImageUrl2") '"systems/images/btnPublish.gif"
            lnkSubmit.AlternateText = GetLocalResourceObject("imgSubmitAlt2")
        End If
        oChannelManager = Nothing

        lnkDelete.Visible = False
        lnkMove.Visible = False

        lnkForceUnlock.Visible = False
        lnkUnlock.Visible = False
        lnkChangeChannel.Visible = False
        panelEditorApproval.Visible = False
        panelPublisherApproval.Visible = False
        lnkVersionHistory.Visible = False

        'Utk Authorization di dialogs
        Session(nPageId.ToString) = True
        lnkVersionHistory.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_history.aspx?c=" & sCulture & "&pg=" & nPageId & "',720,500);return false;"

        Dim chMgr As ChannelManager = New ChannelManager
        Dim sMoreInfo As String = ""

        If bUserLoggedIn Then

            '~~~ Status ~~~
            If sStatus.Contains("locked") Then
                lblPageStatus.Text = GetLocalResourceObject("PageBeingEdited") & " " & sLastUpdatedBy & "."
            End If
            If sStatus.Contains("unlocked") Then
                lblPageStatus.Text = GetLocalResourceObject("PageAvailableForEditing") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
            End If
            If sStatus.Contains("published") Then
                lblPageStatus.Text = GetLocalResourceObject("PagePublished") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate

                'Check Schedule
                If bUseStartDate Then
                    If Now < dStartDate Then
                        lblPageStatus.Text = GetLocalResourceObject("PageScheduled") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                    End If
                End If
                If bUseEndDate Then
                    If Now > dEndDate Then
                        lblPageStatus.Text = GetLocalResourceObject("PageExpired") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                    End If
                End If

            End If
            If sStatus = "waiting_for_editor_approval" Then
                lblPageStatus.Text = GetLocalResourceObject("PageWaitingForEditorApproval") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                If bMarkedForArchival Then
                    lblPageStatus.Text = GetLocalResourceObject("PageMarkedForDeletion_WaitingForEditorApproval") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                End If
            End If
            If sStatus = "waiting_for_publisher_approval" Then
                lblPageStatus.Text = GetLocalResourceObject("PageWaitingForPublisherApproval") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                If bMarkedForArchival Then
                    lblPageStatus.Text = GetLocalResourceObject("PageMarkedForDeletion_WaitingForPublisherApproval") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
                End If
            End If
            If sStatus = "need_content_revision_unlocked" Then
                lblPageStatus.Text = GetLocalResourceObject("PageDeclinedByEditor") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
            End If
            If sStatus = "need_property_revision_unlocked" Then
                lblPageStatus.Text = GetLocalResourceObject("PageDeclinedByPublisher") & " " & sLastUpdatedBy & " - " & dtLastUpdatedDate
            End If


            'IF USER IS AUTHOR
            If bIsAuthor Then
                panelAuthoringLinks.Visible = True

                sMoreInfo += "<div>" & GetLocalResourceObject("Info_YouHaveAuthorRight") & "</div>"

                '~~~ New Page link ~~~
                lnkNewPage.Visible = True
                If (sStatus = "waiting_for_editor_approval" Or sStatus = "waiting_for_publisher_approval") _
                    And bMarkedForArchival Then
                    lnkNewPage.Visible = False
                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotAddNewPages") & "</div>"
                End If

                '~~~ Edit, Delete, Move links ~~~
                If (sStatus.Contains("locked") And Not sStatus.Contains("unlocked")) And sLastUpdatedBy.ToLower <> sUserName.ToLower Then
                    'Kalau sdg di-lock oleh Author lain
                    'do nothing (Visible=false)
                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotMakeChanges1") & "</div>"
                ElseIf sStatus.Contains("wait") Then
                    'Kalau page sdh di-send for review
                    'do nothing (Visible=false)
                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotMakeChanges2") & "</div>"
                Else
                    lnkEdit.Visible = True
                    lnkRename.Visible = True
                    lnkSubmit.Visible = True
                    lnkVersionHistory.Visible = True
                    If nParentId = 0 Then
                        sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotDeleteOrMove") & "</div>"
                    Else
                        lnkDelete.Visible = True
                        'If nSorting <> 0 Then
                        '    lnkMove.Visible = True
                        'End If
                        lnkMove.Visible = True
                    End If

                    If sLastUpdatedBy.ToLower = sUserName.ToLower And (sStatus.Contains("locked") And Not sStatus.Contains("unlocked")) Then
                        lnkUnlock.Visible = True
                    End If
                End If

                '~~~ placeholderPageInfo ~~~
                If Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                    placeholderPageInfo.Visible = True
                End If

            Else
                sMoreInfo += "<div>" & GetLocalResourceObject("Info_YouDontHaveAuthorRight") & "</div>"

                If sLastUpdatedBy.ToLower = sUserName.ToLower And (sStatus.Contains("locked") And Not sStatus.Contains("unlocked")) Then
                    'Jika User bukan Author channel ybs, tapi dia sedang me-lock page tsb
                    'Ini mungkin terjadi saat admin mengganti channel
                    'ATAU yg me-lock (meng-edit) adl Admin
                    panelAuthoringLinks.Visible = True

                    lnkEdit.Visible = True
                    lnkRename.Visible = True
                    lnkSubmit.Visible = True
                    lnkVersionHistory.Visible = True
                    lnkUnlock.Visible = True

                    'sMoreInfo += "<div>Since you've locked this page for editing " & _
                    '        "you can still edit this page " & _
                    '        "until you unlock this page.</div>"
                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_YouCanStillEdit") & "</div>"

                    '~~~ placeholderPageInfo ~~~
                    If Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                        placeholderPageInfo.Visible = True
                    End If
                End If
            End If

            If bIsEditor Then
                If sStatus = "waiting_for_editor_approval" Then
                    sMoreInfo = "<div>" & GetLocalResourceObject("Info_YouHaveEditorRight") & "<br />" & _
                        GetLocalResourceObject("Info_AsAnEditor") & "</div>"
                    panelEditorApproval.Visible = True
                End If

                '~~~ placeholderPageInfo ~~~
                If Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                    placeholderPageInfo.Visible = True
                End If
            End If

            'IF USER IS PUBLSIHERS
            If bIsPublisher Then
                If sStatus = "waiting_for_publisher_approval" Then
                    sMoreInfo = "<div>" & GetLocalResourceObject("Info_YouHavePublisherRight") & "<br />" & _
                        GetLocalResourceObject("Info_AsAPublisher") & "</div>"
                    panelPublisherApproval.Visible = True
                End If

                '~~~ placeholderPageInfo ~~~
                If Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                    placeholderPageInfo.Visible = True
                End If
            End If

            'IF USER IS ADMINISTRATORS
            If bIsAdministrator Then
                panelAuthoringLinks.Visible = True

                sMoreInfo = "<div>" & GetLocalResourceObject("Info_YouHaveAdminRight") & "</div>"

                '*** New Page link ****************
                lnkNewPage.Visible = True
                If (sStatus = "waiting_for_editor_approval" Or sStatus = "waiting_for_publisher_approval") _
                    And bMarkedForArchival Then
                    lnkNewPage.Visible = False

                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotAddNewPages") & "</div>"
                End If

                '*** Edit, Delete, Move links *****
                If sStatus.Contains("locked") And Not sStatus.Contains("unlocked") Then
                    If sLastUpdatedBy.ToLower = sUserName.ToLower Then
                        lnkEdit.Visible = True
                        lnkRename.Visible = True
                        lnkSubmit.Visible = True
                        lnkVersionHistory.Visible = True
                        If nPageId <> 1 Then
                            lnkDelete.Visible = True
                            'If nSorting <> 0 Then
                            '    lnkMove.Visible = True
                            'End If
                            lnkMove.Visible = True
                        Else
                            sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotDeleteOrMove") & "</div>"
                        End If
                        lnkUnlock.Visible = True
                    Else
                        lnkForceUnlock.Visible = True
                    End If
                ElseIf sStatus.Contains("wait") Then
                    'Kalau page sdh di-send for review
                    'do nothing (Visible=false)
                    sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotMakeChanges2") & "</div>"
                Else
                    lnkEdit.Visible = True
                    lnkRename.Visible = True
                    lnkSubmit.Visible = True
                    lnkVersionHistory.Visible = True
                    If nParentId = 0 Then
                        sMoreInfo += "<div>" & GetLocalResourceObject("Info_CannotDeleteOrMove") & "</div>"
                    Else
                        lnkDelete.Visible = True
                        'If nSorting <> 0 Then
                        '    lnkMove.Visible = True
                        'End If
                        lnkMove.Visible = True
                    End If
                End If

                '*** Channel Info *******************
                lnkChangeChannel.Visible = True
                lnkChangeChannel.OnClientClick = "modalDialog('" & sAppPath & "dialogs/channel_change.aspx?c=" & sCulture & "&pg=" & nPageId & "',350,170);return false;"

                '*** Approval ***********************
                If sStatus = "waiting_for_editor_approval" Then
                    panelEditorApproval.Visible = True
                End If
                If sStatus = "waiting_for_publisher_approval" Then
                    panelPublisherApproval.Visible = True
                End If

                '~~~ placeholderPageInfo ~~~
                If Not bIsSystem And Not sRawUrl.Contains("print=Y") Then
                    placeholderPageInfo.Visible = True
                End If
            End If

            '********************************
            '   Disable Collaboration Feature
            '********************************
            If bDisableCollaboration And bIsAuthor And Not sOwner.ToLower = sUserName.ToLower Then
                If bInitialPage Then
                    lnkNewPage.Visible = True

                    placeholderPageInfo.Visible = True
                    panelApprovalInfo.Visible = False
                    pannelChannelInfo.Visible = False
                    pannelVersionAndMoreInfo.Visible = False
                Else
                    lnkNewPage.Visible = False

                    placeholderPageInfo.Visible = False
                End If

                lnkEdit.Visible = False
                lnkRename.Visible = False
                lnkDelete.Visible = False
                lnkMove.Visible = False
                lnkSubmit.Visible = False
                lnkVersionHistory.Visible = False
            End If

            'Move Panel tetap spt semula tanpa hrs mempertimbangkan masalah disable collaboration
            'krn kalau suatu channel disable collaboration, author tdk akan lihat link move
            If bDisableCollaboration And bIsAuthor Then
                lnkMove.Visible = False
            End If

            If bDisableCollaboration And sLastUpdatedBy.ToLower = sUserName.ToLower And (sStatus.Contains("locked") And Not sStatus.Contains("unlocked")) Then
                'Jika User bukan Owner, tapi dia sedang me-lock page tsb
                'Ini mungkin terjadi saat admin mengganti channel atau bDisableCollaboration
                panelAuthoringLinks.Visible = True

                lnkEdit.Visible = True
                lnkRename.Visible = True
                lnkSubmit.Visible = True
                lnkVersionHistory.Visible = True
                lnkUnlock.Visible = True

                sMoreInfo += "<div>" & GetLocalResourceObject("Info_YouCanStillEdit") & "</div>"

                placeholderPageInfo.Visible = True
            End If
            '********************************

            If sStatus.Contains("published") Then
                lnkSubmit.Visible = False
            End If

            If nPageId = nRootId Then
                lnkRename.Visible = False
                lnkDelete.Visible = False
                lnkMove.Visible = False
            End If

            lblMoreInfo.Text = sMoreInfo & "<div style=""margin-top:3px;"">Page Id: <b>" & nPageId & "</b></div>"
            lnkMoreInfo.OnClientClick = "_showMoreInfo(document.getElementById('" & lnkMoreInfo.ClientID & "'),document.getElementById('" & lnkMoreInfoHide.ClientID & "'));return false"
            lnkMoreInfoHide.OnClientClick = "_hideMoreInfo(document.getElementById('" & lnkMoreInfo.ClientID & "'),document.getElementById('" & lnkMoreInfoHide.ClientID & "'));return false"
            lnkMoreInfoHide.Attributes.Add("style", "display:none")

            'Khusus utk Add New Top/Bottom links
            If bIsAdministrator Then
                idAddNewTop.Visible = True
                idAddNewBottom.Visible = True
            End If
            Dim sChannelRoot As String
            Dim oContentManager As ContentManager = New ContentManager
            Dim oDataReader As SqlDataReader
            oDataReader = oContentManager.GetWorkingContentById(nRootId)
            If oDataReader.Read() Then
                sChannelRoot = oDataReader("channel_name")
                Dim sItem As String
                For Each sItem In arrUserRoles
                    If sItem = sChannelRoot & " Authors" Then
                        idAddNewTop.Visible = True
                        idAddNewBottom.Visible = True
                    End If
                Next
            End If
            oDataReader.Close()
            oContentManager = Nothing

            If bIsLink Then
                lnkNewPage.Visible = False
            End If

            If lnkEdit.Visible And bIsListing Then
                lblMoreInfo.Text = lblMoreInfo.Text & "<div style=""margin-top:3px;"">" & GetLocalResourceObject("ListingTemplate") & ": <b>" & sListingTemplateName & "</b></div>"
            End If
        End If
    End Sub


    Public Function colPath() As Collection

        Dim bContainsBlogPage As Boolean = False

        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String = ""
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        Dim colPage As Collection = New Collection
        Dim oCmd As SqlCommand
        Dim pars As SqlParameterCollection

        If bUserLoggedIn Then 'yus
            oCmd = New SqlCommand("advcms_GetPath2") 'Working
        Else
            oCmd = New SqlCommand("advcms_GetPath") 'Published
        End If

        oCmd.CommandType = CommandType.StoredProcedure
        pars = oCmd.Parameters
        With pars
            .Add("@page_id", SqlDbType.Int).Value = nPageId
        End With

        oConn.Open()
        oCmd.Connection = oConn
        Dim oDataReader As SqlDataReader = oCmd.ExecuteReader()
        While oDataReader.Read()

            If (IsDBNull(oDataReader("page_id"))) Then 'kalau ada yg blm di-publish
                Return colPage
            End If

            If bUserLoggedIn Then
                If bContainsBlogPage = False And CInt(oDataReader("page_type")) = 10 Then
                    bContainsBlogPage = True
                End If
            End If

            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If

            If bUserLoggedIn Then
                nCPermission = CInt(oDataReader("channel_permission"))
                sCName = oDataReader("channel_name").ToString
                bIsHdn = CBool(oDataReader("is_hidden"))
                bIsSys = CBool(oDataReader("is_system"))

                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat, bContainsBlogPage) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                'Show published only, 
                'If not yet published => return colPage
                'If contains link from other channel (permission 3), tetap ditampilkan (published version-nya) dlm breadcrumb
                'krn merupakan penunjuk posisi current page (dgn asumsi current page bisa ditampilkan)
                bShowMenu = True
            End If


            Dim arrTmp() As String = {sFile, sTtl, nPrId.ToString, nPgId.ToString} 'parent info is required to know whether it is root or not. Root has parent_id=0
            colPage.Add(arrTmp, nPgId)
        End While
        oDataReader.Close()

        oCmd = Nothing
        oConn.Close()
        oConn = Nothing
        Return colPage
    End Function

    'Authorize User to Show/Hide a Menu Link
    Protected Function ShowLink(ByVal nCPermission As Integer, _
        ByVal oStartDate As Object, _
        ByVal oEndDate As Object, _
        ByVal bIsSys As Boolean, _
        ByVal bIsHdn As Boolean) As Boolean

        Dim bShowLink As Boolean = False

        '~~~ User Authorization (to display Title/Link Text) ~~~
        Dim bShowMenu As Boolean = False
        If nCPermission = 1 Or nCPermission = 2 Then
            'Utk nCPermission=2:
            'Walaupun user blm login, tdk apa2 link-nya ditampilkan
            bShowLink = True
            If bIsHdn Then
                bShowLink = False
            End If
        ElseIf nCPermission = 3 Then
            bShowLink = False
        End If
        '~~~ /User Authorization ~~~

        'Kalau page belum scheduled, set hidden.
        If Not oStartDate.ToString = "" Then
            If Now < CDate(oStartDate) Then
                bShowLink = False
            End If
        End If

        If Not oEndDate.ToString = "" Then
            If Now > CDate(oEndDate) Then
                bShowLink = False
            End If
        End If

        If bIsSys Then
            'IsSystem => non editable page 
            'eg. 
            '   - Admin pages (channel: General, no specific authorization - tergantung ascx yg diinclude)
            '     Advantage: admin page bisa di-bookmark (krn channel=General => link kelihatan)
            '   - SiteMap 
            If bIsHdn Then
                bShowLink = False 'Pasti
            Else
                bShowLink = True 'Pasti - Show Published (Title/Link Text)
                'Kebetulan utk page yg IsSystem sudah pasti tdk ada working copy,
                'Jadi yg di-show selalu Published / Latest Copy (bisa dari pages_working
            End If
        End If

        Return bShowLink
    End Function

    Protected Function ShowLink2(ByVal nCPermission As Integer, _
        ByVal sCName As String, _
        ByVal oStartDate As Object, _
        ByVal oEndDate As Object, _
        ByVal bIsSys As Boolean, _
        ByVal bIsHdn As Boolean, _
        ByVal bUserLoggedIn As Boolean, _
        Optional ByVal bDisCollab As Boolean = False, _
        Optional ByVal sOwn As String = "", _
        Optional ByVal sLastUpdBy As String = "", _
        Optional ByVal sStat As String = "", _
        Optional ByVal bBlog As Boolean = False) As Integer

        Dim vRetVal As Integer
        '0 => Do not show
        '1 => Show Working (Title/Link Text)
        '2 => Show Published (Title/Link Text)

        Dim bUserCanManage As Boolean = False
        Dim bUserIsSubscriber As Boolean = False
        Dim bIsAuthor As Boolean = False
        Dim bIsEditor As Boolean = False
        Dim bIsPublisher As Boolean = False
        Dim bIsAdministrator As Boolean = False

        If bUserLoggedIn Then
            Dim sRole As String
            For Each sRole In arrUserRoles

                If sRole = sCName & " Authors" Or _
                    sRole = sCName & " Editors" Or _
                    sRole = sCName & " Publishers" Or _
                    sRole = sCName & " Resource Managers" Or _
                    sRole = "Administrators" Then
                    bUserCanManage = True
                    bUserIsSubscriber = True
                    'NOTE: Editor & Publisher harus bisa lihat Working copy juga
                    'utk review (tanpa harus edit)
                    'Jadi tdk perlu di-cek apakah:
                    '1. Released (Editor & Publisher lihat Working copy of Title/Link Text)
                    '2. Tidak    (Editor & Publisher lihat Published copy of Title/Link Text)
                End If
                If sRole = sCName & " Subscribers" Then
                    bUserCanManage = False
                    bUserIsSubscriber = True
                End If

                If sRole = sCName & " Authors" Then
                    bIsAuthor = True
                End If
                If sRole = sCName & " Editors" Then
                    bIsEditor = True
                End If
                If sRole = sCName & " Publishers" Then
                    bIsPublisher = True
                End If
                If sRole = "Administrators" Then
                    bIsAdministrator = True
                End If
            Next
        End If

        '~~~ User Authorization (to display Title/Link Text) ~~~
        Dim bShowMenu As Boolean = False
        If nCPermission = 1 Or nCPermission = 2 Then
            'Utk nCPermission=2:
            'Walaupun user blm login, tdk apa2 link-nya ditampilkan
            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            Else
                'Show Published (Title/Link Text)
                vRetVal = 2
                If bIsHdn Then
                    vRetVal = 0
                End If
            End If
        ElseIf nCPermission = 3 Then
            If bUserCanManage Then
                'Show Working (Title/Link Text)
                vRetVal = 1
            ElseIf bUserIsSubscriber Then
                'Show Published (Title/Link Text)
                vRetVal = 2
                If bIsHdn Then
                    vRetVal = 0
                End If
            Else
                vRetVal = 0
            End If
        End If
        '~~~ /User Authorization ~~~

        'Kalau page belum scheduled, set hidden.
        If Not oStartDate.ToString = "" Then
            If Now < CDate(oStartDate) Then
                vRetVal = 0

                If bUserCanManage Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If

            End If
        End If

        If Not oEndDate.ToString = "" Then
            If Now > CDate(oEndDate) Then
                vRetVal = 0

                If bUserCanManage Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If

            End If
        End If

        '******************************************
        '   Disable Collaboration Feature
        '******************************************
        If bUserLoggedIn Then
            If bDisCollab Then
                If sOwn.ToLower = sUserName.ToLower Or bIsEditor Or bIsPublisher Then
                    'Show Working OR ikut sebelumnya
                    'vRetVal = 1
                Else
                    'Selain owner, editor & publisher => selalu Show Published
                    'Show Published
                    If vRetVal = 1 Then 'eg other Authors
                        vRetVal = 2
                    End If
                    If bIsHdn Then 'if hidden, other authors cannot see
                        vRetVal = 0
                    End If
                End If
                If sLastUpdBy.ToLower = sUserName.ToLower And (sStat.Contains("locked") And Not sStat.Contains("unlocked")) Then
                    'Show Working (Title/Link Text)
                    vRetVal = 1
                End If
            End If
        End If
        '********************************

        If bIsAdministrator Then
            'Show Working (Title/Link Text)
            vRetVal = 1
        End If

        If bIsSys Then
            'IsSystem => non editable page 
            'eg. 
            '   - Admin pages (channel: General, no specific authorization - tergantung ascx yg diinclude)
            '     Advantage: admin page bisa di-bookmark (krn channel=General => link kelihatan)
            '   - SiteMap 
            If bIsHdn Then
                vRetVal = 0 'Pasti
            Else
                vRetVal = 2 'Pasti - Show Published (Title/Link Text)
                'Kebetulan utk page yg IsSystem sudah pasti tdk ada working copy,
                'Jadi yg di-show selalu Published / Latest Copy (bisa dari pages_working
            End If
        End If

        Return vRetVal
    End Function


    '************************************
    '   LINK CLICKED
    '************************************
    Protected Sub lnkNewPage_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkNewPage.Click
        RedirectForLogin()
        PrepareNewPage()
        hidLinkPlacement.Value = "" 'Same as the parent
        PrepareNewPageData(sLinkPlacement)

        hidEditorPurpose.Value = "CreateNew"
    End Sub

    Protected Sub PrepareNewPageData(ByVal sPos As String)
        Dim oList As ListItem
        Dim sChannelName As String
        Dim nChannelPermission As Integer

        'Position
        If Not bIsListing Or (bIsListing And (nListingProperty = 1 Or nListingProperty = 3)) Then
            Dim oContentManager As ContentManager = New ContentManager
            Dim oDataReader As SqlDataReader
            oDataReader = oContentManager.GetContentsWithin(nPageId, sPos)

            lstOrdering.Items.Clear()
            Do While oDataReader.Read()
                oList = New ListItem
                oList.Value = oDataReader("page_id").ToString
                'oList.Text = HttpUtility.HtmlEncode(oDataReader("title").ToString)
                oList.Text = oDataReader("title").ToString

                sChannelName = oDataReader("channel_name").ToString
                nChannelPermission = CInt(oDataReader("channel_permission"))

                '~~~ Page Authorization (based-on Channel Permission) ~~~
                Dim bShowMenu As Boolean = False
                If nChannelPermission = 1 Then
                    bShowMenu = True
                ElseIf nChannelPermission = 2 Then
                    'If Not IsNothing(GetUser) Then
                    bShowMenu = True 'Walaupun user blm login, tdk apa2 link-nya ditampilkan
                    'End If
                ElseIf nChannelPermission = 3 Then
                    If bUserLoggedIn Then
                        Dim sRole As String
                        For Each sRole In arrUserRoles
                            If sRole = sChannelName & " Subscribers" Or _
                                sRole = sChannelName & " Authors" Or _
                                sRole = sChannelName & " Editors" Or _
                                sRole = sChannelName & " Publishers" Or _
                                sRole = sChannelName & " Resource Managers" Or _
                                sRole = "Administrators" Then

                                bShowMenu = True
                            End If
                        Next
                    End If
                End If
                '~~~ /Page Authorization ~~~

                If bShowMenu Then
                    lstOrdering.Items.Add(oList)
                End If
            Loop
            oDataReader.Close()
            oList = New ListItem
            oList.Value = "new"
            oList.Text = ">> New Page Menu Here <<"
            lstOrdering.Items.Insert(lstOrdering.Items.Count, oList)
            lstOrdering.SelectedValue = "new"

            oContentManager = Nothing
        End If
        hidRefPage.Value = nPageId.ToString
        hidRefPos.Value = "UNDER"
        btnUp.OnClientClick = "_doUp(document.getElementById('" & lstOrdering.ClientID & "'),document.getElementById('" & hidRefPage.ClientID & "'),document.getElementById('" & hidRefPos.ClientID & "')); return false;"
        btnDown.OnClientClick = "_doDown(document.getElementById('" & lstOrdering.ClientID & "'),document.getElementById('" & hidRefPage.ClientID & "'),document.getElementById('" & hidRefPos.ClientID & "')); return false;"

        If GetFileName().Contains("/") Then
            lblBaseHref.Text = GetAppFullPath() & GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1)
        Else
            lblBaseHref.Text = GetAppFullPath()
        End If
        'txtFileName.Text = "page" & Now.Year & Now.Month & Now.Day & Now.Hour & Now.Minute & Now.Second
        txtFileName.Text = "page" & nPageId & lstOrdering.Items.Count & Now.Minute & Now.Second
        txtTitle.Text = ""
        txtSummary.Text = ""
        txtSummary2.Text = ""
        dropNewsMonth.SelectedValue = Month(Now)
        dropNewsDay.SelectedValue = Day(Now)
        dropNewsYear.SelectedValue = Year(Now)
    End Sub

    Protected Sub lnkEdit_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkEdit.Click
        RedirectForLogin()
        PrepareEditPage()

        '*** Prepare Edit Page Data ***
        Dim content As CMSContent = New CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        content = oContentManager.GetWorkingCopy(nPageId)
        With content
            txtFileName.Text = .FileName
            lblFileName3.Text = .FileName
            txtTitle.Text = .Title

            txtSummary.Text = .Summary.ToString
            txtSummary2.Text = .Summary.ToString

            dropNewsMonth.SelectedValue = Month(.DisplayDate)
            dropNewsDay.SelectedValue = Day(.DisplayDate)
            dropNewsYear.SelectedValue = Year(.DisplayDate)
            txtBody.Text = .ContentBody
            txtBody2.Text = .ContentBody
            If .IsLink Then
                txtLinkTo.Text = .Link
                If .LinkTarget = "_blank" Then
                    chkLinkNewWindow.Checked = True
                Else
                    chkLinkNewWindow.Checked = False
                End If
            End If

            If .FileAttachment <> "" Or .FileView <> "" Or .FileViewListing <> "" Then
                chkAddFile.Checked = True
                chkAddFile.Enabled = False
                tblAddFile.Style.Add("display", "block")
            Else
                chkAddFile.Checked = False
                chkAddFile.Enabled = True
                tblAddFile.Style.Add("display", "none")
            End If
            chkAddFile.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & tblAddFile.ClientID & "').style.display='block'}else{document.getElementById('" & tblAddFile.ClientID & "').style.display='none'}")

            'File Download
            If .FileAttachment <> "" Then
                lblDownloadFileName.Text = .FileAttachment.Substring(.FileAttachment.IndexOf("_") + 1)
                Dim sExt As String = (.FileAttachment.Substring(.FileAttachment.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litDownloadThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileattach.aspx?file=" & nPageId & "\" & .FileAttachment & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litDownloadThumb.Text = ""
                End If
                chkDelDownload.Visible = True
            End If

            'File View
            If .FileView <> "" Then
                lblViewFileName.Text = .FileView.Substring(.FileView.IndexOf("_") + 1)
                Dim sExt As String = (.FileView.Substring(.FileView.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileview.aspx?file=" & nPageId & "\" & .FileView & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewThumb.Text = ""
                End If
                chkDelView.Visible = True
            End If

            'File View Listing
            If .FileViewListing <> "" Then
                lblViewListingFileName.Text = .FileViewListing.Substring(.FileViewListing.IndexOf("_") + 1)
                Dim sExt As String = (.FileViewListing.Substring(.FileViewListing.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewListingThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_listview.aspx?file=" & nPageId & "\" & .FileViewListing & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewListingThumb.Text = ""
                End If
                chkDelViewListing.Visible = True
            End If
        End With

        'Others
        lblBaseHref.Text = GetAppFullPath()

        Dim chMgr As ChannelManager = New ChannelManager
        If chMgr.NeedApproval(nChannelId) <> CMSChannel.APPROVAL_NONE Then
            rdoSavingOptions.Items(3).Text = "&nbsp;" & GetLocalResourceObject("Action_SendForReview")
            btnSubmit.Text = " " & GetLocalResourceObject("Action_SendForReview") & " "
        Else
            rdoSavingOptions.Items(3).Text = "&nbsp;" & GetLocalResourceObject("Action_Publish")
            btnSubmit.Text = " " & GetLocalResourceObject("Action_Publish") & " "
        End If
        chMgr = Nothing
        content = Nothing
        oContentManager = Nothing

        hidEditorPurpose.Value = "EditExisting"
    End Sub

    Protected Sub lnkRename_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkRename.Click
        RedirectForLogin()
        PrepareRenamePage()

        '*** Prepare Edit Page Data ***
        lblBaseHref2.Text = GetAppFullPath()
        txtFileName2.Text = GetFileName().Substring(0, GetFileName().Length - 5)
        txtFileName2.Attributes.Add("onfocus", "this.select()")
        txtFileName2.Focus()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkDelete.Click
        RedirectForLogin()
        PrepareDeletePage()
    End Sub

    Protected Sub lnkMove_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkMove.Click
        RedirectForLogin()
        Dim sAdvanceMove As Boolean = False

        'Try
        '    sAdvanceMove = Profile.GetProfile(sUserName).GetPropertyValue("UseAdvancedMove")
        'Catch ex As Exception
        '    sAdvanceMove = False
        'End Try

        sAdvanceMove = Profile.UseAdvancedMove

        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        If sAdvanceMove Then
            PrepareMovePage3()
        Else
            PrepareMovePage()

            treeMain.Nodes.Clear()
            treeTop.Nodes.Clear()
            treeBottom.Nodes.Clear()

            Dim oDataReader As SqlDataReader

            Dim oRootMain, oRootTop, oRootBottom, oNode As New TreeNode
            Dim dictNodesMain As New Dictionary(Of String, TreeNode)
            Dim dictNodesTop As New Dictionary(Of String, TreeNode)
            Dim dictNodesBottom As New Dictionary(Of String, TreeNode)

            Dim Item As String
            Dim sUserRoles As String = ""
            For Each Item In arrUserRoles
                sUserRoles += Item & " "
            Next

            Dim oContentManager As ContentManager = New ContentManager

            'MAIN Navigation
            oConn = New SqlConnection(sConn)
            oConn.Open()
            Dim oCommand As SqlCommand
            oCommand = New SqlCommand("advcms_Sitemap2") 'Working
            oCommand.CommandType = CommandType.StoredProcedure
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
            oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "main"
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()

            Do While oDataReader.Read()

                nPgId = CInt(oDataReader("page_id"))
                nPrId = CInt(oDataReader("parent_id"))
                sFile = oDataReader("file_name").ToString()
                sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
                If sLnk <> "" Then
                    sTtl = sLnk
                Else
                    sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
                End If
                nCPermission = CInt(oDataReader("channel_permission"))
                sCName = oDataReader("channel_name").ToString
                bIsHdn = CBool(oDataReader("is_hidden"))
                bIsSys = CBool(oDataReader("is_system"))

                If bUserLoggedIn Then 'user sudah pasti logged-in
                    sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                    If sLnk2 <> "" Then
                        sTtl2 = sLnk2
                    Else
                        sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                    End If
                    bDisCollab = CBool(oDataReader("disable_collaboration"))
                    dtLastUpdBy = oDataReader("last_updated_date")
                    sStat = oDataReader("status").ToString
                    sOwn = oDataReader("owner").ToString
                End If

                'Authorize User to Show/Hide a Menu Link
                Dim bShowMenu As Boolean = False
                Dim nShowMenu As Integer = 0
                If bUserLoggedIn Then 'user sudah pasti logged-in
                    nShowMenu = ShowLink2(nCPermission, sCName, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn, bUserLoggedIn, _
                        bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                    If nShowMenu = 0 Then 'Do not show
                        bShowMenu = False
                    ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                        bShowMenu = True
                    Else 'nShowMenu=2 'Show Published (Title/Link Text)
                        If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                            bShowMenu = False
                        Else
                            bShowMenu = True
                            sTtl = sTtl2
                        End If
                    End If
                Else
                    bShowMenu = ShowLink(nCPermission, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn) 'yus
                End If

                If nPrId = 0 Then

                    oRootMain.Value = nPgId.ToString
                    oRootTop.Value = nPgId.ToString
                    oRootBottom.Value = nPgId.ToString
                    If (sUserRoles.Contains(sCName & " Authors") Or bIsAdministrator) Then
                        oRootMain.Text = sTtl
                        oRootTop.Text = sTtl
                        oRootBottom.Text = sTtl
                    Else
                        oRootMain.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                        oRootTop.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                        oRootBottom.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                    End If
                    dictNodesMain.Add(nPgId.ToString, oRootMain)
                    dictNodesTop.Add(nPgId.ToString, oRootTop)
                    dictNodesBottom.Add(nPgId.ToString, oRootBottom)
                Else
                    oNode = New TreeNode()
                    oNode.Value = nPgId
                    If (sUserRoles.Contains(sCName & " Authors") Or bIsAdministrator) Then
                        oNode.Text = sTtl
                    Else
                        oNode.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                    End If

                    If nPageId.ToString <> nPgId Then
                        Try
                            If bShowMenu Then
                                dictNodesMain(nPrId.ToString).ChildNodes.Add(oNode)
                                dictNodesMain.Add(nPgId.ToString, oNode)
                            End If
                        Catch ex As Exception

                        End Try
                    End If
                End If
            Loop
            oDataReader.Close()
            treeMain.Nodes.Add(oRootMain)
            treeMain.ExpandAll()
            oCommand.Dispose()

            'TOP Navigation
            oCommand = New SqlCommand("advcms_Sitemap2") 'Working
            oCommand.CommandType = CommandType.StoredProcedure
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
            oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "top"
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()

            Do While oDataReader.Read()

                nPgId = CInt(oDataReader("page_id"))
                nPrId = CInt(oDataReader("parent_id"))
                sFile = oDataReader("file_name").ToString()
                sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
                If sLnk <> "" Then
                    sTtl = sLnk
                Else
                    sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
                End If
                nCPermission = CInt(oDataReader("channel_permission"))
                sCName = oDataReader("channel_name").ToString
                bIsHdn = CBool(oDataReader("is_hidden"))
                bIsSys = CBool(oDataReader("is_system"))

                If bUserLoggedIn Then
                    sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                    If sLnk2 <> "" Then
                        sTtl2 = sLnk2
                    Else
                        sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                    End If
                    bDisCollab = CBool(oDataReader("disable_collaboration"))
                    dtLastUpdBy = oDataReader("last_updated_date")
                    sStat = oDataReader("status").ToString
                    sOwn = oDataReader("owner").ToString
                End If

                'Authorize User to Show/Hide a Menu Link
                Dim bShowMenu As Boolean = False
                Dim nShowMenu As Integer = 0
                If bUserLoggedIn Then
                    nShowMenu = ShowLink2(nCPermission, sCName, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn, bUserLoggedIn, _
                        bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                    If nShowMenu = 0 Then 'Do not show
                        bShowMenu = False
                    ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                        bShowMenu = True
                    Else 'nShowMenu=2 'Show Published (Title/Link Text)
                        If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                            bShowMenu = False
                        Else
                            bShowMenu = True
                            sTtl = sTtl2
                        End If
                    End If
                Else
                    bShowMenu = ShowLink(nCPermission, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn) 'yus
                End If

                oNode = New TreeNode()
                oNode.Value = nPgId
                If (sUserRoles.Contains(sCName & " Authors") Or bIsAdministrator) Then
                    oNode.Text = sTtl
                Else
                    oNode.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                End If

                If nPageId.ToString <> nPgId Then
                    Try
                        If bShowMenu Then
                            dictNodesTop(nPrId.ToString).ChildNodes.Add(oNode)
                            dictNodesTop.Add(nPgId.ToString, oNode)
                        End If
                    Catch ex As Exception

                    End Try
                End If
            Loop
            oDataReader.Close()
            treeTop.Nodes.Add(oRootTop)
            treeTop.ExpandAll()
            oCommand.Dispose()

            'BOTTOM Navigation
            oCommand = New SqlCommand("advcms_Sitemap2") 'Working
            oCommand.CommandType = CommandType.StoredProcedure
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
            oCommand.Parameters.Add("@maxlvl", SqlDbType.Int).Value = ConfigurationManager.AppSettings("MaxSiteMapLevel") '4=> 1 million
            oCommand.Parameters.Add("@link_placement", SqlDbType.NVarChar).Value = "bottom"
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()

            Do While oDataReader.Read()

                nPgId = CInt(oDataReader("page_id"))
                nPrId = CInt(oDataReader("parent_id"))
                sFile = oDataReader("file_name").ToString()
                sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
                If sLnk <> "" Then
                    sTtl = sLnk
                Else
                    sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
                End If
                nCPermission = CInt(oDataReader("channel_permission"))
                sCName = oDataReader("channel_name").ToString
                bIsHdn = CBool(oDataReader("is_hidden"))
                bIsSys = CBool(oDataReader("is_system"))

                If bUserLoggedIn Then
                    sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                    If sLnk2 <> "" Then
                        sTtl2 = sLnk2
                    Else
                        sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                    End If
                    bDisCollab = CBool(oDataReader("disable_collaboration"))
                    dtLastUpdBy = oDataReader("last_updated_date")
                    sStat = oDataReader("status").ToString
                    sOwn = oDataReader("owner").ToString
                End If

                'Authorize User to Show/Hide a Menu Link
                Dim bShowMenu As Boolean = False
                Dim nShowMenu As Integer = 0
                If bUserLoggedIn Then
                    nShowMenu = ShowLink2(nCPermission, sCName, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn, bUserLoggedIn, _
                        bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                    If nShowMenu = 0 Then 'Do not show
                        bShowMenu = False
                    ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                        bShowMenu = True
                    Else 'nShowMenu=2 'Show Published (Title/Link Text)
                        If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                            bShowMenu = False
                        Else
                            bShowMenu = True
                            sTtl = sTtl2
                        End If
                    End If
                Else
                    bShowMenu = ShowLink(nCPermission, _
                        oDataReader("published_start_date"), _
                        oDataReader("published_end_date"), _
                        bIsSys, bIsHdn) 'yus
                End If

                oNode = New TreeNode()
                oNode.Value = nPgId
                If (sUserRoles.Contains(sCName & " Authors") Or bIsAdministrator) Then
                    oNode.Text = sTtl
                Else
                    oNode.Text = "<span style=""color:#bbbbbb;cursor:default"" onclick=""return false"">" & sTtl & "</span>"
                End If

                If nPageId.ToString <> nPgId Then
                    Try
                        If bShowMenu Then
                            dictNodesBottom(nPrId.ToString).ChildNodes.Add(oNode)
                            dictNodesBottom.Add(nPgId.ToString, oNode)
                        End If
                    Catch ex As Exception

                    End Try
                End If
            Loop
            oDataReader.Close()
            treeBottom.Nodes.Add(oRootBottom)
            treeBottom.ExpandAll()
            oCommand.Dispose()

            oContentManager = Nothing
            oConn.Close()
            oConn = Nothing
        End If

    End Sub

    Protected Sub treeTop_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles treeTop.SelectedNodeChanged
        RedirectForLogin()
        PrepareMovePage2("top")
    End Sub

    Protected Sub treeMain_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles treeMain.SelectedNodeChanged
        RedirectForLogin()
        PrepareMovePage2("main")
    End Sub

    Protected Sub treeBottom_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles treeBottom.SelectedNodeChanged
        RedirectForLogin()
        PrepareMovePage2("bottom")
    End Sub

    Protected Sub lnkSubmit_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkSubmit.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        'Publish
        'oContentManager.SubmitContent(nPageId, contentLatest.Version, True)
        oContentManager.SubmitContent(nPageId, contentLatest.Version)
        oContentManager = Nothing

        Response.Redirect(GetFileName())
    End Sub


    '************************************
    '   PREPARATION (berkaitan dgn control/interface)
    '************************************
    Private Sub PrepareNewPage()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_AddNew") & "</div>"
        litTitle.Visible = True

        If InStr(HttpContext.Current.Request.Browser.Type, "IE") Or InStr(HttpContext.Current.Request.Browser.Type, "IE7") Then
        Else
            fldsetSummary.Style.Add("-moz-border-radius", "7pt")
            fldsetSummary.Style.Add("border", "#e6e7e8 1px solid")
            fldsetContent.Style.Add("-moz-border-radius", "7pt")
            fldsetContent.Style.Add("border", "#e6e7e8 1px solid")

            fldsetSummarySrc.Style.Add("-moz-border-radius", "7pt")
            fldsetSummarySrc.Style.Add("border", "#e6e7e8 1px solid")
            fldsetContentSrc.Style.Add("-moz-border-radius", "7pt")
            fldsetContentSrc.Style.Add("border", "#e6e7e8 1px solid")
        End If

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = True

        'Inside panelAuthoring :
        lnkInsertPageLinks.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId & "',500,500);return false;"
        lnkInsertResources.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId & "',650,570);return false;"

        lnkInsertPageLinks2.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId & "',500,500);return false;"
        lnkInsertResources2.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId & "',650,570);return false;"

        'Specific
        lblFileName3.Visible = False
        txtFileName.Visible = True
        lblAspx.Visible = True

        'If Profile.EditablePageURL Then
        '    panelUrl.Visible = True
        'Else
        '    panelUrl.Visible = False
        'End If
        If bIsListing Then
            If nListingType = 1 And (nListingProperty = 1 Or nListingProperty = 3) Then
                panelListOrdering.Visible = True
            Else
                panelListOrdering.Visible = False
            End If
        Else
            panelListOrdering.Visible = True
        End If

        If bIsListing And nListingType = 2 Then 'News/Journal
            If Profile.UseWYSIWYG Then
                panelSummary.Visible = True
                panelSummarySource.Visible = False
            Else
                panelSummarySource.Visible = True
                panelSummary.Visible = False
            End If

            panelDisplayDate.Visible = True
            dropNewsMonth.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
            dropNewsDay.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
            dropNewsYear.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
            dropNewsMonth.Items.FindByValue(1).Text = MonthName(1)
            dropNewsMonth.Items.FindByValue(2).Text = MonthName(2)
            dropNewsMonth.Items.FindByValue(3).Text = MonthName(3)
            dropNewsMonth.Items.FindByValue(4).Text = MonthName(4)
            dropNewsMonth.Items.FindByValue(5).Text = MonthName(5)
            dropNewsMonth.Items.FindByValue(6).Text = MonthName(6)
            dropNewsMonth.Items.FindByValue(7).Text = MonthName(7)
            dropNewsMonth.Items.FindByValue(8).Text = MonthName(8)
            dropNewsMonth.Items.FindByValue(9).Text = MonthName(9)
            dropNewsMonth.Items.FindByValue(10).Text = MonthName(10)
            dropNewsMonth.Items.FindByValue(11).Text = MonthName(11)
            dropNewsMonth.Items.FindByValue(12).Text = MonthName(12)
        ElseIf bIsListing And nListingType = 1 Then 'General Listing 

            If Profile.UseWYSIWYG Then
                panelSummary.Visible = True
                panelSummarySource.Visible = False
            Else
                panelSummarySource.Visible = True
                panelSummary.Visible = False
            End If

            panelDisplayDate.Visible = False

        Else
            'To display Summary Editor
            'If Profile.UseWYSIWYG Then
            '    panelSummary.Visible = True
            '    panelSummarySource.Visible = False
            'Else
            '    panelSummarySource.Visible = True
            '    panelSummary.Visible = False
            'End If

            panelSummary.Visible = False
            panelSummarySource.Visible = False

            panelDisplayDate.Visible = False
        End If

        panelOptional.Visible = False

        '~~~~~~~~~~~~ txtBody ~~~~~~~~~~~
        txtBody.Text = ""
        txtBody.Css = sAppPath & "templates/" & sTemplateFolderName & "/editing.css"

        Dim grpEdit As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit", "", New String() {"Undo", "Redo", "Search", "FullScreen", "XHTMLSource", "BRK", "Cut", "Copy", "Paste", "PasteWord", "PasteText"})
        Dim grpFont As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpFont", "", New String() {"FontName", "FontSize", "RemoveFormat", "BRK", "Bold", "Italic", "Underline", "Strikethrough", "Superscript", "ForeColor", "BackColor", "StyleAndFormatting"})
        Dim grpPara As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpPara", "", New String() {"Paragraph", "Indent", "Outdent", "BRK", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyFull", "Numbering", "Bullets"})
        Dim grpInsert As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("Insert", "", New String() {"Image", "Hyperlink", "BRK", "CustomTag"})
        Dim grpObjects As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpObjects", "", New String() {"Flash", "Media", "CustomObject", "InternalLink", "BRK", "Characters", "Line", "Bookmark"})
        Dim grpTables As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpTables", "", New String() {"Table", "BRK", "Guidelines"})
        Dim grpStyles As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpStyles", "", New String() {"Styles", "BRK", "Absolute"})

        Dim tabHome As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit, grpFont, grpPara, grpInsert})
        txtBody.ToolbarTabs.Add(tabHome)

        Dim tabStyle As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabStyle", "Objects & Styles")
        tabStyle.Groups.AddRange(New InnovaStudio.ISGroup() {grpObjects, grpTables, grpStyles})
        txtBody.ToolbarTabs.Add(tabStyle)

        txtBody.InternalLinkWidth = 500
        txtBody.InternalLinkHeight = 500
        txtBody.InternalLink = sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId

        txtBody.CustomObjectWidth = 650
        txtBody.CustomObjectHeight = 570
        txtBody.CustomObject = sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId

        txtBody.CustomTags.Add(New InnovaStudio.Param("&nbsp;&nbsp;File Download&nbsp;&nbsp;", "[%FILE_DOWNLOAD%]"))
        txtBody.CustomTags.Add(New InnovaStudio.Param("&nbsp;&nbsp;File Preview On Page&nbsp;&nbsp;", "[%FILE_VIEW%]"))

        txtBody.CustomColors = New String() {"#ff4500", "#ffa500", "#808000", "#4682b4", "#1e90ff", "#9400d3", "#ff1493", "#a9a9a9"}

        txtBody.EditMode = InnovaStudio.EditorModeEnum.XHTMLBody
        '~~~~~~~~~~~~ /txtBody ~~~~~~~~~~~

        '~~~~~~~~~~~~ txtSummary ~~~~~~~~~~~
        txtSummary.Text = ""
        txtSummary2.Text = ""

        txtSummary.btnForm = False
        txtSummary.btnMedia = True
        txtSummary.btnFlash = True
        txtSummary.btnAbsolute = False
        txtSummary.btnStyles = True

        txtSummary.btnPreview = False
        txtSummary.btnFlash = False
        txtSummary.btnMedia = False

        txtSummary.Css = sAppPath & "templates/" & sTemplateFolderName & "/editing.css"

        txtSummary.InternalLinkWidth = 500
        txtSummary.InternalLinkHeight = 500
        txtSummary.InternalLink = sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId

        txtSummary.CustomObjectWidth = 650
        txtSummary.CustomObjectHeight = 570
        txtSummary.CustomObject = sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId
        '~~~~~~~~~~~~ txtSummary ~~~~~~~~~~~

        Dim sPageTypeScript As String = "<script language=""javascript"" type=""text/javascript"">" & vbCrLf & _
            "<!--" & vbCrLf & _
            "function doNormalOrLinked(val)" & vbCrLf & _
            "   {" & vbCrLf & _
            "   if(val)" & vbCrLf & _
            "       {" & vbCrLf & _
            "       document.getElementById('" & panelContentLink.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       if(document.getElementById('" & panelContentLabel.ClientID & "')) document.getElementById('" & panelContentLabel.ClientID & "').style.display = """";" & vbCrLf & _
            "       if(document.getElementById('" & panelContent.ClientID & "')) document.getElementById('" & panelContent.ClientID & "').style.display = """";" & vbCrLf & _
            "       if(document.getElementById('" & panelContentSource.ClientID & "')) document.getElementById('" & panelContentSource.ClientID & "').style.display = """";" & vbCrLf & _
            "       if(document.getElementById('" & panelListingConfig.ClientID & "')) document.getElementById('" & panelListingConfig.ClientID & "').style.display = """";" & vbCrLf & _
            "       if(document.getElementById('" & panelAddFile.ClientID & "')) document.getElementById('" & panelAddFile.ClientID & "').style.display = """";" & vbCrLf & _
            "       }" & vbCrLf & _
            "   else" & vbCrLf & _
            "       {" & vbCrLf & _
            "       document.getElementById('" & panelContentLink.ClientID & "').style.display = """";" & vbCrLf & _
            "       if(document.getElementById('" & panelContentLabel.ClientID & "')) document.getElementById('" & panelContentLabel.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       if(document.getElementById('" & panelContent.ClientID & "')) document.getElementById('" & panelContent.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       if(document.getElementById('" & panelContentSource.ClientID & "')) document.getElementById('" & panelContentSource.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       if(document.getElementById('" & panelListingConfig.ClientID & "')) document.getElementById('" & panelListingConfig.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       if(document.getElementById('" & panelAddFile.ClientID & "')) document.getElementById('" & panelAddFile.ClientID & "').style.display = ""none"";" & vbCrLf & _
            "       }" & vbCrLf & _
            "   }" & vbCrLf & _
            "// -->" & vbCrLf & _
            "</script>"

        placeholderAuthoring.Controls.Add(New LiteralControl(sPageTypeScript))

        'Buttons
        If Profile.UseAdvancedSaveOptions And Not bDisableCollaboration Then
            panelSimpleSave.Visible = False
            panelAdvancedSave.Visible = True
            btnCreatePage.Visible = True
            btnCreateAndPublishPage.Visible = True
            btnSave.Visible = False
            panelSaveOptions.Visible = False
            btnCancel.Visible = True
        Else
            panelSimpleSave.Visible = True
            panelAdvancedSave.Visible = False
            btnCreatePage2.Visible = True
            btnCreateAndPublishPage2.Visible = True
            btnSave2.Visible = False
            btnSaveAndFinish.Visible = False
            btnSubmit.Visible = False
            btnCancel2.Visible = True
        End If

        Dim chMgr As ChannelManager = New ChannelManager
        If chMgr.NeedApproval(nChannelId) <> CMSChannel.APPROVAL_NONE Then
            btnCreateAndPublishPage.Text = " " & GetLocalResourceObject("Action_SendForReview") & " "
            btnCreateAndPublishPage2.Text = " " & GetLocalResourceObject("Action_SendForReview") & " "
        End If
        chMgr = Nothing

        If Profile.UseAdvancedEditor Then
            txtBody.EditorType = InnovaStudio.EditorTypeEnum.Advance
            lnkQuickEdit.Visible = True
            lnkAdvEdit.Visible = False

            txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Advance
            lnkQuickEdit2.Visible = True
            lnkAdvEdit2.Visible = False
        Else
            txtBody.EditorType = InnovaStudio.EditorTypeEnum.Quick
            lnkQuickEdit.Visible = False
            lnkAdvEdit.Visible = True

            txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Quick
            lnkQuickEdit2.Visible = False
            lnkAdvEdit2.Visible = True
        End If

        If Profile.UseWYSIWYG Then
            panelContentLabel.Visible = True
            panelContent.Visible = True
            panelContentSource.Visible = False
        Else
            panelContentLabel.Visible = False
            panelContent.Visible = False
            panelContentSource.Visible = True

            txtBody2.Text = ""
        End If

        panelNormalOrLinked.Visible = True
        rdoNormalPage.Attributes.Add("onclick", "doNormalOrLinked(true)")
        rdoLinkedPage.Attributes.Add("onclick", "doNormalOrLinked(false)")

        tblListingConfig.Style.Add("display", "none")
        chkIsListing.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & tblListingConfig.ClientID & "').style.display='block'}else{document.getElementById('" & tblListingConfig.ClientID & "').style.display='none'}")

        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = "SELECT id, template_name FROM listing_templates order by template_name"
        dropListingTemplates.Items.Clear()
        dropListingTemplates.DataValueField = "id"
        dropListingTemplates.DataTextField = "template_name"
        dropListingTemplates.DataSource = sqlDS
        dropListingTemplates.DataBind()

        If bIsListing And bListingUseCategories Then
            panelListingCategory.Visible = True
            dropListingCategory.Items.Clear()
            dropListingCategory.Items.Add(New ListItem(GetLocalResourceObject("Uncategorized"), ""))
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            Dim oDataReader As SqlDataReader
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "SELECT * FROM listing_categories WHERE page_id = @page_id ORDER BY sorting"
            oCommand = New SqlCommand(sSQL)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            While oDataReader.Read()
                dropListingCategory.Items.Add(New ListItem(oDataReader("listing_category_name").ToString, oDataReader("listing_category_id").ToString))
            End While
            oDataReader.Close()
            oConn.Close()
            oDataReader = Nothing
            oConn = Nothing
        End If

        divTime.Style.Add("display", "none")
        chkTime.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divTime.ClientID & "').style.display=''}else{document.getElementById('" & divTime.ClientID & "').style.display='none'}")
        dropHour.SelectedValue = Now.Hour
        If Now.Minute > 30 Then dropMinute.SelectedValue = 30

        chkAddFile.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & tblAddFile.ClientID & "').style.display='block'}else{document.getElementById('" & tblAddFile.ClientID & "').style.display='none'}")
    End Sub

    Private Sub PrepareEditPage()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_EditPage") & "</div>"
        litTitle.Visible = True

        If InStr(HttpContext.Current.Request.Browser.Type, "IE") Or InStr(HttpContext.Current.Request.Browser.Type, "IE7") Then
        Else
            fldsetSummary.Style.Add("-moz-border-radius", "7pt")
            fldsetSummary.Style.Add("border", "#e6e7e8 1px solid")
            fldsetContent.Style.Add("-moz-border-radius", "7pt")
            fldsetContent.Style.Add("border", "#e6e7e8 1px solid")

            fldsetSummarySrc.Style.Add("-moz-border-radius", "7pt")
            fldsetSummarySrc.Style.Add("border", "#e6e7e8 1px solid")
            fldsetContentSrc.Style.Add("-moz-border-radius", "7pt")
            fldsetContentSrc.Style.Add("border", "#e6e7e8 1px solid")
        End If

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = True

        'Inside panelAuthoring :
        lnkInsertPageLinks.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId & "',500,500);return false;"
        lnkInsertResources.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId & "',600,570);return false;"

        lnkInsertPageLinks2.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId & "',500,500);return false;"
        lnkInsertResources2.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId & "',600,570);return false;"

        'Specific
        lblFileName3.Visible = True
        txtFileName.Visible = False
        lblAspx.Visible = False

        'If Profile.EditablePageURL Then
        '    panelUrl.Visible = True
        'Else
        '    panelUrl.Visible = False
        'End If

        'If nParentListingProperty = 1 Or nListingProperty = 3 Then
        '    panelListOrdering.Visible = True
        'Else
        '    panelListOrdering.Visible = False
        'End If
        panelListOrdering.Visible = False

        If bParentIsListing Then
            If nParentListingType = 2 Then 'News/Journal
                If Profile.UseWYSIWYG Then
                    panelSummary.Visible = True
                    panelSummarySource.Visible = False
                Else
                    panelSummarySource.Visible = True
                    panelSummary.Visible = False
                End If
                panelDisplayDate.Visible = True
                dropNewsMonth.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
                dropNewsDay.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
                dropNewsYear.Attributes.Add("onchange", "validateDate(document.getElementById('" & dropNewsDay.ClientID & "'), document.getElementById('" & dropNewsMonth.ClientID & "'), document.getElementById('" & dropNewsYear.ClientID & "'))")
                dropNewsMonth.Items.FindByValue(1).Text = MonthName(1)
                dropNewsMonth.Items.FindByValue(2).Text = MonthName(2)
                dropNewsMonth.Items.FindByValue(3).Text = MonthName(3)
                dropNewsMonth.Items.FindByValue(4).Text = MonthName(4)
                dropNewsMonth.Items.FindByValue(5).Text = MonthName(5)
                dropNewsMonth.Items.FindByValue(6).Text = MonthName(6)
                dropNewsMonth.Items.FindByValue(7).Text = MonthName(7)
                dropNewsMonth.Items.FindByValue(8).Text = MonthName(8)
                dropNewsMonth.Items.FindByValue(9).Text = MonthName(9)
                dropNewsMonth.Items.FindByValue(10).Text = MonthName(10)
                dropNewsMonth.Items.FindByValue(11).Text = MonthName(11)
                dropNewsMonth.Items.FindByValue(12).Text = MonthName(12)

            ElseIf nParentListingType = 1 Then 'General Listing
                If Profile.UseWYSIWYG Then
                    panelSummary.Visible = True
                    panelSummarySource.Visible = False
                Else
                    panelSummarySource.Visible = True
                    panelSummary.Visible = False
                End If
            End If
        Else
            If bForceShowSummaryEditor Then
                'To display Summary Editor
                If Profile.UseWYSIWYG Then
                    panelSummary.Visible = True
                    panelSummarySource.Visible = False
                Else
                    panelSummarySource.Visible = True
                    panelSummary.Visible = False
                End If
            Else
                panelSummary.Visible = False
                panelSummarySource.Visible = False
            End If

            panelDisplayDate.Visible = False
        End If

        panelOptional.Visible = True


        '~~~~~~~~~~~~ txtBody ~~~~~~~~~~~
        txtBody.Css = sAppPath & "templates/" & sTemplateFolderName & "/editing.css"

        Dim grpEdit As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit", "", New String() {"Undo", "Redo", "Search", "FullScreen", "XHTMLSource", "BRK", "Cut", "Copy", "Paste", "PasteWord", "PasteText"})
        Dim grpFont As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpFont", "", New String() {"FontName", "FontSize", "RemoveFormat", "BRK", "Bold", "Italic", "Underline", "Strikethrough", "Superscript", "ForeColor", "BackColor", "StyleAndFormatting"})
        Dim grpPara As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpPara", "", New String() {"Paragraph", "Indent", "Outdent", "BRK", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyFull", "Numbering", "Bullets"})
        Dim grpInsert As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("Insert", "", New String() {"Image", "Hyperlink", "BRK", "CustomTag"})
        Dim grpObjects As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpObjects", "", New String() {"Flash", "Media", "CustomObject", "InternalLink", "BRK", "Characters", "Line", "Bookmark"})
        Dim grpTables As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpTables", "", New String() {"Table", "BRK", "Guidelines"})
        Dim grpStyles As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpStyles", "", New String() {"Styles", "BRK", "Absolute"})

        Dim tabHome As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit, grpFont, grpPara, grpInsert})
        txtBody.ToolbarTabs.Add(tabHome)

        Dim tabStyle As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabStyle", "Objects & Styles")
        tabStyle.Groups.AddRange(New InnovaStudio.ISGroup() {grpObjects, grpTables, grpStyles})
        txtBody.ToolbarTabs.Add(tabStyle)

        txtBody.InternalLinkWidth = 500
        txtBody.InternalLinkHeight = 500
        txtBody.InternalLink = sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId

        txtBody.CustomObjectWidth = 650
        txtBody.CustomObjectHeight = 570
        txtBody.CustomObject = sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId

        txtBody.CustomTags.Add(New InnovaStudio.Param("&nbsp;&nbsp;File Download&nbsp;&nbsp;", "[%FILE_DOWNLOAD%]"))
        txtBody.CustomTags.Add(New InnovaStudio.Param("&nbsp;&nbsp;File Preview On Page&nbsp;&nbsp;", "[%FILE_VIEW%]"))

        txtBody.CustomColors = New String() {"#ff4500", "#ffa500", "#808000", "#4682b4", "#1e90ff", "#9400d3", "#ff1493", "#a9a9a9"}

        txtBody.EditMode = InnovaStudio.EditorModeEnum.XHTMLBody
        '~~~~~~~~~~~~ /txtBody ~~~~~~~~~~~

        '~~~~~~~~~~~~ txtSummary ~~~~~~~~~~~
        txtSummary.btnForm = False
        txtSummary.btnMedia = True
        txtSummary.btnFlash = True
        txtSummary.btnAbsolute = False
        txtSummary.btnStyles = True

        txtSummary.btnPreview = False
        txtSummary.btnFlash = False
        txtSummary.btnMedia = False

        txtSummary.Css = sAppPath & "templates/" & sTemplateFolderName & "/editing.css"

        txtSummary.InternalLinkWidth = 500
        txtSummary.InternalLinkHeight = 500
        txtSummary.InternalLink = sAppPath & "dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId

        txtSummary.CustomObjectWidth = 650
        txtSummary.CustomObjectHeight = 570
        txtSummary.CustomObject = sAppPath & "dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId
        '~~~~~~~~~~~~ /txtSummary ~~~~~~~~~~~

        'Utk Authorization di dialogs
        Session(nPageId.ToString) = True

        If nLayoutType = 1 Then
            lnkAdditionalContent.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_addcontent.aspx?c=" & sCulture & "&pg=" & nPageId & "&root=" & nRootId & "&area=left',745,515);return false;"
        ElseIf nLayoutType = 2 Then
            lnkAdditionalContent.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_addcontent.aspx?c=" & sCulture & "&pg=" & nPageId & "&root=" & nRootId & "&area=right',745,515);return false;"
        Else
            lnkAdditionalContent.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_addcontent.aspx?c=" & sCulture & "&pg=" & nPageId & "&root=" & nRootId & "&area=leftright',745,515);return false;"
        End If
        lnkPageProperties.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_properties.aspx?c=" & sCulture & "&pg=" & nPageId & "',540,380);return false;"
        lnkPublishingDate.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_schedule.aspx?c=" & sCulture & "&pg=" & nPageId & "',400,510);return false;"
        'lnkPageShop.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_shop.aspx?c=" & sCulture & "&pg=" & nPageId & "',280,292);return false;"
        lnkPageShop.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_shop.aspx?c=" & sCulture & "&pg=" & nPageId & "',280,262);return false;" 'idUnits (Units in stock) hidden 
        'Hide Shop
        If ConfigurationManager.AppSettings("Shop") = "no" Then
            lnkPageShop.Visible = False
        End If

        lnkCustomProperties.OnClientClick = "modalDialog('" & sAppPath & "dialogs/page_properties2.aspx?c=" & sCulture & "&pg=" & nPageId & "',425,375);return false;"
        Dim oMasterPage As BaseMaster = CType(Me.Master, BaseMaster)
        If oMasterPage.UseCustomProperties Then
            lnkCustomProperties.Visible = True
        Else
            lnkCustomProperties.Visible = False
        End If

        'Buttons
        If Profile.UseAdvancedSaveOptions And Not bDisableCollaboration Then
            panelSimpleSave.Visible = False
            panelAdvancedSave.Visible = True
            btnCreatePage.Visible = False
            btnCreateAndPublishPage.Visible = False
            btnSave.Visible = True
            panelSaveOptions.Visible = True
            btnCancel.Visible = True
        Else
            panelSimpleSave.Visible = True
            panelAdvancedSave.Visible = False
            btnCreatePage2.Visible = False
            btnCreateAndPublishPage2.Visible = False
            btnSave2.Visible = True
            btnSaveAndFinish.Visible = True
            btnSubmit.Visible = True
            btnCancel2.Visible = True
        End If

        If hidEditorType.Value = "" Then
            If Profile.UseAdvancedEditor Then
                txtBody.EditorType = InnovaStudio.EditorTypeEnum.Advance
                lnkQuickEdit.Visible = True
                lnkAdvEdit.Visible = False

                txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Advance
                lnkQuickEdit2.Visible = True
                lnkAdvEdit2.Visible = False
            Else
                txtBody.EditorType = InnovaStudio.EditorTypeEnum.Quick
                lnkQuickEdit.Visible = False
                lnkAdvEdit.Visible = True

                txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Quick
                lnkQuickEdit2.Visible = False
                lnkAdvEdit2.Visible = True
            End If
        Else
            If hidEditorType.Value = "advanced" Then
                txtBody.EditorType = InnovaStudio.EditorTypeEnum.Advance
                lnkQuickEdit.Visible = True
                lnkAdvEdit.Visible = False

                txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Advance
                lnkQuickEdit2.Visible = True
                lnkAdvEdit2.Visible = False
            Else
                txtBody.EditorType = InnovaStudio.EditorTypeEnum.Quick
                lnkQuickEdit.Visible = False
                lnkAdvEdit.Visible = True

                txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Quick
                lnkQuickEdit2.Visible = False
                lnkAdvEdit2.Visible = True
            End If
        End If

        If Profile.UseWYSIWYG Then
            panelContentLabel.Visible = True
            panelContent.Visible = True
            panelContentSource.Visible = False
        Else
            panelContentLabel.Visible = False
            panelContent.Visible = False
            panelContentSource.Visible = True
        End If

        If bIsLink Then
            panelContentLink.Style.Add("display", "block")
            panelContentLabel.Visible = False
            panelContent.Visible = False
            panelContentSource.Visible = False
            panelListingConfig.Visible = False
            panelAddFile.Visible = False

            lnkAdditionalContent.Visible = False
            lnkPageShop.Visible = False
        End If
        panelNormalOrLinked.Visible = False

        If bIsListing Then
            tblListingConfig.Style.Add("display", "block")
        Else
            tblListingConfig.Style.Add("display", "none")
        End If
        chkIsListing.Checked = bIsListing
        chkIsListing.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & tblListingConfig.ClientID & "').style.display='block'}else{document.getElementById('" & tblListingConfig.ClientID & "').style.display='none'}")

        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = "SELECT id, template_name FROM listing_templates order by template_name"
        dropListingTemplates.Items.Clear()
        dropListingTemplates.DataValueField = "id"
        dropListingTemplates.DataTextField = "template_name"
        dropListingTemplates.DataSource = sqlDS
        dropListingTemplates.DataBind()

        If Not nListingTemplateId = 0 And Not nListingTemplateId.ToString = "" Then
            dropListingTemplates.SelectedValue = nListingTemplateId
        End If

        If bParentIsListing And bParentListingUseCategories Then
            panelListingCategory.Visible = True
            dropListingCategory.Items.Clear()
            dropListingCategory.Items.Add(New ListItem(GetLocalResourceObject("Uncategorized"), ""))
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            Dim oDataReader As SqlDataReader
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "SELECT * FROM listing_categories WHERE page_id = @page_id ORDER BY sorting"
            oCommand = New SqlCommand(sSQL)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nParentId
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            While oDataReader.Read()
                dropListingCategory.Items.Add(New ListItem(oDataReader("listing_category_name").ToString, oDataReader("listing_category_id").ToString))
            End While
            oDataReader.Close()

            sSQL = "SELECT * FROM listing_category_map WHERE page_id = @page_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            Dim bIsUncategorized As Boolean = True
            While oDataReader.Read()
                bIsUncategorized = False
                dropListingCategory.Items.FindByValue(CInt(oDataReader("listing_category_id"))).Selected = True
            End While
            oDataReader.Close()
            If bIsUncategorized Then
                dropListingCategory.SelectedValue = ""
            End If

            oConn.Close()
            oDataReader = Nothing
            oConn = Nothing
        End If

        If bParentIsListing Then
            If nParentListingType = 2 Then 'News/Journal
                If dDisplayDate.Hour = 0 Then
                    divTime.Style.Add("display", "none")
                    chkTime.Checked = False
                Else
                    divTime.Style.Add("display", "block")
                    chkTime.Checked = True
                End If

                chkTime.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divTime.ClientID & "').style.display=''}else{document.getElementById('" & divTime.ClientID & "').style.display='none'}")
                dropHour.SelectedValue = dDisplayDate.Hour
                If Not IsNothing(dropMinute.Items.FindByValue(dDisplayDate.Minute.ToString)) Then
                    dropMinute.SelectedValue = dDisplayDate.Minute
                Else
                    Dim oItem As ListItem = New ListItem
                    If dDisplayDate.Minute.ToString.Length = 1 Then
                        oItem.Text = "0" & dDisplayDate.Minute.ToString
                    Else
                        oItem.Text = dDisplayDate.Minute.ToString
                    End If
                    oItem.Value = dDisplayDate.Minute.ToString

                    If Now.Minute > 0 And Now.Minute <= 5 Then
                        dropMinute.Items.Insert(1, oItem)
                    ElseIf Now.Minute > 5 And Now.Minute <= 10 Then
                        dropMinute.Items.Insert(2, oItem)
                    ElseIf Now.Minute > 10 And Now.Minute <= 15 Then
                        dropMinute.Items.Insert(3, oItem)
                    ElseIf Now.Minute > 15 And Now.Minute <= 20 Then
                        dropMinute.Items.Insert(4, oItem)
                    ElseIf Now.Minute > 20 And Now.Minute <= 25 Then
                        dropMinute.Items.Insert(5, oItem)
                    ElseIf Now.Minute > 25 And Now.Minute <= 30 Then
                        dropMinute.Items.Insert(6, oItem)
                    ElseIf Now.Minute > 30 And Now.Minute <= 35 Then
                        dropMinute.Items.Insert(7, oItem)
                    ElseIf Now.Minute > 35 And Now.Minute <= 40 Then
                        dropMinute.Items.Insert(8, oItem)
                    ElseIf Now.Minute > 40 And Now.Minute <= 45 Then
                        dropMinute.Items.Insert(9, oItem)
                    ElseIf Now.Minute > 45 And Now.Minute <= 50 Then
                        dropMinute.Items.Insert(10, oItem)
                    ElseIf Now.Minute > 50 And Now.Minute <= 55 Then
                        dropMinute.Items.Insert(11, oItem)
                    ElseIf Now.Minute > 55 And Now.Minute <= 60 Then
                        dropMinute.Items.Insert(12, oItem)
                    End If

                    dropMinute.SelectedValue = dDisplayDate.Minute
                End If
            End If
        End If

        If Not bParentIsListing Then
            idPreviewOnListing.Style.Add("display", "none")
        End If

    End Sub

    Private Sub PrepareRenamePage()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_RenamePage") & "</div>"

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = False
        panelRename.Visible = True
    End Sub

    Private Sub PrepareDeletePage()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_DeletePage") & "</div>"

        Dim oContentManager As ContentManager = New ContentManager
        If oContentManager.IsSubContentExist(nPageId) Then
            panelDelete.Visible = False
            panelDeleteNotAllowed.Visible = True
        Else
            panelDelete.Visible = True
            panelDeleteNotAllowed.Visible = False
        End If
        oContentManager = Nothing

        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = False
    End Sub

    Private Sub PrepareMovePage()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_MovePage") & "</div>"

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = True
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = False
        panelMoveVer2.Visible = False
    End Sub

    Private Sub PrepareMovePage2(ByVal Placement As String)
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_MovePage") & "</div>"

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = True
        panelAuthoring.Visible = False

        'Additional required
        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader = Nothing

        If Placement = "top" Then
            hidMoveRefPage.Value = CInt(treeTop.SelectedValue)
            hidLinkPlacement.Value = "top"
        ElseIf Placement = "main" Then
            hidMoveRefPage.Value = CInt(treeMain.SelectedValue)
            hidLinkPlacement.Value = ""
        ElseIf Placement = "bottom" Then
            hidMoveRefPage.Value = CInt(treeBottom.SelectedValue)
            hidLinkPlacement.Value = "bottom"
        End If


        '*****************************************
        'Target Page Type
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        oConn = New SqlConnection(sConn)
        oConn.Open()
        Dim nMoveRefPageType As Integer
        Dim sSQL As String = "Select * From pages_working where page_id=@page_id"
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = CInt(hidMoveRefPage.Value)
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            nMoveRefPageType = CInt(oDataReader("page_type"))
        End While
        oDataReader.Close()

        If nMoveRefPageType = 4 Or nMoveRefPageType = 5 Then
            'Listing Item di-move ke Listing page lain ATAU Page biasa di-move ke Listing page

            'Langsung move (tdk perlu tentukan posisi)
            Dim contentLatest As CMSContent
            If hidLinkPlacement.Value = "" Then
                contentLatest = oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), "UNDER")
            Else
                contentLatest = oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), "UNDER", hidLinkPlacement.Value)
            End If
            'Set sorting=0
            oContentManager.ResetSorting(nPageId, contentLatest.Version)
            oContentManager = Nothing
            'Redirect
            Response.Redirect(GetFileName())

            Exit Sub
        Else
            'Listing Item di-move ke page biasa ATAU Page biasa di-move ke page biasa
            'noop
        End If
        '*****************************************

        If Placement = "top" Then
            oDataReader = oContentManager.GetContentsWithin(CInt(treeTop.SelectedValue), "top")
        ElseIf Placement = "main" Then
            oDataReader = oContentManager.GetContentsWithin(CInt(treeMain.SelectedValue), "main")
        ElseIf Placement = "bottom" Then
            oDataReader = oContentManager.GetContentsWithin(CInt(treeBottom.SelectedValue), "bottom")
        End If

        If Not oDataReader.HasRows Then
            'Langsung move (tdk perlu tentukan posisi)
            'oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), "UNDER", hidLinkPlacement.Value)
            If hidLinkPlacement.Value = "" Then
                oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), "UNDER")
            Else
                oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), "UNDER", hidLinkPlacement.Value)
            End If
            oDataReader.Close()
            oContentManager = Nothing
            Response.Redirect(GetFileName())
            Exit Sub
        End If

        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        lstMoveOrdering.Items.Clear()

        Dim oList As ListItem
        Do While oDataReader.Read()
            oList = New ListItem

            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = "../" & oDataReader("file_name").ToString()
            'sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString) 
            sLnk = oDataReader("link_text").ToString 'tdk perlu encode krn utk listbox
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                'sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
                sTtl = oDataReader("title").ToString 'tdk perlu encode krn utk listbox
            End If
            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            If bUserLoggedIn Then 'user sudah pasti logged-in
                'sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                sLnk2 = oDataReader("link_text2").ToString 'tdk perlu encode krn utk listbox
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    'sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                    sTtl2 = oDataReader("title2").ToString 'tdk perlu encode krn utk listbox
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then 'user sudah pasti logged-in
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                bShowMenu = ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn) 'yus
            End If

            oList.Value = nPgId
            oList.Text = sTtl
            If nPgId <> nPageId.ToString Then
                If bShowMenu Then
                    lstMoveOrdering.Items.Add(oList)
                End If
            End If
        Loop
        oDataReader.Close()
        oList = New ListItem
        oList.Value = "new"
        oList.Text = ">>" & sTitle & "<<"
        lstMoveOrdering.Items.Insert(lstMoveOrdering.Items.Count, oList)
        lstMoveOrdering.SelectedValue = "new"

        btnMoveUp.OnClientClick = "_doUp(document.getElementById('" & lstMoveOrdering.ClientID & "'),document.getElementById('" & hidMoveRefPage.ClientID & "'),document.getElementById('" & hidMoveRefPos.ClientID & "')); return false;"
        btnMoveDown.OnClientClick = "_doDown(document.getElementById('" & lstMoveOrdering.ClientID & "'),document.getElementById('" & hidMoveRefPage.ClientID & "'),document.getElementById('" & hidMoveRefPos.ClientID & "')); return false;"

        oConn.Close()
        oConn = Nothing
        oContentManager = Nothing
    End Sub

    Private Sub PrepareMovePage3()
        PreparePlaceholdersForEdit()

        litTitle.Text = "<div class=""title"">" & GetLocalResourceObject("Title_MovePage") & "</div>"

        panelDelete.Visible = False
        panelDeleteNotAllowed.Visible = False
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False
        panelAuthoring.Visible = False
        panelMoveVer2.Visible = True
        txtFileNameMove.Attributes.Add("onmouseleave", "if (this.value.toLowerCase()=='default.aspx'){HideShow(document.getElementById('" & ddlMove.ClientID & "'),document.getElementById('" & ddlMove2.ClientID & "'));} else{HideShow(document.getElementById('" & ddlMove2.ClientID & "'),document.getElementById('" & ddlMove.ClientID & "'));};")
    End Sub


    '************************************
    '   COMMON
    '************************************
    Private Sub PreparePlaceholdersForEdit()
        placeholderAuthoring.Visible = True
        placeholderPageInfo.Visible = False
        placeholderBody.Visible = False
        placeholderBodyTop.Visible = False
        placeholderBodyBottom.Visible = False

        'Tdk di set visible=false spy tdk mempengaruhi nLayoutType
        'placeholderLeft.Visible = False
        'placeholderLeftTop.Visible = False
        'placeholderLeftBottom.Visible = False
        'placeholderRight.Visible = False
        'placeholderRightTop.Visible = False
        'placeholderRightBottom.Visible = False
        placeholderLeft.Controls.Clear()
        placeholderLeftTop.Controls.Clear()
        placeholderLeftBottom.Controls.Clear()
        placeholderRight.Controls.Clear()
        placeholderRightTop.Controls.Clear()
        placeholderRightBottom.Controls.Clear()

        placeholderFileView.Visible = False
        placeholderFileDownload.Visible = False
        placeholderListing.Visible = False

        If Not IsNothing(placeholderContentRating) Then
            placeholderContentRating.Visible = False
        End If
        If Not IsNothing(placeholderComments) Then
            placeholderComments.Visible = False
        End If
        If Not IsNothing(placeholderPageTools) Then
            placeholderPageTools.Visible = False
        End If
        If Not IsNothing(placeholderSiteRss) Then
            placeholderSiteRss.Visible = False
        End If
        If Not IsNothing(placeholderStatPageViews) Then
            placeholderStatPageViews.Visible = False
        End If

        If Not IsNothing(placeholderPrint) Then
            placeholderPrint.Visible = False
        End If
        If Not IsNothing(placeholderPagesWithin) Then
            placeholderPagesWithin.Visible = False
        End If
        If Not IsNothing(placeholderSameLevelPages) Then
            placeholderSameLevelPages.Visible = False
        End If
        If Not IsNothing(placeholderPublishingInfo) Then
            placeholderPublishingInfo.Visible = False
        End If
        If Not IsNothing(placeholderCategoryInfo) Then
            placeholderCategoryInfo.Visible = False
        End If
        If Not IsNothing(placeholderOrderNow) Then
            placeholderOrderNow.Visible = False
        End If
        If Not IsNothing(placeholderArchives) Then
            placeholderArchives.Visible = False
        End If
        If Not IsNothing(placeholderCategoryList) Then
            placeholderCategoryList.Visible = False
        End If
        If Not IsNothing(placeholderSubscribe) Then
            placeholderSubscribe.Visible = False
        End If
    End Sub

    Private Function GetFileName() As String
        'Return Request.FilePath.Substring(Request.FilePath.LastIndexOf("/") + 1)

        Return HttpContext.Current.Items("_page")
    End Function

    Private Function GetAppFullPath() As String
        'returns:
        ' http://localhost/ 
        ' http://localhost/apppath/
        '(Selalu ada "/" di akhir)

        Dim sProtocol As String = Request.ServerVariables("SERVER_PORT_SECURE")
        If IsNothing(sProtocol) Or sProtocol = "0" Then
            sProtocol = "http://"
        Else
            sProtocol = "https://"
        End If

        Return sProtocol & sUrlAuthority & sAppPath
    End Function

    '************************************
    '   CANCEL / BACK
    '************************************
    Protected Sub btnBackToPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBackToPage.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnDeleteCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteCancel.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnMoveStep1Cancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMoveStep1Cancel.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnMoveStep2Cancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMoveStep2Cancel.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnCancel2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel2.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnCancel3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel3.Click
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnCancel4_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel4.Click
        Response.Redirect(GetFileName())
    End Sub


    '************************************
    '   ACTION
    '************************************

    Protected Function CreatePage() As Integer
        Dim nNewPageId As Integer

        Dim oContentManager As ContentManager = New ContentManager

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & txtFileName.Text
        Else
            sNewFileName = txtFileName.Text
        End If

        If oContentManager.IsContentExist(sNewFileName & ".aspx") Then
            'File exists
            lblFileExistsLabel.Visible = True
            PrepareNewPage()
            Exit Function
        Else
            lblFileExistsLabel.Visible = False
        End If

        Dim oContentNew As CMSContent = New CMSContent
        Dim oContent As CMSContent = New CMSContent
        With oContent
            .ChannelId = nChannelId
            .FileName = sNewFileName
            .Title = txtTitle.Text

            If Profile.UseWYSIWYG Then
                .Summary = txtSummary.Text
            Else
                .Summary = txtSummary2.Text
            End If

            'File Download
            If fileDownload.FileName <> "" Then
                .FileAttachment = "1_" & fileDownload.FileName
                .FileSize = fileDownload.PostedFile.ContentLength
            End If
            'File View
            If fileView.FileName <> "" Then
                .FileView = "1_" & fileView.FileName
            End If
            'File View Listing
            If fileViewListing.FileName <> "" Then
                .FileViewListing = "1_" & fileViewListing.FileName
            End If

            If Profile.UseWYSIWYG Then
                .ContentBody = txtBody.Text
            Else
                .ContentBody = txtBody2.Text
            End If

            If rdoDateAuto.Checked Then
                .DisplayDate = Now
            Else
                If chkTime.Checked Then
                    .DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, dropHour.SelectedValue, dropMinute.SelectedValue, 0)
                Else
                    .DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, 0, 0, 0)
                End If
            End If

            .PageType = 1
            .Owner = sUserName
            .LastUpdatedBy = sUserName
            .TemplateId = 1 'no problem, krn use_default_template=true
            .FileSize = fileDownload.PostedFile.ContentLength
            .LinkPlacement = hidLinkPlacement.Value
            .RootId = nRootId

            .IsListing = chkIsListing.Checked
            .ListingTemplateId = CInt(dropListingTemplates.SelectedValue)

            .IsLink = rdoLinkedPage.Checked
            If rdoLinkedPage.Checked Then
                .Link = txtLinkTo.Text
                If chkLinkNewWindow.Checked Then
                    .LinkTarget = "_blank"
                Else
                    .LinkTarget = "_self"
                End If
            End If
        End With
        If bIsListing And nListingProperty = 2 Then 'tdk di-order manual
            oContentNew = oContentManager.CreateContent(oContent, CInt(hidRefPage.Value), hidRefPos.Value, True)
        Else
            oContentNew = oContentManager.CreateContent(oContent, CInt(hidRefPage.Value), hidRefPos.Value)
        End If
        nNewPageId = oContentNew.PageId
        oContent = Nothing
        oContentManager = Nothing

        'File Download
        If fileDownload.FileName <> "" Then
            Dim sStorage As String = sResourcesInternal_FileDownload & "\files\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If
            fileDownload.SaveAs(sStorage & 1 & "_" & fileDownload.FileName)
        End If
        'File View
        If fileView.FileName <> "" Then
            Dim sStorage As String = sResourcesInternal_FileView & "\file_views\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If
            fileView.SaveAs(sStorage & 1 & "_" & fileView.FileName)
        End If
        'File View Listing
        If fileViewListing.FileName <> "" Then
            Dim sStorage As String = sResourcesInternal_FileViewListing & "\file_views_listing\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If

            'fileViewListing.SaveAs(sStorage & 1 & "_" & fileViewListing.FileName)
            ResizeFileViewListing(sStorage & 1 & "_" & fileViewListing.FileName, False, dropResize.SelectedValue)

        End If

        If bIsListing And bListingUseCategories Then
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "INSERT INTO listing_category_map (listing_category_id,page_id) VALUES (@listing_category_id,@page_id)"
            Dim i As Integer
            For i = 0 To dropListingCategory.Items.Count - 1
                If dropListingCategory.Items(i).Selected And Not dropListingCategory.Items(i).Value = "" Then
                    oCommand = New SqlCommand(sSQL)
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = CInt(dropListingCategory.Items(i).Value)
                    oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = oContentNew.PageId
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                End If
            Next
            oConn.Close()
            oConn = Nothing
        End If

        oContentNew = Nothing

        'Reset Editor Mode
        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False
        Return nNewPageId
    End Function

    Protected Sub btnCreatePage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreatePage.Click
        RedirectForLogin()

        If CreatePage() = 0 Then 'File Already Exists
            Exit Sub
        End If

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & txtFileName.Text
        Else
            sNewFileName = txtFileName.Text
        End If
        Response.Redirect(sNewFileName & ".aspx")
    End Sub

    Protected Sub btnCreatePage2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreatePage2.Click
        RedirectForLogin()

        If CreatePage() = 0 Then 'File Already Exists
            Exit Sub
        End If

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & txtFileName.Text
        Else
            sNewFileName = txtFileName.Text
        End If
        Response.Redirect(sNewFileName & ".aspx")
    End Sub

    Protected Sub btnCreateAndPublishPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreateAndPublishPage.Click
        RedirectForLogin()
        Dim nNewPageId As Integer
        nNewPageId = CreatePage()

        If nNewPageId = 0 Then 'File Already Exists
            Exit Sub
        End If

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nNewPageId)
        oContentManager.SubmitContent(nNewPageId, contentLatest.Version) 'Publish
        oContentManager = Nothing

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & txtFileName.Text
        Else
            sNewFileName = txtFileName.Text
        End If

        If bIsListing Then
            Response.Redirect(GetFileName())
        Else
            Response.Redirect(sNewFileName & ".aspx")
        End If
    End Sub

    Protected Sub btnCreateAndPublishPage2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreateAndPublishPage2.Click
        RedirectForLogin()
        Dim nNewPageId As Integer
        nNewPageId = CreatePage()

        If nNewPageId = 0 Then 'File Already Exists
            Exit Sub
        End If

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nNewPageId)
        oContentManager.SubmitContent(nNewPageId, contentLatest.Version) 'Publish
        oContentManager = Nothing

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & txtFileName.Text
        Else
            sNewFileName = txtFileName.Text
        End If

        If bIsListing Then
            Response.Redirect(GetFileName())
        Else
            Response.Redirect(sNewFileName & ".aspx")
        End If
    End Sub

    Protected Function SaveFile() As String
        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        'New file disimpan dalam format:
        'C:\[SecureStorage]\files\[page_id]\[version]_filename.doc

        'Delete previous file of the current version
        '(kecuali kalau page baru di-checkout shg previous file masih mengacu ke file versi sebelumnya)
        'Misal:
        'step 1: page_id / version / file_attachment /status : 9 / 2 / 2_tes.doc / published
        'step 2: Waktu di-checkout, create new record : 9 / 3 / 2_tes.doc / locked
        'step 3: Waktu file di-update, update record mjd: 9 / 3 / 3_tes.doc / locked (file 2_tes.doc tdk boleh di-delete karena dipake di versi sblmnya)
        'step 4: Waktu file di-update lagi (misal dgn nama file baru), record di-update mjd: 9 / 3 / 3_newtes.doc / locked (file 3_tes.doc perlu dihapus)

        Dim sCurrentFile As String = contentLatest.FileAttachment
        Dim sPreviousFile As String = ""

        If fileDownload.FileName = "" And chkDelDownload.Checked = False Then
            Return sCurrentFile
        End If

        Dim contentPrevious As CMSContent
        contentPrevious = oContentManager.GetContent(nPageId, contentLatest.Version - 1)
        If Not IsNothing(contentPrevious) Then
            sPreviousFile = contentPrevious.FileAttachment
        Else
            'Delete previous file of the current version
            If System.IO.File.Exists(sResourcesInternal_FileDownload & "\Files\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileDownload & "\Files\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        'Delete current file (krn mau di-update dgn yg baru)
        If sCurrentFile <> "" And sCurrentFile <> sPreviousFile Then
            If System.IO.File.Exists(sResourcesInternal_FileDownload & "\Files\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileDownload & "\Files\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        If chkDelDownload.Checked Then
            Return ""
        End If

        'Save new file
        Dim sStorage As String = sResourcesInternal_FileDownload & "\Files\" & nPageId & "\"
        Dim sFileName As String = fileDownload.FileName
        Dim sFileBytes As Integer = fileDownload.PostedFile.ContentLength
        If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
            My.Computer.FileSystem.CreateDirectory(sStorage)
        End If
        fileDownload.SaveAs(sStorage & contentLatest.Version & "_" & sFileName)

        Return contentLatest.Version & "_" & sFileName
    End Function

    Protected Function SaveFileView() As String
        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim sCurrentFile As String = contentLatest.FileView
        Dim sPreviousFile As String = ""

        If fileView.FileName = "" And chkDelView.Checked = False Then
            Return sCurrentFile
        End If

        Dim contentPrevious As CMSContent
        contentPrevious = oContentManager.GetContent(nPageId, contentLatest.Version - 1)
        If Not IsNothing(contentPrevious) Then
            sPreviousFile = contentPrevious.FileView
        Else
            'Delete previous file of the current version
            If System.IO.File.Exists(sResourcesInternal_FileView & "\file_views\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileView & "\file_views\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        'Delete current file (krn mau di-update dgn yg baru)
        If sCurrentFile <> "" And sCurrentFile <> sPreviousFile Then
            If System.IO.File.Exists(sResourcesInternal_FileView & "\file_views\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileView & "\file_views\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        If chkDelView.Checked Then
            Return ""
        End If

        'Save new file
        Dim sStorage As String = sResourcesInternal_FileView & "\file_views\" & nPageId & "\"
        Dim sFileName As String = fileView.FileName
        Dim sFileBytes As Integer = fileView.PostedFile.ContentLength
        If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
            My.Computer.FileSystem.CreateDirectory(sStorage)
        End If
        fileView.SaveAs(sStorage & contentLatest.Version & "_" & sFileName)

        Return contentLatest.Version & "_" & sFileName
    End Function

    Protected Function SaveFileViewListing() As String
        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim sCurrentFile As String = contentLatest.FileViewListing
        Dim sPreviousFile As String = ""

        If fileViewListing.FileName = "" And chkDelViewListing.Checked = False Then
            Return sCurrentFile
        End If

        Dim contentPrevious As CMSContent
        contentPrevious = oContentManager.GetContent(nPageId, contentLatest.Version - 1)
        If Not IsNothing(contentPrevious) Then
            sPreviousFile = contentPrevious.FileViewListing
        Else
            'Delete previous file of the current version
            If System.IO.File.Exists(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        'Delete current file (krn mau di-update dgn yg baru)
        If sCurrentFile <> "" And sCurrentFile <> sPreviousFile Then
            If System.IO.File.Exists(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile)
            End If
            'Thumbnail 100px - Delete
            sCurrentFile = sCurrentFile.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
            sCurrentFile = sCurrentFile.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")
            If System.IO.File.Exists(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile) Then
                System.IO.File.Delete(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\" & sCurrentFile)
            End If
        End If

        If chkDelViewListing.Checked Then
            Return ""
        End If

        'Save new file
        Dim sStorage As String = sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId & "\"
        Dim sFileName As String = fileViewListing.FileName
        Dim sFileBytes As Integer = fileViewListing.PostedFile.ContentLength
        If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
            My.Computer.FileSystem.CreateDirectory(sStorage)
        End If

        'fileViewListing.SaveAs(sStorage & contentLatest.Version & "_" & sFileName)
        ResizeFileViewListing(sStorage & contentLatest.Version & "_" & sFileName, False, dropResize.SelectedValue)

        Return contentLatest.Version & "_" & sFileName
    End Function

    Protected Sub ResizeFileViewListing(ByVal sLocation As String, Optional ByVal bIsQuick As Boolean = False, Optional ByVal nResize As Integer = 100)
        Dim nSizeThumb As Integer = 300
        Dim nJpegQuality As Integer = 100
        Dim nNewWidth As Integer
        Dim nNewHeight As Integer
        Dim imgOri As System.Drawing.Image

        If bIsQuick = False Then
            imgOri = System.Drawing.Image.FromStream(fileViewListing.PostedFile.InputStream)
        Else
            imgOri = System.Drawing.Image.FromStream(fileQuick.PostedFile.InputStream)
        End If

        nNewWidth = imgOri.Size.Width
        nNewHeight = imgOri.Size.Height
        If nNewWidth < nSizeThumb And nNewHeight < nSizeThumb Then
            'noop
        ElseIf nNewWidth > nNewHeight Then
            nNewHeight = nNewHeight * (nSizeThumb / nNewWidth)
            nNewWidth = nSizeThumb
        ElseIf nNewWidth < nNewHeight Then
            nNewWidth = nNewWidth * (nSizeThumb / nNewHeight)
            nNewHeight = nSizeThumb
        Else
            nNewWidth = nSizeThumb
            nNewHeight = nSizeThumb
        End If

        'Save Floating View
        Dim imgThumb As System.Drawing.Image = New System.Drawing.Bitmap(nNewWidth, nNewHeight)
        Dim gr As System.Drawing.Graphics = System.Drawing.Graphics.FromImage(imgThumb)
        gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic
        gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality
        gr.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
        gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
        gr.DrawImage(imgOri, 0, 0, nNewWidth, nNewHeight)

        Dim info() As System.Drawing.Imaging.ImageCodecInfo = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders()
        Dim ePars As System.Drawing.Imaging.EncoderParameters = New System.Drawing.Imaging.EncoderParameters(1)
        ePars.Param(0) = New System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, nJpegQuality)
        imgThumb.Save(sLocation, info(1), ePars)

        'Thumbnail (default=100px) - Save 
        If nResize <> 0 Then
            nSizeThumb = nResize
            If nNewWidth < nSizeThumb And nNewHeight < nSizeThumb Then
                'noop
            ElseIf nNewWidth > nNewHeight Then
                nNewHeight = nNewHeight * (nSizeThumb / nNewWidth)
                nNewWidth = nSizeThumb
            ElseIf nNewWidth < nNewHeight Then
                nNewWidth = nNewWidth * (nSizeThumb / nNewHeight)
                nNewHeight = nSizeThumb
            Else
                nNewWidth = nSizeThumb
                nNewHeight = nSizeThumb
            End If
            imgThumb = New System.Drawing.Bitmap(nNewWidth, nNewHeight)
            gr = System.Drawing.Graphics.FromImage(imgThumb)
            gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic
            gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality
            gr.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
            gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
            gr.DrawImage(imgOri, 0, 0, nNewWidth, nNewHeight)
            Dim info2() As System.Drawing.Imaging.ImageCodecInfo = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders()
            ePars = New System.Drawing.Imaging.EncoderParameters(1)
            ePars.Param(0) = New System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, nJpegQuality)
            sLocation = sLocation.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
            sLocation = sLocation.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")
            imgThumb.Save(sLocation, info2(1), ePars)

            imgThumb.Dispose()
            imgOri.Dispose()
        Else
            sLocation = sLocation.Replace(".jpg", "_.jpg").Replace(".gif", "_.gif").Replace(".png", "_.png")
            sLocation = sLocation.Replace(".JPG", "_.jpg").Replace(".GIF", "_.gif").Replace(".PNG", "_.png")
            fileViewListing.SaveAs(sLocation)
        End If

    End Sub

    Protected Sub btnRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRename.Click
        RedirectForLogin()

        Dim oContentManager As ContentManager = New ContentManager
        If oContentManager.IsContentExist(txtFileName2.Text & ".aspx") Then
            'File exists
            lblFileExistsLabel2.Visible = True
            PrepareRenamePage()
            Exit Sub
        Else
            lblFileExistsLabel2.Visible = False
        End If

        Dim content As CMSContent = New CMSContent
        content = oContentManager.GetWorkingCopy(nPageId)

        Dim contentLatest As CMSContent
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand

        'Update page_modules
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "UPDATE page_modules SET embed_in='" & txtFileName2.Text & ".aspx' WHERE embed_in=(Select file_name from pages where page_id=" & nPageId & " AND version=" & contentLatest.Version & ")"
        oCommand = New SqlCommand(sSQL, oConn)
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()
        oConn = Nothing

        'Update pages
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "UPDATE pages SET file_name='" & txtFileName2.Text & ".aspx' WHERE page_id=" & nPageId & " AND version=" & contentLatest.Version
        oCommand = New SqlCommand(sSQL, oConn)
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()
        oConn = Nothing

        content = Nothing
        contentLatest = Nothing
        oContentManager = Nothing

        Response.Redirect(txtFileName2.Text & ".aspx")
    End Sub

    Private Sub PageRedirect()
        Dim sRedirectTo As String = GetFileName()
        Dim bRedirectToParent As Boolean = False

        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader

        'If not exists, redirect to parent
        If Not oContentManager.IsContentExist(sRedirectTo) Then
            oDataReader = oContentManager.GetWorkingContentById(nParentId)
            If oDataReader.Read Then
                sRedirectTo = oDataReader("file_name").ToString
            Else
                'If parent not exists redirect to home (tdk mgk)
                sRedirectTo = sRootFile
            End If
            oDataReader.Close()
        End If
        oContentManager = Nothing

        Response.Redirect(sRedirectTo)
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        RedirectForLogin()
        Dim nDeleteReturn As Integer = 0
        Dim oContentManager As ContentManager = New ContentManager
        nDeleteReturn = oContentManager.DeleteContent(nPageId)
        oContentManager = Nothing

        Dim oConn As SqlConnection
        oConn = New SqlConnection(sConn)
        oConn.Open()
        Dim oCommand As SqlCommand
        oCommand = New SqlCommand("DELETE listing_category_map WHERE page_id=@page_id", oConn)
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.ExecuteNonQuery()
        oConn.Close()
        oConn = Nothing

        If nDeleteReturn = 0 Then
            'delete (not archived)

            If System.IO.Directory.Exists(sResourcesInternal_FileDownload & "\files\" & nPageId) Then
                System.IO.Directory.Delete(sResourcesInternal_FileDownload & "\files\" & nPageId, True)
            End If

            If System.IO.Directory.Exists(sResourcesInternal_FileView & "\file_views\" & nPageId) Then
                System.IO.Directory.Delete(sResourcesInternal_FileView & "\file_views\" & nPageId, True)
            End If

            If System.IO.Directory.Exists(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId) Then
                System.IO.Directory.Delete(sResourcesInternal_FileViewListing & "\file_views_listing\" & nPageId, True)
            End If
        End If

        'Redirect
        PageRedirect()
    End Sub

    Protected Sub btnMove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMove.Click
        RedirectForLogin()
        panelMoveStep1.Visible = False
        panelMoveStep2.Visible = False

        Dim oContentManager As ContentManager = New ContentManager
        If hidLinkPlacement.Value = "" Then
            oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), hidMoveRefPos.Value)
        Else
            oContentManager.MoveContent(nPageId, CInt(hidMoveRefPage.Value), hidMoveRefPos.Value, hidLinkPlacement.Value)
        End If
        oContentManager = Nothing

        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnMove3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMove3.Click
        RedirectForLogin()

        Dim oContentManager As ContentManager = New ContentManager
        Dim oDataReader As SqlDataReader

        Dim sTtl As String
        Dim sLnk As String
        Dim sFile As String = ""
        Dim nPgId As Integer
        Dim nPrId As Integer
        Dim nCPermission As Integer
        Dim sCName As String
        Dim bIsHdn As Boolean
        Dim bIsSys As Boolean

        Dim sLnk2 As String 'Published Version
        Dim sTtl2 As String = "" 'Published Version
        Dim bDisCollab As Boolean
        Dim dtLastUpdBy As DateTime
        Dim sStat As String = ""
        Dim sOwn As String = ""

        Dim nPgId_original As Integer

        If ddlMove.SelectedValue = "Before" Or ddlMove.SelectedValue = "After" Then

            'Check Parent Page 
            Dim oDataReader2 As SqlDataReader
            oDataReader2 = oContentManager.GetWorkingContentByFileName(txtFileNameMove.Text)
            If oDataReader2.Read() Then
                nPgId_original = oDataReader2("page_id").ToString
                nPrId = oDataReader2("parent_id").ToString
                oDataReader = oContentManager.GetWorkingContentById(nPrId)
            Else
                oDataReader = Nothing
                Response.Redirect(GetFileName())
            End If
            oDataReader2.Close()
        Else
            oDataReader = oContentManager.GetWorkingContentByFileName(txtFileNameMove.Text)
        End If

        Dim sPlace As String = ""
        Dim bShowMenu As Boolean = False

        Dim Item As String
        Dim sUserRoles As String = ""
        For Each Item In arrUserRoles
            sUserRoles += Item & " "
        Next

        If oDataReader.Read() Then
            nPgId = CInt(oDataReader("page_id"))
            nPrId = CInt(oDataReader("parent_id"))
            sFile = oDataReader("file_name").ToString()
            sLnk = HttpUtility.HtmlEncode(oDataReader("link_text").ToString)
            If sLnk <> "" Then
                sTtl = sLnk
            Else
                sTtl = HttpUtility.HtmlEncode(oDataReader("title").ToString)
            End If
            nCPermission = CInt(oDataReader("channel_permission"))
            sCName = oDataReader("channel_name").ToString
            bIsHdn = CBool(oDataReader("is_hidden"))
            bIsSys = CBool(oDataReader("is_system"))

            sPlace = oDataReader("link_placement").ToString

            If bUserLoggedIn Then 'user sudah pasti logged-in
                sLnk2 = HttpUtility.HtmlEncode(oDataReader("link_text2").ToString)
                If sLnk2 <> "" Then
                    sTtl2 = sLnk2
                Else
                    sTtl2 = HttpUtility.HtmlEncode(oDataReader("title2").ToString)
                End If
                bDisCollab = CBool(oDataReader("disable_collaboration"))
                dtLastUpdBy = oDataReader("last_updated_date")
                sStat = oDataReader("status").ToString
                sOwn = oDataReader("owner").ToString
            End If

            'Authorize User to Show/Hide a Menu Link
            'Dim bShowMenu As Boolean = False
            Dim nShowMenu As Integer = 0
            If bUserLoggedIn Then  'user sudah pasti logged-in
                nShowMenu = ShowLink2(nCPermission, sCName, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn, bUserLoggedIn, _
                    bDisCollab, sOwn, dtLastUpdBy, sStat) 'yus
                If nShowMenu = 0 Then 'Do not show
                    bShowMenu = False
                ElseIf nShowMenu = 1 Then 'Show Working (Title/Link Text)
                    bShowMenu = True
                Else 'nShowMenu=2 'Show Published (Title/Link Text)
                    If sTtl2.ToString = "" Then 'kalau published version blm ada => bShowLink = False
                        bShowMenu = False
                    Else
                        bShowMenu = True
                        sTtl = sTtl2
                    End If
                End If
            Else
                bShowMenu = ShowLink(nCPermission, _
                    oDataReader("published_start_date"), _
                    oDataReader("published_end_date"), _
                    bIsSys, bIsHdn) 'yus
            End If

            If (sUserRoles.Contains(sCName & " Authors") Or bIsAdministrator) Then
                If bShowMenu Then
                    If txtFileNameMove.Text.ToLower = "default.aspx" Then
                        sPlace = ddlMove2.SelectedValue
                        'sPlace: main, top, bottom
                        oContentManager.MoveContent(nPageId, 1, "Under", sPlace)
                    ElseIf ddlMove.SelectedValue = "Before" Or ddlMove.SelectedValue = "After" Then
                        'ddlMove.SelectedValue: Before, After
                        oContentManager.MoveContent(nPageId, nPgId_original, ddlMove.SelectedValue)
                    Else
                        'ddlMove.SelectedValue: Under
                        oContentManager.MoveContent(nPageId, nPgId, ddlMove.SelectedValue)
                    End If
                End If
            End If

        End If
        oDataReader.Close()
        oContentManager = Nothing

        Response.Redirect(GetFileName())
    End Sub

    Protected Sub lnkForceUnlock_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkForceUnlock.Click
        RedirectForLogin()
        Dim oContentManager As ContentManager = New ContentManager
        oContentManager.UnlockContent(nPageId, nVersion)
        oContentManager = Nothing
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub lnkUnlock_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnlock.Click
        RedirectForLogin()
        Dim oContentManager As ContentManager = New ContentManager
        oContentManager.UnlockContent(nPageId, nVersion)
        oContentManager = Nothing
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub lnkApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApprove.Click
        RedirectForLogin()
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager
        oWorkflowManager.EditorApprove(sUserName, nPageId)
        oWorkflowManager = Nothing

        'Redirect
        PageRedirect()
    End Sub

    Protected Sub lnkDecline_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDecline.Click
        RedirectForLogin()
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager
        oWorkflowManager.EditorReject(sUserName, nPageId)
        oWorkflowManager = Nothing
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub lnkApprove2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApprove2.Click
        RedirectForLogin()
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager
        oWorkflowManager.PublisherApprove(sUserName, nPageId)
        oWorkflowManager = Nothing

        'Redirect
        PageRedirect()
    End Sub

    Protected Sub lnkDecline2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDecline2.Click
        RedirectForLogin()
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager
        oWorkflowManager.PublisherReject(sUserName, nPageId)
        oWorkflowManager = Nothing
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub lnkAdvance(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()

        Dim sTitleTmp As String = txtTitle.Text
        Dim sBodyTmp As String = txtBody.Text
        Dim sFileTmp As String = txtFileName.Text
        Dim sSummary As String = txtSummary.Text

        If hidEditorPurpose.Value = "EditExisting" Then
            rdoSavingOptions.SelectedValue = 1
            btnSave_Click(sender, e)
        ElseIf hidEditorPurpose.Value = "CreateNew" Then
            lnkNewPage_Click(sender, Nothing)
        ElseIf hidEditorPurpose.Value = "CreateNewTop" Then

            PrepareNewPage()
            hidLinkPlacement.Value = "top" 'Create under Home, but use 'top' (not 'main')
            PrepareNewPageData("top")
            hidEditorPurpose.Value = "CreateNewTop"

        ElseIf hidEditorPurpose.Value = "CreateNewBottom" Then

            PrepareNewPage()
            hidLinkPlacement.Value = "bottom" 'Create under Home, but use 'bottom' (not 'main')
            PrepareNewPageData("bottom")
            hidEditorPurpose.Value = "CreateNewBottom"

        End If
        lnkAdvEdit.Visible = False
        lnkQuickEdit.Visible = True
        lnkAdvEdit2.Visible = False

        txtBody.EditorType = InnovaStudio.EditorTypeEnum.Advance
        hidEditorType.Value = "advanced"

        lnkQuickEdit2.Visible = True
        txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Advance
        txtSummary.Text = sSummary

        txtTitle.Text = sTitleTmp
        txtBody.Text = sBodyTmp
        txtFileName.Text = sFileTmp
    End Sub

    Protected Sub lnkQuick(ByVal sender As Object, ByVal e As System.EventArgs)
        RedirectForLogin()

        Dim sTitleTmp As String = txtTitle.Text
        Dim sBodyTmp As String = txtBody.Text
        Dim sFileTmp As String = txtFileName.Text
        Dim sSummary As String = txtSummary.Text

        If hidEditorPurpose.Value = "EditExisting" Then
            rdoSavingOptions.SelectedValue = 1
            btnSave_Click(sender, e)
        ElseIf hidEditorPurpose.Value = "CreateNew" Then
            lnkNewPage_Click(sender, Nothing)
        ElseIf hidEditorPurpose.Value = "CreateNewTop" Then

            PrepareNewPage()
            hidLinkPlacement.Value = "top" 'Create under Home, but use 'top' (not 'main')
            PrepareNewPageData("top")
            hidEditorPurpose.Value = "CreateNewTop"

        ElseIf hidEditorPurpose.Value = "CreateNewBottom" Then

            PrepareNewPage()
            hidLinkPlacement.Value = "bottom" 'Create under Home, but use 'bottom' (not 'main')
            PrepareNewPageData("bottom")
            hidEditorPurpose.Value = "CreateNewBottom"

        End If
        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False

        txtBody.EditorType = InnovaStudio.EditorTypeEnum.Quick
        hidEditorType.Value = "quick"

        lnkAdvEdit2.Visible = True
        lnkQuickEdit2.Visible = False
        txtSummary.EditorType = InnovaStudio.EditorTypeEnum.Quick
        txtSummary.Text = sSummary

        txtTitle.Text = sTitleTmp
        txtBody.Text = sBodyTmp
        txtFileName.Text = sFileTmp
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim content As New CMSContent(nPageId, contentLatest.Version)
        content.Title = txtTitle.Text
        If Profile.UseWYSIWYG Then
            content.Summary = txtSummary.Text
        Else
            content.Summary = txtSummary2.Text
        End If

        'File Download
        Dim sFile As String = SaveFile()
        content.FileAttachment = sFile
        If sFile = "" Then
            content.FileSize = 0 'file deleted
        Else
            If fileDownload.FileName = "" Then
                content.FileSize = nFileSize 'no change
            Else
                content.FileSize = fileDownload.PostedFile.ContentLength
            End If
        End If
        'File View
        Dim sFileView As String = SaveFileView()
        content.FileView = sFileView
        'File View Listing
        Dim sFileViewListing As String = SaveFileViewListing()
        content.FileViewListing = sFileViewListing

        If content.FileAttachment <> "" Or content.FileView <> "" Or content.FileViewListing <> "" Then
            chkAddFile.Checked = True
            chkAddFile.Enabled = False
            tblAddFile.Style.Add("display", "block")
        Else
            chkAddFile.Checked = False
            chkAddFile.Enabled = True
            tblAddFile.Style.Add("display", "none")
        End If

        If Profile.UseWYSIWYG Then
            content.ContentBody = txtBody.Text
        Else
            content.ContentBody = txtBody2.Text
        End If

        If rdoDateAuto.Checked Then
            content.DisplayDate = Now
        Else
            If chkTime.Checked Then
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, dropHour.SelectedValue, dropMinute.SelectedValue, 0)
            Else
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, 0, 0, 0)
            End If
        End If

        content.Owner = sUserName

        If bParentIsListing And bParentListingUseCategories Then
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "DELETE FROM listing_category_map WHERE page_id=@page_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            sSQL = "INSERT INTO listing_category_map (listing_category_id,page_id) VALUES (@listing_category_id,@page_id)"
            Dim i As Integer
            For i = 0 To dropListingCategory.Items.Count - 1
                If dropListingCategory.Items(i).Selected And Not dropListingCategory.Items(i).Value = "" Then
                    oCommand = New SqlCommand(sSQL)
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = CInt(dropListingCategory.Items(i).Value)
                    oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                End If
            Next
            oCommand.Dispose()
            oConn.Close()
            oConn = Nothing
        End If

        content.IsListing = chkIsListing.Checked

        content.ListingTemplateId = CInt(dropListingTemplates.SelectedValue)

        content.IsLink = bIsLink
        If bIsLink Then
            content.Link = txtLinkTo.Text
            If chkLinkNewWindow.Checked Then
                content.LinkTarget = "_blank"
            Else
                content.LinkTarget = "_self"
            End If
        End If

        Select Case rdoSavingOptions.SelectedValue
            Case "1" 'Save and Continue Edit
                'PrepareEditPage()
                'oContentManager.SaveContent(content)
                oContentManager.SaveContent(content)
                LoadPageData()
                PrepareEditPage()
            Case "2" 'Finish and Unlock (back to page view)
                oContentManager.SaveContent(content, True)
            Case "3" 'Finish and Lock (for later editing)
                oContentManager.SaveContent(content)
            Case "4" 'Publish
                oContentManager.SaveContent(content)
                'oContentManager.SubmitContent(nPageId, contentLatest.Version, True)
                oContentManager.SubmitContent(nPageId, contentLatest.Version)
        End Select

        contentLatest = Nothing
        oContentManager = Nothing
        content = Nothing

        If Not rdoSavingOptions.SelectedValue = 1 Then
            Response.Redirect(GetFileName())
        Else
            'File Download
            If sFile <> "" Then
                lblDownloadFileName.Text = sFile.Substring(sFile.IndexOf("_") + 1)
                Dim sExt As String = (sFile.Substring(sFile.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litDownloadThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileattach.aspx?file=" & nPageId & "\" & sFile & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litDownloadThumb.Text = ""
                End If
                chkDelDownload.Visible = True
            Else
                lblDownloadFileName.Text = ""
                litDownloadThumb.Text = ""
                chkDelDownload.Visible = False
            End If
            chkDelDownload.Checked = False

            'File View
            If sFileView <> "" Then
                lblViewFileName.Text = sFileView.Substring(sFileView.IndexOf("_") + 1)
                Dim sExt As String = (sFileView.Substring(sFileView.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileview.aspx?file=" & nPageId & "\" & sFileView & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewThumb.Text = ""
                End If
                chkDelView.Visible = True
            Else
                lblViewFileName.Text = ""
                litViewThumb.Text = ""
                chkDelView.Visible = False
            End If
            chkDelView.Checked = False

            'File View Listing
            If sFileViewListing <> "" Then
                lblViewListingFileName.Text = sFileViewListing.Substring(sFileViewListing.IndexOf("_") + 1)
                Dim sExt As String = (sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1)).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                    litViewListingThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileview.aspx?file=" & nPageId & "\" & sFileViewListing & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
                Else
                    litViewListingThumb.Text = ""
                End If
                chkDelViewListing.Visible = True
            Else
                lblViewListingFileName.Text = ""
                litViewListingThumb.Text = ""
                chkDelViewListing.Visible = False
            End If
            chkDelViewListing.Checked = False
        End If

        'Reset Editor Mode
        'lnkAdvEdit.Visible = True
        'lnkQuickEdit.Visible = False

    End Sub

    Protected Sub btnSave2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave2.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim content As New CMSContent(nPageId, contentLatest.Version)
        content.Title = txtTitle.Text
        If Profile.UseWYSIWYG Then
            content.Summary = txtSummary.Text
        Else
            content.Summary = txtSummary2.Text
        End If

        'File Download
        Dim sFile As String = SaveFile()
        content.FileAttachment = sFile
        If sFile = "" Then
            content.FileSize = 0 'file deleted
        Else
            If fileDownload.FileName = "" Then
                content.FileSize = nFileSize 'no change
            Else
                content.FileSize = fileDownload.PostedFile.ContentLength
            End If
        End If
        'File View
        Dim sFileView As String = SaveFileView()
        content.FileView = sFileView
        'File View Listing
        Dim sFileViewListing As String = SaveFileViewListing()
        content.FileViewListing = sFileViewListing

        If content.FileAttachment <> "" Or content.FileView <> "" Or content.FileViewListing <> "" Then
            chkAddFile.Checked = True
            chkAddFile.Enabled = False
            tblAddFile.Style.Add("display", "block")
        Else
            chkAddFile.Checked = False
            chkAddFile.Enabled = True
            tblAddFile.Style.Add("display", "none")
        End If

        If Profile.UseWYSIWYG Then
            content.ContentBody = txtBody.Text
        Else
            content.ContentBody = txtBody2.Text
        End If

        If rdoDateAuto.Checked Then
            content.DisplayDate = Now
        Else
            If chkTime.Checked Then
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, dropHour.SelectedValue, dropMinute.SelectedValue, 0)
            Else
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, 0, 0, 0)
            End If
        End If

        content.Owner = sUserName

        If bParentIsListing And bParentListingUseCategories Then
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "DELETE FROM listing_category_map WHERE page_id=@page_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            sSQL = "INSERT INTO listing_category_map (listing_category_id,page_id) VALUES (@listing_category_id,@page_id)"
            Dim i As Integer
            For i = 0 To dropListingCategory.Items.Count - 1
                If dropListingCategory.Items(i).Selected And Not dropListingCategory.Items(i).Value = "" Then
                    oCommand = New SqlCommand(sSQL)
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = CInt(dropListingCategory.Items(i).Value)
                    oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                End If
            Next
            oCommand.Dispose()
            oConn.Close()
            oConn = Nothing
        End If

        content.IsListing = chkIsListing.Checked

        content.ListingTemplateId = CInt(dropListingTemplates.SelectedValue)

        content.IsLink = bIsLink
        If bIsLink Then
            content.Link = txtLinkTo.Text
            If chkLinkNewWindow.Checked Then
                content.LinkTarget = "_blank"
            Else
                content.LinkTarget = "_self"
            End If
        End If

        'Save and Continue Edit
        'PrepareEditPage() 'Ditaruh sblm save utk mempertahankan viewstate
        'oContentManager.SaveContent(content)
        oContentManager.SaveContent(content)
        LoadPageData()
        PrepareEditPage()

        'File Download
        If sFile <> "" Then
            lblDownloadFileName.Text = sFile.Substring(sFile.IndexOf("_") + 1)
            Dim sExt As String = (sFile.Substring(sFile.LastIndexOf(".") + 1)).ToLower
            If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                litDownloadThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileattach.aspx?file=" & nPageId & "\" & sFile & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
            Else
                litDownloadThumb.Text = ""
            End If
            chkDelDownload.Visible = True
        Else
            lblDownloadFileName.Text = ""
            litDownloadThumb.Text = ""
            chkDelDownload.Visible = False
        End If
        chkDelDownload.Checked = False

        'File View
        If sFileView <> "" Then
            lblViewFileName.Text = sFileView.Substring(sFileView.IndexOf("_") + 1)
            Dim sExt As String = (sFileView.Substring(sFileView.LastIndexOf(".") + 1)).ToLower
            If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                litViewThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_fileview.aspx?file=" & nPageId & "\" & sFileView & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
            Else
                litViewThumb.Text = ""
            End If
            chkDelView.Visible = True
        Else
            lblViewFileName.Text = ""
            litViewThumb.Text = ""
            chkDelView.Visible = False
        End If
        chkDelView.Checked = False

        'File View Listing
        If sFileViewListing <> "" Then
            lblViewListingFileName.Text = sFileViewListing.Substring(sFileViewListing.IndexOf("_") + 1)
            Dim sExt As String = (sFileViewListing.Substring(sFileViewListing.LastIndexOf(".") + 1)).ToLower
            If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                litViewListingThumb.Text = "<img alt="""" title="""" src=""systems/image_thumbnail3_listview.aspx?file=" & nPageId & "\" & sFileViewListing & "&amp;Size=100&amp;Quality=90"" border=""0"" />"
            Else
                litViewListingThumb.Text = ""
            End If
            chkDelViewListing.Visible = True
        Else
            lblViewListingFileName.Text = ""
            litViewListingThumb.Text = ""
            chkDelViewListing.Visible = False
        End If
        chkDelViewListing.Checked = False

        oContentManager = Nothing
        contentLatest = Nothing
        content = Nothing

        'Reset Editor Mode
        'lnkAdvEdit.Visible = True
        'lnkQuickEdit.Visible = False
    End Sub

    Protected Sub btnSaveAndFinish_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveAndFinish.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim content As New CMSContent(nPageId, contentLatest.Version)
        content.Title = txtTitle.Text
        If Profile.UseWYSIWYG Then
            content.Summary = txtSummary.Text
        Else
            content.Summary = txtSummary2.Text
        End If

        'File Download
        Dim sFile As String = SaveFile()
        content.FileAttachment = sFile
        If sFile = "" Then
            content.FileSize = 0 'file deleted
        Else
            If fileDownload.FileName = "" Then
                content.FileSize = nFileSize 'no change
            Else
                content.FileSize = fileDownload.PostedFile.ContentLength
            End If
        End If
        'File View
        Dim sFileView As String = SaveFileView()
        content.FileView = sFileView
        'File View Listing
        Dim sFileViewListing As String = SaveFileViewListing()
        content.FileViewListing = sFileViewListing

        If Profile.UseWYSIWYG Then
            content.ContentBody = txtBody.Text
        Else
            content.ContentBody = txtBody2.Text
        End If

        If rdoDateAuto.Checked Then
            content.DisplayDate = Now
        Else
            If chkTime.Checked Then
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, dropHour.SelectedValue, dropMinute.SelectedValue, 0)
            Else
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, 0, 0, 0)
            End If
        End If

        content.Owner = sUserName

        If bParentIsListing And bParentListingUseCategories Then
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "DELETE FROM listing_category_map WHERE page_id=@page_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            sSQL = "INSERT INTO listing_category_map (listing_category_id,page_id) VALUES (@listing_category_id,@page_id)"
            Dim i As Integer
            For i = 0 To dropListingCategory.Items.Count - 1
                If dropListingCategory.Items(i).Selected And Not dropListingCategory.Items(i).Value = "" Then
                    oCommand = New SqlCommand(sSQL)
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = CInt(dropListingCategory.Items(i).Value)
                    oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                End If
            Next
            oCommand.Dispose()
            oConn.Close()
            oConn = Nothing
        End If

        content.IsListing = chkIsListing.Checked

        content.ListingTemplateId = CInt(dropListingTemplates.SelectedValue)

        content.IsLink = bIsLink
        If bIsLink Then
            content.Link = txtLinkTo.Text
            If chkLinkNewWindow.Checked Then
                content.LinkTarget = "_blank"
            Else
                content.LinkTarget = "_self"
            End If
        End If

        'Finish and Unlock (back to page view)
        oContentManager.SaveContent(content, True)

        oContentManager = Nothing
        contentLatest = Nothing
        content = Nothing

        'Reset Editor Mode
        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False

        'If bParentIsListing Then
        '    Response.Redirect(sParentFileName)
        'Else
        '    Response.Redirect(GetFileName())
        'End If
        Response.Redirect(GetFileName())

    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(nPageId)

        Dim content As New CMSContent(nPageId, contentLatest.Version)
        content.Title = txtTitle.Text
        If Profile.UseWYSIWYG Then
            content.Summary = txtSummary.Text
        Else
            content.Summary = txtSummary2.Text
        End If

        'File Download
        Dim sFile As String = SaveFile()
        content.FileAttachment = sFile
        If sFile = "" Then
            content.FileSize = 0 'file deleted
        Else
            If fileDownload.FileName = "" Then
                content.FileSize = nFileSize 'no change
            Else
                content.FileSize = fileDownload.PostedFile.ContentLength
            End If
        End If
        'File View
        Dim sFileView As String = SaveFileView()
        content.FileView = sFileView
        'File View Listing
        Dim sFileViewListing As String = SaveFileViewListing()
        content.FileViewListing = sFileViewListing

        If Profile.UseWYSIWYG Then
            content.ContentBody = txtBody.Text
        Else
            content.ContentBody = txtBody2.Text
        End If

        If rdoDateAuto.Checked Then
            content.DisplayDate = Now
        Else
            If chkTime.Checked Then
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, dropHour.SelectedValue, dropMinute.SelectedValue, 0)
            Else
                content.DisplayDate = New DateTime(dropNewsYear.SelectedValue, dropNewsMonth.SelectedValue, dropNewsDay.SelectedValue, 0, 0, 0)
            End If
        End If

        content.Owner = sUserName

        If bParentIsListing And bParentListingUseCategories Then
            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "DELETE FROM listing_category_map WHERE page_id=@page_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            sSQL = "INSERT INTO listing_category_map (listing_category_id,page_id) VALUES (@listing_category_id,@page_id)"
            Dim i As Integer
            For i = 0 To dropListingCategory.Items.Count - 1
                If dropListingCategory.Items(i).Selected And Not dropListingCategory.Items(i).Value = "" Then
                    oCommand = New SqlCommand(sSQL)
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = CInt(dropListingCategory.Items(i).Value)
                    oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                End If
            Next
            oCommand.Dispose()
            oConn.Close()
            oConn = Nothing
        End If

        content.IsListing = chkIsListing.Checked

        content.ListingTemplateId = CInt(dropListingTemplates.SelectedValue)

        content.IsLink = bIsLink
        If bIsLink Then
            content.Link = txtLinkTo.Text
            If chkLinkNewWindow.Checked Then
                content.LinkTarget = "_blank"
            Else
                content.LinkTarget = "_self"
            End If
        End If

        'Publish
        oContentManager.SaveContent(content)
        'oContentManager.SubmitContent(nPageId, contentLatest.Version, True)
        oContentManager.SubmitContent(nPageId, contentLatest.Version)

        oContentManager = Nothing
        contentLatest = Nothing
        content = Nothing

        'Reset Editor Mode
        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False

        'If bParentIsListing Then
        '    Response.Redirect(sParentFileName)
        'Else
        '    Response.Redirect(GetFileName())
        'End If
        Response.Redirect(GetFileName())

    End Sub


    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sSearch As String = ""
        sSearch = Server.UrlEncode(txtSearch.Text)
        Response.Redirect("~/" & sLinkSearch & "?q=" & sSearch)
    End Sub


    '************************************
    '   Used For Login
    '************************************
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = sLinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub


    Protected Sub btnModulePosition_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnModulePosition.Click
        Dim sPlaceholder As String = hidPlaceHolder.Value
        Dim nPageModuleId As Integer = CInt(hidModule.Value)
        Dim sMove As String = hidMove.Value

        Dim oConn As SqlConnection
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim oCommand As SqlCommand

        If sMove = "" Then
            oCommand = New SqlCommand("delete page_modules where page_module_id=@page_module_id")
            oCommand.Connection = oConn
            oCommand.Parameters.Add("@page_module_id", SqlDbType.NVarChar).Value = nPageModuleId
            oCommand.ExecuteNonQuery()
        End If

        oCommand = New SqlCommand("EXEC advcms_ModuleSorting @file,@placeholder")
        oCommand.Parameters.Add("@file", SqlDbType.NVarChar).Value = GetFileName()
        oCommand.Parameters.Add("@placeholder", SqlDbType.NVarChar).Value = sPlaceholder
        oCommand.Connection = oConn
        Dim oDataReader As SqlDataReader
        oDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)

        Dim oConn2 As SqlConnection
        oConn2 = New SqlConnection(sConn)
        oConn2.Open()
        oCommand = New SqlCommand("delete page_module_sorting where file_name=@file_name and placeholder_id=@placeholder_id")
        oCommand.Connection = oConn2
        oCommand.Parameters.Add("@file_name", SqlDbType.NVarChar).Value = GetFileName()
        oCommand.Parameters.Add("@placeholder_id", SqlDbType.NVarChar).Value = sPlaceholder
        oCommand.ExecuteNonQuery()

        Dim nSort As Integer = 2 'Starts from 2, incremented by 2
        Dim nSortTarget As Integer
        Do While oDataReader.Read
            oCommand = New SqlCommand("insert into page_module_sorting (page_module_id,file_name,placeholder_id,sorting) VALUES (@id,@file_name,@placeholder_id,@sorting)")
            oCommand.Connection = oConn2
            oCommand.Parameters.Add("@id", SqlDbType.Int).Value = CInt(oDataReader("page_module_id"))
            oCommand.Parameters.Add("@file_name", SqlDbType.NVarChar).Value = GetFileName()
            oCommand.Parameters.Add("@placeholder_id", SqlDbType.NVarChar).Value = sPlaceholder
            oCommand.Parameters.Add("@sorting", SqlDbType.Int).Value = nSort
            oCommand.ExecuteNonQuery()
            If nPageModuleId = CInt(oDataReader("page_module_id")) Then
                nSortTarget = nSort
            End If
            nSort = nSort + 2
        Loop
        oDataReader.Close()

        'Move
        If Not sMove = "" Then
            oCommand = New SqlCommand("update page_module_sorting set sorting=@sorting_new where page_module_id=@page_module_id AND file_name=@file_name and placeholder_id=@placeholder_id")
            oCommand.Connection = oConn2
            oCommand.Parameters.Add("@page_module_id", SqlDbType.NVarChar).Value = nPageModuleId
            oCommand.Parameters.Add("@file_name", SqlDbType.NVarChar).Value = GetFileName()
            oCommand.Parameters.Add("@placeholder_id", SqlDbType.NVarChar).Value = sPlaceholder

            If sMove = "up" Then
                oCommand.Parameters.Add("@sorting_new", SqlDbType.NVarChar).Value = nSortTarget - 3
                oCommand.ExecuteNonQuery()
            ElseIf sMove = "down" Then
                oCommand.Parameters.Add("@sorting_new", SqlDbType.NVarChar).Value = nSortTarget + 3
                oCommand.ExecuteNonQuery()
            End If
        End If

        oConn.Close()
        oConn2.Close()

        'clear
        hidPlaceHolder.Value = ""
        hidModule.Value = ""

        Response.Redirect(GetFileName())
    End Sub

    Protected Sub ShowWorkspace()
        If bUserLoggedIn Then
            'Float Scripts
            If bIsAdministrator Then
                placeholderScript.Controls.Add(New LiteralControl("<script language=""javascript"">var float=new ICFloat();float.add(""popWorkspace"");float.add(""popAdmin"");</script>"))
            Else
                placeholderScript.Controls.Add(New LiteralControl("<script language=""javascript"">var float=new ICFloat();float.add(""popWorkspace"");</script>"))
            End If

            panelPopWorkspace.Visible = True
        Else
            panelPopWorkspace.Visible = False
            Exit Sub
        End If

        Dim sLinkWorkspaceAccount As String = "account.aspx"
        Dim sLinkWorkspacePreferences As String = "preferences.aspx"
        Dim sLinkWorkspacePages As String = "pages.aspx"
        Dim sLinkWorkspaceResources As String = "resources.aspx"
        Dim sLinkWorkspaceApproval As String = "approval.aspx"
        Dim sLinkWorkspaceEvents As String = "events.aspx"
        Dim sLinkWorkspacePolls As String = "polls.aspx"
        Dim sLinkWorkspaceNewsletters As String = "newsletters.aspx"
        Dim sLinkWorkspaceShop As String = "shop.aspx"
        Dim sLinkCustomListing As String = "custom_listing.aspx"

        If Not nRootId = 1 Then sLinkWorkspaceAccount = "account_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspacePreferences = "preferences_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspacePages = "pages_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspaceResources = "resources_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspaceApproval = "approval_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspaceEvents = "events_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspacePolls = "polls_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspaceNewsletters = "newsletters_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkWorkspaceShop = "shop_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkCustomListing = "custom_listing_" & nRootId & ".aspx"

        lnkAccount.NavigateUrl = sLinkWorkspaceAccount
        lnkPreferences.NavigateUrl = sLinkWorkspacePreferences
        lnkPages.NavigateUrl = sLinkWorkspacePages
        lnkResources.NavigateUrl = sLinkWorkspaceResources
        lnkApproval.NavigateUrl = sLinkWorkspaceApproval
        lnkEvents.NavigateUrl = sLinkWorkspaceEvents
        lnkPolls.NavigateUrl = sLinkWorkspacePolls
        lnkNewsletters.NavigateUrl = sLinkWorkspaceNewsletters
        lnkShop.NavigateUrl = sLinkWorkspaceShop
        lnkCustomListing.NavigateUrl = sLinkCustomListing

        Dim bShowResourceLink As Boolean = False
        Dim bShowApprovalLink As Boolean = False
        Dim bShowPagesLink As Boolean = False
        Dim bShowPrefLink As Boolean = False
        Dim bShowPollLink As Boolean = False
        Dim bShowEventLink As Boolean = False
        Dim bShowNewsletterLink As Boolean = False
        Dim bShowShopLink As Boolean = False
        Dim bShowCustomListingLink As Boolean = False

        Dim Item As String
        For Each Item In arrUserRoles
            If Item.Contains("Authors") Then
                If Item.Substring(Item.IndexOf("Authors")) = "Authors" Then
                    bShowPagesLink = True
                    bShowPrefLink = True
                    'bShowEventLink = True
                End If
            End If

            If Item.Contains("Editors") Then
                If Item.Substring(Item.IndexOf("Editors")) = "Editors" Then
                    bShowApprovalLink = True
                    bShowPagesLink = True
                    'bShowEventLink = True
                End If
            End If

            If Item.Contains("Publishers") Then
                If Item.Substring(Item.IndexOf("Publishers")) = "Publishers" Then
                    bShowApprovalLink = True
                    bShowPagesLink = True
                    'bShowEventLink = True
                End If
            End If

            If Item.Contains("Resource Managers") Then
                If Item.Substring(Item.IndexOf("Resource Managers")) = "Resource Managers" Then
                    bShowResourceLink = True
                    'bShowPagesLink = True
                    'bShowEventLink = True
                End If
            End If

            If Item = "Polls Managers" Then
                bShowPollLink = True
            End If

            If Item = "Events Managers" Then
                bShowEventLink = True
            End If

            If Item = "Newsletters Managers" Then
                bShowNewsletterLink = True
            End If

            If Item = "Administrators" Then
                bShowApprovalLink = True
                bShowResourceLink = True
                bShowPagesLink = True
                bShowPrefLink = True
                bShowPollLink = True
                bShowEventLink = True
                bShowNewsletterLink = True
                bShowShopLink = True
                bShowCustomListingLink = True
            End If
        Next

        If Not bShowApprovalLink Then
            idApproval.Visible = False
        End If
        If Not bShowResourceLink Then
            idResources.Visible = False
        End If
        If Not bShowPagesLink Then
            idPages.Visible = False
        End If
        If Not bShowPrefLink Then
            idPreferences.Visible = False
        End If
        If Not bShowPollLink Then
            idPolls.Visible = False
        End If
        If Not bShowEventLink Then
            idEvents.Visible = False
        End If
        If Not bShowNewsletterLink Then
            idNewsletters.Visible = False
        End If
        If Not bShowShopLink Then
            idShop.Visible = False
        End If
        If Not bShowCustomListingLink Then
            idCustomListing.Visible = False
        End If

        'Hide Shop
        If ConfigurationManager.AppSettings("Shop") = "no" Then
            idShop.Visible = False
        End If

        'Hide Events
        idEvents.Visible = False
    End Sub

    Protected Sub ShowAdmin()
        If bUserLoggedIn Then
            If bIsAdministrator Then
                panelPopAdmin.Visible = True
            Else
                panelPopAdmin.Visible = False
                Exit Sub
            End If
        Else
            panelPopAdmin.Visible = False
            Exit Sub
        End If

        Dim sLinkAdminChannels As String = "admin_channels.aspx"
        Dim sLinkAdminUsers As String = "admin_users.aspx"
        Dim sLinkAdminRegistrationSettings As String = "registration_settings.aspx"
        Dim sLinkAdminTemplates As String = "admin_templates.aspx"
        Dim sLinkAdminModules As String = "admin_modules.aspx"
        Dim sLinkAdminLocalization As String = "admin_localization.aspx"

        If Not nRootId = 1 Then sLinkAdminChannels = "admin_channels_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdminUsers = "admin_users_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdminRegistrationSettings = "registration_settings_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdminTemplates = "admin_templates_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdminModules = "admin_modules_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkAdminLocalization = "admin_localization_" & nRootId & ".aspx"

        lnkChannels.NavigateUrl = sLinkAdminChannels
        lnkUsers.NavigateUrl = sLinkAdminUsers
        lnkRegistrationSettings.NavigateUrl = sLinkAdminRegistrationSettings
        lnkTemplates.NavigateUrl = sLinkAdminTemplates
        lnkModules.NavigateUrl = sLinkAdminModules
        lnkLocalization.NavigateUrl = sLinkAdminLocalization
    End Sub

    Protected Sub lnkAddNewTop_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddNewTop.Click
        Response.Redirect(sRootFile & "?action=top")
    End Sub

    Protected Sub lnkAddNewBottom_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddNewBottom.Click
        Response.Redirect(sRootFile & "?action=bottom")
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If Not Page.IsPostBack Then
            If Request.QueryString("action") = "top" Then
                RedirectForLogin()
                If idAddNewTop.Visible = True Then
                    PrepareNewPage()
                    hidLinkPlacement.Value = "top" 'Create under Home, but use 'top' (not 'main')
                    PrepareNewPageData("top")
                    hidEditorPurpose.Value = "CreateNewTop"
                End If
            End If

            If Request.QueryString("action") = "bottom" Then
                RedirectForLogin()
                If idAddNewBottom.Visible = True Then
                    PrepareNewPage()
                    hidLinkPlacement.Value = "bottom" 'Create under Home, but use 'bottom' (not 'main')
                    PrepareNewPageData("bottom")
                    hidEditorPurpose.Value = "CreateNewBottom"
                End If
            End If
        End If
    End Sub

    '*** LISTING ***
    Protected Sub ShowListing(ByVal nPageIndex As Integer)
        Dim oPds As PagedDataSource = New PagedDataSource
        Dim oContent As Content = New Content

        If Not Page.IsPostBack Then
            If Not sListingDefaultOrder = "" Then
                dropListingOrdering.SelectedValue = sListingDefaultOrder
            End If
        End If

        Dim sSortType As String = "DESC"
        If nListingType = 1 Then
            'General
            If Not Page.IsPostBack Then
                'First load berdasarkan default order
                If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                    sSortType = "ASC"
                End If
                oContent.SortingBy = sListingDefaultOrder
                oContent.SortingType = sSortType
            Else

                If dropListingOrdering.Visible = True Then
                    'Postback dari dropdown
                    If dropListingOrdering.SelectedValue = "title" Or dropListingOrdering.SelectedValue = "last_updated_by" Or dropListingOrdering.SelectedValue = "owner" Then
                        sSortType = "ASC"
                    End If
                    oContent.SortingBy = dropListingOrdering.SelectedValue
                    oContent.SortingType = sSortType
                Else
                    'Postback dari paging
                    If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                        sSortType = "ASC"
                    End If
                    oContent.SortingBy = sListingDefaultOrder
                    oContent.SortingType = sSortType
                End If

            End If

            If nListingProperty = 1 Or nListingProperty = 3 Then
                oContent.ManualOrder = True
            End If

        Else
            'News
            'If Not Page.IsPostBack Then
            '    'First load berdasarkan "display_date DESC"
            '    oContent.SortingBy = "display_date"
            '    oContent.SortingType = "DESC"
            'Else
            '    'Postback dari dropdown
            '    If dropListingOrdering.SelectedValue = "last_updated_date" Or dropListingOrdering.SelectedValue = "file_size" Then
            '        sSortType = "DESC"
            '    End If
            '    oContent.SortingBy = dropListingOrdering.SelectedValue
            '    oContent.SortingType = sSortType
            'End If
            oContent.SortingBy = "display_date"
            oContent.SortingType = "DESC"
        End If

        Dim bNoSelection As Boolean = False
        Dim nYear As Integer
        Dim nMonth As Integer
        Dim nDay As Integer
        If Not IsNothing(Request.QueryString("d")) Then
            nYear = Request.QueryString("d").Split("-")(0)
            nMonth = Request.QueryString("d").Split("-")(1)
            If Request.QueryString("d").Split("-").Length = 3 Then
                'Date Selection
                nDay = Request.QueryString("d").Split("-")(2)
                oPds.DataSource = oContent.GetPagesWithin(nPageId, 0, 3, New Date(nYear, nMonth, nDay), False).DefaultView 'Get all posts on the specified date.
            Else
                'Month Selection
                oPds.DataSource = oContent.GetPagesWithin(nPageId, 0, 5, Nothing, False, nYear, nMonth).DefaultView 'Get all posts on the specified month.
            End If
            litTitle.Text = litTitle.Text & "<div class=""recent_entries""><a class=""recent_entries"" href=""" & HttpContext.Current.Items("_page") & """>Recent Entries</a></div>"
        ElseIf Not IsNothing(Request.QueryString("w")) Then
            'Week Selection
            nYear = Request.QueryString("w").Split("-")(0)
            nMonth = Request.QueryString("w").Split("-")(1)
            nDay = Request.QueryString("w").Split("-")(2)
            oPds.DataSource = oContent.GetPagesWithin(nPageId, 0, 6, New Date(nYear, nMonth, nDay), False).DefaultView 'Get all posts on the specified week.
            litTitle.Text = litTitle.Text & "<div class=""recent_entries""><a class=""recent_entries"" href=""" & HttpContext.Current.Items("_page") & """>Recent Entries</a></div>"
        ElseIf Not IsNothing(Request.QueryString("cat")) Then
            'Get latest posts on the specified category.
            oPds.DataSource = oContent.GetPagesWithin(nPageId, 0, 7, , , , , Request.QueryString("cat")).DefaultView

            Dim sSQL As String
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            Dim oDataReader As SqlDataReader
            oConn = New SqlConnection(sConn)
            oConn.Open()
            sSQL = "SELECT * FROM listing_categories WHERE listing_category_id=@listing_category_id"
            oCommand = New SqlCommand(sSQL)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@listing_category_id", SqlDbType.Int).Value = Request.QueryString("cat")
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            While oDataReader.Read()
                litTitle.Text = litTitle.Text & "<div class=""category_name"">" & oDataReader("listing_category_name").ToString & " &nbsp;&nbsp;<a class=""all_categories"" href=""" & HttpContext.Current.Items("_page") & """>All Categories</a></div>"
            End While
            oDataReader.Close()
            oConn.Close()
            oConn = Nothing
        Else
            'No Selection
            bNoSelection = True

            nYear = Now.Year
            nMonth = Now.Month
            If nListingType = 1 Then
                'General Listing
                oPds.DataSource = oContent.GetPagesWithin(nPageId, 0, 1, Nothing, False).DefaultView 'Get all posts
            Else
                'News/Journal
                oPds.DataSource = oContent.GetPagesWithin(nPageId, 500, 2, Nothing, False).DefaultView 'Get 500 latest posts
            End If

        End If

        'Formatting
        panelDataList.Visible = True
        dlDataList.RepeatDirection = RepeatDirection.Horizontal
        dlDataList.ItemStyle.VerticalAlign = VerticalAlign.Top
        dlDataList.CellPadding = 0
        dlDataList.CellSpacing = 0
        dlDataList.GridLines = GridLines.None
        dlDataList.RepeatColumns = nListingColumns

        litDataListHeader.Text = sListingTemplateHeader
        litDataListFooter.Text = sListingTemplateFooter

        'dlDataList.HeaderTemplate = New TemplateListing(ListItemType.Header, nListingTemplateId, nRootId, bIsReader)
        dlDataList.ItemTemplate = New TemplateListing(ListItemType.Item, nListingTemplateId, nRootId, bIsReader)
        'dlDataList.FooterTemplate = New TemplateListing(ListItemType.Footer, nListingTemplateId, nRootId, bIsReader)

        'TODO: Paging & Binding
        oPds.AllowPaging = True
        oPds.PageSize = nListingPageSize
        oPds.CurrentPageIndex = nPageIndex
        lblDataListPagingInfo.Text = GetLocalResourceObject("PAGE") & " " & (oPds.CurrentPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & oPds.PageCount
        lblDataListPagingInfo2.Text = GetLocalResourceObject("PAGE") & " " & (oPds.CurrentPageIndex + 1) & " " & GetLocalResourceObject("of") & " " & oPds.PageCount
        If oPds.IsFirstPage Then
            pgDataListFirst.Enabled = False
            pgDataListPrevious.Enabled = False
            pgDataListFirst2.Enabled = False
            pgDataListPrevious2.Enabled = False
        Else
            pgDataListFirst.Enabled = True
            pgDataListPrevious.Enabled = True
            pgDataListFirst2.Enabled = True
            pgDataListPrevious2.Enabled = True
        End If
        If oPds.IsLastPage Then
            pgDataListLast.Enabled = False
            pgDataListNext.Enabled = False
            pgDataListLast2.Enabled = False
            pgDataListNext2.Enabled = False
        Else
            pgDataListLast.Enabled = True
            pgDataListNext.Enabled = True
            pgDataListLast2.Enabled = True
            pgDataListNext2.Enabled = True
        End If

        dlDataList.DataSource = oPds
        dlDataList.DataBind()

        hidPageCount.Value = oPds.PageCount
        hidPageIndex.Value = oPds.CurrentPageIndex

        If oPds.Count = 0 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        If oPds.PageCount < 2 Then
            idDataListHeader.Visible = False
            idDataListFooter.Visible = False
            If dropListingOrdering.Visible = False Then
                idDataListHeaderContainer.Visible = False
            End If
        End If

        oContent = Nothing
        oPds = Nothing
    End Sub
    Protected Sub pgDataListFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListFirst.Click
        ShowListing(0)
    End Sub
    Protected Sub pgDataListLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListLast.Click
        ShowListing(CInt(hidPageCount.Value) - 1)
    End Sub
    Protected Sub pgDataListNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListNext.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) + 1
        ShowListing(CInt(hidPageIndex.Value))
    End Sub
    Protected Sub pgDataListPrevious_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListPrevious.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) - 1
        ShowListing(CInt(hidPageIndex.Value))
    End Sub
    Protected Sub pgDataListFirst2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListFirst2.Click
        ShowListing(0)
    End Sub
    Protected Sub pgDataListLast2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListLast2.Click
        ShowListing(CInt(hidPageCount.Value) - 1)
    End Sub
    Protected Sub pgDataListNext2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListNext2.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) + 1
        ShowListing(CInt(hidPageIndex.Value))
    End Sub
    Protected Sub pgDataListPrevious2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles pgDataListPrevious2.Click
        hidPageIndex.Value = CInt(hidPageIndex.Value) - 1
        ShowListing(CInt(hidPageIndex.Value))
    End Sub

    Protected Sub dropListingOrdering_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dropListingOrdering.SelectedIndexChanged
        ShowListing(0)
    End Sub

    Protected Sub btnQuickAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnQuickAdd.Click
        RedirectForLogin()

        Dim nNewPageId As Integer

        Dim oContentManager As ContentManager = New ContentManager

        Dim sNewFileName As String
        If GetFileName().Contains("/") Then
            sNewFileName = GetFileName().Substring(0, GetFileName().LastIndexOf("/") + 1) & "page" & nPageId & lstOrdering.Items.Count & Now.Minute & Now.Second
        Else
            sNewFileName = "page" & nPageId & lstOrdering.Items.Count & Now.Minute & Now.Second
        End If

        If oContentManager.IsContentExist(sNewFileName & ".aspx") Then
            'File exists
            Exit Sub
        End If

        Dim sExt As String
        Dim oContentNew As CMSContent = New CMSContent
        Dim oContent As CMSContent = New CMSContent
        With oContent
            .ChannelId = nChannelId
            .FileName = sNewFileName
            .Title = txtQuickTitle.Text
            .Summary = txtQuickSummary.Text

            'File Download
            If fileQuick.FileName <> "" Then
                .FileAttachment = "1_" & fileQuick.FileName
                .FileSize = fileQuick.PostedFile.ContentLength
            End If
            'File View
            sExt = (.FileAttachment.Substring(.FileAttachment.LastIndexOf(".") + 1)).ToLower

            If sExt = "flv" Or sExt = "mp3" Or _
                sExt = "jpeg" Or sExt = "jpg" Or _
                sExt = "gif" Or sExt = "png" Or sExt = "bmp" Or _
                sExt = "m4v" Or sExt = "wmv" Or _
                sExt = "mp4" Or sExt = "swf" _
                Then
                .FileView = "1_" & fileQuick.FileName
            End If
            'File View Listing
            If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
                .FileViewListing = "1_" & fileQuick.FileName
            End If

            .ContentBody = ""
            .DisplayDate = New DateTime(Now.Year, Now.Month, Now.Day, 0, 0, 0)
            .PageType = 1
            .Owner = sUserName
            .LastUpdatedBy = sUserName
            .TemplateId = 1 'no problem, krn use_default_template=true
            .FileSize = fileQuick.PostedFile.ContentLength
            .LinkPlacement = sLinkPlacement
            .RootId = nRootId

            .IsListing = False
            .ListingType = 1
            .ListingProperty = 1

            .ListingDefaultOrder = "title"
            .ListingDatetimeFormat = ""
            .ListingColumns = 1
            .ListingPageSize = 10
            .ListingTemplateId = 1 'TODO: bahaya kalau template id 1 dihapus
            .ListingUseCategories = False

            .IsLink = False
        End With
        oContentNew = oContentManager.CreateContent(oContent, nPageId, "UNDER")
        nNewPageId = oContentNew.PageId

        'File Download 
        If fileQuick.FileName <> "" Then
            Dim sStorage As String = sResourcesInternal_FileDownload & "\files\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If
            fileQuick.SaveAs(sStorage & 1 & "_" & fileQuick.FileName)
        End If
        'File View
        sExt = (oContent.FileAttachment.Substring(oContent.FileAttachment.LastIndexOf(".") + 1)).ToLower
        If sExt = "flv" Or sExt = "mp3" Or _
            sExt = "jpeg" Or sExt = "jpg" Or _
            sExt = "gif" Or sExt = "png" Or sExt = "bmp" Or _
                sExt = "m4v" Or sExt = "wmv" Or _
                sExt = "mp4" Or sExt = "swf" _
            Then
            Dim sStorage As String = sResourcesInternal_FileView & "\file_views\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If
            fileQuick.SaveAs(sStorage & 1 & "_" & fileQuick.FileName)
        End If
        'File View Listing
        If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Or sExt = "bmp" Then
            Dim sStorage As String = sResourcesInternal_FileViewListing & "\file_views_listing\" & nNewPageId & "\"
            If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
                My.Computer.FileSystem.CreateDirectory(sStorage)
            End If
            'fileViewListing.SaveAs(sStorage & 1 & "_" & fileViewListing.FileName)
            ResizeFileViewListing(sStorage & 1 & "_" & fileQuick.FileName, True, 100)
        End If

        Dim contentLatest As CMSContent
        contentLatest = oContentManager.GetLatestVersion(nNewPageId)
        oContentManager.SubmitContent(nNewPageId, contentLatest.Version) 'Publish

        oContent = Nothing
        oContentNew = Nothing
        oContentManager = Nothing

        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnSearch_Click1(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click

    End Sub
End Class
