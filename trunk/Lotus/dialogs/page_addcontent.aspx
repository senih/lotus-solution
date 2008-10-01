<%@ Page Language="VB" ValidateRequest="false"%>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Private nPageId As Integer
    Private nRootId As Integer
    Private sContentArea As String
    Private sTemplateFolderName As String
    Private sLeftContent As String
    Private sRightContent As String

    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            'Authorization
            If Not Session(Request.QueryString("pg").ToString) Then
                'Session(nPageId.ToString) akan = true jika page bisa dibuka (di default.aspx/vb)
                Response.Write("Authorization Failed.")
                Response.End()
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RedirectForLogin()
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        
        nPageId = CInt(Request.QueryString("pg"))
        nRootId = Request.QueryString("root")
        sContentArea = Request.QueryString("area")
        
        'EDITOR
        If Not Page.IsPostBack Then
            If Profile.UseWYSIWYG Then
                If Profile.UseAdvancedEditor Then
                    txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Advance
                    lnkQuickEdit.Visible = True
                    lnkAdvEdit.Visible = False
                    hidEditorType.Value = "advanced"
                    
                    If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                        txtAddContent.Height = 315
                    Else
                        txtAddContent.Height = 422
                    End If
                    
                Else
                    txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Quick
                    lnkQuickEdit.Visible = False
                    lnkAdvEdit.Visible = True
                    hidEditorType.Value = "quick"
                    
                    If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                        txtAddContent.Height = 398
                    Else
                        txtAddContent.Height = 422
                    End If
                    
                End If
            Else
                txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Quick
                hidEditorType.Value = "quick"

                If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                    txtAddContent.Height = 398
                Else
                    txtAddContent.Height = 422
                End If
            End If
        End If


        Dim oDataReader As SqlDataReader
        Dim oContentManager As ContentManager = New ContentManager
        oDataReader = oContentManager.GetWorkingContentById(nPageId)
        If oDataReader.Read Then
            sTemplateFolderName = oDataReader("folder_name").ToString
            sLeftContent = oDataReader("content_left").ToString
            sRightContent = oDataReader("content_right").ToString
        End If
        oDataReader.Close()
        oContentManager = Nothing

        '~~~~~~~~~~~~ txtAddContent ~~~~~~~~~~~
        txtAddContent.Css = "../templates/" & sTemplateFolderName & "/editing.css"

        Dim grpEdit As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit", "", New String() {"Undo", "Redo", "Search", "FullScreen", "XHTMLSource", "BRK", "Cut", "Copy", "Paste", "PasteWord", "PasteText"})
        Dim grpFont As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpFont", "", New String() {"FontName", "FontSize", "RemoveFormat", "BRK", "Bold", "Italic", "Underline", "Strikethrough", "Superscript", "ForeColor", "BackColor", "StyleAndFormatting"})
        Dim grpPara As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpPara", "", New String() {"Paragraph", "Indent", "Outdent", "BRK", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyFull", "Numbering", "Bullets"})
        Dim grpInsert As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("Insert", "", New String() {"Image", "Hyperlink", "BRK", "CustomTag"})
        Dim grpObjects As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpObjects", "", New String() {"Flash", "Media", "CustomObject", "InternalLink", "BRK", "Characters", "Line", "Bookmark"})
        Dim grpTables As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpTables", "", New String() {"Table", "BRK", "Guidelines"})
        Dim grpStyles As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpStyles", "", New String() {"Styles", "BRK", "Absolute"})

        Dim tabHome As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit, grpFont, grpPara, grpInsert})
        txtAddContent.ToolbarTabs.Add(tabHome)

        Dim tabStyle As InnovaStudio.ISTab = New InnovaStudio.ISTab("tabStyle", "Objects & Styles")
        tabStyle.Groups.AddRange(New InnovaStudio.ISGroup() {grpObjects, grpTables, grpStyles})
        txtAddContent.ToolbarTabs.Add(tabStyle)
        
        txtAddContent.InternalLinkWidth = 500
        txtAddContent.InternalLinkHeight = 500
        txtAddContent.InternalLink = "page_links.aspx?c=" & sCulture & "&root=" & nRootId

        txtAddContent.CustomObjectWidth = 650
        txtAddContent.CustomObjectHeight = 570
        txtAddContent.CustomObject = "page_resources.aspx?c=" & sCulture & "&pg=" & nPageId
        
        lnkInsertPageLinks.OnClientClick = "modalDialog('../dialogs/page_links.aspx?c=" & sCulture & "&root=" & nRootId & "',500,500);return false;"
        lnkInsertResources.OnClientClick = "modalDialog('../dialogs/page_resources.aspx?c=" & sCulture & "&pg=" & nPageId & "',600,570);return false;"

        txtAddContent.CustomTags.Add(New InnovaStudio.Param("&nbsp;&nbsp;BREAK&nbsp;&nbsp;", "[%BREAK%]"))

        txtAddContent.CustomColors = New String() {"#ff4500", "#ffa500", "#808000", "#4682b4", "#1e90ff", "#9400d3", "#ff1493", "#a9a9a9"}

        txtAddContent.EditMode = InnovaStudio.EditorModeEnum.XHTMLBody
        '~~~~~~~~~~~~ /txtAddContent ~~~~~~~~~~~
        
        If Not Page.IsPostBack Then
            dropPlacement.Items.Clear()
            If sContentArea = "left" Then
                dropPlacement.Items.Add(New ListItem(GetLocalResourceObject("LeftContent"), "Left"))
                txtAddContent.Text = sLeftContent
            ElseIf sContentArea = "right" Then
                dropPlacement.Items.Add(New ListItem(GetLocalResourceObject("RightContent"), "Right"))
                txtAddContent.Text = sRightContent
            Else
                dropPlacement.Items.Add(New ListItem(GetLocalResourceObject("LeftContent"), "Left"))
                dropPlacement.Items.Add(New ListItem(GetLocalResourceObject("RightContent"), "Right"))
                txtAddContent.Text = sLeftContent
            End If
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()
        Dim oContentManager As ContentManager = New ContentManager
        If dropPlacement.SelectedValue = "Left" Then
            oContentManager.SaveContent(nPageId, txtAddContent.Text, "Left")
        Else
            oContentManager.SaveContent(nPageId, txtAddContent.Text, "Right")
        End If
        oContentManager = Nothing

        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")
        
        If hidEditorType.Value = "quick" Then
            txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Quick
            
            If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                txtAddContent.Height = 398
            Else
                txtAddContent.Height = 422
            End If
        Else
            txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Advance
            
            If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                txtAddContent.Height = 315
            Else
                txtAddContent.Height = 422
            End If
        End If
    End Sub

    Protected Sub dropPlacement_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        nPageId = CInt(Request.QueryString("pg"))
        
        Dim oDataReader As SqlDataReader
        Dim oContentManager As ContentManager = New ContentManager
        oDataReader = oContentManager.GetWorkingContentById(nPageId)
        If oDataReader.Read Then
            sTemplateFolderName = oDataReader("folder_name").ToString
            sLeftContent = oDataReader("content_left").ToString
            sRightContent = oDataReader("content_right").ToString
        End If
        oDataReader.Close()
        oContentManager = Nothing
        
        If hidEditorType.Value = "quick" Then
            txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Quick
            
            If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                txtAddContent.Height = 398
            Else
                txtAddContent.Height = 422
            End If
        Else
            txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Advance
            
            If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
                txtAddContent.Height = 315
            Else
                txtAddContent.Height = 422
            End If
        End If
        
        If dropPlacement.SelectedValue = "Left" Then
            txtAddContent.Text = sLeftContent
        End If
        
        If dropPlacement.SelectedValue = "Right" Then
            txtAddContent.Text = sRightContent
        End If
        
        lblSaveStatus.Text = ""
    End Sub

    Protected Sub lnkQuickEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Quick
        lnkQuickEdit.Visible = False
        lnkAdvEdit.Visible = True
        hidEditorType.Value = "quick"
        lblSaveStatus.Text = ""
        txtAddContent.Height = 340
        
        If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
            txtAddContent.Height = 398
        Else
            txtAddContent.Height = 422
        End If
    End Sub

    Protected Sub lnkAdvEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sAddContent As String = txtAddContent.Text
        txtAddContent.EditorType = InnovaStudio.EditorTypeEnum.Advance
        lnkQuickEdit.Visible = True
        lnkAdvEdit.Visible = False
        hidEditorType.Value = "advanced"
        lblSaveStatus.Text = ""

        If InStr(HttpContext.Current.Request.Browser.Type, "IE") Then
            txtAddContent.Height = 315
        Else
            txtAddContent.Height = 422
        End If
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<base target="_self">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script>
    function modalDialogShow_IE(url,width,height) //IE
	    {
	    return window.showModalDialog(url,window,
		    "dialogWidth:"+width+"px;dialogHeight:"+height+"px;edge:Raised;center:Yes;help:No;Resizable:Yes;Maximize:Yes");
	    }
    function modalDialogShow_Moz(url,width,height) //Moz
        {
        var left = screen.availWidth/2 - width/2;
        var top = screen.availHeight/2 - height/2;
        activeModalWin = window.open(url, "", "width="+width+"px,height="+height+",left="+left+",top="+top+",scrollbars=yes,resizable=yes");
        window.onfocus = function(){if (activeModalWin.closed == false){activeModalWin.focus();};};
        
        }
    function modalDialog(url,width,height)
	    {
	    if(navigator.appName.indexOf('Microsoft')!=-1)
		    return modalDialogShow_IE(url,width,height); //IE	
	    else
		    modalDialogShow_Moz(url,width,height); //Moz	
	    }
