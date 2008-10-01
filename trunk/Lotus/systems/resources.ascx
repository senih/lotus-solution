<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>


<script runat="server">
    Private sCurrentDirectory As String
    Private sPath As String = ""
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            panelManager.Visible = False
        Else
            panelManager.Visible = True
        End If

        If Me.IsUserLoggedIn Then
            Dim oList As ListItem
            Dim sChannelName As String
            Dim Item As String
            Dim oChannelManager As ChannelManager = New ChannelManager

            'Render Channels
            dropChannels.Items.Clear()
            'oList = New ListItem
            'oList.Value = ""
            'oList.Text = GetLocalResourceObject("SelectChannel") 'Select Channel..
            'dropChannels.Items.Add(oList)

            If Me.IsAdministrator Then
                Dim oDataReader As SqlDataReader
                oDataReader = oChannelManager.GetChannels()
                Do While oDataReader.Read()
                    oList = New ListItem
                    oList.Value = oDataReader("channel_id").ToString
                    oList.Text = oDataReader("channel_name").ToString
                    dropChannels.Items.Add(oList)
                Loop
                oDataReader.Close()
                oDataReader = Nothing
            Else
                For Each Item In Roles.GetRolesForUser(GetUser.UserName)
                    If Item.Contains("Resource Managers") Then
                        If Item.Substring(Item.IndexOf("Resource Managers")) = "Resource Managers" Then
                            sChannelName = Item.Substring(0, Item.IndexOf("Resource Managers") - 1)
                            oList = New ListItem
                            oList.Value = oChannelManager.GetChannelByName(sChannelName).ChannelId.ToString
                            oList.Text = sChannelName
                            dropChannels.Items.Add(oList)
                        End If
                    End If
                Next
            End If

            oChannelManager = Nothing
            
            If dropChannels.Items.Count = 0 Then
                panelResources.Visible = False
                panelLogin.Visible = True
                panelLogin.FindControl("Login1").Focus()
                Exit Sub
            End If

            panelResources.Visible = True
            panelLogin.Visible = False

            sPath = Request.QueryString("path")
            If sPath <> "" Then
                Dim nChnlId As Integer
                If sPath.Substring(1).IndexOf("\") = -1 Then
                    nChnlId = sPath.Substring(1)
                Else
                    nChnlId = sPath.Substring(1, sPath.Substring(1).IndexOf("\"))
                End If
                dropChannels.SelectedValue = nChnlId

                sPath = Server.MapPath("resources") & sPath
                If Directory.Exists(sPath) Then
                    sCurrentDirectory = sPath
                End If
                
                panelManager.Visible = True
                showFiles()
            Else
                sPath = Server.MapPath("resources") & "\" & dropChannels.SelectedValue
                If Directory.Exists(sPath) Then
                    sCurrentDirectory = sPath
                End If
                
                panelManager.Visible = True
                showFiles()
            End If

        Else
            panelResources.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        End If
    End Sub

    Protected Sub showFiles()
        With My.Computer.FileSystem
            'install Path
            Dim n As Integer
            Dim nFileLength As Double
            Dim i As Integer

            Dim sPhysicalPath As String = sCurrentDirectory
            Dim cItems As ObjectModel.ReadOnlyCollection(Of String)
            Dim sName As String
            Dim sResMapPath As String = Server.MapPath("resources")
            Dim sResources As String = ""

            If sPhysicalPath.Length > sResMapPath.Length Then
                sResources = "resources" & sPhysicalPath.Substring(sResMapPath.Length).Replace("\", "/")
            Else
                sPhysicalPath = sResMapPath
                sCurrentDirectory = sResMapPath
            End If

            'Breadcrumb
            Dim sQueryString As String = Request.QueryString("path") & ""
            If sQueryString = "" Then sQueryString = "\" & dropChannels.SelectedValue
            
            Dim sBreadcrumb As String = ""
                
            Dim item As String
            Dim slink As String = ""
            Dim count As String = 0
            Dim nLength As Integer
            If Not sQueryString.Substring(1).IndexOf("\") = -1 Then
                nLength = sQueryString.Substring(sQueryString.Substring(1).IndexOf("\")).Split("\").Length()
                For Each item In sQueryString.Substring(sQueryString.Substring(1).IndexOf("\")).Split("\")
                    slink = slink & "\" & item
                    If count = nLength - 1 Then
                        sBreadcrumb = sBreadcrumb & item
                    ElseIf count = 0 Then
                        sBreadcrumb = sBreadcrumb & "\" ' "<a href=""" & Me.LinkWorkspaceResources & "?path=" & Server.UrlEncode(slink) & """>" & dropChannels.SelectedItem.Text & "</a>\"
                    Else
                        sBreadcrumb = sBreadcrumb & "<a href=""" & Me.LinkWorkspaceResources & "?path=" & Server.UrlEncode(slink) & """>" & item & "</a>\"
                    End If
                    count += 1
                Next
            Else
                sBreadcrumb = sBreadcrumb ' & dropChannels.SelectedItem.Text
            End If

            lblPath.Text = sBreadcrumb.Replace("\", " \ ")
            'dropChannels.SelectedItem.Text & sBreadcrumb.Replace("\", " \ ")

 
            
            Dim sInstallPath As String 'relative
            Dim sPath As String
            Dim sRawUrl As String = Context.Request.RawUrl.ToString()

            If sRawUrl.Contains("?") Then
                sPath = sRawUrl.Split(CChar("?"))(0).ToString
            Else
                sPath = sRawUrl
            End If
            sInstallPath = sPath.Substring(0, sPath.LastIndexOf("/") + 1)

            Dim dt As New DataTable
            dt.Columns.Add(New DataColumn("FileName", GetType(String)))
            dt.Columns.Add(New DataColumn("FileUrl", GetType(String)))
            dt.Columns.Add(New DataColumn("LastUpdated", GetType(DateTime)))
            dt.Columns.Add(New DataColumn("Size", GetType(String)))
            dt.Columns.Add(New DataColumn("Icon", GetType(String)))

            ' Create Up one Folder
            If Request.QueryString("path") <> "" Then
                If .GetParentPath(sCurrentDirectory) <> sResMapPath Then
                    Dim dr As DataRow = dt.NewRow()
                    dr("FileName") = "..."
                    dr("Icon") = ""
                    dr("FileUrl") = Me.AppFullPath & Me.LinkWorkspaceResources & "?path=" & Server.UrlEncode(.GetParentPath(sCurrentDirectory).Substring(sResMapPath.Length))
                    dt.Rows.Add(dr)
                End If
            End If

            'List Folder at current directory
            cItems = .GetDirectories(sPhysicalPath, FileIO.SearchOption.SearchTopLevelOnly)
            n = cItems.Count

            Dim sVirtualPath As String
            For i = 0 To cItems.Count - 1
                Dim dr As DataRow = dt.NewRow()
                sName = .GetDirectoryInfo(cItems(i)).Name.ToString
                dr("FileName") = sName
                dr("LastUpdated") = .GetDirectoryInfo(cItems(i)).LastWriteTime

                nFileLength = .GetDirectoryInfo(cItems(i)).GetFiles.Length
                If nFileLength = 0 Then
                    dr("Size") = "" '"0 " & GetLocalResourceObject("Files")
                ElseIf nFileLength = 1 Then
                    dr("Size") = "1 " & GetLocalResourceObject("File")
                Else
                    dr("Size") = nFileLength & " " & GetLocalResourceObject("Files")
                End If

                sVirtualPath = Me.AppFullPath & Me.LinkWorkspaceResources & "?path=" & Server.UrlEncode(.GetDirectoryInfo(cItems(i)).FullName.Substring(sResMapPath.Length))
                dr("Icon") = sVirtualPath
                dr("FileUrl") = sVirtualPath
                dt.Rows.Add(dr)
            Next

            'List All File at current directory
            cItems = .GetFiles(sPhysicalPath, FileIO.SearchOption.SearchTopLevelOnly)
            If cItems.Count = 0 Then
                btnDelete.Visible = False
                'lblEmpty.Visible = True
            Else
                btnDelete.Visible = True
                'lblEmpty.Visible = False
            End If

            For i = 0 To cItems.Count - 1
                Dim dr As DataRow = dt.NewRow()
                sName = .GetFileInfo(cItems(i)).Name.ToString
                dr("FileName") = sName
                dr("LastUpdated") = .GetFileInfo(cItems(i)).LastWriteTime

                nFileLength = .GetFileInfo(cItems(i)).Length
                If nFileLength = 0 Then
                    dr("Size") = "0 KB"
                ElseIf nFileLength / 1024 < 1 Then
                    dr("Size") = "1 KB"
                Else
                    dr("Size") = FormatNumber((nFileLength / 1024), 0).ToString & " KB"
                End If

                sVirtualPath = sInstallPath & sResources & "/" & sName
                Dim sExt As String = cItems(i).Substring(cItems(i).LastIndexOf(".") + 1).ToLower
                If sExt = "jpeg" Or sExt = "jpg" Or sExt = "gif" Or sExt = "png" Then
                    dr("Icon") = sInstallPath & "systems/image_thumbnail.aspx?file=" & sVirtualPath & "&Size=70"
                Else
                    dr("Icon") = sInstallPath & "systems/images/blank.gif"
                End If

                dr("FileUrl") = sVirtualPath
                dt.Rows.Add(dr)
            Next

            GridView1.DataSource = dt
            GridView1.DataBind()

            btnDelete.OnClientClick = "if(_getSelection(document.getElementById('" & hidFilesToDel.ClientID & "'))){return confirm('" & GetLocalResourceObject("DeleteConfirm") & "')}else{return false}"
            btnDelete.Style.Add("margin-right", "5px")
            btnDelete2.Attributes.Add("onclick", "if(!confirm('" & GetLocalResourceObject("DeleteConfirm2") & "'))return;")
        End With
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim sPhysicalPath As String = sCurrentDirectory
      
        With FileUpload1.PostedFile
            'File asp,cgi,pl merupakan plain/text
            'aspx dan ascx typenya application/xml
            If Not (.ContentType.ToString = "application/octet-stream" Or .ContentType.ToString = "application/xml" _
                Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "cgi" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "pl" _
                Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "asp" Or .FileName.Substring(.FileName.LastIndexOf(".") + 1) = "aspx") Then
                FileUpload1.SaveAs(sPhysicalPath & "\" & FileUpload1.FileName)
                lblUploadStatus.Text = ""
            Else
                lblUploadStatus.Text = GetLocalResourceObject("UploadFailed")
                'Upload failed. File type not allowed.
            End If
        End With

        showFiles()
    End Sub

    Protected Sub dropChannels_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dropChannels.SelectedIndexChanged
        Response.Redirect(Me.LinkWorkspaceResources & "?path=%5c" & dropChannels.SelectedValue)
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim Item As String
        With My.Computer.FileSystem
            For Each Item In hidFilesToDel.Value.Split("|")
                If My.Computer.FileSystem.FileExists(Server.MapPath(Item)) Then
                    File.Delete(Server.MapPath(Item))
                End If
            Next
        End With

        showFiles()
    End Sub

    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        Dim iIndex As Integer = e.NewPageIndex()
        GridView1.PageIndex = iIndex
        showFiles()
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnNewFolder_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim sPhysicalPath As String
        With My.Computer.FileSystem
            sPhysicalPath = sCurrentDirectory
            If .DirectoryExists(sPhysicalPath & "\" & txtNewFolder.Text) Then
                lblUploadStatus.Text = GetLocalResourceObject("DirectoryExist")
            Else
                .CreateDirectory(sPhysicalPath & "\" & txtNewFolder.Text)
                sCurrentDirectory = sPhysicalPath
            End If
        End With
        showFiles()
        txtNewFolder.Text = ""
    End Sub

    Function ShowCheckBox(ByVal sUrl As String) As String
        Dim sHTML As String
        If sUrl.Contains("?path=") Then
            sHTML = "<img src=""systems/images/ico_folder.gif""><input name=""chkSelect"" style=""display:none"" type=""checkbox"" />"
        Else
            sHTML = "<input name=""chkSelect"" type=""checkbox"" />"
        End If
        Return sHTML & "<input name=""hidSelect"" type=""hidden"" value=""" & sUrl & """ /> "
    End Function

    Function Preview(ByVal sIcon As String) As String
        Dim sHTML As String
        If sIcon = "" Then
            sHTML = ""
        ElseIf sIcon.Contains("?path=") Then
            sHTML = "<a href=""#"" " & _
            "onclick=""document.getElementById('" & hidFilesToDel.ClientID & "').value ='" & sIcon & "'; " & _
            "document.getElementById('" & btnDelete2.ClientID & "').click();return false;"">" & GetLocalResourceObject("delete") & "</a>"
        Else
            sHTML = "<img src=""" & sIcon & """>"
        End If
        Return sHTML
    End Function

    Function ShowLink(ByVal sUrl As String, ByVal sFileName As String) As String
        Dim sHTML As String
        If sUrl.Contains("?path=") Then
            sHTML = "<a href=""" & sUrl & """ name=""Folder"">" & sFileName & "</a>"
        Else
            sHTML = "<a href=""" & sUrl & """ target=""_blank"">" & sFileName & "</a>"
        End If
        Return sHTML
    End Function

    Protected Sub btnDelete2_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim Item As String = hidFilesToDel.Value
        Dim sDirectory As String = Server.MapPath("resources") & Server.UrlDecode(Item.Substring(Item.LastIndexOf("=") + 1))
        If Directory.Exists(sDirectory) Then
            Directory.Delete(sDirectory, True)
        End If
        showFiles()
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelResources" runat="server">
    <table cellpadding="0" cellspacing="0">
    <tr><td><asp:Label ID="lblChannel" meta:resourcekey="lblChannel" runat="server" Text="Channel"></asp:Label>:&nbsp;</td><td>
    <asp:DropDownList ID="dropChannels" runat="server" AutoPostBack="true">
    </asp:DropDownList>&nbsp;</td><td><asp:Label ID="lblPath" runat="server" Text=""></asp:Label>
    </td></tr></table>
    <br /><br />
     
    <table cellpadding="0" cellspacing="0">
    <tr>
    <td>

    <asp:GridView ID="GridView1" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" 
        HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" 
        HeaderStyle-HorizontalAlign=left AllowPaging="True" AllowSorting="False" 
        AutoGenerateColumns="False">
        <Columns>
       <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderText="" ItemStyle-CssClass="padding2">
        <ItemTemplate>
          <%#ShowCheckBox(Eval("FileUrl"))%>
        </ItemTemplate>
        </asp:TemplateField>
       <asp:TemplateField SortExpression="FileName" ItemStyle-VerticalAlign="Middle" meta:resourcekey="lblFileName"  HeaderText="File Name" HeaderStyle-Wrap=false ItemStyle-CssClass="padding2">
        <ItemTemplate>
          <%#ShowLink(Eval("FileUrl"), Eval("FileName"))%> 
        </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField meta:resourcekey="lblLastUpdated" DataField="LastUpdated" HeaderText="Last Updated" SortExpression="LastUpdated">
           <ItemStyle VerticalAlign="Middle" Wrap=false/>
       </asp:BoundField>
       <asp:BoundField meta:resourcekey="lblSize" DataField="Size" HeaderText="Size" SortExpression="Size">
           <ItemStyle VerticalAlign="Middle" Wrap=false />
       </asp:BoundField>
       <asp:TemplateField ItemStyle-VerticalAlign="Middle"  meta:resourcekey="lblPreview" ItemStyle-CssClass="padding2" HeaderText="Preview">
        <ItemTemplate >
          <%#Preview(Eval("Icon"))%>
        </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    </asp:GridView>
    
    <asp:Panel ID="panelManager" runat="server">
    
        <div style="margin:5px"></div>
        <script language="javascript">
        function _getSelection(oEl)
            {
            var bReturn=false;
            var sTmp="";
            for(var i=0;i<document.getElementsByName("chkSelect").length;i++)
                {
                var oInput=document.getElementsByName("chkSelect")[i];        
                if(oInput.checked==true)
                    {
                    sTmp+= "|" + document.getElementsByName("hidSelect")[i].value;
                   // alert(document.getElementsByName("hidSelect")[i].value)
                    bReturn=true;
                    }
                }
            oEl.value=sTmp.substring(1);
            return bReturn;
            }
        </script>
        <asp:Label ID="lblEmpty" Visible="false" meta:resourcekey="lblEmpty" runat="server" Height="20px" Font-Bold=true Text="No files found."></asp:Label>
        
        <asp:HiddenField ID="hidFilesToDel" runat="server" />
        
        <table cellpadding="0" cellspacing="0" style="margin-top:10px">
        <tr>
        <td><asp:TextBox ID="txtNewFolder" runat="server"></asp:TextBox></td>
        <td><asp:Button ID="btnNewFolder" runat="server" Text="New Folder" meta:resourcekey="btnNewFolder" OnClick="btnNewFolder_Click" ValidationGroup="NewFolder" /></td>
        <td><asp:RequiredFieldValidator ID="rfv1" ControlToValidate="txtNewFolder" ValidationGroup="NewFolder" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator></td>
        <td style="width:100%">&nbsp;</td> 
        <td><asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text="Delete selected files"  /></td>
        </tr>
        </table>       
        
        <div style="border:#E0E0E0 1px solid;padding:10px;width:270px;margin-top:20px">
        <table cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="2" style="padding-bottom:10px">
                <asp:Label ID="lblUploadFile" meta:resourcekey="lblUploadFile" Font-Bold="true" runat="server" Text="Upload File"></asp:Label>
            </td>
        </tr>
        <tr>
            <td><asp:FileUpload ID="FileUpload1" runat="server"/></td>
            <td><asp:Button ID="btnUpload" meta:resourcekey="btnUpload" runat="server" Text="Upload" /></td>
        </tr>
        <tr>
            <td colspan="2" height="5px"></td>
        </tr>
        <tr>
            <td colspan="2"><asp:Label ID="lblUploadStatus" runat="server" Text="" ForeColor="Red"></asp:Label></td>
        </tr>
        </table>  
        </div>
    
    </asp:Panel>  
    <input ID="btnDelete2" runat="server" style="display:none" type="button" onserverclick="btnDelete2_Click" /> 
    
        
    </td>
    </tr>
    </table>
    
    <br /><br />
</asp:Panel>