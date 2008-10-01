Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class RegistrationSetting

    Private _confirmation_subject As String
    Public Property ConfirmationSubject() As String
        Get
            Return _confirmation_subject
        End Get
        Set(ByVal value As String)
            _confirmation_subject = value
        End Set
    End Property

    Private _confirmation_body As String
    Public Property ConfirmationBody() As String
        Get
            Return _confirmation_body
        End Get
        Set(ByVal value As String)
            _confirmation_body = value
        End Set
    End Property

    Private _confirmed_subject As String
    Public Property ConfirmedSubject() As String
        Get
            Return _confirmed_subject
        End Get
        Set(ByVal value As String)
            _confirmed_subject = value
        End Set
    End Property

    Private _confirmed_body As String
    Public Property ConfirmedBody() As String
        Get
            Return _confirmed_body
        End Get
        Set(ByVal value As String)
            _confirmed_body = value
        End Set
    End Property

    Private _unsubscribe_signature As String
    Public Property UnsubscribeSignature() As String
        Get
            Return _unsubscribe_signature
        End Get
        Set(ByVal value As String)
            _unsubscribe_signature = value
        End Set
    End Property

    Private _unsubscribe_signature_text As String
    Public Property UnsubscribeSignatureText() As String
        Get
            Return _unsubscribe_signature_text
        End Get
        Set(ByVal value As String)
            _unsubscribe_signature_text = value
        End Set
    End Property

    Private _root_id As Integer
    Public Property RootId() As Integer
        Get
            Return _root_id
        End Get
        Set(ByVal value As Integer)
            _root_id = value
        End Set
    End Property

    Private _option_type As String
    Public Property OptionType() As String
        Get
            Return _option_type
        End Get
        Set(ByVal value As String)
            _option_type = value
        End Set
    End Property

    Private _option_description As String
    Public Property OptionDescription() As String
        Get
            Return _option_description
        End Get
        Set(ByVal value As String)
            _option_description = value
        End Set
    End Property

    Private _opt1 As String
    Public Property Option1() As String
        Get
            Return _opt1
        End Get
        Set(ByVal value As String)
            _opt1 = value
        End Set
    End Property

    Private _channel1 As String
    Public Property Channel1() As String
        Get
            Return _channel1
        End Get
        Set(ByVal value As String)
            _channel1 = value
        End Set
    End Property

    Private _opt2 As String
    Public Property Option2() As String
        Get
            Return _opt2
        End Get
        Set(ByVal value As String)
            _opt2 = value
        End Set
    End Property

    Private _channel2 As String
    Public Property Channel2() As String
        Get
            Return _channel2
        End Get
        Set(ByVal value As String)
            _channel2 = value
        End Set
    End Property

    Private _opt3 As String
    Public Property Option3() As String
        Get
            Return _opt3
        End Get
        Set(ByVal value As String)
            _opt3 = value
        End Set
    End Property

    Private _channel3 As String
    Public Property Channel3() As String
        Get
            Return _channel3
        End Get
        Set(ByVal value As String)
            _channel3 = value
        End Set
    End Property

    Private _opt4 As String
    Public Property Option4() As String
        Get
            Return _opt4
        End Get
        Set(ByVal value As String)
            _opt4 = value
        End Set
    End Property

    Private _channel4 As String
    Public Property Channel4() As String
        Get
            Return _channel4
        End Get
        Set(ByVal value As String)
            _channel4 = value
        End Set
    End Property

    Private _opt5 As String
    Public Property Option5() As String
        Get
            Return _opt5
        End Get
        Set(ByVal value As String)
            _opt5 = value
        End Set
    End Property

    Private _channel5 As String
    Public Property Channel5() As String
        Get
            Return _channel5
        End Get
        Set(ByVal value As String)
            _channel5 = value
        End Set
    End Property

    Private _enable As Boolean
    Public Property Enable() As Boolean
        Get
            Return _enable
        End Get
        Set(ByVal value As Boolean)
            _enable = value
        End Set
    End Property

End Class

Public Class RegistrationOption
    Private _key As String
    Public Property Key() As String
        Get
            Return _key
        End Get
        Set(ByVal value As String)
            _key = value
        End Set
    End Property

    Private _value As String
    Public Property Value() As String
        Get
            Return _value
        End Get
        Set(ByVal value As String)
            _value = value
        End Set
    End Property

