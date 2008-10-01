Imports Microsoft.VisualBasic
Imports System.Threading

Public Class BaseUserControl
    Inherits System.Web.UI.UserControl

    Private sAppFullPath As String = ""
    Public ReadOnly Property AppFullPath() As String
        Get
            'returns:
            ' http://localhost/ 
            ' http://localhost/apppath/
            '(Selalu ada "/" di akhir)
            Dim sPort As String = Request.ServerVariables("SERVER_PORT")
            If IsNothing(sPort) Or sPort = "80" Or sPort = "443" Then
                sPort = ""
            Else
                sPort = ":" & sPort
            End If

            Dim sProtocol As String = Request.ServerVariables("SERVER_PORT_SECURE")
            If IsNothing(sProtocol) Or sProtocol = "0" Then
                sProtocol = "http://"
            Else
                sProtocol = "https://"
            End If

            If Request.ApplicationPath = "/" Then
                'App is installed in root
                Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath
            Else
                'App is installed in virtual directory
                Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath & "/"
            End If
        End Get
    End Property

    Private sAppPath As String = ""
    Public ReadOnly Property AppPath() As String
        Get
            sAppPath = Context.Request.ApplicationPath
            If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"
            Return sAppPath
        End Get
    End Property

    Private sModuleData As String = "" 'not always available
    Public Property ModuleData() As String
        Get
            Return sModuleData
        End Get
        Set(ByVal value As String)
            sModuleData = value
        End Set
    End Property

    'User Roles
    Private bIsPublisher As Boolean
    Public Property IsPublisher() As Boolean
        Get
            Return bIsPublisher
        End Get
        Set(ByVal value As Boolean)
            bIsPublisher = value
        End Set
    End Property

    Private bIsSubscriber As Boolean
    Public Property IsSubscriber() As Boolean
        Get
            Return bIsSubscriber
        End Get
        Set(ByVal value As Boolean)
            bIsSubscriber = value
        End Set
    End Property

    Private bIsAuthor As Boolean
    Public Property IsAuthor() As Boolean
        Get
            Return bIsAuthor
        End Get
        Set(ByVal value As Boolean)
            bIsAuthor = value
        End Set
    End Property

    Private bIsEditor As Boolean
    Public Property IsEditor() As Boolean
        Get
            Return bIsEditor
        End Get
        Set(ByVal value As Boolean)
            bIsEditor = value
        End Set
    End Property

    Private bIsResourceManager As Boolean
    Public Property IsResourceManager() As Boolean
        Get
            Return bIsResourceManager
        End Get
        Set(ByVal value As Boolean)
            bIsResourceManager = value
        End Set
    End Property

    Private bIsAdministrator As Boolean
    Public Property IsAdministrator() As Boolean
        Get
            Return bIsAdministrator
        End Get
        Set(ByVal value As Boolean)
            bIsAdministrator = value
        End Set
    End Property

    Private bIsOwner As Boolean
    Public Property IsOwner() As Boolean
        Get
            Return bIsOwner
        End Get
        Set(ByVal value As Boolean)
            bIsOwner = value
        End Set
    End Property

    Private bIsReader As Boolean 'Not an Admin, Author, Editor or Publisher   
    Public Property IsReader() As Boolean
        Get
            Return bIsReader
        End Get
        Set(ByVal value As Boolean)
            bIsReader = value
        End Set
    End Property

    Private bUserLoggedIn As Boolean
    Public Property IsUserLoggedIn() As Boolean
        Get
            Return bUserLoggedIn
        End Get
        Set(ByVal value As Boolean)
            bUserLoggedIn = value
        End Set
    End Property

    Private sUserName As String = ""
    Public Property UserName() As String
        Get
            Return sUserName
        End Get
        Set(ByVal value As String)
            sUserName = value
        End Set
    End Property

    'Currency Symbol
    Private sCurrencySeparator As String = ""
    Public Property CurrencySeparator() As String
        Get
            Return sCurrencySeparator
        End Get
        Set(ByVal value As String)
            sCurrencySeparator = value
        End Set
    End Property

    Public ReadOnly Property CurrencySymbol() As String
        Get
            Dim sCurrencySymbol As String = Thread.CurrentThread.CurrentUICulture.NumberFormat.CurrencySymbol
            If sCurrencySymbol.Length > 1 Then
                sCurrencySymbol = sCurrencySymbol.Substring(0, 1).ToUpper() & sCurrencySymbol.Substring(1).ToString
            End If
            Return sCurrencySymbol & sCurrencySeparator 'Thread.CurrentThread.CurrentUICulture.NumberFormat.CurrencySymbol & sCurrencySeparator
        End Get
    End Property

    'Culture
    Public ReadOnly Property Culture() As String
        Get
            Return Thread.CurrentThread.CurrentUICulture.Name
        End Get
    End Property

    'Root
    Private sRootFile As String
    Public Property RootFile() As String
        Get
            Return sRootFile
        End Get
        Set(ByVal value As String)
            sRootFile = value
        End Set
    End Property

    Private nRootId As Integer
    Public Property RootID() As Integer
        Get
            Return nRootId
        End Get
        Set(ByVal value As Integer)
            nRootId = value
        End Set
    End Property

    'PageId
    Private nPageId As Integer
    Public Property PageID() As Integer
        Get
            Return nPageId
        End Get
        Set(ByVal value As Integer)
            nPageId = value
        End Set
    End Property

    'ParentId
    Private nParentId As Integer
    Public Property ParentID() As Integer
        Get
            Return nParentId
        End Get
        Set(ByVal value As Integer)
            nParentId = value
        End Set
    End Property

    'PageType
    Private nPageType As Integer
    Public Property PageType() As Integer
        Get
            Return nPageType
        End Get
        Set(ByVal value As Integer)
            nPageType = value
        End Set
    End Property

    'ParentPageType
    Private nParentPageType As Integer
    Public Property ParentPageType() As Integer
        Get
            Return nParentPageType
        End Get
        Set(ByVal value As Integer)
            nParentPageType = value
        End Set
    End Property

    'ParentFileName
    Private sParentFileName As String
    Public Property ParentFileName() As String
        Get
            Return sParentFileName
        End Get
        Set(ByVal value As String)
            sParentFileName = value
        End Set
    End Property

    'TemplateID
    Private nTemplateId As Integer
    Public Property TemplateID() As Integer
        Get
            Return nTemplateId
        End Get
        Set(ByVal value As Integer)
            nTemplateId = value
        End Set
    End Property
    Private sTemplateFolderName As String
    Public Property TemplateFolderName() As String
        Get
            Return sTemplateFolderName
        End Get
        Set(ByVal value As String)
            sTemplateFolderName = value
        End Set
    End Property

    Private nChannelPermission As Integer
    Public Property ChannelPermission() As Integer
        Get
            Return nChannelPermission
        End Get
        Set(ByVal value As Integer)
            nChannelPermission = value
        End Set
    End Property

    'Links
    Private sLinkPassword As String = "password.aspx"
    Public Property LinkPassword() As String
        Get
            Return sLinkPassword
        End Get
        Set(ByVal value As String)
            sLinkPassword = value
        End Set
    End Property

    Private sLinkRegistration As String = "registration.aspx"
    Public Property LinkRegistration() As String
        Get
            Return sLinkRegistration
        End Get
        Set(ByVal value As String)
            sLinkRegistration = value
        End Set
    End Property

    Private sLinkLogin As String = "login.aspx"
    Public Property LinkLogin() As String
        Get
            Return sLinkLogin
        End Get
        Set(ByVal value As String)
            sLinkLogin = value
        End Set
    End Property

    Private sLinkActivate As String = "activate.aspx"
    Public Property LinkActivate() As String
        Get
            Return sLinkActivate
        End Get
        Set(ByVal value As String)
            sLinkActivate = value
        End Set
    End Property

    Private sLinkPollResults As String = "poll_results.aspx"
    Public Property LinkPollResults() As String
        Get
            Return sLinkPollResults
        End Get
        Set(ByVal value As String)
            sLinkPollResults = value
        End Set
    End Property

    Private sLinkEvents As String = "event_view.aspx"
    Public Property LinkEvents() As String
        Get
            Return sLinkEvents
        End Get
        Set(ByVal value As String)
            sLinkEvents = value
        End Set
    End Property

    Private sLinkShopPaypalCart As String = "shop_pcart.aspx"
    Public Property LinkShopPaypalCart() As String
        Get
            Return sLinkShopPaypalCart
        End Get
        Set(ByVal value As String)
            sLinkShopPaypalCart = value
        End Set
    End Property
    Private sLinkShopPaypalCompleted As String = "shop_pcompleted.aspx"
    Public Property LinkShopPaypalCompleted() As String
        Get
            Return sLinkShopPaypalCompleted
        End Get
        Set(ByVal value As String)
            sLinkShopPaypalCompleted = value
        End Set
    End Property

    Private sLinkShopConfig As String = "shop_config.aspx"
    Public Property LinkShopConfig() As String
        Get
            Return sLinkShopConfig
        End Get
        Set(ByVal value As String)
            sLinkShopConfig = value
        End Set
    End Property

    Private sLinkShopProductTypes As String = "shop_product_types.aspx"
    Public Property LinkShopProductTypes() As String
        Get
            Return sLinkShopProductTypes
        End Get
        Set(ByVal value As String)
            sLinkShopProductTypes = value
        End Set
    End Property

    Private sLinkShopProductTypeLookup As String = "shop_product_type_lookup.aspx"
    Public Property LinkShopProductTypeLookup() As String
        Get
            Return sLinkShopProductTypeLookup
        End Get
        Set(ByVal value As String)
            sLinkShopProductTypeLookup = value
        End Set
    End Property

    Private sLinkShopShipments As String = "shop_shipments.aspx"
    Public Property LinkShopShipments() As String
        Get
            Return sLinkShopShipments
        End Get
        Set(ByVal value As String)
            sLinkShopShipments = value
        End Set
    End Property

    Private sLinkShopTaxes As String = "shop_taxes.aspx"
    Public Property LinkShopTaxes() As String
        Get
            Return sLinkShopTaxes
        End Get
        Set(ByVal value As String)
            sLinkShopTaxes = value
        End Set
    End Property

    Private sLinkShopCoupons As String = "shop_coupons.aspx"
    Public Property LinkShopCoupons() As String
        Get
            Return sLinkShopCoupons
        End Get
        Set(ByVal value As String)
            sLinkShopCoupons = value
        End Set
    End Property

    Private sLinkShopOrders As String = "shop_orders.aspx"
    Public Property LinkShopOrders() As String
        Get
            Return sLinkShopOrders
        End Get
        Set(ByVal value As String)
            sLinkShopOrders = value
        End Set
    End Property

    Private sAdmin As String = "admin.aspx"
    Public Property LinkAdmin() As String
        Get
            Return sAdmin
        End Get
        Set(ByVal value As String)
            sAdmin = value
        End Set
    End Property

    Private sWorkspace As String = "workspace.aspx"
    Public Property LinkWorkspace() As String
        Get
            Return sWorkspace
        End Get
        Set(ByVal value As String)
            sWorkspace = value
        End Set
    End Property

    Private sAdminUsers As String = "admin_users.aspx"
    Public Property LinkAdminUsers() As String
        Get
            Return sAdminUsers
        End Get
        Set(ByVal value As String)
            sAdminUsers = value
        End Set
    End Property

    Private sAdminUsersImport As String = "admin_users_import.aspx"
    Public Property LinkAdminUsersImport() As String
        Get
            Return sAdminUsersImport
        End Get
        Set(ByVal value As String)
            sAdminUsersImport = value
        End Set
    End Property

    Private sAdminUserNew As String = "admin_user_new.aspx"
    Public Property LinkAdminUserNew() As String
        Get
            Return sAdminUserNew
        End Get
        Set(ByVal value As String)
            sAdminUserNew = value
        End Set
    End Property

    Private sAdminUserInfo As String = "admin_user_info.aspx"
    Public Property LinkAdminUserInfo() As String
        Get
            Return sAdminUserInfo
        End Get
        Set(ByVal value As String)
            sAdminUserInfo = value
        End Set
    End Property

    Private sAdminChannels As String = "admin_channels.aspx"
    Public Property LinkAdminChannels() As String
        Get
            Return sAdminChannels
        End Get
        Set(ByVal value As String)
            sAdminChannels = value
        End Set
    End Property

    Private sAdminChannelNew As String = "admin_channel_new.aspx"
    Public Property LinkAdminChannelNew() As String
        Get
            Return sAdminChannelNew
        End Get
        Set(ByVal value As String)
            sAdminChannelNew = value
        End Set
    End Property

    Private sAdminChannelInfo As String = "admin_channel_info.aspx"
    Public Property LinkAdminChannelInfo() As String
        Get
            Return sAdminChannelInfo
        End Get
        Set(ByVal value As String)
            sAdminChannelInfo = value
        End Set
    End Property

    Private sWorkspaceApproval As String = "approval.aspx"
    Public Property LinkWorkspaceApproval() As String
        Get
            Return sWorkspaceApproval
        End Get
        Set(ByVal value As String)
            sWorkspaceApproval = value
        End Set
    End Property

    Private sAdminTemplates As String = "admin_templates.aspx"
    Public Property LinkAdminTemplates() As String
        Get
            Return sAdminTemplates
        End Get
        Set(ByVal value As String)
            sAdminTemplates = value
        End Set
    End Property

    Private sAdminTemplateNew As String = "admin_template_new.aspx"
    Public Property LinkAdminTemplateNew() As String
        Get
            Return sAdminTemplateNew
        End Get
        Set(ByVal value As String)
            sAdminTemplateNew = value
        End Set
    End Property

    Private sAdminModules As String = "admin_modules.aspx"
    Public Property LinkAdminModules() As String
        Get
            Return sAdminModules
        End Get
        Set(ByVal value As String)
            sAdminModules = value
        End Set
    End Property

    Private sAdminModuleNew As String = "admin_module_new.aspx"
    Public Property LinkAdminModuleNew() As String
        Get
            Return sAdminModuleNew
        End Get
        Set(ByVal value As String)
            sAdminModuleNew = value
        End Set
    End Property

    Private sAdminModulePages As String = "admin_module_pages.aspx"
    Public Property LinkAdminModulePages() As String
        Get
            Return sAdminModulePages
        End Get
        Set(ByVal value As String)
            sAdminModulePages = value
        End Set
    End Property

    Private sAdminRegistrationSettings As String = "registration_settings.aspx"
    Public Property LinkAdminRegistrationSettings() As String
        Get
            Return sAdminRegistrationSettings
        End Get
        Set(ByVal value As String)
            sAdminRegistrationSettings = value
        End Set
    End Property

    Private sWorkspacePages As String = "pages.aspx"
    Public Property LinkWorkspacePages() As String
        Get
            Return sWorkspacePages
        End Get
        Set(ByVal value As String)
            sWorkspacePages = value
        End Set
    End Property

    Private sWorkspaceResources As String = "resources.aspx"
    Public Property LinkWorkspaceResources() As String
        Get
            Return sWorkspaceResources
        End Get
        Set(ByVal value As String)
            sWorkspaceResources = value
        End Set
    End Property

    Private sWorkspaceAccount As String = "account.aspx"
    Public Property LinkWorkspaceAccount() As String
        Get
            Return sWorkspaceAccount
        End Get
        Set(ByVal value As String)
            sWorkspaceAccount = value
        End Set
    End Property

    Private sWorkspacePreferences As String = "preferences.aspx"
    Public Property LinkWorkspacePreferences() As String
        Get
            Return sWorkspacePreferences
        End Get
        Set(ByVal value As String)
            sWorkspacePreferences = value
        End Set
    End Property

    Private sWorkspaceEvents As String = "events.aspx"
    Public Property LinkWorkspaceEvents() As String
        Get
            Return sWorkspaceEvents
        End Get
        Set(ByVal value As String)
            sWorkspaceEvents = value
        End Set
    End Property

    Private sWorkspaceEventNew As String = "event_new.aspx"
    Public Property LinkWorkspaceEventNew() As String
        Get
            Return sWorkspaceEventNew
        End Get
        Set(ByVal value As String)
            sWorkspaceEventNew = value
        End Set
    End Property

    Private sWorkspaceEventEdit As String = "event_edit.aspx"
    Public Property LinkWorkspaceEventEdit() As String
        Get
            Return sWorkspaceEventEdit
        End Get
        Set(ByVal value As String)
            sWorkspaceEventEdit = value
        End Set
    End Property

    Private sWorkspaceEventEmbed As String = "event_embed.aspx"
    Public Property LinkWorkspaceEventEmbed() As String
        Get
            Return sWorkspaceEventEmbed
        End Get
        Set(ByVal value As String)
            sWorkspaceEventEmbed = value
        End Set
    End Property

    Private sWorkspacePolls As String = "polls.aspx"
    Public Property LinkWorkspacePolls() As String
        Get
            Return sWorkspacePolls
        End Get
        Set(ByVal value As String)
            sWorkspacePolls = value
        End Set
    End Property

    Private sWorkspacePollInfo As String = "poll_info.aspx"
    Public Property LinkWorkspacePollInfo() As String
        Get
            Return sWorkspacePollInfo
        End Get
        Set(ByVal value As String)
            sWorkspacePollInfo = value
        End Set
    End Property

    Private sWorkspacePollNew As String = "poll_new.aspx"
    Public Property LinkWorkspacePollNew() As String
        Get
            Return sWorkspacePollNew
        End Get
        Set(ByVal value As String)
            sWorkspacePollNew = value
        End Set
    End Property

    Private sWorkspacePollPages As String = "poll_pages.aspx"
    Public Property LinkWorkspacePollPages() As String
        Get
            Return sWorkspacePollPages
        End Get
        Set(ByVal value As String)
            sWorkspacePollPages = value
        End Set
    End Property

    Private sWorkspaceShop As String = "shop.aspx"
    Public Property LinkWorkspaceShop() As String
        Get
            Return sWorkspaceShop
        End Get
        Set(ByVal value As String)
            sWorkspaceShop = value
        End Set
    End Property

    Private sLinkCustomListing As String = "custom_listing.aspx"
    Public Property LinkCustomListing() As String
        Get
            Return sLinkCustomListing
        End Get
        Set(ByVal value As String)
            sLinkCustomListing = value
        End Set
    End Property

    Private sAdminLocalization As String = "admin_localization.aspx"
    Public Property LinkAdminLocalization() As String
        Get
            Return sAdminLocalization
        End Get
        Set(ByVal value As String)
            sAdminLocalization = value
        End Set
    End Property

    Private sAdminSite As String = "admin_site.aspx"
    Public Property LinkAdminSite() As String
        Get
            Return sAdminSite
        End Get
        Set(ByVal value As String)
            sAdminSite = value
        End Set
    End Property

    Private sWorkspaceNewsletters As String = "newsletters.aspx"
    Public Property LinkWorkspaceNewsletters() As String
        Get
            Return sWorkspaceNewsletters
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsletters = value
        End Set
    End Property

    Private sWorkspaceNewsConfigure As String = "newsletters_configure.aspx"
    Public Property LinkWorkspaceNewsConfigure() As String
        Get
            Return sWorkspaceNewsConfigure
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsConfigure = value
        End Set
    End Property

    Private sWorkspaceNewsSend As String = "newsletters_send.aspx"
    Public Property LinkWorkspaceNewsSend() As String
        Get
            Return sWorkspaceNewsSend
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsSend = value
        End Set
    End Property

    Private sWorkspaceNewsLists As String = "mailing_lists.aspx"
    Public Property LinkWorkspaceNewsLists() As String
        Get
            Return sWorkspaceNewsLists
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsLists = value
        End Set
    End Property

    Private sWorkspaceNewsSettings As String = "subscription_settings.aspx"
    Public Property LinkWorkspaceNewsSettings() As String
        Get
            Return sWorkspaceNewsSettings
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsSettings = value
        End Set
    End Property

    Private sWorkspaceNewsSubscribers As String = "subscribers.aspx"
    Public Property LinkWorkspaceNewsSubscribers() As String
        Get
            Return sWorkspaceNewsSubscribers
        End Get
        Set(ByVal value As String)
            sWorkspaceNewsSubscribers = value
        End Set
    End Property

    Private sSubscriptionUpdate As String = "subscription_update.aspx"
    Public Property LinkSubscriptionUpdate() As String
        Get
            Return sSubscriptionUpdate
        End Get
        Set(ByVal value As String)
            sSubscriptionUpdate = value
        End Set
    End Property

    Private sNewsList As String = "news_list.aspx"
    Public Property LinkNewsList() As String
        Get
            Return sNewsList
        End Get
        Set(ByVal value As String)
            sNewsList = value
        End Set
    End Property


    'Site Info
    Private sSiteName As String
    Public Property SiteName() As String
        Get
            Return sSiteName
        End Get
        Set(ByVal value As String)
            sSiteName = value
        End Set
    End Property

    Private sSiteAddress As String
    Public Property SiteAddress() As String
        Get
            Return sSiteAddress
        End Get
        Set(ByVal value As String)
            sSiteAddress = value
        End Set
    End Property

    Private sSiteCity As String
    Public Property SiteCity() As String
        Get
            Return sSiteCity
        End Get
        Set(ByVal value As String)
            sSiteCity = value
        End Set
    End Property

    Private sSiteState As String
    Public Property SiteState() As String
        Get
            Return sSiteState
        End Get
        Set(ByVal value As String)
            sSiteState = value
        End Set
    End Property

    Private sSiteCountry As String
    Public Property SiteCountry() As String
        Get
            Return sSiteCountry
        End Get
        Set(ByVal value As String)
            sSiteCountry = value
        End Set
    End Property

    Private sSiteZip As String
    Public Property SiteZip() As String
        Get
            Return sSiteZip
        End Get
        Set(ByVal value As String)
            sSiteZip = value
        End Set
    End Property

    Private sSitePhone As String
    Public Property SitePhone() As String
        Get
            Return sSitePhone
        End Get
        Set(ByVal value As String)
            sSitePhone = value
        End Set
    End Property

    Private sSiteFax As String
    Public Property SiteFax() As String
        Get
            Return sSiteFax
        End Get
        Set(ByVal value As String)
            sSiteFax = value
        End Set
    End Property

    Private sSiteEmail As String
    Public Property SiteEmail() As String
        Get
            Return sSiteEmail
        End Get
        Set(ByVal value As String)
            sSiteEmail = value
        End Set
    End Property

    Private sTellAFriend As String = "tell_a_friend.aspx"
    Public Property LinkTellAFriend() As String
        Get
            Return sTellAFriend
        End Get
        Set(ByVal value As String)
            sTellAFriend = value
        End Set
    End Property
    Private sSiteRss As String = "site_rss.aspx"
    Public Property LinkSiteRss() As String
        Get
            Return sSiteRss
        End Get
        Set(ByVal value As String)
            sSiteRss = value
        End Set
    End Property

    Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        If Not nRootId = 1 Then sAdmin = "admin_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspace = "workspace_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminUsers = "admin_users_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminUserNew = "admin_user_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminUserInfo = "admin_user_info_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminChannels = "admin_channels_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminChannelNew = "admin_channel_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminChannelInfo = "admin_channel_info_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceApproval = "approval_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminTemplates = "admin_templates_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminTemplateNew = "admin_template_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminModules = "admin_modules_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminModuleNew = "admin_module_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminModulePages = "admin_module_pages_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePages = "pages_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceResources = "resources_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceAccount = "account_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePreferences = "preferences_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceEvents = "events_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceEventNew = "event_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceEventEdit = "event_edit_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceEventEmbed = "event_embed_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePolls = "polls_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePollInfo = "poll_info_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePollNew = "poll_new_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspacePollPages = "poll_pages_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminLocalization = "admin_localization_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminSite = "admin_site_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsletters = "newsletters_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsConfigure = "newsletters_configure_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsSend = "newsletters_send_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopOrders = "shop_orders_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopCoupons = "shop_coupons_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopShipments = "shop_shipments_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkPassword = "password_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopTaxes = "shop_taxes_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminUsersImport = "admin_users_import_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceShop = "shop_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopConfig = "shop_config_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkPollResults = "poll_results_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkActivate = "activate_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkEvents = "event_view_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopProductTypes = "shop_product_types_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopProductTypeLookup = "shop_product_type_lookup_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsLists = "mailing_lists_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsSettings = "subscription_settings_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sWorkspaceNewsSubscribers = "subscribers_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sSubscriptionUpdate = "subscription_update_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sNewsList = "news_list_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sAdminRegistrationSettings = "registration_settings_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkLogin = "login_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkRegistration = "registration_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopPaypalCart = "shop_pcart_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkShopPaypalCompleted = "shop_pcompleted_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sLinkCustomListing = "custom_listing_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sTellAFriend = "tell_a_friend_" & nRootId & ".aspx"
        If Not nRootId = 1 Then sSiteRss = "site_rss_" & nRootId & ".aspx"

    End Sub
End Class
