<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">  
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsNothing(Request.QueryString("RetUrl")) Then
            btnBack.Visible = True
        Else
            btnBack.Visible = False
        End If
        
        Dim nTotal As Integer = 0
        Dim i As Integer = 0
        Dim w As Integer
        Dim wPercent As Integer

        Dim PollList As Collection = New Collection
        Dim PollAnswers As Collection = New Collection
        Dim PollTotalVoters As Collection = New Collection

        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        Dim sSQL As String
        
        Dim pollId As String
        Dim Pattern As String = "<(.|\n)*?>"
        pollId = Request.QueryString("pid").Replace("'", "")
        pollId = Regex.Replace(pollId, Pattern, String.Empty)
        sSQL = "SELECT * FROM polls " & _
        "INNER JOIN (SELECT * FROM poll_answers WHERE ((poll_answers.poll_id = @poll_id) AND (poll_answers.answer IS NOT NULL))) As pollsResult ON (polls.poll_id=pollsResult.poll_id)"
        oConn.Open()
        oCommand = New SqlCommand(sSQL, oConn)
        oCommand.Parameters.Add("@poll_id", SqlDbType.Int).Value = pollId
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            i += 1
            lblHeader.Text = oDataReader("question").ToString
            w = oDataReader("total")
            PollAnswers.Add(oDataReader("answer").ToString, i)
            PollTotalVoters.Add(w, i)
            nTotal += w
        End While
        oDataReader.Close()
        oCommand.Dispose()
        oConn.Close()

        Literal1.Text = ""
        Dim sBarRowClass As String = "barRow"
        For i = 1 To PollAnswers.Count
            w = PollTotalVoters(i).ToString
            If Not (nTotal = 0) Then
                wPercent = (w / nTotal) * 100
            Else
                wPercent = 0
            End If
            If w = 0 Then wPercent = 0
            
            If Not wPercent = 0 Then
                Literal1.Text += "<div class=""" & sBarRowClass & """ style=""padding:5px;"">" & PollAnswers(i).ToString & _
                    "<table cellpadding=""0"" cellspacing=""0"" style=""width:300px""><tr><td style=""width:20px;padding:3px;padding-left:0"">" & w & "</td><td style=""width:55px;padding:3px;text-align:right"">" & wPercent & "% </td>" & _
                    "<td style=""padding:3px;""><table class=""bar" & i & """ style=""width:" & wPercent & "%;""><tr><td style=""height:5px""></td></tr></table></td>" & _
                    "</tr></table></div>"
            Else
                Literal1.Text += "<div class=""" & sBarRowClass & """ style=""padding:5px;"">" & PollAnswers(i).ToString & _
                    "<table cellpadding=""0"" cellspacing=""0"" style=""width:300px""><tr><td style=""width:20px;padding:3px;padding-left:0"">" & w & "</td><td style=""width:55px;padding:3px;text-align:right"">" & wPercent & "% </td>" & _
                    "<td style=""padding:3px;""></td>" & _
                    "</tr></table></div>"
            End If
            
            If sBarRowClass = "barRow" Then
                sBarRowClass = "barRowAlternate"
            Else
                sBarRowClass = "barRow"
            End If

        Next
        lblTotal.Text = GetLocalResourceObject("total") & " " & nTotal.ToString
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Request.QueryString("RetUrl"))
    End Sub
</script>

<table cellpadding="0" cellspacing="0">
<tr>
    <td class="pollHeader">
    <asp:Label ID="lblHeader" runat="server"></asp:Label>
    </td>
</tr>
<tr>
    <td>
    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
    </td>
</tr>
</table>
<div style="margin:10px"></div>
<asp:Label ID="lblTotal" runat="server"></asp:Label>
<div style="margin:20px"></div>
<asp:Button ID="btnBack" runat="server" meta:resourcekey="btnBack" OnClick="btnBack_Click" />