End Class

Public Class Registration

    Public Shared Sub InsertRegistrationSetting(ByVal Setting As RegistrationSetting)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = " delete registration_settings where root_id=@root_id; " & _
                "insert into registration_settings (root_id,enable,confirmation_subject,confirmation_body,confirmed_subject,confirmed_body,option_type,option_description,opt1,channel1,opt2,channel2,opt3,channel3,opt4,channel4,opt5,channel5) " & _
                "values (@root_id,@enable,@confirmation_subject,@confirmation_body,@confirmed_subject,@confirmed_body,@option_type,@option_description,@opt1,@channel1,@opt2,@channel2,@opt3,@channel3,@opt4,@channel4,@opt5,@channel5)"
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Setting.RootId
        sqlCmd.Parameters.Add("@enable", SqlDbType.Bit).Value = True
        sqlCmd.Parameters.Add("@confirmation_body", SqlDbType.NText).Value = Setting.ConfirmationBody
        sqlCmd.Parameters.Add("@confirmation_subject", SqlDbType.NText).Value = Setting.ConfirmationSubject
        sqlCmd.Parameters.Add("@confirmed_body", SqlDbType.NText).Value = Setting.ConfirmedBody
        sqlCmd.Parameters.Add("@confirmed_subject", SqlDbType.NText).Value = Setting.ConfirmedSubject
        sqlCmd.Parameters.Add("@option_description", SqlDbType.NVarChar).Value = Setting.OptionDescription
        sqlCmd.Parameters.Add("@option_type", SqlDbType.NVarChar).Value = Setting.OptionType
        sqlCmd.Parameters.Add("@opt1", SqlDbType.NVarChar).Value = Setting.Option1
        sqlCmd.Parameters.Add("@opt2", SqlDbType.NVarChar).Value = Setting.Option2
        sqlCmd.Parameters.Add("@opt3", SqlDbType.NVarChar).Value = Setting.Option3
        sqlCmd.Parameters.Add("@opt4", SqlDbType.NVarChar).Value = Setting.Option4
        sqlCmd.Parameters.Add("@opt5", SqlDbType.NVarChar).Value = Setting.Option5
        sqlCmd.Parameters.Add("@channel1", SqlDbType.NVarChar).Value = Setting.Channel1
        sqlCmd.Parameters.Add("@channel2", SqlDbType.NVarChar).Value = Setting.Channel2
        sqlCmd.Parameters.Add("@channel3", SqlDbType.NVarChar).Value = Setting.Channel3
        sqlCmd.Parameters.Add("@channel4", SqlDbType.NVarChar).Value = Setting.Channel4
        sqlCmd.Parameters.Add("@channel5", SqlDbType.NVarChar).Value = Setting.Channel5
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub


    Public Shared Function GetRegistrationSetting(ByVal RootID As Integer) As RegistrationSetting
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim Reader As SqlDataReader
        Dim oSetting As RegistrationSetting = New RegistrationSetting
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "select * from registration_settings where root_id=@root_id"
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = RootID
        oConn.Open()
        Reader = sqlCmd.ExecuteReader
        While Reader.Read
            oSetting.ConfirmationBody = Reader("confirmation_body").ToString
            oSetting.ConfirmationSubject = Reader("confirmation_subject").ToString
            oSetting.ConfirmedBody = Reader("confirmed_body").ToString
            oSetting.ConfirmedSubject = Reader("confirmed_subject").ToString
            oSetting.OptionDescription = Reader("option_description").ToString
            oSetting.OptionType = Reader("option_type").ToString
            oSetting.Option1 = Reader("opt1").ToString
            oSetting.Option2 = Reader("opt2").ToString
            oSetting.Option3 = Reader("opt3").ToString
            oSetting.Option4 = Reader("opt4").ToString
            oSetting.Option5 = Reader("opt5").ToString
            oSetting.Channel1 = Reader("channel1").ToString
            oSetting.Channel2 = Reader("channel2").ToString
            oSetting.Channel3 = Reader("channel3").ToString
            oSetting.Channel4 = Reader("channel4").ToString
            oSetting.Channel5 = Reader("channel5").ToString
            oSetting.RootId = CInt(Reader("root_id"))
        End While
        Reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        
        Return oSetting
    End Function
End Class
