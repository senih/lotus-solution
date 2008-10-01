<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="pg"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>

<%@ Import Namespace="System.Drawing"  %>
<%@ Import Namespace="System.Drawing.Imaging"  %>
<%@ Import Namespace="System.Drawing.Drawing2D"  %>

<script runat=server>
    Private nPageId As Integer
    Private nVersion As Integer
    Private sView As String

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        nPageId = CInt(Request.QueryString("pg"))
        nVersion = CInt(Request.QueryString("ver"))
        sView = Request.QueryString("view")

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
            sSQL = "SELECT file_view, channel_permission, channel_name " & _
                    "FROM pages_published  " & _
                    "WHERE page_id = " & nPageId & " AND version = " & nVersion
        Else
            sSQL = "SELECT pages.file_view, channels.channel_name, " & _
                    "channels.permission AS channel_permission " & _
                    "FROM pages INNER JOIN " & _
                    "channels ON pages.channel_id = channels.channel_id " & _
                    "WHERE pages.page_id = " & nPageId & " AND pages.version = " & nVersion
        End If
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            sFileName = oDataReader("file_view").ToString
            nChannelPermission = CInt(oDataReader("channel_permission"))
            sChannelName = oDataReader("channel_name").ToString

            '~~~ Authorization ~~~
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
            '~~~~~~~~~~~~~~~~~~~~~

            If sFileName <> "" Then
                Dim sFile As String = ConfigurationManager.AppSettings("FileStorage") & "\file_views\" & nPageId & "\" & sFileName

                Dim sName As String = sFileName.Substring(sFileName.IndexOf("_") + 1)
                sName = sName.Replace(" ", "_")
                
                Dim infoFile As New FileInfo(sFile)
                
                Response.Clear()
                Response.AddHeader("content-disposition", "attachment;filename=" & sName)
                Response.AddHeader("Content-Length", infoFile.Length.ToString)
                Response.ContentType = "application/octet-stream"
                    
                Response.WriteFile(sFile)
                Response.End()

            Else
                Response.Write("File Not Found.")
            End If
        Else
            Response.Write("File Not Found.")
        End If
        oDataReader.Close()

        oConn.Close()
    End Sub
</script>
