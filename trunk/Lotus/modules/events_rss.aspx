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
        'Dim sCulture As String = Request.QueryString("c")
        'If Not sCulture = "" Then
        '    Dim ci As New CultureInfo(sCulture)
        '    Thread.CurrentThread.CurrentCulture = ci
        '    Thread.CurrentThread.CurrentUICulture = ci
        'End If
        Dim sFileName As String = ""
        Dim sURL As String
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
            sFileName = GetAppFullPath() & oDataReader("file_name").ToString
            
            sXML.WriteElementString("title", oDataReader("title").ToString)
            sXML.WriteElementString("link", sFileName)
        End If
        oDataReader.Close()

        sSQL = "SELECT * FROM calendar WHERE is_rec=0 AND " & _
                "start_time>getdate() AND page_id=" & nPageId & " ORDER BY start_time desc"
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            sURL = oDataReader("url").ToString
            dDisplayDate = CDate(oDataReader("start_time"))
            
            sXML.WriteStartElement("item")
            sXML.WriteElementString("title", oDataReader("subject").ToString)
            If sURL <> "" Then
                sXML.WriteElementString("link", sURL)
            Else
                sXML.WriteElementString("link", sFileName)
            End If
            sXML.WriteElementString("description", oDataReader("location").ToString & "<br />" & oDataReader("notes").ToString)
            sXML.WriteElementString("pubDate", dDisplayDate.ToString("r"))
            sXML.WriteEndElement()
        End While
        oDataReader.Close()

        sXML.WriteEndElement()
        sXML.WriteEndElement()
        sXML.Close()

        Response.Write(sWriter.ToString)
        oConn.Close()
        oConn = Nothing
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

