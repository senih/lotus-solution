<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        SqlDataSource1.ConnectionString = sConn
        SqlDataSource2.ConnectionString = sConn
        
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
            panelCustomListing.Visible = False
            panelEntries.Visible = False
            panelEmbed.Visible = False
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                
                If IsNothing(Request.QueryString("id")) And IsNothing(Request.QueryString("embed")) Then
                    panelCustomListing.Visible = True
                    panelEntries.Visible = False
                    panelEmbed.Visible = False
                    
                    SqlDataSource1.DeleteCommand = "DELETE FROM [custom_listings] WHERE [custom_listing_id] = @custom_listing_id; DELETE from page_modules WHERE module_file='custom_listing.ascx' AND module_data=@custom_listing_id"
                    SqlDataSource1.SelectCommand = "SELECT  custom_listings.*, listing_templates.template_name FROM custom_listings INNER JOIN " & _
                        "listing_templates ON custom_listings.listing_template_id = listing_templates.id"
                
                    Dim sqlDS As SqlDataSource = New SqlDataSource
                    sqlDS.ConnectionString = sConn
                    sqlDS.SelectCommand = "SELECT id, template_name FROM listing_templates order by template_name"
                    dropListingTemplates.Items.Clear()
                    dropListingTemplates.DataValueField = "id"
                    dropListingTemplates.DataTextField = "template_name"
                    dropListingTemplates.DataSource = sqlDS
                    dropListingTemplates.DataBind()
                End If

                If Not IsNothing(Request.QueryString("id")) Then
                    panelEntries.Visible = True
                    panelCustomListing.Visible = False
                    panelEmbed.Visible = False

                    SqlDataSource2.DeleteCommand = "DELETE FROM [custom_listing_items] WHERE [custom_listing_item_id] = @custom_listing_item_id"
                    SqlDataSource2.SelectCommand = "SELECT * FROM custom_listing_items WHERE custom_listing_id=@custom_listing_id"
                    SqlDataSource2.SelectParameters("custom_listing_id").DefaultValue = Request.QueryString("id")
                
                    Dim oCmd As SqlCommand
                    Dim oDataReader As SqlDataReader
                    oConn.Open()
                    oCmd = New SqlCommand
                    oCmd.Connection = oConn
                    oCmd.CommandText = "SELECT * FROM custom_listings WHERE custom_listing_id=@custom_listing_id"
                    oCmd.CommandType = CommandType.Text
                    oCmd.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = Request.QueryString("id")
                    oDataReader = oCmd.ExecuteReader
                    If oDataReader.Read Then
                        lblEntryTitle.Text = oDataReader("title").ToString
                    End If
                    oDataReader.Close()
                    oCmd.Dispose()
                    oConn.Close()
                End If
                
                If Not IsNothing(Request.QueryString("embed")) Then
                    panelEntries.Visible = False
                    panelCustomListing.Visible = False
                    panelEmbed.Visible = True
                    
                    sdsModules.ConnectionString = sConn
                    sdsModules.DeleteCommand = "DELETE FROM [page_modules] WHERE [page_module_id] = @original_page_module_id"
                    sdsModules.SelectParameters(0).DefaultValue = "custom_listing.ascx"
                    sdsModules.SelectParameters(1).DefaultValue = Request.QueryString("embed")
                    sdsModules.SelectCommand = "SELECT page_modules.*, templates.template_name FROM templates RIGHT OUTER JOIN " & _
                        "page_modules ON templates.template_id=page_modules.template_id" & _
                        " where page_modules.module_file=@module_file AND module_data=@module_data"
                        
                    sdsModules.OldValuesParameterFormatString = "original_{0}"

                    panelPlacement.Controls.Add(New LiteralControl("<script>" & _
                        "function _doSelect(oEl,sPlaceHolder)" & _
                         "   {" & _
                         "   document.getElementById('tdLeftTop').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdBodyTop').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdRightTop').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdLeftCenter').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdBodyCenter').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdRightCenter').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdLeftBottom').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdBodyBottom').style.border='#cccccc 3px solid';" & _
                         "   document.getElementById('tdRightBottom').style.border='#cccccc 3px solid';" & _
                         "   oEl.style.border='orange 3px solid';" & _
                         "   document.getElementById('" & hidPlacement.ClientID & "').value=sPlaceHolder;" & _
                         "   }" & _
                        "</" & "script>"))
                    
                    Dim oCmd As SqlCommand
                    Dim oDataReader As SqlDataReader
                    oConn.Open()
                    oCmd = New SqlCommand
                    oCmd.Connection = oConn
                    oCmd.CommandText = "SELECT * FROM custom_listings WHERE custom_listing_id=@custom_listing_id"
                    oCmd.CommandType = CommandType.Text
                    oCmd.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = Request.QueryString("embed")
                    oDataReader = oCmd.ExecuteReader
                    If oDataReader.Read Then
                        lblEmbedTitle.Text = GetLocalResourceObject("EmbedListing") & " " & oDataReader("title").ToString
                    End If
                    oDataReader.Close()
                    oCmd.Dispose()
                    oConn.Close()
                    
                    Dim colTemplate As Collection
                    Dim templateMgr As TemplateManager = New TemplateManager
                    colTemplate = templateMgr.ListAllTemplates()
                    dropTemplates.Items.Clear()
                    dropTemplates.Items.Add(New ListItem("", ""))
                    For Each template As CMSTemplate In colTemplate
                        dropTemplates.Items.Add(New ListItem(template.TemplateName, template.TemplateId.ToString))
                    Next
                    templateMgr = Nothing
                End If
            End If
        End If
    End Sub
    
    Function ShowType(ByVal bUseCustom As Boolean, ByVal nPageId As Object, ByVal nCustomListingId As Integer) As String
        If bUseCustom Then
            Return "<a href=""" & Me.LinkCustomListing & "?id=" & nCustomListingId & """>" & GetLocalResourceObject("Custom entries") & "</a>"
        Else
            Dim sTitle As String = ""
            Dim oContent As Content = New Content
            Dim dt As DataTable
            dt = oContent.GetPage(nPageId, True)
            If dt.Rows.Count > 0 Then
                sTitle = dt.Rows(0).Item("title").ToString
            Else
                oContent = Nothing
                Return "-"
            End If
            oContent = Nothing
            Return GetLocalResourceObject("Pages within") & "<br />'" & sTitle & "' (#" & nPageId & ")"
        End If
    End Function
    
    Function ShowEntryTitle(ByVal nPageId As Integer) As String
        Dim oContent As Content = New Content
        Dim dt As DataTable
        dt = oContent.GetPage(nPageId, True)
        Dim sTitle As String = dt.Rows(0).Item("title").ToString
        oContent = Nothing
        Return sTitle
    End Function

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sCmd As String
        Dim oCmd As New SqlCommand
        oConn.Open()
    
        oCmd.Connection = oConn
        If rdoPageWithin.Checked = True Then
            sCmd = "Insert into custom_listings(title,columns,visible_records,listing_template_id,use_custom_entries,parent_id,use_box) " & _
                "values (@title,@columns,@visible_records,@listing_template_id,@use_custom_entries,@parent_id,@use_box)"
        Else
            sCmd = "Insert into custom_listings(title,columns,visible_records,listing_template_id,use_custom_entries,use_box) " & _
                "values (@title,@columns,@visible_records,@listing_template_id,@use_custom_entries,@use_box)"
        End If
    
        oCmd.CommandText = sCmd
        oCmd.CommandType = CommandType.Text
    
        oCmd.Parameters.Add("@title", SqlDbType.NVarChar, 255).Value = txtTitle.Text
        
        
        If rdoPageWithin.Checked = True Then
            oCmd.Parameters.Add("@use_custom_entries", SqlDbType.Bit).Value = False
            oCmd.Parameters.Add("@parent_id", SqlDbType.Int).Value = txtPageId.Text
        Else
            oCmd.Parameters.Add("@use_custom_entries", SqlDbType.Bit).Value = True
        End If
        
        oCmd.Parameters.Add("@columns", SqlDbType.Int).Value = 1
        oCmd.Parameters.Add("@visible_records", SqlDbType.Int).Value = 1
        oCmd.Parameters.Add("@use_box", SqlDbType.Bit).Value = False
        
        oCmd.Parameters.Add("@listing_template_id", SqlDbType.Int).Value = dropListingTemplates.SelectedValue
        oCmd.ExecuteNonQuery()
    
        oConn.Close()
        oCmd.Dispose()
        Response.Redirect(Me.LinkCustomListing)
    End Sub

    Protected Sub gridCustomListing_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim iIndex As Integer
        iIndex = e.RowIndex()
        oConn.Open()
        Dim sSQL As String = "DELETE FROM custom_listing_items " & _
            "WHERE custom_listing_id=@custom_listing_id "
        Dim oCmd As SqlCommand = New SqlCommand(sSQL)
        oCmd.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = gridCustomListing.DataKeys(iIndex).Value

        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()
    End Sub

    Protected Sub gridCustomListing_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)
        Dim iIndex As Integer = e.NewPageIndex()
        gridCustomListing.PageIndex = iIndex
    End Sub

    Protected Sub gridCustomListing_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gridCustomListing.Rows.Count - 1
            CType(gridCustomListing.Rows(i).Cells(4).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
        
    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub
    
    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub gridEntries_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteEntryConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gridEntries.Rows.Count - 1
            CType(gridEntries.Rows(i).Cells(2).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub gridEntries_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)
        Dim iIndex As Integer = e.NewPageIndex()
        gridEntries.PageIndex = iIndex
    End Sub

    Protected Sub btnAddEntry_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub

        Dim sCmd As String
        Dim oCmd As New SqlCommand
        oConn.Open()
    
        oCmd.Connection = oConn
        sCmd = "Insert into custom_listing_items(page_id,custom_listing_id) " & _
            "values (@page_id,@custom_listing_id)"
    
        oCmd.CommandText = sCmd
        oCmd.CommandType = CommandType.Text
    
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = txtPageId2.Text
        oCmd.Parameters.Add("@custom_listing_id", SqlDbType.Int).Value = Request.QueryString("id")
        oCmd.ExecuteNonQuery()
    
        oConn.Close()
        oCmd.Dispose()
        
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkCustomListing)
    End Sub
    
    Protected Sub grvModules_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteEmbedConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvModules.Rows.Count - 1
            CType(grvModules.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub

    Protected Sub btnBack2_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkCustomListing)
    End Sub
    
    Protected Sub btnEmbed_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmbed.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        If dropTemplates.SelectedValue = "" And txtPage.Text = "" Then
            Response.Redirect(HttpContext.Current.Items("_path"))
        End If
        
        If hidPlacement.Value = "" Then
            hidPlacement.Value = "placeholderBody"
        End If
        Dim oConn As SqlConnection = New SqlConnection(sConn)
        Dim oCmd As SqlCommand = New SqlCommand
        If Not dropTemplates.SelectedValue = "" Then
            oCmd.CommandText = "INSERT INTO [page_modules] ([module_file], [template_id], [embed_in], [placeholder_id], [module_data]) VALUES (@module_file, @template_id, @embed_in, @placeholder_id, @module_data)"
            oCmd.Parameters.Add("@template_id", SqlDbType.Int).Value = dropTemplates.SelectedValue
        Else
            oCmd.CommandText = "INSERT INTO [page_modules] ([module_file], [embed_in], [placeholder_id], [module_data]) VALUES (@module_file, @embed_in, @placeholder_id, @module_data)"
        End If
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@module_file", SqlDbType.NVarChar).Value = "custom_listing.ascx"
        oCmd.Parameters.Add("@embed_in", SqlDbType.NVarChar).Value = txtPage.Text
        oCmd.Parameters.Add("@placeholder_id", SqlDbType.NVarChar).Value = hidPlacement.Value
        oCmd.Parameters.Add("@module_data", SqlDbType.NVarChar).Value = Request.QueryString("embed")
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub gridCustomListing_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkCustomListing & "?embed=" & gridCustomListing.SelectedDataKey().Value)
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelCustomListing" runat="server" Wrap=false Visible="false">
<asp:GridView ID="gridCustomListing" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" AllowPaging="True" PageSize="20" HeaderStyle-HorizontalAlign=Left AutoGenerateColumns="False" DataSourceID="SqlDataSource1" AllowSorting="True" DataKeyNames="custom_listing_id" OnRowDeleting="gridCustomListing_RowDeleting" OnPageIndexChanging="gridCustomListing_PageIndexChanging" OnPreRender="gridCustomListing_PreRender" OnSelectedIndexChanged="gridCustomListing_SelectedIndexChanged">
    <Columns>
        <asp:BoundField meta:resourcekey="colTitle" HeaderText="Title" DataField="title" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top" />
        <asp:TemplateField meta:resourcekey="colType" HeaderText="Type" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top">
        <ItemTemplate>
            <%#ShowType(Eval("use_custom_entries"), Eval("parent_id"), Eval("custom_listing_id"))%>
        </ItemTemplate>
        </asp:TemplateField>  
        <asp:BoundField meta:resourcekey="colTemplate" HeaderText="Template" DataField="template_name" ItemStyle-VerticalAlign="top" />
        <asp:CommandField meta:resourcekey="colEmbed" ShowSelectButton="True" SelectText="Embed to Pages" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top" />
        <asp:CommandField meta:resourcekey="colDelete" DeleteText="Delete"  ShowDeleteButton="True" ItemStyle-VerticalAlign="top" />
    </Columns> 
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource1" runat="server" >
    <DeleteParameters>
        <asp:Parameter Name="custom_listing_id" Type="Int32" />
    </DeleteParameters>
</asp:SqlDataSource>

<script language="javascript">
function clientValidateType(source, arguments) 
    {
    var rdoPageWithin=document.getElementById("<%=rdoPageWithin.clientId%>");
    if (rdoPageWithin.checked) 
        {
        var txtPageId=document.getElementById("<%=txtPageId.clientId%>");
        if(txtPageId.value=="") 
            {
            arguments.IsValid=false;
            return;   
            }
        }
    arguments.IsValid=true;    
    } 
</script>

<div style="border:#E0E0E0 1px solid;padding:10px;width:350px;margin-top:15px">
<table cellpadding="3" cellspacing="0">
<tr>
    <td colspan="3" style="padding-bottom:7px"><asp:Label ID="lblNewListing" meta:resourcekey="lblNewListing" Font-Bold="true" runat="server" Text="New Listing"></asp:Label></td>
</tr>
<tr>
<td valign="top" style="padding-top:7px"><asp:Label ID="lblType" meta:resourcekey="lblType" runat="server" Text="Type"></asp:Label></td>
<td valign="top" style="padding-top:6px">:</td>
<td>
    <table cellpadding="0" cellspacing="0">
    <tr>
    <td style="white-space:nowrap">
        <asp:RadioButton ID="rdoPageWithin" meta:resourcekey="rdoPageWithin" Checked="true" GroupName="type" Text="Pages within:" runat="server" />
        <asp:TextBox ID="txtPageId" Width="30" runat="server"></asp:TextBox> <i>(Specify Page ID here)</i>
        <asp:CustomValidator runat="server" id="cv1" ClientValidationFunction="clientValidateType" ErrorMessage="*" SetFocusOnError="true"></asp:CustomValidator>
    </td>
    </tr>
    <tr>
    <td>
        <asp:RadioButton ID="rdoCustomEntries" meta:resourcekey="rdoCustomEntries" Text="Custom entries" GroupName="type" runat="server" />
    </td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td><asp:Label ID="lblTitle" meta:resourcekey="lblTitle" runat="server" Text="Title"></asp:Label></td>
<td>:</td>
<td>
    <asp:TextBox ID="txtTitle" Width="170" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
<td><asp:Label ID="lblListingTemplate" meta:resourcekey="lblListingTemplate" runat="server" Text="Listing Template"></asp:Label></td>
<td>:</td>
<td>
    <asp:DropDownList ID="dropListingTemplates" runat="server">
    </asp:DropDownList>
</td>
</tr>
<tr>
<td style="text-align:left;white-space:nowrap" valign="top" colspan ="3">
<br /><asp:Button ID="btnCreate" meta:resourcekey="btnCreate" runat="server" Text=" Create " OnClick="btnCreate_Click" />
</td>
</tr>
</table>
</div>
</asp:Panel>

<asp:Panel ID="panelEntries" runat="server">

<div style="font-weight:bold;padding-bottom:10px">
    <asp:Label ID="lblListing" meta:resourcekey="lblListing" runat="server" Text="Listing"></asp:Label>:&nbsp;<asp:Label ID="lblEntryTitle" runat="server" Text=""></asp:Label>
</div>

<asp:GridView ID="gridEntries" GridLines="None" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" AllowPaging="True" PageSize="20" HeaderStyle-HorizontalAlign=Left AutoGenerateColumns="False" DataSourceID="SqlDataSource2" AllowSorting="True" DataKeyNames="custom_listing_item_id" OnPreRender="gridEntries_PreRender" OnPageIndexChanging="gridEntries_PageIndexChanging">
<Columns>
<asp:BoundField meta:resourcekey="colPageId" HeaderText="Page Id" DataField="page_id" ItemStyle-VerticalAlign="top" />
<asp:TemplateField meta:resourcekey="colTitle" HeaderText="Title">
<ItemTemplate>
<%#ShowEntryTitle(Eval("page_id"))%>
</ItemTemplate>
</asp:TemplateField>
<asp:CommandField meta:resourcekey="colDelete" DeleteText="Delete" ShowDeleteButton="True" ItemStyle-VerticalAlign="top" />
</Columns>
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource2" runat="server" >
    <SelectParameters>
        <asp:Parameter Name="custom_listing_id" Type="Int32" />
    </SelectParameters>
    <DeleteParameters>
        <asp:Parameter Name="custom_listing_item_id" Type="Int32" />
    </DeleteParameters>
</asp:SqlDataSource>

<table cellpadding="3" cellspacing="0" style="margin-top:15px">
<tr>
<td><asp:Label ID="lblPageId" meta:resourcekey="lblPageId" runat="server" Text="Page Id"></asp:Label></td>
<td>:</td>
<td>
    <asp:TextBox ID="txtPageId2" Width="30" ValidationGroup="Entry" runat="server"></asp:TextBox>
    <asp:RequiredFieldValidator ControlToValidate="txtPageId2" ValidationGroup="Entry" ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
</td>
</tr>
<tr>
<td style="text-align:left;white-space:nowrap" valign="top" colspan ="3">
<br /><asp:Button ID="btnAddEntry" meta:resourcekey="btnAddEntry" ValidationGroup="Entry" runat="server" Text=" Add Entry " OnClick="btnAddEntry_Click" />
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text=" Back to Listing " OnClick="btnBack_Click" />
</td>
</tr>
</table>
</asp:Panel>


<asp:Panel ID="panelEmbed" runat="server" Visible="false" >

<asp:Label ID="lblEmbedTitle" Font-Bold=true runat="server" Text=""></asp:Label>
<br /><br />

<table cellpadding="0" cellspacing="0">
<tr>
<td valign="top" style="padding-right:15px" >
    <table>    
    <tr>
        <td style="padding-left:0px">
            <asp:Label ID="lblTemplateOrPage" meta:resourcekey="lblTemplateOrPage" runat="server" Text="Template/Page"></asp:Label>
        </td>
        <td style="padding-top:9">:</td>
        <td>
            <table cellpadding="0" cellspacing="0">
            <tr>
                <td><asp:DropDownList ID="dropTemplates" runat="server"></asp:DropDownList></td> 
                <td>&nbsp;/&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtPage" runat="server"></asp:TextBox>
                </td>
                <td>&nbsp;
                    <asp:Label ID="lblEg" meta:resourcekey="lblEg" runat="server" Text="(eg. default.aspx)"></asp:Label>
                </td>         
            </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="padding-left:0" valign="top">
            <asp:Label ID="lblPlacement" meta:resourcekey="lblPlacement" runat="server" Text="Placement"></asp:Label>
        </td>
        <td valign="top">:</td>
        <td style="padding-top:5px;padding-bottom:5px">
        
            <asp:Panel ID="panelPlacement" runat="server">
            </asp:Panel>

            <table cellpadding="0" cellspacing="5" style="width:300px;border:#e7e7e7 1px solid">
            <tr>
                <td id="tdLeftTop" onclick="_doSelect(this,'placeholderLeftTop')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblLeftTop" meta:resourcekey="lblLeftTop" runat="server" Text="Left Top"></asp:Label>
                </td>
                <td id="tdBodyTop" onclick="_doSelect(this,'placeholderBodyTop')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblBodyTop" meta:resourcekey="lblBodyTop" runat="server" Text="Body Top"></asp:Label>
                </td>
                <td id="tdRightTop" onclick="_doSelect(this,'placeholderRightTop')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblRightTop" meta:resourcekey="lblRightTop" runat="server" Text="Right Top"></asp:Label>
                </td>
            </tr>
            <tr>
                <td id="tdLeftCenter" onclick="_doSelect(this,'placeholderLeft')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblLeft" meta:resourcekey="lblLeft" runat="server" Text="Left"></asp:Label>
                </td>
                <td id="tdBodyCenter" onclick="_doSelect(this,'placeholderBody')" align="center" style="width:100px;height:100px;padding:20px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblBody" meta:resourcekey="lblBody" runat="server" Text="Body"></asp:Label>
                </td>
                <td id="tdRightCenter" onclick="_doSelect(this,'placeholderRight')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblRight" meta:resourcekey="lblRight" runat="server" Text="Right"></asp:Label>
                </td>
            </tr>
            <tr>
                <td id="tdLeftBottom" onclick="_doSelect(this,'placeholderLeftBottom')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblLeftBottom" meta:resourcekey="lblLeftBottom" runat="server" Text="Left Bottom"></asp:Label>
                </td>
                <td id="tdBodyBottom" onclick="_doSelect(this,'placeholderBodyBottom')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblBodyBottom" meta:resourcekey="lblBodyBottom" runat="server" Text="Body Bottom"></asp:Label>
                </td>
                <td id="tdRightBottom" onclick="_doSelect(this,'placeholderRightBottom')" align="center" style="padding:10px;cursor:default;border:#cccccc 3px solid">
                    <asp:Label ID="lblRightBottom" meta:resourcekey="lblRightBottom" runat="server" Text="Right Bottom"></asp:Label>
                </td>
            </tr>
            </table>
            <asp:HiddenField ID="hidPlacement" runat="server" />

        </td>
    </tr>
    <tr>
        <td style="padding-left:0;padding-top:10px" colspan=3>
            <asp:Button ID="btnEmbed" meta:resourcekey="btnEmbed" runat="server" Text=" Embed " />
            <asp:Button ID="btnBack2" meta:resourcekey="btnBack" CausesValidation=false runat="server" Text=" Back to Listing " OnClick="btnBack2_Click" />
        </td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td>&nbsp;</td>
</tr>
<tr>
<td valign="top">
    <asp:GridView ID="grvModules" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
       GridLines=None AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" 
       DataSourceID="sdsModules" DataKeyNames="page_module_id"  OnPreRender="grvModules_PreRender">
           <Columns>       
            <asp:BoundField DataField="template_name" meta:resourcekey="lblTemplate" HeaderText="Template" SortExpression="template_name" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:BoundField>
            <asp:TemplateField meta:resourcekey="lblPage2" HeaderText="Page" SortExpression="embed_in">
                <ItemTemplate>
                <a href="<%#Eval("embed_in")%>" target="_blank"><%#Eval("embed_in")%></a>
                </ItemTemplate>
                <HeaderStyle HorizontalAlign="Left" />
            </asp:TemplateField>
            <asp:BoundField DataField="placeholder_id" meta:resourcekey="lblPlacement2" HeaderText="Placement" SortExpression="placeholder_id" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:BoundField>
            <asp:CommandField meta:resourcekey="lblCommand" ShowDeleteButton="True" >
            <HeaderStyle HorizontalAlign="Left" />
            </asp:CommandField>
        </Columns>
    </asp:GridView>
        
    <asp:SqlDataSource ID="sdsModules" runat="server" >
        <DeleteParameters>
            <asp:Parameter Name="original_page_module_id" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
        <asp:Parameter Name="module_file" Type="String" />
        <asp:Parameter Name="module_data" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</td>
</tr>
</table>
<br /><br />

</asp:Panel>
