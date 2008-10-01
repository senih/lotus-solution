<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>

<script runat="server">  
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
       
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()
        oCommand = New SqlCommand("Select * From pages_published where page_id=@page_id")
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = Me.ModuleData
        oCommand.Connection = oConn
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            litContent.Text = oDataReader("content_body").ToString
        End If
        oDataReader.Close()
        oConn.Close()
        oConn = Nothing
    End Sub
</script>
<asp:Literal ID="litContent" runat="server"></asp:Literal>
