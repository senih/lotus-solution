<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="NewsletterManager" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
                
    Private sUserName As String = ""
    Private sUserEmail As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        'Format link untuk update subscription = linkupdate?uid=[encripted name & email]
        'Extract Encripted  email

        Dim Id As String = Request.QueryString("uid")
        panelConfirm.Visible = False
        panelFinish.Visible = False
        If Not Id = "" Then
            Id = IDDecode(Id)
            Try
                sUserName = Id.Split(";").GetValue(0)
                sUserEmail = Id.Split(";").GetValue(1)
            Catch ex As Exception
                Exit Sub
            End Try

            ' Get Info from subscriber
            Dim colSubscriberInfo As Collection = GetSubscriberInfo(sUserEmail)
            Dim bExist As Boolean = False
            If Not IsNothing(colSubscriberInfo.Count) Then
                If CType(colSubscriberInfo(colSubscriberInfo.Count), Subscription).Status Then
                    bExist = True
                End If
            End If
            
            If bExist Then
                lblEmail.Text = sUserEmail
                hidEmail.Value = sUserEmail
                panelConfirm.Visible = True
            
                'Show all Active Mailing List (Private or Not)
                cbCategories.DataSource = GetCategoriesByRootID(Me.RootID, True, False)
                cbCategories.DataBind()

                'Select which subscription
                Dim i, x As Integer
                Try
                    Dim colCategories As Collection = GetSubscription(sUserEmail)
                    For x = 1 To colCategories.Count
                        For i = 0 To cbCategories.Items.Count - 1
                            If cbCategories.Items(i).Value = CType(colCategories(x), Subscription).CategoryId Then
                                cbCategories.Items(i).Selected = True
                            End If
                        Next
                    Next
                Catch ex As Exception
                End Try
                
                'Hide Private Mailing List
                Dim oConn As SqlConnection = New SqlConnection(sConn)
                Dim oReader As SqlDataReader
                Dim oCmd As SqlCommand
                oCmd = New SqlCommand
                oCmd.Connection = oConn
                oCmd.CommandType = CommandType.Text
                oCmd.CommandText = "select * from newsletters_categories where private=1 AND active=1 AND (root_id=" & Me.RootID & " or root_id is null) order by category"
                oConn.Open()
                oReader = oCmd.ExecuteReader()
                While oReader.Read
                    'cbCategories.Items.Remove(cbCategories.Items.FindByValue(oReader("category_id")))
                    If Not cbCategories.Items.FindByValue(oReader("category_id")).Selected Then
                        cbCategories.Items.FindByValue(oReader("category_id")).Attributes.Add("style", "display:none")
                    End If
                End While
                oReader.Close()
                oCmd.Dispose()
                oConn.Close()
            End If

        End If

    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim colSubscriptionInfo As Subscription = New Subscription

        'Insert UserName & Email to newsletters_subscribers each category
        For i = 0 To cbCategories.Items.Count - 1
            colSubscriptionInfo = CheckSubscription(sUserEmail, cbCategories.Items(i).Value)

            If cbCategories.Items(i).Selected Then 'subscribe
                'check apakah dia sudah terdaftar pad akategory tersebut ? 
                If Not IsNothing(colSubscriptionInfo) Then
                    UpdateSubscription(hidEmail.Value, sUserEmail, cbCategories.Items(i).Value, False)
                Else
                    AddSubscriber(sUserName, sUserEmail, cbCategories.Items(i).Value, False)
                End If
            Else 'unsubscribe
                If Not IsNothing(colSubscriptionInfo) Then
                    UpdateSubscription(hidEmail.Value, sUserEmail, cbCategories.Items(i).Value, True)
                End If
            End If
        Next
        panelConfirm.Visible = False
        panelFinish.Visible = True
    End Sub
</script>

<asp:Panel ID="panelConfirm" runat="server">

    <%=GetLocalResourceObject("email")%> <asp:Label ID="lblEmail" Font-Bold=true runat="server"></asp:Label>
    <br /><br />
    <%=GetLocalResourceObject("Choose")%> 
    <div style="margin:7px"></div>
    <asp:CheckBoxList ID="cbCategories" runat="server" DataTextField="category" DataValueField="category_id">
    </asp:CheckBoxList>
    <div style="margin:10px"></div>
    <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" meta:resourcekey="btnUpdate" Text="Update" />
    <div style="margin:20px"></div>
    <asp:HiddenField ID="hidEmail" runat="server" />
</asp:Panel>

<asp:Panel ID="panelFinish" runat="server">

    <%=GetLocalResourceObject("finish")%>
    <div style="margin:20px"></div>

</asp:Panel>
