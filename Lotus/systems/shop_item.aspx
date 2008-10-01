<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>


<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nOrderId As Integer
    Private sCurrencySymbol As String = ""
    Private sCurrencySeparator As String = ""
    Private nRootId As Integer
    Private nSubtotal As Decimal
    Private nShipping As Decimal
    Private nTax As Decimal
    
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
        lblStatusLabel.Text = GetLocalResourceObject("lblStatusLabel.Text")
        lblShippedLabel.Text = GetLocalResourceObject("lblShippedLabel.Text")
        lblShippedDateLabel.Text = GetLocalResourceObject("lblShippedDateLabel.Text")

        nOrderId = CInt(Request.QueryString("oid"))

        If Not Page.IsPostBack Then
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
            
                lblID.Text = oDataReader("order_id").ToString
                lblDate.Text = FormatDateTime(oDataReader("order_date"), DateFormat.LongDate) & " " & FormatDateTime(oDataReader("order_date"), DateFormat.ShortTime)
                Dim sOrderBy As String = oDataReader("order_by").ToString
                lblOrderBy.Text = sOrderBy & " - " & Membership.GetUser(sOrderBy).Email
                If Not IsDBNull(oDataReader("shipping_first_name")) Then
                    Dim sShipping As String
                    sShipping = "<div>" & oDataReader("shipping_first_name").ToString & " " & oDataReader("shipping_last_name").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_company").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_address").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_city").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_state").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_country").ToString & "</div>" & _
                        "<div>" & oDataReader("shipping_zip").ToString & "</div>" & _
                        "<div>Ph." & oDataReader("shipping_phone").ToString & "</div>"
                    If Not oDataReader("shipping_fax").ToString = "" Then
                        sShipping += "<div>Fax." & oDataReader("shipping_fax").ToString & "</div>"
                    End If
                    lblShippingInfo.Text = sShipping
                    idShipping.Visible = True
                    idShipping2.Visible = True
                    idShipping3.Visible = True
                    If oDataReader("shipping_status").ToString = "SHIPPED" Then
                        chkShipped.Checked = True
                    Else
                        chkShipped.Checked = False
                    End If
                    If Not IsDBNull(oDataReader("shipped_date")) Then
                        Dim dShippedDate As DateTime = Convert.ToDateTime(oDataReader("shipped_date"))
                        txtShippedDate.Text = dShippedDate.Year & "/" & dShippedDate.Month & "/" & dShippedDate.Day
                    End If
                Else
                    btnSave.Visible = False
                End If
                lblStatus.Text = ShowStatus(oDataReader("status").ToString)
            
                nSubtotal = oDataReader("sub_total")
                nShipping = oDataReader("shipping")
                nTax = oDataReader("tax")
            
            End If
            oDataReader.Close()
            oCmd.Dispose()
            oConn.Close()
        
            GetConfigShop()
        
            lblItems.Text = ShowItems(nOrderId)
            lblTotal.Text = ShowTotal(nSubtotal, nShipping, nTax)
        End If
        
        btnClose.OnClientClick = "self.close()"
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
            Return "Waiting for payment"
        ElseIf sStatus = "CONFIRMED" Then
            Return "Confirmed"
        Else
            Return "Verified"
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
            sCurrencySymbol = sCurrencySymbol & sCurrencySeparator
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
        If txtShippedDate.Text = "" Then
            sSQL = "UPDATE orders SET shipping_status=@shipping_status WHERE order_id=@order_id"
        Else
            sSQL = "UPDATE orders SET shipping_status=@shipping_status, shipped_date=@shipped_date WHERE order_id=@order_id"
        End If
        oCmd.CommandText = sSQL
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oCmd.Parameters.Add("@shipping_status", SqlDbType.NVarChar, 50).Value = sShippingStatus
        If Not txtShippedDate.Text = "" Then
            oCmd.Parameters.Add("@shipped_date", SqlDbType.DateTime).Value = Convert.ToDateTime(txtShippedDate.Text)
        End If
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()
        
        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")
    End Sub
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
    <tr>
        <td valign="top" style="white-space:nowrap">
            <asp:Label ID="lblStatusLabel" meta:resourcekey="lblStatusLabel" runat="server" Text="Status"></asp:Label>
        </td>
        <td  valign="top">:</td>
        <td><asp:Label ID="lblStatus" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr id="idShipping2" runat="server" visible=false>
        <td style="white-space:nowrap">
            <asp:Label ID="lblShippedLabel" meta:resourcekey="lblShippedLabel" runat="server" Text="Shipped"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:CheckBox ID="chkShipped" Text="" runat="server" /></td>
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
