Imports System.Collections.Generic
Imports System.Threading

Public Class BaseMaster
    Inherits MasterPage

    'Fixed Menu
    Private nFixedMenuId As Integer = 0
    Public Property FixedMenuId() As Integer
        Get
            Return nFixedMenuId
        End Get
        Set(ByVal value As Integer)
            nFixedMenuId = value
        End Set
    End Property
    Private dictFixedMenu As Dictionary(Of String, ArrayList)
    Public Property FixedMenu() As Dictionary(Of String, ArrayList)
        Get
            Return dictFixedMenu
        End Get
        Set(ByVal value As Dictionary(Of String, ArrayList))
            dictFixedMenu = value
        End Set
    End Property

    Private bHideHomeLink As Boolean = False
    Public Property HideHomeLink() As Boolean
        Get
            Return bHideHomeLink
        End Get
        Set(ByVal value As Boolean)
            bHideHomeLink = value
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

    Private bIsReader As Boolean 'Not an Admin, Author, Editor or Publisher   
    Public Property IsReader() As Boolean
        Get
            Return bIsReader
        End Get
        Set(ByVal value As Boolean)
            bIsReader = value
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

    'Custom Properties
    Private bUseCustomProperties As Boolean = False
    Public Property UseCustomProperties() As Boolean
        Get
            Return bUseCustomProperties
        End Get
        Set(ByVal value As Boolean)
            bUseCustomProperties = value
        End Set
    End Property
    Private sCustomValue1 As String = ""
    Public Property CustomValue1() As String
        Get
            Return sCustomValue1
        End Get
        Set(ByVal value As String)
            sCustomValue1 = value
        End Set
    End Property
    Private sCustomValue2 As String = ""
    Public Property CustomValue2() As String
        Get
            Return sCustomValue2
        End Get
        Set(ByVal value As String)
            sCustomValue2 = value
        End Set
    End Property
    Private sCustomValue3 As String = ""
    Public Property CustomValue3() As String
        Get
            Return sCustomValue3
        End Get
        Set(ByVal value As String)
            sCustomValue3 = value
        End Set
    End Property
    Private sCustomValue4 As String = ""
    Public Property CustomValue4() As String
        Get
            Return sCustomValue4
        End Get
        Set(ByVal value As String)
            sCustomValue4 = value
        End Set
    End Property
    Private sCustomValue5 As String = ""
    Public Property CustomValue5() As String
        Get
            Return sCustomValue5
        End Get
        Set(ByVal value As String)
            sCustomValue5 = value
        End Set
    End Property
    Private sCustomValue6 As String = ""
    Public Property CustomValue6() As String
        Get
            Return sCustomValue6
        End Get
        Set(ByVal value As String)
            sCustomValue6 = value
        End Set
    End Property
    Private sCustomValue7 As String = ""
    Public Property CustomValue7() As String
        Get
            Return sCustomValue7
        End Get
        Set(ByVal value As String)
            sCustomValue7 = value
        End Set
    End Property
    Private sCustomValue8 As String = ""
    Public Property CustomValue8() As String
        Get
            Return sCustomValue8
        End Get
        Set(ByVal value As String)
            sCustomValue8 = value
        End Set
    End Property
    Private sCustomValue9 As String = ""
    Public Property CustomValue9() As String
        Get
            Return sCustomValue9
        End Get
        Set(ByVal value As String)
            sCustomValue9 = value
        End Set
    End Property
    Private sCustomValue10 As String = ""
    Public Property CustomValue10() As String
        Get
            Return sCustomValue10
        End Get
        Set(ByVal value As String)
            sCustomValue10 = value
        End Set
    End Property

    'General Purpose Content before & after Body Content
    Private sBodyStart As String = ""
    Public Property BodyStart() As String
        Get
            Return sBodyStart
        End Get
        Set(ByVal value As String)
            sBodyStart = value
        End Set
    End Property
    Private sBodyEnd As String = ""
    Public Property BodyEnd() As String
        Get
            Return sBodyEnd
        End Get
        Set(ByVal value As String)
            sBodyEnd = value
        End Set
    End Property

    'Site Map
    'Private bUseSiteMap As Boolean = False
    'Public Property UseSiteMap() As Boolean
    '    Get
    '        Return bUseSiteMap
    '    End Get
    '    Set(ByVal value As Boolean)
    '        bUseSiteMap = value
    '    End Set
    'End Property
    'Private dictSiteMap As Dictionary(Of String, ArrayList)
    'Public Property SiteMap() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictSiteMap
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictSiteMap = value
    '    End Set
    'End Property

    'Main Menu
    'Private dictMainMenu As Dictionary(Of String, ArrayList)
    'Public Property MainMenu() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictMainMenu
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictMainMenu = value
    '    End Set
    'End Property

    'Pages Within
    'Private dictPagesWithin As Dictionary(Of String, ArrayList)
    'Public Property PagesWithin() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictPagesWithin
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictPagesWithin = value
    '    End Set
    'End Property

    'Vertical Menu Rollover
    Private sMnuBgImage As String = ""
    Public Property mnuBgImg() As String
        Get
            Return sMnuBgImage
        End Get
        Set(ByVal value As String)
            sMnuBgImage = value
        End Set
    End Property
    Private sMnuOverBgColor As String = ""
    Public Property mnuOverBgColor() As String
        Get
            Return sMnuOverBgColor
        End Get
        Set(ByVal value As String)
            sMnuOverBgColor = value
        End Set
    End Property
    Private sMnuNormalBgColor As String = ""
    Public Property mnuNormalBgColor() As String
        Get
            Return sMnuNormalBgColor
        End Get
        Set(ByVal value As String)
            sMnuNormalBgColor = value
        End Set
    End Property

    'Shopping Cart Link
    Private sShoppingCartLink As String
    Public Property ShoppingCartLink() As String
        Get
            Return sShoppingCartLink
        End Get
        Set(ByVal value As String)
            sShoppingCartLink = value
        End Set
    End Property
    Private sShoppingCartTitle As String
    Public Property ShoppingCartTitle() As String
        Get
            Return sShoppingCartTitle
        End Get
        Set(ByVal value As String)
            sShoppingCartTitle = value
        End Set
    End Property

    'Home Link
    Private sHomeLink As String
    Public Property HomeLink() As String
        Get
            Return sHomeLink
        End Get
        Set(ByVal value As String)
            sHomeLink = value
        End Set
    End Property
    Private sHomeLinkTitle As String
    Public Property HomeLinkTitle() As String
        Get
            Return sHomeLinkTitle
        End Get
        Set(ByVal value As String)
            sHomeLinkTitle = value
        End Set
    End Property

    'Login Link
    Private sLoginLink As String
    Public Property LoginLink() As String
        Get
            Return sLoginLink
        End Get
        Set(ByVal value As String)
            sLoginLink = value
        End Set
    End Property
    Private sLoginLinkTitle As String
    Public Property LoginLinkTitle() As String
        Get
            Return sLoginLinkTitle
        End Get
        Set(ByVal value As String)
            sLoginLinkTitle = value
        End Set
    End Property
    Private sLogoutLinkTitle As String
    Public Property LogoutLinkTitle() As String
        Get
            Return sLogoutLinkTitle
        End Get
        Set(ByVal value As String)
            sLogoutLinkTitle = value
        End Set
    End Property

    ''Top Menu
    'Private dictTopMenu As Dictionary(Of String, ArrayList)
    'Public Property TopMenu() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictTopMenu
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictTopMenu = value
    '    End Set
    'End Property

    ''Bottom Menu
    'Private dictBottomMenu As Dictionary(Of String, ArrayList)
    'Public Property BottomMenu() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictBottomMenu
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictBottomMenu = value
    '    End Set
    'End Property

    'Same Level Pages
    'Private dictSameLevelPages As Dictionary(Of String, ArrayList)
    'Public Property SameLevelPages() As Dictionary(Of String, ArrayList)
    '    Get
    '        Return dictSameLevelPages
    '    End Get
    '    Set(ByVal value As Dictionary(Of String, ArrayList))
    '        dictSameLevelPages = value
    '    End Set
    'End Property

    'Country/Locale Select
    Private dictLocales As Dictionary(Of String, ArrayList)
    Public Property Locales() As Dictionary(Of String, ArrayList)
        Get
            Return dictLocales
        End Get
        Set(ByVal value As Dictionary(Of String, ArrayList))
            dictLocales = value
        End Set
    End Property

    'Print Link
    Private sPrintLink As String
    Public Property PrintLink() As String
        Get
            Return sPrintLink
        End Get
        Set(ByVal value As String)
            sPrintLink = value
        End Set
    End Property
    Private sPrintLinkTitle As String
    Public Property PrintLinkTitle() As String
        Get
            Return sPrintLinkTitle
        End Get
        Set(ByVal value As String)
            sPrintLinkTitle = value
        End Set
    End Property

    'Breadcrumb Link Separator
    Private sBreadcrumbLinkSeparator As String = ""
    Public Property BreadcrumbLinkSeparator() As String
        Get
            Return sBreadcrumbLinkSeparator
        End Get
        Set(ByVal value As String)
            sBreadcrumbLinkSeparator = value
        End Set
    End Property

    'Main Menu Link Separator
    'Private sMainMenuLinkSeparator As String = ""
    'Public Property MainMenuLinkSeparator() As String
    '    Get
    '        Return sMainMenuLinkSeparator
    '    End Get
    '    Set(ByVal value As String)
    '        sMainMenuLinkSeparator = value
    '    End Set
    'End Property

    'Top Menu Link Separator
    'Private sTopMenuLinkSeparator As String = ""
    'Public Property TopMenuLinkSeparator() As String
    '    Get
    '        Return sTopMenuLinkSeparator
    '    End Get
    '    Set(ByVal value As String)
    '        sTopMenuLinkSeparator = value
    '    End Set
    'End Property

    ''Bottom Menu Link Separator
    'Private sBottomMenuLinkSeparator As String = ""
    'Public Property BottomMenuLinkSeparator() As String
    '    Get
    '        Return sBottomMenuLinkSeparator
    '    End Get
    '    Set(ByVal value As String)
    '        sBottomMenuLinkSeparator = value
    '    End Set
    'End Property

    'Same Level Pages Bullet
    'Private sSameLevelPagesBullet As String = ""
    'Public Property SameLevelPagesBullet() As String
    '    Get
    '        Return sSameLevelPagesBullet
    '    End Get
    '    Set(ByVal value As String)
    '        sSameLevelPagesBullet = value
    '    End Set
    'End Property

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
End Class
