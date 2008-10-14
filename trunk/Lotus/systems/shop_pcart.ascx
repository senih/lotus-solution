<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Net.Mail " %>
<%@ Import Namespace="Registration" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    '*** Configuration ***
    Private sCurrencySymbol As String
    Private sCurrencySeparator As String
    Private sCurrencyCode As String
    Private sOrderDescription As String
    Private sTerms As String

    Private sPaypalCartPage As String
    Private sPaypalNotifyPage As String
    Private sPaypalReturnPage As String
    Private sPaypalCancelPage As String
    Private sPaypalEmail As String
    Private sPaypalURL As String
    Private bUsePaypal As Boolean
    Private bUseCashOnDelivery As Boolean
    Private sCODOrderConfirmTemplate As String
    '*** /Configuration ***
    
    Private dtCart As DataTable
    Private dtShipping As DataTable
    Private nItemId As Integer 'utk add to cart
    Private bUseShipping As Boolean = False 'if there is tangible product
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        GetConfigShop()
        
        If Not Me.IsUserLoggedIn Then
            Session("shipping") = Nothing
        End If
        
        If IsNothing(Session("shipping")) Then
            CreateShipping()
        Else
            dtShipping = Session("shipping")
        End If
               
        If IsNothing(Session("Cart")) Then
            CreateCart()
        Else
            dtCart = Session("Cart")
            
            'If there is tangible product, then use shipping
            Dim drCart As DataRow
            For Each drCart In dtCart.Rows
                If Convert.ToBoolean(drCart("tangible")) Then
                    bUseShipping = True
                    Exit For
                End If
            Next
        End If
        
        If Not Page.IsPostBack Then
            If Request.QueryString("s") = "ship" Then
                If Me.IsUserLoggedIn Then
                    If bUseShipping Then
                        Wizard1.ActiveStepIndex = 2 'Show Shipping (Form)
                        ShowShipping()
                    Else
                        Wizard1.ActiveStepIndex = 3 'Show Order Review
                        ShowReview()
                    End If
                Else
                    Response.Redirect(HttpContext.Current.Items("_page"))
                End If
            Else
                If Not IsNothing(Request.QueryString("item")) Then
                    nItemId = CInt(Request.QueryString("item"))
                    AddToCart(nItemId)
                End If
                
                'Wizard1.ActiveStepIndex = 0
                
                GridView1.DataSource = dtCart
                GridView1.DataBind()
                lblSubTotal.Text = sCurrencySymbol & FormatNumber(GetSubTotal(), 2)
                
                If GridView1.Rows.Count = 0 Then 'cart empty                    
                    Wizard1.Visible = False
                    panelEmpty.Visible = True
                End If
                
                Dim sCont As String = ""
                If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
                    sCont = Request.ServerVariables("HTTP_REFERER")
                End If
                If Not sCont = "" And Not sCont.Contains(sPaypalCartPage) Then
                    lnkContinue.NavigateUrl = sCont
                Else
                    lnkContinue.Visible = False
                End If
            End If
        End If
        
        'ddShippingState.Attributes.Add("onchange", "ddStateChange(this)")
        
        lnkBack.NavigateUrl = "~/" & Me.RootFile
        If bUsePaypal And bUseCashOnDelivery Then
            'do nothing
        End If
        If bUsePaypal And Not bUseCashOnDelivery Then
            idChoosePayment.Visible = False
            idCashOnDelivery.Visible = False
        End If
        If Not bUsePaypal And bUseCashOnDelivery Then
            idChoosePayment.Visible = False
            idPaypal.Visible = False
        End If
        If Not bUsePaypal And Not bUseCashOnDelivery Then
            idChoosePayment.Visible = False
            idCashOnDelivery.Visible = False
            idPaypal.Visible = False
        End If
    End Sub
    
    Protected Sub Wizard1_NextButtonClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs)
        If Me.IsUserLoggedIn Then
            Response.Redirect(HttpContext.Current.Items("_page") & "?s=ship")
        Else
            'LOGIN
            panelLogin.Visible = True
            Login1.PasswordRecoveryUrl = "~/password.aspx?ReturnUrl=" & Request.RawUrl.Split("?")(0)

            'Note: Kalau ingin CREATE ACCOUNT (QUICK) tinggal di-enable saja, sudah di-test, tdk perlu setting lain2
            '      Keuntungan pake CREATE ACCOUNT (STANDARD): Ada option mailing list subscription, sdgkan QUICK tdk ada
            'If bUseShipping Then
                'CREATE ACCOUNT (STANDARD)
                panelCreateUser.Visible = False
                panelRegister.Visible = True
                linkRegister.NavigateUrl = "~/" & Me.LinkRegistration & "?returnurl=" & Me.AppPath & HttpContext.Current.Items("_page")
            'Else
            '    'CREATE ACCOUNT (QUICK)
            '    panelCreateUser.Visible = True
            '    panelRegister.Visible = False
            'End If
        End If
    End Sub
    
    '*** CREATE ACCOUNT (QUICK) ***
    Protected Sub CreateUserWizard1_NextButtonClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs)
        panelLogin.Visible = False
    End Sub
    Protected Sub btnContinue_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'This is after an account created
        Response.Redirect(HttpContext.Current.Items("_page") & "?s=ship")
    End Sub
    
    '*** LOGIN ***
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        'This is after login submitted
        Response.Redirect(HttpContext.Current.Items("_page") & "?s=ship")
    End Sub
    
    '*** SHOW ORDER REVIEW ***
    Protected Sub btnSaveAndReview_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        AddShipping()
        Wizard1.ActiveStepIndex = 3
        ShowReview()
    End Sub
    Protected Sub ShowReview()
        dtCart = Session("Cart")
        GridView2.DataSource = dtCart
        GridView2.DataBind()
        
        Dim nTax As Decimal = GetTax()
        Dim nShipping As Decimal = GetShipping()
        Dim nSubTotal As Decimal = GetSubTotal()
        
        lblSubTotal2.Text = sCurrencySymbol & FormatNumber(nSubTotal, 2)
        lblShipping.Text = sCurrencySymbol & FormatNumber(nShipping, 2)
        lblTax.Text = sCurrencySymbol & FormatNumber(nTax, 2)
        lblTotal.Text = sCurrencySymbol & FormatNumber(nSubTotal + nShipping + nTax, 2)
        lnkEditCart.NavigateUrl = Request.RawUrl.Split("?")(0)
        litTerms.Text = sTerms
        If nTax = 0 Then
            idTax.Visible = False
        End If
        If GetShipping() = 0 Then
            idShipping.visible = False
        End If
        If nTax = 0 And nShipping = 0 Then
            idSubTotal.visible = False
        End If
    End Sub
    
    '*** SHOW SHIPPING (FORM) ***
    Sub ShowShipping()
        dtShipping = Session("Shipping")
        Dim drShipping As DataRow
        
        oConn.Open()
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        
        If dtShipping.Rows.Count = 0 Then
            
            'Find previous saved Shipping Info from database
            oCommand = New SqlCommand("SELECT * FROM shipping_info WHERE username=@username")
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@username", SqlDbType.NVarChar, 256).Value = Me.UserName
            oCommand.Connection = oConn
            oDataReader = oCommand.ExecuteReader()
            If oDataReader.Read() Then
                drShipping = dtShipping.NewRow
                drShipping("shipping_first_name") = oDataReader("shipping_first_name")
                drShipping("shipping_last_name") = oDataReader("shipping_last_name")
                drShipping("shipping_company") = oDataReader("shipping_company")
                drShipping("shipping_address") = oDataReader("shipping_address")
                drShipping("shipping_city") = oDataReader("shipping_city")
                drShipping("shipping_state") = oDataReader("shipping_state")
                drShipping("shipping_country") = oDataReader("shipping_country")
                drShipping("shipping_zip") = oDataReader("shipping_zip")
                drShipping("shipping_phone") = oDataReader("shipping_phone")
                drShipping("shipping_fax") = oDataReader("shipping_fax")
                dtShipping.Rows.Add(drShipping)
            Else
                ddShippingState.Style.Add("display", "none")
                txtShippingState.Style.Add("display", "")
                'Clean Up
                oDataReader.Close()
                oConn.Close()
                oConn = Nothing
                Exit Sub
            End If
            oDataReader.Close()
        End If
        
        drShipping = dtShipping.Rows(0)
        
        'Country
        ddShippingCountry.Text = drShipping("shipping_country")
        
        'State
        ddShippingState.Items.Clear()
        oCommand = New SqlCommand("Select * from country_state_lookup where country=@country order by state_code")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@country", SqlDbType.VarChar, 3).Value = drShipping("shipping_country")
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read
            ddShippingState.Items.Add(New ListItem(oDataReader("state").ToString, oDataReader("state_code").ToString))
        End While
        If (ddShippingState.Items.Count > 0) Then
            ddShippingState.Style.Add("display", "")
            txtShippingState.Style.Add("display", "none")
            ddShippingState.SelectedValue = drShipping("shipping_state")
        Else
            ddShippingState.Style.Add("display", "none")
            txtShippingState.Style.Add("display", "")
            txtShippingState.Text = drShipping("shipping_state")
        End If
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
        
        'Others
        txtShippingFirstName.Text = drShipping("shipping_first_name").ToString
        txtShippingLastName.Text = drShipping("shipping_last_name").ToString
        txtShippingCompany.Text = drShipping("shipping_company").ToString
        txtShippingAddress.Text = drShipping("shipping_address").ToString
        txtShippingCity.Text = drShipping("shipping_city").ToString
        txtShippingZip.Text = drShipping("shipping_zip").ToString
        txtShippingPhone.Text = drShipping("shipping_phone").ToString
        txtShippingFax.Text = drShipping("shipping_fax").ToString
        
    End Sub
        

    '*** UTILITY ***
    Sub GetConfigShop()
        Dim oCmd As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM config_shop WHERE root_id=@root_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oDataReader = oCmd.ExecuteReader
        While oDataReader.Read
            sCurrencySymbol = oDataReader("currency_symbol").ToString
            sCurrencySeparator = oDataReader("currency_separator").ToString
            If sCurrencySymbol.Length > 1 Then
                sCurrencySymbol = sCurrencySymbol.Substring(0, 1).ToUpper() & sCurrencySymbol.Substring(1).ToString
            End If
            sCurrencySymbol = sCurrencySymbol & sCurrencySeparator
            sCurrencyCode = oDataReader("currency_code").ToString
            sOrderDescription = oDataReader("order_description").ToString

            sPaypalCartPage = Me.LinkShopPaypalCart
            sPaypalReturnPage = Me.LinkShopPaypalCompleted
            sPaypalNotifyPage = "systems/paypal_notify.aspx"
            sPaypalCancelPage = Me.RootFile
            
            sPaypalEmail = oDataReader("paypal_email").ToString
            sPaypalURL = oDataReader("paypal_url").ToString
            
            If sPaypalURL.Contains("sandbox") Then
                sPaypalNotifyPage = "systems/paypal_notify_sandbox.aspx"
            Else
                sPaypalNotifyPage = "systems/paypal_notify.aspx"
            End If
            
            sTerms = oDataReader("terms").ToString
            If Not IsDBNull(oDataReader("use_cash_on_delivery")) Then
                bUseCashOnDelivery = CBool(oDataReader("use_cash_on_delivery"))
            Else
                bUseCashOnDelivery = False
            End If
            If Not IsDBNull(oDataReader("use_paypal")) Then
                bUsePaypal = CBool(oDataReader("use_paypal"))
            Else
                bUsePaypal = False
            End If
            sCODOrderConfirmTemplate = oDataReader("cod_order_confirm_template").ToString
        End While
        oDataReader.Close()
        oCmd.Dispose()
        oConn.Close()
    End Sub
    
    Sub CreateCart()
        dtCart = New DataTable("Cart")
        dtCart.Columns.Add("id", GetType(Integer))
        dtCart.Columns("id").AutoIncrement = True
        dtCart.Columns("id").AutoIncrementSeed = 1
        dtCart.Columns.Add("qty", GetType(Integer))
        dtCart.Columns.Add("item_id", GetType(Integer))
        dtCart.Columns.Add("item_desc", GetType(String))
        dtCart.Columns.Add("price", GetType(Decimal))
        dtCart.Columns.Add("sale_price", GetType(Decimal))
        dtCart.Columns.Add("discount_percentage", GetType(Integer))
        dtCart.Columns.Add("current_price", GetType(Decimal))
        dtCart.Columns.Add("tangible", GetType(Boolean))
        dtCart.Columns.Add("weight", GetType(Decimal))
        Session("Cart") = dtCart
    End Sub
    
    Sub CreateShipping()
        dtShipping = New DataTable("Shipping")
        dtShipping.Columns.Add("shipping_first_name", GetType(String))
        dtShipping.Columns.Add("shipping_last_name", GetType(String))
        dtShipping.Columns.Add("shipping_company", GetType(String))
        dtShipping.Columns.Add("shipping_address", GetType(String))
        dtShipping.Columns.Add("shipping_city", GetType(String))
        dtShipping.Columns.Add("shipping_state", GetType(String))
        dtShipping.Columns.Add("shipping_country", GetType(String))
        dtShipping.Columns.Add("shipping_zip", GetType(String))
        dtShipping.Columns.Add("shipping_phone", GetType(String))
        dtShipping.Columns.Add("shipping_fax", GetType(String))
        Session("shipping") = dtShipping
    End Sub
    
    Sub AddShipping()
        dtShipping = Session("Shipping")
        Dim drShipping As DataRow
        Dim bNew As Boolean = False
        If dtShipping.Rows.Count = 0 Then bNew = True
        If bNew Then
            drShipping = dtShipping.NewRow
        Else
            drShipping = dtShipping.Rows(0)
        End If

        Dim sShippingState As String
        If ddShippingState.Items.Count = 0 Then
            sShippingState = txtShippingState.Text
        Else
            sShippingState = ddShippingState.SelectedValue
        End If
        drShipping("shipping_first_name") = txtShippingFirstName.Text
        drShipping("shipping_last_name") = txtShippingLastName.Text
        drShipping("shipping_company") = txtShippingCompany.Text
        drShipping("shipping_address") = txtShippingAddress.Text
        drShipping("shipping_city") = txtShippingCity.Text
        drShipping("shipping_state") = sShippingState
        drShipping("shipping_country") = ddShippingCountry.Text
        drShipping("shipping_zip") = txtShippingZip.Text
        drShipping("shipping_phone") = txtShippingPhone.Text
        drShipping("shipping_fax") = txtShippingFax.Text
        
        If bNew Then
            dtShipping.Rows.Add(drShipping)
        End If
        Session("Shipping") = dtShipping
        
        'Insert/Update into shipping_info
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn.Open()
        Dim bShippingInfoExists As Boolean = False
        oCommand = New SqlCommand("SELECT * FROM shipping_info WHERE username=@username")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@username", SqlDbType.NVarChar, 256).Value = Me.UserName
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            bShippingInfoExists = True
        End If
        oDataReader.Close()
        oDataReader = Nothing
            
        Dim sSQL As String
        If bShippingInfoExists Then
            sSQL = "UPDATE shipping_info SET shipping_first_name=@shipping_first_name,shipping_last_name=@shipping_last_name,shipping_company=@shipping_company,shipping_address=@shipping_address,shipping_city=@shipping_city,shipping_state=@shipping_state,shipping_country=@shipping_country,shipping_zip=@shipping_zip,shipping_phone=@shipping_phone,shipping_fax=@shipping_fax WHERE username=@username"
        Else
            sSQL = "INSERT INTO shipping_info (username,shipping_first_name,shipping_last_name,shipping_company,shipping_address,shipping_city,shipping_state,shipping_country,shipping_zip,shipping_phone,shipping_fax) VALUES (@username,@shipping_first_name,@shipping_last_name,@shipping_company,@shipping_address,@shipping_city,@shipping_state,@shipping_country,@shipping_zip,@shipping_phone,@shipping_fax)"
        End If
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@username", SqlDbType.NVarChar, 256).Value = Me.UserName.ToString
        oCommand.Parameters.Add("@shipping_first_name", SqlDbType.NVarChar, 50).Value = txtShippingFirstName.Text
        oCommand.Parameters.Add("@shipping_last_name", SqlDbType.NVarChar, 50).Value = txtShippingLastName.Text
        oCommand.Parameters.Add("@shipping_company", SqlDbType.NVarChar, 50).Value = txtShippingCompany.Text
        oCommand.Parameters.Add("@shipping_address", SqlDbType.NVarChar, 50).Value = txtShippingAddress.Text
        oCommand.Parameters.Add("@shipping_city", SqlDbType.NVarChar, 50).Value = txtShippingCity.Text
        oCommand.Parameters.Add("@shipping_state", SqlDbType.NVarChar, 50).Value = sShippingState
        oCommand.Parameters.Add("@shipping_country", SqlDbType.NVarChar, 50).Value = ddShippingCountry.Text
        oCommand.Parameters.Add("@shipping_zip", SqlDbType.NVarChar, 50).Value = txtShippingZip.Text
        oCommand.Parameters.Add("@shipping_phone", SqlDbType.NVarChar, 50).Value = txtShippingPhone.Text
        oCommand.Parameters.Add("@shipping_fax", SqlDbType.NVarChar, 50).Value = txtShippingFax.Text
        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()
        oConn.Close()
    End Sub
    
    Sub AddToCart(ByVal nItemId As Integer)
        Dim oContentManager As New ContentManager
        Dim oDataReader As SqlDataReader
        oDataReader = oContentManager.GetPublishedContentById(nItemId)
        If oDataReader.Read() Then
            dtCart = Session("Cart")
            Dim bItemExists As Boolean = False
            Dim drCart As DataRow
            For Each drCart In dtCart.Rows
                If drCart("item_id") = nItemId Then
                    drCart("qty") += 1
                    bItemExists = True
                    Exit For
                End If
            Next
            If Not bItemExists Then
                drCart = dtCart.NewRow
                drCart("qty") = 1
                drCart("item_id") = nItemId
                drCart("item_desc") = oDataReader("title").ToString
                If Not IsDBNull(oDataReader("price")) Then
                    drCart("price") = oDataReader("price")
                Else
                    drCart("price") = 0
                End If
                If Not IsDBNull(oDataReader("sale_price")) Then
                    drCart("sale_price") = oDataReader("sale_price")
                Else
                    drCart("sale_price") = 0
                End If
                If Not IsDBNull(oDataReader("discount_percentage")) Then
                    drCart("discount_percentage") = oDataReader("discount_percentage")
                Else
                    drCart("discount_percentage") = 0
                End If
                If Not IsDBNull(oDataReader("tangible")) Then
                    drCart("tangible") = Convert.ToBoolean(oDataReader("tangible"))
                Else
                    drCart("tangible") = False
                End If
                If Not IsDBNull(oDataReader("weight")) Then
                    drCart("weight") = Convert.ToDecimal(oDataReader("weight"))
                Else
                    drCart("weight") = 0
                End If
                drCart("current_price") = GetPromoPrice(drCart("price"), drCart("sale_price"), drCart("discount_percentage"))
                dtCart.Rows.Add(drCart)
            End If
        End If
        oDataReader.Close()
        Session("Cart") = dtCart
    End Sub
    
    Function GetPromoPrice(ByVal price As Decimal, ByVal sale_price As Decimal, ByVal discount_percentage As Integer) As Decimal
        If sale_price > 0 Then
            Return sale_price
        ElseIf discount_percentage > 0 Then
            Return price - (price * (discount_percentage / 100))
        Else
            Return price
        End If
    End Function
    
    Function GetCouponPrice(ByVal item_id As Integer, ByVal price As Decimal, ByVal qty As Integer, ByVal code As String) As Decimal
        Dim vRetVal As Decimal
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "SELECT * FROM coupons WHERE code=@code"
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 10).Value = code
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            
            If qty < Convert.ToInt32(oDataReader("min_purchase")) Then
                oDataReader.Close()
                oConn.Close()
                oConn = Nothing
                Return price
            End If
            
            If Now > Convert.ToDateTime(oDataReader("expire_date")) Then
                oDataReader.Close()
                oConn.Close()
                oConn = Nothing
                Return price
            End If
            
            If Convert.ToBoolean(oDataReader("all_items")) Then
                If Convert.ToInt32(oDataReader("coupon_type")) = 1 Then
                    'free shipping (Later)
                    vRetVal = price
                ElseIf Convert.ToInt32(oDataReader("coupon_type")) = 2 Then
                    'percent off
                    vRetVal = price - (price * (Convert.ToDecimal(oDataReader("percent_off")) / 100))
                Else
                    'amount off
                    vRetVal = price - Convert.ToDecimal(oDataReader("amount_off"))
                End If
            ElseIf Convert.ToInt32(oDataReader("item_id")) = item_id Then
                If Convert.ToInt32(oDataReader("coupon_type")) = 1 Then
                    'free shipping (Later)
                    vRetVal = price
                ElseIf Convert.ToInt32(oDataReader("coupon_type")) = 2 Then
                    'percent off
                    vRetVal = price - (price * (Convert.ToDecimal(oDataReader("percent_off")) / 100))
                Else
                    'amount off
                    vRetVal = price - Convert.ToDecimal(oDataReader("amount_off"))
                End If
            Else
                vRetVal = price
            End If
        Else
            vRetVal = price
        End If

        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
        Return vRetVal
    End Function
    
    Function GetSubTotal() As Decimal
        If IsNothing(Session("Cart")) Then
            Return 0
        End If
        Dim drCart As DataRow
        Dim nTotal As Decimal = 0
        dtCart = Session("Cart")
        For Each drCart In dtCart.Rows
            nTotal += drCart("qty") * drCart("current_price")
        Next
        Return nTotal
    End Function
    
    Function GetTotalTangible() As Decimal
        If IsNothing(Session("Cart")) Then
            Return 0
        End If
        Dim drCart As DataRow
        Dim nTotal As Decimal = 0
        dtCart = Session("Cart")
        For Each drCart In dtCart.Rows
            If drCart("tangible") Then
                nTotal += drCart("qty") * drCart("current_price")
            End If
        Next
        Return nTotal
    End Function
    
    Function GetWeightTangible() As Decimal
        If IsNothing(Session("Cart")) Then
            Return 0
        End If
        Dim drCart As DataRow
        Dim nTotal As Decimal = 0
        dtCart = Session("Cart")
        For Each drCart In dtCart.Rows
            If drCart("tangible") Then
                If Not IsDBNull(drCart("weight")) Then 'backward
                    nTotal += Convert.ToDecimal(drCart("weight"))
                End If
            End If
        Next
        Return nTotal
    End Function
    
    Function GetShipping() As Decimal
        If Not bUseShipping Then
            Return 0
        End If
        Dim drShipping As DataRow
        dtShipping = Session("Shipping")
        If Not dtShipping.Rows.Count = 0 Then
            drShipping = dtShipping.Rows(0)
            Return CalculateShipping(GetWeightTangible(), GetTotalTangible(), drShipping("shipping_country"), drShipping("shipping_state"))
        Else
            Return 0 'sehrsnya tdk terjadi, utk amannya saja.
        End If
    End Function
   
    Private Function CalculateShipping(ByVal weight As Decimal, ByVal total As Decimal, ByVal country As String, ByVal state As String) As Decimal
        
        oConn.Open()

        Dim cost As Decimal = 0 '-1

        Dim baseSQL As String = "SELECT ship_cost, percentage_cost from shipping_cost WHERE weight_from<=@weight and weight_to>=@weight and total_from<=@total and total_to>=@total "
        Dim sSql As String = ""
        sSql = sSql & baseSQL & " AND location=@country_state "
        sSql = sSql & " UNION ALL " & baseSQL & " AND location=@country "
        sSql = sSql & " UNION ALL " & baseSQL & " AND location=@all "

        Dim oCommand As New SqlCommand(sSql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@weight", SqlDbType.Decimal).Value = weight
        oCommand.Parameters.Add("@total", SqlDbType.Decimal).Value = total
        oCommand.Parameters.Add("@all", SqlDbType.NVarChar, 128).Value = "*"
        oCommand.Parameters.Add("@country_state", SqlDbType.NVarChar, 128).Value = country & IIf(state = "", "", " " & state)
        oCommand.Parameters.Add("@country", SqlDbType.NVarChar, 128).Value = country

        oCommand.Connection = oConn
        Dim oDataReader As SqlDataReader = oCommand.ExecuteReader()

        If oDataReader.Read Then
            If Not IsDBNull(oDataReader("percentage_cost")) Then
                cost = total * Convert.ToDecimal(oDataReader("percentage_cost")) / 100
            ElseIf Not IsDBNull(oDataReader("ship_cost")) Then
                cost = oDataReader("ship_cost")
            End If
        End If

        oConn.Close()

        Return cost
    End Function
    
    Function GetTax() As Decimal
        If Not bUseShipping Then
            Return 0
        End If
        Dim drShipping As DataRow
        dtShipping = Session("Shipping")
        If Not dtShipping.Rows.Count = 0 Then
            drShipping = dtShipping.Rows(0)
            Return CalculateTax(GetTotalTangible(), GetShipping(), drShipping("shipping_country"), drShipping("shipping_state"))
        Else
            Return 0 'sehrsnya tdk terjadi, utk amannya saja.
        End If
    End Function
    
    Private Function CalculateTax(ByVal total_tangible As Decimal, ByVal shipping_cost As Decimal, ByVal country As String, ByVal state As String) As Decimal

        oConn.Open()

        Dim sSQL As String = "Select * from taxes where country=@country and state=@state "
        sSQL = sSQL & "UNION ALL Select * from taxes where country=@country and (state is null or state='') "
        Dim oCommand As New SqlCommand(sSQL)
        oCommand.Parameters.Add("@country", SqlDbType.VarChar, 3).Value = country
        oCommand.Parameters.Add("@state", SqlDbType.NVarChar, 255).Value = state
        oCommand.Connection = oConn
        Dim taxRate As SqlDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim rate As Decimal = 0
        Dim bItemsOnly As Boolean
        If taxRate.Read Then
            bItemsOnly = Convert.ToBoolean(taxRate("items_only"))
            If IsDBNull(taxRate("tax_rate")) Then
                rate = 0
            Else
                rate = Convert.ToDecimal(taxRate("tax_rate"))
            End If
            taxRate.Close()
        End If
        
        oConn.Close()
        
        If bItemsOnly Then
            Return (total_tangible) * rate / 100
        Else
            Return (total_tangible + shipping_cost) * rate / 100
        End If       
    End Function
    
    Function GetPaypalPaymentUrl(ByVal nOrderId As Integer) As String

        Dim sAmount As String = GetSubTotal().ToString("N2") '.Replace(",", ".")
        If (sAmount.Substring(sAmount.Length - 3, 1) = ",") Then '1.000,00 => 1,000.00
            sAmount = sAmount.Replace(",", "#")
            sAmount = sAmount.Replace(".", ",")
            sAmount = sAmount.Replace("#", ".")
        End If

        Dim sShipping As String = GetShipping().ToString("N2").Replace(",", ".")
        Dim sTax As String = GetTax().ToString("N2").Replace(",", ".")
        
        Dim sBaseUrl As String = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "") & Request.ApplicationPath
        If Not sBaseUrl.EndsWith("/") Then sBaseUrl += "/"
        
        Dim sNotifyUrl As String = HttpUtility.UrlEncode(sBaseUrl & sPaypalNotifyPage)
        Dim sReturnUrl As String = HttpUtility.UrlEncode(sBaseUrl & sPaypalReturnPage & "?item_number=" & nOrderId.ToString)
        Dim sCancelUrl As String = HttpUtility.UrlEncode(sBaseUrl & sPaypalCancelPage)
        Dim sBusiness As String = HttpUtility.UrlEncode(sPaypalEmail)
        Dim sDescription As String = HttpUtility.UrlEncode(sOrderDescription)
               
        Dim sPaymentUrl As String
        sPaymentUrl = sPaypalURL & "?cmd=_xclick"
        sPaymentUrl += "&upload=1"
        sPaymentUrl += "&rm=2" 'POST
        sPaymentUrl += "&no_shipping=1" '1=not ask shipping address, 2=must enter
        sPaymentUrl += "&no_note=1" 'not prompted to include a note
        sPaymentUrl += "&currency_code=" & sCurrencyCode
        sPaymentUrl += "&business=" & sBusiness
        sPaymentUrl += "&item_number=" & nOrderId.ToString 'ditampilkan di bwh item_name
        sPaymentUrl += "&custom=" & nOrderId.ToString 'sembarang (tdk ditampilkan)
        sPaymentUrl += "&item_name=" & sDescription
        sPaymentUrl += "&amount=" & sAmount
        sPaymentUrl += "&shipping=" & sShipping
        sPaymentUrl += "&tax=" & sTax
        sPaymentUrl += "&notify_url=" & sNotifyUrl
        sPaymentUrl += "&return=" & sReturnUrl
        sPaymentUrl += "&cancel_return=" & sCancelUrl

        Return sPaymentUrl
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

    
    '*** OTHERS (UI) ***            
    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        dtCart = Session("Cart")
        dtCart.Rows(e.RowIndex).Delete()
        Session("Cart") = dtCart
        GridView1.DataSource = dtCart
        GridView1.DataBind()
        lblSubTotal.Text = sCurrencySymbol & FormatNumber(GetSubTotal(), 2)
        
        If GridView1.Rows.Count = 0 Then
            'cart empty
            Wizard1.Visible = False
            panelEmpty.Visible = True
        End If
    End Sub
    
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        UpdateCart()
        dtCart = Session("Cart")
        GridView1.DataSource = dtCart
        GridView1.DataBind()
        lblSubTotal.Text = sCurrencySymbol & FormatNumber(GetSubTotal(), 2)
    End Sub
    
    Protected Sub UpdateCart()
        Dim drCart As DataRow
        dtCart = Session("Cart")
        
        Dim oRow As GridViewRow
        Dim id As Integer
        Dim qty As Integer
        For Each oRow In GridView1.Rows
            id = Convert.ToInt32(GridView1.DataKeys(oRow.RowIndex)(0))
            qty = Convert.ToInt32(CType(oRow.FindControl("txtQty"), TextBox).Text)

            For Each drCart In dtCart.Rows
                If drCart("id") = id Then
                    drCart("qty") = qty
                    
                    If Not txtCouponCode.Text = "" Then
                        Dim nCouponPrice As Decimal = GetCouponPrice(drCart("item_id"), drCart("price"), drCart("qty"), txtCouponCode.Text)
                        If drCart("price") <> nCouponPrice Then
                            'Coupon Price will replace Promo Price
                            drCart("current_price") = nCouponPrice
                        Else
                            'back to promo price (if any)
                            drCart("current_price") = GetPromoPrice(drCart("price"), drCart("sale_price"), drCart("discount_percentage"))
                        End If
                    End If
                    
                    Exit For
                End If
            Next
        Next
        Session("Cart") = dtCart
    End Sub
    
    Function ShowPrice(ByVal price As Decimal, ByVal current_price As Decimal) As String
        If price = current_price Then
            Return sCurrencySymbol & FormatNumber(price, 2)
        Else
            Return "<strike>" & sCurrencySymbol & FormatNumber(price, 2) & "</strike>&nbsp;" & _
                sCurrencySymbol & FormatNumber(current_price, 2)
        End If
    End Function
    
    Protected Sub ddShippingCountry_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddShippingCountry.SelectedIndexChanged
        'load state
        ddShippingState.Items.Clear()

        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from country_state_lookup where country=@country order by state_code "
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@country", SqlDbType.VarChar, 3).Value = ddShippingCountry.SelectedValue
        oCommand.Connection = oConn
        Dim oDataReader As SqlDataReader = oCommand.ExecuteReader()

        While oDataReader.Read
            ddShippingState.Items.Add(New ListItem(oDataReader("state").ToString, oDataReader("state_code").ToString))
        End While
        
        If (ddShippingState.Items.Count > 0) Then
            'ddShippingState.Items.Add(New ListItem("Others", "OTH"))
            ddShippingState.Style.Add("display", "")
            txtShippingState.Style.Add("display", "none")
        Else
            'ddShippingState.Items.Add(New ListItem("Others", "OTH"))
            ddShippingState.Style.Add("display", "none")
            txtShippingState.Style.Add("display", "")
        End If
        
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
    End Sub
    
    
    '*** DATABASE ***
    Protected Function SaveOrder(ByVal sPaymentMethod As String) As Integer
        Dim nOrderId As Integer

        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "INSERT INTO orders (order_date,order_by,sub_total,total,status,shipping,tax,payment_method,root_id) " & _
            "VALUES (@order_date,@order_by,@sub_total,@total,@status,@shipping,@tax,@payment_method,@root_id);SELECT SCOPE_IDENTITY();"
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@order_date", SqlDbType.DateTime).Value = Now
        oCommand.Parameters.Add("@order_by", SqlDbType.NVarChar, 50).Value = Me.UserName
        oCommand.Parameters.Add("@sub_total", SqlDbType.Money).Value = GetSubTotal()
        oCommand.Parameters.Add("@total", SqlDbType.Money).Value = GetSubTotal() + GetShipping() + GetTax()
        oCommand.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = "WAITING_FOR_PAYMENT"
        oCommand.Parameters.Add("@shipping", SqlDbType.Money).Value = GetShipping()
        oCommand.Parameters.Add("@tax", SqlDbType.Money).Value = GetTax()
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oCommand.Parameters.Add("@payment_method", SqlDbType.NVarChar, 50).Value = sPaymentMethod
        oCommand.Connection = oConn
        nOrderId = oCommand.ExecuteScalar()
        
        sSQL = "INSERT INTO order_items (order_id,item_id,item_desc,price,qty,tangible) " & _
            "VALUES (@order_id,@item_id,@item_desc,@price,@qty,@tangible)"
        Dim drCart As DataRow
        dtCart = Session("Cart")
        
        For Each drCart In dtCart.Rows
            oCommand = New SqlCommand(sSQL)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
            oCommand.Parameters.Add("@item_id", SqlDbType.Int).Value = drCart("item_id")
            oCommand.Parameters.Add("@item_desc", SqlDbType.NVarChar, 255).Value = drCart("item_desc")
            oCommand.Parameters.Add("@price", SqlDbType.Money).Value = drCart("current_price")
            oCommand.Parameters.Add("@qty", SqlDbType.Int).Value = drCart("qty")
            oCommand.Parameters.Add("@tangible", SqlDbType.Bit).Value = drCart("tangible")
            oCommand.Connection = oConn
            oCommand.ExecuteNonQuery()
        Next
       
        oCommand.Dispose()
        oConn.Close()
        oConn = Nothing
        
        Return nOrderId
    End Function
            
    Protected Sub SaveShipping(ByVal nOrderId As Integer)
        
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "UPDATE orders set shipping_first_name=@shipping_first_name, shipping_last_name=@shipping_last_name, " & _
            "shipping_company=@shipping_company, shipping_address=@shipping_address, shipping_city=@shipping_city, " & _
            "shipping_state=@shipping_state, shipping_country=@shipping_country, " & _
            "shipping_zip=@shipping_zip, shipping_phone=@shipping_phone, shipping_fax=@shipping_fax " & _
            "WHERE order_id=@order_id"
        oCommand = New SqlCommand(sSQL)
        oCommand.CommandType = CommandType.Text
        
        Dim drShipping As DataRow
        dtShipping = Session("Shipping")
        drShipping = dtShipping.Rows(0)
        
        oCommand.Parameters.Add("@shipping_first_name", SqlDbType.NVarChar, 50).Value = drShipping("shipping_first_name")
        oCommand.Parameters.Add("@shipping_last_name", SqlDbType.NVarChar, 50).Value = drShipping("shipping_last_name")
        oCommand.Parameters.Add("@shipping_company", SqlDbType.NVarChar, 50).Value = drShipping("shipping_company")
        oCommand.Parameters.Add("@shipping_address", SqlDbType.NVarChar, 255).Value = drShipping("shipping_address")
        oCommand.Parameters.Add("@shipping_city", SqlDbType.NVarChar, 50).Value = drShipping("shipping_city")
        oCommand.Parameters.Add("@shipping_state", SqlDbType.NVarChar, 50).Value = drShipping("shipping_state")
        oCommand.Parameters.Add("@shipping_country", SqlDbType.NVarChar, 50).Value = drShipping("shipping_country")
        oCommand.Parameters.Add("@shipping_zip", SqlDbType.NVarChar, 50).Value = drShipping("shipping_zip")
        oCommand.Parameters.Add("@shipping_phone", SqlDbType.NVarChar, 50).Value = drShipping("shipping_phone")
        oCommand.Parameters.Add("@shipping_fax", SqlDbType.NVarChar, 50).Value = drShipping("shipping_fax")
        oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()
        oConn = Nothing
    End Sub
    
    
    '*** PAY HERE ***
    Protected Sub btnPayHere_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim nOrderId As Integer
        nOrderId = SaveOrder("PAYPAL")
        If bUseShipping Then
            SaveShipping(nOrderId)
        End If
        
        Response.Redirect(GetPaypalPaymentUrl(nOrderId))
    End Sub
    
    
    '*** Cash On Delivery ***
    Protected Sub btnCashOnDelivery_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim nOrderId As Integer
        nOrderId = SaveOrder("CASH_ON_DELIVERY")
        If bUseShipping Then
            SaveShipping(nOrderId)
        End If
        
        SendCashOnDeliveryConfirmation(nOrderId)

        Session("cart") = Nothing 'Empty shopping cart
        Wizard1.ActiveStepIndex = 4
    End Sub
    
    Protected Sub SendCashOnDeliveryConfirmation(ByVal nOrderId As Integer)
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        
        Dim nShipping As Decimal
        Dim nTax As Decimal
        Dim dtOrderDate As DateTime
        Dim sOrderBy As String = ""
        Dim sWebsiteUrl As String = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, "")
                
        '*** order ***
        oCommand = New SqlCommand("SELECT * FROM orders WHERE order_id=@order_id")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
        oConn.Open()
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader
        Dim sShipping As String = ""
        If oDataReader.Read Then
            dtOrderDate = oDataReader("order_date")
            sOrderBy = oDataReader("order_by").ToString
            nShipping = oDataReader("shipping")
            nTax = oDataReader("tax")
            dtOrderDate = Convert.ToDateTime(oDataReader("order_date")) '6/2/2007 9:58:01 AM
            
            nShipping = oDataReader("shipping")
            nTax = oDataReader("tax")
            
            If Not IsDBNull(oDataReader("shipping_first_name")) Then
                bUseShipping = True
                sShipping = "<div>" & oDataReader("shipping_first_name").ToString & " " & oDataReader("shipping_last_name").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_company").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_address").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_city").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_state").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_country").ToString & "</div>" & _
                    "<div>" & oDataReader("shipping_zip").ToString & "</div>" & _
                    "<div>Ph." & oDataReader("shipping_phone").ToString & "</div>"
                If Not oDataReader("shipping_fax").ToString = "" Then
                    sShipping += "<div>Mobile." & oDataReader("shipping_fax").ToString & "</div>"
                End If
            Else
                bUseShipping = False
            End If
        End If
        oDataReader.Close()
        oCommand.Dispose()
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
        
        '*** Send Email to Admin ***   
        Dim user As MembershipUser = Membership.GetUser(sOrderBy)
        Dim sUserEmail As String = user.Email
        Dim sEmailTemplate As String = "<html><head><title>Incoming Order</title>" & _
            "<style>td{font-family:Verdana;font-size:11px}</style></head>" & _
            "<body style=""font-family:Verdana;font-size:11px"">" & _
            "<p>Incoming Order by " & sOrderBy & " (" & sUserEmail & ")</p>" & _
            "<p>Order ID: [%ORDER_ID%]</p>" & _
            "<p>Order Items:</p>" & _
            "<p>[%ORDER_DETAIL%]</p>" & _
            "<p>Ship to:</p>" & _
            "<p>[%SHIP_TO%]</p>" & _
            "<p>Sincerely,<br>Support<br><a href=""[%WEBSITE_URL%]"">[%WEBSITE_URL%]</a></p></body></html>"
        Dim sBody As String = sEmailTemplate
        sBody = sBody.Replace("[%ORDER_ID%]", nOrderId.ToString)
        sBody = sBody.Replace("[%ORDER_DATE%]", dtOrderDate.AddHours(Me.TimeOffset).ToString)
        sBody = sBody.Replace("[%ORDER_DETAIL%]", sOrderDetail)
        sBody = sBody.Replace("[%SHIP_TO%]", sShipping)
        sBody = sBody.Replace("[%WEBSITE_URL%]", sWebsiteUrl)
        Dim mailToShopAdmin As String() = New String() {sPaypalEmail} 'Use Paypal Email Account
        If Not SendMail(mailToShopAdmin, "Incoming Order #" & nOrderId & " (Cash On Delivery)", sBody, True) Then
            'Mailing Failed...
            'Exit Sub
        End If
        
        '*** Send "Order Confirmation" to Customer (bukan "Thank You For Your Order" email) ***         
        sBody = sCODOrderConfirmTemplate
        sBody = sBody.Replace("[%ORDER_ID%]", nOrderId.ToString)
        sBody = sBody.Replace("[%ORDER_DATE%]", dtOrderDate.AddHours(Me.TimeOffset).ToString)
        sBody = sBody.Replace("[%ORDER_DETAIL%]", sOrderDetail)
        sBody = sBody.Replace("[%SHIP_TO%]", sShipping)
        sBody = sBody.Replace("[%WEBSITE_URL%]", sWebsiteUrl)
        Dim mailToCustomer As String() = New String() {sUserEmail}
        If Not SendMail(mailToCustomer, "Your Order #" & nOrderId & " (Cash On Delivery)", sBody, True) Then
            'Mailing Failed...
            'Exit Sub
        End If
        
        oCommand.Dispose()
        oConn = Nothing
    End Sub

    Protected Sub Login1_Authenticate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.AuthenticateEventArgs)
        If Login1.UserName.Contains("@") Then
            Dim sUserName As String
            sUserName = Membership.GetUserNameByEmail(Login1.UserName)
            If Not IsNothing(sUserName) Then
                If Membership.ValidateUser(sUserName, Login1.Password) Then
                    Login1.UserName = sUserName
                    e.Authenticated = True
                Else
                    e.Authenticated = False
                End If
            Else
                e.Authenticated = False
            End If
        Else
            If Membership.ValidateUser(Login1.UserName, Login1.Password) Then
                e.Authenticated = True
            Else
                e.Authenticated = False
            End If
        End If
    End Sub
