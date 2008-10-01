<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Globalization"%>
<%@ Import Namespace="System.Threading"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Public Description As String
    Public Title As String
    Public Link As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sUrl As String

        If Me.ModuleData = "" Then
            'sUrl = GetAppFullPath() & "systems/rss.aspx?pg=53" 'specify directly

            '*** Get news/listing page under home ***
            Dim sPageId As String = ""
            Dim oConn As SqlConnection
            Dim oCommand As SqlCommand
            Dim oDataReader As SqlDataReader
            oConn = New SqlConnection(sConn)
            oConn.Open()
            oCommand = New SqlCommand("SELECT top 1 * from pages_published where page_type=4 And parent_id=" & Me.RootID, oConn)
            oDataReader = oCommand.ExecuteReader()
            If oDataReader.Read() Then
                sPageId = oDataReader("page_id").ToString()
            End If
            oDataReader.Close()
            If Not sPageId = "" Then
                sUrl = GetAppFullPath() & "systems/rss.aspx?pg=" & sPageId & "&c=" & Thread.CurrentThread.CurrentCulture.Name
            Else
                Exit Sub
            End If
            '****************************************
        Else
            sUrl = Me.ModuleData
        End If

        Dim httpRss As HttpWebRequest = DirectCast(WebRequest.Create(sUrl), HttpWebRequest)

        Dim dsRss, dsTitle As New XmlDataSource

        dsRss.DataFile = httpRss.RequestUri.ToString
        'dsRss.XPath = "rss/channel/item"
        dsRss.XPath = "rss/channel/item [position()<=5]"

        dsTitle.DataFile = httpRss.RequestUri.ToString
        'dsTitle.XPath = "rss/channel"
        dsTitle.XPath = "rss/channel [position()<=5]"
        'Dim dsRss As DataSet = New DataSet
        'Try
        '  MsgBox("test")
        '  dsRss.ReadXml(httpRss.GetResponse.GetResponseStream)

        '  Dim indxTitle As Integer = dsRss.Tables(1).Columns("title").Ordinal
        '  Title = dsRss.Tables(1).Rows(0).ItemArray.GetValue(indxTitle).ToString

        '  Dim indxDesc As Integer = dsRss.Tables(1).Columns("description").Ordinal
        '  Description = dsRss.Tables(1).Rows(0).ItemArray.GetValue(indxDesc).ToString
  
        '  Dim indxLink As Integer = dsRss.Tables(1).Columns("link").Ordinal
        '  Link = dsRss.Tables(1).Rows(0).ItemArray.GetValue(indxLink).ToString
  
        '  Dim dateLink As Integer = dsRss.Tables(1).Columns("pubDate").Ordinal
        '  Link = dsRss.Tables(1).Rows(0).ItemArray.GetValue(indxLink).ToString

        'Catch ex As Exception
        '  MsgBox(ex.ToString)
        '  Exit Sub
        'End Try

        'MsgBox(dsRss.Tables(3).Columns(1).ToString)
        'If (dsRss.Tables.Count = 3) Then
        repeaterRss.DataSource = dsRss
        repeaterRss.DataBind()

        rssTitle.DataSource = dsTitle
        rssTitle.DataBind()
        rssMore.DataSource = dsTitle
        rssMore.DataBind()
        'Else
        '  panelNews.Visible = False
        'End If

    End Sub

    Private Function GetAppFullPath() As String
        'returns:
        ' http://localhost/ 
        ' http://localhost/apppath/
        '(Selalu ada "/" di akhir)
        Dim sPort As String = Request.ServerVariables("SERVER_PORT")
        If IsNothing(sPort) Or sPort = "80" Or sPort = "443" Then
            sPort = ""
        Else
            sPort = ":" & sPort
        End If

        Dim sProtocol As String = Request.ServerVariables("SERVER_PORT_SECURE")
        If IsNothing(sProtocol) Or sProtocol = "0" Then
            sProtocol = "http://"
        Else
            sProtocol = "https://"
        End If

        If Request.ApplicationPath = "/" Then
            'App is installed in root
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath
        Else
            'App is installed in virtual directory
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath & "/"
        End If
    End Function
</script>

<asp:Panel ID="panelNews" runat="server">

<table cellpadding="0" cellspacing="0" class="boxNewsFeed">
<tr>
<td class="boxHeaderNewsFeed">
    <asp:DataList ID="rssTitle" Width="100%" runat="server">
    <ItemTemplate>
        <div class="boxTitleNewsFeed"><%#XPath("lastBuildDate")%></div>
        <div class="boxTitleNewsFeed"><%#XPath("title")%></div>
        <div class="boxTitleNewsFeed"><%#XPath("description")%></div>
    </ItemTemplate>
    </asp:DataList>    
</td>
</tr>
<tr>
<td class="boxContentNewsFeed">
  <asp:DataList ID="repeaterRss" Width="100%" SkinID="gridNewsFeedBox" runat="server">
    <ItemTemplate>
      <div><%#XPath("pubDate")%></div>
      <b><%#XPath("title")%></b>
      <div><%#XPath("description")%>
      <a href="<%#XPath("link")%>"><asp:Literal ID="litMore" meta:resourcekey="litMore" runat="server" Text="More"></asp:Literal></a>
      </div><br />
    </ItemTemplate>
  </asp:DataList>
</td>
</tr>
<tr>
<td class="boxFooterNewsFeed">
    <asp:DataList ID="rssMore" Width="100%" runat="server">
    <ItemTemplate>
        <a href="<%#XPath("link")%>">
            <asp:Literal ID="lnkMoreNews" meta:resourcekey="lnkMoreNews" runat="server"></asp:Literal>
        </a>
    </ItemTemplate>
    </asp:DataList>    
</td>
</tr>
</table>

</asp:Panel>






