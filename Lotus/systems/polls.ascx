<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelPolls.Visible = False
            panelPollInfo.visible=False
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
    
    Protected Sub grvPolls_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
       
        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim nPollId As Integer = grvPolls.DataKeys.Item(index).Value
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand
        Dim reader As SqlDataReader
        oCmd.CommandText = "SELECT question FROM polls WHERE [poll_id] = @poll_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int, 4).Value = nPollId
        
        oConn.Open()
        oCmd.Connection = oConn
        reader = oCmd.ExecuteReader()
        If reader.Read() Then
            txtQestion.Text = reader("question")
            sdsPollAnswer.SelectParameters(0).DefaultValue = nPollId
            sdsPollAnswer.ConnectionString = sConn
        End If
        reader.Close()
        oConn.Close()
        
        panelPollInfo.Visible = True
        panelPolls.Visible = False
    End Sub

    Protected Sub grvPolls_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grvPolls.RowDeleting
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
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
        
        grvPolls.DataBind()
        
        panelPollInfo.Visible = False
        panelPolls.Visible = True
    End Sub

    Protected Sub grvPolls_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvPolls.Rows.Count - 1
            CType(grvPolls.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
    
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
        
        grvPolls.DataBind()
    End Sub
    
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand
        Dim i As Integer = 0

        oCmd.CommandText = "UPDATE [poll_answers] SET [answer] = @answer WHERE [poll_answer_id] = @poll_answer_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@answer", SqlDbType.NText)
        oCmd.Parameters.Add("@poll_answer_id", SqlDbType.Int)

        oConn.Open()
        oCmd.Connection = oConn
        For i = 0 To 9
            If CType(grvAnswer.Rows(i).Cells(0).Controls(1), TextBox).Text = "" Then
                oCmd.Parameters.Item("@answer").SqlValue = System.DBNull.Value
            Else
                oCmd.Parameters.Item("@answer").SqlValue = CType(grvAnswer.Rows(i).Cells(0).Controls(1), TextBox).Text
            End If

            oCmd.Parameters.Item("@poll_answer_id").SqlValue = grvAnswer.DataKeys.Item(i).Value
            oCmd.ExecuteNonQuery()
            oCmd.Dispose()
        Next

        oCmd.CommandText = "UPDATE [polls] SET [question]=@question, root_id=" & Me.RootID & " WHERE [poll_id] = @poll_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@question", SqlDbType.NVarChar).Value = txtQestion.Text
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int).Value = sdsPollAnswer.SelectParameters(0).DefaultValue

        oCmd.ExecuteNonQuery()
        oCmd.Dispose()

        oConn.Close()
        
        lblStatus.Text = GetLocalResourceObject("SavedSuccessfully")
        
        panelPollInfo.Visible = True
        panelPolls.Visible = False
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        grvPolls.DataBind()
        
        panelPollInfo.Visible = False
        panelPolls.Visible = True
    End Sub
 
    Protected Sub grvPolls_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim addButton As LinkButton = CType(e.Row.Cells(1).Controls(0), LinkButton)
            addButton.CommandArgument = e.Row.RowIndex.ToString()
        End If
    End Sub
</script>

<asp:Panel ID="panelLogin" meta:resourcekey="Login1" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelPolls" runat="server" Visible="false" >


<asp:GridView ID="grvPolls" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
   GridLines=None AutoGenerateColumns="False" AllowPaging="True"  
   DataKeyNames="poll_id" DataSourceID="sdsPolls" OnPreRender="grvPolls_PreRender" OnRowCommand="grvPolls_RowCommand" OnRowCreated="grvPolls_RowCreated">
       <Columns>
        <asp:BoundField DataField="question" meta:resourcekey="lblQuestions" HeaderText="Questions" SortExpression="question" >
            <HeaderStyle HorizontalAlign="Left" />
        </asp:BoundField>
        <asp:buttonfield buttontype="Link" meta:resourcekey="cmdAnswers" commandname="cmdAnswers" text="Answers"/>
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

</asp:Panel>

<asp:Panel ID="panelPollInfo" runat="server" Visible="false" >

   <asp:Label ID="lblQuestion" meta:resourcekey="lblQuestion" runat="server" Text="Question:" Font-Bold="true"></asp:Label>
   &nbsp;&nbsp;<asp:TextBox ID="txtQestion" runat="server" Width="300"></asp:TextBox> <br /><br />

    <asp:GridView ID="grvAnswer" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
       GridLines=None AutoGenerateColumns="False" AllowPaging="True" 
       DataSourceID="sdsPollAnswer" DataKeyNames="poll_answer_id"  >
           <Columns>
           <asp:TemplateField meta:resourcekey="lblAnswer" HeaderText="Answer">
           <ItemTemplate >
           <asp:TextBox ID="TextBox1" Text =<%# Eval ("answer","")%> Width="200" runat="server" >
           </asp:TextBox>
           </ItemTemplate>
           </asp:TemplateField>
           <asp:BoundField DataField="total" meta:resourcekey="lblTotal" ItemStyle-HorizontalAlign=Center HeaderText="Total" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:BoundField>
        </Columns>
        <HeaderStyle BackColor="#E7E7E7" ForeColor="#555555" HorizontalAlign="Left" />
        <AlternatingRowStyle BackColor="#F7F7F7" />
    </asp:GridView>
    
    <asp:SqlDataSource ID="sdsPollAnswer" runat="server" 
        SelectCommand="SELECT * FROM [poll_answers] WHERE ([poll_id] = @poll_id)" 
        UpdateCommand="UPDATE [poll_answers] SET [answer] = @answer WHERE [poll_answer_id] = @poll_answer_id"  > 
        <SelectParameters>
            <asp:Parameter Name="poll_id" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="answer" Type="String" />
            <asp:Parameter Name="poll_answer_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    
<br />
<asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
<asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="  Cancel  " />
<asp:Label ID="lblStatus" runat="server" Text="" Font-Bold=true></asp:Label> 
<br /><br />

</asp:Panel>
 

