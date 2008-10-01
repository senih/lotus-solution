<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>

<script runat="server">
Dim nPageId As Integer
Dim nVersion As Integer
Dim sImageFileName As String

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
Private oConn As New SqlConnection(sConn)

Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        nPageId = CInt(Request.QueryString("pg"))
        nVersion = CInt(Request.QueryString("ver"))
        sImageFileName = Request.QueryString("img")

        Dim sFile As String = ConfigurationManager.AppSettings("FileStorage") & "\galleries\" & nPageId & "\" & sImageFileName

        'Authorization
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader

        Dim sFileName As String
        Dim nChannelPermission As Integer
        Dim sChannelName As String

        oConn = New SqlConnection(sConn)
        oConn.Open()

        If IsNothing(GetUser) Then
            sSQL = "SELECT file_attachment, channel_permission, channel_name " & _
                    "FROM pages_published  " & _
                    "WHERE page_id = " & nPageId & " AND version = " & nVersion
        Else
            sSQL = "SELECT pages.file_attachment, channels.channel_name, " & _
                    "channels.permission AS channel_permission " & _
                    "FROM pages INNER JOIN " & _
                    "channels ON pages.channel_id = channels.channel_id " & _
                    "WHERE pages.page_id = " & nPageId & " AND pages.version = " & nVersion

        End If
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            sFileName = oDataReader("file_attachment").ToString
            nChannelPermission = CInt(oDataReader("channel_permission"))
            sChannelName = oDataReader("channel_name").ToString

            'Authorization
            If IsNothing(GetUser) And Not nChannelPermission = 1 Then
                Response.Write("Please Login..")
                Exit Sub
            End If
            If nChannelPermission = 3 Then
                If Not (Roles.IsUserInRole(GetUser.UserName, sChannelName & " Subscribers") Or _
                    Roles.IsUserInRole(GetUser.UserName, sChannelName & " Authors") Or _
                    Roles.IsUserInRole(GetUser.UserName, sChannelName & " Editors") Or _
                    Roles.IsUserInRole(GetUser.UserName, sChannelName & " Publishers") Or _
                    Roles.IsUserInRole(GetUser.UserName, sChannelName & " Resource Managers") Or _
                    Roles.IsUserInRole(GetUser.UserName, "Administrators")) Then
                    Response.Write("Authorization Failed..")
                    Exit Sub
                End If
            End If
        End If
        oDataReader.Close()
        oConn.Close()


        Dim infoFile As New FileInfo(sFile)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=" & sImageFileName.Substring(sImageFileName.IndexOf("_") + 1))
        Response.AddHeader("Content-Length", infoFile.Length.ToString)
        Response.ContentType = "application/octet-stream"
        Response.WriteFile(sFile)
        Response.End()
End Sub
</script>