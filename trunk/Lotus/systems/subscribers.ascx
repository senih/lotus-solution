<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="system.IO" %>

<script runat="server">  
  Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
  Private oConn As New SqlConnection(sConn)
  Private iIndex As Integer
  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
    panelLogin.Visible = True
    panelSubscribers.Visible = False
    If Not (IsNothing(GetUser())) Then
      If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators")) Then
        gvSubscribers.DataSource = GetCategories(Me.RootID)
        gvSubscribers.DataBind()
        panelLogin.Visible = False
        panelSubscribers.Visible = True
      End If
    End If
    txtFailed.Text = ""
    idFailed.Visible = False
  End Sub

  Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
    Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
  End Sub

  Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
    Response.Redirect(HttpContext.Current.Items("_path"))
  End Sub

  Protected Sub gvSubscribers_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    If Not Me.IsUserLoggedIn Then Exit Sub

    Dim oCmd As SqlCommand
    Dim reader As SqlDataReader
    oConn.Open()
    
    Dim sb As StringBuilder = New StringBuilder
    sb.Append("id,name,email,date_registered")
    sb.AppendLine()
    
    oCmd = New SqlCommand
    oCmd.Connection = oConn
    oCmd.CommandText = "SELECT * FROM newsletters_subscribers WHERE status=1 and unsubscribe=0 and category_id=" & gvSubscribers.SelectedDataKey.Value.ToString
    oCmd.CommandType = CommandType.Text
    reader = oCmd.ExecuteReader
    While reader.Read
      sb.Append(reader("id").ToString() & "," & _
          reader("name").ToString() & "," & _
          reader("email").ToString() & "," & _
          reader("date_registered").ToString())
      sb.AppendLine()
    End While
    reader.Close()
    oCmd.Dispose()
    oConn.Close()

    Response.ContentType = "Application/x-msexcel"
    Response.AddHeader("content-disposition", "attachment;filename=""data.csv""")
    Response.Write(sb.ToString)
    Response.End()
  End Sub

  Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
    If Not Me.IsUserLoggedIn Then Exit Sub
    
    lblSearch.Text = ""
    Dim sqlDS1 As SqlDataSource = New SqlDataSource
    sqlDS1.ConnectionString = sConn

    If dropSearchUser.SelectedValue = "Name" Then
      If txtName.Text = "" Then
        lblSearch.Text = GetLocalResourceObject("UserNameRequired") '"User Name required."
      Else
        Dim sUserName As String = txtName.Text.ToLower
        sqlDS1.SelectCommand = "SELECT name, email  FROM newsletters_subscribers " & _
                "where(newsletters_subscribers.unsubscribe = 0 " & _
          " and ( name like '%" & sUserName & "%' or name like '%" & sUserName & "' or name like '" & sUserName & "%' or name like '" & sUserName & "'" & _
          " )) GROUP BY email,name "
        Users.DataSource = sqlDS1
        Users.DataBind()
    
      End If
    Else
      If txtName.Text = "" Then
        lblSearch.Text = GetLocalResourceObject("EmailRequired") '"Email required."
      Else
        Dim sEmail As String = txtName.Text.ToLower
        sqlDS1.SelectCommand = "SELECT name, email  FROM newsletters_subscribers " & _
        "where(newsletters_subscribers.unsubscribe = 0 " & _
          " and ( email like '%" & sEmail & "%' or email like '%" & sEmail & "' or email like '" & sEmail & "%' or email like '" & sEmail & "'" & _
          " )) GROUP BY email,name "
        Users.DataSource = sqlDS1
        Users.DataBind()
      End If
    End If
  End Sub

  Protected Sub Users_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
    Dim i As Integer
    Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
    For i = 0 To Users.Rows.Count - 1
      CType(Users.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
    Next
  End Sub

  Protected Sub Users_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles Users.RowDeleting
    If Not Me.IsUserLoggedIn Then Exit Sub
    Dim oCmd As SqlCommand
    oConn.Open()
    
    oCmd = New SqlCommand
    oCmd.Connection = oConn
    oCmd.CommandText = "DELETE newsletters_subscribers WHERE email= @email"
    oCmd.Parameters.Add("email", SqlDbType.NVarChar).Value = Users.DataKeys.Item(e.RowIndex).Value.ToString
    oCmd.CommandType = CommandType.Text
    oCmd.ExecuteNonQuery()
    oCmd.Dispose()
    oConn.Close()
    btnListAllUsers_Click(Nothing, Nothing)
    gvSubscribers.DataSource = GetCategories(Me.RootID)
    gvSubscribers.DataBind()
  End Sub

  Protected Sub Users_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles Users.PageIndexChanging
    iIndex = e.NewPageIndex()
    Users.PageIndex = iIndex
    btnListAllUsers_Click(Nothing, Nothing)
  End Sub

  Protected Sub Users_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    Users.PageIndex = iIndex
  End Sub

  Protected Sub btnListAllUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnListAllUsers.Click
    If Not Me.IsUserLoggedIn Then Exit Sub
    Dim sqlDS1 As SqlDataSource = New SqlDataSource
    sqlDS1.ConnectionString = sConn

    sqlDS1.SelectCommand = "SELECT name, email  FROM newsletters_subscribers " & _
                "where newsletters_subscribers.unsubscribe = 0 GROUP BY email,name "
    txtName.Text = ""
    Users.DataSource = sqlDS1
    Users.DataBind()
    lblSearch.Text = ""
  End Sub

  Protected Sub Users_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
    If e.Row.RowType = DataControlRowType.DataRow Then
      Dim ds As SqlDataSource = CType(e.Row.FindControl("SqlDataSource2"), SqlDataSource)
      ds.ConnectionString = sConn
      ds.SelectCommand = "SELECT newsletters_subscribers.*,nc.category " & _
        "FROM newsletters_subscribers " & _
        "inner join " & _
        "(Select * From newsletters_categories)as nc on (nc.category_id=newsletters_subscribers.category_id) " & _
        "WHERE ([email] = @email) and unsubscribe = 0"
      ds.SelectParameters("email").DefaultValue = Users.DataKeys(e.Row.RowIndex).Value
    End If
  End Sub

  Protected Sub btnImportUser_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    If Not Me.IsUserLoggedIn Then Exit Sub
        
    Dim x As Integer
    Dim item As String
    Dim Name As String
    Dim Email As String
    'Dim sCategoryId As Integer
        
    Dim nUser As Integer = 0
    'Dim nList As Integer = 0
    Dim nError As Integer = 0
    
    Dim sr As StreamReader
    Dim sFailed As String = ""
    Dim colSubscriberInfo As Subscription = New Subscription

    sr = New StreamReader(Fileupload1.PostedFile.InputStream, System.Text.Encoding.Default)
    Dim line As String = ""
    While Not line Is Nothing
      line = sr.ReadLine()
      If Not line = "" Then
        x = 0
        Email = ""
        Name = ""
        For Each item In line.Split(",")
          Select Case x
            Case 0
              Name = item
            Case 1
              Email = item
          End Select
          x += 1
        Next
        If Email = "" Then
          nError += 1
          sFailed += line & GetLocalResourceObject("reqEmail") & vbCrLf
        Else
          Dim nCount As Integer
          For nCount = 0 To lstList.Items.Count - 1
            If lstList.Items(nCount).Selected Then
              colSubscriberInfo = CheckSubscription(Email, lstList.Items(nCount).Value)
              If IsNothing(colSubscriberInfo) Then
                AddSubscriber(Name, Email, lstList.Items(nCount).Value, False, True)
                nUser += 1
              Else
                sFailed += line & " [" & lstList.Items(nCount).Text & "] " & GetLocalResourceObject("dupEmail") & vbCrLf
                nError += 1
              End If
                
            End If
          Next
                    
        End If
            
      End If
    End While
    sr.Close()
    lblNote.Text = nUser & " " & GetLocalResourceObject("imported") & ", " & nError & " " & GetLocalResourceObject("failed") & "."
        
    Fileupload1.PostedFile.InputStream.Close()
    panelImport.Visible = True
    panelSubscribers.Visible = False
        lstList.DataSource = GetCategoriesByRootID(Me.RootID)
    lstList.DataBind()
    
    If nError > 0 Then
      idFailed.Visible = True
      txtFailed.Text = sFailed
    Else
      idFailed.Visible = False
      txtFailed.Text = ""
    End If
  End Sub

  Protected Sub lnkImport_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    panelImport.Visible = True
    panelSubscribers.Visible = False
        lstList.DataSource = GetCategoriesByRootID(Me.RootID)
    lstList.DataBind()
  End Sub

  Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    panelImport.Visible = False
    panelSubscribers.Visible = True
  End Sub
</script>

<asp:Panel ID="panelLogin" runat="server">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelSubscribers" runat="server" >
    <asp:LinkButton ID="lnkImport" meta:resourcekey="lnkImport" runat="server" Text="Import Subscribers" OnClick="lnkImport_Click"></asp:LinkButton>
<p></p>

<asp:Panel ID="DataUser" runat="server" Visible="true">
    <table>
    <tr>
        <td align="left" nowrap="nowrap">
            <asp:Label ID="lblSearchUser" meta:resourcekey="lblSearchUser" runat="server" Text="Search User"></asp:Label></td>
        <td align="left" style="width: 3px">
            :</td>
        <td><asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="lblBy" meta:resourcekey="lblBy" runat="server" Text="By"></asp:Label></td>
        <td style="width: 3px">
            :</td>
        <td>
            <asp:DropDownList ID="dropSearchUser"  runat="server">
                <asp:ListItem meta:resourcekey="liName" Value="Name" Text="Name"></asp:ListItem>
                <asp:ListItem meta:resourcekey="liEmail" Value="Email" Text="Email"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td></td>
        <td style="width: 3px">
        </td>
        <td>
            <asp:Label ID="lblSearch" runat="server" ForeColor=red></asp:Label>
        </td>
    </tr>
    <tr>
        <td></td>
        <td style="width: 3px">
        </td>
        <td style="text-align: right" nowrap=nowrap>
            <asp:Button ID="btnSearch" meta:resourcekey="btnSearch" CausesValidation=False  runat=server Text="Search" />
            <asp:Button ID="btnListAllUsers" meta:resourcekey="btnListAllUsers" runat="server" Text="List All Users" CausesValidation=false />                
        </td>
    </table>
    <br />
    <asp:GridView ID="Users" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  
    CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"  RowStyle-VerticalAlign="Top"
    DataKeyNames="email" AllowPaging="True" AutoGenerateColumns="False" 
    AllowSorting="False" OnPreRender="Users_PreRender"  
    OnPageIndexChanged="Users_PageIndexChanged" OnRowDataBound="Users_RowDataBound">
            <Columns >
                <asp:BoundField DataField="name" HeaderText="Name" meta:resourcekey="name" SortExpression="name" HeaderStyle-Wrap="False" />
                <asp:BoundField DataField="email" HeaderText="Email" meta:resourcekey="email" SortExpression="email" />
                <asp:TemplateField HeaderText="Category" meta:resourcekey="category">
                <ItemTemplate>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="Users" Name="email" PropertyName="SelectedValue" Type="String" />
                      </SelectParameters>
                     </asp:SqlDataSource>
                 
                    <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource2">
                      <ItemTemplate>
                        - <%#Eval("category", "")%><br />
                      </ItemTemplate>
                    </asp:Repeater>
            
                </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField DeleteText="Delete" meta:resourcekey="Command" ShowDeleteButton="true"  ButtonType="link" />
            </Columns>
    </asp:GridView>
    <br />
</asp:Panel>

<asp:GridView ID="gvSubscribers" AlternatingRowStyle-BackColor="#f6f7f8" runat="server"
      HeaderStyle-BackColor="#d6d7d8" CellPadding=7  ShowHeader="true"
      HeaderStyle-HorizontalAlign=Left GridLines=None AutoGenerateColumns="False" 
      AllowPaging="True" AllowSorting="false" DataKeyNames="CategoryId" OnSelectedIndexChanged="gvSubscribers_SelectedIndexChanged">
<Columns>
  <asp:BoundField DataField="Title" HeaderText="List" meta:resourcekey="Title"/>
  <asp:BoundField DataField="Count" HeaderText="Subscribers" meta:resourcekey="Count"/>
  <asp:CommandField meta:resourcekey="DownloadCsv" SelectText="Download CSV" ShowSelectButton="true" />
</Columns>
</asp:GridView>
</asp:Panel>

<asp:Panel ID="panelImport" runat="server" style="width:100%" Visible="false" >
<table cellpadding="3" cellspacing="0">
<tr>
    <td style="padding-left:0px;white-space:nowrap"><asp:Label ID="lblImportFromFile" meta:resourcekey="lblImportFromFile" runat="server" Text="Import from a file"></asp:Label></td>
    <td>:&nbsp;</td>
    <td style="width:100%">
    <asp:fileupload ID="Fileupload1" runat="server" ></asp:fileupload>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="Fileupload1" runat="server" ErrorMessage="*" ValidationGroup="import"></asp:RequiredFieldValidator>
        <asp:Label ID="lblFormatInfo" meta:resourcekey="lblFormatInfo" Font-Italic="true" runat="server" Text="(Format: Name,Email)"></asp:Label>
    </td>
</tr>
<tr>
    <td style="padding-left:0px;white-space:nowrap"><asp:Label ID="lbllist" meta:resourcekey="lbllist" runat="server" Text="Select list(s) for the users"></asp:Label></td>
    <td>:&nbsp;</td>
    <td>
    <asp:ListBox ID="lstList" runat="server"  Rows="5" SelectionMode="Multiple" 
           Width="225" DataTextField="category" DataValueField="category_id"></asp:ListBox>
    <asp:RequiredFieldValidator ID="rfv2" ControlToValidate="lstList" runat="server" ErrorMessage="*" ValidationGroup="import"></asp:RequiredFieldValidator>

    </td>
</tr>
<tr>
    <td colspan="3" style="height:5px"></td>
</tr>
<tr>
    <td colspan="3" style="padding-left:0px;">
    <asp:Button ID="btnImportUser" runat="server" meta:resourcekey="btnImportUser" Text=" Import "  ValidationGroup="import" OnClick="btnImportUser_Click" /> 
    <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Back " CausesValidation="false"  OnClick="btnCancel_Click" />
    <asp:Label ID="lblNote" Font-Bold="true" runat="server" Text=""></asp:Label>   
    </td>
</tr>
<tr runat="server" id="idFailed" visible="false">
    <td colspan="3" style="height:5px">
    <hr />
    <asp:Label ID="lblFailed" runat="server" Text="Failed:" meta:resourcekey="lblFailed" ></asp:Label>
    <div style="margin:5px"></div>
    <asp:TextBox ID="txtFailed" Height="100px" Wrap="false" Width="350px" TextMode="MultiLine" runat="server"></asp:TextBox>
    </td>
</tr>
</table>
 
</asp:Panel>
