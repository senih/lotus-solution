<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat=server >
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sconn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SqlDataSource1.ConnectionString = sConn

        If Not IsNothing(GetUser) Then
            Dim sChannelName As String
            Dim sSQL As String
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                sSQL = "SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes1 WHERE status='waiting_for_editor_approval' " & _
                    " UNION SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes2 WHERE status='waiting_for_publisher_approval' "
                SqlDataSource1.SelectCommand = sSQL
            Else
                Dim sTmp As String = ""
                Dim Item As String
                Dim i As Integer = 0

                For Each Item In Roles.GetRolesForUser(GetUser.UserName)
                    If Item.Contains("Editors") Then
                        If Item.Substring(Item.IndexOf("Editors")) = "Editors" Then
                            sChannelName = Item.Substring(0, Item.IndexOf("Editors") - 1)
                            If i = 0 Then
                                sTmp = " AND (channel_name='" & sChannelName & "'"
                            Else
                                sTmp += "OR channel_name='" & sChannelName & "'"
                            End If
                        End If
                        i += 1
                    End If
                Next
                If Not (i = 0) Then
                    sTmp += ")"
                End If

                Dim sTmp2 As String = ""
                i = 0
                For Each Item In Roles.GetRolesForUser(GetUser.UserName)
                    If Item.Contains("Publishers") Then
                        If Item.Substring(Item.IndexOf("Publishers")) = "Publishers" Then
                            sChannelName = Item.Substring(0, Item.IndexOf("Publishers") - 1)
                            If i = 0 Then
                                sTmp2 = "AND (channel_name='" & sChannelName & "'"
                            Else
                                sTmp2 += "OR channel_name='" & sChannelName & "'"
                            End If
                        End If
                        i += 1
                    End If
                Next
                If Not (i = 0) Then
                    sTmp2 += ")"
                End If

                If sTmp <> "" And sTmp2 = "" Then
                    sSQL = "SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes1 WHERE status='waiting_for_editor_approval' " & sTmp
                    SqlDataSource1.SelectCommand = sSQL
                ElseIf sTmp = "" And sTmp2 <> "" Then
                    sSQL = "SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes2 WHERE status='waiting_for_publisher_approval' " & sTmp2
                    SqlDataSource1.SelectCommand = sSQL
                ElseIf sTmp <> "" And sTmp2 <> "" Then
                    sSQL = "SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes1 WHERE status='waiting_for_editor_approval' " & sTmp & _
                        " UNION SELECT [page_id], [title], [file_name], [last_updated_by], [status] FROM (Select * From pages_working) As tes2 WHERE status='waiting_for_publisher_approval' " & sTmp2
                    SqlDataSource1.SelectCommand = sSQL
                End If
            End If

            panelApproval.Visible = True
            panelLogin.Visible = False
        Else
            panelApproval.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        End If
        Page.ClientScript.RegisterOnSubmitStatement(Me.GetType, "tes", "transferValue(document.getElementById('" & hidPageIDs.ClientID & "'),document.getElementById('" & hidStats.ClientID & "'))")
    End Sub

    Protected Sub btnApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager

        Dim i As Integer
        For i = 0 To GridView1.Rows.Count - 1
            If CType(GridView1.Rows.Item(i).Cells(0).Controls(1), CheckBox).Checked Then
                'lblListPages.Text = GridView1.Rows.Item(i).Cells(2).Text & " - " & hidPageIDs.Value.Split(",")(i) & " - " & hidStats.Value.Split(",")(i)
                If hidStats.Value.Split(",")(i) = "waiting_for_editor_approval" Then
                    oWorkflowManager.EditorApprove(GetUser.UserName, hidPageIDs.Value.Split(",")(i))
                ElseIf hidStats.Value.Split(",")(i) = "waiting_for_publisher_approval" Then
                    oWorkflowManager.PublisherApprove(GetUser.UserName, hidPageIDs.Value.Split(",")(i))
                End If
            End If
        Next

        oWorkflowManager = Nothing

        Response.Redirect(Me.LinkWorkspaceApproval)
    End Sub

    Protected Sub btnDecline_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDecline.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
        
        Dim oWorkflowManager As WorkflowManager = New WorkflowManager

        Dim i As Integer
        For i = 0 To GridView1.Rows.Count - 1
            If CType(GridView1.Rows.Item(i).Cells(0).Controls(1), CheckBox).Checked Then
                'lblListPages.Text = GridView1.Rows.Item(i).Cells(2).Text & " - " & hidPageIDs.Value.Split(",")(i) & " - " & hidStats.Value.Split(",")(i)
                If hidStats.Value.Split(",")(i) = "waiting_for_editor_approval" Then
                    oWorkflowManager.EditorReject(GetUser.UserName, hidPageIDs.Value.Split(",")(i))
                ElseIf hidStats.Value.Split(",")(i) = "waiting_for_publisher_approval" Then
                    oWorkflowManager.PublisherReject(GetUser.UserName, hidPageIDs.Value.Split(",")(i))
                End If
            End If
        Next

        oWorkflowManager = Nothing

        Response.Redirect(Me.LinkWorkspaceApproval)
    End Sub

    Protected Sub GridView1_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.DataBound
        If GridView1.Rows.Count = 0 Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                lblListPages.Text = GetLocalResourceObject("WaitingForApprovalEmpty")
                '"There are no pages waiting for approval."
            Else
                lblListPages.Text = GetLocalResourceObject("WaitingYourApprovalEmpty")
                '"There are no pages waiting for your approval."
            End If

            btnApprove.Visible = False
            btnDecline.Visible = False
        End If
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Response.Redirect(GridView1.SelectedRow.Cells(2).Text)
    End Sub

    Public Function ShowStatus(ByVal s As String) As String
        If s = "waiting_for_editor_approval" Then
            Return "Waiting for Editor Approval"
        ElseIf s = "waiting_for_publisher_approval" Then
            Return "Waiting for Publisher Approval"
        Else
            Return ""
        End If
    End Function

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelApproval" runat="server" Visible="False">
<p><asp:Label ID="lblListPages" meta:resourcekey="lblListPages" runat="server" Text="List of pages waiting for approval:"></asp:Label></p>


