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
            panelDownloads.Visible = True
            
            If Not Page.IsPostBack Then               
                Dim sSQL As String = "SELECT order_items.order_item_id, order_items.item_id, order_items.item_desc, pages_published.version, pages_published.file_attachment, " & _
                "pages_published.file_size, orders.order_date FROM orders INNER JOIN order_items ON orders.order_id = order_items.order_id INNER JOIN " & _
                "pages_published ON order_items.item_id = pages_published.page_id " & _
                "WHERE orders.status = 'VERIFIED' AND order_items.tangible = 0 AND orders.order_by = @order_by"
                sqlDS.ConnectionString = sConn
                sqlDS.SelectCommand = sSQL
                sqlDS.SelectParameters.Add("order_by", Me.UserName)
                GridView1.DataBind()
                
                If GridView1.Rows.Count > 0 Then
                    'email/order confirmed
                    'krn: sdh dicek berdasarkan order_by & order_id-nya (sesuai dgn logged-in user & query string oid)
                    Dim nOrderId As Integer = 0
                    If Not IsNothing(Request.QueryString("oid")) Then
                        nOrderId = CInt(Request.QueryString("oid"))
                    End If

                    Dim oCommand As SqlCommand
                    oCommand = New SqlCommand("UPDATE orders set download_status='CONFIRMED' where order_id=@order_id and order_by=@order_by and download_status is null")
                    oCommand.CommandType = CommandType.Text
                    oCommand.Parameters.Add("@order_id", SqlDbType.Int).Value = nOrderId
                    oCommand.Parameters.Add("@order_by", SqlDbType.NVarChar, 128).Value = Me.UserName
                    oConn.Open()
                    oCommand.Connection = oConn
                    oCommand.ExecuteNonQuery()
                    oConn.Close()
                End If
            End If

        End If
    End Sub
    
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
    
    Function GetFileUrl(ByVal nPageId As Integer, ByVal nVersion As Integer) As String
        Return "systems/file_download.aspx?pg=" & nPageId & "&ver=" & nVersion
    End Function
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelDownloads" runat="server">
    <asp:GridView ID="GridView1" DataSourceID="sqlDS" CellPadding="7" AutoGenerateColumns=false runat="server">
    <Columns>
    <asp:BoundField DataField="item_desc" meta:resourcekey="colItem" HeaderText="Items" />
    <asp:TemplateField meta:resourcekey="colPurchasedDate" HeaderText="Purchased Date" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right">
    <ItemTemplate>
    <%#FormatDateTime(Eval("order_date"), DateFormat.LongDate)%>
    </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="">
    <ItemTemplate>
    <a href="<%#GetFileUrl(Eval("item_id"), Eval("version"))%>"><%#GetLocalResourceObject("Download")%></a>
    </ItemTemplate>
    </asp:TemplateField>
    </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sqlDS" runat="server" >
    </asp:SqlDataSource>
</asp:Panel>
