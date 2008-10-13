<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="NewsletterManager" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    Dim sPath, sPathFile, sPathFile2, sPathFile3, sPathFile4 As String
    Dim NewsId As Integer
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelNews.Visible = False
        Else
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Or _
                Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then

                'Enable this line if using AJAX
                'Dim oUpdate As ScriptManager = ScriptManager.GetCurrent(Page)
                'oUpdate.RegisterPostBackControl(btnSave)
                ''oUpdate.RegisterPostBackControl(lnkAdvEdit)
                ''oUpdate.RegisterPostBackControl(lnkQuickEdit)
                'oUpdate.RegisterPostBackControl(btnCancel)
                
                panelNews.Visible = True
                
                If Request.QueryString("mode") = "adv" Then
                    'WYSIWYG Editor
                    panelHtml.Visible = True
                    txtBodyHtml.Visible = True
                    txtBodyText.Visible = False
                    
                    txtBodyHtml.btnForm = False
                    txtBodyHtml.btnMedia = True
                    txtBodyHtml.btnFlash = True
                    txtBodyHtml.btnAbsolute = False
                    txtBodyHtml.btnStyles = True
                    
                    Dim sCssText As String = "body{font:12px Arial;}"
                    hidCSS.Value = sCssText
                    txtBodyHtml.CssText = sCssText
                    
                    lnkInsertPageLinks.OnClientClick = "modalDialog2('" & Me.AppPath & "dialogs/page_links.aspx?c=" & Me.Culture & "&root=" & Me.RootID & "&abs=true',500,500);return false;"
                    lnkInsertResources.OnClientClick = "modalDialog2('" & Me.AppPath & "dialogs/page_resources.aspx?c=" & Me.Culture & "&pg=" & Me.PageID & "&abs=true',650,520);return false;"

                    If Profile.UseAdvancedEditor Then
                        txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
                        txtBodyHtml.Text = "<html><head><style>" & sCssText & "</style></head><body></body></html>"
                        'lnkQuickEdit.Visible = True
                        'lnkAdvEdit.Visible = False
                    Else
                        txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Quick
                        'lnkQuickEdit.Visible = False
                        'lnkAdvEdit.Visible = True
                    End If
                    
                    'Used by newsletter_style.aspx
                    panelNews.Controls.Add(New LiteralControl("<div id=""divEditorId"" style=""display:none"">" & txtBodyHtml.UniqueID & "</div>"))
                    panelNews.Controls.Add(New LiteralControl("<div id=""divCSSId"" style=""display:none"">" & hidCSS.UniqueID & "</div>"))
                    
                    lnkCss.Attributes.Add("onclick", "modalDialog2('systems/newsletter_style.aspx?c=" & Me.Culture & "',430,380);return false;")
                    dropInsertTag.Attributes.Add("onchange", "oUtil.obj.insertHTML(this.value);this.value=''")
                    
                    lbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                    lbCategories.DataBind()
                Else
                    'TEXT Editor
                    panelHtml.Visible = False
                    txtBodyHtml.Visible = False
                    txtBodyText.Visible = True
                    txtBodyText.Text = ""
                     
                    lbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                    lbCategories.DataBind()
                End If
                
            End If
        End If
    End Sub
    
    'Protected Sub lnkAdvEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdvEdit.Click
    '    Dim sBodyTmp As String = txtBodyHtml.Text
    '    Dim sCssText As String = hidCSS.Value

    '    lnkAdvEdit.Visible = False
    '    lnkQuickEdit.Visible = True
    '    txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
    '    txtBodyHtml.Text = "<html><head><style>" & sCssText & "</style></head><body>" & sBodyTmp & "</body></html>"
    'End Sub

    'Protected Sub lnkQuickEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkQuickEdit.Click
    '    Dim sBodyTmp As String = txtBodyHtml.Text
    '    Dim sCssText As String = hidCSS.Value

    '    lnkAdvEdit.Visible = True
    '    lnkQuickEdit.Visible = False
    '    txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Quick
    '    txtBodyHtml.Text = sBodyTmp
    '    txtBodyHtml.CssText = sCssText
    'End Sub
        
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))

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
        
        If FileUpload2.FileName <> "" Then
            sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\"
            If Not System.IO.Directory.Exists(sPath & news_id) Then
                System.IO.Directory.CreateDirectory(sPath & news_id)
            End If
            FileUpload2.SaveAs(sPath & news_id & "\" & FileUpload2.FileName)
        End If
        
        If FileUpload3.FileName <> "" Then
            sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\"
            If Not System.IO.Directory.Exists(sPath & news_id) Then
                System.IO.Directory.CreateDirectory(sPath & news_id)
            End If
            FileUpload3.SaveAs(sPath & news_id & "\" & FileUpload3.FileName)
        End If
        
        If FileUpload4.FileName <> "" Then
            sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\"
            If Not System.IO.Directory.Exists(sPath & news_id) Then
                System.IO.Directory.CreateDirectory(sPath & news_id)
            End If
            FileUpload4.SaveAs(sPath & news_id & "\" & FileUpload4.FileName)
        End If
        '------------------------------------
        
        Response.Redirect(Me.LinkWorkspaceNewsletters)
    End Sub
       
    Protected Sub btnCancel_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles btnCancel.Command
        Response.Redirect(Me.LinkWorkspaceNewsletters)
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelNews" runat="server" Visible="false">
    <asp:HiddenField ID="hidCSS" runat="server"  /> 

    <table cellpadding="7" style="width:100%">
    <tr>
    <td style="padding-left:0px"><asp:Label ID="lblSubject" runat="server" Text="Subject" meta:resourcekey="lblSubject"></asp:Label></td><td>:</td>
    <td style="width:100%">
        <asp:TextBox ID="txtSubject" Width="200" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td style="padding-left:0px" colspan="3">
    
        <asp:Label ID="lblBody" Visible="false" runat="server" Text="Body" meta:resourcekey="lblBody"></asp:Label>
        
        <asp:TextBox ID="txtBodyText" runat="server" TextMode=MultiLine Width="100%" Height="400px"></asp:TextBox>
        <asp:Panel ID="panelHtml" runat="server">
        <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td style="white-space:nowrap;">
<%--                <asp:LinkButton ID="lnkAdvEdit" runat="server" meta:resourcekey="lnkAdvEdit">Advanced Mode</asp:LinkButton>              
                <asp:LinkButton ID="lnkQuickEdit" runat="server" Visible=false meta:resourcekey="lnkQuickEdit">Quick Mode</asp:LinkButton> 
                &nbsp;
--%>            <asp:LinkButton ID="lnkCss" runat="server" meta:resourcekey="lnkCss">Style Sheet</asp:LinkButton>
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
              EditMode="XHTMLBody" Width="100%" Height="400px" Text=""/>
        </asp:Panel>
      </td>
    </tr>
    <tr>
    <td valign="top" style="padding-left:0px">
        <asp:Literal ID="litLists" meta:resourcekey="litLists" runat="server"></asp:Literal>
    </td>
    <td valign="top">:</td>
    <td>
        <asp:ListBox ID="lbCategories" runat="server" DataTextField="category" DataValueField="category_id" SelectionMode="Multiple"></asp:ListBox>
    </td>
    </tr>
    <tr>
    <td valign="top" style="padding-left:0px">
        <asp:Literal ID="litAttachments" meta:resourcekey="litAttachments" runat="server"></asp:Literal>
    </td>
    <td valign="top">:</td>
    <td>
        <div>
            <asp:FileUpload ID="FileUpload1" runat="server" /><br />
        </div>
        <div>
            <asp:FileUpload ID="FileUpload2" runat="server" /><br />
        </div>
        <div>
            <asp:FileUpload ID="FileUpload3" runat="server" /><br />
        </div>
        <div>
            <asp:FileUpload ID="FileUpload4" runat="server" /><br />
        </div>
    </tr>
    </table>
    
    <p>
    <asp:Button runat="server" ID="btnSave" Text=" Create " meta:resourcekey="btnSave" />
    <asp:Button runat="server" ID="btnUpdate" Text=" Update " visible="false" meta:resourcekey="btnUpdate" />
    <asp:Button runat="server" ID="btnCancel" Text=" Cancel " meta:resourcekey="btnCancel" />
    </p>
</asp:Panel>
