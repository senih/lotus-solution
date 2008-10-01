<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.IO" %>

<script runat=server>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim nFormDataId As Integer = Request.QueryString("fd")
        Dim nPageId As Integer = Request.QueryString("pg")
        Dim nFormFieldDefId As Integer = Request.QueryString("ff")
        Dim sFileName As String = nFormDataId & "_" & nPageId & "_" & nFormFieldDefId & "_" & Request.QueryString("file")

        '~~~ Authorization ~~~
        If Not Session("allow") = True Then
            Response.Write("Please Login..")
            Exit Sub
        End If
        '~~~~~~~~~~~~~~~~~~~~~

        If sFileName <> "" Then
            Dim sFile As String = Server.MapPath("../resources") & "\Forms\" & nPageId & "\" & sFileName
            Dim infoFile As New FileInfo(sFile)
            Response.Clear()
            Response.AddHeader("content-disposition", "attachment;filename=" & Request.QueryString("file"))
            Response.AddHeader("Content-Length", infoFile.Length.ToString)
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(sFile)
            Response.End()
        Else
            Response.Write("File Not Found.")
        End If
    End Sub
</script>
