Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security.Membership

Public Class Newsletter

    Private _newsId As Integer
    Public Property Id() As Integer
        Get
            Return _newsId
        End Get
        Set(ByVal value As Integer)
            _newsId = value
        End Set
    End Property

    Private _message As String
    Public Property Message() As String
        Get
            Return _message
        End Get
        Set(ByVal value As String)
            _message = value
        End Set
    End Property

    Private _subject As String
    Public Property Subject() As String
        Get
            Return _subject
        End Get
        Set(ByVal value As String)
            _subject = value
        End Set
    End Property

    Private _css As String
    Public Property Css() As String
        Get
            Return _css
        End Get
        Set(ByVal value As String)
            _css = value
        End Set
    End Property

    Private _form As String
    Public Property Form() As String
        Get
            Return _form
        End Get
        Set(ByVal value As String)
            _form = value
        End Set
    End Property

    Private _receipients_type As String
    Public Property ReceipientsType() As String
        Get
            Return _receipients_type
        End Get
        Set(ByVal value As String)
            _receipients_type = value
        End Set
    End Property

    Private _sent_to As String
    Public Property SendTo() As String
        Get
            Return _sent_to
        End Get
        Set(ByVal value As String)
            _sent_to = value
        End Set
    End Property

    Private _author As String
    Public Property Author() As String
        Get
            Return _author
        End Get
        Set(ByVal value As String)
            _author = value
        End Set
    End Property

    Private _created_date As DateTime
    Public Property CreatedDate() As DateTime
        Get
            Return _created_date
        End Get
        Set(ByVal value As DateTime)
            _created_date = value
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

End Class

Public Class Category

    Private _categoryId As Integer
    Public Property CategoryId() As Integer
        Get
            Return _categoryId
        End Get
        Set(ByVal value As Integer)
            _categoryId = value
        End Set
    End Property

    Private _title As String
    Public Property Title() As String
        Get
            Return _title
        End Get
        Set(ByVal value As String)
            _title = value
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

    Private _active As Boolean
    Public Property Active() As Boolean
        Get
            Return _active
        End Get
        Set(ByVal value As Boolean)
            _active = value
        End Set
    End Property

    Private _private As Boolean
    Public Property IsPrivate() As Boolean
        Get
            Return _private
        End Get
        Set(ByVal value As Boolean)
            _private = value
        End Set
    End Property

    Private _count As Integer
    Public Property Count() As Integer
        Get
            Return _count
        End Get
        Set(ByVal value As Integer)
            _count = value
        End Set
    End Property

End Class


Public Class NewsletterSetting

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

End Class

Public Class Subscription

    Private _name As String
    Public Property Name() As String
        Get
            Return _name
        End Get
        Set(ByVal value As String)
            _name = value
        End Set
    End Property

    Private _email As String
    Public Property Email() As String
        Get
            Return _email
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property

    Private _category_id As Integer
    Public Property CategoryId() As Integer
        Get
            Return _category_id
        End Get
        Set(ByVal value As Integer)
            _category_id = value
        End Set
    End Property

    Private _status As Boolean
    Public Property Status() As Boolean
        Get
            Return _status
        End Get
        Set(ByVal value As Boolean)
            _status = value
        End Set
    End Property

    Private _date_registered As DateTime
    Public Property DateRegistered() As DateTime
        Get
            Return _date_registered
        End Get
        Set(ByVal value As DateTime)
            _date_registered = value
        End Set
    End Property

    Private _unsubscribe As Boolean
    Public Property Unssubscribe() As Boolean
        Get
            Return _unsubscribe
        End Get
        Set(ByVal value As Boolean)
            _unsubscribe = value
        End Set
    End Property
End Class

Public Class Receipient

    Private _newsletter_id As Integer
    Public Property NewsletterId() As Integer
        Get
            Return _newsletter_id
        End Get
        Set(ByVal value As Integer)
            _newsletter_id = value
        End Set
    End Property

    Private _email As String
    Public Property Email() As String
        Get
            Return _email
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property

    Private _status As String
    Public Property Status() As String
        Get
            Return _status
        End Get
        Set(ByVal value As String)
            _status = value
        End Set
    End Property

End Class


