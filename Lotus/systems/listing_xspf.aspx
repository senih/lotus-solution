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
        Response.ContentType = "application/xspf+xml"
        Response.ContentEncoding = Encoding.UTF8

        Dim sPath As String
        If sRawUrl.Contains("?") Then
            sPath = sRawUrl.Split(CChar("?"))(0).ToString
        Else
            sPath = sRawUrl
        End If

        Dim nPageId As Integer = CInt(Request.QueryString("pg"))
               
        Dim sWriter As StringWriter = New StringWriter
        Dim sXML As XmlTextWriter = New XmlTextWriter(sWriter)
        sXML.WriteStartElement("playlist")
        sXML.WriteAttributeString("version", "1")
        sXML.WriteAttributeString("xmlns", "http://xspf.org/ns/0/")
        
        
        Dim nListingType As Integer
        Dim nListingProperty As Integer
        Dim sListingDefaultOrder As String
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        sSQL = "SELECT * FROM pages_published where channel_permission=1 AND page_id=" & nPageId
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            nListingType = oDataReader("listing_type")
            nListingProperty = oDataReader("listing_property")
            sListingDefaultOrder = oDataReader("listing_default_order").ToString
        Else
            oDataReader.Close()
            oConn.Close()
            oConn = Nothing
            Exit Sub
        End If
        oDataReader.Close()
       
        
        sXML.WriteStartElement("trackList")

        Dim dt As DataTable = New DataTable
        Dim oContent As Content = New Content
        
        Dim sSortType As String = "DESC"
        If nListingType = 1 Then
            'General
            If sListingDefaultOrder = "title" Or sListingDefaultOrder = "last_updated_by" Or sListingDefaultOrder = "owner" Then
                sSortType = "ASC"
            End If
            oContent.SortingBy = sListingDefaultOrder
            oContent.SortingType = sSortType

            If nListingProperty = 1 Or nListingProperty = 3 Then
                oContent.ManualOrder = True
            End If
        Else
            oContent.SortingBy = "display_date"
            oContent.SortingType = "DESC"
        End If
        If nListingType = 1 Then
            'General Listing
            dt = oContent.GetPagesWithin(nPageId, 0, 1, Nothing, False) 'Get all posts
        Else
            'News/Journal
            dt = oContent.GetPagesWithin(nPageId, 50, 2, Nothing, False) 'Get 50 latest posts
        End If

        If dt.Rows.Count > 0 Then
            For i As Integer = 0 To dt.Rows.Count - 1
                sXML.WriteStartElement("track")
                sXML.WriteElementString("title", dt.Rows(i).Item(1).ToString)
                sXML.WriteElementString("creator", "")
                sXML.WriteElementString("location", GetAppFullPath() & dt.Rows(i).Item(26).ToString)
                sXML.WriteElementString("image", GetAppFullPath() & dt.Rows(i).Item(12).ToString)
                sXML.WriteElementString("info", GetAppFullPath() & dt.Rows(i).Item(3).ToString)
                sXML.WriteEndElement()
            Next
        End If
        
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

        If Request.ApplicationPath = "/" Then
            'App is installed in root
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath
        Else
            'App is installed in virtual directory
            Return sProtocol & Request.ServerVariables("SERVER_NAME") & sPort & Request.ApplicationPath & "/"
        End If
    End Function
</script>

