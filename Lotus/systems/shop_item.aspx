<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nOrderId As Integer
    Private sCurrencySymbol As String = ""
    Private sCurrencySeparator As String = ""
    Private sPaypalDownloadsPage As String = ""
    Private sEmailTemplate As String = ""
    Private nRootId As Integer
    Private nSubtotal As Decimal
    Private nShipping As Decimal
    Private nTax As Decimal
    Private dtOrderDate As DateTime
    Private sOrderBy As String = ""
    Private sBaseUrl As String
    Private sWebsiteUrl As String
    Private sStatus As String
    Private sShipping As String
    Private sShippingStatus As String
    Private bUseShipping As Boolean
    Private dShippedDate As DateTime
    Private sPaymentMethod As String
    Private nTimeOffset As Double = 0
    
    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            Dim Item As String
            Dim bIsAdministrator As Boolean = False
            For Each Item In Roles.GetRolesForUser(GetUser.UserName)
                If Item = "Administrators" Then
                    bIsAdministrator = True
                    Exit For
                End If
            Next
        
            If Not bIsAdministrator Then
                Response.Write("Authorization Failed.")
                Response.End()
            End If
        End If
    End Sub
    
    
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs)
        sBaseUrl = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "") & Request.ApplicationPath
        If Not sBaseUrl.EndsWith("/") Then sBaseUrl += "/"
        sWebsiteUrl = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "")
        
        nOrderId = CInt(Request.QueryString("oid"))
        
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM orders WHERE order_id=@order_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oDataReader = oCmd.ExecuteReader
        If oDataReader.Read Then
            
            nRootId = oDataReader("root_id").ToString
            dtOrderDate = oDataReader("order_date")
            sOrderBy = oDataReader("order_by").ToString
            sStatus = oDataReader("status").ToString
            nSubtotal = oDataReader("sub_total")
            nShipping = oDataReader("shipping")
            nTax = oDataReader("tax")
            dtOrderDate = Convert.ToDateTime(oDataReader("order_date")) '6/2/2007 9:58:01 AM
            sPaymentMethod = oDataReader("payment_method").ToString
            
            If Not IsDBNull(oDataReader("shipping_first_name")) Then
                bUseShipping = True
                sShipping = "<div>" & oDataReader("shipping_first_name").ToString & " " & oDataReader("shipping_last_name").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_company").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_address").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_city").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_state").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_country").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_zip").ToString & "</div>" & _
                    "<div>Ph. " & oDataReader("shipping_phone").ToString
                If Not oDataReader("shipping_fax").ToString = "" Then
                    sShipping += ", " & oDataReader("shipping_fax").ToString 
                End If
                sShipping += "</div>"
                sShippingStatus = oDataReader("shipping_status").ToString
                If Not IsDBNull(oDataReader("shipped_date")) Then
                    dShippedDate = Convert.ToDateTime(oDataReader("shipped_date"))
                End If
            Else
                bUseShipping = False
            End If

        End If
        oDataReader.Close()
        
        Dim sSQL As String = "SELECT locales.time_offset FROM pages_working INNER JOIN locales ON pages_working.file_name = locales.home_page WHERE pages_working.root_id=" & nRootId
        oCmd = New SqlCommand(sSQL, oConn)
        oDataReader = oCmd.ExecuteReader()
        If oDataReader.Read() Then
            nTimeOffset = oDataReader("time_offset")
        End If
        oDataReader.Close()
        
        oCmd.Dispose()
        oConn.Close()

        GetConfigShop()
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
        lblIDLabel.Text = GetLocalResourceObject("lblIDLabel.Text")
        lblDateLabel.Text = GetLocalResourceObject("lblDateLabel.Text")
        lblCustomerLabel.Text = GetLocalResourceObject("lblCustomerLabel.Text")
        lblShippingInfoLabel.Text = GetLocalResourceObject("lblShippingInfoLabel.Text")
        lblItemsLabel.Text = GetLocalResourceObject("lblItemsLabel.Text")
        lblTotalLabel.Text = GetLocalResourceObject("lblTotalLabel.Text")
        lblShippedDateLabel.Text = GetLocalResourceObject("lblShippedDateLabel.Text")
        lblPayment.Text = GetLocalResourceObject("lblPayment.Text")
        chkPaid.Text = GetLocalResourceObject("chkPaid.Text")
        lblShipment.Text = GetLocalResourceObject("lblShipment.Text")
        chkShipped.Text = GetLocalResourceObject("chkShipped.Text")
        
        If Not Page.IsPostBack Then
            If bUseShipping Then
                If sShippingStatus = "SHIPPED" Then
                    chkShipped.Checked = True
                Else
                    chkShipped.Checked = False
                End If
            End If
            If sStatus = "VERIFIED" Then
                chkPaid.Checked = True
            Else
                chkPaid.Checked = False
            End If
        End If
        If bUseShipping Then
            'Shippable
            lblShippingInfo.Text = sShipping
            idShipping.Visible = True
            idShipping2.Visible = True
            idShipping3.Visible = True
            If sShippingStatus <> "" Then
                txtShippedDate.Text = dShippedDate.AddHours(nTimeOffset).Year & "/" & dShippedDate.AddHours(nTimeOffset).Month & "/" & dShippedDate.AddHours(nTimeOffset).Day
            End If
            
            If sPaymentMethod = "PAYPAL" Then
                lblPaymentMethod.Text = "Paypal (" & ShowStatus(sStatus) & ")&nbsp;"
                chkPaid.Visible = False
            ElseIf sPaymentMethod = "CASH_ON_DELIVERY" Then
                lblPaymentMethod.Text = "COD (" & ShowStatus(sStatus) & ")&nbsp;"
            End If
        Else
            'Downloadable
            If sPaymentMethod = "PAYPAL" Then
                btnSave.Visible = False
                idPayment.Visible = False
            ElseIf sPaymentMethod = "CASH_ON_DELIVERY" Then
                lblPaymentMethod.Text = "COD (" & ShowStatus(sStatus) & ")&nbsp;"
            End If
        End If

        lblOrderBy.Text = sOrderBy & " - " & Membership.GetUser(sOrderBy).Email
        lblID.Text = nOrderId
        lblDate.Text = dtOrderDate.AddHours(nTimeOffset) 'FormatDateTime(dtOrderDate, DateFormat.LongDate) & " " & FormatDateTime(dtOrderDate, DateFormat.ShortTime)
        lblItems.Text = ShowItems(nOrderId)
        lblTotal.Text = ShowTotal(nSubtotal, nShipping, nTax)
        'lblStatus.Text = ShowStatus(sStatus)
        
        btnClose.OnClientClick = "parent.icCloseDlg();return false;" '"self.close()"
    End Sub
    
    Function ShowItems(ByVal nOrderId As Integer) As String
        Dim sHTML As String = ""
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM order_items WHERE order_id=@order_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oDataReader = oCmd.ExecuteReader
        While oDataReader.Read
            sHTML += "<div>" & oDataReader("item_id").ToString & ". " & oDataReader("item_desc").ToString & "(" & oDataReader("qty").ToString & ") - " & sCurrencySymbol & FormatNumber(oDataReader("price"), 2) & "</div>"
        End While
        oDataReader.Close()
        oCmd.Dispose()
        oConn.Close()
        
        Return sHTML
    End Function
    
    Function ShowTotal(ByVal nSubTotal As Decimal, ByVal nShipping As Decimal, ByVal nTax As Decimal) As String
        Dim sHTML As String
        If nShipping > 0 Or nTax > 0 Then
            sHTML = sCurrencySymbol & FormatNumber(nSubTotal, 2) & "&nbsp;(subtotal)"
        Else
            Return sCurrencySymbol & FormatNumber(nSubTotal, 2)
        End If
        If nShipping > 0 Then
            sHTML += "<br />" & sCurrencySymbol & FormatNumber(nShipping, 2) & "&nbsp;(shipping)"
        End If
        If nTax > 0 Then
            sHTML += "<br />" & sCurrencySymbol & FormatNumber(nTax, 2) & "&nbsp;(tax)"
        End If
        Return sHTML
    End Function
    
    Function ShowStatus(ByVal sStatus As String) As String
        If sStatus = "WAITING_FOR_PAYMENT" Then
            Return "Waiting"
        ElseIf sStatus = "CONFIRMED" Then
            Return "Waiting"
        Else
            Return "Completed"
        End If
    End Function
    
    Sub GetConfigShop()
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM config_shop WHERE root_id=@root_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = nRootId
        oDataReader = oCmd.ExecuteReader
        While oDataReader.Read
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
        End While
        oDataReader.Close()
        oCmd.Dispose()
        oConn.Close()
    End Sub
            
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Dim sShippingStatus As String = ""
        If chkShipped.Checked Then
            sShippingStatus = "SHIPPED"
        End If
        
        Dim sSQL As String
        Dim oCmd As SqlCommand
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        sSQL = "UPDATE orders SET shipping_status=@shipping_status, shipped_date=@shipped_date WHERE order_id=@order_id"
        oCmd.CommandText = sSQL
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oCmd.Parameters.Add("@shipping_status", SqlDbType.NVarChar, 50).Value = sShippingStatus
        If txtShippedDate.Text = "" Then
            oCmd.Parameters.Add("@shipped_date", SqlDbType.DateTime).Value = Now
        Else
            Dim dTmp As DateTime = Convert.ToDateTime(txtShippedDate.Text)
            oCmd.Parameters.Add("@shipped_date", SqlDbType.DateTime).Value = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 23, 59, 59).AddHours(-nTimeOffset)
        End If
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()

        If sStatus <> "VERIFIED" And chkPaid.Checked = True Then
            SetPaidAndSendReceipt()
        End If
        If sStatus = "VERIFIED" And chkPaid.Checked = False Then
            '*** update status ***
            Dim oCommand As SqlCommand
            oCommand = New SqlCommand("UPDATE orders set status='WAITING_FOR_PAYMENT' where order_id=@order_id")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
            oConn.Open()
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
            oConn.Close()
        End If
        
        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")
    End Sub
    
    Protected Sub SetPaidAndSendReceipt()
        Dim nOrderId As Integer = Request.QueryString("oid")
        
        '*** update status ***
        Dim oCommand As SqlCommand
        oCommand = New SqlCommand("UPDATE orders set status='VERIFIED' where order_id=@order_id")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oConn.Open()
        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()
        oConn.Close()
        
        '*** order items ***
        Dim oDataReader As SqlDataReader
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
        sBody = sBody.Replace("[%ORDER_DATE%]", dtOrderDate.AddHours(nTimeOffset).ToString)
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
    End Sub
    
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
    function adjustHeight()
        {
        if(navigator.appName.indexOf('Microsoft')!=-1)
            document.getElementById('cellContent').height=365;
        else
            document.getElementById('cellContent').height=365;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:7px;background-color:#E6E7E8">
<form id="form1" runat="server">

<table style="width:100%" cellpadding="0" cellspacing="0">
<tr>
<td id="cellContent" valign="top">
    <table width="100%" cellpadding="3">
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblIDLabel" meta:resourcekey="lblIDLabel" runat="server" Text="ID"></asp:Label>
        </td>
        <td>:</td>
        <td style="width:100%"><asp:Label ID="lblID" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblDateLabel" meta:resourcekey="lblDateLabel" runat="server" Text="Date"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:Label ID="lblDate" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblCustomerLabel" meta:resourcekey="lblCustomerLabel" runat="server" Text="Customer"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:Label ID="lblOrderBy" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr id="idShipping" runat="server" visible=false>
        <td valign="top" style="white-space:nowrap">
            <asp:Label ID="lblShippingInfoLabel" meta:resourcekey="lblShippingInfoLabel" runat="server" Text="Shipping"></asp:Label>
        </td>
        <td  valign="top">:</td>
        <td><asp:Label ID="lblShippingInfo" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr>
        <td valign="top" style="white-space:nowrap">
            <asp:Label ID="lblItemsLabel" meta:resourcekey="lblItemsLabel" runat="server" Text="Items"></asp:Label>
        </td>
        <td  valign="top">:</td>
        <td><asp:Label ID="lblItems" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr>
        <td valign="top" style="white-space:nowrap">
            <asp:Label ID="lblTotalLabel" meta:resourcekey="lblTotalLabel" runat="server" Text="Total"></asp:Label>
        </td>
        <td  valign="top">:</td>
        <td><asp:Label ID="lblTotal" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr id="idPayment" runat="server">
        <td style="white-space:nowrap">
            <asp:Label ID="lblPayment" meta:resourcekey="lblPayment" runat="server" Text="Payment"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:Label ID="lblPaymentMethod" runat="server" Text=""></asp:Label>
            <asp:CheckBox ID="chkPaid" meta:resourcekey="chkPaid" Text="Paid" runat="server" />
        </td>
    </tr>
    <tr id="idShipping2" runat="server" visible=false>
        <td style="white-space:nowrap">
            <asp:Label ID="lblShipment" meta:resourcekey="lblShipment" runat="server" Text="Shipment"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:CheckBox ID="chkShipped" meta:resourcekey="chkShipped" Text="Shipped" runat="server" /></td>
    </tr>
    <tr id="idShipping3" runat="server" visible=false>
        <td style="white-space:nowrap">
            <asp:Label ID="lblShippedDateLabel" meta:resourcekey="lblShippedDateLabel" runat="server" Text="Shipped Date"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtShippedDate" Width="60" runat="server"></asp:TextBox>
            <i>(YYYY/MM/DD)</i>
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
