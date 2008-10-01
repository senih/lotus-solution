<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    Dim sPath, sPathFile As String
    Dim NewsId As Integer

    Private Function GetFileName() As String
        Return HttpContext.Current.Items("_page")
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not (IsNothing(GetUser())) Then
            '~~~ Only Administrators  ~~~
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
                panelNews.Visible = True

                lnkMailingLists.NavigateUrl = "~/" & Me.LinkWorkspaceNewsLists
                lnkSettings.NavigateUrl = "~/" & Me.LinkWorkspaceNewsSettings
                lnkSubscribers.NavigateUrl = "~/" & Me.LinkWorkspaceNewsSubscribers

                SqlNewsletters.ConnectionString = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
                SqlNewsletters.SelectCommand = "select * from newsletters where root_id=" & Me.RootID & " or root_id is null order by subject"

                ' Subscribe
                lbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                lbCategories.DataBind()

                litEditorId.Controls.Add(New LiteralControl("<div id=""divEditorId"">" & txtBodyHtml.UniqueID & "</div>"))
                litEditorId.Controls.Add(New LiteralControl("<div id=""divCSSId"">" & hidCSS.UniqueID & "</div>"))
                lnkCss.Attributes.Add("onclick", "modalDialog('systems/newsletter_style.aspx?c=" & Me.Culture & "',430,380);return false;")
        
                dropInsertTag.Attributes.Add("onchange", "oUtil.obj.insertHTML(this.value)")
            End If
        Else
            panelLogin.Visible = True
            panelNews.Visible = False
        End If
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub grvNewsletters_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles grvNewsletters.PreRender
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvNewsletters.Rows.Count - 1
            CType(grvNewsletters.Rows(i).Cells(5).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    'delete newsletter
    Protected Sub grvNewsletters_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grvNewsletters.RowDeleting
        If Not Me.IsUserLoggedIn Then Exit Sub
        NewsId = grvNewsletters.DataKeys.Item(e.RowIndex).Value
        DeleteNewsletter(grvNewsletters.DataKeys.Item(e.RowIndex).Value)
        'tambahan untuk delete attachment ketika delete message
        '------------------------------------------------------
        sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId
        If System.IO.Directory.Exists(sPath) Then
            System.IO.Directory.Delete(sPath, True)
        End If

        Response.Redirect(GetFileName())
    End Sub

    'edit newsletter
    Protected Sub grvNewsletters_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles grvNewsletters.RowEditing
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim oNewsletter As Newsletter = New Newsletter
        NewsId = grvNewsletters.DataKeys.Item(e.NewEditIndex).Value
        hidNewsId.Value = NewsId
        panelNewslettersNew.Visible = True
        panelNewsletters.Visible = False
        btnSave.Visible = False
        btnUpdate.Visible = True

        hidNewslettersId.Value = NewsId
        oNewsletter = GetNewsletterById(NewsId)

        txtSubject.Text = oNewsletter.Subject
        hidCSS.Value = oNewsletter.Css

        If oNewsletter.Form = "text" Then
            panelHtml.Visible = False
            txtBodyHtml.Visible = False
            txtBodyText.Visible = True
            txtBodyText.Text = oNewsletter.Message
        Else
            panelHtml.Visible = True
            txtBodyText.Visible = False
            txtBodyHtml.Visible = True
            txtBodyHtml.btnForm = False
            txtBodyHtml.btnMedia = True
            txtBodyHtml.btnFlash = True
            txtBodyHtml.btnAbsolute = False
            txtBodyHtml.btnStyles = True
            txtBodyHtml.CssText = oNewsletter.Css
            txtBodyHtml.Text = oNewsletter.Message
        
            lnkInsertPageLinks.OnClientClick = "modalDialog('" & Me.AppPath & "dialogs/page_links.aspx?c=" & Me.Culture & "&root=" & Me.RootID & "&abs=true',500,500);return false;"
            lnkInsertResources.OnClientClick = "modalDialog('" & Me.AppPath & "dialogs/page_resources.aspx?c=" & Me.Culture & "&pg=" & Me.PageID & "&abs=true',650,570);return false;"

            If Profile.UseAdvancedEditor Then
                txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
                txtBodyHtml.Text = "<html><head><style>" & oNewsletter.Css & "</style></head><body>" & oNewsletter.Message & "</body></html>"
                lnkQuickEdit.Visible = True
                lnkAdvEdit.Visible = False
            Else
                txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Quick
                lnkQuickEdit.Visible = False
                lnkAdvEdit.Visible = True
            End If

        End If

        Dim Categories As Collection = GetCategoriesByNewsId(NewsId)
        Dim i, x As Integer
        For x = 1 To Categories.Count
            For i = 0 To lbCategories.Items.Count - 1
                If lbCategories.Items(i).Value = CType(Categories(x), Category).CategoryId Then
                    lbCategories.Items(i).Selected = True
                End If
            Next

        Next
        oNewsletter = Nothing

        'tambahan dari andy untuk meampilkan file yg diupload ketika edit
        '----------------------------------------------------------------
        sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId
        lnkUploadFile.Text = ""

        If System.IO.Directory.Exists(sPath) Then
            For Each item As String In System.IO.Directory.GetFiles(sPath)
                If Not item.Substring(item.LastIndexOf("\") + 1).ToLower = "thumbs.db" Then
                    sPathFile = sPath & item.Substring(item.LastIndexOf("\") + 1)
                    lnkUploadFile.Text = item.Substring(item.LastIndexOf("\") + 1)
                    chkDelFile.Visible = True
                End If
            Next
        End If
        '-----------------------------------
    End Sub

    'Select newsletter
    Protected Sub grvNewsletters_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles grvNewsletters.SelectedIndexChanging
        Dim sUrl As String = ""
        Dim oNewsletter As Newsletter = New Newsletter

        NewsId = grvNewsletters.DataKeys.Item(e.NewSelectedIndex).Value
        oNewsletter = GetNewsletterById(NewsId)

        If oNewsletter.ReceipientsType = 0 Then
            sUrl = Me.LinkWorkspaceNewsConfigure & "?id=" & NewsId.ToString
        Else
            sUrl = Me.LinkWorkspaceNewsSend & "?id=" & NewsId.ToString
        End If
        Response.Redirect(sUrl)
    End Sub

    'new newsletter
    Protected Sub lnkNewHtml_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewHtml.Click
        Dim sCssText As String = "body{font:12px Arial;}"
        hidCSS.Value = sCssText
        panelNewslettersNew.Visible = True
        panelNewsletters.Visible = False
        panelHtml.Visible = True
        txtBodyHtml.CssText = sCssText
        txtBodyHtml.Visible = True
        txtBodyHtml.btnForm = False
        txtBodyHtml.btnMedia = True
        txtBodyHtml.btnFlash = True
        txtBodyHtml.btnAbsolute = False
        txtBodyHtml.btnStyles = True
        txtBodyText.Visible = False
        
        lnkInsertPageLinks.OnClientClick = "modalDialog('" & Me.AppPath & "dialogs/page_links.aspx?c=" & Me.Culture & "&root=" & Me.RootID & "&abs=true',500,500);return false;"
        lnkInsertResources.OnClientClick = "modalDialog('" & Me.AppPath & "dialogs/page_resources.aspx?c=" & Me.Culture & "&pg=" & Me.PageID & "&abs=true',650,570);return false;"
        
        If Profile.UseAdvancedEditor Then
            txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
            txtBodyHtml.Text = "<html><head><style>" & sCssText & "</style></head><body></body></html>"
            lnkQuickEdit.Visible = True
            lnkAdvEdit.Visible = False
        Else
            txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Quick
            lnkQuickEdit.Visible = False
            lnkAdvEdit.Visible = True
        End If

    End Sub

    Protected Sub lnkNewText_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewText.Click
        panelNewslettersNew.Visible = True
        panelNewsletters.Visible = False
        panelHtml.Visible = False
        txtBodyText.Visible = True
    End Sub

    Protected Sub lnkAdvEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdvEdit.Click
        Dim sBodyTmp As String = txtBodyHtml.Text
        Dim sCssText As String = hidCSS.Value

        lnkAdvEdit.Visible = False
        lnkQuickEdit.Visible = True
        txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
        txtBodyHtml.Text = "<html><head><style>" & sCssText & "</style></head><body>" & sBodyTmp & "</body></html>"
    End Sub

    Protected Sub lnkQuickEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkQuickEdit.Click
        Dim sBodyTmp As String = txtBodyHtml.Text
        Dim sCssText As String = hidCSS.Value

        lnkAdvEdit.Visible = True
        lnkQuickEdit.Visible = False
        txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Quick
        txtBodyHtml.Text = sBodyTmp
        txtBodyHtml.CssText = sCssText
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sBody As String
        Dim sForm As String
        Dim sName As String = GetUser.UserName.ToString
        Dim news_id As Integer
        Dim i As Integer
        Dim oNewsletter As Newsletter = New Newsletter

        If txtBodyText.Visible Then
            sBody = txtBodyText.Text
            sForm = "text"
        Else
            sBody = txtBodyHtml.Text
            sForm = "html"
        End If

        'insert newsletters
        oNewsletter.Subject = txtSubject.Text
        oNewsletter.Message = sBody
        oNewsletter.Css = hidCSS.Value
        oNewsletter.Author = sName
        oNewsletter.Form = sForm
        oNewsletter.RootId = Me.RootID
        news_id = InsertNewsletter(oNewsletter)
        oNewsletter = Nothing

        'insert map newsletters and category
        If lbCategories.Items.Count <> 0 Then
            For i = 0 To lbCategories.Items.Count - 1
                If lbCategories.Items(i).Selected Then
                    InsertNewsletterMap(news_id, lbCategories.Items(i).Value)
                End If
            Next
        End If

        'tambahan dari andi untuk attach file
        '------------------------------------
        If FileUpload1.FileName <> "" Then
            sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\"
            If Not System.IO.Directory.Exists(sPath & news_id) Then
                System.IO.Directory.CreateDirectory(sPath & news_id)
            End If
            FileUpload1.SaveAs(sPath & news_id & "\" & FileUpload1.FileName)
        End If
        '------------------------------------
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim sBody As String
        Dim sName As String = GetUser.UserName.ToString
        Dim oNewsletter As Newsletter = New Newsletter
        Dim i As Integer
        Dim news_id As Integer = hidNewslettersId.Value

        If txtBodyText.Visible Then
            sBody = txtBodyText.Text
        Else
            sBody = txtBodyHtml.Text
        End If

        oNewsletter.Subject = txtSubject.Text
        oNewsletter.Message = sBody
        oNewsletter.Css = hidCSS.Value
        oNewsletter.Id = hidNewslettersId.Value
        oNewsletter.RootId = Me.RootID
        UpdateNewsletter(oNewsletter)
        oNewsletter = Nothing

        'insert map newsletters and category
        If lbCategories.Items.Count <> 0 Then
            For i = 0 To lbCategories.Items.Count - 1
                If lbCategories.Items(i).Selected Then
                    InsertNewsletterMap(news_id, lbCategories.Items(i).Value)
                End If
            Next
        End If
   
        'dari andy untuk cari path
        '--------------------------
        sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & news_id

        If System.IO.Directory.Exists(sPath) Then
            For Each item As String In System.IO.Directory.GetFiles(sPath)
                If Not (item.Substring(item.LastIndexOf("\") + 1) <> "" And item.Substring(item.LastIndexOf("\") + 1).ToLower = "thumbs.db") Then
                    sPathFile = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                Else
                    sPathFile = ""
                End If
            Next
        End If

        'dari andy untuk attach ketika update
        '------------------------------------
        If Not System.IO.Directory.Exists(sPath) Then
            System.IO.Directory.CreateDirectory(sPath)
        End If

        If FileUpload1.FileName <> "" Then
            If sPathFile <> "" Then
                System.IO.File.Delete(sPathFile)
            End If

            FileUpload1.SaveAs(sPath & "\" & FileUpload1.FileName)
        End If

        'tambahan dari andy untuk delete attachment
        '-----------------------------------------
        If chkDelFile.Checked = True Then
            System.IO.File.Delete(sPathFile)
        End If
        '-----------------------------------------
        Response.Redirect(GetFileName())
    End Sub

    Protected Sub btnCancel_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles btnCancel.Command
        Response.Redirect(GetFileName())
    End Sub

    'dari andy untuk security saat download file attachment
    '------------------------------------------------------
    Protected Sub lnkUploadFile_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If lnkUploadFile.Text <> "" Then
            NewsId = CInt(hidNewsId.Value)
            Dim sUpload As String = lnkUploadFile.Text
            Dim sFile As String = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId & "\" & sUpload
            Dim infoFile As New FileInfo(sFile)
 
            Response.Clear()
            Response.AddHeader("content-disposition", "attachment;filename=" & sUpload)
            Response.AddHeader("Content-Length", infoFile.Length.ToString)
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(sFile)
            Response.End()
        Else
            Response.Write("<script>alert('" & GetLocalResourceObject("FileNotFound") & "');<")
            Response.Write("/script>")
        End If
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelNews" runat="server" Visible="false">

<asp:Panel ID="panelNewsletters" runat="server" >
  <asp:LinkButton ID="lnkNewHtml" Text="New Html Message" meta:resourcekey="lnkNewHtml" runat="server"></asp:LinkButton>&nbsp;&nbsp; 
  <asp:LinkButton ID="lnkNewText" Text="New Text Message" meta:resourcekey="lnkNewText" runat="server"></asp:LinkButton>&nbsp;&nbsp; 
<asp:HyperLink ID="lnkMailingLists" meta:resourcekey="lnkMailingLists" runat="server">Mailing Lists</asp:HyperLink>&nbsp;&nbsp; 
  <asp:HyperLink ID="lnkSubscribers" meta:resourcekey="lnkSubscribers" runat="server">Subscribers</asp:HyperLink>&nbsp;&nbsp; 
<asp:HyperLink ID="lnkSettings" meta:resourcekey="lnkSettings" runat="server">Settings</asp:HyperLink>
  <p></p>
  <asp:GridView ID="grvNewsletters" AlternatingRowStyle-BackColor="#f6f7f8" runat="server"
      HeaderStyle-BackColor="#d6d7d8" CellPadding=7  
      HeaderStyle-HorizontalAlign=Left GridLines=None 
      AutoGenerateColumns="False" 
      AllowPaging="True" AllowSorting="True" 
      DataKeyNames="id" DataSourceID="SqlNewsletters" 
      >
    <Columns>
      <asp:BoundField DataField="subject" HeaderText="Subject" meta:resourcekey="subject" SortExpression="subject" />
      <asp:BoundField DataField="created_date" HeaderText="Date Created" meta:resourcekey="created_date" SortExpression="created_date"  />
      <asp:BoundField DataField="author" HeaderText="Author" meta:resourcekey="author" SortExpression="author" />
      <asp:CommandField EditText="Edit"  ShowEditButton="True" meta:resourcekey="Command" /> 
      <asp:CommandField SelectText="Send" ShowSelectButton="True" meta:resourcekey="Command" /> 
      <asp:CommandField ShowDeleteButton="True" meta:resourcekey="Command"/>
    </Columns>
    <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" />
    <AlternatingRowStyle BackColor="#F6F7F8" />
  </asp:GridView>
</asp:Panel>

 <asp:SqlDataSource ID="SqlNewsletters" runat="server" >
 </asp:SqlDataSource>
 
<asp:HiddenField ID="hidNewslettersId" runat="server" />
<asp:HiddenField ID="hidCSS" runat="server"  /> 
<div ID="litEditorId" runat="server" style="display:none;"></div>
 
<asp:Panel ID="panelNewslettersNew" runat="server" Visible="false">
  <table style="width:100%">
    <tr>
      <td style="padding-left:0px">
        <asp:Label ID="lblSubject" runat="server" Text="Subject" meta:resourcekey="lblSubject"></asp:Label>
      </td><td>:</td>
      <td>
        <asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
      </td>
    </tr>
    <tr valign=top >
      <td style="padding-left:0px">
        <asp:Label ID="lblBody" runat="server" Text="Body" meta:resourcekey="lblBody"></asp:Label>
      </td>
      <td>:</td>
      <td style="width:100%">
        <asp:TextBox ID="txtBodyText" runat="server" TextMode=MultiLine Width="400px" Height="280px" ></asp:TextBox>
        <asp:Panel ID="panelHtml" runat="server" >
        <table cellpadding=0 cellspacing=0 width=100%>
          <tr>
            <td style="white-space:nowrap;">
                <asp:LinkButton ID="lnkAdvEdit" runat="server" meta:resourcekey="lnkAdvEdit">Advanced Mode</asp:LinkButton>              
                <asp:LinkButton ID="lnkQuickEdit" runat="server" Visible=false meta:resourcekey="lnkQuickEdit">Quick Mode</asp:LinkButton> 
                &nbsp;
                <asp:LinkButton ID="lnkCss" runat="server" meta:resourcekey="lnkCss">Style Sheet</asp:LinkButton>
            </td>
            <td align=right>
                
            
                    <table cellpadding="0" cellspacing="0">
                    <tr>
                    <td style="padding-left:3px;padding-right:5px;">
                        <asp:DropDownList ID="dropInsertTag" AutoPostBack=false runat="server">
                            <asp:ListItem meta:resourcekey="optTagInsert" Text="Insert.." Value=""></asp:ListItem>
                            <asp:ListItem meta:resourcekey="optTag1" Text="Name" Value="[%Name%]"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="optTag2" Text="Site Name" Value="[%SiteName%]"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="optTag3" Text="Site Email" Value="[%SiteEmail%]"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="optTag4" Text="Unsubscribe Signature" Value="[%UnsubscribeSignature%]"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;white-space:nowrap;">
                        <asp:LinkButton ID="lnkInsertPageLinks" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertResources.gif" style="margin-top:3px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertResources" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
                    </td>
                    </tr>
                    </table> 
            </td>
          </tr>
        </table>
        <div style=" margin:3px;"></div>
        <editor:WYSIWYGEditor runat="server" ID="txtBodyHtml" scriptPath="systems/editor/scripts/" 
              EditMode="XHTMLBody" Width="100%" Height="320px" Text=""/>
        </asp:Panel>
      </td>
    </tr>
    <tr valign=top >
      <td style="padding-left:0px">
        <%=GetLocalResourceObject("Lists")%>
      </td><td>:</td>
      <td>
          <asp:ListBox ID="lbCategories" runat="server" DataTextField="category" DataValueField="category_id" SelectionMode="Multiple"></asp:ListBox>
      </td>
    </tr>
    <tr valign=top >
      <td style="padding-left:0px; white-space:nowrap" >
        <%=GetLocalResourceObject("FileUpload")%>
      </td><td>:</td>
      <td>
        <asp:FileUpload ID="FileUpload1" runat="server" /><br />
        <asp:LinkButton ID="lnkUploadFile" runat="server" OnClick="lnkUploadFile_Click" ></asp:LinkButton>
        <asp:CheckBox id="chkDelFile" meta:resourcekey="chkDelFile" runat="server" Visible=false Text="Delete File"></asp:CheckBox>
    </tr>
  </table><p></p>
  <asp:Button runat="server" ID="btnSave" Text=" Create " meta:resourcekey="btnSave" />
  <asp:Button runat="server" ID="btnUpdate" Text=" Update " visible="false" meta:resourcekey="btnUpdate" />
  <asp:Button runat="server" ID="btnCancel" Text=" Cancel " meta:resourcekey="btnCancel" /></asp:Panel>
  <asp:HiddenField ID="hidNewsId" runat="server" />
</asp:Panel>
