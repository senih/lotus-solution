<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            panelConfig.Visible = True
            
            txtTerms.Css = Me.AppPath & "templates/" & Me.TemplateFolderName & "/editing.css"

            Dim sSQL As String = "select * from config_shop where root_id=@root_id"
            Dim oCommand As New SqlCommand(sSQL)
            oCommand.Connection = oConn
            oConn.Open()
            Dim oReader As SqlDataReader
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
            oReader = oCommand.ExecuteReader

            If oReader.Read Then
                txtSymbol.Text = oReader("currency_symbol").ToString
                txtSeparator.Text = oReader("currency_separator").ToString
                txtCode.Text = oReader("currency_code").ToString
                txtOrderDesc.Text = oReader("order_description").ToString
                txtTerms.Text = oReader("terms").ToString
                txtPpEmail.Text = oReader("paypal_email").ToString
                txtPpUrl.Text = oReader("paypal_url").ToString

                txtPpOrder.Text = oReader("paypal_order_email_template").ToString
                txtOrderNow.Text = oReader("order_now_template").ToString
                
                oReader.Close()
                oCommand.Dispose()
                oConn.Close()
                Exit Sub
            End If

            'if config record not exist
            oReader.Close()
            oCommand.Dispose()
            
            sSQL = "insert into config_shop (currency_symbol,currency_separator,currency_code,order_description,terms,paypal_email,paypal_url,paypal_order_email_template,order_now_template,root_id) values (@symbol,@separator,@code,@orderDesc,@terms,@ppemail,@ppurl,@ppOrder,@orderNow,@root_id)"
            oCommand = New SqlCommand(sSQL)
            oCommand.Connection = oConn
            oCommand.Parameters.Add("@symbol", SqlDbType.NVarChar).Value = "$"
            oCommand.Parameters.Add("@separator", SqlDbType.NVarChar).Value = ""
            oCommand.Parameters.Add("@code", SqlDbType.NVarChar).Value = "USD"
            oCommand.Parameters.Add("@orderDesc", SqlDbType.NVarChar).Value = "Shopping Cart Total"
            oCommand.Parameters.Add("@terms", SqlDbType.Text).Value = "Your Terms here..."
            oCommand.Parameters.Add("@ppemail", SqlDbType.NVarChar).Value = ""
            oCommand.Parameters.Add("@ppurl", SqlDbType.NVarChar).Value = "https://www.sandbox.paypal.com/us/cgi-bin/webscr"
            oCommand.Parameters.Add("@ppOrder", SqlDbType.Text).Value = "<html><head><title>Thank you for your order</title><style>td{font-family:Verdana;font-size:11px}</style></head><body style=""font-family:Verdana;font-size:11px""><p>Dear Customer,</p><p><b>Thank you for your order!</b><p>Following is a list of items you purchased on [%ORDER_DATE%] - Order #[%ORDER_ID%]:</p>[%ORDER_DETAIL%]<p>If your order contains downloadable items, please visit:&nbsp;<a href=""[%DOWNLOAD_LINK%]"">[%DOWNLOAD_LINK%]</a></p><p>Sincerely,<br>Support Team<br><a href=""[%WEBSITE_URL%]"">[%WEBSITE_URL%]</a></p></body></html>"
            oCommand.Parameters.Add("@orderNow", SqlDbType.Text).Value = "<table cellpadding=""0"" cellspacing=""0"" class=""boxOrderNow""><tr><td class=""boxHeaderOrderNow"">Order Now!</td></tr><tr><td class=""boxContentOrderNow""><b>[%TITLE%]</b><br />[%SUMMARY%]<br /><br /><table cellpadding=""0"" cellspacing=""0""><tr style=""[%HIDE_PRICE%]""><td style=""text-align:right;padding:5px;padding-left:0px"">List Price: </td><td style=""font-size:14px;padding:5px""><strike>[%PRICE%]</strike></td></tr><tr><td style=""text-align:right;padding:5px;padding-left:0px"">Price:</td><td style=""font-size:12px;font-weight:bold;padding:5px"">[%CURRENT_PRICE%]</td></tr></table><br /><a href=""[%PAYPAL_ADD_TO_CART_URL%]""/><img src=""resources/1/btnBuyNow.jpg"" alt="""" border=""0""/></a><br /></td></tr></table>"
            oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
            oCommand.Connection = oConn
            oCommand.ExecuteReader(CommandBehavior.CloseConnection)
            
            oConn.Close()
            
            txtSymbol.Text = "$"
            txtSeparator.Text = ""
            txtCode.Text = "USD"
            txtOrderDesc.Text = "Shopping Cart Total"
            txtTerms.Text = "Your Terms here..."
            txtPpEmail.Text = ""
            txtPpUrl.Text = "https://www.sandbox.paypal.com/us/cgi-bin/webscr"
            txtPpOrder.Text = "<html><head><title>Thank you for your order</title><style>td{font-family:Verdana;font-size:11px}</style></head><body style=""font-family:Verdana;font-size:11px""><p>Dear Customer,</p><p><b>Thank you for your order!</b><p>Following is a list of items you purchased on [%ORDER_DATE%] - Order #[%ORDER_ID%]:</p>[%ORDER_DETAIL%]<p>If your order contains downloadable items, please visit:&nbsp;<a href=""[%DOWNLOAD_LINK%]"">[%DOWNLOAD_LINK%]</a></p><p>Sincerely,<br>Support Team<br><a href=""[%WEBSITE_URL%]"">[%WEBSITE_URL%]</a></p></body></html>"
            txtOrderNow.Text = "<table cellpadding=""0"" cellspacing=""0"" class=""boxOrderNow""><tr><td class=""boxHeaderOrderNow"">Order Now!</td></tr><tr><td class=""boxContentOrderNow""><b>[%TITLE%]</b><br />[%SUMMARY%]<br /><br /><table cellpadding=""0"" cellspacing=""0""><tr style=""[%HIDE_PRICE%]""><td style=""text-align:right;padding:5px;padding-left:0px"">List Price: </td><td style=""font-size:14px;padding:5px""><strike>[%PRICE%]</strike></td></tr><tr><td style=""text-align:right;padding:5px;padding-left:0px"">Price:</td><td style=""font-size:12px;font-weight:bold;padding:5px"">[%CURRENT_PRICE%]</td></tr></table><br /><a href=""[%PAYPAL_ADD_TO_CART_URL%]""/><img src=""resources/1/btnBuyNow.jpg"" alt="""" border=""0""/></a><br /></td></tr></table>"
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sSQL As String = "update config_shop set currency_symbol=@symbol, currency_separator=@separator, currency_code=@code, order_description=@orderDesc, terms=@terms, paypal_email=@ppemail, paypal_url=@ppurl,paypal_order_email_template=@ppOrder, order_now_template=@orderNow where root_id=@root_id"
        Dim oCommand As New SqlCommand(sSQL)
        oCommand.Connection = oConn
        oConn.Open()

        oCommand.Parameters.Add("@symbol", SqlDbType.NVarChar).Value = txtSymbol.Text
        oCommand.Parameters.Add("@separator", SqlDbType.NVarChar).Value = txtSeparator.Text
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar).Value = txtCode.Text
        oCommand.Parameters.Add("@orderDesc", SqlDbType.NVarChar).Value = txtOrderDesc.Text
        oCommand.Parameters.Add("@terms", SqlDbType.Text).Value = txtTerms.Text
        oCommand.Parameters.Add("@ppemail", SqlDbType.NVarChar).Value = txtPpEmail.Text
        oCommand.Parameters.Add("@ppurl", SqlDbType.NVarChar).Value = txtPpUrl.Text
        oCommand.Parameters.Add("@ppOrder", SqlDbType.Text).Value = txtPpOrder.Text
        oCommand.Parameters.Add("@orderNow", SqlDbType.Text).Value = txtOrderNow.Text
        oCommand.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
        oCommand.Connection = oConn
        oCommand.ExecuteReader(CommandBehavior.CloseConnection)
        
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelConfig" runat="server" Visible="False" Wrap=false>
  <table>
    <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblSymbol" meta:resourcekey="lblSymbol" runat="server"></asp:Label>
      </td>
      <td valign="top"> : </td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtSymbol" runat="server"></asp:TextBox>
      </td>
    </tr>
      <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblSeparator" meta:resourcekey="lblSeparator" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtSeparator" runat="server"></asp:TextBox>
      </td>
    </tr>
    <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblCode" meta:resourcekey="lblCode" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtCode" runat="server"></asp:TextBox>
      </td>
    </tr>
    <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblOrderDesc" meta:resourcekey="lblOrderDesc" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtOrderDesc" runat="server"></asp:TextBox>
      </td>
    </tr>
    <tr>
      <td style="text-align:left;white-space:nowrap" colspan="3"  valign="top">
        <br /><asp:Label ID="lblTerms" meta:resourcekey="lblTerms" runat="server"></asp:Label>
      </td>
    </tr>
      <tr>
      <td style="text-align:left;white-space:nowrap" colspan="3" valign="top">
        <editor:WYSIWYGEditor runat="server" ID="txtTerms" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="250px" Text="" />
        <br /><br />
      </td>
    </tr>
    <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblPpEmail" meta:resourcekey="lblPpEmail" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtPpEmail" Width="300" runat="server"></asp:TextBox>
      </td>
    </tr>
      <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblPpUrl" meta:resourcekey="lblPpUrl" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtPpUrl" Width="300" runat="server"></asp:TextBox>
      </td>
    </tr>
      <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblPpOrder" meta:resourcekey="lblPpOrder" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtPpOrder" TextMode="MultiLine" Width="400" Height="250px" runat="server"></asp:TextBox>
      </td>
    </tr>
      <tr>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:Label ID="lblOrderNow" meta:resourcekey="lblOrderNow" runat="server"></asp:Label>
      </td>
      <td valign="top">:</td>
      <td style="text-align:left;white-space:nowrap" valign="top">
        <asp:TextBox ID="txtOrderNow" TextMode="MultiLine" Width="400" Height="250px" runat="server"></asp:TextBox>
      </td>
    </tr>
    <tr>
      <td style="text-align:left;white-space:nowrap" valign="top" colspan ="3">
        <br /><asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text=" Save " OnClick="btnSave_Click" />
      </td>
    </tr>
  </table>
</asp:Panel>