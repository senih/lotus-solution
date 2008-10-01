<%@ Page Language="VB" %>
<%@ Import Namespace="System.Drawing"  %>
<%@ Import Namespace="System.Drawing.Imaging"  %>
<%@ Import Namespace="System.Drawing.Drawing2D"  %>

<script runat="server">
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim nSizeThumb As Integer
        Dim sFileLocation As String
        Dim nJpegQuality As Integer
        Dim nNewWidth As Integer
        Dim nNewHeight As Integer
        Dim imgOri As System.Drawing.Image

        nSizeThumb = Request.QueryString("Size")
        sFileLocation = Request.QueryString("file")
        nJpegQuality = Request.QueryString("Quality")

        'Authorization
        Dim nPageId As Integer
        nPageId = sFileLocation.Substring(0, sFileLocation.IndexOf("\"))
        If Not Session(nPageId.ToString) Then
            'Session(nPageId.ToString) akan = true jika GenerateThumbnails berhasil di-execute
            Response.Write("Authorization Failed.")
            Exit Sub
        End If
                
        Dim sFile As String = ConfigurationManager.AppSettings("FileStorage") & "\files\" & sFileLocation
        
        imgOri = System.Drawing.Image.FromFile(sFile)
        nNewWidth = imgOri.Size.Width
        nNewHeight = imgOri.Size.Height
        If nNewWidth < nSizeThumb And nNewHeight < nSizeThumb Then
            'noop
        ElseIf nNewWidth > nNewHeight Then
            nNewHeight = nNewHeight * (nSizeThumb / nNewWidth)
            nNewWidth = nSizeThumb
        ElseIf nNewWidth < nNewHeight Then
            nNewWidth = nNewWidth * (nSizeThumb / nNewHeight)
            nNewHeight = nSizeThumb
        Else
            nNewWidth = nSizeThumb
            nNewHeight = nSizeThumb
        End If
  
        'Cara 1
        Dim imgThumb As System.Drawing.Image = New Bitmap(nNewWidth, nNewHeight)
        Dim gr As Graphics = Graphics.FromImage(imgThumb)
        gr.InterpolationMode = InterpolationMode.HighQualityBicubic
        gr.SmoothingMode = SmoothingMode.HighQuality
        gr.PixelOffsetMode = PixelOffsetMode.HighQuality
        gr.CompositingQuality = CompositingQuality.HighQuality
        gr.DrawImage(imgOri, 0, 0, nNewWidth, nNewHeight)
        
        'Cara 2
        'Dim imgThumb As System.Drawing.Image = _
        'imgOri.GetThumbnailImage(nNewWidth, nNewHeight, Nothing, System.IntPtr.Zero)
        
        Response.ContentType = "image/jpeg"
        
        'Cara 1
        Dim info() As ImageCodecInfo = ImageCodecInfo.GetImageEncoders()
        Dim ePars As EncoderParameters = New EncoderParameters(1)
        ePars.Param(0) = New EncoderParameter(Imaging.Encoder.Quality, nJpegQuality)
        imgThumb.Save(Response.OutputStream, info(1), ePars)
        
        'Cara 2
        'imgThumb.Save(Response.OutputStream, Imaging.ImageFormat.Jpeg)
        
        imgThumb.Dispose()
        imgOri.Dispose()
    End Sub
</script>