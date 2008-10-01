<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private dtCoupons As DataTable

    Private sCurrencySymbol As String
    Private sCurrencySeparator As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            panelCoupons.Visible = True
            panelCouponsData.Visible = True
        
            GetConfigShop()
            lblCurrencySymbol.Text = sCurrencySymbol
  
            rbType1.Checked = True
            rbType2.Checked = False
            rbType3.Checked = False
    
            rbProduct1.Checked = True
            rbProduct2.Checked = False
    
            ListCoupons()
        End If
    End Sub

    Sub ListCoupons()
        Dim sSQL As String = "select * from coupons"
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = sSQL
        sqlDS.DeleteCommand = "--"
        gvCoupons.DataBind()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sCmd As String
        Dim oCmd As New SqlCommand
        oConn.Open()
    
        oCmd.Connection = oConn
        sCmd = "Insert into coupons(coupon_type,percent_off,amount_off,all_items,item_id,expire_date,min_purchase,code) " & _
               "values (@type, @percent, @amount, @all, @item_id, @exp, @min, @code)"
    
        oCmd.CommandText = sCmd
        oCmd.CommandType = CommandType.Text
    
        If rbType1.Checked = True Then
            oCmd.Parameters.Add("@type", SqlDbType.Int).Value = 1
            oCmd.Parameters.Add("@percent", SqlDbType.Decimal).Value = DBNull.Value
            oCmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = DBNull.Value
        End If
    
        If rbType2.Checked = True Then
            oCmd.Parameters.Add("@type", SqlDbType.Int).Value = 2
            oCmd.Parameters.Add("@percent", SqlDbType.Decimal).Value = txtType2.Text
            oCmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = DBNull.Value
        End If
    
        If rbType3.Checked = True Then
            oCmd.Parameters.Add("@type", SqlDbType.Int).Value = 3
            oCmd.Parameters.Add("@percent", SqlDbType.Decimal).Value = DBNull.Value
            oCmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = txtType3.Text
        End If
    
        If rbProduct1.Checked = True Then
            oCmd.Parameters.Add("@all", SqlDbType.Bit).Value = True
            oCmd.Parameters.Add("@item_id", SqlDbType.Int).Value = DBNull.Value
        End If
    
        If rbProduct2.Checked = True Then
            oCmd.Parameters.Add("@all", SqlDbType.Bit).Value = False
            oCmd.Parameters.Add("@item_id", SqlDbType.Int).Value = txtProduct2.Text
        End If
    
        oCmd.Parameters.Add("@exp", SqlDbType.DateTime).Value = txtExp.Text
        oCmd.Parameters.Add("@min", SqlDbType.Int).Value = txtMin.Text
        oCmd.Parameters.Add("@code", SqlDbType.NVarChar).Value = txtCode.Text
    
        oCmd.ExecuteNonQuery()
    
        oConn.Close()
        oCmd.Dispose()
        Response.Redirect(Me.LinkShopCoupons)
    End Sub

    Protected Sub gvCoupons_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvCoupons.Rows.Count - 1
            CType(gvCoupons.Rows(i).Cells(4).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub gvCoupons_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim oCmd As New SqlCommand
        oConn.Open()
    
        oCmd.Connection = oConn
        oCmd.CommandText = "delete from coupons where coupon_id=" & gvCoupons.DataKeys.Item(e.RowIndex).Value
        oCmd.CommandType = CommandType.Text
        oCmd.ExecuteNonQuery()
    
        oConn.Close()
        oCmd.Dispose()
    
        ListCoupons()
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Function ShowCouponValue(ByVal nCouponType As Integer, ByVal bAllItem As Boolean, _
      ByVal nPercentageOff As Object, ByVal nAmountOff As Object, _
      ByVal nItemId As Object) As String
        
        Dim sTitle As String = ""
        Dim sFileName As String = ""
        If Not IsDBNull(nItemId) Then
            Dim oCmd As SqlCommand
            Dim oDataReader As SqlDataReader
            oConn.Open()
            oCmd = New SqlCommand
            oCmd.Connection = oConn
            oCmd.CommandText = "SELECT * FROM pages_published WHERE page_id=@page_id"
            oCmd.CommandType = CommandType.Text
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nItemId
            oDataReader = oCmd.ExecuteReader
            While oDataReader.Read
                sTitle = oDataReader("title").ToString
                sFileName = oDataReader("file_name").ToString
            End While
            oDataReader.Close()
            oCmd.Dispose()
            oConn.Close()
        End If
    
        If nCouponType = 1 Then
            If bAllItem Then
                Return "Free Shipping on All products"
            Else
                Return "Free Shipping on product #" & nItemId & "<br />" & "<a href=""" & sFileName & """>" & sTitle & "</a>"
            End If
        ElseIf nCouponType = 2 Then
            If bAllItem Then
                Return nPercentageOff & "% Off of All products"
            Else
                Return nPercentageOff & "% Off of product #" & nItemId & "<br />" & "<a href=""" & sFileName & """>" & sTitle & "</a>"
            End If
        Else 'If nCouponType = 3 Then
            If bAllItem Then
                Return sCurrencySymbol & nAmountOff & " Off All products"
            Else
                Return sCurrencySymbol & nAmountOff & " Off product #" & nItemId & "<br />" & "<a href=""" & sFileName & """>" & sTitle & "</a>"
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
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelCoupons" runat="server" Wrap=false Visible="false">
  <asp:GridView ID="gvCoupons" DataSourceID="sqlDS" DataKeyNames="coupon_id" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 HeaderStyle-HorizontalAlign="Left" runat="server" AllowPaging="True" AutoGenerateColumns="False" AllowSorting="False" OnPreRender="gvCoupons_PreRender" OnRowDeleting="gvCoupons_RowDeleting">
  <Columns>
    <asp:TemplateField HeaderText="Expires" ItemStyle-VerticalAlign="top">
      <ItemTemplate>
        <%#FormatDateTime(Eval("expire_date"), DateFormat.ShortDate)%>
      </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField HeaderText="Code" DataField="code" ItemStyle-VerticalAlign="top" />
    <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="top">
      <ItemTemplate>
        <%#ShowCouponValue(Eval("coupon_type"), Eval("all_items"), Eval("percent_off"), Eval("amount_off"), Eval("item_id"))%>
      </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField HeaderText="Min Purchase" DataField="min_purchase" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="top" />
    <asp:CommandField DeleteText="Delete" meta:resourcekey="Delete" ItemStyle-Wrap="false" ShowDeleteButton="true"  ButtonType="link" ItemStyle-VerticalAlign="top" />
  </Columns>
  </asp:GridView>
  <asp:SqlDataSource ID="sqlDS" runat="server" >
</asp:SqlDataSource>
</asp:panel>

<div style="margin:15px"></div>

<asp:Panel ID="panelCouponsData" runat="server" Wrap=false Visible="false">
  <table>
    <tr>
      <td valign="top" style="padding-top:5px"><%=GetLocalResourceObject("Type")%></td><td valign="top" style="padding-top:5px">:</td>
      <td colspan="2">
        
        <table cellpadding="0" cellspacing="0">
        <tr style="display:none">
            <td colspan="2">
                <asp:RadioButton GroupName="Type" ID="rbType1" Checked="true" meta:resourcekey="rbType1" Text="Free Shipping" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:RadioButton GroupName="Type" ID="rbType2" meta:resourcekey="rbType2" Text="Percentage Off" runat="server" />:&nbsp;
            </td>
            <td>
                <asp:TextBox ID="txtType2" runat="server"></asp:TextBox> % 
            </td>
        </tr>
        <tr>
            <td>
                <asp:RadioButton GroupName="Type" ID="rbType3" meta:resourcekey="rbType3" Text="Amount Off" runat="server" />:&nbsp;
            </td>
            <td>
                <asp:TextBox ID="txtType3" runat="server"></asp:TextBox>
                (<asp:Label ID="lblCurrencySymbol" runat="server" Text=""></asp:Label>)
            </td>
        </tr>
        </table>
      
      </td>
    </tr> 
    <tr>
      <td><%=GetLocalResourceObject("Product")%></td><td>:</td>
      <td>
        <asp:RadioButton GroupName="Product" ID="rbProduct1" Checked ="true" meta:resourcekey="rbProduct1" Text="All Items" runat="server" />
      </td><td></td>
    </tr>
    <tr>
      <td colspan="2"></td>
      <td><asp:RadioButton GroupName="Product" ID="rbProduct2" meta:resourcekey="rbProduct2" Text="Item #" runat="server" /></td>
      <td> : <asp:TextBox ID="txtProduct2" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
      <td><%=GetLocalResourceObject("Min Purchase")%></td><td>:</td>
      <td>
          <asp:TextBox ID="txtMin" runat="server"></asp:TextBox>
      </td><td></td>
    </tr>
    <tr>
      <td><%=GetLocalResourceObject("Expiration Date")%></td><td>:</td>
      <td colspan="2">
          <asp:TextBox ID="txtExp" runat="server"></asp:TextBox> <i>(yyyy/mm/dd)</i>
      </td>
    </tr>
    <tr>
      <td><%=GetLocalResourceObject("Coupon Code")%></td><td>:</td>
      <td>
          <asp:TextBox ID="txtCode" runat="server"></asp:TextBox>
      </td><td></td>
    </tr>
    <tr>
      <td colspan="4">
          <br /><asp:Button ID="btnSave" runat="server" meta:resourcekey="btnSave" Text=" Create Coupon " OnClick="btnSave_Click" />
      </td>
    </tr>
</table>
</asp:Panel>





