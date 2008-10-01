Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlClient.SqlParameterCollection
Imports System.Web.Security
Imports System.Web.Security.roles
Imports System.Web.Security.Membership

Public Class CMSChannel
    Private intChannelId As Integer = 0
    Private strChannelName As String = ""
    Private intDefaultTemplate As Integer = 0
    Private intPermission As Integer = 0
    Private bolDisableCollaboration As Boolean = False

    Public Const APPROVAL_NONE As Integer = 0
    Public Const APPROVAL_BY_EDITOR As Integer = 1
    Public Const APPROVAL_BY_PUBLISHER As Integer = 2
    Public Const APPROVAL_BY_ALL As Integer = 3

    Public Property ChannelId() As Integer
        Get
            Return intChannelId
        End Get
        Set(ByVal value As Integer)
            intChannelId = value
        End Set
    End Property
    Public Property ChannelName() As String
        Get
            Return strChannelName
        End Get
        Set(ByVal value As String)
            strChannelName = value
        End Set
    End Property
    Public Property DefaultTemplate() As Integer
        Get
            Return intDefaultTemplate
        End Get
        Set(ByVal value As Integer)
            intDefaultTemplate = value
        End Set
    End Property
    Public Property Permission() As Integer
        Get
            Return intPermission
        End Get
        Set(ByVal value As Integer)
            intPermission = value
        End Set
    End Property

    Public Property DisableCollaboration() As Boolean
        Get
            Return bolDisableCollaboration
        End Get
        Set(ByVal value As Boolean)
            bolDisableCollaboration = value
        End Set
    End Property

    Public Sub New()

    End Sub
    Public Sub New(ByVal intChannelId As Integer)
        Me.New(intChannelId, "", 0, 0, False)
    End Sub
    Public Sub New(ByVal intChannelId As Integer, ByVal strChannelName As String, ByVal intDefaultTmp As Integer, ByVal intPermission As Integer, Optional ByVal bolDisableCollaboration As Boolean = False)
        Me.ChannelId = intChannelId
        Me.ChannelName = strChannelName
        Me.DefaultTemplate = intDefaultTmp
        Me.Permission = intPermission
        Me.DisableCollaboration = bolDisableCollaboration
    End Sub
End Class

