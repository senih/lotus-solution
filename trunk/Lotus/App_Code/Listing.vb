Imports System
Imports System.Data
Imports System.Data.SqlClient

Public Class TemplateListing
    Implements System.Web.UI.ITemplate

    Private oListItemType As ListItemType
    Private nListingTemplateId As Integer
    Private nRootId As Integer

    Private sCurrencySymbol As String
    Private sCurrencySeparator As String
    Private sPaypalCartPage As String

    Private oKey As Collection = New Collection
    Private sConn As String
    Private oConn As SqlConnection

    Private bIsReader As Boolean

    Sub New(ByVal type As ListItemType, ByVal template As Integer, ByVal root As Integer, Optional ByVal bIsRdr As Boolean = True)
        oListItemType = type
        nListingTemplateId = template
        nRootId = root
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)

        bIsReader = bIsRdr

        '*** Config Shop ***
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM config_shop WHERE root_id=@root_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        reader = oCmd.ExecuteReader
        While reader.Read
            sCurrencySymbol = reader("currency_symbol").ToString
            sCurrencySeparator = reader("currency_separator").ToString
            If sCurrencySymbol.Length > 1 Then
                sCurrencySymbol = sCurrencySymbol.Substring(0, 1).ToUpper() & sCurrencySymbol.Substring(1).ToString
            End If
            sCurrencySymbol = sCurrencySymbol & sCurrencySeparator

            If nRootId = 1 Then
                sPaypalCartPage = "shop_pcart.aspx"
            Else
                sPaypalCartPage = "shop_pcart_" & nRootId & ".aspx"
            End If
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()
        '*** /Config Shop ***
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub

    Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) _
        Implements System.Web.UI.ITemplate.InstantiateIn

        Dim ph As New PlaceHolder()

        Dim litText1 As New Literal
        Dim litText2 As New Literal
        Dim litText3 As New Literal
        Dim litText4 As New Literal
        Dim litText5 As New Literal
        Dim litText6 As New Literal
        Dim litText7 As New Literal
        Dim litText8 As New Literal
        Dim litText9 As New Literal
        Dim litText10 As New Literal
        Dim litText11 As New Literal
        Dim litText12 As New Literal
        Dim litText13 As New Literal
        Dim litText14 As New Literal
        Dim litText15 As New Literal
        Dim litText16 As New Literal
        Dim litText17 As New Literal
        Dim litText18 As New Literal
        Dim litText19 As New Literal
        Dim litText20 As New Literal
        Dim litText21 As New Literal
        Dim litText22 As New Literal
        Dim litText23 As New Literal
        Dim litText24 As New Literal
        Dim litText25 As New Literal
        Dim litText26 As New Literal
        Dim litText27 As New Literal
        Dim litText28 As New Literal
        Dim litText29 As New Literal
        Dim litText30 As New Literal
        Dim litText31 As New Literal
        Dim litText32 As New Literal
        Dim litText33 As New Literal
        Dim litText34 As New Literal
        Dim litText35 As New Literal
        Dim litText36 As New Literal
        Dim litText37 As New Literal
        Dim litText38 As New Literal
        Dim litText39 As New Literal
        Dim litText40 As New Literal
        litText1.ID = "litText1"
        litText2.ID = "litText2"
        litText3.ID = "litText3"
        litText4.ID = "litText4"
        litText5.ID = "litText5"
        litText6.ID = "litText6"
        litText7.ID = "litText7"
        litText8.ID = "litText8"
        litText9.ID = "litText9"
        litText10.ID = "litText10"
        litText11.ID = "litText11"
        litText12.ID = "litText12"
        litText13.ID = "litText13"
        litText14.ID = "litText14"
        litText15.ID = "litText15"
        litText16.ID = "litText16"
        litText17.ID = "litText17"
        litText18.ID = "litText18"
        litText19.ID = "litText19"
        litText20.ID = "litText20"
        litText21.ID = "litText21"
        litText22.ID = "litText22"
        litText23.ID = "litText23"
        litText24.ID = "litText24"
        litText25.ID = "litText25"
        litText26.ID = "litText26"
        litText27.ID = "litText27"
        litText28.ID = "litText28"
        litText29.ID = "litText29"
        litText30.ID = "litText30"
        litText31.ID = "litText31"
        litText32.ID = "litText32"
        litText33.ID = "litText33"
        litText34.ID = "litText34"
        litText35.ID = "litText35"
        litText36.ID = "litText36"
        litText37.ID = "litText37"
        litText38.ID = "litText38"
        litText39.ID = "litText39"
        litText40.ID = "litText40"


        Dim sTemplate As String = ""
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM listing_templates WHERE id=@id"

        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = nListingTemplateId
        reader = oCmd.ExecuteReader
        While reader.Read
            sTemplate = reader("template").ToString()
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()

        'Dim sTmp As String = ""

        Dim nStart As Integer
        Dim nEnd As Integer
        Dim nLen As Integer

        Select Case (oListItemType)
            Case ListItemType.Header
                'ph.Controls.Add(New LiteralControl("<table class=""newspost"" cellpadding=""0"" cellspacing=""0"">"))
            Case ListItemType.Item

                oKey.Clear()

                nStart = sTemplate.IndexOf("[%")
                nEnd = sTemplate.IndexOf("%]") + 2
                nLen = nEnd - nStart

                Dim nOrder As Integer = 1
                While Not nStart = -1

                    ph.Controls.Add(New LiteralControl(sTemplate.Substring(0, nStart)))

                    Select Case nOrder
                        Case 1
                            ph.Controls.Add(litText1)
                        Case 2
                            ph.Controls.Add(litText2)
                        Case 3
                            ph.Controls.Add(litText3)
                        Case 4
                            ph.Controls.Add(litText4)
                        Case 5
                            ph.Controls.Add(litText5)
                        Case 6
                            ph.Controls.Add(litText6)
                        Case 7
                            ph.Controls.Add(litText7)
                        Case 8
                            ph.Controls.Add(litText8)
                        Case 9
                            ph.Controls.Add(litText9)
                        Case 10
                            ph.Controls.Add(litText10)
                        Case 11
                            ph.Controls.Add(litText11)
                        Case 12
                            ph.Controls.Add(litText12)
                        Case 13
                            ph.Controls.Add(litText13)
                        Case 14
                            ph.Controls.Add(litText14)
                        Case 15
                            ph.Controls.Add(litText15)
                        Case 16
                            ph.Controls.Add(litText16)
                        Case 17
                            ph.Controls.Add(litText17)
                        Case 18
                            ph.Controls.Add(litText18)
                        Case 19
                            ph.Controls.Add(litText19)
                        Case 20
                            ph.Controls.Add(litText20)
                        Case 21
                            ph.Controls.Add(litText21)
                        Case 22
                            ph.Controls.Add(litText22)
                        Case 23
                            ph.Controls.Add(litText23)
                        Case 24
                            ph.Controls.Add(litText24)
                        Case 25
                            ph.Controls.Add(litText25)
                        Case 26
                            ph.Controls.Add(litText26)
                        Case 27
                            ph.Controls.Add(litText27)
                        Case 28
                            ph.Controls.Add(litText28)
                        Case 29
                            ph.Controls.Add(litText29)
                        Case 30
                            ph.Controls.Add(litText30)
                        Case 31
                            ph.Controls.Add(litText31)
                        Case 32
                            ph.Controls.Add(litText32)
                        Case 33
                            ph.Controls.Add(litText33)
                        Case 34
                            ph.Controls.Add(litText34)
                        Case 35
                            ph.Controls.Add(litText35)
                        Case 36
                            ph.Controls.Add(litText36)
                        Case 37
                            ph.Controls.Add(litText37)
                        Case 38
                            ph.Controls.Add(litText38)
                        Case 39
                            ph.Controls.Add(litText39)
                        Case 40
                            ph.Controls.Add(litText40)
                    End Select

                    'sTmp = sTmp + sTemplate.Substring(nStart, nLen)

                    Select Case sTemplate.Substring(nStart, nLen)
                        Case "[%LINK_TARGET%]"
                            oKey.Add("[%LINK_TARGET%]", nOrder)
                        Case "[%FILE_NAME%]"
                            oKey.Add("[%FILE_NAME%]", nOrder)
                        Case "[%TITLE%]"
                            oKey.Add("[%TITLE%]", nOrder)
                        Case "[%DISPLAY_DATE%]"
                            oKey.Add("[%DISPLAY_DATE%]", nOrder)
                        Case "[%SUMMARY%]"
                            oKey.Add("[%SUMMARY%]", nOrder)
                        Case "[%FILE_DOWNLOAD%]"
                            oKey.Add("[%FILE_DOWNLOAD%]", nOrder)
                        Case "[%FILE_DOWNLOAD_ICON%]"
                            oKey.Add("[%FILE_DOWNLOAD_ICON%]", nOrder)
                        Case "[%FILE_DOWNLOAD_URL%]"
                            oKey.Add("[%FILE_DOWNLOAD_URL%]", nOrder)
                        Case "[%FILE_VIEW_LISTING_URL%]"
                            oKey.Add("[%FILE_VIEW_LISTING_URL%]", nOrder)
                        Case "[%FILE_SIZE%]"
                            oKey.Add("[%FILE_SIZE%]", nOrder)
                        Case "[%OWNER%]"
                            oKey.Add("[%OWNER%]", nOrder)
                        Case "[%COMMENTS%]"
                            oKey.Add("[%COMMENTS%]", nOrder)
                        Case "[%LAST_UPDATED_BY%]"
                            oKey.Add("[%LAST_UPDATED_BY%]", nOrder)
                        Case "[%FIRST_PUBLISHED_DATE%]"
                            oKey.Add("[%FIRST_PUBLISHED_DATE%]", nOrder)
                        Case "[%LAST_UPDATED_DATE%]"
                            oKey.Add("[%LAST_UPDATED_DATE%]", nOrder)
                        Case "[%TOTAL_HITS%]"
                            oKey.Add("[%TOTAL_HITS%]", nOrder)
                        Case "[%HITS_TODAY%]"
                            oKey.Add("[%HITS_TODAY%]", nOrder)
                        Case "[%TOTAL_DOWNLOADS%]"
                            oKey.Add("[%TOTAL_DOWNLOADS%]", nOrder)
                        Case "[%DOWNLOADS_TODAY%]"
                            oKey.Add("[%DOWNLOADS_TODAY%]", nOrder)
                        Case ("[%RATING%]")
                            oKey.Add("[%RATING%]", nOrder)
                        Case ("[%HIDE_RATING%]")
                            oKey.Add("[%HIDE_RATING%]", nOrder)
                        Case ("[%HIDE_FILE_DOWNLOAD%]")
                            oKey.Add("[%HIDE_FILE_DOWNLOAD%]", nOrder)
                        Case ("[%HIDE_FILE_VIEW_LISTING%]")
                            oKey.Add("[%HIDE_FILE_VIEW_LISTING%]", nOrder)
                        Case "[%PAGE_ID%]"
                            oKey.Add("[%PAGE_ID%]", nOrder)
                        Case "[%PRICING_INFO%]"
                            oKey.Add("[%PRICING_INFO%]", nOrder)
                        Case "[%PAYPAL_ADD_TO_CART_URL%]"
                            oKey.Add("[%PAYPAL_ADD_TO_CART_URL%]", nOrder)
                        Case "[%HIDE_PAYPAL_ADD_TO_CART%]"
                            oKey.Add("[%HIDE_PAYPAL_ADD_TO_CART%]", nOrder)
                        Case "[%HIDE_PRICING_INFO%]"
                            oKey.Add("[%HIDE_PRICING_INFO%]", nOrder)
                        Case ("[%FILE_VIEW_LISTING_MORE_URL%]")
                            oKey.Add("[%FILE_VIEW_LISTING_MORE_URL%]", nOrder)
                        Case ("[%FILE_VIEW_URL%]")
                            oKey.Add("[%FILE_VIEW_URL%]", nOrder)
                        Case ("[%HIDE_FILE_VIEW%]")
                            oKey.Add("[%HIDE_FILE_VIEW%]", nOrder)
                        Case ("[%CATEGORY_INFO%]")
                            oKey.Add("[%CATEGORY_INFO%]", nOrder)
                        Case ("[%HIDE%]")
                            oKey.Add("[%HIDE%]", nOrder)
                        Case ("[%INDEX%]")
                            oKey.Add("[%INDEX%]", nOrder)
                    End Select

                    sTemplate = sTemplate.Substring(nEnd)

                    nStart = sTemplate.IndexOf("[%")
                    nEnd = sTemplate.IndexOf("%]") + 2
                    nLen = nEnd - nStart

                    nOrder = nOrder + 1
                End While

                'sTmp = sTmp + sTemplate.Substring(0)

                ph.Controls.Add(New LiteralControl(sTemplate.Substring(0)))

                AddHandler ph.DataBinding, New EventHandler(AddressOf Item_DataBinding)

            Case ListItemType.AlternatingItem

            Case ListItemType.Footer
                'ph.Controls.Add(New LiteralControl("</table>"))
        End Select

        container.Controls.Add(ph)
    End Sub

    Private nIndex As Integer = 0

    Private Sub Item_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ph As PlaceHolder = CType(sender, PlaceHolder)
        Dim ri As DataListItem = CType(ph.NamingContainer, DataListItem) 'Dim ri As GridViewRow = CType(ph.NamingContainer, GridViewRow)

        Dim i As Integer
        For i = 1 To 15 'max 40
            If Not IsNothing(ph.FindControl("litText" & i.ToString)) Then
                Select Case oKey(i).ToString
                    Case "[%PAGE_ID%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "page_id"))
                    Case "[%LINK_TARGET%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "link_target"))
                    Case "[%FILE_NAME%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_name"))
                    Case "[%TITLE%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = HttpUtility.HtmlEncode(Convert.ToString(DataBinder.Eval(ri.DataItem, "title")))
                    Case "[%OWNER%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "owner"))
                    Case "[%DISPLAY_DATE%]"
                        Dim sTime As String
                        Dim dDisplayDate As DateTime = DataBinder.Eval(ri.DataItem, "display_date")
                        If dDisplayDate.Hour = 0 And dDisplayDate.Minute = 0 Then
                            sTime = ""
                        Else
                            sTime = " - " & FormatDateTime(dDisplayDate, DateFormat.ShortTime)
                        End If

                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = FormatDateTime(dDisplayDate, DateFormat.LongDate) & sTime
                    Case "[%SUMMARY%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "summary"))
                    Case "[%FILE_DOWNLOAD_URL%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_download_url"))
                    Case "[%FILE_VIEW_LISTING_URL%]"
                        If Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_listing_url")) = "" Then
                            'krn kalau tdk diisi blank, akan selalu request www...com/ menyebabkan home page akan di-execute terus saat listing ditampilkan
                            Dim sAppPath As String = HttpContext.Current.Request.ApplicationPath
                            If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = sAppPath & "systems/images/blank.gif"
                        Else
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_listing_url"))
                        End If
                    Case "[%FILE_VIEW_LISTING_MORE_URL%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_listing_more_url"))
                    Case "[%FILE_VIEW_URL%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_url"))
                    Case "[%FILE_SIZE%]"
                        Dim sFileSize As String
                        Dim nFileSize As Integer
                        If Not IsDBNull(DataBinder.Eval(ri.DataItem, "file_size")) Then
                            nFileSize = Convert.ToInt32(DataBinder.Eval(ri.DataItem, "file_size"))
                            If nFileSize < 1024 Then
                                sFileSize = nFileSize & " bytes"
                            Else
                                sFileSize = FormatNumber((nFileSize / 1024), 0) & " KB"
                            End If
                        Else
                            nFileSize = 0
                            sFileSize = ""
                        End If
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sFileSize
                    Case "[%COMMENTS%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "comments"))
                    Case "[%FIRST_PUBLISHED_DATE%]"
                        If IsDBNull(DataBinder.Eval(ri.DataItem, "first_published_date")) Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = ""
                        Else
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = FormatDateTime(DataBinder.Eval(ri.DataItem, "first_published_date"), DateFormat.LongDate)
                        End If
                    Case "[%LAST_UPDATED_BY%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "last_updated_by"))
                    Case "[%LAST_UPDATED_DATE%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = FormatDateTime(DataBinder.Eval(ri.DataItem, "last_updated_date"), DateFormat.LongDate)
                    Case "[%TOTAL_HITS%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "total_hits"))
                    Case "[%HITS_TODAY%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "hits_today"))
                    Case "[%TOTAL_DOWNLOADS%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "total_downloads"))
                    Case "[%DOWNLOADS_TODAY%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "downloads_today"))
                    Case "[%RATING%]"
                        Dim nRating As Decimal
                        nRating = DataBinder.Eval(ri.DataItem, "rating")
                        Dim sImage As String = ""
                        Dim sAppPath As String = HttpContext.Current.Request.ApplicationPath
                        If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"
                        If nRating = 0 Then
                            sImage = ""
                        ElseIf nRating = 1 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star10.gif"" />"
                        ElseIf nRating > 1 And nRating < 2 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star15.gif"" />"
                        ElseIf nRating = 2 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star20.gif"" />"
                        ElseIf nRating > 2 And nRating < 3 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star25.gif"" />"
                        ElseIf nRating = 3 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star30.gif"" />"
                        ElseIf nRating > 3 And nRating < 4 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star35.gif"" />"
                        ElseIf nRating = 4 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star40.gif"" />"
                        ElseIf nRating > 4 And nRating < 5 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star45.gif"" />"
                        ElseIf nRating = 5 Then
                            sImage = "<img src=""" & sAppPath & "systems/images/stars/star50.gif"" />"
                        End If
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sImage '(DataBinder.Eval(ri.DataItem, "rating"))
                    Case "[%HIDE_FILE_DOWNLOAD%]"
                        If Convert.ToString(DataBinder.Eval(ri.DataItem, "file_download_url")) = "" Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        Else
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = ""
                        End If
                    Case "[%HIDE_FILE_VIEW_LISTING%]"
                        If Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_listing_url")) = "" Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        Else
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = ""
                        End If
                    Case "[%HIDE_FILE_VIEW%]"
                        If Convert.ToString(DataBinder.Eval(ri.DataItem, "file_view_url")) = "" Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        Else
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = ""
                        End If
                    Case "[%PRICING_INFO%]"
                        Dim sPricingInfo As String = ""
                        If Not DataBinder.Eval(ri.DataItem, "price") = 0 Then
                            If DataBinder.Eval(ri.DataItem, "current_price") = DataBinder.Eval(ri.DataItem, "price") Then
                                sPricingInfo = sCurrencySymbol & FormatNumber(DataBinder.Eval(ri.DataItem, "price"), 2)
                            Else
                                sPricingInfo = "<strike>" & sCurrencySymbol & FormatNumber(DataBinder.Eval(ri.DataItem, "price"), 2) & "</strike>&nbsp;" & sCurrencySymbol & FormatNumber(DataBinder.Eval(ri.DataItem, "current_price"), 2)
                            End If
                        End If
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sPricingInfo
                    Case "[%PAYPAL_ADD_TO_CART_URL%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sPaypalCartPage & "?item=" & Convert.ToString(DataBinder.Eval(ri.DataItem, "page_id"))
                    Case "[%HIDE_PAYPAL_ADD_TO_CART%]"
                        If DataBinder.Eval(ri.DataItem, "price") = 0 Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        End If
                    Case "[%HIDE_PRICING_INFO%]"
                        If DataBinder.Eval(ri.DataItem, "price") = 0 Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        End If
                    Case "[%RATING%]"
                        Dim nRating As Decimal
                        nRating = DataBinder.Eval(ri.DataItem, "rating")
                        If nRating = 0 Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        End If
                    Case "[%FILE_DOWNLOAD%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = Convert.ToString(DataBinder.Eval(ri.DataItem, "file_download"))
                    Case "[%FILE_DOWNLOAD_ICON%]"
                        Dim sAppPath As String = HttpContext.Current.Request.ApplicationPath
                        If Not sAppPath.EndsWith("/") Then sAppPath = sAppPath & "/"

                        Dim sIcon As String

                        If Convert.ToString(DataBinder.Eval(ri.DataItem, "file_download")) = "" Then
                            sIcon = sAppPath & "systems/images/blank.gif"
                        Else
                            Dim sFileDownload As String
                            sFileDownload = DataBinder.Eval(ri.DataItem, "file_download")
                            Dim sFileViewURL As String
                            sFileViewURL = DataBinder.Eval(ri.DataItem, "file_view_url")

                            Dim sFileExt As String = ""
                            If Not sFileDownload = "" Then
                                sFileExt = sFileDownload.Substring(sFileDownload.LastIndexOf(".") + 1).ToLower
                            Else
                                If Not sFileViewURL = "" Then
                                    sFileExt = sFileViewURL.Substring(sFileViewURL.LastIndexOf(".") + 1).ToLower
                                End If
                            End If

                            If Not sFileExt = "" Then
                                If sFileExt = "bmp" Or _
                                    sFileExt = "gif" Or _
                                    sFileExt = "jpg" Or _
                                    sFileExt = "jpeg" Or _
                                    sFileExt = "png" Then
                                    sIcon = sAppPath & "systems/images/files/ico_image.gif"
                                ElseIf sFileExt = "mov" Or _
                                    sFileExt = "mpg" Or _
                                    sFileExt = "mpeg" Or _
                                    sFileExt = "wmv" Or _
                                    sFileExt = "avi" Then
                                    sIcon = sAppPath & "systems/images/files/ico_video.gif"
                                ElseIf sFileExt = "mp3" Or _
                                    sFileExt = "wav" Or _
                                    sFileExt = "mid" Or _
                                    sFileExt = "wma" Then
                                    sIcon = sAppPath & "systems/images/files/ico_audio.gif"
                                ElseIf sFileExt = "exe" Then
                                    sIcon = sAppPath & "systems/images/files/ico_exe.gif"
                                ElseIf sFileExt = "doc" Then
                                    sIcon = sAppPath & "systems/images/files/ico_doc.gif"
                                ElseIf sFileExt = "mdb" Then
                                    sIcon = sAppPath & "systems/images/files/ico_mdb.gif"
                                ElseIf sFileExt = "ppt" Then
                                    sIcon = sAppPath & "systems/images/files/ico_ppt.gif"
                                ElseIf sFileExt = "xls" Then
                                    sIcon = sAppPath & "systems/images/files/ico_xls.gif"
                                ElseIf sFileExt = "pdf" Then
                                    sIcon = sAppPath & "systems/images/files/ico_pdf.gif"
                                ElseIf sFileExt = "swf" Or _
                                    sFileExt = "flv" Then
                                    sIcon = sAppPath & "systems/images/files/ico_swf.gif"
                                ElseIf sFileExt = "txt" Then
                                    sIcon = sAppPath & "systems/images/files/ico_txt.gif"
                                ElseIf sFileExt = "zip" Then
                                    sIcon = sAppPath & "systems/images/files/ico_zip.gif"
                                Else
                                    sIcon = sAppPath & "systems/images/files/ico_txt.gif"
                                End If
                            Else
                                sIcon = sAppPath & "systems/images/blank.gif"
                            End If
                        End If
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sIcon
                    Case "[%CATEGORY_INFO%]"
                        Dim oContentManager As ContentManager = New ContentManager
                        Dim oReaderCategories As SqlDataReader
                        Dim sCategories As String = ""
                        oReaderCategories = oContentManager.GetPageCategories(Convert.ToString(DataBinder.Eval(ri.DataItem, "page_id")))
                        Dim bIsUncategorized As Boolean = True
                        While oReaderCategories.Read()
                            bIsUncategorized = False
                            If Not sCategories = "" Then sCategories += ", "
                            sCategories = sCategories & oReaderCategories("listing_category_name").ToString
                        End While
                        oReaderCategories.Close()
                        If bIsUncategorized Then
                            sCategories = "-" 'Uncategorized
                        End If
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = sCategories
                        oReaderCategories = Nothing
                        oContentManager = Nothing
                    Case "[%HIDE%]"
                        If bIsReader Then
                            CType(ph.FindControl("litText" & i.ToString), Literal).Text = "display:none;"
                        End If
                    Case "[%INDEX%]"
                        CType(ph.FindControl("litText" & i.ToString), Literal).Text = nIndex

                End Select
            End If
        Next
        nIndex = nIndex + 1
    End Sub

End Class



