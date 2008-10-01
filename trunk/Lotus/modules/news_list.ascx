<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="NewsletterManager" %>


<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not IsPostBack Then
            lnkShowLatest_Click(sender, Nothing)
        End If
    End Sub

    Protected Sub ddlList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not ddlList.SelectedIndex = 0 Then
            gvMailList.DataSource = GetNewsleters(False, Me.RootID, ddlList.SelectedValue)
            gvMailList.DataBind()
            gvMailList.Visible = True
            litMessage.Text = ""
            'txtMessage.Visible = False
            'txtMessage.Text = ""
        End If
    End Sub

    Protected Sub gvMailList_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs)
        Dim sMessage As String
        Dim oNewsletter As Newsletter = New Newsletter
        oNewsletter = GetNewsletterById(gvMailList.DataKeys(e.NewSelectedIndex).Value)
        sMessage = oNewsletter.Message
        If oNewsletter.Form = "Html" Then
            'txtMessage.Text = oNewsletter.Message.Replace("<br/>", vbCrLf)
            sMessage = sMessage.Replace("[%Name%]", "--")
            litMessage.Text = sMessage
        Else
            ' txtMessage.Text = oNewsletter.Message '.Replace(vbCrLf, "<br/>")
            sMessage = sMessage.Replace("[%Name%]", "--")
            litMessage.Text = sMessage.Replace(vbCrLf, "<br/>")
        End If
        gvMailList.Visible = False
        'txtMessage.Visible = True
    End Sub

    Protected Sub lnkShowLatest_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        gvMailList.DataSource = GetNewsleters(True, Me.RootID)
        gvMailList.DataBind()
        ddlList.DataSource = GetCategoriesByRootID(Me.RootID, True, True)
        ddlList.DataBind()
        ddlList.Items.Insert(0, GetLocalResourceObject("SelectList"))
        gvMailList.Visible = True
        'txtMessage.Visible = False
        'txtMessage.Text = ""
        litMessage.Text = ""
    End Sub
  
</script>

<asp:DropDownList ID="ddlList" runat="server" DataTextField="category" DataValueField="category_id" AutoPostBack="true" OnSelectedIndexChanged="ddlList_SelectedIndexChanged">
</asp:DropDownList>&nbsp;&nbsp;
<asp:LinkButton ID="lnkShowLatest" runat="server" OnClick="lnkShowLatest_Click" meta:resourcekey="lnkLatest">Show All</asp:LinkButton>
<div style="margin:15px"></div>
<asp:GridView ID="gvMailList" runat="server" EnableTheming="false"
      CellPadding="4" ShowHeader="false" GridLines="None" AutoGenerateColumns="False" 
      AllowPaging="True" AllowSorting="false" DataKeyNames="id" 
      OnSelectedIndexChanging="gvMailList_SelectedIndexChanging">
      <Columns>
        <asp:TemplateField>
          <ItemTemplate>
           <%# Eval("Subject", "")%> - <%#Eval("CreatedDate", "")%>
          </ItemTemplate>
        </asp:TemplateField>
        <asp:CommandField SelectText="Select" ItemStyle-VerticalAlign="top" ShowSelectButton="True" meta:resourcekey="Select"/> 
      </Columns>
</asp:GridView>
<%--<asp:TextBox ID="txtMessage" runat="server" Visible="false" width="500px" height="100px" ReadOnly="true" TextMode="MultiLine"></asp:TextBox>
--%>
<asp:Literal ID="litMessage" runat="server"></asp:Literal>