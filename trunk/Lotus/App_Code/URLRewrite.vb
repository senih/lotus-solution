Imports Microsoft.VisualBasic
Imports System.Web
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient

'Public Class SafeTextBox
'    Inherits System.Web.UI.WebControls.TextBox
'    'Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
'    '    MyBase.OnLoad(e)
'    '    If Not Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "clientEncode") Then
'    '        Dim sb As New StringBuilder
'    '        sb.Append("function clientEncode(id)")
'    '        sb.Append("{")
'    '        sb.Append("var oEl=document.getElementById(id);")
'    '        sb.Append("if(oEl!=null)")
'    '        sb.Append(" {")
'    '        sb.Append(" sVal=oEl.value;")
'    '        'sb.Append(" oEl.value=sVal.replace(new RegExp(’<’, ‘g’), ‘<’).replace(new RegExp(’>’, ‘g’), ‘>’);")
'    '        sb.Append(" oEl.value=sVal.replace(/&/g,""&amp;"").replace(/</g,""&lt;"").replace(/>/g,""&gt;"");")
'    '        sb.Append(" }")
'    '        sb.Append("}")
'    '        Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "clientEncode", sb.ToString(), True)
'    '    End If
'    '    If Not Page.IsPostBack Then
'    '        Page.Form.Attributes("onsubmit") += "clientEncode('" + ClientID + "');"
'    '    End If
'    'End Sub

'    Public Overrides Property Text() As String
'        Get
'            Return MyBase.Text
'        End Get
'        Set(ByVal value As String)
'            MyBase.Text = System.Web.HttpUtility.HtmlEncode(value)

'            'MyBase.Text = System.Web.HttpUtility.HtmlDecode(value)
'            'If Not String.IsNullOrEmpty(value) Then
'            '    MyBase.Text = value.Replace("&amp;", "&").Replace("&lt;", "<").Replace("&gt;", ">")
'            'Else
'            '    MyBase.Text = value
'            'End If
'        End Set
'    End Property
'End Class

Public Class URLRewrite
    Implements IHttpModule

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Dim WithEvents _application As HttpApplication = Nothing

    Public Sub Dispose() Implements System.Web.IHttpModule.Dispose
        oConn = Nothing
    End Sub

    Public Sub Init(ByVal context As System.Web.HttpApplication) Implements System.Web.IHttpModule.Init
        _application = context
    End Sub

    Private Sub context_BeginRequest(ByVal sender As Object, ByVal e As System.EventArgs) Handles _application.BeginRequest
        Dim sRawUrl As String = _application.Context.Request.RawUrl

        Dim sPath As String = _application.Context.Request.Path '/InsiteCreation2006/default.aspx or '/InsiteCreation2006/BLOGS/default.aspx
        Dim sAppPath As String = _application.Context.Request.ApplicationPath '/InsiteCreation2006

        Dim sFile As String

        HttpContext.Current.Items("action") = sRawUrl

        '~~~~~~~~~~~~ Cara 1 ~~~~~~~~~~~~
        If sAppPath = "/" Then
            sFile = sPath.Substring(1) 'sPath => /default.aspx
        Else
            'sFile = sPath.Replace(sAppPath & "/", "")
            'bug: kalau case tdk sama tdk ter-replace

            'fix:
            'MsgBox(sAppPath.ToLower & "/" & " | " & sPath.Substring(0, sAppPath.Length + 1).ToLower())
            'sAppPath.Length + 1 => sAppPath & "/"
            If sAppPath.ToLower & "/" = sPath.Substring(0, sAppPath.Length + 1).ToLower() Then
                sFile = sPath.Substring(sAppPath.Length + 1)
            Else
                sFile = sPath 'tdk terjadi
            End If
        End If
        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        'OR

        '~~~~~~~~~~~~ Cara 2 ~~~~~~~~~~~~
        'sFile = Path.GetFileName(sPath) '=> bug: won't work if page is in sub dir, eg: tes/tes.aspx
        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        HttpContext.Current.Items("_page") = sFile
        HttpContext.Current.Items("_path") = sRawUrl 'Used For Login

        Dim qs As String = ""
        If sRawUrl.Contains("?") Then
            qs = sRawUrl.Split(CChar("?"))(1).ToString
            sRawUrl = sRawUrl.Split(CChar("?"))(0).ToString
        End If

        If Not File.Exists(_application.Context.Server.MapPath(sRawUrl)) Then
            Dim sExtension As String
            sExtension = sFile.Substring(sFile.LastIndexOf(".") + 1).ToLower
            If sExtension = "aspx" Then

                _application.Context.RewritePath("~/default.aspx")
            ElseIf sExtension = "flv" Or sExtension = "mp3" Or sExtension = "jpg" Or sExtension = "jpeg" Or sExtension = "gif" Or sExtension = "png" Or sExtension = "bmp" Then
                If sFile.Split("-").Length > 1 Then
                    If sFile.Split("-")(0) = "dynamic" Then
                        _application.Context.RewritePath("~/systems/file_view.aspx?pg=" & sFile.Split("-")(1) & "&ver=" & sFile.Split("-")(2))
                    End If
                End If
            End If
        End If
    End Sub

End Class

Namespace FormReplace
    Public Class Form
        Inherits System.Web.UI.HtmlControls.HtmlForm
        Protected Overrides Sub RenderAttributes(ByVal writer As System.Web.UI.HtmlTextWriter)
            writer.WriteAttribute("name", Me.Name)
            Me.Attributes.Remove("name")

            writer.WriteAttribute("method", Me.Method)
            Me.Attributes.Remove("method")

            Me.Attributes.Render(writer)

            'If Not IsNothing(Context.Items("action")) Then
            '    writer.WriteAttribute("action", Context.Items("action"))
            'End If
            'Me.Attributes.Remove("action")

            'writer.WriteAttribute("action", HttpUtility.HtmlEncode(HttpContext.Current.Items("action")))
            'writer.WriteAttribute("action", "")
            writer.WriteAttribute("action", HttpUtility.HtmlEncode(Context.Request.RawUrl))
            Me.Attributes.Remove("action")

            writer.WriteAttribute("onsubmit", "if (typeof(WebForm_OnSubmit) == 'function') return WebForm_OnSubmit();")
            Me.Attributes.Remove("onsubmit")

            If Not IsNothing(Me.ID) Then
                writer.WriteAttribute("id", Me.ClientID)
            End If
        End Sub
    End Class
End Namespace
