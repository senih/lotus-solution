<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">    
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
        dropTemplates.Attributes.Add("onchange", "if(this.value!='')document.getElementById('" & txtPage.ClientID & "').value=''")
        txtPage.Attributes.Add("onkeyup", "if(this.value!='')document.getElementById('" & dropTemplates.ClientID & "').value=''")
        
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelExtensions.Visible = False
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                Dim sModuleFile As String = Replace(Request.QueryString("file"), "'", "''")
                Dim sModuleName As String = ""

                sdsExtensions.ConnectionString = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
                sdsExtensions.DeleteCommand = "DELETE FROM [page_modules] WHERE [page_module_id] = @original_page_module_id"
                'sdsExtensions.SelectCommand = "SELECT * FROM [page_modules] where [module_file]='" & Request.QueryString("file") & "'"
                sdsExtensions.SelectCommand = "SELECT page_modules.*, templates.template_name FROM templates RIGHT OUTER JOIN " & _
                    "page_modules ON templates.template_id=page_modules.template_id" & _
                    " where page_modules.module_file='" & sModuleFile & "'"
                sdsExtensions.OldValuesParameterFormatString = "original_{0}"
                panelExtensions.Visible = True

                'sdsPlaceholder.ConnectionString = sConn
                'sdsPlaceholder.SelectCommand = "SELECT * FROM placeholders"

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

                Dim oConn As SqlConnection = New SqlConnection(sConn)
                Dim oCmd As SqlCommand = New SqlCommand
                Dim sPlaceholder As String = ""

                oCmd.CommandText = "SELECT * FROM [modules] where module_file = @module_file"
                oCmd.CommandType = CommandType.Text
                oCmd.Parameters.Add("@module_file", SqlDbType.NVarChar).Value = sModuleFile

                oConn.Open()
                oCmd.Connection = oConn
                Dim oDataReader As SqlDataReader = oCmd.ExecuteReader()
                If oDataReader.Read() Then
                    sModuleName = oDataReader("display_name")
                End If
                oDataReader.Close()
                oConn.Close()

                litModuleInfo.Text = sModuleName & " (" & sModuleFile & ")"
                
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

    End Sub

    Protected Sub btnEmbed_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmbed.Click
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim sModuleFile As String = Request.QueryString("file")
        If dropTemplates.SelectedValue = "" And txtPage.Text = "" Then
            Response.Redirect(Me.LinkAdminModulePages & "?file=" & sModuleFile)
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
        oCmd.Parameters.Add("@module_file", SqlDbType.NVarChar).Value = sModuleFile
        oCmd.Parameters.Add("@embed_in", SqlDbType.NVarChar).Value = txtPage.Text
        oCmd.Parameters.Add("@placeholder_id", SqlDbType.NVarChar).Value = hidPlacement.Value ' ddlPlaceholder.SelectedValue
        oCmd.Parameters.Add("@module_data", SqlDbType.NVarChar).Value = txtModuleData.Text

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oConn.Close()

        grvExtensions.DataBind()
        'Response.Redirect(Me.LinkAdminModulePages & "?file=" & sModuleFile)
    End Sub

    Protected Sub grvExtensions_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvExtensions.Rows.Count - 1
            CType(grvExtensions.Rows(i).Cells(4).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
    Protected Function ViewUrl(ByVal s As String) As String
        If s.Contains("*") Then
            If s = "*" Then
                Return Me.RootFile
            Else
                Return s.Substring(1)
            End If
        Else
            Return s
        End If
        
    End Function
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelExtensions" runat="server" Visible="false" >

Module: <b><asp:Literal ID="litModuleInfo" runat="server"></asp:Literal></b>
<br /><br />

<table cellpadding="0" cellspacing="0">
<tr>
<td valign="top" style="padding-right:15px">
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
        <td style="padding-left:0;" valign="top">
            <asp:Label ID="lblPlacement" meta:resourcekey="lblPlacement" runat="server" Text="Placement"></asp:Label>
        </td>
        <td valign="top">:</td>
        <td>
        
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
        <td style="padding-left:0">            
            <asp:Label ID="lblModuleData" meta:resourcekey="lblModuleData" runat="server" Text="Module Data"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtModuleData" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="padding-left:0;padding-top:10px" colspan=3>
            <asp:Button ID="btnEmbed" meta:resourcekey="btnEmbed" runat="server" Text=" Embed " />
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
    <asp:GridView ID="grvExtensions" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
       GridLines=None AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" 
       DataSourceID="sdsExtensions" DataKeyNames="page_module_id"  OnPreRender="grvExtensions_PreRender">
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
            <asp:BoundField DataField="module_data" meta:resourcekey="lblModuleData2" HeaderText="Module Data" SortExpression="module_data" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:BoundField>
            <asp:CommandField meta:resourcekey="lblCommand" DeleteText="Delete" ShowDeleteButton="True" >
                <HeaderStyle HorizontalAlign="Left" />
            </asp:CommandField>
   
        </Columns>
    </asp:GridView>
        
    <asp:SqlDataSource ID="sdsExtensions" runat="server" >
        <DeleteParameters>
            <asp:Parameter Name="original_page_module_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</td>
</tr>
</table>
<br />

</asp:Panel>