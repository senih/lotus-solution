<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            'SendMail(New String() {""}, "ok", "start", False)

            '*** verify ***
            If Not IsVerified() Then
                Exit Sub
            End If
             
            '*** paypal ***
            Dim nOrderId As Integer = Convert.ToInt32(Request.Params("custom"))
            'Dim sPaymentStatus As String = Request.Params("payment_status")'sPaymentStatus=Completed
            Dim nAmount As Decimal = Convert.ToDecimal(Request.Params("mc_gross"), System.Globalization.CultureInfo.CreateSpecificCulture("en-US")) 'nAmount=3.00

            '*** order ***
            Dim bOk As Boolean = False
        
            Dim sWebsiteUrl As String = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "")
            'WebsiteUrl=http://www.insitecreation.com
            Dim dtOrderDate As DateTime
            Dim nRootId As Integer
            Dim nShipping As Decimal = 0
            Dim nTax As Decimal = 0
            Dim sOrderBy As String = ""
            
            Dim oConn As SqlConnection
            Dim oDataReader As SqlDataReader
            Dim oCommand As SqlCommand
            oConn = New SqlConnection(sConn)
            oConn.Open()
            oCommand = New SqlCommand("SELECT * FROM orders where order_id=@order_id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader
            If oDataReader.Read Then
                dtOrderDate = Convert.ToDateTime(oDataReader("order_date")) '6/2/2007 9:58:01 AM
                If Not IsDBNull(oDataReader("shipping")) Then
                    nShipping = Convert.ToDecimal(oDataReader("shipping")) '0.0000 
                End If
                If Not IsDBNull(oDataReader("tax")) Then
                    nTax = Convert.ToDecimal(oDataReader("tax")) '0.0000 
                End If
                sOrderBy = oDataReader("order_by").ToString 'admin
                               
                nRootId = Convert.ToInt32(oDataReader("root_id")) '1
                If nAmount >= Convert.ToDecimal(oDataReader("total")) Then
                    bOk = True
                End If
            End If
            oDataReader.Close()
            oConn.Close()

            If Not bOk Then
                oCommand.Dispose()
                oConn = Nothing
                Exit Sub
            End If

            '*** update status ***
            oCommand = New SqlCommand("UPDATE orders set status='VERIFIED', total=@total where order_id=@order_id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
            oCommand.Parameters.Add("@total", SqlDbType.Decimal).Value = nAmount
            oConn.Open()
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            oConn.Close()

            '*** shop config ***
            Dim sBaseUrl As String = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "") & Request.ApplicationPath
            If Not sBaseUrl.EndsWith("/") Then sBaseUrl += "/"
            Dim sCurrencySymbol As String = ""
            Dim sCurrencySeparator As String = ""
            Dim sPaypalDownloadsPage As String = ""
            Dim sEmailTemplate As String = ""
            oCommand = New SqlCommand("SELECT * FROM config_shop WHERE root_id=@root_id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
            oConn.Open()
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader
            If oDataReader.Read Then
                sCurrencySymbol = oDataReader("currency_symbol").ToString
                sCurrencySeparator = oDataReader("currency_separator").ToString
                If sCurrencySymbol.Length > 1 Then
                    sCurrencySymbol = sCurrencySymbol.Substring(0, 1).ToUpper() & sCurrencySymbol.Substring(1).ToString
                End If
                sCurrencySymbol = sCurrencySymbol & sCurrencySeparator '$
                If nRootId = 1 Then
                    sPaypalDownloadsPage = "shop_downloads.aspx?oid=" & nOrderId
                Else
                    sPaypalDownloadsPage = "shop_downloads_" & nRootId & ".aspx?oid=" & nOrderId
                End If
                
                sEmailTemplate = oDataReader("paypal_order_email_template").ToString
            End If
            oDataReader.Close()
            oConn.Close()

            '*** order items ***
            oCommand = New SqlCommand("SELECT * FROM order_items where order_id=@order_id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
            oConn.Open()
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader
            Dim sOrderDetail As String = "<table style=""margin-bottom:15px;width:100%;"">"
            Dim nSubTotal As Decimal = 0
            While oDataReader.Read()
                sOrderDetail += "<tr>" & _
                    "<td style=""width:100%"">" & oDataReader("item_desc").ToString & "</td>" & _
                    "<td style=""text-align:right"">" & oDataReader("qty").ToString & "</td>" & _
                    "<td style=""padding-left:30px;text-align:right"">" & sCurrencySymbol & FormatNumber(Convert.ToDecimal(oDataReader("price")), 2) & "</td>" & _
                    "</tr>"
                nSubTotal += Convert.ToInt32(oDataReader("qty")) * Convert.ToDecimal(oDataReader("price"))
            End While
            If nShipping <> 0 Or nTax <> 0 Then
                sOrderDetail += "<tr><td colspan=""2"" style=""text-align:right"">Subtotal:&nbsp;</td>" & _
                    "<td style=""text-align:right"">" & sCurrencySymbol & FormatNumber(nSubTotal, 2) & "</td></tr>"
            End If
            If nShipping <> 0 Then
                sOrderDetail += "<tr><td colspan=""2"" style=""text-align:right"">Postage and Packing:&nbsp;</td>" & _
                    "<td style=""text-align:right"">" & sCurrencySymbol & FormatNumber(nShipping, 2) & "</td></tr>"    
            End If
            If nTax <> 0 Then
                sOrderDetail += "<tr><td colspan=""2"" style=""text-align:right"">Tax:&nbsp;</td>" & _
                 "<td style=""text-align:right"">" & sCurrencySymbol & FormatNumber(nTax, 2) & "</td></tr>"
            End If
            sOrderDetail += "<tr><td colspan=""2"" style=""text-align:right"">Total:&nbsp;</td>" & _
            "<td style=""text-align:right"">" & sCurrencySymbol & FormatNumber(nSubTotal + nShipping + nTax, 2) & "</td></tr>" & _
            "</table>"
            oDataReader.Close()
            oConn.Close()
        
            '*** Send Email ***         
            Dim sDownloadLink As String
            sDownloadLink = sBaseUrl & sPaypalDownloadsPage
            Dim sBody As String = sEmailTemplate
            sBody = sBody.Replace("[%ORDER_ID%]", nOrderId.ToString)
            sBody = sBody.Replace("[%ORDER_DATE%]", dtOrderDate.ToString)
            sBody = sBody.Replace("[%ORDER_DETAIL%]", sOrderDetail)
            sBody = sBody.Replace("[%DOWNLOAD_LINK%]", sDownloadLink)
            sBody = sBody.Replace("[%WEBSITE_URL%]", sWebsiteUrl)
            Dim user As MembershipUser = Membership.GetUser(sOrderBy)
            Dim mailTo As String() = New String() {user.Email}
            If Not SendMail(mailTo, "Thank you for your order", sBody, True) Then
                'Mailing Failed...
                'Exit Sub
            End If
            
            oCommand.Dispose()
            oConn = Nothing
        Catch ex As Exception
            'SendMail(New String() {""}, "error", ex.Source.ToString & vbCrLf & ex.Message.ToString, False)
        End Try
    End Sub
    
    Private Function IsVerified() As Boolean
        Dim sResponse As String = ""
        Dim sPost As String = Request.Form.ToString() & "&cmd=_notify-validate"
        Dim sPaypalURL As String = "https://www.sandbox.paypal.com/us/cgi-bin/webscr"
        
        Dim oRequest As HttpWebRequest
        oRequest = WebRequest.Create(sPaypalURL)
        oRequest.Method = "POST"
        oRequest.ContentType = "application/x-www-form-urlencoded"
        oRequest.ContentLength = sPost.Length
        
        Dim oWriter As New StreamWriter(oRequest.GetRequestStream, System.Text.Encoding.ASCII)
        oWriter.Write(sPost)
        oWriter.Close()
        
        Dim oReader As New StreamReader(oRequest.GetResponse.GetResponseStream)
        sResponse = oReader.ReadToEnd
        oReader.Close()
        
        If sResponse = "VERIFIED" Then
            Return True
        Else
            Return False
        End If
    End Function
    
    Private Function SendMail(ByVal mailTo() As String, ByVal sSubject As String, ByVal sBody As String, ByVal bIsHTML As Boolean) As Boolean
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage

        Try
            Dim i As Integer
            For i = 0 To UBound(mailTo)
                oMailMessage.To.Add(mailTo(i))
            Next

            oMailMessage.Subject = sSubject
            oMailMessage.IsBodyHtml = bIsHTML
            oMailMessage.Body = sBody

            oSmtpClient.Send(oMailMessage)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function
</script>


