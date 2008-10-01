<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    
    Private nFormPageId As Integer = 0
    Public Property FormPageId() As Integer
        Get
            Return nFormPageId
        End Get
        Set(ByVal value As Integer)
            nFormPageId = value
        End Set
    End Property
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        If nFormPageId = 0 Then
            nFormPageId = Me.ModuleData
        End If
        
        Dim dv As DataView
        Dim oFormManager As FormManager = New FormManager
        dv = New DataView(oFormManager.GetData(nFormPageId))
                
        '~~~ ROTATE STAFF ~~~
        Dim nFormDataId As Integer = 0
        Dim oCmd As SqlCommand
        Dim oReader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT TOP 1 * FROM form_data_impressions WHERE page_id=" & nFormPageId & " ORDER BY impression_date"
        oCmd.CommandType = CommandType.Text
        oReader = oCmd.ExecuteReader
        If oReader.Read Then
            nFormDataId = CInt(oReader("form_data_id")) 'Menampilkan yg teratas
        End If
        oReader.Close()
        oCmd.Dispose()
        oConn.Close()
        dv.RowFilter = "Id=" & nFormDataId
        '~~~~~~~~~~~~~~~~~~~~
        
        GridView1.DataSource = dv
        GridView1.DataBind()
        oFormManager = Nothing
    End Sub
    
    Function ShowLink(ByVal sLink As String) As String
        If Not sLink = "" Then sLink = "<a href=""" & sLink & """>læs mere</a>"
        Return sLink
    End Function

    Protected Sub GridView1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        If GridView1.Rows.Count > 0 Then
            Dim i As Integer
            Dim oCmd As SqlCommand = New SqlCommand
            oCmd.Connection = oConn
            oConn.Open()
            
            'Ada limit impresions
            'oCmd.CommandText = "update form_data_impressions set impressions=impressions-1,impression_date=getdate() WHERE form_data_id = @form_data_id"

            'Tdk ada limit impressions
            oCmd.CommandText = "update form_data_impressions set impression_date=getdate() WHERE form_data_id = @form_data_id"
            oCmd.CommandType = CommandType.Text
            oCmd.Parameters.Add("@form_data_id", SqlDbType.Int)
        
            For i = 0 To GridView1.Rows.Count - 1
                oCmd.Parameters.Item("@form_data_id").Value = GridView1.DataKeys(i).Value
                oCmd.ExecuteNonQuery()
                oCmd.Dispose()
            Next
            oConn.Close()
        End If
    End Sub
</script>

<asp:Panel ID="panelReport" runat="server">
    <asp:GridView ID="GridView1" runat="server" Width="100%" DataKeyNames="Id" AutoGenerateColumns="false" ShowHeader="false" GridLines="None" CellPadding="5"  OnPreRender="GridView1_PreRender">
    <Columns>
    <asp:TemplateField>
    <ItemTemplate>
    <div style="font-weight:bold"><%#Eval("Titel")%></div>
    <div><%#Eval("Kort tekst")%> <%#ShowLink(Eval("Link","")) %></div>
    <div style="text-align:right"><%#Eval("Forfatter")%></div>
    <%--<div><%#Eval("Beskrivelse")%></div>--%>
    </ItemTemplate>
    </asp:TemplateField>
    </Columns>
    </asp:GridView>
</asp:Panel>