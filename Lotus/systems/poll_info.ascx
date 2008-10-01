<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsNothing(GetUser) Then
            Panel_Login.Visible = True
            Panel_Poll_info.Visible = False
        Else
            If (Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Or _
               Roles.IsUserInRole(GetUser.UserName.ToString(), "Polls Managers")) Then
                hidPollID.Value = Request.QueryString("PollID")
                Dim oConn As SqlConnection = New SqlConnection(sConn)
                Dim oCmd As SqlCommand = New SqlCommand
                Dim reader As SqlDataReader
                oCmd.CommandText = "SELECT question FROM polls WHERE [poll_id] = @poll_id"
                oCmd.CommandType = CommandType.Text
                oCmd.Parameters.Add("@poll_id", SqlDbType.Int, 4).Value = hidPollID.Value

                oConn.Open()
                oCmd.Connection = oConn
                reader = oCmd.ExecuteReader()
                Do While reader.Read()
                    txtQestion.Text = reader("question")
                    If txtQestion.Text = "" Then
                        Panel_Poll_info.Visible = False
                    Else
                        Panel_Poll_info.Visible = True
                        sdsPollAnswer.ConnectionString = sConn
                    End If
                Loop
                reader.Close()
                oConn.Close()
            End If
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
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
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int).Value = hidPollID.Value

        oCmd.ExecuteNonQuery()
        oCmd.Dispose()

        oConn.Close()
        Response.Redirect(Me.LinkWorkspacePolls)
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(Me.LinkWorkspacePolls)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="Panel_Login" runat="server" Visible="False">
   <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>
<asp:HiddenField ID="hidPollID" runat="server" />


<asp:Panel ID="Panel_Poll_info" runat="server" Visible="false" >

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
            <asp:ControlParameter ControlID="hidPollID" Name="poll_id" PropertyName="Value" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="answer" Type="String" />
            <asp:Parameter Name="poll_answer_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    
<br />
<asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
<asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="  Cancel  " />
<br /><br />

</asp:Panel>
 