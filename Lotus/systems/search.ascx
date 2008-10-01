<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        SqlDataSource2.ConnectionString = sConn
        Dim sqlSearch As Search = New Search
        Dim sKeywords As String = ""
        Dim sUser As String = ""
        If Not Request.QueryString("q") = "" Then
            sKeywords = Server.UrlDecode(Request.QueryString("q"))
            sKeywords = Server.HtmlDecode(sKeywords)
            If Not IsNothing(GetUser()) Then
                sUser = GetUser.UserName
            End If

            'Search Site
            SqlDataSource2.SelectCommand = sqlSearch.GetSqlScript(Me.RootID, sKeywords, sUser, "site") 'sqlSearch.GetSqlScript(sKeywords, sUser, "site")
            dlSearchResult.DataBind()

            If (dlSearchResult.Rows.Count = 0) Then
                lblResult.Text = GetLocalResourceObject("Result1") & " - " & Server.HtmlEncode(sKeywords) & " - " & GetLocalResourceObject("Result2")
                lblResult.Visible = True
            End If

        End If
    End Sub

    Protected Sub dlSearchResult_index_change(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles dlSearchResult.PageIndexChanging
        dlSearchResult.DataBind()
    End Sub

    Function GetContent(ByVal sContent As String) As String
        Dim Pattern As String = "<(.|\n)*?>"
        Dim sResult As String
        Dim temp As String
        temp = Regex.Replace(sContent, Pattern, String.Empty)

        If temp.Length = 0 Then
            sResult = ""
        ElseIf temp.Length < 200 Then
            sResult = temp.Substring(0, temp.Length)
        Else
            sResult = temp.Substring(0, 200) & " ..."
        End If

        Return sResult
    End Function

</script>

<asp:Label ID="lblResult" runat="server" Visible="false"></asp:Label>

<asp:GridView ID="dlSearchResult" runat="server"  EnableTheming="false"
PageSize="10"
CellPadding="7" CellSpacing="3" PagerStyle-HorizontalAlign="right" 
PagerSettings-Position="TopAndBottom"
AutoGenerateColumns=false  ShowHeader="false" 
GridLines="None" EnableSortingAndPagingCallbacks="false" 
OnPageIndexChanging="dlSearchResult_index_change"  
DataSourceID="SqlDataSource2"
AllowPaging="true" Width="100%" >
<Columns>
<asp:TemplateField>
  <ItemTemplate>
    <div><a href="<%# Eval("file_name","" ) %>"><b><%#Eval("title", "")%></b></a></div>
    <div><%#GetContent(Eval("content_body", ""))%></div>
    <div><a href="<%# Eval("file_name","") %>"><%#"~/" & Eval("file_name","")%></a>&nbsp;&nbsp;<%#Eval("last_updated_date", "")%></div>
  </ItemTemplate>  
</asp:TemplateField>
 </Columns>
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource2" runat="server">
</asp:SqlDataSource>
