<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="TemplateManager" %> 
<%@ Import Namespace="ChannelManager" %> 

<script runat="server">
    Private sRawUrl As String = Context.Request.RawUrl.ToString
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            panelLogin.Visible = True
            Dim oUC1 As Control = LoadControl("login.ascx")
            panelLogin.Controls.Add(oUC1)
            panelChannels.Visible = False
            panelChannelInfo.Visible = False
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                panelChannels.Visible = True
                
                Dim oChannel As ChannelManager = New ChannelManager
                grvChannels.DataSource = oChannel.GetChannelsCollection()
                grvChannels.DataBind()
                
                Dim oTemplate As TemplateManager = New TemplateManager
                ddlDefaultTemplate.DataSource = oTemplate.ListAllTemplates
                ddlDefaultTemplate.DataBind()
            End If
        End If
    End Sub
    
    Protected Sub grvChannels_RowChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs)
        Dim iIndex As Integer
        iIndex = e.NewSelectedIndex
        Dim sChannel As String = Server.HtmlDecode(grvChannels.Rows.Item(iIndex).Cells(1).Text)
        Dim oSelectChannel As CMSChannel = New CMSChannel
        Dim oChannel As ChannelManager = New ChannelManager
        oSelectChannel = oChannel.GetChannelByName(sChannel)
        
        hidChannelId.Value = oSelectChannel.ChannelId
        Dim nChannelId As Integer = CInt(hidChannelId.Value)
        oSelectChannel = oChannel.GetChannel(nChannelId)
        Dim oTemplates As TemplateManager = New TemplateManager
        ddlTemplate2.DataSource = oTemplates.ListAllTemplates()
        ddlTemplate2.DataBind()
        
        txtChannelName2.Text = oSelectChannel.ChannelName
        ddlTemplate2.SelectedValue = oSelectChannel.DefaultTemplate.ToString
        ddlPermission2.SelectedValue = oSelectChannel.Permission.ToString
        chkDisableCollabAuth2.Checked = oSelectChannel.DisableCollaboration
        
        panelChannelInfo.Visible = True
        panelChannels.Visible=False
    End Sub
    
    Protected Sub grvChannels_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim bChannelExist As Boolean = False
        Dim iIndex As Integer
        iIndex = e.RowIndex()
        Dim sChannel As String = Server.HtmlDecode(grvChannels.Rows.Item(iIndex).Cells(1).Text)
        Dim oDeleteChannel As CMSChannel = New CMSChannel
        Dim oChannel As ChannelManager = New ChannelManager
        oDeleteChannel = oChannel.GetChannelByName(sChannel)
        
        Dim sFolder As String = Server.MapPath("resources") & "\"
        
        Dim nReturn As Integer
        nReturn = oChannel.DeleteChannel(oDeleteChannel.ChannelId)
        If nReturn = 0 Then
            lblSucess.Visible = True
        Else
            lblSucess.Visible = False
            
            If My.Computer.FileSystem.DirectoryExists(sFolder & oDeleteChannel.ChannelId) Then
                Directory.Delete(sFolder & oDeleteChannel.ChannelId, True)
            End If
        End If
        
        grvChannels.DataSource = oChannel.GetChannelsCollection()
        grvChannels.DataBind()
    End Sub
   
    Private Function showTemplateName(ByVal nTemplateId As Integer) As String
        Dim oGettemplate As TemplateManager = New TemplateManager
        Return oGettemplate.GetTemplate(nTemplateId).TemplateName
    End Function
    
    Private Function showPermission(ByVal nPermission As Integer) As String
        Dim sPermission As String
        If nPermission = 1 Then
            sPermission = GetLocalResourceObject("ViewPermission1") 'Everyone (Anonymous Users)
        ElseIf nPermission = 2 Then
            sPermission = GetLocalResourceObject("ViewPermission2") 'All Users (Registered)
        Else
            sPermission = GetLocalResourceObject("ViewPermission3") 'Channel's Users Only
        End If
        Return sPermission
    End Function
    
    Private Function showInfo(ByVal bDisableCollaboration As Boolean) As String
        If bDisableCollaboration Then
            Return "<span style=""font-weight:bold;font-size:14px"">*</span>"
        Else
            Return ""
        End If
    End Function

    Protected Sub grvChannels_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To grvChannels.Rows.Count - 1
            CType(grvChannels.Rows(i).Cells(7).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
        Next
    End Sub
    
    Protected Function showUsers(ByVal sChannelName As String) As String
        Dim sReturn As String = ""
        sReturn += "<div>Subscribers: " & Roles.GetUsersInRole(sChannelName & " Subscribers").Length & " Users</div>"
        sReturn += "<div>Authors: " & Roles.GetUsersInRole(sChannelName & " Authors").Length & " Users</div>"
        sReturn += "<div>Editors: " & Roles.GetUsersInRole(sChannelName & " Editors").Length & " Users</div>"
        sReturn += "<div>Publishers: " & Roles.GetUsersInRole(sChannelName & " Publishers").Length & " Users</div>"
        sReturn += "<div>Resource Managers: " & Roles.GetUsersInRole(sChannelName & " Resource Managers").Length & " Users</div>"
        Return sReturn
    End Function
    
    Protected Sub btnCreateChannel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim bChannelExist As Boolean = False
        Dim sFolder As String = Server.MapPath("resources") & "\"
        Dim oNewChannel As CMSChannel = New CMSChannel
        Dim oCreateChannel As ChannelManager = New ChannelManager
        Dim oChannel As CMSChannel = New CMSChannel
        oNewChannel.ChannelName = txtChannelName.Text.ToString
        oNewChannel.DefaultTemplate = ddlDefaultTemplate.SelectedValue
        oNewChannel.Permission = ddlPermission.SelectedValue
        oNewChannel.DisableCollaboration = chkDisableCollabAuth.Checked
        
        If IsNothing(oCreateChannel.CreateChannel(oNewChannel)) Then
            bChannelExist = True
            lblSucess.Visible = True
            Exit Sub
        End If
        If Not bChannelExist Then
            oCreateChannel = New ChannelManager
            oChannel = oCreateChannel.GetChannelByName(txtChannelName.Text)
            If Not My.Computer.FileSystem.DirectoryExists(sFolder & oChannel.ChannelId) Then
                My.Computer.FileSystem.CreateDirectory(sFolder & oChannel.ChannelId)
            End If
        End If
        
        txtChannelName.Text = ""
        
        Dim oChannelManager As ChannelManager = New ChannelManager
        grvChannels.DataSource = oChannelManager.GetChannelsCollection()
        grvChannels.DataBind()
    End Sub
    
    Private Function GetFileName() As String
        Dim sFileName As String
        Dim sPath As String
        If sRawUrl.Contains("?") Then
            sPath = sRawUrl.Split(CChar("?"))(0).ToString
        Else
            sPath = sRawUrl
        End If

        sFileName = sPath.Substring(sPath.LastIndexOf("/") + 1) 'All pages are in root
        Return sFileName
    End Function

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Response.Redirect(HttpContext.Current.Items("_path"))
        
        Dim nChannelId As Integer = CInt(hidChannelId.Value)
        Dim oUpdateChannel As CMSChannel = New CMSChannel
        Dim oChannel As ChannelManager = New ChannelManager
        
        oUpdateChannel = oChannel.GetChannel(nChannelId)
        oUpdateChannel.ChannelName = txtChannelName2.Text
        oUpdateChannel.DefaultTemplate = ddlTemplate2.SelectedValue
        oUpdateChannel.Permission = ddlPermission2.SelectedValue
        oUpdateChannel.DisableCollaboration = chkDisableCollabAuth2.Checked

        If Not IsNothing(oChannel.GetChannelByName(txtChannelName2.Text)) Then
            If oChannel.GetChannelByName(txtChannelName2.Text).ChannelId = nChannelId Then
                'self update (same id)
                oChannel.UpdateChannel(oUpdateChannel)
            Else
                'do not update, other channel has the same name
            End If
        Else
            oChannel.UpdateChannel(oUpdateChannel)
        End If
        
        panelChannels.Visible = True
        panelChannelInfo.Visible = False
        
        grvChannels.DataSource = oChannel.GetChannelsCollection()
        grvChannels.DataBind()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        panelChannels.Visible = True
        panelChannelInfo.Visible = False
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
</asp:Panel>

<asp:Panel ID="panelChannels" runat="server" Visible="false" >

<asp:GridView ID="grvChannels" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 HeaderStyle-HorizontalAlign=Left runat="server"
       GridLines=None AutoGenerateColumns="False" OnSelectedIndexChanging="grvChannels_RowChanging" OnRowDeleting="grvChannels_RowDeleting" OnPreRender="grvChannels_PreRender">
           <Columns>
            <asp:TemplateField ItemStyle-VerticalAlign=top>
                <ItemTemplate><img src="systems/images/ico_folder.gif" /></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ChannelName" HeaderStyle-HorizontalAlign=Left ItemStyle-VerticalAlign=top/>
            <asp:TemplateField ItemStyle-VerticalAlign=top>
                <ItemTemplate><%#showInfo(Eval("DisableCollaboration"))%></ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField meta:resourcekey="lblDefaultTemplate" HeaderText="Default Template" ItemStyle-VerticalAlign=top HeaderStyle-HorizontalAlign=Left>
                <ItemTemplate >
                    <%#showTemplateName(Eval("DefaultTemplate"))%>
                </ItemTemplate>                
             </asp:TemplateField>
             <asp:TemplateField meta:resourcekey="lblViewPermission" HeaderText="View Permission"  ItemStyle-VerticalAlign=top HeaderStyle-HorizontalAlign=Left>
                <ItemTemplate >
                    <%#showPermission(Eval("permission"))%>
                </ItemTemplate>
             </asp:TemplateField>
            <asp:TemplateField meta:resourcekey="lblUsers" HeaderText="Users" HeaderStyle-HorizontalAlign=Left>
                <ItemTemplate >
                    <%#showUsers(Eval("ChannelName"))%>
                </ItemTemplate>                
             </asp:TemplateField>
            <asp:CommandField meta:resourcekey="lblCommand" HeaderStyle-HorizontalAlign=Left ShowSelectButton=true ItemStyle-VerticalAlign=top SelectText="Edit" />
            <asp:CommandField meta:resourcekey="lblCommand" DeleteText="Delete" ShowDeleteButton="true" ItemStyle-VerticalAlign=top ButtonType="link" />
        </Columns>
    </asp:GridView>
<br />
<asp:Label ID="lblNote" meta:resourcekey="lblNote" runat="server" Font-Size=XX-Small  Font-Italic=true Text="( * ) Collaborative authoring disabled."></asp:Label>
<div style="padding-top:7px;padding-bottom:7px">
<asp:Label ID="lblSucess" meta:resourcekey="lblSucess" ForeColor="red" runat="server" Text="Delete Failed. Channel is in use." Font-Bold=true Visible="false"></asp:Label> 
</div>

<div style="border:#E0E0E0 1px solid;padding:10px;width:350px">
<table>
    <tr>
        <td colspan="3" style="padding-bottom:7px"><asp:Label ID="lblNewChannel" meta:resourcekey="lblNewChannel" Font-Bold="true" runat="server" Text="New Channel"></asp:Label></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
        <asp:Label ID="lblChannelName" meta:resourcekey="lblChannelName" runat="server" Text="Name"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtChannelName" runat="server"  ValidationGroup="Channel"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="*" ControlToValidate="txtChannelName" ValidationGroup="Channel"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
        <asp:Label ID="lblChannelTemplate" meta:resourcekey="lblTemplate" runat="server" Text="Default Template"></asp:Label>
        </td>
        <td>:</td>
        <td>
            <asp:DropDownList ID="ddlDefaultTemplate" runat="server" DataTextField="TemplateName" DataValueField="TemplateId">
            </asp:DropDownList>
        </td>
    </tr>
     <tr>
        <td align="left" style="text-align:left;white-space:nowrap">
           <asp:Label ID="lblPermission" meta:resourcekey="lblPermission" runat="server" Text="Page View Permission"></asp:Label></td>
        <td align="left">:</td>
        <td><!-- 1.Everyone 2.Registered Users 3.Channel's Users Only-->
            <asp:DropDownList ID="ddlPermission" runat="server">
            <asp:ListItem Value="1" meta:resourcekey="ddlPermissionOpt1" Text="Everyone (Anonymous Users)"></asp:ListItem>
            <asp:ListItem Value="2" meta:resourcekey="ddlPermissionOpt2" Text="All Users (Registered)"></asp:ListItem>           
            <asp:ListItem Value="3" meta:resourcekey="ddlPermissionOpt3" Text="Channel's Users Only"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>

    <tr>
        <td style="padding-top:7px" colspan="3">
            <asp:CheckBox ID="chkDisableCollabAuth" meta:resourcekey="chkDisableCollabAuth" Text=" Disable Collaborative Authoring" runat="server" />
        </td>
    </tr>
    <tr>
        <td colspan="3" height="10px"></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:Button ID="btnCreateChannel" meta:resourcekey="btnCreate" runat="server" Text=" Create " OnClick="btnCreateChannel_Click" ValidationGroup="Channel"/>
        </td>
    </tr>

</table>
</div>

</asp:Panel>

<asp:Panel ID="panelChannelInfo" runat="server" Visible="false">
    <asp:HiddenField ID="hidChannelId" runat="server" />
    <table>
    <tr>
        <td align="left" nowrap=nowrap>
           <asp:Label ID="Label2" meta:resourcekey="lblChannelName" runat="server" Text="Name"></asp:Label>
        </td>
        <td align="left" style="width: 3px; text-align: left">
            :</td>
        <td>
            <asp:TextBox ID="txtChannelName2" runat="server" ValidationGroup="ChannelUpdate"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtChannelName" ValidationGroup="ChannelUpdate"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td align="left" nowrap=nowrap>
            <asp:Label ID="lblTemplate" meta:resourcekey="lblTemplate" runat="server" Text="Default Template"></asp:Label></td>
        <td align="left" style="width: 3px">
            :</td>
        <td>
            <asp:DropDownList ID="ddlTemplate2" runat="server" DataTextField="TemplateName" DataValueField="TemplateId"> 
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="left" style="text-align: left; " nowrap=nowrap>
           <asp:Label ID="Label3" meta:resourcekey="lblPermission" runat="server" Text="View Permission"></asp:Label></td>
        <td align="left">
            :</td>
        <td>
            <asp:DropDownList ID="ddlPermission2" runat="server">
            <asp:ListItem Value="1" meta:resourcekey="ddlPermissionOpt1" Text="Everyone (Anonymous Users)"></asp:ListItem>
            <asp:ListItem Value="2" meta:resourcekey="ddlPermissionOpt2" Text="All Users (Registered)"></asp:ListItem>
            <asp:ListItem Value="3" meta:resourcekey="ddlPermissionOpt3" Text="Channel's Users Only"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td colspan=3 height="10px"></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:CheckBox ID="chkDisableCollabAuth2" meta:resourcekey="chkDisableCollabAuth" Text=" Disable Collaborative Authoring" runat="server" />
        </td>
    </tr>
    <tr>
        <td colspan=3 align="left" style="text-align:left;padding-top:10px" nowrap=nowrap>
            <asp:Button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" Update " ValidationGroup="ChannelUpdate" OnClick="btnUpdate_Click" />  
            <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text="  Cancel  " OnClick="btnCancel_Click" />  
        </td>
    </tr>
    
</table>
<br />

</asp:Panel>

