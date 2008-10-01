<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            Panel_Login.Visible = True
            panelPolls.Visible = False
        Else
            If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Or _
               Roles.IsUserInRole(GetUser.UserName.ToString(), "Polls Managers")) Then
                sdsPolls.ConnectionString = sConn

                sdsPolls.SelectCommand = "SELECT * FROM [polls] where root_id=@root_id or root_id is null"
                sdsPolls.SelectParameters(0).DefaultValue = Me.RootID
                sdsPolls.DeleteCommand = "DELETE FROM [polls] WHERE [poll_id] = @poll_id"

                panelPolls.Visible = True
        
            End If
        End If
    End Sub

    Protected Sub grvPolls_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grvPolls.SelectedIndexChanged
        Response.Redirect(Me.LinkWorkspacePollPages & "?PollID=" & grvPolls.SelectedValue)
    End Sub

    Protected Sub grvPolls_editing(ByVal sender As Object, ByVal e As GridViewEditEventArgs) Handles grvPolls.RowEditing
        Response.Redirect(Me.LinkWorkspacePollInfo & "?PollID=" & grvPolls.DataKeys.Item(e.NewEditIndex).Value)
    End Sub

    Protected Sub grvPolls_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grvPolls.RowDeleting
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand

        oCmd.CommandText = "DELETE FROM [poll_answers] WHERE [poll_id] = @poll_id"
        oCmd.CommandType = CommandType.Text
    oCmd.Parameters.Add("@poll_id", SqlDbType.Int, 4).Value = grvPolls.DataKeys.Item(e.RowIndex).Value

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oCmd.CommandText = "DELETE FROM [page_modules] WHERE ((module_data = @poll_id) AND (module_file = 'poll.ascx'))"
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
    oConn.Close()
    sdsPolls.DeleteParameters.Item("poll_id").DefaultValue = grvPolls.DataKeys.Item(e.RowIndex).Value
    End Sub

    Protected Sub grvPolls_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvPolls.Rows.Count - 1
            CType(grvPolls.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand
        Dim i As Integer

        oCmd.CommandText = "INSERT INTO [polls] ([question],[root_id]) VALUES (@question,@root_id) select @@Identity as new_poll_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@question", SqlDbType.NVarChar).Value = txtNewQuestion.Text
        oCmd.Parameters.Add("@root_id", SqlDbType.NVarChar).Value = Me.RootID

        oConn.Open()
        oCmd.Connection = oConn
        'Get Newly Created Poll ID
        Dim nNewPollId As Long = 0
        Dim rowsAffected As Integer
        Dim dataReader As SqlDataReader = oCmd.ExecuteReader()
        While dataReader.Read
            nNewPollId = dataReader("new_poll_id")
            rowsAffected = 1
        End While
        dataReader.Close()

        oCmd.CommandText = "INSERT INTO [poll_answers] ([poll_id], [answer] , [total] ) VALUES (@poll_id, @answer, @total)"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int).Value = nNewPollId
        oCmd.Parameters.Add("@answer", SqlDbType.NText).Value = System.DBNull.Value
        oCmd.Parameters.Add("@total", SqlDbType.VarChar).Value = 0

        For i = 0 To 9
            oCmd.ExecuteNonQuery()
        Next
        oCmd.Dispose()
        oConn.Close()

        Response.Redirect(Me.LinkWorkspacePolls)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="Panel_Login" meta:resourcekey="Login1" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelPolls" runat="server" Visible="false" >
<table>
<tr>
<td>
    <asp:GridView ID="grvPolls" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
       GridLines=None AutoGenerateColumns="False" AllowPaging="True"  
       DataKeyNames="poll_id" DataSourceID="sdsPolls" OnPreRender="grvPolls_PreRender">
           <Columns>
            <asp:BoundField DataField="question" meta:resourcekey="lblQuestions" HeaderText="Questions" SortExpression="question" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:BoundField>
            <asp:CommandField meta:resourcekey="cmdEdit" EditText="Answers" ShowEditButton=True >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:CommandField>
            <asp:CommandField ShowSelectButton="True" meta:resourcekey="cmdEmbed" ItemStyle-Wrap="false" SelectText="Embed Poll" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:CommandField>
            <asp:CommandField meta:resourcekey="cmdDelete" DeleteText="Delete" ShowDeleteButton=True >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:CommandField>

        </Columns>
    </asp:GridView>
    
    <asp:SqlDataSource ID="sdsPolls" runat="server" > 
    <SelectParameters>
     <asp:Parameter Name="root_id" Type="Int16"  />
    </SelectParameters>
    <DeleteParameters>
     <asp:Parameter Name="poll_id" Type="Int16" />
    </DeleteParameters>
    </asp:SqlDataSource>
</td>
</tr>
<tr>
<td style="padding-top:7px">
  <asp:Label ID="lblSucess" runat="server" Text="" Font-Bold=true></asp:Label> 
</td>
</tr>
</table>

<div style="border:#E0E0E0 1px solid;padding:10px;width:380px;margin-top:10px">
<table>
<tr>
    <td colspan="3" style="padding-bottom:7px">
        <asp:Label ID="lblAddNew" meta:resourcekey="lblAddNew" Font-Bold="true" runat="server" Text="Add New"></asp:Label>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblNewQuestion" meta:resourcekey="lblNewQuestion" runat="server" Text="Question"></asp:Label>      
    </td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtNewQuestion" runat="server" Width="300"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="*" ControlToValidate="txtNewQuestion" ValidationGroup="Poll"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td colspan="3" style="padding-top:7px">
        <asp:Button ID="btnCreate" meta:resourcekey="btnCreate" runat="server" Text=" Create " ValidationGroup="Poll"/>
    </td>
</tr>
</table>
</div>
<br /><br />
</asp:Panel>

