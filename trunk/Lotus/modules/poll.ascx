<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        rblPollAnswers.ValidationGroup = "Poll" & Me.ClientID
        rfvPollAnswers.ValidationGroup = "Poll" & Me.ClientID
        btnSubmit.ValidationGroup = "Poll" & Me.ClientID

        Dim oCmd As SqlCommand = New SqlCommand
        Dim oReader As SqlDataReader
        oConn.Open()
        oCmd.Connection = oConn

        oCmd.CommandText = "SELECT * FROM [polls] WHERE [poll_id] = @poll_id "
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int, 4).Value = Me.ModuleData
        oReader = oCmd.ExecuteReader()
        If oReader.Read Then
            lblQuestion.Text = oReader("question")
        End If
        oReader.Close()
        sdsPollAnswers.ConnectionString = sConn
        sdsPollAnswers.SelectParameters.Item(0).DefaultValue = Me.ModuleData
        sdsPollAnswers.SelectCommand = "SELECT * FROM [poll_answers] WHERE (([poll_id] = @poll_id) AND ([answer] IS NOT NULL))"
        oConn.Close()
        
        lnkResults.NavigateUrl = "~/" & Me.LinkPollResults & "?pid=" & Me.ModuleData & "&RetUrl=" & HttpContext.Current.Items("_page")
    End Sub

    Protected Sub btnsubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        If rblPollAnswers.Items.Count = 0 Then Exit Sub
        Dim oCmd As SqlCommand = New SqlCommand
        Dim oReader As SqlDataReader
        Dim iTotal As Integer = 0
        Dim sIP As String = HttpContext.Current.Request.UserHostAddress
        Dim bInsert As Boolean = True
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM poll_voters WHERE poll_id=@poll_id AND ip_voter=@ip"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@poll_id", SqlDbType.Int, 4).Value = Me.ModuleData
        oCmd.Parameters.Add("@ip", SqlDbType.NVarChar).Value = sIP
        oReader = oCmd.ExecuteReader()
        If oReader.Read() Then
            bInsert = False
        End If
        oReader.Close()

        If bInsert Then
            oCmd.CommandText = "Insert INTO poll_voters (poll_id,ip_voter) VALUES (@poll_id,@ip)"
            oCmd.ExecuteNonQuery()
            oCmd.Dispose()

            oCmd.CommandText = "SELECT [total] FROM [poll_answers] WHERE [poll_answer_id] = @poll_answer_id"
            oCmd.CommandType = CommandType.Text
            oCmd.Parameters.Add("@poll_answer_id", SqlDbType.Int, 4).Value = rblPollAnswers.SelectedValue
            oReader = oCmd.ExecuteReader()
            If oReader.Read Then
                iTotal = oReader("total")
            End If
            oReader.Close()

            oCmd.CommandText = "UPDATE [poll_answers] SET [total] = @total WHERE [poll_answer_id] = @poll_answer_id"
            oCmd.CommandType = CommandType.Text
            oCmd.Parameters.Add("@total", SqlDbType.Int, 16).Value = iTotal + 1
            oCmd.ExecuteNonQuery()
            oCmd.Dispose()
        End If
        oConn.Close()
            
        Response.Redirect(Me.LinkPollResults & "?pid=" & Me.ModuleData & "&RetUrl=" & HttpContext.Current.Items("_page"))
    End Sub

</script>

<asp:Panel ID="Panel_Polls" runat="server" DefaultButton="btnSubmit" CssClass="poll">

<table cellpadding="0" cellspacing="0" class="boxPoll">
<tr>
<td class="boxHeaderPoll">
    <asp:Label ID="lblQuestion" runat="server" Text=""></asp:Label>
    <asp:RequiredFieldValidator ID="rfvPollAnswers" runat="server" ErrorMessage="" ControlToValidate="rblPollAnswers" ValidationGroup="Polls"></asp:RequiredFieldValidator>
</td>
</tr>
<tr>
<td class="boxFormPoll">
    <asp:RadioButtonList ID="rblPollAnswers" runat="server" 
    DataSourceID="sdsPollAnswers" ValidationGroup="Polls" 
    DataTextField="answer" CellPadding="0" CellSpacing="0" DataValueField="poll_answer_id">
    </asp:RadioButtonList>
</td>
</tr>
<tr>
<td class="boxFooterPoll">
    <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" CssClass="btnPoll" runat="server" Text=" Submit " ValidationGroup="Polls" />
    <asp:HyperLink ID="lnkResults" meta:resourcekey="lnkResults" runat="server">Results</asp:HyperLink>
</td>
</tr>
</table>

<asp:SqlDataSource ID="sdsPollAnswers" runat="server">
    <SelectParameters>
        <asp:Parameter Name="poll_id" Type="Int32" />
    </SelectParameters>
 </asp:SqlDataSource>
    
</asp:Panel>