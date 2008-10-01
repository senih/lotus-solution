Imports System.Data
Imports System.Data.Sql
Imports System.Data.sqlClient
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.Security
Imports System.Web.Security.Roles
Imports System.Web.Security.Membership
Imports System.Net.Mail

Partial Class modules_forum
    Inherits BaseUserControl

    Private Const TP_FORUM As String = "F"
    Private Const TP_THREAD As String = "T"
    Private Const TP_REPLY As String = "R"
    Private Const TP_QUOTE As String = "Q"
    Private Const TP_ABUSE As String = "A"

    Private Const ST_LOCKED As String = "locked"
    Private Const ST_UNLOCKED As String = "unlocked"

    Private sConn As String
    Private oConn As SqlConnection

    Private strAppPath As String

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        If (oConn IsNot Nothing AndAlso oConn.State = ConnectionState.Open) Then
            oConn.Close()
        End If
        oConn = Nothing
    End Sub

    Public Function GetDiscussionRecord(ByVal subjectId As Decimal) As SqlDataReader
        'Dim oConn As New SqlConnection(sConn)
        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sSQL As String = "Select * from discussion where subject_id=@subject_id and page_id=@page_id"
        
        Dim oCommand As New SqlCommand(sSQL)
        oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = subjectId
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = me.PageID
        oCommand.Connection = oConn
        Return oCommand.ExecuteReader(CommandBehavior.CloseConnection)
    End Function

    Public Function GetUsersStats(ByVal userName As String) As Decimal
        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sSQL As String = "Select count(*) as user_posts from discussion where type in ('T', 'R', 'Q') and posted_by=@posted_by and page_id=@page_id"
        Dim oCommand As New SqlCommand(sSQL)
        oCommand.Parameters.Add("@posted_by", SqlDbType.VarChar, 64).Value = userName
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = me.PageID
        
        oCommand.Connection = oConn
        Dim dr As SqlDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)
        dr.Read()

        Dim posts As Decimal = Convert.ToDecimal(dr("user_posts"))
        dr.Close()
        oConn.Close()

        Return posts
    End Function

    Public Function GetUsersPic(ByVal userName As String) As String
        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sSQL As String = "Select fileurl from membership_add where user_name=@user_name"
        Dim oCommand As New SqlCommand(sSQL)
        oCommand.Parameters.Add("@user_name", SqlDbType.VarChar, 64).Value = userName

        oCommand.Connection = oConn
        Dim dr As SqlDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)

        Dim fName As String = ""
        If (dr.Read()) Then
            fName = dr("fileurl")
        End If

        dr.Close()
        oConn.Close()

        Return fName
    End Function

    Private Sub CreateDiscussion(ByVal parentId As Decimal, _
        ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal type As String, _
        ByVal noReply As Boolean, _
        ByVal reply_to As Decimal, _
        ByVal status As String)

        Dim oCmd As SqlCommand = New SqlCommand("advcms_CreateDiscussion")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@parent_id", SqlDbType.Decimal).Value = parentId
        oCmd.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = Server.HtmlEncode(subject)
        oCmd.Parameters.Add("@message", SqlDbType.NText).Value = message
        oCmd.Parameters.Add("@posted_by", SqlDbType.NVarChar, 128).Value = GetUser.UserName
        oCmd.Parameters.Add("@posted_date", SqlDbType.DateTime).Value = Now
        oCmd.Parameters.Add("@category", SqlDbType.NVarChar, 128).Value = category
        oCmd.Parameters.Add("@type", SqlDbType.Char, 1).Value = type
        oCmd.Parameters.Add("@noreply", SqlDbType.Bit).Value = noReply
        oCmd.Parameters.Add("@reply_to", SqlDbType.Decimal).Value = reply_to
        oCmd.Parameters.Add("@last_post_id", SqlDbType.Decimal).Value = 0
        oCmd.Parameters.Add("@status", SqlDbType.VarChar, 16).Value = status
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = me.PageID

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
    End Sub

    Public Sub CreateForum(ByVal parentId As Decimal, _
        ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal defaultStatus As String)

        CreateDiscussion(parentId, subject, message, category, TP_FORUM, False, 0, defaultStatus)
    End Sub

    Public Sub CreateThread(ByVal parentId As Decimal, _
        ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal noReply As Boolean, _
        ByVal defaultStatus As String)
        CreateDiscussion(parentId, subject, message, category, TP_THREAD, noReply, 0, defaultStatus)
    End Sub

    Public Sub CreateReply(ByVal parentId As Decimal, _
        ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal noReply As Boolean, _
        ByVal replyTo As Decimal)
        CreateDiscussion(parentId, subject, message, category, TP_REPLY, noReply, replyTo, ST_UNLOCKED)
    End Sub

    Public Sub CreateQuote(ByVal parentId As Decimal, _
        ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal noReply As Boolean, _
        ByVal replyTo As Decimal)
        CreateDiscussion(parentId, subject, message, category, TP_QUOTE, noReply, replyTo, ST_UNLOCKED)
    End Sub

    Public Sub CreateAbuse(ByVal parentId As Decimal, _
    ByVal subject As String, _
    ByVal message As String, _
    ByVal category As String, _
    ByVal noReply As Boolean, _
    ByVal replyTo As Decimal)

        'send email to administrator
        Dim users() As String = GetUsersInRole("Administrators")
        Dim mailTo(UBound(users)) As String
        Dim i As Integer
        For i = 0 To UBound(users)
            mailTo(i) = GetUser(users(i)).Email
        Next i

        Dim path As String = Me.AppFullPath
        If Not path.EndsWith("/") Then
            path = path & "/"
        End If
 
        Dim msg As New StringBuilder("")
        msg.AppendLine("<p>" & GetLocalResourceObject("litEmailReportBy") & "&nbsp;" & GetUser().UserName & "</p>")
        msg.AppendLine("<p>" & GetLocalResourceObject("litEmailMessageId") & "&nbsp;" & replyTo & "&nbsp;(<a href='" & path & GetCurrentPage() & "?did=" & parentId & "'>" & GetLocalResourceObject("litEmailViewMessage") & "</a>)</p>")
        msg.AppendLine("<p>" & GetLocalResourceObject("litEmailMessage") & "&nbsp;" & "</p>")
        msg.AppendLine("<div>" & message & "</div>")

        SendMail(Nothing, mailTo, subject, msg.ToString)
    End Sub

    Public Sub EditForum(ByVal subjectId As Decimal, ByVal subject As String, _
        ByVal message As String, _
        ByVal category As String, _
        ByVal status As String)

        'Dim oConn As New SqlConnection(sConn)
        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sql As String = "update discussion set subject=@subject, message=@message, category=@category, status=@status where subject_id=@subject_id "

        Dim oCommand As New SqlCommand(sql)
        oCommand.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = Server.HtmlEncode(subject)
        oCommand.Parameters.Add("@message", SqlDbType.NText).Value = message
        oCommand.Parameters.Add("@category", SqlDbType.NVarChar, 64).Value = category
        oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = subjectId
        oCommand.Parameters.Add("@status", SqlDbType.VarChar, 16).Value = status

        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()

        oConn.Close()
    End Sub

    Public Sub EditThread(ByVal subjectId As Decimal, ByVal subject As String, _
        ByVal message As String, ByVal status As String)

        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sql As String = "update discussion set subject=@subject, message=@message where subject_id=@subject_id "

        Dim oCommand As New SqlCommand(sql)
        oCommand.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = Server.HtmlEncode(subject)
        oCommand.Parameters.Add("@message", SqlDbType.NText).Value = message
        oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = subjectId
        oCommand.Parameters.Add("@status", SqlDbType.VarChar, 16).Value = status

        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()

        oConn.Close()
    End Sub

    Public Sub EditReply(ByVal subjectId As Decimal, ByVal subject As String, _
        ByVal message As String, ByVal noReply As Boolean)

        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sql As String = "update discussion set subject=@subject, message=@message, noreply=@noreply where subject_id=@subject_id "

        Dim oCommand As New SqlCommand(sql)
        oCommand.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = Server.HtmlEncode(subject)
        oCommand.Parameters.Add("@message", SqlDbType.NText).Value = message
        oCommand.Parameters.Add("@noreply", SqlDbType.Bit).Value = noReply
        oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = subjectId

        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()

        oConn.Close()
    End Sub

    Public Sub EditQuote(ByVal subjectId As Decimal, ByVal subject As String, _
        ByVal message As String, ByVal noReply As Boolean)

        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sql As String = "update discussion set subject=@subject, message=@message, noreply=@noreply where subject_id=@subject_id "

        Dim oCommand As New SqlCommand(sql)
        oCommand.Parameters.Add("@subject", SqlDbType.NVarChar, 255).Value = Server.HtmlEncode(subject)
        oCommand.Parameters.Add("@message", SqlDbType.NText).Value = message
        oCommand.Parameters.Add("@noreply", SqlDbType.Bit).Value = noReply
        oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = subjectId

        oCommand.Connection = oConn
        oCommand.ExecuteNonQuery()

        oConn.Close()
    End Sub

    Public Sub DeleteDiscussion(ByVal subjectId As Decimal)

        Dim oCmd As SqlCommand = New SqlCommand("advcms_DeleteDiscussion")
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add("@current", SqlDbType.Decimal).Value = subjectId

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
    End Sub

    Private Function isAdmin() As Boolean
        If GetUser() Is Nothing Then Return False

        If IsUserInRole(GetUser.UserName, "Administrators") Then
            Return True
        End If
        Return False
    End Function

    Private Sub LoadCategories()
        If (oConn.State = ConnectionState.Closed) Then
            oConn.Open()
        End If

        Dim sSQL As String = "Select distinct category from discussion where type='F' and page_id=" & me.PageID 
        Dim oCommand As New SqlCommand(sSQL, oConn)
        Dim Cat As SqlDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)

        While Cat.Read
            ddCategory.Items.Add(New ListItem(Cat("category"), Cat("category")))
        End While
        ddCategory.Items.Add(New ListItem(GetLocalResourceObject("optNewCat"), "NEWCAT"))

        Cat.Close()
        oConn.Close()
    End Sub

    Protected Function GetCurrentPage() As String
        Return HttpContext.Current.Items("_page")
    End Function

    Protected Function NVL(ByVal obj As Object, ByVal repVal As String) As String
        If (IsDBNull(obj)) Then Return repVal
        Return obj.ToString
    End Function

    Protected Function CutText(ByVal s As String, ByVal c As Integer, ByVal addText As String) As String
        If s.Length <= c Then Return s
        Return (s.Substring(0, c) + addText)
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lnkLoginHere.NavigateUrl = Me.AppPath & Me.LinkLogin & "?ReturnUrl=" & HttpContext.Current.Items("_page")
        lnkRegisterHere.NavigateUrl = Me.AppPath & Me.LinkRegistration & "?ReturnUrl=" & HttpContext.Current.Items("_page")
        If Not Me.IsUserLoggedIn Then
            pnlRegisterAndLogin.Visible = True
        End If

        'load dropdown list item
        pnlSearchResult.Visible = False
        If Not IsPostBack Then
            Dim dId As String = Request.QueryString("did")
            Dim mode As String = Request.QueryString("mode")

            pnlViewForum.Visible = False
            pnlReplies.Visible = False
            pnlViewThreads.Visible = False
            pnlCreateDiscussion.Visible = False
            pnlDeleteDiscussion.Visible = False

            If mode <> "" Then
                If GetUser() Is Nothing Then Response.Redirect(GetCurrentPage)

                If mode = "crt" Then
                    LoadCreateDiscussionForm()
                ElseIf mode = "edt" Then
                    LoadEditDiscussionForm(dId)
                ElseIf mode = "del" Then
                    DeleteDiscussionForm(dId)
                End If

            ElseIf dId <> "" Then 'mode="", load forum or thread/topic
                'load record
                Dim disc As SqlDataReader = GetDiscussionRecord(dId)
                disc.Read()
                Dim sType As String = disc("type").ToString
                disc.Close()
                Select Case sType
                    Case TP_FORUM
                        LoadForum(dId)
                    Case TP_THREAD
                        LoadThread(dId)
                End Select
            Else
                'display discussion, initial page, no parameters
                pnlViewForum.Visible = True
            End If
        End If

        strAppPath = (Context.Request.ApplicationPath)
        If (Not strAppPath.EndsWith("/")) Then
            strAppPath = strAppPath & "/"
        End If
        txtMessage.scriptPath = strAppPath & "systems/editor/scripts/"
    End Sub

    Private Sub LoadCreateDiscussionForm()
        hfSubjectId.Value = Request.QueryString("prn")
        hfType.Value = Request.QueryString("type")
        ''display create discussion form
        pnlCategory.Visible = False
        pnlNoRelply.Visible = False
        pnlStatus.Visible = False
        Select Case hfType.Value
            Case TP_FORUM
                LoadCategories()
                ddCategory.SelectedValue = Request.QueryString("cat")
                pnlCategory.Visible = True
                pnlStatus.Visible = True
            Case TP_THREAD
                pnlStatus.Visible = True
            Case TP_REPLY, TP_QUOTE
                pnlNoRelply.Visible = True

                hfReplyTo.Value = Request.QueryString("rpt")

                Dim rd As SqlDataReader = GetDiscussionRecord(hfSubjectId.Value)
                If (rd.Read) Then
                    txtSubject.Text = GetLocalResourceObject("litReply") & rd("subject")
                    If (hfType.Value = TP_QUOTE) Then
                        'load content
                        rd.Close()
                        rd = GetDiscussionRecord(hfReplyTo.Value)
                        If rd.Read Then
                            txtMessage.Text = "<div style='border:#d7d7d7 1px dotted;padding:5px'>" & rd("message").ToString() & "</div><br><hr><br>"
                        End If
                    End If
                End If
                rd.Close()
            Case TP_ABUSE
                hfReplyTo.Value = Request.QueryString("rpt")
                Dim rd As SqlDataReader = GetDiscussionRecord(hfSubjectId.Value)
                If (rd.Read) Then
                    txtSubject.Text = GetLocalResourceObject("litAbuse") & rd("subject")
                    rd.Close()
                    rd = GetDiscussionRecord(hfReplyTo.Value)
                    If rd.Read Then
                        txtMessage.Text = "<div style='border:#d7d7d7 1px dotted;padding:5px'>" & rd("message").ToString() & "</div><br><hr><br>"
                    End If
                End If
                rd.Close()
        End Select
        txtMessage.Css = Me.AppPath & "templates/" & Me.TemplateFolderName & "/editing.css"
        If Profile.UseAdvancedEditor Then
            txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Advance
            lnkQuickEdit.Visible = True
            lnkAdvEdit.Visible = False
        Else
            txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Quick
            lnkQuickEdit.Visible = False
            lnkAdvEdit.Visible = True
        End If

        pnlCreateDiscussion.Visible = True
        btnUpdate.Visible = False
        btnCreate.Visible = True
    End Sub

    Private Sub LoadEditDiscussionForm(ByVal dId As String)
        Dim disc As SqlDataReader = GetDiscussionRecord(dId)
        disc.Read()
        Dim cat As String = disc("category").ToString
        Dim status As String = disc("status").ToString
        Dim noReply As Boolean = Convert.ToBoolean(disc("noreply"))
        Dim subject As String = disc("subject").ToString
        Dim message As String = disc("message").ToString()
        Dim type As String = disc("type").ToString
        Dim parent As Decimal = Convert.ToDecimal(disc("parent_id"))
        disc.Close()

        hfSubjectId.Value = dId
        hfType.Value = type
        hfParentId.Value = parent

        ''display create discussion form
        pnlCategory.Visible = False
        pnlNoRelply.Visible = False
        pnlStatus.Visible = False
        Select Case hfType.Value
            Case TP_FORUM
                LoadCategories()
                ddCategory.SelectedValue = cat
                pnlCategory.Visible = True
                ddStatus.SelectedValue = status
                pnlStatus.Visible = True
            Case TP_THREAD
                ddStatus.SelectedValue = status
                pnlStatus.Visible = True
            Case TP_REPLY, TP_QUOTE
                pnlNoRelply.Visible = True
                cbNoReply.Checked = noReply
        End Select
        txtSubject.Text = subject
        txtMessage.Text = message
        txtMessage.Css = Me.AppPath & "templates/" & Me.TemplateFolderName & "/editing.css"
        If Profile.UseAdvancedEditor Then
            txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Advance
            lnkQuickEdit.Visible = True
            lnkAdvEdit.Visible = False
        Else
            txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Quick
            lnkQuickEdit.Visible = False
            lnkAdvEdit.Visible = True
        End If

        pnlCreateDiscussion.Visible = True
        btnUpdate.Visible = True
        btnCreate.Visible = False
    End Sub

    Private Sub DeleteDiscussionForm(ByVal dId As String)
        Dim disc As SqlDataReader = GetDiscussionRecord(dId)
        disc.Read()
        Dim sSubject As String = disc("subject")
        hfSubjectId.Value = dId
        hfType.Value = disc("type").ToString
        hfParentId.Value = Convert.ToDecimal(disc("parent_id"))
        disc.Close()

        Select Case hfType.Value
            Case TP_FORUM
                litDelDiscussion.Text = "Are you sure to delete forum: """ & sSubject & """ ?" & vbCrLf & _
                    "Deleting the forum will also delete all the posts in this forum. "
            Case TP_THREAD
                litDelDiscussion.Text = "Are you sure to delete topic: """ & sSubject & """ ?" & vbCrLf & _
                    "Deleting the topic will also delete all the posts in this topic. "
            Case TP_REPLY
                litDelDiscussion.Text = "Are you sure to delete reply: """ & sSubject & """ ?" & vbCrLf & _
                    "This operation cannot be undone. "
            Case TP_QUOTE
                litDelDiscussion.Text = "Are you sure to delete quote: """ & sSubject & """ ?" & vbCrLf & _
                    "This operation cannot be undone. "
        End Select

        pnlDeleteDiscussion.Visible = True
    End Sub

    ''Open forum containing threads
    Private Sub LoadForum(ByVal forumId As Decimal, Optional ByVal countViewed As Boolean = True)
        Dim currPage As String = GetCurrentPage()

        Dim forum As SqlDataReader = GetDiscussionRecord(forumId)
        forum.Read()
        Dim frmStatus As String = forum("status").ToString()
        Dim frmSubject As String = forum("subject").ToString()
        Dim frmMessage As String = forum("message").ToString()
        Dim frmViewed As String = Convert.ToInt32(NVL(forum("viewed"), "0"))
        forum.Close()

        If (isAdmin()) Then
            litEditForum.Text = "<a href=""" & currPage & "?mode=edt&did=" & forumId & """>" & GetLocalResourceObject("lnkEdit") & "</a>"
            litDeleteForum.Text = "<a href=""" & currPage & "?mode=del&did=" & forumId & """>" & GetLocalResourceObject("lnkDelete") & "</a>"
        End If

        If (GetUser() IsNot Nothing And frmStatus <> ST_LOCKED) Then
            litNewThread.Text = "<a href=""" & currPage & "?mode=crt&type=T&prn=" & forumId & "&rpt=0" & """>" & GetLocalResourceObject("lnkNewThread") & "</a>"
        End If

        'path
        litFrmPath.Text = "<a href=""" & currPage & """>" & GetLocalResourceObject("litForumIndex") & "</a> / " & frmSubject

        lblForumTitle.Text = frmSubject
        lblForumDesc.Text = frmMessage
        dsThreads.SelectCommand = "select t1.* , t2.replies, t3.last_post_date, t3.last_post_by, t3.last_post_subject from discussion as t1 " & _
            "left join (select parent_id, count(*) as replies from discussion where type in ('R', 'Q') group by parent_id) as t2 on t1.subject_id=t2.parent_id " & _
            "left join (select subject_id, posted_date as last_post_date, posted_by as last_post_by, subject as last_post_subject from discussion) as t3 on t1.last_post_id=t3.subject_id " & _
            "WHERE t1.parent_id=@parent_id order by t1.posted_date desc "
        dsThreads.SelectParameters("parent_id").DefaultValue = forumId
        grdThreads.DataBind()
        hfSubjectId.Value = forumId

        'update viewed
        Dim sSql As String
        Dim oCommand As SqlCommand
        If countViewed Then
            oConn.Open()
            sSql = "update discussion set viewed=(isnull(viewed, 0) + 1) where subject_id=@subject_id"
            oCommand = New SqlCommand(sSql, oConn)
            oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = forumId
            oCommand.ExecuteNonQuery()
            oConn.Close()
        End If

        'forum status box
        If frmStatus = ST_LOCKED Then
            litForumStatus.Text = "<span style='font-weight:bold'>" & GetLocalResourceObject("statusLocked") & ".</span>"
        Else
            litForumStatus.Text = "<span style='font-weight:bold'>" & GetLocalResourceObject("statusUnlocked") & ".</span>"
        End If

        oConn.Open()
        sSQL = "select t1.threads, t2.posts from " & _
            "(select count(*) as threads from discussion where parent_id=@parent_id) as t1, " & _
            "(select count(*) as posts from discussion where parent_id in (select subject_id from discussion where parent_id=@parent_id)) as t2 "
        oCommand = New SqlCommand(sSQL, oConn)
        oCommand.Parameters.Add("@parent_id", SqlDbType.Decimal).Value = forumId
        Dim dr As SqlDataReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)

        If dr.Read Then
            litForumTopics.Text = NVL(dr("threads"), "0")
            litForumPosts.Text = NVL(dr("posts"), "0")
        Else
            litForumTopics.Text = "0"
            litForumPosts.Text = "0"
        End If
        dr.Close()
        oConn.Close()

        litForumViewed.Text = frmViewed
      
        pnlViewThreads.Visible = True
        pnlViewForum.Visible = False
        pnlCreateDiscussion.Visible = False
        pnlReplies.Visible = False
        
    End Sub

    ''Open thread containing replies
    Private Sub LoadThread(ByVal threadId As Decimal, Optional ByVal coundViewed As Boolean = True)
        Dim currPage As String = GetCurrentPage()

        Dim thread As SqlDataReader = GetDiscussionRecord(threadId)
        thread.Read()
        Dim thrSubject As String = thread("subject").ToString
        Dim thrParent As Decimal = Convert.ToDecimal(thread("parent_id"))
        Dim thrPostedBy As String = thread("posted_by").ToString
        Dim thrPostedDate As DateTime = Convert.ToDateTime(thread("posted_date"))
        Dim thrMessage As String = thread("message").ToString()
        Dim thrStatus As String = thread("status").ToString
        thread.Close()

        litThreadId.Text = threadId
        lblThreadTitle.Text = thrSubject
        litThreadHeader.Text = thrPostedDate.ToString

        Dim userPosts As Decimal = GetUsersStats(thrPostedBy)
        Dim userPic As String = GetUsersPic(thrPostedBy)

        Dim poster As MembershipUser = GetUser(thrPostedBy)
        Dim creationDate As String = ""
        If poster IsNot Nothing Then
            creationDate = poster.CreationDate.ToShortDateString
        End If

        Dim sb As StringBuilder = New StringBuilder()
        If (userPic <> "") Then
            sb.Append("<img src=""" & strAppPath & "resources/photos/" & userPic & """ /><br><br>")
        End If
        sb.Append("<span style=""font-weight:bold"">" & thrPostedBy & "</span>")
        sb.Append("<br><br><span style="""">Joined: " & creationDate & "</span>")
        sb.Append("<br><br><span style="""">Posts: " & userPosts & "</span>")

        litThreadInfo.Text = sb.ToString()
        litThreadSubject.Text = _
            "<div style=""font-size:12px;font-weight:bold"">" & thrSubject & "</div>"

        'path
        Dim forum As SqlDataReader = GetDiscussionRecord(thrParent)
        forum.Read()
        Dim frmStatus As String = forum("status").ToString
        litThreadPath.Text = "<a href=""" & currPage & """>" & GetLocalResourceObject("litForumIndex") & "</a> / <a href=""" & currPage & "?did=" & forum("subject_id") & """>" & CutText(forum("subject"), 35, "...") & "</a> / " & CutText(thrSubject, 35, "...")
        forum.Close()

        sb = New StringBuilder(litThreadSubject.Text)
        If (GetUser() IsNot Nothing) Then
            sb.Append("<br><div align=""right"">")
            sb.Append("<a href=""" & currPage & "?mode=crt&type=A&prn=" & threadId & "&rpt=" & threadId & """>" & GetLocalResourceObject("lnkAbuse") & "</a>")
            If (isAdmin() Or (thrPostedBy = GetUser.UserName AndAlso thrStatus <> ST_LOCKED)) Then
                sb.Append("&nbsp;&nbsp;<a href=""" & currPage & "?mode=edt&did=" & threadId & """>" & GetLocalResourceObject("lnkEdit") & "</a>&nbsp;")
                sb.Append("<a href=""" & currPage & "?mode=del&did=" & threadId & """>" & GetLocalResourceObject("lnkDelete") & "</a>")
            End If
            If (thrStatus <> ST_LOCKED) Then
                sb.Append("&nbsp;&nbsp;<a href=""" & currPage & "?mode=crt&type=R&prn=" & threadId & "&rpt=" & threadId & """>" & GetLocalResourceObject("lnkReply") & "</a>&nbsp;")
                sb.Append("<a href=""" & currPage & "?mode=crt&type=Q&prn=" & threadId & "&rpt=" & threadId & """>" & GetLocalResourceObject("lnkQuote") & "</a>")
            End If
            If (frmStatus <> ST_LOCKED) Then
                litNewThread2.Text = "<a href=""" & currPage & "?mode=crt&type=T&prn=" & thrParent & "&rpt=0" & """>" & GetLocalResourceObject("lnkNewThread") & "</a>"
            End If
            sb.Append("</div>")
        End If
        litThreadSubject.Text = sb.ToString

        litThreadMessage.Text = thrMessage

        dsReplies.SelectCommand = "select t1.*, t2.user_posts, '" & thrStatus & "' as FR_STATUS, isnull(t3.fileurl,'') as fileurl from discussion as t1 " & _
            "left join (select count(*) as user_posts, posted_by from discussion where type in ('R', 'T', 'Q') group by posted_by) as t2 on t1.posted_by=t2.posted_by " & _
            "left join membership_add as t3 on t1.posted_by=t3.user_name " & _
            "WHERE t1.parent_id=@parent_id order by t1.posted_date desc "
        dsReplies.SelectParameters("parent_id").DefaultValue = threadId
        grdReplies.DataBind()

        hfSubjectId.Value = threadId

        'update viewed
        If coundViewed Then
            oConn.Open()
            Dim sSQL As String = "update discussion set viewed=(isnull(viewed, 0) + 1) where subject_id=@subject_id"
            Dim oCommand As New SqlCommand(sSQL, oConn)
            oCommand.Parameters.Add("@subject_id", SqlDbType.Decimal).Value = threadId
            oCommand.ExecuteReader(CommandBehavior.CloseConnection)
            oConn.Close()
        End If

        pnlViewThreads.Visible = False
        pnlViewForum.Visible = False
        pnlCreateDiscussion.Visible = False
        pnlReplies.Visible = True
        
    End Sub

    Protected Sub lnkAdvEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdvEdit.Click
        lnkAdvEdit.Visible = False
        lnkQuickEdit.Visible = True
        txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Advance
        txtMessage.Css = Me.AppPath & "templates/" & Me.TemplateFolderName & "/editing.css"
    End Sub

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        'create new forum
        Select Case hfType.Value
            Case TP_FORUM
                Dim cat As String = ddCategory.SelectedValue
                If (ddCategory.SelectedValue = "NEWCAT") Then
                    cat = txtNewCat.Text
                End If
                CreateForum(0, txtSubject.Text, txtMessage.Text, cat, ddStatus.SelectedValue)
                Response.Redirect(GetCurrentPage)
            Case TP_THREAD
                CreateThread(CDec(hfSubjectId.Value), txtSubject.Text, txtMessage.Text, "THREADS", cbNoReply.Checked, ddStatus.SelectedValue)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_REPLY
                CreateReply(CDec(hfSubjectId.Value), txtSubject.Text, txtMessage.Text, "REPLY", cbNoReply.Checked, hfReplyTo.Value)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_QUOTE
                CreateQuote(CDec(hfSubjectId.Value), txtSubject.Text, txtMessage.Text, "QUOTE", cbNoReply.Checked, hfReplyTo.Value)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_ABUSE
                CreateAbuse(CDec(hfSubjectId.Value), txtSubject.Text, txtMessage.Text, "ABUSE", cbNoReply.Checked, hfReplyTo.Value)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
        End Select
    End Sub

    'this event is fired when datasource has complete data retrieval
    Protected Sub dsRepeater_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsRepeater.Selected
        litNewForumEmpty.Visible = False
        If e.AffectedRows = 0 AndAlso isAdmin() Then
            litNewForumEmpty.Text = "<a href=""" & GetCurrentPage() & "?mode=crt&type=F&prn=0&rpt=0&cat=NEWCAT" & """>" & GetLocalResourceObject("lnkNewForum") & "</a>"
            litNewForumEmpty.Visible = True
        End If
    End Sub

    Protected Sub repCat_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles repCat.DataBinding
        dsRepeater.SelectCommand = "SELECT DISTINCT [category] FROM [discussion]WHERE TYPE='F' and page_id=@page_id"
        dsRepeater.SelectParameters("page_id").DefaultValue = me.PageID
        dsRepeater.DataBind()
    End Sub

    Protected Sub repCat_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repCat.ItemDataBound

        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim litNewForum As Literal = CType(e.Item.FindControl("litNewForum"), Literal)

            If isAdmin() Then
                litNewForum.Text = "<a href=""" & GetCurrentPage() & "?mode=crt&type=F&prn=0&rpt=0&cat=" & CType(e.Item.DataItem, DataRowView)("Category") & """>" & GetLocalResourceObject("lnkNewForum") & "</a>"
            End If

            Dim DSource As SqlDataSource = CType(e.Item.FindControl("dsForum"), SqlDataSource)
            DSource.SelectCommand = "select t1.* , t2.threads, t3.last_post_date, t3.last_post_by, t3.last_post_subject from discussion as t1 " & _
                "left join (select parent_id, count(*) as threads from discussion where type='T' group by parent_id) as t2 on t1.subject_id=t2.parent_id " & _
                "left join (select subject_id, posted_date as last_post_date, posted_by as last_post_by, subject as last_post_subject from discussion) as t3 on t1.last_post_id=t3.subject_id " & _
                "WHERE category=@category and type='F' and page_id=@page_id "
            DSource.SelectParameters("category").DefaultValue = CType(e.Item.DataItem, DataRowView)("Category")
            DSource.SelectParameters("page_id").DefaultValue = Me.PageID
            
            Dim FGrid As GridView = CType(e.Item.FindControl("grdForum"), GridView)
            AddHandler FGrid.RowDataBound, AddressOf grdForum_RowDataBound
            FGrid.DataBind()
        End If
    End Sub

    Protected Sub grdForum_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
            Dim forum As Literal = DirectCast(e.Row.FindControl("litColForum"), Literal)
            Dim lastPost As Literal = DirectCast(e.Row.FindControl("litColLastPost"), Literal)
            Dim thread As Literal = DirectCast(e.Row.FindControl("litColThread"), Literal)
            forum.Text = "<a href=""" & GetCurrentPage() & "?did=" & drv("subject_id") & """>" & drv("subject") & "</a><br>" & drv("message")
            If IsDBNull(drv("last_post_subject")) Then
                lastPost.Text = "<div align=""center"">-</div>"
            Else
                lastPost.Text = CutText(drv("last_post_subject"), 25, "...") & "<br>by " & drv("last_post_by") & "<br>" & drv("last_post_date")
            End If
            If (Not IsDBNull(drv("threads"))) Then
                thread.Text = drv("threads")
            Else
                thread.Text = "0"
            End If

        End If
    End Sub

    Protected Sub grdThreads_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdThreads.PageIndexChanged
        LoadForum(hfSubjectId.Value, False)
    End Sub

    Protected Sub grdThreads_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdThreads.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
            Dim forum As Literal = DirectCast(e.Row.FindControl("litThrThread"), Literal)
            Dim lastPost As Literal = DirectCast(e.Row.FindControl("litThrLastPost"), Literal)
            Dim viewed As Literal = DirectCast(e.Row.FindControl("litThrViewed"), Literal)
            Dim thread As Literal = DirectCast(e.Row.FindControl("litThrReplies"), Literal)
            'forum.Text = "<a href=""" & GetCurrentPage() & "?did=" & drv("subject_id") & """>" & drv("subject") & "</a><br>" & CutText(drv("message"), 50, "...")
            forum.Text = "<a href=""" & GetCurrentPage() & "?did=" & drv("subject_id") & """>" & drv("subject") & "</a><br>" & GetContent(drv("message"), 50)
            If IsDBNull(drv("last_post_subject")) Then
                lastPost.Text = "<div align=""center"">-</div>"
            Else
                lastPost.Text = CutText(drv("last_post_subject"), 25, "...") & "<br>by " & drv("last_post_by") & "<br>" & drv("last_post_date")
            End If
            If (Not IsDBNull(drv("replies"))) Then
                thread.Text = drv("replies")
            Else
                thread.Text = "0"
            End If
            If (Not IsDBNull(drv("viewed"))) Then
                viewed.Text = drv("viewed")
            Else
                viewed.Text = "0"
            End If
        End If
    End Sub

    Protected Sub grdReplies_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdReplies.PageIndexChanged
        LoadThread(hfSubjectId.Value, False)
    End Sub

    Protected Sub grdReplies_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdReplies.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
            Dim header As Literal = DirectCast(e.Row.Cells(0).FindControl("litRepliesHeader"), Literal)
            Dim replyId As Literal = DirectCast(e.Row.Cells(0).FindControl("litRepliesId"), Literal)
            Dim info As Literal = DirectCast(e.Row.Cells(0).FindControl("litRepliesUserInfo"), Literal)
            Dim subject As Literal = DirectCast(e.Row.Cells(0).FindControl("litRepliesSubject"), Literal)
            Dim message As Literal = DirectCast(e.Row.Cells(0).FindControl("litRepliesMessage"), Literal)

            WriteDiscussion(drv, header, replyId, info, subject, message)

        End If
    End Sub

    Private Sub WriteDiscussion(ByVal drv As DataRowView, ByRef header As Literal, ByRef replyId As Literal, ByRef info As Literal, ByRef subject As Literal, ByRef message As Literal)
        Dim sb As StringBuilder = New StringBuilder("")
        sb.Append(drv("posted_date"))
        header.Text = sb.ToString

        sb = New StringBuilder("")
        sb.Append(drv("subject_id"))
        If Convert.ToDouble(drv("reply_to")) <> 0 Then
            sb.Append(" to " & drv("reply_to"))
        End If
        replyId.Text = sb.ToString

        Dim poster As MembershipUser = GetUser(drv("posted_by").ToString)
        Dim creationDate As String = ""
        If poster IsNot Nothing Then
            creationDate = poster.CreationDate.ToShortDateString
        End If

        sb = New StringBuilder("")
        If (drv("fileurl") <> "") Then
            sb.Append("<img src=""" & strAppPath & "resources/photos/" & drv("fileurl") & """ /><br><br>")
        End If
        sb.Append("<span style=""font-weight:bold"">" & drv("posted_by") & "</span>")
        sb.Append("<br><br><span style="""">Joined: " & creationDate & "</span>")
        sb.Append("<br><br><span style="""">Posts: " & drv("user_posts") & "</span>")
        info.Text = sb.ToString

        sb = New StringBuilder("")
        sb.Append("<div style=""font-size:12px;font-weight:bold"">" & drv("subject") & "</div>")

        If (GetUser() IsNot Nothing) Then
            sb.Append("<br><div align=""right"">")
            sb.Append("<a href=""" & GetCurrentPage() & "?mode=crt&type=A&prn=" & drv("parent_id") & "&rpt=" & drv("subject_id") & """>" & GetLocalResourceObject("lnkAbuse") & "</a>")
            If (isAdmin() Or (drv("posted_by") = GetUser.UserName AndAlso drv("FR_STATUS").ToString <> ST_LOCKED)) Then
                sb.Append("&nbsp;&nbsp;<a href=""" & GetCurrentPage() & "?mode=edt&did=" & drv("subject_id") & """>" & GetLocalResourceObject("lnkEdit") & "</a>&nbsp;")
                sb.Append("<a href=""" & GetCurrentPage() & "?mode=del&did=" & drv("subject_id") & """>" & GetLocalResourceObject("lnkDelete") & "</a>")
            End If
            If (Convert.ToBoolean(drv("noreply")) = False AndAlso drv("FR_STATUS") <> ST_LOCKED) Then
                sb.Append("&nbsp;&nbsp;<a href=""" & GetCurrentPage() & "?mode=crt&type=R&prn=" & drv("parent_id") & "&rpt=" & drv("subject_id") & """>" & GetLocalResourceObject("lnkReply") & "</a>&nbsp;")
                sb.Append("<a href=""" & GetCurrentPage() & "?mode=crt&type=Q&prn=" & drv("parent_id") & "&rpt=" & drv("subject_id") & """>" & GetLocalResourceObject("lnkQuote") & "</a>")
            End If
            sb.Append("</div>")
        End If
        subject.Text = sb.ToString

        sb = New StringBuilder("")
        sb.Append(drv("message"))
        message.Text = sb.ToString
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Select Case hfType.Value
            Case TP_FORUM
                Response.Redirect(GetCurrentPage)
            Case TP_THREAD
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_REPLY
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_QUOTE
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_ABUSE
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
        End Select
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        'Save the changes.
        Select Case hfType.Value
            Case TP_FORUM
                Dim cat As String = ddCategory.SelectedValue
                If (ddCategory.SelectedValue = "NEWCAT") Then
                    cat = txtNewCat.Text
                End If
                EditForum(hfSubjectId.Value, txtSubject.Text, txtMessage.Text, cat, ddStatus.SelectedValue)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_THREAD
                EditThread(hfSubjectId.Value, txtSubject.Text, txtMessage.Text, ddStatus.SelectedValue)
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_REPLY
                EditReply(hfSubjectId.Value, txtSubject.Text, txtMessage.Text, cbNoReply.Checked)
                Response.Redirect(GetCurrentPage() & "?did=" & hfParentId.Value)
            Case TP_QUOTE
                EditQuote(hfSubjectId.Value, txtSubject.Text, txtMessage.Text, cbNoReply.Checked)
                Response.Redirect(GetCurrentPage() & "?did=" & hfParentId.Value)
        End Select
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        DeleteDiscussion(hfSubjectId.Value)
        If hfParentId.Value = "0" Then
            Response.Redirect(GetCurrentPage())
        Else
            Response.Redirect(GetCurrentPage() & "?did=" & hfParentId.Value)
        End If
    End Sub

    Protected Sub btnCancelDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelDelete.Click
        Select Case hfType.Value
            Case TP_FORUM, TP_THREAD
                Response.Redirect(GetCurrentPage() & "?did=" & hfSubjectId.Value)
            Case TP_REPLY, TP_QUOTE
                Response.Redirect(GetCurrentPage() & "?did=" & hfParentId.Value)
        End Select
    End Sub

    Protected Sub lnkQuickEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkQuickEdit.Click
        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False
        txtMessage.EditorType = InnovaStudio.EditorTypeEnum.Quick
        txtMessage.Css = Me.AppPath & "templates/" & Me.TemplateFolderName & "/editing.css"
    End Sub

    Private Function SendMail(ByVal maFrom As MailAddress, ByVal mailTo() As String, ByVal strSubject As String, ByVal strBody As String) As Boolean
        Dim oSmtpClient As SmtpClient = New SmtpClient
        Dim oMailMessage As MailMessage = New MailMessage

        Try
            Dim i As Integer
            For i = 0 To UBound(mailTo)
                oMailMessage.To.Add(mailTo(i))
            Next

            oMailMessage.Subject = strSubject
            oMailMessage.IsBodyHtml = True
            oMailMessage.Body = strBody

            oSmtpClient.Send(oMailMessage)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Protected Sub btnSearchForum_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearchForum.Click

        If txtSearchForum.Text = "" Then Exit Sub

        pnlViewForum.Visible = False
        pnlReplies.Visible = False
        pnlViewThreads.Visible = False
        pnlCreateDiscussion.Visible = False
        pnlDeleteDiscussion.Visible = False
        
        dsSearchForum.SelectCommand = _
            "select d2.subject_id,d2.parent_id,d2.type,d2.subject,d2.message from " & _
            "(select distinct  id=case type when 'R' then parent_id when 'Q' then parent_id  else subject_id end from discussion where page_id=" & me.PageID & " and (subject like '%" & txtSearchForum.Text & "%' or message like '%" & txtSearchForum.Text & "%')) as d1 " & _
            "left join discussion as d2 on d1.id=d2.subject_id "

        grdSearchForum.DataBind()

        pnlSearchResult.Visible = True
    End Sub

    Protected Sub grdSearchForum_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdSearchForum.PageIndexChanged
        dsSearchForum.SelectCommand = _
            "select d2.subject_id,d2.parent_id,d2.type,d2.subject,d2.message from " & _
            "(select distinct  id=case type when 'R' then parent_id when 'Q' then parent_id  else subject_id end from discussion where page_id=" & me.PageID & " and (subject like '%" & txtSearchForum.Text & "%' or message like '%" & txtSearchForum.Text & "%')) as d1 " & _
            "left join discussion as d2 on d1.id=d2.subject_id "
        grdSearchForum.DataBind()

        pnlSearchResult.Visible = True
    End Sub

    Protected Sub grdSearchForum_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdSearchForum.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)

            Dim title As Literal = DirectCast(e.Row.Cells(0).FindControl("litSearchTitle"), Literal)
            Dim content As Literal = DirectCast(e.Row.Cells(0).FindControl("litSearchContent"), Literal)

            Dim sb As StringBuilder = New StringBuilder
            sb.Append("<a href=""" & strAppPath & "forum.aspx?did=")
            If (drv("type") = "Q" Or drv("type") = "R") Then
                sb.Append(drv("parent_id"))
            Else
                sb.Append(drv("subject_id"))
            End If
            sb.Append(""">")
            sb.AppendLine(drv("subject"))
            sb.AppendLine("</a>")

            title.Text = sb.ToString
            content.Text = GetContent(drv("message"), 200)
        End If
    End Sub

    Private Function GetContent(ByVal sContent As String, ByVal length As Integer) As String
        Dim Pattern As String = "<(.|\n)*?>"
        Dim sResult As String
        Dim temp As String
        temp = Regex.Replace(sContent, Pattern, String.Empty)

        If temp.Length = 0 Then
            sResult = ""
        ElseIf temp.Length < length Then
            sResult = temp.Substring(0, temp.Length)
        Else
            sResult = temp.Substring(0, length) & " ..."
        End If

        Return sResult.Trim
    End Function
End Class