Public Class ChannelManager
    Private sConn As String
    Private oConn As SqlConnection

    Private CMS_ROLES_SUFF() As String = {" Subscribers", " Authors", " Editors", " Publishers", " Resource Managers"}

    Public Function CreateChannel(ByVal piChannel As CMSChannel) As CMSChannel
        Dim oChannel As CMSChannel = New CMSChannel(0)

        'Check if the channel (name) already exist.
        Dim sql As String = "SELECT * FROM channels WHERE UPPER(channel_name)=UPPER(@channel_name)"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@channel_name", SqlDbType.NVarChar, 50).Value = piChannel.ChannelName
        oConn.Open()
        oCmd.Connection = oConn
        If oCmd.ExecuteReader.Read Then
            'the channel with the same name is found
            oConn.Close()
            Return Nothing
        End If
        oConn.Close()

        oCmd = New SqlCommand("advcms_CreateChannel")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@channel_name", SqlDbType.NVarChar, 50).Value = piChannel.ChannelName
        oCmd.Parameters.Add("@default_template_id", SqlDbType.Int).Value = piChannel.DefaultTemplate
        oCmd.Parameters.Add("@permission", SqlDbType.Int).Value = piChannel.Permission
        oCmd.Parameters.Add("@disable_collaboration", SqlDbType.Bit).Value = piChannel.DisableCollaboration

        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader()
        If (reader.Read) Then
            oChannel = New CMSChannel(CInt(reader("channel_id")), reader("channel_name").ToString(), CInt(reader("default_template_id")), CInt(reader("permission")), CBool(reader("disable_collaboration")))
        End If
        oCmd = Nothing
        oConn.Close()

        'Create roles
        CreateRolesByChannel(oChannel.ChannelName)

        Return oChannel
    End Function

    Public Function GetChannel(ByVal intChannelId As Integer) As CMSChannel
        Dim oChannel As CMSChannel = Nothing

        Dim sql As String = "SELECT channel_id, channel_name, default_template_id, permission, disable_collaboration " & _
            " FROM channels WHERE channel_id=@channel_id"
        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@channel_id", SqlDbType.Int).Value = intChannelId

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read Then
            oChannel = New CMSChannel(CInt(reader("channel_id")), reader("channel_name").ToString, CInt(reader("default_template_id")), CInt(reader("permission")), CBool(reader("disable_collaboration")))
        End If
        reader.Close()
        oConn.Close()
        Return oChannel
    End Function

    Public Function GetChannelByName(ByVal strChannelName As String) As CMSChannel
        Dim oChannel As CMSChannel = Nothing

        Dim sql As String = "SELECT channel_id, channel_name, default_template_id, permission, disable_collaboration " & _
            " FROM channels WHERE channel_name=@channel_name"
        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@channel_name", SqlDbType.NVarChar, 50).Value = strChannelName

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read Then
            oChannel = New CMSChannel(CInt(reader("channel_id")), reader("channel_name").ToString, CInt(reader("default_template_id")), CInt(reader("permission")), CBool(reader("disable_collaboration")))
        End If
        reader.Close()
        oConn.Close()
        Return oChannel
    End Function

    Public Function DeleteChannel(ByVal intId As Integer) As Integer
    
        Dim oChannel As CMSChannel = GetChannel(intId)
    
        'Check if there is page using this channel.
        Dim sql As String = "SELECT TOP 100 PERCENT channel_id FROM pages_working WHERE channel_id=@channel_id1 UNION SELECT TOP 100 PERCENT channel_id FROM pages_published WHERE channel_id=@channel_id2"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@channel_id1", SqlDbType.Int).Value = intId
        oCmd.Parameters.Add("@channel_id2", SqlDbType.Int).Value = intId
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        If (reader.Read) Then
            'there is pages in this channel.
            oCmd = Nothing
            oConn.Close()
            Return 0
        End If
        reader.Close()

        DeleteRolesByChannel(oChannel.ChannelName)

        sql = "DELETE FROM channels " & _
            "WHERE channel_id=@channel_id "
        oCmd = New SqlCommand(sql)
        oCmd.Parameters.Add("@channel_id", SqlDbType.Int).Value = intId

        oCmd.Connection = oConn
        Dim rowAffected As Integer = oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()

        Return rowAffected
    End Function

    Public Function UpdateChannel(ByVal piChannel As CMSChannel) As CMSChannel

        'Get previouse Channel
        Dim prevChannel As CMSChannel = GetChannel(piChannel.ChannelId)

        Dim sql As String = "UPDATE channels set channel_name=@channel_name, default_template_id=@def_template, permission=@permission, disable_collaboration=@disable_collaboration " & _
            "WHERE channel_id=@channel_id "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@channel_name", SqlDbType.NVarChar, 50).Value = piChannel.ChannelName
        oCmd.Parameters.Add("@def_template", SqlDbType.Int).Value = piChannel.DefaultTemplate
        oCmd.Parameters.Add("@permission", SqlDbType.Int).Value = piChannel.Permission
        oCmd.Parameters.Add("@disable_collaboration", SqlDbType.Bit).Value = piChannel.DisableCollaboration
        oCmd.Parameters.Add("@channel_id", SqlDbType.Int).Value = piChannel.ChannelId

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()

        'Update all roles
        UpdateRolesByChannel(piChannel.ChannelName, prevChannel.ChannelName)

        Return piChannel
    End Function

    Public Function NeedApproval(ByVal intChannelId As Integer) As Integer
        Dim oChannel As CMSChannel = GetChannel(intChannelId)

        Dim needEditorAppr As Boolean = False
        Dim needPublisherAppr As Boolean = False

        Dim editorUsers() As String = GetUsersInRole(oChannel.ChannelName & " " & "Editors")
        If (editorUsers.Length > 0) Then needEditorAppr = True

        Dim pubUsers() As String = GetUsersInRole(oChannel.ChannelName & " " & "Publishers")
        If (pubUsers.Length > 0) Then needPublisherAppr = True

        If (needEditorAppr And needPublisherAppr) Then Return CMSChannel.APPROVAL_BY_ALL
        If (needEditorAppr) Then Return CMSChannel.APPROVAL_BY_EDITOR
        If (needPublisherAppr) Then Return CMSChannel.APPROVAL_BY_PUBLISHER

        Return CMSChannel.APPROVAL_NONE
    End Function

    Public Function NeedEditorApproval(ByVal intChannelId As Integer) As Boolean
        Dim oChannel As CMSChannel = GetChannel(intChannelId)

        Dim users() As String = GetUsersInRole(oChannel.ChannelName & " " & "Editors")
        If users.Length > 0 Then Return True

        Return False
    End Function

    Public Function NeedPublisherApproval(ByVal intChannelId As Integer) As Boolean
        Dim oChannel As CMSChannel = GetChannel(intChannelId)

        Dim users() As String = GetUsersInRole(oChannel.ChannelName & " " & "Publishers")
        If users.Length > 0 Then Return True

        Return False
    End Function

    Private Sub DeleteRolesByChannel(ByVal strChannel As String)
        'Delete roles
        Dim i As Integer = 0
        Dim chRole As String = ""
        For i = LBound(CMS_ROLES_SUFF) To UBound(CMS_ROLES_SUFF)
            chRole = strChannel & CMS_ROLES_SUFF(i)
            If Roles.RoleExists(chRole) Then
                If Not (GetUsersInRole(chRole).Length = 0) Then
                    Roles.RemoveUsersFromRole(GetUsersInRole(chRole), chRole)
                End If
                Roles.DeleteRole(chRole)
            End If

        Next i
    End Sub

    Public Function GetChannels() As SqlDataReader
        Dim oConn As New SqlConnection(sConn)
        oConn.Open()

        Dim sSQL As String
        sSQL = "SELECT * from channels"

        Dim oCommand As New SqlCommand(sSQL, oConn)
        GetChannels = oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetChannelsCollection() As Collection
        Dim sql As String = "SELECT * " & _
            " FROM channels "

        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text

        Dim colChannels As Collection = New Collection()
        Dim channel As CMSChannel
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read
            channel = New CMSChannel
            With channel
                .ChannelId = CInt(reader("channel_id"))
                .ChannelName = reader("channel_name").ToString
                .DefaultTemplate = CInt(reader("default_template_id"))
                .Permission = CInt(reader("permission"))
                .DisableCollaboration = CBool(reader("disable_collaboration"))
            End With
            colChannels.Add(channel, reader("channel_id").ToString)
        End While
        reader.Close()
        oConn.Close()

        Return colChannels
    End Function

    Public Function IsAuthorInChannel(ByVal strUser As String, ByVal intChannelId As Integer) As Boolean
        Return IsUserInChannelRole(strUser, intChannelId, CMS_ROLES_SUFF(1))
    End Function

    Public Function IsEditorInChannel(ByVal strUser As String, ByVal intChannelId As Integer) As Boolean
        Return IsUserInChannelRole(strUser, intChannelId, CMS_ROLES_SUFF(2))
    End Function

    Public Function IsPublisherInChannel(ByVal strUser As String, ByVal intChannelId As Integer) As Boolean
        Return IsUserInChannelRole(strUser, intChannelId, CMS_ROLES_SUFF(3))
    End Function

    Private Function IsUserInChannelRole(ByVal strUser As String, ByVal intChannelId As Integer, ByVal strRollSuff As String) As Boolean
        Dim channel As CMSChannel = GetChannel(intChannelId)
        Return IsUserInRole(strUser, channel.ChannelName & strRollSuff)
    End Function

    Private Sub UpdateRolesByChannel(ByVal newChannel As String, ByVal oldChannel As String)
        If newChannel = oldChannel Then
            Exit Sub
        End If

        'Delete roles
        Dim i As Integer = 0
        Dim chNewRole As String = ""
        Dim chOldRole As String = ""
        For i = LBound(CMS_ROLES_SUFF) To UBound(CMS_ROLES_SUFF)
            chNewRole = newChannel & CMS_ROLES_SUFF(i)
            chOldRole = oldChannel & CMS_ROLES_SUFF(i)
            If Not Roles.RoleExists(chNewRole) Then
                Roles.CreateRole(chNewRole)
            End If

            If Roles.RoleExists(chOldRole) Then
                If Not (GetUsersInRole(chOldRole).Length = 0) Then
                    Roles.AddUsersToRole(GetUsersInRole(chOldRole), chNewRole)
                    Roles.RemoveUsersFromRole(GetUsersInRole(chOldRole), chOldRole)
                End If
                Roles.DeleteRole(chOldRole)
            End If
        Next i
    End Sub

    Private Sub CreateRolesByChannel(ByVal strChannel As String)
        'Delete roles
        Dim i As Integer = 0
        Dim chRole As String = ""
        For i = LBound(CMS_ROLES_SUFF) To UBound(CMS_ROLES_SUFF)
            chRole = strChannel & CMS_ROLES_SUFF(i)
            If Not Roles.RoleExists(chRole) Then
                Roles.CreateRole(chRole)
            End If
        Next i
    End Sub

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub
End Class

