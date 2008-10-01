Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlClient.SqlParameterCollection

Public Class CMSTemplate
    Private intTemplateId As Integer
    Private strTemplateName As String
    Private strFolderName As String

    Public Property TemplateId() As Integer
        Get
            Return intTemplateId
        End Get
        Set(ByVal value As Integer)
            intTemplateId = value
        End Set
    End Property
    Public Property TemplateName() As String
        Get
            Return strTemplateName
        End Get
        Set(ByVal value As String)
            strTemplateName = value
        End Set
    End Property
    Public Property FolderName() As String
        Get
            Return strFolderName
        End Get
        Set(ByVal value As String)
            strFolderName = value
        End Set
    End Property

    Public Sub New()

    End Sub

    Public Sub New(ByVal intId As Integer, ByVal strName As String, ByVal strFolderName As String)
        Me.TemplateId = intId
        Me.TemplateName = strName
        Me.FolderName = strFolderName
    End Sub

End Class

Public Class TemplateManager

    Private sConn As String
    Private oConn As SqlConnection

    Public Function CreateTemplate(ByVal template As CMSTemplate) As CMSTemplate
        Dim oTemplate As CMSTemplate = New CMSTemplate

        'Check if the channel (name) already exist.
        Dim sql As String = "SELECT * FROM templates WHERE UPPER(template_name)=UPPER(@template_name)"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@template_name", SqlDbType.NVarChar, 50).Value = template.TemplateName
        oConn.Open()
        oCmd.Connection = oConn
        If oCmd.ExecuteReader.Read Then
            'the template with the same name is found
            oConn.Close()
            Return Nothing
        End If
        oConn.Close()

        oCmd = New SqlCommand("advcms_CreateTemplate")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@template_name", SqlDbType.NVarChar, 50).Value = template.TemplateName
        oCmd.Parameters.Add("@folder_name", SqlDbType.NVarChar, 50).Value = template.FolderName

        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader()
        If (reader.Read) Then
            oTemplate = New CMSTemplate( _
                CInt(reader("template_id")), _
                reader("template_name").ToString(), _
                reader("folder_name").ToString() _
            )
        End If
        oCmd = Nothing
        oConn.Close()

        Return oTemplate
    End Function

    Public Function GetTemplate(ByVal intTemplateId As Integer) As CMSTemplate
        Dim template As CMSTemplate = New CMSTemplate

        Dim sql As String = "SELECT template_id, template_name, folder_name " & _
            " FROM templates WHERE template_id=@template_id"

        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@template_id", SqlDbType.Int).Value = intTemplateId

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read Then
            template = New CMSTemplate
            With template
                .TemplateId = CInt(reader("template_id"))
                .TemplateName = reader("template_name").ToString
                .FolderName = reader("folder_name").ToString
            End With
        End If
        reader.Close()
        oConn.Close()
        Return template
    End Function

    Public Function GetTemplateByName(ByVal sTemplateName As String) As CMSTemplate
        Dim template As CMSTemplate = New CMSTemplate

        Dim sql As String = "SELECT template_id, template_name, folder_name " & _
            " FROM templates WHERE template_name=@template_name"

        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@template_name", SqlDbType.NVarChar).Value = sTemplateName

        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read Then
            template = New CMSTemplate
            With template
                .TemplateId = CInt(reader("template_id"))
                .TemplateName = reader("template_name").ToString
                .FolderName = reader("folder_name").ToString
            End With
        End If
        reader.Close()
        oConn.Close()
        Return template
    End Function

    Public Function DeleteTemplate(ByVal intTemplateId As Integer) As Integer

        'Check if the template is already used by page.
        Dim sql As String = "SELECT template_id FROM pages_published WHERE template_id=@template_id " & _
            "UNION ALL SELECT default_template_id as template_id FROM channels WHERE default_template_id=@defaut_template_id " & _
            "UNION ALL SELECT template_id FROM pages_working WHERE template_id=@template_id " & _
            "ORDER BY template_id"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@template_id", SqlDbType.Int).Value = intTemplateId
        oCmd.Parameters.Add("@defaut_template_id", SqlDbType.Int).Value = intTemplateId
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
        
        sql = "DELETE FROM templates " & _
            "WHERE template_id=@template_id "
        oCmd = New SqlCommand(sql)
        oCmd.Parameters.Add("@template_id", SqlDbType.Int).Value = intTemplateId

        oCmd.Connection = oConn
        Dim rowAffected As Integer = oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()

        Return rowAffected
    End Function

    Public Function UpdateTemplate(ByVal piTemplate As CMSTemplate) As CMSTemplate

        Dim sql As String = "UPDATE templates set template_name=@template_name, " & _
            "folder_name=@folder_name " & _
            "WHERE template_id=@template_id "
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@template_name", SqlDbType.NVarChar, 50).Value = piTemplate.TemplateName
        oCmd.Parameters.Add("@folder_name", SqlDbType.NVarChar, 50).Value = piTemplate.FolderName
        oCmd.Parameters.Add("@template_id", SqlDbType.Int).Value = piTemplate.TemplateId

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()

        Return piTemplate
    End Function

    Public Function ListAllTemplates() As Collection
        Dim sql As String = "SELECT template_id, template_name, folder_name " & _
           " FROM templates ORDER by template_name"

        oConn.Open()
        Dim cmd As New SqlCommand(sql, oConn)
        cmd.CommandType = CommandType.Text

        Dim colTemplate As Collection = New Collection()
        Dim template As CMSTemplate
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read
            template = New CMSTemplate
            With template
                .TemplateId = CInt(reader("template_id"))
                .TemplateName = reader("template_name").ToString
                .FolderName = reader("folder_name").ToString
            End With
            colTemplate.Add(template, reader("template_id").ToString)
        End While
        reader.Close()
        oConn.Close()

        Return colTemplate
    End Function

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub

End Class
