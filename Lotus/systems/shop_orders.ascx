<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private sCurrencySymbol As String = ""
    Private sCurrencySeparator As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelOrders.Visible = False
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelOrders.Visible = True
                panelLogin.Visible = False
                
                GetConfigShop()
                txtToDate.Text = Now.Year & "/" & Now.Month & "/" & Now.Day
                txtFromDate.Text = Now.Subtract(New TimeSpan(72, 0, 0)).Year & "/" & Now.Subtract(New TimeSpan(168, 0, 0)).Month & "/" & Now.Subtract(New TimeSpan(168, 0, 0)).Day
            
                If Not Page.IsPostBack Then
                
                    Dim sqlDS As SqlDataSource = New SqlDataSource
                    sqlDS.ConnectionString = sConn
                    sqlDS.SelectCommand = "SELECT * FROM orders WHERE order_date>=@date_from AND order_date<=@date_to order by order_date desc"
                    sqlDS.SelectParameters.Add("date_from", SqlDbType.DateTime)
                    Dim dTmp As DateTime = Now.Subtract(New TimeSpan(72, 0, 0))
                    sqlDS.SelectParameters(0).DefaultValue = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 0, 0, 0).AddHours(-Me.TimeOffset) 'Now 'Now.Subtract(New TimeSpan(72, 0, 0))
                    sqlDS.SelectParameters.Add("date_to", SqlDbType.DateTime)
                    Dim dTmp2 As DateTime = Now
                    sqlDS.SelectParameters(1).DefaultValue = New DateTime(dTmp2.Year, dTmp2.Month, dTmp2.Day, 23, 59, 59).AddHours(-Me.TimeOffset) 'Now
 
                    GridView1.DataSource = sqlDS
                    GridView1.DataBind()
                End If
            End If
        End If
    End Sub

    Protected Sub btnOrdersByStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim dTmp As DateTime
        Dim dTmp2 As DateTime
        
        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        If dropOrderStatus.SelectedValue = "" Then
            sqlDS.SelectCommand = "SELECT * FROM orders WHERE order_date>=@date_from AND order_date<=@date_to order by order_date desc"
            sqlDS.SelectParameters.Add("date_from", SqlDbType.DateTime)
            dTmp = Convert.ToDateTime(txtFromDate.Text)
            sqlDS.SelectParameters(0).DefaultValue = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 0, 0, 0).AddHours(-Me.TimeOffset)
            sqlDS.SelectParameters.Add("date_to", SqlDbType.DateTime)
            dTmp2 = Convert.ToDateTime(txtToDate.Text)
            sqlDS.SelectParameters(1).DefaultValue = New DateTime(dTmp2.Year, dTmp2.Month, dTmp2.Day, 23, 59, 59).AddHours(-Me.TimeOffset)
        Else
            If dropOrderStatus.SelectedValue = "WAITING" Then
                sqlDS.SelectCommand = "SELECT * FROM orders WHERE (status='WAITING_FOR_PAYMENT' OR status='CONFIRMED') AND order_date>=@date_from AND order_date<@date_to order by order_date desc"
            ElseIf dropOrderStatus.SelectedValue = "CONFIRMED" Then
                'Combined with Waiting
            ElseIf dropOrderStatus.SelectedValue = "VERIFIED" Then
                sqlDS.SelectCommand = "SELECT * FROM orders WHERE status='VERIFIED' AND order_date>=@date_from AND order_date<=@date_to order by order_date desc"
            End If
            sqlDS.SelectParameters.Add("date_from", SqlDbType.DateTime)
            dTmp = Convert.ToDateTime(txtFromDate.Text)
            sqlDS.SelectParameters(0).DefaultValue = New DateTime(dTmp.Year, dTmp.Month, dTmp.Day, 0, 0, 0).AddHours(-Me.TimeOffset)
            sqlDS.SelectParameters.Add("date_to", SqlDbType.DateTime)
            dTmp2 = Convert.ToDateTime(txtToDate.Text)
            sqlDS.SelectParameters(1).DefaultValue = New DateTime(dTmp2.Year, dTmp2.Month, dTmp2.Day, 23, 59, 59).AddHours(-Me.TimeOffset)
        End If
        GridView1.DataSource = sqlDS
        GridView1.DataBind()
        
        txtOrderEmail.Text = ""
        txtOrderID.Text = ""
    End Sub

    Protected Sub btnOrdersByEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sOrderBy As String = Membership.GetUserNameByEmail(txtOrderEmail.Text)
        
        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = "SELECT * FROM orders WHERE order_by=@order_by order by order_date desc"
        sqlDS.SelectParameters.Add("order_by", SqlDbType.NVarChar)
        sqlDS.SelectParameters(0).DefaultValue = sOrderBy
        GridView1.DataSource = sqlDS
        GridView1.DataBind()
        
        txtOrderID.Text = ""
    End Sub

    Protected Sub btnOrdersByID_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = "SELECT * FROM orders WHERE order_id=@order_id"
        sqlDS.SelectParameters.Add("order_id", SqlDbType.Int)
        sqlDS.SelectParameters(0).DefaultValue = txtOrderID.Text
        GridView1.DataSource = sqlDS
        GridView1.DataBind()
        
        txtOrderEmail.Text = ""
    End Sub
    
    Function ShowCustomer(ByVal sOrderBy As String) As String
        Dim user As MembershipUser = Membership.GetUser(sOrderBy)
        Return sOrderBy & "<br />" & user.Email
    End Function
    
    Function ShowStatus(ByVal sStatus As String, ByVal sMethod As String) As String
        Dim sReturn As String = ""
        
        If sMethod = "PAYPAL" Then
            sReturn = "Paypal"
        ElseIf sMethod = "CASH_ON_DELIVERY" Then
            sReturn = GetLocalResourceObject("COD")
        End If
        
        If sStatus = "WAITING_FOR_PAYMENT" Then
            sReturn += " (" & GetLocalResourceObject("WaitingForPayment") & ")"
        ElseIf sStatus = "CONFIRMED" Then
            sReturn += " (" & GetLocalResourceObject("Confirmed") & ")"
        Else
            sReturn += " (" & GetLocalResourceObject("Verified") & ")"
        End If
        Return sReturn
    End Function
    
    Function ShowTotal(ByVal nSubTotal As Decimal, ByVal nShipping As Decimal, ByVal nTax As Decimal) As String
        Dim sHTML As String
        If nShipping > 0 Or nTax > 0 Then
            sHTML = GetLocalResourceObject("subtotal") & "&nbsp;" & sCurrencySymbol & FormatNumber(nSubTotal, 2)
        Else
            Return sCurrencySymbol & FormatNumber(nSubTotal, 2)
        End If
        If nShipping > 0 Then
            sHTML += "<br />" & GetLocalResourceObject("shipping") & "&nbsp;" & sCurrencySymbol & FormatNumber(nShipping, 2)
        End If
        If nTax > 0 Then
            sHTML += "<br />" & GetLocalResourceObject("tax") & "&nbsp;" & sCurrencySymbol & FormatNumber(nTax, 2)
        End If
        Return sHTML
    End Function
    
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
            sHTML += "<div>" & oDataReader("item_desc").ToString & "(" & oDataReader("qty").ToString & ")</div>"
        End While
        oDataReader.Close()
        oCmd.Dispose()
        oConn.Close()
        
        Return sHTML
    End Function
    
    Function ShowShippingStatus(ByVal sShippingStatus As String, ByVal sShippingFirstName As String) As String
        If sShippingFirstName = "" Then
            Return GetLocalResourceObject("NotRequired")
        Else
            If sShippingStatus = "" Then
                Return GetLocalResourceObject("Waiting")
            Else
                Return GetLocalResourceObject("Shipped")
            End If
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
        oCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Me.RootID
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
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelOrders" runat="server">