</script>

<asp:Wizard ID="Wizard1" StartNextButtonText="PROCEED TO CHECKOUT" meta:resourcekey="Wizard1" Width="100%" DisplaySideBar="false" runat="server" OnNextButtonClick="Wizard1_NextButtonClick">
    <WizardSteps>
        <asp:WizardStep ID="WizardStep1" runat="server" Title="Step 1">
            <p><asp:HyperLink ID="lnkContinue" meta:resourcekey="lnkContinue" runat="server"></asp:HyperLink></p>
            
            <asp:GridView ID="GridView1" Width="100%" CellPadding="10" runat="server" AutoGenerateColumns="false"
            DataKeyNames="id" OnRowDeleting="GridView1_RowDeleting">
            <Columns>
            <asp:BoundField DataField="item_desc" HeaderText="Item" meta:resourcekey="colItem" ItemStyle-Width="100%" />
            <asp:TemplateField HeaderText="Price" meta:resourcekey="colPrice" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                <ItemTemplate><%#ShowPrice(Eval("price"), Eval("current_price"))%></ItemTemplate>
            </asp:TemplateField>            
            <asp:TemplateField HeaderText="Quantity" meta:resourcekey="colQuantity" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:TextBox ID="txtQty" Text='<%#Bind("qty")%>' Width="30" runat="server"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField DeleteText="Remove" meta:resourcekey="colRemove" ButtonType="Link" ShowDeleteButton="true" />

            </Columns>
            </asp:GridView> 
            
            <table cellpadding="7" width="100%">
            <tr>
            <td style="width:100%;text-align:right">
            <asp:Label ID="lblSubtotalLabel" meta:resourcekey="lblSubtotalLabel" runat="server" Font-Bold="true" Text="Subtotal"></asp:Label>
            </td>
            <td>:&nbsp;</td>
            <td style="text-align:right">            
            <asp:Label ID="lblSubTotal" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            </tr>
            </table>
            <div style="text-align:right;padding:10px;padding-bottom:0px">
                <asp:Literal ID="litIfYouHaveCoupon" meta:resourcekey="litIfYouHaveCoupon" runat="server"></asp:Literal>
                <asp:TextBox ID="txtCouponCode" runat="server"></asp:TextBox>
            </div>
            <div style="text-align:right;padding:10px">
                <asp:Button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" Update " OnClick="btnUpdate_Click" />
            </div>
        </asp:WizardStep>  
              
        <asp:WizardStep ID="WizardStep2" runat="server" Title="Step 2">
            <asp:Panel ID="panelLogin" DefaultButton="Login1$LoginButton" runat="server">   
            <p>
                <asp:Literal ID="litYouMustLogin" meta:resourcekey="litYouMustLogin" runat="server"></asp:Literal>
            </p>
            <p>
                <asp:Label ID="lblLoginHere" meta:resourcekey="lblLoginHere" Font-Bold="true" runat="server" Text="Label"></asp:Label>
            </p>         
            <asp:Login ID="Login1" meta:resourcekey="Login1" Orientation="Horizontal" TitleText="" PasswordRecoveryText="Password Recovery"
             DisplayRememberMe="false" LoginButtonText=" Login " runat="server" OnLoggedIn="Login1_LoggedIn" OnAuthenticate="Login1_Authenticate">
            </asp:Login>
            </asp:Panel>
            
            <asp:Panel ID="panelCreateUser" runat="server">            
            <p>
            <asp:CreateUserWizard ID="CreateUserWizard1" meta:resourcekey="CreateUserWizard1" LabelStyle-HorizontalAlign="Left" CreateUserButtonText=" Create Account " CompleteSuccessTextStyle-Font-Bold="true" CompleteSuccessText="&nbsp;" ContinueButtonText="Continue to the next step" HeaderText="If you have never registered, please fill the form below:" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Font-Bold="true" runat="server" OnNextButtonClick="CreateUserWizard1_NextButtonClick">
                <WizardSteps>
                    <asp:CreateUserWizardStep ID="CreateUserWizardStep1" Title="&nbsp;" runat="server">
                    </asp:CreateUserWizardStep>
                    <asp:CompleteWizardStep ID="CompleteWizardStep1" Title="" runat="server">
                    <ContentTemplate>
                    <asp:Literal ID="litRegistThankYou" meta:resourcekey="litRegistThankYou" runat="server"></asp:Literal>
                    <div>&nbsp;</div>
                    <asp:Button ID="btnContinue" meta:resourcekey="btnContinue" runat="server" OnClick="btnContinue_Click" Text="Continue to the next page" />
                    </ContentTemplate>
                    </asp:CompleteWizardStep>
                </WizardSteps>
            </asp:CreateUserWizard>
            </p>
            </asp:Panel>
            
            <asp:Panel ID="panelRegister" runat="server" Visible="False">
            <p>
                <asp:Label ID="lblIfYouNeverRegist" meta:resourcekey="lblIfYouNeverRegist" runat="server" Font-Bold="true" Text="If you have never registered:"></asp:Label>
            </p>
            <p><asp:HyperLink runat="server" ID="linkRegister" meta:resourcekey="linkRegister" Font-Bold="true" Text="Register Now!"></asp:HyperLink></p>
            <p>
                <asp:Label ID="lblRegistIsFast" meta:resourcekey="lblRegistIsFast" runat="server" Text="Registration is fast and free."></asp:Label>
            </p>
            </asp:Panel>
        </asp:WizardStep>
        
        <asp:WizardStep ID="WizardStep3" runat="server" AllowReturn="false" StepType="Finish" Title="Step 4">

            <table cellpadding="3">
            <tr>
                <td colspan="2" style="font-weight:bold;background:#d6d7d8;padding:10px;padding-left:5px">
                    <asp:Label ID="lblShippingInfo" meta:resourcekey="lblShippingInfo" runat="server" Text="Shipping Information"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-top:10px">
                    <asp:Label ID="lblFirstName" Visible=false meta:resourcekey="lblFirstName" runat="server" Text="First Name" Font-Size="XX-Small"></asp:Label>
                    <asp:Label ID="lblFullName" meta:resourcekey="lblFullName" runat="server" Text="Full Name" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingFirstName" Width="330px" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv1" ControlToValidate="txtShippingFirstName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr style="display:none">
                <td colspan="2">
                    <asp:Label ID="lblLastName" meta:resourcekey="lblLastName" runat="server" Text="Last Name" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingLastName" Width="180px" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblCompany" meta:resourcekey="lblCompany" runat="server" Text="Company (optional)" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingCompany" Width="330px" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblAddress" meta:resourcekey="lblAddress" runat="server" Text="Address" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingAddress" Width="330px" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv3" ControlToValidate="txtShippingAddress" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblCountry" meta:resourcekey="lblCountry" runat="server" Text="Country" Font-Size="XX-Small"></asp:Label><br />
                        <asp:DropDownList id="ddShippingCountry" Width="185px" runat="server" AutoPostBack="true">
                                <asp:ListItem value=""></asp:ListItem>
                                <asp:ListItem value="AF">Afghanistan</asp:ListItem>
                                <asp:ListItem value="AL">Albania</asp:ListItem>
                                <asp:ListItem value="DZ">Algeria</asp:ListItem>
                                <asp:ListItem value="AS">American Samoa</asp:ListItem>
                                <asp:ListItem value="AD">Andorra</asp:ListItem>
                                <asp:ListItem value="AO">Angola</asp:ListItem>
                                <asp:ListItem value="AI">Anguilla</asp:ListItem>
                                <asp:ListItem value="AQ">Antarctica</asp:ListItem>
                                <asp:ListItem value="AG">Antigua and Barbuda</asp:ListItem>
                                <asp:ListItem value="AR">Argentina</asp:ListItem>
                                <asp:ListItem value="AM">Armenia</asp:ListItem>
                                <asp:ListItem value="AW">Aruba</asp:ListItem>
                                <asp:ListItem value="AC">Ascension Island</asp:ListItem>
                                <asp:ListItem value="AU">Australia</asp:ListItem>
                                <asp:ListItem value="AT">Austria</asp:ListItem>
                                <asp:ListItem value="AZ">Azerbaijan</asp:ListItem>
                                <asp:ListItem value="BS">Bahamas</asp:ListItem>
                                <asp:ListItem value="BH">Bahrain</asp:ListItem>
                                <asp:ListItem value="BD">Bangladesh</asp:ListItem>
                                <asp:ListItem value="BB">Barbados</asp:ListItem>
                                <asp:ListItem value="BY">Belarus</asp:ListItem>
                                <asp:ListItem value="BE">Belgium</asp:ListItem>
                                <asp:ListItem value="BZ">Belize</asp:ListItem>
                                <asp:ListItem value="BJ">Benin</asp:ListItem>
                                <asp:ListItem value="BM">Bermuda</asp:ListItem>
                                <asp:ListItem value="BT">Bhutan</asp:ListItem>
                                <asp:ListItem value="BO">Bolivia</asp:ListItem>
                                <asp:ListItem value="BA">Bosnia and Herzegovina</asp:ListItem>
                                <asp:ListItem value="BW">Botswana</asp:ListItem>
                                <asp:ListItem value="BV">Bouvet Island</asp:ListItem>
                                <asp:ListItem value="BR">Brazil</asp:ListItem>
                                <asp:ListItem value="IO">British Indian</asp:ListItem>
                                <asp:ListItem value="BN">Brunei</asp:ListItem>
                                <asp:ListItem value="BG">Bulgaria</asp:ListItem>
                                <asp:ListItem value="BF">Burkina Faso</asp:ListItem>
                                <asp:ListItem value="BI">Burundi</asp:ListItem>
                                <asp:ListItem value="KH">Cambodia</asp:ListItem>
                                <asp:ListItem value="CM">Cameroon</asp:ListItem>
                                <asp:ListItem value="CA">Canada</asp:ListItem>
                                <asp:ListItem value="CV">Cape Verde</asp:ListItem>
                                <asp:ListItem value="KY">Cayman Islands</asp:ListItem>
                                <asp:ListItem value="CF">Central African Republic</asp:ListItem>
                                <asp:ListItem value="TD">Chad</asp:ListItem>
                                <asp:ListItem value="CL">Chile</asp:ListItem>
                                <asp:ListItem value="CN">China</asp:ListItem>
                                <asp:ListItem value="CX">Christmas Island</asp:ListItem>
                                <asp:ListItem value="CC">Cocos (Keeling) Islands</asp:ListItem>
                                <asp:ListItem value="CO">Colombia</asp:ListItem>
                                <asp:ListItem value="KM">Comoros</asp:ListItem>
                                <asp:ListItem value="CD">Congo (DRC)</asp:ListItem>
                                <asp:ListItem value="CG">Congo</asp:ListItem>
                                <asp:ListItem value="CK">Cook Islands</asp:ListItem>
                                <asp:ListItem value="CR">Costa Rica</asp:ListItem>
                                <asp:ListItem value="CI">Côte d'Ivoire</asp:ListItem>
                                <asp:ListItem value="HR">Croatia</asp:ListItem>
                                <asp:ListItem value="CU">Cuba</asp:ListItem>
                                <asp:ListItem value="CY">Cyprus</asp:ListItem>
                                <asp:ListItem value="CZ">Czech Republic</asp:ListItem>
                                <asp:ListItem value="DK">Denmark</asp:ListItem>
                                <asp:ListItem value="DJ">Djibouti</asp:ListItem>
                                <asp:ListItem value="DM">Dominica</asp:ListItem>
                                <asp:ListItem value="DO">Dominican Republic</asp:ListItem>
                                <asp:ListItem value="EC">Ecuador</asp:ListItem>
                                <asp:ListItem value="EG">Egypt</asp:ListItem>
                                <asp:ListItem value="SV">El Salvador</asp:ListItem>
                                <asp:ListItem value="GQ">Equatorial Guinea</asp:ListItem>
                                <asp:ListItem value="ER">Eritrea</asp:ListItem>
                                <asp:ListItem value="EE">Estonia</asp:ListItem>
                                <asp:ListItem value="ET">Ethiopia</asp:ListItem>
                                <asp:ListItem value="FK">Falkland Islands</asp:ListItem>
                                <asp:ListItem value="FO">Faroe Islands</asp:ListItem>
                                <asp:ListItem value="FJ">Fiji Islands</asp:ListItem>
                                <asp:ListItem value="FI">Finland</asp:ListItem>
                                <asp:ListItem value="FR">France</asp:ListItem>
                                <asp:ListItem value="GF">French Guiana</asp:ListItem>
                                <asp:ListItem value="PF">French Polynesia</asp:ListItem>
                                <asp:ListItem value="TF">French Southern</asp:ListItem>
                                <asp:ListItem value="GA">Gabon</asp:ListItem>
                                <asp:ListItem value="GM">Gambia, The</asp:ListItem>
                                <asp:ListItem value="GE">Georgia</asp:ListItem>
                                <asp:ListItem value="DE">Germany</asp:ListItem>
                                <asp:ListItem value="GH">Ghana</asp:ListItem>
                                <asp:ListItem value="GI">Gibraltar</asp:ListItem>
                                <asp:ListItem value="GR">Greece</asp:ListItem>
                                <asp:ListItem value="GL">Greenland</asp:ListItem>
                                <asp:ListItem value="GD">Grenada</asp:ListItem>
                                <asp:ListItem value="GP">Guadeloupe</asp:ListItem>
                                <asp:ListItem value="GU">Guam</asp:ListItem>
                                <asp:ListItem value="GT">Guatemala</asp:ListItem>
                                <asp:ListItem value="GG">Guernsey</asp:ListItem>
                                <asp:ListItem value="GN">Guinea</asp:ListItem>
                                <asp:ListItem value="GW">Guinea-Bissau</asp:ListItem>
                                <asp:ListItem value="GY">Guyana</asp:ListItem>
                                <asp:ListItem value="HT">Haiti</asp:ListItem>
                                <asp:ListItem value="HM">Heard Island</asp:ListItem>
                                <asp:ListItem value="HN">Honduras</asp:ListItem>
                                <asp:ListItem value="HK">Hong Kong SAR</asp:ListItem>
                                <asp:ListItem value="HU">Hungary</asp:ListItem>
                                <asp:ListItem value="IS">Iceland</asp:ListItem>
                                <asp:ListItem value="IN">India</asp:ListItem>
                                <asp:ListItem value="ID">Indonesia</asp:ListItem>
                                <asp:ListItem value="IR">Iran</asp:ListItem>
                                <asp:ListItem value="IQ">Iraq</asp:ListItem>
                                <asp:ListItem value="IE">Ireland</asp:ListItem>
                                <asp:ListItem value="IM">Isle of Man</asp:ListItem>
                                <asp:ListItem value="IL">Israel</asp:ListItem>
                                <asp:ListItem value="IT">Italy</asp:ListItem>
                                <asp:ListItem value="JM">Jamaica</asp:ListItem>
                                <asp:ListItem value="JP">Japan</asp:ListItem>
                                <asp:ListItem value="JO">Jordan</asp:ListItem>
                                <asp:ListItem value="JE">Jersey</asp:ListItem>
                                <asp:ListItem value="KZ">Kazakhstan</asp:ListItem>
                                <asp:ListItem value="KE">Kenya</asp:ListItem>
                                <asp:ListItem value="KI">Kiribati</asp:ListItem>
                                <asp:ListItem value="KR">Korea</asp:ListItem>
                                <asp:ListItem value="KW">Kuwait</asp:ListItem>
                                <asp:ListItem value="KG">Kyrgyzstan</asp:ListItem>
                                <asp:ListItem value="LA">Laos</asp:ListItem>
                                <asp:ListItem value="LV">Latvia</asp:ListItem>
                                <asp:ListItem value="LB">Lebanon</asp:ListItem>
                                <asp:ListItem value="LS">Lesotho</asp:ListItem>
                                <asp:ListItem value="LR">Liberia</asp:ListItem>
                                <asp:ListItem value="LY">Libya</asp:ListItem>
                                <asp:ListItem value="LI">Liechtenstein</asp:ListItem>
                                <asp:ListItem value="LT">Lithuania</asp:ListItem>
                                <asp:ListItem value="LU">Luxembourg</asp:ListItem>
                                <asp:ListItem value="MO">Macao SAR</asp:ListItem>
                                <asp:ListItem value="MK">Macedonia</asp:ListItem>
                                <asp:ListItem value="MG">Madagascar</asp:ListItem>
                                <asp:ListItem value="MW">Malawi</asp:ListItem>
                                <asp:ListItem value="MY">Malaysia</asp:ListItem>
                                <asp:ListItem value="MV">Maldives</asp:ListItem>
                                <asp:ListItem value="ML">Mali</asp:ListItem>
                                <asp:ListItem value="MT">Malta</asp:ListItem>
                                <asp:ListItem value="MH">Marshall Islands</asp:ListItem>
                                <asp:ListItem value="MQ">Martinique</asp:ListItem>
                                <asp:ListItem value="MR">Mauritania</asp:ListItem>
                                <asp:ListItem value="MU">Mauritius</asp:ListItem>
                                <asp:ListItem value="YT">Mayotte</asp:ListItem>
                                <asp:ListItem value="MX">Mexico</asp:ListItem>
                                <asp:ListItem value="FM">Micronesia</asp:ListItem>
                                <asp:ListItem value="MD">Moldova</asp:ListItem>
                                <asp:ListItem value="MC">Monaco</asp:ListItem>
                                <asp:ListItem value="MN">Mongolia</asp:ListItem>
                                <asp:ListItem value="MS">Montserrat</asp:ListItem>
                                <asp:ListItem value="MA">Morocco</asp:ListItem>
                                <asp:ListItem value="MZ">Mozambique</asp:ListItem>
                                <asp:ListItem value="MM">Myanmar</asp:ListItem>
                                <asp:ListItem value="NA">Namibia</asp:ListItem>
                                <asp:ListItem value="NR">Nauru</asp:ListItem>
                                <asp:ListItem value="NP">Nepal</asp:ListItem>
                                <asp:ListItem value="AN">Netherlands Antilles</asp:ListItem>
                                <asp:ListItem value="NL">Netherlands, The</asp:ListItem>
                                <asp:ListItem value="NC">New Caledonia</asp:ListItem>
                                <asp:ListItem value="NZ">New Zealand</asp:ListItem>
                                <asp:ListItem value="NI">Nicaragua</asp:ListItem>
                                <asp:ListItem value="NE">Niger</asp:ListItem>
                                <asp:ListItem value="NG">Nigeria</asp:ListItem>
                                <asp:ListItem value="NU">Niue</asp:ListItem>
                                <asp:ListItem value="NF">Norfolk Island</asp:ListItem>
                                <asp:ListItem value="KP">North Korea</asp:ListItem>
                                <asp:ListItem value="MP">Northern Mariana Islands</asp:ListItem>
                                <asp:ListItem value="NO">Norway</asp:ListItem>
                                <asp:ListItem value="OM">Oman</asp:ListItem>
                                <asp:ListItem value="PK">Pakistan</asp:ListItem>
                                <asp:ListItem value="PW">Palau</asp:ListItem>
                                <asp:ListItem value="PS">Palestinian Authority</asp:ListItem>
                                <asp:ListItem value="PA">Panama</asp:ListItem>
                                <asp:ListItem value="PG">Papua New Guinea</asp:ListItem>
                                <asp:ListItem value="PY">Paraguay</asp:ListItem>
                                <asp:ListItem value="PE">Peru</asp:ListItem>
                                <asp:ListItem value="PH">Philippines</asp:ListItem>
                                <asp:ListItem value="PN">Pitcairn Islands</asp:ListItem>
                                <asp:ListItem value="PL">Poland</asp:ListItem>
                                <asp:ListItem value="PT">Portugal</asp:ListItem>
                                <asp:ListItem value="PR">Puerto Rico</asp:ListItem>
                                <asp:ListItem value="QA">Qatar</asp:ListItem>
                                <asp:ListItem value="RE">Reunion</asp:ListItem>
                                <asp:ListItem value="RO">Romania</asp:ListItem>
                                <asp:ListItem value="RU">Russia</asp:ListItem>
                                <asp:ListItem value="RW">Rwanda</asp:ListItem>
                                <asp:ListItem value="WS">Samoa</asp:ListItem>
                                <asp:ListItem value="SM">San Marino</asp:ListItem>
                                <asp:ListItem value="ST">São Tomé and Príncipe</asp:ListItem>
                                <asp:ListItem value="SA">Saudi Arabia</asp:ListItem>
                                <asp:ListItem value="SN">Senegal</asp:ListItem>
                                <asp:ListItem value="YU">Serbia and Montenegro</asp:ListItem>
                                <asp:ListItem value="SC">Seychelles</asp:ListItem>
                                <asp:ListItem value="SL">Sierra Leone</asp:ListItem>
                                <asp:ListItem value="SG">Singapore</asp:ListItem>
                                <asp:ListItem value="SK">Slovakia</asp:ListItem>
                                <asp:ListItem value="SI">Slovenia</asp:ListItem>
                                <asp:ListItem value="SB">Solomon Islands</asp:ListItem>
                                <asp:ListItem value="SO">Somalia</asp:ListItem>
                                <asp:ListItem value="ZA">South Africa</asp:ListItem>
                                <asp:ListItem value="GS">South Georgia</asp:ListItem>
                                <asp:ListItem value="ES">Spain</asp:ListItem>
                                <asp:ListItem value="LK">Sri Lanka</asp:ListItem>
                                <asp:ListItem value="SH">St. Helena</asp:ListItem>
                                <asp:ListItem value="KN">St. Kitts and Nevis</asp:ListItem>
                                <asp:ListItem value="LC">St. Lucia</asp:ListItem>
                                <asp:ListItem value="PM">St. Pierre and Miquelon</asp:ListItem>
                                <asp:ListItem value="VC">St. Vincent and the Grenadines</asp:ListItem>
                                <asp:ListItem value="SD">Sudan</asp:ListItem>
                                <asp:ListItem value="SR">Suriname</asp:ListItem>
                                <asp:ListItem value="SJ">Svalbard and Jan Mayen</asp:ListItem>
                                <asp:ListItem value="SZ">Swaziland</asp:ListItem>
                                <asp:ListItem value="SE">Sweden</asp:ListItem>
                                <asp:ListItem value="CH">Switzerland</asp:ListItem>
                                <asp:ListItem value="SY">Syria</asp:ListItem>
                                <asp:ListItem value="TW">Taiwan</asp:ListItem>
                                <asp:ListItem value="TJ">Tajikistan</asp:ListItem>
                                <asp:ListItem value="TZ">Tanzania</asp:ListItem>
                                <asp:ListItem value="TH">Thailand</asp:ListItem>
                                <asp:ListItem value="TP">Timor-Leste</asp:ListItem>
                                <asp:ListItem value="TG">Togo</asp:ListItem>
                                <asp:ListItem value="TK">Tokelau</asp:ListItem>
                                <asp:ListItem value="TO">Tonga</asp:ListItem>
                                <asp:ListItem value="TT">Trinidad and Tobago</asp:ListItem>
                                <asp:ListItem value="TA">Tristan da Cunha</asp:ListItem>
                                <asp:ListItem value="TN">Tunisia</asp:ListItem>
                                <asp:ListItem value="TR">Turkey</asp:ListItem>
                                <asp:ListItem value="TM">Turkmenistan</asp:ListItem>
                                <asp:ListItem value="TC">Turks and Caicos Islands</asp:ListItem>
                                <asp:ListItem value="TV">Tuvalu</asp:ListItem>
                                <asp:ListItem value="UG">Uganda</asp:ListItem>
                                <asp:ListItem value="UA">Ukraine</asp:ListItem>
                                <asp:ListItem value="AE">United Arab Emirates</asp:ListItem>
                                <asp:ListItem value="UK">United Kingdom</asp:ListItem>
                                <asp:ListItem value="US">United States</asp:ListItem>
                                <asp:ListItem value="UM">United States Minor</asp:ListItem>
                                <asp:ListItem value="UY">Uruguay</asp:ListItem>
                                <asp:ListItem value="UZ">Uzbekistan</asp:ListItem>
                                <asp:ListItem value="VU">Vanuatu</asp:ListItem>
                                <asp:ListItem value="VA">Vatican City</asp:ListItem>
                                <asp:ListItem value="VE">Venezuela</asp:ListItem>
                                <asp:ListItem value="VN">Vietnam</asp:ListItem>
                                <asp:ListItem value="VI">Virgin Islands</asp:ListItem>
                                <asp:ListItem value="VG">Virgin Islands, British</asp:ListItem>
                                <asp:ListItem value="WF">Wallis and Futuna</asp:ListItem>
                                <asp:ListItem value="YE">Yemen</asp:ListItem>
                                <asp:ListItem value="ZM">Zambia</asp:ListItem>
                                <asp:ListItem value="ZW">Zimbabwe</asp:ListItem>
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCountry" ControlToValidate="ddShippingCountry" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label ID="lblState" meta:resourcekey="lblState" runat="server" Text="State/Province" Font-Size="XX-Small"></asp:Label><br />
                    <script language="javascript" type="text/javascript">
                        function clientValidateState(source, arguments) 
                            {
                            var ddShippingState=document.getElementById("<%=ddShippingState.clientId%>");
                            if (ddShippingState.style.display=='none') 
                                {
                                var txtShippingState=document.getElementById("<%=txtShippingState.clientId%>");
                                if(txtShippingState.value=="") 
                                    {
                                    arguments.IsValid=false;
                                    return;   
                                    }
                                }
                            arguments.IsValid=true;    
                            }                           
                    </script>
                    <asp:DropDownList ID="ddShippingState" runat="server">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtShippingState" Width="180px" runat="server"></asp:TextBox>
                    <asp:CustomValidator runat="server" ID="cvState" ClientValidationFunction="clientValidateState" ErrorMessage="*" SetFocusOnError="true"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblCity" meta:resourcekey="lblCity" runat="server" Text="City" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingCity" Width="180px" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv4" ControlToValidate="txtShippingCity" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label ID="lblZip" meta:resourcekey="lblZip" runat="server" Text="Zip/Postal Code" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingZip" Width="180px" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv5" ControlToValidate="txtShippingZip" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblPhone" meta:resourcekey="lblPhone" runat="server" Text="Phone" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingPhone" Width="180px" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv6" ControlToValidate="txtShippingPhone" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label Visible="false" ID="lblFax" meta:resourcekey="lblFax" runat="server" Text="Fax (optional)" Font-Size="XX-Small"></asp:Label>
                    <asp:Label ID="lblMobile" meta:resourcekey="lblMobile" runat="server" Text="lblMobile (optional)" Font-Size="XX-Small"></asp:Label><br />
                    <asp:TextBox ID="txtShippingFax" Width="180px" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:right;padding-top:10px">
                    <asp:Button ID="btnSaveAndReview" meta:resourcekey="btnSaveAndReview" runat="server" Text=" SAVE & REVIEW ORDER " OnClick="btnSaveAndReview_Click" />
                </td>
            </tr>
            </table>
        </asp:WizardStep>
        
        <asp:WizardStep ID="WizardStep4" runat="server" AllowReturn="false" StepType="Finish" Title="">
            <p>
                <asp:Label ID="lblPleaseReview" meta:resourcekey="lblPleaseReview" runat="server" Text="Please review the following item in your shopping cart:"></asp:Label>
            </p>
            <asp:GridView ID="GridView2" Width="100%" CellPadding="10" runat="server" AutoGenerateColumns="false"
            DataKeyNames="id">
            <Columns>
            <asp:BoundField DataField="item_desc" HeaderText="Item" meta:resourcekey="colItem" ItemStyle-Width="100%" />            
            <asp:BoundField DataField="qty" HeaderText="Quantity" meta:resourcekey="colQuantity" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
            <asp:TemplateField HeaderText="Price" meta:resourcekey="colPrice" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                <ItemTemplate><%#ShowPrice(Eval("price"), Eval("current_price"))%></ItemTemplate>
            </asp:TemplateField>
            </Columns>
            </asp:GridView> 
            <hr />
            <table cellpadding="7" style="width:100%">
            <tr id="idSubTotal" runat="server">
                <td style="width:100%;text-align:right">
                <asp:Label ID="lblSubtotalLabel2" meta:resourcekey="lblSubtotalLabel" runat="server" Font-Bold="true" Text="Subtotal"></asp:Label>
                </td>
                <td>:&nbsp;</td>
                <td style="text-align:right">          
                <asp:Label ID="lblSubTotal2" runat="server" Font-Bold="true" Text=""></asp:Label>
                </td>
            </tr>
            <tr id="idShipping" runat="server">
                <td style="width:100%;text-align:right">
                <asp:Label ID="lblShippingLabel" meta:resourcekey="lblShippingLabel" runat="server" Text="Postage and Packing"></asp:Label>
                </td>
                <td>:&nbsp;</td>
                <td style="text-align:right">            
                <asp:Label ID="lblShipping" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr id="idTax" runat="server">
                <td style="width:100%;text-align:right">
                <asp:Label ID="lblTaxLabel" meta:resourcekey="lblTaxLabel" runat="server" Text="Tax"></asp:Label>
                </td>
                <td>:&nbsp;</td>
                <td style="text-align:right">            
                <asp:Label ID="lblTax" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width:100%;text-align:right">
                <asp:Label ID="lblTotalLabel" meta:resourcekey="lblTotalLabel" runat="server" Font-Bold="true" Text="Total"></asp:Label>
                </td>
                <td>:&nbsp;</td>
                <td style="text-align:right">                
                <asp:Label ID="lblTotal" runat="server" Font-Bold="true" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align:right"colspan="3">
                    <asp:HyperLink ID="lnkEditCart" meta:resourcekey="lnkEditCart" Text="Edit Cart" runat="server"></asp:HyperLink>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                <asp:Label ID="lblTerms" meta:resourcekey="lblTerms" Font-Bold="true" runat="server" Text="Terms & Conditions"></asp:Label>
                <br />
                <asp:Panel ID="Panel1"  BorderWidth="1" BorderColor="#cccccc" BorderStyle=solid runat="server" ScrollBars="Vertical" Height="70px" Width="100%">
                    <div style="padding:5px"><asp:Literal ID="litTerms" runat="server"></asp:Literal></div>
                </asp:Panel>
                <div style="text-align:right">
                <asp:CheckBox ID="chkAcceptTerms" meta:resourcekey="chkAcceptTerms" Text="Accept Terms & Conditions" runat="server" />
                <asp:CustomValidator ID="cvAccept" ClientValidationFunction="clientValidateTerms" ErrorMessage="*" runat="server"></asp:CustomValidator>
                </div>
                </td>
            </tr>
            <tr id="idChoosePayment" runat="server">
                <td colspan="3">
                <asp:Label ID="lblBillingInfo" meta:resourcekey="lblBillingInfo" runat="server" Font-Bold=true Text="Billing Information"></asp:Label>
                <br />
                <asp:Label ID="lblChoosePayment" meta:resourcekey="lblChoosePayment" runat="server" Text="Please choose your preferred payment method:"></asp:Label>
                </td>
            </tr>
            <tr id="idPaypal" runat="server">
                <td colspan="3" style="text-align:right">
                    <asp:Label ID="lblCCPaypal" meta:resourcekey="lblCCPaypal" runat="server" Text="Credit Card Payment using PayPal:"></asp:Label>
                    <asp:Button ID="btnPayHere" meta:resourcekey="btnPayHere" runat="server" Text=" Pay Here " OnClick="btnPayHere_Click" />
                </td>
            </tr>
            <tr id="idCashOnDelivery" runat="server">
                <td colspan="3" style="text-align:right">                    
                    <asp:Label ID="lblCashOnDelivery" meta:resourcekey="lblCashOnDelivery" runat="server" Text="Cash On Delivery:"></asp:Label>
                    <asp:Button ID="btnCashOnDelivery" meta:resourcekey="btnCashOnDelivery" runat="server" Text=" Cash On Delivery " OnClick="btnCashOnDelivery_Click" />
                </td>
            </tr>
            </table>
        </asp:WizardStep>
        <asp:WizardStep ID="WizardStep5" runat="server" AllowReturn="false" StepType="Finish" Title="">
            <p>
                <asp:Label ID="lblThankYou" meta:resourcekey="lblThankYou" Font-Bold="true" runat="server" Text="Thank you for your order!"></asp:Label>
            </p>
            <p>
                <asp:Label ID="lblYourOrder" meta:resourcekey="lblYourOrder" runat="server" Text="Your order is currently being processed."></asp:Label>
            </p>
            <asp:HyperLink ID="lnkBack" meta:resourcekey="lnkBack" Text="Back to Home Page" runat="server"></asp:HyperLink>
        </asp:WizardStep>
    </WizardSteps>

    <StepNavigationTemplate>
        <asp:button id="StepPreviousButton" Visible="false" runat="server" causesvalidation="False" commandname="MovePrevious" text="Previous" />
        <asp:button id="StepNextButton" Visible="false" runat="server" commandname="MoveNext" text="Next" />
    </StepNavigationTemplate>
    <FinishNavigationTemplate>
        <asp:button id="StepPreviousButton" Visible="false" runat="server" causesvalidation="False" commandname="MovePrevious" text="Previous" />
        <asp:button id="StepNextButton" Visible="false" runat="server" commandname="MoveNext" text=" Pay Here " />
    </FinishNavigationTemplate>
</asp:Wizard>

<asp:Panel ID="panelEmpty" Visible="false" runat="server">
<p>
<asp:Label ID="lblCartEmpty" meta:resourcekey="lblCartEmpty" Font-Bold="true" runat="server" Text="Shopping Cart Empty."></asp:Label>
</p>
</asp:Panel>

<script language="javascript" type="text/javascript">
function clientValidateTerms(source, arguments) 
    {
    var chkAcceptTerms=document.getElementById("<%=chkAcceptTerms.clientId%>");
    if (chkAcceptTerms) 
        {
        if(!chkAcceptTerms.checked) 
            {
            alert('<%=getlocalresourceobject("PleaseCheckTerms")%>')
            arguments.IsValid=false;
            return;   
            }
        }
    arguments.IsValid=true;    
    }      
</script>