Public Class NewsletterManager
    Public Shared Function GetNewsletterById(ByVal NewsId As Integer) As Newsletter
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim news As Newsletter = New Newsletter
        Dim sqlCmd As SqlCommand = New SqlCommand
        Dim reader As SqlDataReader
        Dim exist As Boolean = False
        sqlCmd.Connection = oConn
        sqlCmd.CommandText = "Select * from newsletters where id=@id "
        sqlCmd.Parameters.Add("@id", SqlDbType.Int).Value = NewsId
        oConn.Open()
        reader = sqlCmd.ExecuteReader
        While reader.Read
            news.Author = reader("author").ToString
            If Not IsDBNull(reader("created_date")) Then
                news.CreatedDate = reader("created_date")
            End If
            news.Css = reader("css").ToString
            news.Form = reader("form").ToString
            news.Message = reader("message").ToString
            news.ReceipientsType = reader("receipients_type").ToString
            news.RootId = reader("root_id")
            news.SendTo = reader("send_to").ToString
            news.Subject = reader("subject").ToString
            news.Id = reader("id")
            exist = True
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()

        If Not exist Then
            news = Nothing
        End If
        Return news
    End Function

    Public Shared Function GetNewsleters(ByVal All As Boolean, ByVal RootId As Integer, Optional ByVal category_id As Integer = 0) As Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim Newsletters As Collection = New Collection
        Dim sqlCmd As SqlCommand = New SqlCommand
        Dim reader As SqlDataReader
        sqlCmd.Connection = oConn
        If All Then
            sqlCmd.CommandText = "SELECT  DISTINCT newsletters.subject,newsletters.created_date,newsletters.id FROM newsletters INNER JOIN " & _
             " newsletters_map ON newsletters.id = newsletters_map.newsletter_id INNER JOIN " & _
             " newsletters_categories ON newsletters_map.category_id = newsletters_categories.category_id where newsletters_categories.private =0 and newsletters_categories.root_id=@root_id order by  newsletters.created_date desc"
        Else
            sqlCmd.CommandText = "SELECT  DISTINCT newsletters.subject,newsletters.created_date,newsletters.id FROM newsletters INNER JOIN " & _
                        " newsletters_map ON newsletters.id = newsletters_map.newsletter_id INNER JOIN " & _
                        " newsletters_categories ON newsletters_map.category_id = newsletters_categories.category_id where newsletters_categories.private =0 and newsletters_categories.root_id=@root_id and newsletters_categories.category_id=@category_id order by  newsletters.created_date desc"

        End If
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = category_id
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = RootId
        oConn.Open()
        reader = sqlCmd.ExecuteReader
        While reader.Read
            Dim news As Newsletter = New Newsletter
            If Not IsDBNull(reader("created_date")) Then
                news.CreatedDate = reader("created_date")
            End If
            ' news.Author = reader("author").ToString
            ' news.Css = reader("css").ToString
            ' news.Form = reader("form").ToString
            ' news.Message = reader("message").ToString
            ' news.ReceipientsType = reader("receipients_type").ToString
            ' news.RootId = reader("root_id")
            ' news.SendTo = reader("send_to").ToString
            news.Subject = reader("subject").ToString
            news.Id = reader("id")
            Newsletters.Add(news)
            news = Nothing
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return Newsletters
    End Function

    Public Shared Function InsertNewsletter(ByVal oNewsletter As Newsletter) As Integer
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        Dim i As Integer

        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "insert into newsletters (subject,message,author,form,created_date,receipients_type,css,root_id) " & _
                "values (@subject,@message,@author,@form,getdate(),0,@css,@root_id) select @@Identity as news_id "
        sqlCmd.Parameters.Add("@subject", SqlDbType.NVarChar).Value = oNewsletter.Subject
        sqlCmd.Parameters.Add("@message", SqlDbType.Text).Value = oNewsletter.Message
        sqlCmd.Parameters.Add("@css", SqlDbType.Text).Value = oNewsletter.Css
        sqlCmd.Parameters.Add("@author", SqlDbType.NVarChar).Value = oNewsletter.Author
        sqlCmd.Parameters.Add("@form", SqlDbType.NVarChar).Value = oNewsletter.Form
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = oNewsletter.RootId
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        While reader.Read
            i = reader("news_id")
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return i
    End Function

    Public Shared Sub UpdateNewsletter(ByVal oNewsletter As Newsletter)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "update newsletters set subject=@subject,message=@message,css=@css,root_id=@root_id where id=@news_id ;delete newsletters_map where newsletter_id=@news_id "
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = oNewsletter.Id
        sqlCmd.Parameters.Add("@subject", SqlDbType.NVarChar).Value = oNewsletter.Subject
        sqlCmd.Parameters.Add("@message", SqlDbType.Text).Value = oNewsletter.Message
        sqlCmd.Parameters.Add("@css", SqlDbType.Text).Value = oNewsletter.Css
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = oNewsletter.RootId
        ' sqlCmd.Parameters.Add("@author", SqlDbType.NVarChar).Value = oNewsletter.Author
        ' sqlCmd.Parameters.Add("@form", SqlDbType.NVarChar).Value = oNewsletter.Form
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub


    'delete Newsletter and newsletter map by newsletter ID
    Public Shared Sub DeleteNewsletter(ByVal NewsId As Integer)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        oConn.Open()
        sqlCmd.CommandText = "DELETE FROM newsletters WHERE id=@news_id ; DELETE newsletters_map where newsletter_id=@news_id " '; DELETE FROM newsletters_receipients WHERE newsletters_id=@news_id"
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    'Category
    Public Shared Function GetCategories(ByVal RootId As Integer) As Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        Dim i As Integer
        Dim colCategories As Collection = New Collection
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "SELECT * FROM newsletters_categories where root_id=@root_id"
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = RootId
        oConn.Open()
        reader = sqlCmd.ExecuteReader
        While reader.Read
            Dim Category As Category = New Category
            Category.CategoryId = reader("category_id")
            Category.Title = reader("category")
            Category.RootId = reader("root_id")
            Category.Active = reader("active")
            Category.IsPrivate = reader("private")
            colCategories.Add(Category)
        End While
        reader.Close()
        sqlCmd.Dispose()
        sqlCmd.CommandText = "SELECT count(email) FROM newsletters_subscribers where category_id=@category_id and status=1 and unsubscribe=0"
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int)
        For i = 1 To colCategories.Count
            sqlCmd.Parameters("@category_id").Value = CType(colCategories.Item(i), Category).CategoryId
            reader = sqlCmd.ExecuteReader
            While reader.Read
                CType(colCategories.Item(i), Category).Count = reader.GetValue(0)
            End While
            reader.Close()
            sqlCmd.Dispose()
        Next
        oConn.Close()
        Return colCategories

    End Function

    Public Shared Function GetCategoriesByRootID(ByVal RootId As Integer, Optional ByVal active As Boolean = True, Optional ByVal IsPublic As Boolean = False) As SqlDataSource
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim sqlDS1 As SqlDataSource = New SqlDataSource
        Dim sActive As String = ""
        If active Then
            sActive = "active=1 and "
            If IsPublic Then
                sActive = "active=1 and private=0 and"
            End If
        End If

        sqlDS1.ConnectionString = sConn
        sqlDS1.SelectCommand = "select * from newsletters_categories where " & sActive & "  (root_id=" & RootId & " or root_id is null)"
        Return sqlDS1
    End Function

    Public Shared Function GetCategoriesByNewsId(ByVal NewsId As Integer) As Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        Dim colCategories As Collection = New Collection
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "SELECT a.* FROM newsletters_categories a right join (SELECT category_id FROM newsletters_map WHERE newsletter_id=@news_id) as b on a.category_id=b.category_id"
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId
        oConn.Open()
        reader = sqlCmd.ExecuteReader
        While reader.Read
            Dim Category As Category = New Category
            Category.CategoryId = reader("category_id")
            Category.Title = reader("category")
            Category.RootId = reader("root_id")
            Category.Active = reader("active")
            Category.IsPrivate = reader("private")
            colCategories.Add(Category)
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return colCategories
    End Function

    Public Shared Sub DeleteCategory(ByVal CategoryId As Integer)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = " DELETE newsletters_categories where category_id=@category_id ;DELETE newsletters_map where category_id=@category_id ; " & _
                             " Update newsletters_subscribers set unsubscribe=1 where category_id=@category_id "
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = CategoryId
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Sub InsertCategory(ByVal Category As Category)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "insert into newsletters_categories (category,active,root_id,private) " & _
           "values (@category,@active,@root_id,@private) "
        sqlCmd.Parameters.Add("@category", SqlDbType.NVarChar).Value = Category.Title
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Category.RootId
        sqlCmd.Parameters.Add("@active", SqlDbType.Bit).Value = Category.Active
        sqlCmd.Parameters.Add("@private", SqlDbType.Bit).Value = Category.IsPrivate
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Sub InsertNewsletterMap(ByVal NewsId As Integer, ByVal CategoryId As Integer)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = " insert into newsletters_map (newsletter_id,category_id) values (@news_id,@category_id)"
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = CategoryId
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub


    '#################### 
    'Subscription
    '####################
    Public Shared Function GetSubscription(ByVal Email As String) As Collection
        Dim colCategoryId As Collection = New Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "select * from newsletters_subscribers where email=@email and unsubscribe=0 and status=1"
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        Dim i As Integer = 0
        While reader.Read
            i += 1
            Dim oSubscription As Subscription = New Subscription
            oSubscription.CategoryId = (reader("category_id"))
            If Not IsDBNull(reader("date_registered")) Then
                oSubscription.DateRegistered = (reader("date_registered"))
            End If
            oSubscription.Email = (reader("email"))
            oSubscription.Name = (reader("name"))
            oSubscription.Status = (reader("status"))
            oSubscription.Unssubscribe = (reader("unsubscribe"))
            colCategoryId.Add(oSubscription)
            oSubscription = Nothing
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        If i = 0 Then
            colCategoryId = Nothing
        End If
        Return colCategoryId
    End Function

    Public Shared Function CheckSubscription(ByVal Email As String, ByVal CategoryID As Integer) As Subscription
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "select * from newsletters_subscribers where email=@email and category_id=@category_id"
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = CategoryID
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        Dim oSubscription As Subscription = New Subscription
        Dim i As Integer = 0
        While reader.Read
            i += 1
            oSubscription.CategoryId = (reader("category_id"))
            If Not IsDBNull(reader("date_registered")) Then
                oSubscription.DateRegistered = (reader("date_registered"))
            End If
            oSubscription.Email = (reader("email"))
            oSubscription.Name = (reader("name"))
            oSubscription.Status = (reader("status"))
            oSubscription.Unssubscribe = (reader("unsubscribe"))
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        If i = 0 Then
            oSubscription = Nothing
        End If
        Return oSubscription
    End Function

    Public Shared Function GetSubscriberInfo(ByVal Email As String) As Collection
        Dim colInfo As Collection = New Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "select * from newsletters_subscribers where email=@email"
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        Dim i As Integer = 0
        While reader.Read
            i += 1
            Dim oSubscription As Subscription = New Subscription
            oSubscription.CategoryId = (reader("category_id"))
            If Not IsDBNull(reader("date_registered")) Then
                oSubscription.DateRegistered = (reader("date_registered"))
            End If
            oSubscription.Email = (reader("email"))
            oSubscription.Name = (reader("name"))
            oSubscription.Status = (reader("status"))
            oSubscription.Unssubscribe = (reader("unsubscribe"))
            colInfo.Add(oSubscription)
            oSubscription = Nothing
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        If i = 0 Then
            colInfo = Nothing
        End If
        Return colInfo
    End Function

    Public Shared Sub UpdateSubscription(ByVal oldEmail As String, ByVal Email As String, ByVal CategoryID As Integer, ByVal Unsubscribe As Boolean, Optional ByVal Status As Boolean = True)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "UPDATE newsletters_subscribers SET email=@email, status=@status, unsubscribe=@unsubscribe where email=@oldEmail AND category_id=@category_id "
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        sqlCmd.Parameters.Add("@oldEmail", SqlDbType.NVarChar).Value = oldEmail
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = CategoryID
        sqlCmd.Parameters.Add("@status", SqlDbType.Bit).Value = Status
        sqlCmd.Parameters.Add("@unsubscribe", SqlDbType.Bit).Value = Unsubscribe
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Sub ActivateSubscriber(ByVal Email As String)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "UPDATE newsletters_subscribers  set status =1 WHERE email=@email"
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Sub AddSubscriber(ByVal sUserName As String, ByVal sEmail As String, ByVal nCategoryId As Integer, ByVal Unsubscribe As Boolean, Optional ByVal Status As Boolean = True)
        'If Not IsNothing(GetUserNameByEmail(sEmail)) Then
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "INSERT INTO newsletters_subscribers (name,email,category_id,status,unsubscribe,date_registered) values (@name,@email,@category_id,@status,@unsubscribe,getdate())"
        sqlCmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = sUserName
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = sEmail
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = nCategoryId
        sqlCmd.Parameters.Add("@status", SqlDbType.Bit).Value = Status
        sqlCmd.Parameters.Add("@unsubscribe", SqlDbType.Bit).Value = Unsubscribe
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
        'End If
    End Sub

    Public Shared Sub UnSubscribe(ByVal Email As String)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "UPDATE newsletters_subscribers set unsubscribe=1 where email=@email "
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Function ListSubscribers(ByVal CategoryID As Integer) As Boolean
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        Dim Delete As Boolean = True
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "Select * from newsletters_subscribers where category_id=@category_id and unsubscribe=0 and status=1"
        sqlCmd.Parameters.Add("@category_id", SqlDbType.Int).Value = CategoryID
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        While reader.Read
            Delete = False
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return Delete

    End Function

    '###############
    ' Receipients 
    '###############
    Public Shared Function GetReceipients(ByVal NewsId As Integer, Optional ByVal Status As Boolean = False, Optional ByVal Rows As String = "100 percent") As Collection
        Dim Receipients As Collection = New Collection
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        If Status Then
            sqlCmd.CommandText = "select DISTINCT top " & Rows & " newsletters_id,email,status from newsletters_receipients where newsletters_id=@news_id and status='0'"
        Else
            sqlCmd.CommandText = "select DISTINCT top " & Rows & " newsletters_id,email,status from newsletters_receipients where newsletters_id=@news_id"
        End If
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        While reader.Read
            Dim oReceipient As Receipient = New Receipient
            oReceipient.Status = (reader("status"))
            oReceipient.Email = (reader("email"))
            oReceipient.NewsletterId = (reader("newsletters_id"))
            Receipients.Add(oReceipient)
            oReceipient = Nothing
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return Receipients
    End Function

    Public Shared Sub UpdateReceipients(ByVal NewsId As Integer, ByVal Email As String, ByVal Status As String)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "update newsletters_receipients set status=@status where newsletters_id=@news_id and email=@email"
        sqlCmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = Email
        sqlCmd.Parameters.Add("@news_id", SqlDbType.Int).Value = NewsId
        sqlCmd.Parameters.Add("@status", SqlDbType.NVarChar).Value = Status
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    '##########
    ' Setting
    '##########

    Public Shared Sub CreateSetting(ByVal Setting As NewsletterSetting)
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "delete newsletters_settings where root_id=@root_id ; insert into newsletters_settings (confirmation_subject,confirmation_body,unsubscribe_signature,unsubscribe_signature_text,root_id) values (@confirmation_subject,@confirmation_body,@unsubscribe_signature,@unsubscribe_signature_text,@root_id) "
        sqlCmd.Parameters.Add("@unsubscribe_signature", SqlDbType.NText).Value = Setting.UnsubscribeSignature
        sqlCmd.Parameters.Add("@unsubscribe_signature_text", SqlDbType.NText).Value = Setting.UnsubscribeSignatureText
        sqlCmd.Parameters.Add("@confirmation_subject", SqlDbType.NText).Value = Setting.ConfirmationSubject
        sqlCmd.Parameters.Add("@confirmation_body", SqlDbType.NText).Value = Setting.ConfirmationBody
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = Setting.RootId
        oConn.Open()
        sqlCmd.ExecuteNonQuery()
        sqlCmd.Dispose()
        oConn.Close()
    End Sub

    Public Shared Function GetSetting(ByVal RootID As Integer) As NewsletterSetting
        Dim sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim sqlCmd As SqlCommand
        Dim reader As SqlDataReader
        Dim Setting As NewsletterSetting = New NewsletterSetting
        sqlCmd = New SqlCommand
        sqlCmd.Connection = oConn
        sqlCmd.CommandType = CommandType.Text
        sqlCmd.CommandText = "select * from newsletters_settings where root_id=@root_id"
        sqlCmd.Parameters.Add("@root_id", SqlDbType.Int).Value = RootID
        oConn.Open()
        reader = sqlCmd.ExecuteReader()
        While reader.Read
            Setting.ConfirmationSubject = reader("confirmation_subject")
            Setting.ConfirmationBody = reader("confirmation_body").ToString
            Setting.UnsubscribeSignature = reader("unsubscribe_signature").ToString
            Setting.UnsubscribeSignatureText = reader("unsubscribe_signature_text")
            Setting.RootId = reader("root_id")
        End While
        reader.Close()
        sqlCmd.Dispose()
        oConn.Close()
        Return Setting
    End Function

    Public Shared Function IDEncode(ByVal text As String) As String
        Dim sOut As String = ""
        Try
            sOut = Convert.ToBase64String(System.Text.Encoding.Default.GetBytes(text))
        Catch ex As Exception
        End Try
        Return sOut
    End Function

    Public Shared Function IDDecode(ByVal text As String) As String
        Dim sOut As String = ""
        Try
            sOut = System.Text.Encoding.Default.GetString(Convert.FromBase64String(text))
        Catch ex As Exception
        End Try
        Return sOut
    End Function
   
End Class