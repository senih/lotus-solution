<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="*" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="System.IO"%>
<%@ Import Namespace="System.Globalization"%>
<%@ Import Namespace="System.Threading"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private sRawUrl As String = Context.Request.RawUrl.ToString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.ContentType = "text/xml"
        Response.ContentEncoding = Encoding.UTF8

        Dim sPath As String
        If sRawUrl.Contains("?") Then
            sPath = sRawUrl.Split(CChar("?"))(0).ToString
        Else
            sPath = sRawUrl
        End If

        Dim nPageId As Integer = CInt(Request.QueryString("pg"))
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        Dim sTitle As String
        Dim sSummary As String
        Dim sContentBody As String
        Dim sFileName As String
        Dim dDisplayDate As Date

        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader

        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sWriter As StringWriter = New StringWriter
        Dim sXML As XmlTextWriter = New XmlTextWriter(sWriter)
        sXML.WriteStartElement("rss")
        sXML.WriteAttributeString("version", "2.0")
        sXML.WriteStartElement("channel")

        sSQL = "SELECT * FROM pages_published where channel_permission=1 AND page_id=" & nPageId ' & " and is_hidden=0"
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            sTitle = oDataReader("title").ToString
            sFileName = oDataReader("file_name").ToString
            sXML.WriteElementString("title", sTitle)
            sXML.WriteElementString("link", GetAppFullPath() & sFileName)
        End If
        oDataReader.Close()

        sSQL = "SELECT top 4 * FROM pages_published where channel_permission=1 AND parent_id=" & nPageId & _
               " and is_hidden=0 and display_date <= getdate()" & _
               " order by display_date desc, created_date desc"
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            If ShowLink(CInt(oDataReader("channel_permission")), _
                          oDataReader("published_start_date"), _
                          oDataReader("published_end_date"), _
                          CBool(oDataReader("is_system")), _
                          CBool(oDataReader("is_hidden"))) Then
    
                sTitle = oDataReader("title").ToString
                sFileName = oDataReader("file_name").ToString
                sSummary = oDataReader("summary").ToString
                sContentBody = oDataReader("content_body").ToString
                dDisplayDate = CDate(oDataReader("display_date"))
                sXML.WriteStartElement("item")
                sXML.WriteElementString("title", sTitle)
                sXML.WriteElementString("link", GetAppFullPath() & sFileName)
                sXML.WriteElementString("description", sSummary)
                sXML.WriteElementString("content", sContentBody)
                'sXML.WriteElementString("pubDate", FormatDateTime(dDisplayDate, DateFormat.ShortDate))
                sXML.WriteElementString("pubDate", dDisplayDate.ToString("r"))
                sXML.WriteEndElement()
            End If
        End While
        oDataReader.Close()

        sXML.WriteEndElement()
        sXML.WriteEndElement()
        sXML.Close()

        Response.Write(sWriter.ToString)
        oConn.Close()
        oConn = Nothing
    End Sub

    Protected Function ShowLink(ByVal nCPermission As Integer, _
        ByVal oStartDate As Object, _
        ByVal oEndDate As Object, _
        ByVal bIsSys As Boolean, _
        ByVal bIsHdn As Boolean) As Boolean

        Dim bShowLink As Boolean = False
        Dim bShowMenu As Boolean = False
        If nCPermission = 1 Or nCPermission = 2 Then
            bShowLink = True
            If bIsHdn Then
                bShowLink = False
            End If
        ElseIf nCPermission = 3 Then
            bShowLink = False
        End If

        If Not oStartDate.ToString = "" Then
            If Now < CDate(oStartDate) Then
                bShowLink = False
            End If
        End If

        If Not oEndDate.ToString = "" Then
            If Now > CDate(oEndDate) Then
                bShowLink = False
            End If
        End If

        If bIsSys Then
            If bIsHdn Then
                bShowLink = False
            Else
                bShowLink = True
            End If
        End If
        Return bShowLink
    End Function

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

        Dim sAppPath As String = Request.ApplicationPath
        If sAppPath = "/" Then
            'App is installed in root
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & sAppPath
        Else
            'App is installed in virtual directory
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & sAppPath & "/"
        End If
    End Function
</script>

