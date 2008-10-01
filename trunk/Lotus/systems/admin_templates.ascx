<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="TemplateManager" %> 
<%@ Import Namespace="CMSTemplate" %> 

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                If Not IsNothing(Request.QueryString("lt_id")) And Not Page.IsPostBack Then
                    panelViewTemplates.Visible = False
                    panelEditListingTemplate.Visible = True
                    EditListingTemplate()
                    
                    dropInsertTag.Attributes.Add("onchange", "insertTag(this,'" & txtListingTemplate2.ClientID & "',this.value)")
                    txtListingTemplate2.Attributes.Add("onselect", "saveSel(this)")
                    txtListingTemplate2.Attributes.Add("onclick", "saveSel(this)")
                    txtListingTemplate2.Attributes.Add("onkeyup", "saveSel(this)")
                    
                    dropInsertTagHeader.Attributes.Add("onchange", "insertTag(this,'" & txtListingTemplateHeader.ClientID & "',this.value)")
                    txtListingTemplateHeader.Attributes.Add("onselect", "saveSel(this)")
                    txtListingTemplateHeader.Attributes.Add("onclick", "saveSel(this)")
                    txtListingTemplateHeader.Attributes.Add("onkeyup", "saveSel(this)")
                    
                    dropInsertTagFooter.Attributes.Add("onchange", "insertTag(this,'" & txtListingTemplateFooter.ClientID & "',this.value)")
                    txtListingTemplateFooter.Attributes.Add("onselect", "saveSel(this)")
                    txtListingTemplateFooter.Attributes.Add("onclick", "saveSel(this)")
                    txtListingTemplateFooter.Attributes.Add("onkeyup", "saveSel(this)")
                    Exit Sub
                End If
                
                panelViewTemplates.Visible = True
                txtTemplateName.Focus()
                panelEditListingTemplate.Visible = False
               
                Dim oTemplates As TemplateManager = New TemplateManager
                grvTemplates.DataSource = oTemplates.ListAllTemplates()
                grvTemplates.DataBind()
                
                Dim sqlDS As SqlDataSource = New SqlDataSource
                sqlDS.ConnectionString = sConn
                sqlDS.SelectCommand = "Select * From listing_templates order by template_name"
                'sqlDS.SelectParameters.Add("date_from", SqlDbType.DateTime)

                grvListingTemplates.DataSource = sqlDS
                grvListingTemplates.DataBind()
                 
                Dim sqlDS2 As SqlDataSource = New SqlDataSource
                sqlDS2.ConnectionString = sConn
                sqlDS2.SelectCommand = "SELECT id, template_name FROM listing_templates order by template_name"
                dropListingTemplates.Items.Clear()
                dropListingTemplates.DataValueField = "id"
                dropListingTemplates.DataTextField = "template_name"
                dropListingTemplates.DataSource = sqlDS2
                dropListingTemplates.DataBind()
            End If
        End If
    End Sub
    
    Protected Sub grvTemplates_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim oTemplates As TemplateManager = New TemplateManager
        Dim oDeletedTemplate As CMSTemplate = New CMSTemplate
        Dim iIndex As Integer
        iIndex = e.RowIndex()
        oDeletedTemplate = oTemplates.GetTemplateByName(grvTemplates.Rows.Item(iIndex).Cells(0).Text)
         
        Dim nReturn As Integer
        nReturn = oTemplates.DeleteTemplate(oDeletedTemplate.TemplateId)
        If nReturn = 0 Then
            lblStatus.Visible = True
        Else
            lblStatus.Visible = False
        End If
 
        grvTemplates.DataSource = oTemplates.ListAllTemplates()
        grvTemplates.DataBind()
    End Sub
    
    Protected Sub grvTemplates_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grvTemplates.PageIndexChanging
        Dim iIndex As Integer = e.NewPageIndex()
        grvTemplates.PageIndex = iIndex
        Dim oTemplates As TemplateManager = New TemplateManager
        grvTemplates.DataSource = oTemplates.ListAllTemplates()
        grvTemplates.DataBind()
    End Sub

    Protected Sub grvTemplates_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvTemplates.Rows.Count - 1
            CType(grvTemplates.Rows(i).Cells(2).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
        Protected Sub btnRegisterTemplate_click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegisterTemplate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim bTemplateExist As Boolean = False
        Dim oNewTemplate As CMSTemplate = New CMSTemplate
        Dim oTemplate As TemplateManager = New TemplateManager
        
        oNewTemplate.TemplateName = txtTemplateName.Text
        oNewTemplate.FolderName = txtFolderName.Text

        'oNewTemplate.LayoutType = CInt(rdoLayoutType.SelectedValue)
        If txtFolderName.Text.Contains(" ") Or _
            txtFolderName.Text.Contains("\") Or _
            txtFolderName.Text.Contains("/") Or _
            txtFolderName.Text.Contains(":") Or _
            txtFolderName.Text.Contains("*") Or _
            txtFolderName.Text.Contains("?") Or _
            txtFolderName.Text.Contains("""") Or _
            txtFolderName.Text.Contains("<") Or _
            txtFolderName.Text.Contains(">") Or _
            txtFolderName.Text.Contains("|") Then
            GetLocalResourceObject("CannotContain")
            lblStatus2.Text = GetLocalResourceObject("CannotContain")
            '"Template folder name cannot contain spaces or any of the following characters: \/:*?""<>|"
            Exit Sub
        End If
        
        If IsNothing(oTemplate.CreateTemplate(oNewTemplate)) Then
            bTemplateExist = True
            lblStatus2.Text = GetLocalResourceObject("AlreadyExists")
            '"Template already exists."
            Exit Sub
        End If
        
        Response.Redirect(Me.LinkAdminTemplates)
    End Sub
    
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnNewListingTemplate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sTemplate As String = ""
        Dim nListingType As Integer = 1
        Dim nListingProperty As Integer = 2
        Dim nListingColumns As Integer = 1
        Dim nListingPageSize As Integer = 12
        Dim bListingUseCategories As Boolean = 1
        Dim sListingDefaultOrder As String = "last_updated_date"
        Dim sTemplateHeader As String = ""
        Dim sTemplateFooter As String = ""
        Dim sListingScript As String = ""
        
        oConn.Open()
        Dim cmd As SqlCommand
        Dim reader As SqlDataReader
        
        cmd = New SqlCommand("SELECT * from listing_templates WHERE id=@id", oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@id", SqlDbType.Int).Value = dropListingTemplates.SelectedValue
        reader = cmd.ExecuteReader()
        If reader.Read Then
            sTemplate = reader("template").ToString()
            nListingType = CInt(reader("listing_type"))
            nListingProperty = CInt(reader("listing_property"))
            nListingColumns = CInt(reader("listing_columns"))
            nListingPageSize = CInt(reader("listing_page_size"))
            bListingUseCategories = Convert.ToBoolean(reader("listing_use_categories"))
            sListingDefaultOrder = reader("listing_default_order").ToString()
            sTemplateHeader = reader("template_header").ToString()
            sTemplateFooter = reader("template_footer").ToString()
            sListingScript = reader("listing_script").ToString()
        End If
        reader.Close()
        
        cmd = New SqlCommand("INSERT INTO listing_templates (template_name,template,template_header,template_footer,listing_script,listing_type,listing_property,listing_columns,listing_page_size,listing_use_categories,listing_default_order) VALUES (@template_name,@template,@template_header,@template_footer,@listing_script,@listing_type,@listing_property,@listing_columns,@listing_page_size,@listing_use_categories,@listing_default_order)  SELECT @@Identity as new_id", oConn)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@template_name", SqlDbType.NVarChar, 50).Value = txtListingTemplateName.Text
        
        cmd.Parameters.Add("@template", SqlDbType.NText).Value = sTemplate
        cmd.Parameters.Add("@template_header", SqlDbType.NText).Value = sTemplateHeader
        cmd.Parameters.Add("@template_footer", SqlDbType.NText).Value = sTemplateFooter
        cmd.Parameters.Add("@listing_type", SqlDbType.Int).Value = nListingType
        cmd.Parameters.Add("@listing_property", SqlDbType.Int).Value = nListingProperty
        cmd.Parameters.Add("@listing_columns", SqlDbType.Int).Value = nListingColumns
        cmd.Parameters.Add("@listing_page_size", SqlDbType.Int).Value = nListingPageSize
        cmd.Parameters.Add("@listing_use_categories", SqlDbType.Bit).Value = bListingUseCategories
        cmd.Parameters.Add("@listing_default_order", SqlDbType.NVarChar).Value = sListingDefaultOrder
        cmd.Parameters.Add("@listing_script", SqlDbType.NText).Value = sListingScript
        Dim nNewId As Integer = 0
        reader = cmd.ExecuteReader()
        If reader.Read Then
            nNewId = reader("new_id")
        End If
        reader.Close()
        oConn.Close()
        oConn = Nothing
        'If nNewId = 0 Then
        '    Response.Redirect(Me.LinkAdminTemplates)
        'Else
        '    Response.Redirect(Me.LinkAdminTemplates & "?lt_id=" & nNewId)
        'End If
        Response.Redirect(Me.LinkAdminTemplates)
    End Sub

    Protected Sub grvListingTemplates_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvListingTemplates.Rows.Count - 1
            CType(grvListingTemplates.Rows(i).Cells(2).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub grvListingTemplates_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        Dim sql As String = "SELECT listing_template_id FROM pages_published WHERE listing_template_id=@listing_template_id " & _
            "UNION ALL SELECT listing_template_id FROM pages_working WHERE listing_template_id=@listing_template_id ORDER BY listing_template_id"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        Dim iIndex As Integer = grvListingTemplates.DataKeys(e.RowIndex).Value

        oCmd.Parameters.Add("@listing_template_id", SqlDbType.Int).Value = iIndex
        oConn.Open()
        oCmd.Connection = oConn
        Dim reader As SqlDataReader = oCmd.ExecuteReader
        If (reader.Read) Then
            'listing template is used
            oCmd = Nothing
            oConn.Close()
            oConn = Nothing
            lblStatus3.Visible = True
            Exit Sub
        End If
        reader.Close()

        oCmd = New SqlCommand("DELETE FROM listing_templates WHERE id=@id")
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = iIndex
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        oConn = Nothing
        
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub btnSaveListingTemplate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        
        Dim sql As String = "UPDATE listing_templates set listing_script=@listing_script,template_name=@template_name,template=@template,template_header=@template_header,template_footer=@template_footer,listing_type=@listing_type,listing_property=@listing_property,listing_columns=@listing_columns,listing_page_size=@listing_page_size,listing_use_categories=@listing_use_categories,listing_default_order=@listing_default_order where id=@id"
        Dim oCmd As SqlCommand = New SqlCommand(sql)
        oCmd.CommandType = CommandType.Text
        
        oCmd.Parameters.Add("@id", SqlDbType.Int).Value = CInt(hidListingTemplateId.Value)
        oCmd.Parameters.Add("@template_name", SqlDbType.NVarChar, 50).Value = txtListingTemplateName2.Text
        oCmd.Parameters.Add("@template", SqlDbType.NText).Value = txtListingTemplate2.Text
        oCmd.Parameters.Add("@template_header", SqlDbType.NText).Value = txtListingTemplateHeader.Text
        oCmd.Parameters.Add("@template_footer", SqlDbType.NText).Value = txtListingTemplateFooter.Text
        oCmd.Parameters.Add("@listing_script", SqlDbType.NText).Value = txtListingScript.Text
        
        Dim nListingType As Integer
        Dim nListingProperty As Integer
        Dim nListingColumns As Integer
        Dim nListingPageSize As Integer
        Dim bListingUseCategories As Boolean
        Dim sListingDefaultOrder As String
        If rdoListingTypeGeneral.Checked Then
            nListingType = 1

            If rdoShowListingOnSiteMap.Checked Then
                nListingProperty = 1
            ElseIf rdoHideListingOnSiteMap.Checked Then
                If Not rdoManualOrder.Checked Then
                    nListingProperty = 2
                Else
                    nListingProperty = 3
                End If
            End If
        Else 'rdoListingTypeNews.Checked Then
            nListingType = 2
            nListingProperty = 2
        End If
        nListingColumns = CInt(dropListingColumns.SelectedValue)
        nListingPageSize = CInt(txtListingPageSize.Text)
        bListingUseCategories = chkListingUseCategories.Checked
        sListingDefaultOrder = dropDefaultOrder.SelectedValue
        
        oCmd.Parameters.Add("@listing_type", SqlDbType.Int).Value = nListingType
        oCmd.Parameters.Add("@listing_property", SqlDbType.Int).Value = nListingProperty
        oCmd.Parameters.Add("@listing_columns", SqlDbType.Int).Value = nListingColumns
        oCmd.Parameters.Add("@listing_page_size", SqlDbType.Int).Value = nListingPageSize
        oCmd.Parameters.Add("@listing_use_categories", SqlDbType.Bit).Value = bListingUseCategories
        oCmd.Parameters.Add("@listing_default_order", SqlDbType.NVarChar).Value = sListingDefaultOrder
        
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
        oConn = Nothing
        Response.Redirect(Me.LinkAdminTemplates)
    End Sub
    
    Protected Sub grvListingTemplates_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim iIndex As Integer = grvListingTemplates.SelectedDataKey.Value
        Response.Redirect(Me.LinkAdminTemplates & "?lt_id=" & iIndex)
    End Sub
    
    Protected Sub EditListingTemplate()
        Dim nListingType As Integer
        Dim nListingProperty As Integer
        Dim nListingColumns As Integer
        Dim nListingPageSize As Integer
        Dim bListingUseCategories As Boolean
        Dim sListingDefaultOrder As String
        
        oConn.Open()
        Dim cmd As SqlCommand
        cmd = New SqlCommand("Select * From listing_templates where id=@id", oConn)
        cmd.Parameters.Add("@id", SqlDbType.Int).Value = Request.QueryString("lt_id")
        cmd.CommandType = CommandType.Text
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read Then
            hidListingTemplateId.Value = reader("id").ToString()
            txtListingTemplateName2.Text = reader("template_name").ToString()
            txtListingTemplate2.Text = reader("template").ToString()
            txtListingTemplateHeader.Text = reader("template_header").ToString()
            txtListingTemplateFooter.Text = reader("template_footer").ToString()
            txtListingScript.Text = reader("listing_script").ToString()
                        
            nListingType = CInt(reader("listing_type"))
            nListingProperty = CInt(reader("listing_property"))
            nListingColumns = CInt(reader("listing_columns"))
            nListingPageSize = CInt(reader("listing_page_size"))
            bListingUseCategories = Convert.ToBoolean(reader("listing_use_categories"))
            sListingDefaultOrder = reader("listing_default_order").ToString()
            
            'Generate SQL Script
            Dim nB As Integer
            If bListingUseCategories Then
                nB = 1
            Else
                nB = 0
            End If
            txtSQL.Text = "INSERT INTO listing_templates (template_name,listing_type,listing_property," & _
                "listing_default_order,listing_columns,listing_page_size,listing_use_categories," & _
                "template,template_header,template_footer,listing_script) VALUES " & _
                "('" & reader("template_name").ToString() & "'," & nListingType & "," & _
                nListingProperty & "," & _
                "'" & sListingDefaultOrder & "'," & _
                nListingColumns & "," & _
                nListingPageSize & "," & _
                nB & "," & _
                "'" & reader("template").ToString().Replace("'", "''").Replace(vbCrLf, "'+CHAR(13)+'") & "'," & _
                "'" & reader("template_header").ToString().Replace("'", "''").Replace(vbCrLf, "'+CHAR(13)+'") & "'," & _
                "'" & reader("template_footer").ToString().Replace("'", "''").Replace(vbCrLf, "'+CHAR(13)+'") & "'," & _
                "'" & reader("listing_script").ToString().Replace("'", "''").Replace(vbCrLf, "'+CHAR(13)+'") & "')"
            txtSQL.Visible = False
            '/Generate SQL Script
            
            If nListingType = 1 Then
                rdoListingTypeGeneral.Checked = True
                divListingSettings.Style.Add("display", "block")
            Else ' nListingType = 2
                rdoListingTypeNews.Checked = True
                divListingSettings.Style.Add("display", "none")
            End If

            rdoListingTypeNews.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divListingSettings.ClientID & "').style.display='none'}")
            rdoListingTypeGeneral.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divListingSettings.ClientID & "').style.display='block'}")

            If nListingProperty = 1 Then
                rdoShowListingOnSiteMap.Checked = True
                divManualOrder.Style.Add("display", "none")
                rdoDefaultOrder.Checked = True
            ElseIf nListingProperty = 2 Then
                rdoHideListingOnSiteMap.Checked = True
                divManualOrder.Style.Add("display", "block")
                rdoDefaultOrder.Checked = True
            Else
                rdoHideListingOnSiteMap.Checked = True
                divManualOrder.Style.Add("display", "block")
                rdoManualOrder.Checked = True
            End If

            If Not sListingDefaultOrder = "" Then
                dropDefaultOrder.SelectedValue = sListingDefaultOrder
            End If

            rdoShowListingOnSiteMap.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divManualOrder.ClientID & "').style.display='none'}")
            rdoHideListingOnSiteMap.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & divManualOrder.ClientID & "').style.display='block'}")

            If nListingColumns = 0 Or nListingColumns.ToString = "" Then
                dropListingColumns.SelectedValue = 1
            Else
                dropListingColumns.SelectedValue = nListingColumns
            End If
            If nListingPageSize = 0 Or nListingPageSize.ToString = "" Then
                txtListingPageSize.Text = 10
            Else
                txtListingPageSize.Text = nListingPageSize
            End If
            chkListingUseCategories.Checked = bListingUseCategories
        End If
        reader.Close()
        oConn.Close()
        oConn = Nothing
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkAdminTemplates)
    End Sub

    Protected Sub grvListingTemplates_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)
        Dim iIndex As Integer = e.NewPageIndex()
        grvListingTemplates.PageIndex = iIndex
        
        Dim sqlDS As SqlDataSource = New SqlDataSource
        sqlDS.ConnectionString = sConn
        sqlDS.SelectCommand = "Select * From listing_templates order by template_name"
        sqlDS.SelectParameters.Add("date_from", SqlDbType.DateTime)

        grvListingTemplates.DataSource = sqlDS
        grvListingTemplates.DataBind()
    End Sub
</script>


<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelViewTemplates" runat="server" Wrap=false Visible="false">

<table cellpadding="0" cellspacing="0">
<tr>
<td valign="top" style="padding-right:15px">

<asp:GridView ID="grvTemplates"  GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server" 
AllowPaging="true" PageSize="25" AutoGenerateColumns=false OnRowDeleting="grvTemplates_RowDeleting"  OnPreRender="grvTemplates_PreRender"> 
    <Columns>
        <asp:BoundField meta:resourcekey="colTemplateName" HeaderText="Name" DataField="TemplateName" ItemStyle-Wrap="false" />
        <asp:BoundField meta:resourcekey="colFolder" HeaderText="Folder" DataField="FolderName" />            
        <asp:CommandField meta:resourcekey="colDelete" DeleteText="Delete" HeaderText="" ShowDeleteButton=true />
    </Columns> 
</asp:GridView>

<div style="padding-top:7px">
  <asp:Label ID="lblStatus" meta:resourcekey="lblStatus" runat="server" Text="Delete Failed. Template is in use." Font-Bold=true Visible="false"></asp:Label> 
</div>

<table >
    <tr>
        <td colspan="2" style="padding-bottom:7px">
            <asp:Label ID="lblNewTemplate" meta:resourcekey="lblNewTemplate" Font-Bold="true" runat="server" Text="New Template"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblTemplateName" meta:resourcekey="lblTemplateName" runat="server" Text="Name"></asp:Label>
        </td>
        <td>:</td>
        <td style="white-space:nowrap">
            <asp:TextBox ID="txtTemplateName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="*" ControlToValidate="txtTemplateName" ValidationGroup="Template"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td nowrap="nowrap">
            <asp:Label ID="lblFolderName" meta:resourcekey="lblFolderName" runat="server" Text="Folder"></asp:Label>
        </td>
        <td>:</td>
        <td nowrap="nowrap">
            <asp:TextBox ID="txtFolderName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtFolderName" ValidationGroup="Template"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td colspan="3" valign="top" style="padding-top:7px">
            <asp:Button ID="btnRegisterTemplate" meta:resourcekey="btnRegisterTemplate" runat="server" Text=" Save " OnClick="btnRegisterTemplate_click" ValidationGroup="Template" />
            <div style="margin:8px"></div>
            <asp:Label ID="lblStatus2" Font-Bold=true runat="server" Text=""></asp:Label>       
        </td>
    </tr>
</table>

</td>
<td valign="top" style="border-left:#C0C0C0 1px solid;padding-left:15px">

<asp:GridView ID="grvListingTemplates" DataKeyNames="id" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding="7" HeaderStyle-HorizontalAlign="Left" runat="server" 
AllowPaging="true" PageSize="25" AutoGenerateColumns=false OnPreRender="grvListingTemplates_PreRender" OnRowDeleting="grvListingTemplates_RowDeleting" OnSelectedIndexChanged="grvListingTemplates_SelectedIndexChanged" OnPageIndexChanging="grvListingTemplates_PageIndexChanging"> 
    <Columns>
        <asp:BoundField meta:resourcekey="colListingTemplateName" HeaderText="Name" DataField="template_name" ItemStyle-Wrap="false" />
        <asp:CommandField meta:resourcekey="colEdit" SelectText="Edit" HeaderText="" ShowSelectButton=true />
        <asp:CommandField meta:resourcekey="colDelete" DeleteText="Delete" HeaderText="" ShowDeleteButton=true />
    </Columns> 
</asp:GridView>

<div style="padding-top:7px">
  <asp:Label ID="lblStatus3" meta:resourcekey="lblStatus" runat="server" Text="Delete Failed. Template is in use." Font-Bold=true Visible="false"></asp:Label> 
</div>

<table>
<tr>
    <td colspan="3" style="padding-top:10px;padding-bottom:5px">
        <asp:Label ID="lblNewListingTemplate" meta:resourcekey="lblNewListingTemplate" Font-Bold="true" runat="server"></asp:Label>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblListingTemplateName" meta:resourcekey="lblListingTemplateName" runat="server" Text="Name"></asp:Label></td>
    <td>:</td>
    <td><asp:TextBox ID="txtListingTemplateName" runat="server"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtListingTemplateName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td><asp:Label runat="server" ID="lblCopyFromTemplate" meta:resourcekey="lblCopyFromTemplate" Text="Copy from template"></asp:Label></td>
    <td>:</td>
    <td>
    <asp:DropDownList ID="dropListingTemplates" runat="server">
    </asp:DropDownList>
    </td>
</tr>
<tr>
    <td colspan="3" valign="top" style="padding-top:7px">
        <asp:Button ID="btnNewListingTemplate" meta:resourcekey="btnNewListingTemplate" runat="server" Text=" Save " ValidationGroup="ListingTemplate" OnClick="btnNewListingTemplate_Click" />
    </td>
</tr>
</table>

</td>
</tr>
</table>

</asp:Panel>

<asp:Panel ID="panelEditListingTemplate" Visible="false" runat="server">
<asp:HiddenField ID="hidListingTemplateId" runat="server" />
<table>
<tr>
    <td colspan="3" style="padding-bottom:5px">
        <asp:Label ID="lblEditListingTemplate" meta:resourcekey="lblEditListingTemplate" Font-Bold="true" runat="server"></asp:Label>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblListingTemplateName2" meta:resourcekey="lblListingTemplateName" ValidationGroup="EditListingTemplate" runat="server" Text="Name"></asp:Label></td>
    <td>:</td>
    <td>
        <asp:TextBox ID="txtListingTemplateName2" Width="200" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtListingTemplateName" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td colspan="3" style="text-align:right">
        <table cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
        <td style="width:100%">
        </td>
        <td>
            <asp:Label ID="Label1" meta:resourcekey="lblInsert" runat="server" Text="Insert:"></asp:Label>&nbsp;
        </td>
        <td style="text-align:right">
            <script language="javascript" type="text/javascript">
            function insertTag(e,id,tag)
                {
                try
                    {
                    var oSel=document.getElementById(id).pos;
                    oSel.select();
                    oSel.text=tag;
                    }
                catch(e){}
                e.value="";
                }  
            function saveSel(e)
                {
                e.pos = document.selection.createRange();
                }      
            </script>

            <asp:DropDownList ID="dropInsertTagHeader" AutoPostBack="false" runat="server">
            <asp:ListItem Text="" Value=""></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTab" Text="TAB" Value="	"></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTitle" Text="Title" Value="[%TITLE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optURL" Text="URL" Value="[%READ_MORE%]"></asp:ListItem>
            </asp:DropDownList>  
        </td>
        </tr>
        </table>  
    </td>
</tr>
<tr>
    <td valign="top"><asp:Label ID="lblListingTemplateHeader" meta:resourcekey="lblListingTemplateHeader" runat="server" Text="Header Template"></asp:Label></td>
    <td valign="top">:</td>
    <td>
    <asp:TextBox ID="txtListingTemplateHeader" TextMode="MultiLine" Rows="5" Wrap=false Width="510px" Font-Names=Arial ValidationGroup="EditListingTemplate" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td colspan="3" style="text-align:right">
        <table cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
        <td style="width:100%">
        </td>
        <td>
            <asp:Label ID="lblInsert" meta:resourcekey="lblInsert" runat="server" Text="Insert:"></asp:Label>&nbsp;
        </td>
        <td style="text-align:right">
            <asp:DropDownList ID="dropInsertTag" AutoPostBack="false" runat="server">
            <asp:ListItem Text="" Value=""></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTab" Text="TAB" Value="	"></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTitle" Text="Title" Value="[%TITLE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optURL" Text="URL" Value="[%FILE_NAME%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optLinkTarget" Text="Link Target" Value="[%LINK_TARGET%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optSummary" Text="Summary" Value="[%SUMMARY%]"></asp:ListItem>        
            <asp:ListItem meta:resourcekey="optDisplayDate" Text="Display Date" Value="[%DISPLAY_DATE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optCategoryInfo" Text="Category Info" Value="[%CATEGORY_INFO%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optFileDownload" Text="File Download" Value="[%FILE_DOWNLOAD%]"></asp:ListItem>        
            <asp:ListItem meta:resourcekey="optFileDownloadURL" Text="File Download URL" Value="[%FILE_DOWNLOAD_URL%]"></asp:ListItem>        
            <asp:ListItem meta:resourcekey="optFileDownloadSize" Text="File Download Size" Value="[%FILE_SIZE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optFileDownloadIcon" Text="File Download Icon" Value="[%FILE_DOWNLOAD_ICON%]"></asp:ListItem>  
            <asp:ListItem meta:resourcekey="optHideFileDownload" Text="Hide File Download" Value="[%HIDE_FILE_DOWNLOAD%]"></asp:ListItem>        
            <asp:ListItem meta:resourcekey="optFileViewURL" Text="File View URL" Value="[%FILE_VIEW_URL%]"></asp:ListItem>  
            <asp:ListItem meta:resourcekey="optHideFileView" Text="Hide File View" Value="[%HIDE_FILE_VIEW%]"></asp:ListItem>          
            <asp:ListItem meta:resourcekey="optFileViewListingURL" Text="File View Listing URL" Value="[%FILE_VIEW_LISTING_URL%]"></asp:ListItem>  
            <asp:ListItem meta:resourcekey="optFileViewListingMoreURL" Text="File View Listing URL (Larger)" Value="[%FILE_VIEW_LISTING_MORE_URL%]"></asp:ListItem>              
            <asp:ListItem meta:resourcekey="optHideFileViewListing" Text="Hide File View Listing" Value="[%HIDE_FILE_VIEW_LISTING%]"></asp:ListItem>         
            <asp:ListItem meta:resourcekey="optPersonFirstCreating" Text="Person First Creating" Value="[%OWNER%]"></asp:ListItem>        
            <asp:ListItem meta:resourcekey="optPersonLastUpdating" Text="Person Last Updating" Value="[%LAST_UPDATED_BY%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optDateFirstPublished" Text="Date First Published" Value="[%FIRST_PUBLISHED_DATE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optDateLastUpdated" Text="Date Last Updated/Published" Value="[%LAST_UPDATED_DATE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optTotalHits" Text="Total Hits" Value="[%TOTAL_HITS%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHitsToday" Text="Hits Today" Value="[%HITS_TODAY%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optTotalDownloads" Text="Total Downloads" Value="[%TOTAL_DOWNLOADS%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optDownloadsToday" Text="Downloads Today" Value="[%DOWNLOADS_TODAY%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optComments" Text="Comments" Value="[%COMMENTS%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optRating" Text="Rating" Value="[%RATING%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHideRating" Text="Hide Rating" Value="[%HIDE_RATING%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optPricingInfo" Text="Pricing Info" Value="[%PRICING_INFO%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHidePricingInfo" Text="Hide Pricing Info" Value="[%HIDE_PRICING_INFO%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optAddToCartURL" Text="Add To Cart URL" Value="[%PAYPAL_ADD_TO_CART_URL%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHideAddToCart" Text="Hide Add To Cart" Value="[%HIDE_PAYPAL_ADD_TO_CART%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHide" Text="Hide" Value="[%HIDE%]"></asp:ListItem>
            </asp:DropDownList>  
        </td>
        </tr>
        </table>  
    </td>
</tr>
<tr>
    <td valign="top"><asp:Label ID="lblListingTemplate" meta:resourcekey="lblListingTemplate" runat="server" Text="Item Template"></asp:Label></td>
    <td valign="top">:</td>
    <td><asp:TextBox ID="txtListingTemplate2" TextMode="MultiLine" Rows="20" Wrap=false Width="510px" Font-Names=Arial ValidationGroup="EditListingTemplate" runat="server"></asp:TextBox></td>
</tr>
<tr>
    <td colspan="3" style="text-align:right">
        <table cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
        <td style="width:100%">
        </td>
        <td>
            <asp:Label ID="Label2" meta:resourcekey="lblInsert" runat="server" Text="Insert:"></asp:Label>&nbsp;
        </td>
        <td style="text-align:right">
            <asp:DropDownList ID="dropInsertTagFooter" AutoPostBack="false" runat="server">
            <asp:ListItem Text="" Value=""></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTab" Text="TAB" Value="	"></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optTitle" Text="Title" Value="[%TITLE%]"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optURL" Text="URL" Value="[%READ_MORE%]"></asp:ListItem>
            </asp:DropDownList>  
        </td>
        </tr>
        </table>  
    </td>
</tr>
<tr>
    <td valign="top"><asp:Label ID="lblListingTemplateFooter" meta:resourcekey="lblListingTemplateFooter" runat="server" Text="Footer Template"></asp:Label></td>
    <td valign="top">:</td>
    <td>
    <asp:TextBox ID="txtListingTemplateFooter" TextMode="MultiLine" Rows="8" Wrap=false Width="510px" Font-Names=Arial ValidationGroup="EditListingTemplate" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td valign="top"><asp:Label ID="lblListingScript" meta:resourcekey="lblListingScript" runat="server" Text="Script"></asp:Label></td>
    <td valign="top">:</td>
    <td>
    <asp:TextBox ID="txtListingScript" TextMode="MultiLine" Wrap=false Width="510px" Font-Names=Arial Rows="8" ValidationGroup="EditListingTemplate" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td valign="top" style="padding-top:7px;white-space:nowrap"><asp:Label runat="server" id="lblListingType" meta:resourcekey="lblListingType" Text="Listing Type"></asp:Label></td>
    <td valign="top" style="padding-top:7px">:</td>
    <td>               
    <div><asp:RadioButton ID="rdoListingTypeNews" meta:resourcekey="rdoListingTypeNews" Text="Calendar-based listing" GroupName="grpDateOption" runat="server"></asp:RadioButton></div>   
    <div><asp:RadioButton ID="rdoListingTypeGeneral" meta:resourcekey="rdoListingTypeGeneral" Text="General Listing" GroupName="grpDateOption" runat="server"></asp:RadioButton></div>
        <div id="divListingSettings" style="width:400px;margin:3px;margin-top:7px;margin-left:20px;border:#F2F4F5 3px solid;padding:3px;padding-bottom:7px" runat="server">
            <asp:RadioButton ID="rdoShowListingOnSiteMap" meta:resourcekey="rdoShowListingOnSiteMap" GroupName="ShowHideOnSiteMap" Text="Include listing entries in sitemap" runat="server"></asp:RadioButton><br />
            <asp:RadioButton ID="rdoHideListingOnSiteMap" meta:resourcekey="rdoHideListingOnSiteMap" GroupName="ShowHideOnSiteMap" Text="Exclude listing entries from sitemap" runat="server"></asp:RadioButton><br />
            <div ID="divManualOrder" style="padding-left:17px" runat="server">
                <table cellpadding="1" cellspacing="0">
                <tr>
                <td style="white-space:nowrap">
                <asp:RadioButton ID="rdoManualOrder" meta:resourcekey="rdoManualOrder" Text="Manual order" runat="server" groupname="grpListingOrder"></asp:RadioButton>
                <asp:RadioButton ID="rdoDefaultOrder" meta:resourcekey="rdoDefaultOrder" Text="Default order by:" runat="server" groupname="grpListingOrder"></asp:RadioButton>
                </td>
                <td>
                <asp:DropDownList ID="dropDefaultOrder" runat="server">
                    <asp:ListItem meta:resourcekey="optTitle" Value="title" Text="Title"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="optAuthor" Value="owner" Text="Author"></asp:ListItem>                                
                    <asp:ListItem meta:resourcekey="optPersonLastUpdating" Value="last_updated_by" Text="Person Last Updating"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="optPublishDate" Value="first_published_date" Text="Publish Date"></asp:ListItem>            
                    <asp:ListItem meta:resourcekey="optLastUpdatedDate" Value="last_updated_date" Text="Last Updated Date"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="optRating" Value="rating" Text="Rating"></asp:ListItem>  
                    <asp:ListItem meta:resourcekey="optComments" Value="comments" Text="Comments"></asp:ListItem>   
                    <asp:ListItem meta:resourcekey="optDownloadSize" Value="file_size" Text="Download Size"></asp:ListItem>         
                    <asp:ListItem meta:resourcekey="optTotalDownloads" Value="total_downloads" Text="Total Downloads"></asp:ListItem> 
                    <asp:ListItem meta:resourcekey="optDownloadsToday" Value="downloads_today" Text="Downloads Today"></asp:ListItem>  
                    <asp:ListItem meta:resourcekey="optTotalHits" Value="total_hits" Text="Total Hits"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="optHitsToday" Value="hits_today" Text="Hits Today"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="optPrice" Value="current_price" Text="Price"></asp:ListItem>
                </asp:DropDownList>                          
                </td>
                </tr>
                </table>
            </div>
        </div>
    </td>
</tr>
<tr>
    <td><asp:Label ID="lblLayout" meta:resourcekey="lblLayout" runat="server" Text="Layout"></asp:Label></td>
    <td>:</td>
    <td>
        <table cellpadding="0" cellspacing="0">
        <tr>
        <td>
            <asp:DropDownList ID="dropListingColumns" runat="server">
                <asp:ListItem meta:resourcekey="opt1Columns" Text="1 Columns" Value="1" Selected=true></asp:ListItem>
                <asp:ListItem meta:resourcekey="opt2Columns" Text="2 Columns" Value="2"></asp:ListItem>
                <asp:ListItem meta:resourcekey="opt3Columns" Text="3 Columns" Value="3"></asp:ListItem>
                <asp:ListItem meta:resourcekey="opt4Columns" Text="4 Columns" Value="4"></asp:ListItem>
                <asp:ListItem meta:resourcekey="opt5Columns" Text="5 Columns" Value="5"></asp:ListItem>
            </asp:DropDownList>&nbsp;&nbsp;                  
        </td>
        <td><asp:Label ID="lblRecordsPerPage" meta:resourcekey="lblRecordsPerPage" runat="server" Text="Records per page"></asp:Label>:&nbsp;</td>
        <td>
            <asp:TextBox ID="txtListingPageSize" value="10" Width="20" runat="server"></asp:TextBox>
        </td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <td colspan="3" style="padding-left:2px">
    <asp:CheckBox ID="chkListingUseCategories" meta:resourcekey="chkListingUseCategories" text="Use categories to organize listing entries" runat="server"></asp:CheckBox>
    </td>
</tr> 
<tr>
    <td colspan="3" valign="top" style="padding-top:15px">
        <asp:Button ID="btnSaveListingTemplate" meta:resourcekey="btnSaveListingTemplate" runat="server" Text=" Save " ValidationGroup="EditListingTemplate" OnClick="btnSaveListingTemplate_Click" />
        <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
    </td>
</tr>
</table>
<asp:TextBox ID="txtSQL" TextMode=MultiLine Height="400" Width="100%" runat="server"></asp:TextBox>
</asp:Panel>





