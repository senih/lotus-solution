<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SqlDataSource1.ConnectionString = sConn

        If Not IsNothing(GetUser) Then
            Dim sChannelName As String
            Dim sSQL As String

            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then

                lblListOfPages.Text = GetLocalResourceObject("ListOfPagesInMyChannel") 'List of pages in my channels:

                sSQL = "SELECT [page_id], [title], [file_name], [channel_name], [status], [last_updated_by], [https] FROM pages_working where is_system=0 order by last_updated_date"
                SqlDataSource1.SelectCommand = sSQL
                SqlDataSource1.UpdateCommand = "update pages set https=@https where page_id=@page_id"
                          
            Else
                GridView1.Columns(4).Visible = False
                GridView1.Columns(5).Visible = False
                
                lblListOfPages.Text = GetLocalResourceObject("ListOfPagesInMyChannel") 'List of pages in my channels:

                Dim Item As String = ""
                Dim sTmp As String = ""

                For Each Item In Roles.GetRolesForUser(GetUser.UserName)

                    If Item.Contains("Editors") Then
                        If Item.Substring(Item.IndexOf("Editors")) = "Editors" Then

                            sChannelName = Item.Substring(0, Item.IndexOf("Editors") - 1)
                            sTmp += " OR channel_name='" & sChannelName & "'"
                        End If
                    End If

                    If Item.Contains("Publishers") Then
                        If Item.Substring(Item.IndexOf("Publishers")) = "Publishers" Then

                            sChannelName = Item.Substring(0, Item.IndexOf("Publishers") - 1)
                            sTmp += " OR channel_name='" & sChannelName & "'"
                        End If
                    End If

                    If Item.Contains("Authors") Then

                        If Item.Substring(Item.IndexOf("Authors")) = "Authors" Then
                            sChannelName = Item.Substring(0, Item.IndexOf("Authors") - 1)
                            sTmp += " OR channel_name='" & sChannelName & "'"
                        End If
                    End If
                Next

                If Not sTmp = "" Then
                    sSQL = "SELECT [page_id], [title], [file_name], [channel_name], [status], [last_updated_by], [https] FROM pages_working Where (" & sTmp.Substring(4) & ") and is_system=0 order by last_updated_date"
                    SqlDataSource1.SelectCommand = sSQL
                    SqlDataSource1.UpdateCommand = "update pages set https=@https where page_id=@page_id"
                End If
            End If

            panelMyPages.Visible = True
            panelLogin.Visible = False
        Else
            panelMyPages.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        End If

    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Response.Redirect("~/" & GridView1.SelectedRow.Cells(1).Text)
    End Sub

    Public Function ShowStatus(ByVal s As String, ByVal sBy As String) As String
        Select Case s
            Case "locked" : Return GetLocalResourceObject("LockedBy") & " " & sBy

            Case "unlocked" : Return GetLocalResourceObject("NotLocked")

            Case "need_content_revision_unlocked" : Return GetLocalResourceObject("Declined") 'Declined

            Case "need_content_revision_locked" : Return GetLocalResourceObject("LockedBy") & " " & sBy 'tdk ada

            Case "need_property_revision_unlocked" : Return GetLocalResourceObject("NotLocked")

            Case "need_property_revision_locked" : Return GetLocalResourceObject("LockedBy") & " " & sBy

            Case "waiting_for_editor_approval" : Return GetLocalResourceObject("WaitingForEditorApproval")

            Case "waiting_for_publisher_approval" : Return GetLocalResourceObject("WaitingForPublisherApproval")

            Case "published" : Return GetLocalResourceObject("Published")

            Case Else
                Return s
        End Select
    End Function

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub
</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" runat="server" meta:resourcekey="Login1" PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
</asp:Panel>

<asp:Panel ID="panelMyPages" runat="server" Visible="False">
<p>
<asp:Label ID="lblListOfPages" runat="server" Text=""></asp:Label>
</p>
<asp:GridView ID="GridView1" GridLines="None" DataKeyNames="page_id" AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" CellPadding=7 runat="server" AllowPaging="True" HeaderStyle-HorizontalAlign=Left AutoGenerateColumns="False" DataSourceID="SqlDataSource1" AllowSorting="True">
    <Columns>
        <asp:BoundField DataField="title" ReadOnly="true" meta:resourcekey="lblTitle" HeaderText="Title" SortExpression="title" >
        <ItemStyle VerticalAlign="Top" />
        </asp:BoundField>
        <asp:BoundField DataField="file_name" ReadOnly="true" meta:resourcekey="lblLocation" HeaderText="Page" SortExpression="file_name">
            <ItemStyle VerticalAlign="Top" />
        </asp:BoundField>
        <asp:BoundField DataField="channel_name" ReadOnly="true" meta:resourcekey="lblChannel" ItemStyle-VerticalAlign="top" HeaderText="Channel" SortExpression="channel_name" />
        <asp:TemplateField meta:resourcekey="lblStatus" HeaderText="Status" SortExpression="status">
            <ItemTemplate>
            <%#ShowStatus(Eval("status"), Eval("last_updated_by"))%>
            </ItemTemplate>
            <ItemStyle VerticalAlign="Top" />
        </asp:TemplateField>
        <asp:CheckBoxField DataField="https" HeaderText="Https" ItemStyle-VerticalAlign="top" SortExpression="https" />
        <asp:CommandField ShowEditButton="true" meta:resourcekey="lblEdit" EditText="Edit" ItemStyle-VerticalAlign="top" />
        <asp:CommandField meta:resourcekey="lblGoTo" SelectText="Go To" ShowSelectButton="True">
            <ItemStyle VerticalAlign="Top" Wrap=false />
        </asp:CommandField>
    </Columns>
    <HeaderStyle HorizontalAlign="Left" />
</asp:GridView>

<asp:SqlDataSource ID="SqlDataSource1" runat="server" >
</asp:SqlDataSource>
<div>&nbsp;</div>

</asp:Panel>