//    window.onresize = resize;
//    function resize()
//        {
//        document.getElementById("idAreaoEdit_<%=txtAddContent.ClientID %>").style.width="100%";
//        document.getElementById("idAreaoEdit_<%=txtAddContent.ClientID %>").style.height="100%";
//        }
    function adjustHeight()
        {
//        if(navigator.appName.indexOf('Microsoft')!=-1)
//            document.getElementById('cellContent').height=305;
//        else
//            document.getElementById('cellContent').height=400;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:0px;background-color:#E6E7E8;width:100%;overflow:hidden">
<form id="form1" runat="server">
<table border="0" cellpadding="0" cellspacing="0" style="width:100%;height:100%">
<tr>
    <td colspan="2" style="text-align:right">
        <asp:DropDownList ID="dropPlacement" AutoPostBack="true" runat="server" OnSelectedIndexChanged="dropPlacement_SelectedIndexChanged">
        </asp:DropDownList>
    </td>
</tr>
<tr>
    <td valign="top" style="padding-top:5px;padding-left:7px">
        <asp:LinkButton ID="lnkAdvEdit" meta:resourcekey="lnkAdvEdit" runat="server" OnClick="lnkAdvEdit_Click">Advanced Mode</asp:LinkButton>               
        <asp:LinkButton ID="lnkQuickEdit" meta:resourcekey="lnkQuickEdit" runat="server" Visible="false" OnClick="lnkQuickEdit_Click">Quick Mode</asp:LinkButton> 
    </td>
    <td align="right" valign="top" style="padding:3px">
        <table summary="" cellpadding="0" cellspacing="0">
        <tr>
        <td style="padding-left:3px;padding-right:3px;padding-top:1px">
            <asp:Label ID="lblInsertPageResources2" meta:resourcekey="lblInsertPageResources" runat="server" Text="Insert:"></asp:Label>&nbsp;
        </td>
        <td style="padding-left:3px;padding-right:3px;">
            <img src="../systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
        </td>
        <td style="padding-left:3px;padding-right:3px;">
            <asp:LinkButton ID="lnkInsertPageLinks" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
        </td>
        <td style="padding-left:3px;padding-right:3px;">
            <img src="../systems/images/ico_InsertResources.gif" style="margin-top:3px" />
        </td>
        <td style="padding-left:3px;padding-right:3px;">
            <asp:LinkButton ID="lnkInsertResources" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
        </td>
        </tr>
        </table>  
    </td>
</tr>
<tr>
    <td colspan="2" id="cellContent" style="height:340px" valign="top">
        <editor:WYSIWYGEditor runat="server" ID="txtAddContent" 
            scriptPath="../systems/editor/scripts/" 
            EditMode="XHTMLBody" 
            Width="100%"            
            Text="" />
        <asp:HiddenField ID="hidEditorType" runat="server" />
    </td>
</tr>
<tr>
    <td colspan="2" align="right" style="padding:10px;padding-right:15px;">
        <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold="true"></asp:Label>
        <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" OnClientClick="self.close()" Text=" Close " />
        <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />        
    </td>
</tr>
</table>

</form>
</body>
</html>