<table cellpadding="7" cellspacing="0" style="margin-bottom:15px">
<tr>
    <td colspan="8" style="padding-left:0px"><asp:Label ID="lblOrdersByStatus" meta:resourcekey="lblOrdersByStatus" Font-Bold="true" runat="server" Text="Orders by status"></asp:Label></td>
</tr>
<tr>
    <td style="padding-left:0px"><asp:Label ID="lblStatus" meta:resourcekey="lblStatus" runat="server" Text="Status:"></asp:Label></td>
    <td>
        <asp:DropDownList ID="dropOrderStatus" runat="server">
        <asp:ListItem Text="All Status" Value=""></asp:ListItem>
        <asp:ListItem meta:resourcekey="optWaitingForPayment" Text="Waiting for payment" Value="WAITING"></asp:ListItem>
<%--        <asp:ListItem meta:resourcekey="optConfirmed" Text="Confirmed" Value="CONFIRMED"></asp:ListItem>--%>
        <asp:ListItem meta:resourcekey="optVerified" Text="Verified" Value="VERIFIED"></asp:ListItem>
        </asp:DropDownList>
    </td>
    <td><asp:Label ID="lblFrom" meta:resourcekey="lblFrom" runat="server" Text="From:"></asp:Label></td>
    <td><asp:TextBox ID="txtFromDate" Width="60" runat="server"></asp:TextBox></td>
    <td><asp:Label ID="lblTo" meta:resourcekey="lblTo" runat="server" Text="To:"></asp:Label></td>
    <td><asp:TextBox ID="txtToDate" Width="60" runat="server"></asp:TextBox></td>
    <td><i>(YYYY/MM/DD)</i></td>
    <td><asp:Button ID="btnOrdersByStatus" meta:resourcekey="btnOrdersByStatus" runat="server" Text=" View " OnClick="btnOrdersByStatus_Click" /></td>
