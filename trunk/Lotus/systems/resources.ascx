<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    Private sCurrentDirectory As String
    Private sPath As String = ""
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Enable this line if using AJAX
        'Dim oUpdate As ScriptManager = ScriptManager.GetCurrent(Page)
        'oUpdate.RegisterPostBackControl(btnUpload)

        If Me.IsUserLoggedIn Then
            Dim oList As ListItem
            Dim sChannelName As String
            Dim Item As String
            Dim oChannelManager As ChannelManager = New ChannelManager

            'Render Channels
            If Not Page.IsPostBack Then
                dropChannels.Items.Clear()

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
            End If

            
            If dropChannels.Items.Count = 0 Then
                panelResources.Visible = False
                panelLogin.Visible = True
                panelLogin.FindControl("Login1").Focus()
                Exit Sub
            End If

            panelResources.Visible = True
            panelLogin.Visible = False

            sPath = Server.MapPath("resources") & "\" & dropChannels.SelectedValue
            If Directory.Exists(sPath) Then
                sCurrentDirectory = sPath
            End If
            showFiles()
        Else
            panelResources.Visible = False
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
        End If
    End Sub

    Protected Sub showFiles()
        With My.Computer.FileSystem

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
            If hidPath.Value = "" Then hidPath.Value = "\" & dropChannels.SelectedValue
            Dim sTmp As String = hidPath.Value
            Dim sBreadcrumb As String = ""
            Dim item As String
            Dim slink As String = ""
            Dim count As String = 0
            Dim nLength As Integer
            If Not sTmp.Substring(1).IndexOf("\") = -1 Then
                nLength = sTmp.Substring(sTmp.Substring(1).IndexOf("\")).Split("\").Length()
                For Each item In sTmp.Substring(sTmp.Substring(1).IndexOf("\")).Split("\")
                    slink = slink & "\" & item
                    If count = nLength - 1 Then
                        sBreadcrumb = sBreadcrumb & item
                    ElseIf count = 0 Then
                        sBreadcrumb = sBreadcrumb & "\"
                    Else
                        sBreadcrumb = sBreadcrumb & item & "\"
                    End If
                    count += 1
                Next
            Else
                sBreadcrumb = sBreadcrumb
            End If
            lblPath.Text = sBreadcrumb.Replace("\", " \ ")

 
            'Install Path
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
            If .GetParentPath(sCurrentDirectory) <> sResMapPath Then
                Dim dr As DataRow = dt.NewRow()
                dr("FileName") = "..."
                dr("Icon") = ""
                dr("FileUrl") = .GetParentPath(sCurrentDirectory).Substring(sResMapPath.Length)
                dt.Rows.Add(dr)
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

                dr("Icon") = "folder"
                dr("FileUrl") = .GetDirectoryInfo(cItems(i)).FullName.Substring(sResMapPath.Length)
                dt.Rows.Add(dr)
            Next

            'List All Files on the current directory
            cItems = .GetFiles(sPhysicalPath, FileIO.SearchOption.SearchTopLevelOnly)
            If cItems.Count = 0 Then
                btnDelete.Visible = False
                lblEmpty.Visible = True
            Else
                btnDelete.Visible = True
                lblEmpty.Visible = False
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
        End With
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        sPath = Server.MapPath("resources") & hidPath.Value
        If Directory.Exists(sPath) Then
            sCurrentDirectory = sPath
        End If
        
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
        hidPath.Value = "\" & dropChannels.SelectedValue
        lblPath.Text = ""

        'Refresh
        sPath = Server.MapPath("resources") & hidPath.Value
        If Directory.Exists(sPath) Then
            sCurrentDirectory = sPath
        End If
        showFiles()
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        Dim Item As String
        With My.Computer.FileSystem
            For Each Item In hidFilesToDel.Value.Split("|")
                If My.Computer.FileSystem.FileExists(Server.MapPath(Item)) Then
                    File.Delete(Server.MapPath(Item))
                End If
            Next
        End With

        'Refresh
        sPath = Server.MapPath("resources") & hidPath.Value
        If Directory.Exists(sPath) Then
            sCurrentDirectory = sPath
        End If
        showFiles()
    End Sub

    Protected Sub btnNewFolder_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))

        sPath = Server.MapPath("resources") & hidPath.Value
        
        If Directory.Exists(sPath) Then
            sCurrentDirectory = sPath
        End If
        
        Dim sPhysicalPath As String
        With My.Computer.FileSystem
            sPhysicalPath = sCurrentDirectory
            If .DirectoryExists(sPhysicalPath & "\" & txtNewFolder.Text) Then
                lblUploadStatus.Text = GetLocalResourceObject("DirectoryExist")
            Else
                .CreateDirectory(sPhysicalPath & "\" & txtNewFolder.Text)
            End If
        End With
        
        showFiles()
        txtNewFolder.Text = ""
    End Sub

    Function ShowCheckBox(ByVal sIcon As String, ByVal sUrl As String) As String
        Dim sHTML As String
        If sIcon = "folder" Or sIcon = "" Then
            sHTML = "<img src=""systems/images/ico_folder.gif""><input name=""chkSelect"" style=""display:none"" type=""checkbox"" />"
        Else
            sHTML = "<input name=""chkSelect"" type=""checkbox"" />"
        End If
        Return sHTML & "<input name=""hidSelect"" type=""hidden"" value=""" & sUrl & """ /> "
    End Function

    Function Preview(ByVal sIcon As String) As String
        Dim sHTML As String
        If sIcon = "folder" Or sIcon = "" Then
            sHTML = ""
        Else
            sHTML = "<img src=""" & sIcon & """>"
        End If
        Return sHTML
    End Function

    Function ShowFolderLink(ByVal sIcon As String) As String
        Dim sHTML As String = ""
        If sIcon <> "folder" And sIcon <> "" Then
            sHTML = "<span style=""display:none"">"
        End If
        Return sHTML
    End Function

    Function ShowDeleteFolderLink(ByVal sIcon As String) As String
        Dim sHTML As String = ""
        If sIcon <> "folder" Then
            sHTML = "<span style=""display:none"">"
        End If
        Return sHTML
    End Function
    
    Function ShowFile(ByVal sIcon As String, ByVal sUrl As String, ByVal sFileName As String) As String
        Dim sHTML As String = ""
        If sIcon <> "folder" And sIcon <> "" Then
            sHTML = "<a href=""" & sUrl & """ title="""" target=""_blank"">" & sFileName & "</a>"
        End If
        Return sHTML
    End Function

    Protected Sub GridView1_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim addButton As LinkButton = CType(e.Row.Cells(1).Controls(1), LinkButton)
            addButton.Attributes("index") = e.Row.RowIndex.ToString()
            
            Dim addButton2 As LinkButton = CType(e.Row.Cells(4).Controls(1), LinkButton)
            addButton2.Attributes("index") = e.Row.RowIndex.ToString()
            addButton2.OnClientClick = "if(!confirm('" & GetLocalResourceObject("DeleteConfirm2") & "'))return false;"
        End If
    End Sub

    Protected Sub lnkFolder_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))

        Dim lnkBtn As LinkButton = sender
        Dim index As Integer = CInt(lnkBtn.Attributes("index"))
        
        If Request.Form("hidFileFolder").Split(",")(index).Contains("/") Then
            'MsgBox(Request.Form("hidFileFolder").Split(",")(index).ToString)
        Else
            hidPath.Value = Request.Form("hidFileFolder").Split(",")(index).ToString
            
            'Refresh
            sPath = Server.MapPath("resources") & hidPath.Value
            If Directory.Exists(sPath) Then
                sCurrentDirectory = sPath
            End If
            showFiles()
        End If
    End Sub

    Protected Sub lnkFolderDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim lnkBtn As LinkButton = sender
        Dim index As Integer = CInt(lnkBtn.Attributes("index"))
        
        Dim sDirectory As String = Server.MapPath("resources") & Request.Form("hidFolderDel").Split(",")(index).ToString
        If Directory.Exists(sDirectory) Then
            Directory.Delete(sDirectory, True)
        End If

        'Refresh
        sPath = Server.MapPath("resources") & hidPath.Value
        If Directory.Exists(sPath) Then
            sCurrentDirectory = sPath
        End If
        showFiles()
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelResources" runat="server">

    <table cellpadding="0" cellspacing="0">
    <tr><td><asp:Label ID="lblChannel" meta:resourcekey="lblChannel" runat="server" Text="Channel"></asp:Label>:&nbsp;</td><td>
    <asp:DropDownList ID="dropChannels" runat="server" AutoPostBack="true">
    </asp:DropDownList>&nbsp;</td><td><asp:Label ID="lblPath" runat="server" Text=""></asp:Label>
    </td></tr></table>
    <br />
    
    <asp:HiddenField ID="hidPath" runat="server" />
     
    <table cellpadding="0" cellspacing="0" border="0" style="width:100%">
    <tr>
    <td valign="top" style="width:100%">

    <asp:GridView ID="GridView1" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" Width="100%"
        HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" 
        HeaderStyle-HorizontalAlign=left AllowPaging="False" AllowSorting="False" 
        AutoGenerateColumns="False" OnRowCreated="GridView1_RowCreated">
        <Columns>
       <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderText="" >
        <ItemTemplate>
          <%#ShowCheckBox(Eval("icon"), Eval("FileUrl"))%>
        </ItemTemplate>
        </asp:TemplateField>
       <asp:TemplateField SortExpression="FileName" ItemStyle-VerticalAlign="Middle" meta:resourcekey="lblFileName"  HeaderText="File Name" HeaderStyle-Wrap=false >
        <ItemTemplate>
            <%#ShowFolderLink(Eval("Icon"))%>
            <asp:LinkButton ID="lnkFolder" runat="server" OnClick="lnkFolder_Click"><%#Eval("FileName")%></asp:LinkButton>
            <input name="hidFileFolder" value="<%#Eval("FileUrl")%>" type="hidden" />
            </span>
            
            <%#ShowFile(Eval("Icon"), Eval("FileUrl"), Eval("FileName"))%>  
        </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField Visible="false" meta:resourcekey="lblLastUpdated" DataField="LastUpdated" HeaderText="Last Updated" SortExpression="LastUpdated">
           <ItemStyle VerticalAlign="Middle" Wrap=false/>
       </asp:BoundField>
       <asp:BoundField meta:resourcekey="lblSize" DataField="Size" ItemStyle-Font-Size=XX-Small HeaderText="Size" SortExpression="Size">
           <ItemStyle VerticalAlign="Middle" Wrap=false />
       </asp:BoundField>
       <asp:TemplateField ItemStyle-VerticalAlign="Middle"  meta:resourcekey="lblPreview"  HeaderText="Preview">
        <ItemTemplate >
            <%#ShowDeleteFolderLink(Eval("Icon"))%>
            <asp:LinkButton ID="lnkFolderDelete" runat="server" OnClick="lnkFolderDelete_Click"><%#GetLocalResourceObject("delete")%></asp:LinkButton>
            <input name="hidFolderDel" value="<%#Eval("FileUrl")%>" type="hidden" />
            </span>  
             
            <%#Preview(Eval("Icon"))%>          
        </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    </asp:GridView>
    
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
        
    </td>
    <td valign="top">
        <div style="border:#E0E0E0 1px solid;padding:10px;margin-left:20px;margin-bottom:20px">
            <asp:Label ID="lblUploadFile" meta:resourcekey="lblUploadFile" Font-Bold="true" runat="server" Text="Upload File"></asp:Label>
            <br /><br />
            <asp:FileUpload ID="FileUpload1" runat="server"/>
            <br />
            <asp:Button ID="btnUpload" meta:resourcekey="btnUpload" runat="server" Text="Upload" />
            <asp:Label ID="lblUploadStatus" runat="server" Text="" ForeColor="Red"></asp:Label>
        </div> 
        <div style="border:#E0E0E0 1px solid;padding:10px;margin-left:20px">
            <asp:Label ID="lblNewFolder" meta:resourcekey="lblNewFolder" Font-Bold="true" runat="server" Text="New Folder"></asp:Label>
            <br /><br />
            <asp:TextBox ID="txtNewFolder" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv1" ControlToValidate="txtNewFolder" ValidationGroup="NewFolder" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
            <br /><br />
            <asp:Button ID="btnNewFolder" runat="server" Text="New Folder" meta:resourcekey="btnNewFolder" OnClick="btnNewFolder_Click" ValidationGroup="NewFolder" />
        </div>
        
    </td>
    </tr>
    </table>
    <br />
    <asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text="Delete selected files"  />
        
    <br /><br />
</asp:Panel>