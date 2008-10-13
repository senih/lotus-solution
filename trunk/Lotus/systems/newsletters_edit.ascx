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
                'oUpdate.RegisterPostBackControl(btnUpdate)
                ''oUpdate.RegisterPostBackControl(lnkAdvEdit)
                ''oUpdate.RegisterPostBackControl(lnkQuickEdit)
                'oUpdate.RegisterPostBackControl(btnCancel)
                'oUpdate.RegisterPostBackControl(lnkUploadFile)
                'oUpdate.RegisterPostBackControl(lnkUploadFile2)
                'oUpdate.RegisterPostBackControl(lnkUploadFile3)
                'oUpdate.RegisterPostBackControl(lnkUploadFile4)
                
                panelNews.Visible = True
                
                NewsId = Request.QueryString("id")
                hidNewsId.Value = NewsId
        
                Dim oNewsletter As Newsletter = New Newsletter
                oNewsletter = GetNewsletterById(NewsId)
                txtSubject.Text = oNewsletter.Subject
                hidCSS.Value = oNewsletter.Css
                
                If oNewsletter.Form = "text" Then
                    panelHtml.Visible = False
                    txtBodyText.Visible = True
                    txtBodyHtml.Visible = False
                    
                    txtBodyText.Text = oNewsletter.Message
                    
                    dropInsertTag.Attributes.Add("onchange", "oUtil.obj.insertHTML(this.value)")
                    
                    lbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                    lbCategories.DataBind()
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
                    
                    lnkInsertPageLinks.OnClientClick = "modalDialog2('" & Me.AppPath & "dialogs/page_links.aspx?c=" & Me.Culture & "&root=" & Me.RootID & "&abs=true',500,500);return false;"
                    lnkInsertResources.OnClientClick = "modalDialog2('" & Me.AppPath & "dialogs/page_resources.aspx?c=" & Me.Culture & "&pg=" & Me.PageID & "&abs=true',650,520);return false;"

                    If Profile.UseAdvancedEditor Then
                        txtBodyHtml.EditorType = InnovaStudio.EditorTypeEnum.Advance
                        txtBodyHtml.Text = "<html><head><style>" & oNewsletter.Css & "</style></head><body>" & oNewsletter.Message & "</body></html>"
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
                    
                    lnkCss.Attributes.Add("onclick", "modalDialog('systems/newsletter_style.aspx?c=" & Me.Culture & "',430,380);return false;")
                    dropInsertTag.Attributes.Add("onchange", "oUtil.obj.insertHTML(this.value);this.value=''")
                    
                    lbCategories.DataSource = GetCategoriesByRootID(Me.RootID)
                    lbCategories.DataBind()
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

                Dim nCount As Integer = 1
                If System.IO.Directory.Exists(sPath) Then
                    For Each item As String In System.IO.Directory.GetFiles(sPath)
                        If Not item.Substring(item.LastIndexOf("\") + 1).ToLower = "thumbs.db" Then
                            sPathFile = sPath & item.Substring(item.LastIndexOf("\") + 1)
                    
                            If nCount = 1 Then
                                lnkUploadFile.Text = item.Substring(item.LastIndexOf("\") + 1)
                                chkDelFile.Visible = True
                            End If
                    
                            If nCount = 2 Then
                                lnkUploadFile2.Text = item.Substring(item.LastIndexOf("\") + 1)
                                chkDelFile2.Visible = True
                            End If
                    
                            If nCount = 3 Then
                                lnkUploadFile3.Text = item.Substring(item.LastIndexOf("\") + 1)
                                chkDelFile3.Visible = True
                            End If
                    
                            If nCount = 4 Then
                                lnkUploadFile4.Text = item.Substring(item.LastIndexOf("\") + 1)
                                chkDelFile4.Visible = True
                            End If
                    
                            nCount = nCount + 1
                        End If
                    Next
                End If
                '-----------------------------------
                
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
    
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        Dim sBody As String
        Dim sName As String = GetUser.UserName.ToString
        Dim oNewsletter As Newsletter = New Newsletter
        Dim i As Integer
        NewsId = hidNewsId.Value

        If txtBodyText.Visible Then
            sBody = txtBodyText.Text
        Else
            sBody = txtBodyHtml.Text
        End If

        oNewsletter.Subject = txtSubject.Text
        oNewsletter.Message = sBody
        oNewsletter.Css = hidCSS.Value
        oNewsletter.Id = hidNewsId.Value
        oNewsletter.RootId = Me.RootID
        UpdateNewsletter(oNewsletter)
        oNewsletter = Nothing

        'insert map newsletters and category
        If lbCategories.Items.Count <> 0 Then
            For i = 0 To lbCategories.Items.Count - 1
                If lbCategories.Items(i).Selected Then
                    InsertNewsletterMap(NewsId, lbCategories.Items(i).Value)
                End If
            Next
        End If
   
        'dari andy untuk cari path (Ysf: OK, bgn ini sptnya msh bisa di-efisienkan? khusunya bgn "Else")
        '--------------------------
        sPath = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId

        Dim nCount As Integer = 1
        
        If System.IO.Directory.Exists(sPath) Then
            For Each item As String In System.IO.Directory.GetFiles(sPath)
                If Not (item.Substring(item.LastIndexOf("\") + 1) <> "" And item.Substring(item.LastIndexOf("\") + 1).ToLower = "thumbs.db") Then
                    If nCount = 1 Then
                        sPathFile = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                    End If
                    
                    If nCount = 2 Then
                        sPathFile2 = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                    End If
                    If nCount = 3 Then
                        sPathFile3 = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                    End If
                    If nCount = 4 Then
                        sPathFile4 = sPath & "\" & item.Substring(item.LastIndexOf("\") + 1)
                    End If
                    
                    nCount = nCount + 1
                Else
                    sPathFile = ""
                    sPathFile2 = ""
                    sPathFile3 = ""
                    sPathFile4 = ""
                End If
            Next
        End If

        'tambahan dari andy untuk delete attachment
        '-----------------------------------------
                    
        If chkDelFile.Checked = True Then
            If sPathFile <> "" Then
                System.IO.File.Delete(sPathFile)
            End If
        End If
        
        If chkDelFile2.Checked = True Then
            If sPathFile2 <> "" Then
                System.IO.File.Delete(sPathFile2)
            End If
        End If
        
        If chkDelFile3.Checked = True Then
            If sPathFile3 <> "" Then
                System.IO.File.Delete(sPathFile3)
            End If
        End If
        
        If chkDelFile4.Checked = True Then
            If sPathFile4 <> "" Then
                System.IO.File.Delete(sPathFile4)
            End If
        End If
        
        '-----------------------------------------
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
        
        If FileUpload2.FileName <> "" Then
            If sPathFile2 <> "" Then
                System.IO.File.Delete(sPathFile2)
            End If

            FileUpload2.SaveAs(sPath & "\" & FileUpload2.FileName)
        End If
        
        If FileUpload3.FileName <> "" Then
            If sPathFile3 <> "" Then
                System.IO.File.Delete(sPathFile3)
            End If

            FileUpload3.SaveAs(sPath & "\" & FileUpload3.FileName)
        End If
        
        If FileUpload4.FileName <> "" Then
            If sPathFile4 <> "" Then
                System.IO.File.Delete(sPathFile4)
            End If

            FileUpload4.SaveAs(sPath & "\" & FileUpload4.FileName)
        End If

        Response.Redirect(Me.LinkWorkspaceNewsEdit & "?id=" & NewsId)
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
            
        ElseIf lnkUploadFile2.Text <> "" Then
            Dim sUpload2 As String = lnkUploadFile2.Text
            Dim sFile2 As String = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId & "\" & sUpload2
            Dim infoFile2 As New FileInfo(sFile2)
 
            Response.Clear()
            Response.AddHeader("content-disposition", "attachment;filename=" & sUpload2)
            Response.AddHeader("Content-Length", infoFile2.Length.ToString)
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(sFile2)
            Response.End()
            
        ElseIf lnkUploadFile3.Text <> "" Then
            Dim sUpload3 As String = lnkUploadFile3.Text
            Dim sFile3 As String = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId & "\" & sUpload3
            Dim infoFile3 As New FileInfo(sFile3)
 
            Response.Clear()
            Response.AddHeader("content-disposition", "attachment;filename=" & sUpload3)
            Response.AddHeader("Content-Length", infoFile3.Length.ToString)
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(sFile3)
            Response.End()
            
        ElseIf lnkUploadFile4.Text <> "" Then
            Dim sUpload4 As String = lnkUploadFile4.Text
            Dim sFile4 As String = ConfigurationManager.AppSettings("FileStorage") & "\newsletters\" & NewsId & "\" & sUpload4
            Dim infoFile4 As New FileInfo(sFile4)
 
            Response.Clear()
            Response.AddHeader("content-disposition", "attachment;filename=" & sUpload4)
            Response.AddHeader("Content-Length", infoFile4.Length.ToString)
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(sFile4)
            Response.End()
            
        Else
            Response.Write("<script>alert('" & GetLocalResourceObject("FileNotFound") & "');<")
            Response.Write("/script>")
        End If
    End Sub
    
    Private Function GetFileName() As String
        Return HttpContext.Current.Items("_page")
    End Function
    
    Protected Sub btnCancel_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles btnCancel.Command
        Response.Redirect(Me.LinkWorkspaceNewsletters)
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelNews" runat="server" Visible="false">
    <asp:HiddenField ID="hidCSS" runat="server"  /> 
    <asp:HiddenField ID="hidNewsId" runat="server" /> 

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
        <asp:Panel ID="panelHtml" runat="server" >
            <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td style="white-space:nowrap;">
<%--                    <asp:LinkButton ID="lnkAdvEdit" runat="server" meta:resourcekey="lnkAdvEdit">Advanced Mode</asp:LinkButton>              
                    <asp:LinkButton ID="lnkQuickEdit" runat="server" Visible=false meta:resourcekey="lnkQuickEdit">Quick Mode</asp:LinkButton> 
                    &nbsp;
--%>                    <asp:LinkButton ID="lnkCss" runat="server" meta:resourcekey="lnkCss">Style Sheet</asp:LinkButton>
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
            <asp:LinkButton ID="lnkUploadFile" runat="server" OnClick="lnkUploadFile_Click" ></asp:LinkButton>
            <asp:CheckBox id="chkDelFile" meta:resourcekey="chkDelFile" runat="server" Visible=false Text="Delete File"></asp:CheckBox>
        </div>
        <div>
            <asp:FileUpload ID="FileUpload2" runat="server" /><br />
            <asp:LinkButton ID="lnkUploadFile2" runat="server" OnClick="lnkUploadFile_Click" ></asp:LinkButton>
            <asp:CheckBox id="chkDelFile2" meta:resourcekey="chkDelFile" runat="server" Visible=false Text="Delete File"></asp:CheckBox>
        </div>
        <div>
            <asp:FileUpload ID="FileUpload3" runat="server" /><br />
            <asp:LinkButton ID="lnkUploadFile3" runat="server" OnClick="lnkUploadFile_Click" ></asp:LinkButton>
            <asp:CheckBox id="chkDelFile3" meta:resourcekey="chkDelFile" runat="server" Visible=false Text="Delete File"></asp:CheckBox>
        </div>
        <div>
            <asp:FileUpload ID="FileUpload4" runat="server" /><br />
            <asp:LinkButton ID="lnkUploadFile4" runat="server" OnClick="lnkUploadFile_Click" ></asp:LinkButton>
            <asp:CheckBox id="chkDelFile4" meta:resourcekey="chkDelFile" runat="server" Visible=false Text="Delete File"></asp:CheckBox>
        </div>
    </td>
    </tr>
    </table>
    
    <p>
    <asp:Button runat="server" ID="btnUpdate" Text=" Update " meta:resourcekey="btnUpdate" />
    <asp:Button runat="server" ID="btnCancel" Text=" Cancel " meta:resourcekey="btnCancel" />
    </p>
</asp:Panel>