</tr>
<tr>
    <td colspan="8" style="padding-left:0px"><asp:Label ID="lblOrdersByEmail" meta:resourcekey="lblOrdersByEmail" Font-Bold="true" runat="server" Text="Orders by email"></asp:Label></td>
</tr>
<tr>
    <td style="padding-left:0px"><asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email:"></asp:Label></td>
    <td><asp:TextBox ID="txtOrderEmail" runat="server"></asp:TextBox></td>
    <td colspan="6"><asp:Button ID="btnOrdersByEmail" meta:resourcekey="btnOrdersByEmail" runat="server" Text=" Find " OnClick="btnOrdersByEmail_Click" /></td>
</tr>
<tr>
    <td colspan="8" style="padding-left:0px"><asp:Label ID="lblOrdersByID" meta:resourcekey="lblOrdersByID" runat="server" Font-Bold="true" Text="Orders by ID"></asp:Label></td>
</tr>
<tr>
    <td style="padding-left:0px"><asp:Label ID="lblID" meta:resourcekey="lblID" runat="server" Text="ID:"></asp:Label></td>
    <td><asp:TextBox ID="txtOrderID" runat="server"></asp:TextBox></td>
    <td colspan="6"><asp:Button ID="btnOrdersByID" meta:resourcekey="btnOrdersByID" runat="server" Text=" Find " OnClick="btnOrdersByID_Click" /></td>
</tr>
</table>

<asp:GridView ID="GridView1" CellPadding="7" AutoGenerateColumns="false" runat="server">
<Columns>
<asp:TemplateField HeaderText="ID" meta:resourcekey="colID" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <a href="javascript:modalDialog('<%#me.AppPath %>systems/shop_item.aspx?c=<%#me.Culture %>&oid=<%#Eval("order_id")%>',400,430)"><%#Eval("order_id")%></a>
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Date" meta:resourcekey="colDate" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <%#FormatDateTime(CDate(Eval("order_date")).AddHours(Me.TimeOffset), DateFormat.GeneralDate)%> 
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Customer" meta:resourcekey="colCustomer" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <%#ShowCustomer(Eval("order_by"))%><br />    
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Items" Visible="false" meta:resourcekey="colItems" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <%#ShowItems(Eval("order_id"))%>
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Total" meta:resourcekey="colTotal" HeaderStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="right">
    <ItemTemplate>
    <%#ShowTotal(Eval("sub_total"), Eval("shipping"), Eval("tax"))%>
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Payment" meta:resourcekey="colStatus" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <%#ShowStatus(Eval("status"), Eval("payment_method"))%>
    </ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Shipment" meta:resourcekey="colShipment" ItemStyle-VerticalAlign="Top">
    <ItemTemplate>
    <%#ShowShippingStatus(Eval("shipping_status", ""), Eval("shipping_first_name", ""))%>
    </ItemTemplate>
</asp:TemplateField>
</Columns>
</asp:GridView>

</asp:Panel>