<script>
function transferValue(oEl,oEl2)
    {
    var sTmp="";
    var items = document.getElementsByName("hidSelect")
    for(var i=0;i<items.length;i++)
        {
        sTmp+="," + items[i].value;
        }
    sTmp=sTmp.substring(1);
    oEl.value=sTmp;

    var sTmp2="";
    items = document.getElementsByName("hidStat")
    for(var i=0;i<items.length;i++)
        {
        sTmp2+="," + items[i].value;
        }
    sTmp2=sTmp2.substring(1);
    oEl2.value=sTmp2;
    //alert(oEl2.value)
    }
</script>
<asp:HiddenField ID="hidPageIDs" runat="server" />
<asp:HiddenField ID="hidStats" runat="server" />
<asp:GridView ID="GridView1" GridLines=None AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"  CellPadding=7 runat="server" AllowPaging="True" HeaderStyle-HorizontalAlign=Left AutoGenerateColumns="False" DataSourceID="SqlDataSource1" AllowSorting="True">
    <Columns>
        <asp:TemplateField>
        <ItemTemplate>
            <asp:CheckBox ID="chkSelect" runat="server" />   
            <input name="hidSelect" type="hidden" value="<%#Eval("page_id") %>" />
            <input name="hidStat" type="hidden" value="<%#Eval("status") %>" />
        </ItemTemplate>     
        </asp:TemplateField> 
        <asp:BoundField meta:resourcekey="lblTitle" DataField="title" HeaderText="Title" SortExpression="title" />
        <asp:BoundField meta:resourcekey="lblLocation" DataField="file_name" HeaderText="Page" SortExpression="file_name">
        </asp:BoundField>
        <asp:TemplateField meta:resourcekey="lblStatus" HeaderText="Status" SortExpression="status">
            <ItemTemplate>
            <%#ShowStatus(Eval("status"))%>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:CommandField meta:resourcekey="lblCommand" SelectText="Go To" ShowSelectButton="True">
        </asp:CommandField>
    </Columns>
    <HeaderStyle HorizontalAlign="Left" />
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource1" runat="server" >
</asp:SqlDataSource>
<div style="margin:15px"></div>
    <asp:Button ID="btnApprove" meta:resourcekey="btnApprove" runat="server" Text=" Approve " />
    <asp:Button ID="btnDecline" meta:resourcekey="btnDecline" runat="server" Text=" Decline " />
<br /><br />

</asp:Panel>
