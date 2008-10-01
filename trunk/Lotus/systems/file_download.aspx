<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="pg"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml"  %>

<%@ Import Namespace="System.Drawing"  %>
<%@ Import Namespace="System.Drawing.Imaging"  %>
<%@ Import Namespace="System.Drawing.Drawing2D"  %>

<script runat="server">
    Private nPageId As Integer
    Private nVersion As Integer
    Private sView As String

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Stat()
        Dim sql As String = "INSERT INTO page_downloads (page_id,ip,user_agent,date_stamp,datetime_stamp) VALUES (@page_id,@ip,@user_agent,@date_stamp,@datetime_stamp)"
        Dim cmd As SqlCommand
        cmd = New SqlCommand(sql)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = CInt(Request.QueryString("pg"))
        cmd.Parameters.Add("@ip", SqlDbType.NVarChar, 50).Value = Request.ServerVariables("REMOTE_ADDR").ToString
        cmd.Parameters.Add("@user_agent", SqlDbType.NVarChar, 50).Value = Request.ServerVariables("HTTP_USER_AGENT").ToString
        cmd.Parameters.Add("@date_stamp", SqlDbType.SmallDateTime).Value = New Date(Now.Year, Now.Month, Now.Day)
        cmd.Parameters.Add("@datetime_stamp", SqlDbType.DateTime).Value = Now
        oConn.Open()
        cmd.Connection = oConn
        cmd.ExecuteNonQuery()
        cmd = Nothing
        oConn.Close()
    End Sub
    
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
        Dim sElements As String
        Dim bFileEnabled As Boolean = True
        Dim sStatus As String

        oConn = New SqlConnection(sConn)
        oConn.Open()

        If IsNothing(GetUser) Then
            sSQL = "SELECT file_attachment, channel_permission, channel_name, elements, status " & _
                    "FROM pages_published  " & _
                    "WHERE page_id = " & nPageId & " AND version = " & nVersion
        Else
            sSQL = "SELECT pages.file_attachment, channels.channel_name, " & _
                    "channels.permission AS channel_permission, elements, status " & _
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
            
            sStatus = oDataReader("status").ToString
            sElements = oDataReader("elements").ToString
            If Not sElements = "" Then
                Dim oXML As XmlDocument = New XmlDocument
                oXML.LoadXml(sElements)
                If Not CBool(oXML.DocumentElement.Item("file_download").InnerText) Then
                    bFileEnabled = False
                End If
            End If

            '~~~ Authorization ~~~
            Dim bIsReader As Boolean = False
            Dim bIsSubscriber As Boolean = False
            Dim sUserName As String = ""
            If IsNothing(GetUser) Then
                bIsReader = True
                
                If nChannelPermission = 1 Then
                    If sStatus <> "published" Then
                        'Anonymous User coba akses public file versi sebelumnya/blm published
                        Exit Sub
                    End If
                Else
                    Response.Write("Please Login..")
                    Exit Sub
                End If

            Else
                sUserName = GetUser.UserName
                bIsSubscriber = Roles.IsUserInRole(sUserName, sChannelName & " Subscribers")
            End If
            
            If nChannelPermission = 3 Then
                If Not (Roles.IsUserInRole(sUserName, sChannelName & " Subscribers") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Authors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Editors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Publishers") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Resource Managers") Or _
                    Roles.IsUserInRole(sUserName, "Administrators")) Then
                    Response.Write("Authorization Failed..")
                    Exit Sub
                End If
            End If
            
            If sStatus <> "published" Then
                'File yg coba diakses versi sebelumnya/blm published
                '(harus author, admin, dst)
                If Not (Roles.IsUserInRole(sUserName, sChannelName & " Authors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Editors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Publishers") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Resource Managers") Or _
                    Roles.IsUserInRole(sUserName, "Administrators")) Then

                    Response.Write("Authorization Failed..")
                    Exit Sub
                End If
            End If
            
            If bFileEnabled = False Then
                If IsNothing(GetUser) Then
                    Response.Write("Please Login..")
                    Exit Sub
                End If
                
                If Roles.IsUserInRole(sUserName, sChannelName & " Authors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Editors") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Publishers") Or _
                    Roles.IsUserInRole(sUserName, sChannelName & " Resource Managers") Or _
                    Roles.IsUserInRole(sUserName, "Administrators") Then
                    'Boleh download
                ElseIf CheckOrder() Then
                    'Boleh download
                Else
                    'Tdk boleh download
                    Response.Write("Authorization Failed..")
                    Exit Sub
                End If
            End If
            '~~~~~~~~~~~~~~~~~~~~~

            If sFileName <> "" Then
                
                'Stat
                If bIsReader Or bIsSubscriber Then
                    Stat()
                End If
                
                Dim sFile As String = ConfigurationManager.AppSettings("FileStorage") & "\files\" & nPageId & "\" & sFileName

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
    
    Function CheckOrder() As Boolean
        Dim bReturn As Boolean = False
        Dim sSQL As String = "SELECT order_items.order_item_id, order_items.item_id, order_items.item_desc, pages_published.file_attachment, " & _
            "pages_published.file_size, orders.order_date FROM orders INNER JOIN order_items ON orders.order_id = order_items.order_id INNER JOIN " & _
            "pages_published ON order_items.item_id = pages_published.page_id " & _
            "WHERE orders.status = 'VERIFIED' AND orders.order_by=@order_by AND order_items.item_id=@page_id"
                
        Dim cmd As SqlCommand
        cmd = New SqlCommand(sSQL)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@page_id", SqlDbType.Int).Value = CInt(Request.QueryString("pg"))
        cmd.Parameters.Add("@order_by", SqlDbType.NVarChar).Value = GetUser.UserName
        oConn.Open()
        cmd.Connection = oConn
        Dim oDataReader As SqlDataReader
        oDataReader = cmd.ExecuteReader()
        If oDataReader.Read() Then
            bReturn = True
        End If
        cmd = Nothing
        oConn.Close()
        
        Return bReturn
    End Function
</script>
