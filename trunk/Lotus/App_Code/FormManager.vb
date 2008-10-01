Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security.Membership

Public Class FormManager
    Inherits System.Web.UI.UserControl

    Private sConn As String
    Private oConn As SqlConnection

    Public Function GetData(ByVal nPageId As Integer) As DataTable
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        Dim dt As New DataTable

        Dim nFormFieldDefId As Integer
        Dim sInputType As String
        Dim sFieldName As String

        Dim arrFieldNames As Collection = New Collection
        Dim arrFieldTypes As Collection = New Collection
        Dim arrFieldDefId As Collection = New Collection

        Dim i As Integer = 1

        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id ORDER BY form_field_definition_id"

        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader

        dt.Columns.Add(New DataColumn("Id", GetType(Integer))) 'this

        While reader.Read
            nFormFieldDefId = CInt(reader("form_field_definition_id"))
            sInputType = reader("input_type").ToString
            sFieldName = reader("form_field_name").ToString

            arrFieldTypes.Add(sInputType, i)
            arrFieldNames.Add(sFieldName, i)
            arrFieldDefId.Add(nFormFieldDefId, i)

            i = i + 1

            If sInputType = "dropdown" Or _
                sInputType = "radio" Or _
                sInputType = "listbox_single" Or _
                sInputType = "short_text" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(String)))

            ElseIf sInputType = "listbox_multiple" Or _
                sInputType = "checklist" Or _
                sInputType = "long_text" Or _
                sInputType = "html" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(String)))

            ElseIf sInputType = "checkbox" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(Boolean)))

            ElseIf sInputType = "money" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(Decimal)))

            ElseIf sInputType = "number" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(Decimal)))

            ElseIf sInputType = "date" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(String)))

            ElseIf sInputType = "file" Then

                dt.Columns.Add(New DataColumn(sFieldName, GetType(String)))

            End If
        End While
        reader.Close()

        dt.Columns.Add(New DataColumn("Submitted", GetType(DateTime)))

        'ISI DATA
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT DISTINCT(form_data_id) FROM form_data WHERE page_id=@page_id order by form_data_id desc"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        Dim dr As DataRow
        Do While reader.Read()
            dr = dt.NewRow()

            dr("Id") = CInt(reader("form_data_id")) 'this

            dt.Rows.Add(dr)
        Loop
        reader.Close()

        For i = 1 To arrFieldDefId.Count
            oCmd = New SqlCommand
            oCmd.Connection = oConn

            oCmd.CommandText = "SELECT form_data.*, form_field_definitions.input_type " & _
                "FROM form_data INNER JOIN " & _
                "form_field_definitions ON form_data.form_field_definition_id = form_field_definitions.form_field_definition_id " & _
                "WHERE (form_data.page_id = @page_id) AND (form_data.form_field_definition_id = @form_field_definition_id) order by form_data_id desc"
            oCmd.CommandType = CommandType.Text
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCmd.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = arrFieldDefId(i)
            reader = oCmd.ExecuteReader

            Dim n As Integer = 0
            Dim nTmp As Integer = 0

            Do While reader.Read()

                If Not nTmp = CInt(reader("form_data_id")) Then
                    n = n + 1
                    nTmp = CInt(reader("form_data_id"))
                End If

                sInputType = reader("input_type").ToString

                If sInputType = "dropdown" Or _
                    sInputType = "radio" Or _
                    sInputType = "listbox_single" Or _
                    sInputType = "short_text" Then

                    dt.Rows(n - 1).Item(i) = reader("value1").ToString

                ElseIf sInputType = "listbox_multiple" Or _
                    sInputType = "checklist" Then

                    dt.Rows(n - 1).Item(i) = reader("value2").ToString.Replace("-##-", ", ")

                ElseIf sInputType = "long_text" Or _
                    sInputType = "html" Then

                    dt.Rows(n - 1).Item(i) = reader("value2").ToString

                ElseIf sInputType = "checkbox" Then

                    If IsDBNull(reader("value3")) Then
                        dt.Rows(n - 1).Item(i) = False
                    Else
                        dt.Rows(n - 1).Item(i) = CBool(reader("value3"))
                    End If

                ElseIf sInputType = "money" Then

                    If Not IsDBNull(reader("value4")) Then
                        dt.Rows(n - 1).Item(i) = FormatNumber(Convert.ToDecimal(reader("value4")), 2)
                    End If

                ElseIf sInputType = "number" Then

                    If Not IsDBNull(reader("value5")) Then
                        dt.Rows(n - 1).Item(i) = FormatNumber(Convert.ToDecimal(reader("value5")), 2)
                    End If

                ElseIf sInputType = "date" Then

                    dt.Rows(n - 1).Item(i) = FormatDateTime(CDate(reader("value6")), DateFormat.ShortDate)

                ElseIf sInputType = "file" Then

                    If Not IsDBNull(reader("value1")) Then
                        dt.Rows(n - 1).Item(i) = "<a href=""systems/form_file_download.aspx?fd=" & reader("form_data_id").ToString & "&pg=" & nPageId & "&ff=" & arrFieldDefId(i) & "&file=" & reader("value1").ToString & """>" & reader("value1").ToString & "</a>"
                    End If

                End If

                If Not IsDBNull(reader("submitted_date")) Then
                    dt.Rows(n - 1).Item(arrFieldDefId.Count + 1) = CDate(reader("submitted_date"))
                End If

            Loop

            reader.Close()
        Next

        reader.Close()
        oCmd.Dispose()
        oConn.Close()

        Return dt
    End Function

    Public Function GetControl(ByVal sInputType As String, ByVal nWidth As Object, ByVal nHeight As Object, ByVal nFormFieldDefId As Integer, ByVal sName As String, ByVal sDefaultValue As String) As Object
        Dim sql As String = "SELECT * from form_field_values where form_field_definition_id=@form_field_definition_id"
        Dim oCommand As SqlCommand
        oCommand = New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
        Dim nW As Integer = 230
        Dim nH As Integer = 50
        If Not IsDBNull(nWidth) Then
            nW = CInt(nWidth)
        End If
        If Not IsDBNull(nHeight) Then
            nH = CInt(nHeight)
        End If
        Dim oObj As Object
        Dim oReader As SqlDataReader
        oConn.Open()
        oCommand.Connection = oConn
        oReader = oCommand.ExecuteReader(CommandBehavior.CloseConnection)
        If sInputType = "dropdown" Then
            Dim oDDL As DropDownList = New DropDownList
            oDDL.ID = sName
            While oReader.Read
                Dim oItem As ListItem = New ListItem
                oItem.Value = oReader("display_value").ToString
                oItem.Text = oReader("display_value").ToString
                If CBool(oReader("is_default")) Then
                    oItem.Selected = True
                End If
                oDDL.Items.Add(oItem)
            End While
            oObj = oDDL
        ElseIf sInputType = "radio" Then
            Dim oRBL As RadioButtonList = New RadioButtonList
            oRBL.ID = sName
            While oReader.Read
                Dim oItem As ListItem = New ListItem
                oItem.Value = oReader("display_value").ToString
                oItem.Text = oReader("display_value").ToString
                If CBool(oReader("is_default")) Then
                    oItem.Selected = True
                End If
                oRBL.Items.Add(oItem)
            End While
            oObj = oRBL
        ElseIf sInputType = "listbox_multiple" Then
            Dim oList As ListBox = New ListBox
            oList.ID = sName
            oList.SelectionMode = ListSelectionMode.Multiple
            oList.Width = nW
            oList.Height = nH
            While oReader.Read
                Dim oItem As ListItem = New ListItem
                oItem.Value = oReader("display_value").ToString
                oItem.Text = oReader("display_value").ToString
                If CBool(oReader("is_default")) Then
                    oItem.Selected = True
                End If
                oList.Items.Add(oItem)
            End While
            oObj = oList
        ElseIf sInputType = "listbox_single" Then
            Dim oList As ListBox = New ListBox
            oList.ID = sName
            oList.SelectionMode = ListSelectionMode.Single
            oList.Width = nW
            oList.Height = nH
            While oReader.Read
                Dim oItem As ListItem = New ListItem
                oItem.Value = oReader("display_value").ToString
                oItem.Text = oReader("display_value").ToString
                If CBool(oReader("is_default")) Then
                    oItem.Selected = True
                End If
                oList.Items.Add(oItem)
            End While
            oObj = oList
        ElseIf sInputType = "checklist" Then
            Dim oCBL As CheckBoxList = New CheckBoxList
            oCBL.ID = sName
            While oReader.Read
                Dim oItem As ListItem = New ListItem
                oItem.Value = oReader("display_value").ToString
                oItem.Text = oReader("display_value").ToString
                If CBool(oReader("is_default")) Then
                    oItem.Selected = True
                End If
                oCBL.Items.Add(oItem)
            End While
            oObj = oCBL
        ElseIf sInputType = "checkbox" Then
            Dim oCheck As CheckBox = New CheckBox
            oCheck.ID = sName
            oObj = oCheck
        ElseIf sInputType = "long_text" Then
            Dim oText As TextBox = New TextBox
            oText.Text = sDefaultValue
            oText.TextMode = TextBoxMode.MultiLine
            oText.Width = nW
            oText.Height = nH
            oText.ID = sName
            oObj = oText
        ElseIf sInputType = "html" Then

            Dim appPath As String = Context.Request.ApplicationPath
            If (Not appPath.EndsWith("/")) Then
                appPath = appPath & "/"
            End If

            Dim oText As InnovaStudio.WYSIWYGEditor = New InnovaStudio.WYSIWYGEditor
            oText.Text = sDefaultValue
            oText.Width = nW
            oText.Height = nH
            oText.ID = sName
            oText.EditorType = InnovaStudio.EditorTypeEnum.Advance
            oText.scriptPath = appPath & "systems/editor/scripts/"
            oText.EditMode = InnovaStudio.EditorModeEnum.XHTMLBody
            oText.CssText = "body{font-family:verdana;font-size:10px}"
            oText.Text = "<html><head><style>body{font-family:verdana;font-size:11px}</style></head><body></body></html>"
            oText.btnForm = False

            'oText.btnMedia = True
            'oText.btnFlash = True
            'oText.btnAbsolute = False
            'oText.btnStyles = True
            'oText.InternalLinkWidth = 500
            'oText.InternalLinkHeight = 500
            'oText.CustomObjectWidth = 650
            'oText.CustomObjectHeight = 570
            'oText.InternalLink = "dialogs/page_links.aspx"
            oObj = oText
            'oText = Nothing
        ElseIf sInputType = "short_text" Then
            Dim oText As TextBox = New TextBox
            oText.Text = sDefaultValue
            oText.Width = nW
            oText.ID = sName
            oObj = oText
        ElseIf sInputType = "number" Then 'LATER: Validation
            Dim oText As TextBox = New TextBox
            oText.Text = sDefaultValue
            oText.Width = nW
            oText.ID = sName
            oObj = oText
        ElseIf sInputType = "money" Then 'LATER: Validation
            Dim oText As TextBox = New TextBox
            oText.Text = sDefaultValue
            oText.Width = nW
            oText.ID = sName
            oObj = oText
        ElseIf sInputType = "file" Then
            Dim oText As FileUpload = New FileUpload
            oText.ID = sName
            oObj = oText
        Else
            oObj = Nothing
        End If
        oReader.Close()
        oReader = Nothing
        oConn.Close()
        Return oObj
    End Function

    Public Sub UploadData(ByVal nFormDataId As Integer, ByVal nPageId As Integer, ByVal nFormFieldDefId As Integer, ByVal oFileUpload As FileUpload, ByVal sStorage As String)
        If oFileUpload.FileName = "" Then
            InsertEmpty(nFormDataId, nPageId, nFormFieldDefId)
            Exit Sub
        End If
        Dim oCommand As SqlCommand
        oConn.Open()
        oCommand = New SqlCommand
        oCommand.Connection = oConn
        oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value1,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value1,GetDate())"
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
        oCommand.Parameters.Add("@value1", SqlDbType.NVarChar, 255).Value = oFileUpload.FileName
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()
        oConn.Close()

        Dim sFileName As String
        Dim sFileType As String
        sFileName = nFormDataId & "_" & nPageId & "_" & nFormFieldDefId & "_" & oFileUpload.FileName
        sFileType = oFileUpload.PostedFile.ContentType.ToString
        If Not My.Computer.FileSystem.DirectoryExists(sStorage) Then
            My.Computer.FileSystem.CreateDirectory(sStorage)
        End If
        oFileUpload.SaveAs(sStorage & sFileName)
    End Sub

    Public Sub InsertData(ByVal nFormDataId As Integer, ByVal nPageId As Integer, ByVal nFormFieldDefId As Integer, ByVal sInputType As String, ByVal sValue As String, ByVal bValue As Boolean, ByVal nValue As Nullable(Of Decimal), ByVal dValue As Nullable(Of DateTime))
        Dim oCommand As SqlCommand
        oConn.Open()

        If sInputType = "dropdown" Or _
            sInputType = "radio" Or _
            sInputType = "listbox_single" Or _
            sInputType = "short_text" Then

            'sValue                
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value1,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value1,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value1", SqlDbType.NVarChar, 255).Value = sValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        ElseIf sInputType = "listbox_multiple" Or _
            sInputType = "checklist" Or _
            sInputType = "long_text" Or _
            sInputType = "html" Then

            'sValue                
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value2,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value2,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value2", SqlDbType.NText).Value = sValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        ElseIf sInputType = "checkbox" Then

            'bValue
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value3,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value3,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value3", SqlDbType.Bit).Value = bValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        ElseIf sInputType = "money" Then

            'nValue
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value4,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value4,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value4", SqlDbType.Money).Value = nValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        ElseIf sInputType = "number" Then

            'nValue
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value5,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value5,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value5", SqlDbType.Decimal).Value = nValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        ElseIf sInputType = "date" Then

            'dValue
            oCommand = New SqlCommand
            oCommand.Connection = oConn
            oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,value6,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,@value6,GetDate())"
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
            oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
            oCommand.Parameters.Add("@value6", SqlDbType.DateTime).Value = dValue
            oCommand.ExecuteNonQuery()
            oCommand.Dispose()

        Else

        End If

        oConn.Close()
    End Sub

    Public Sub InsertEmpty(ByVal nFormDataId As Integer, ByVal nPageId As Integer, ByVal nFormFieldDefId As Integer)
        Dim oCommand As SqlCommand
        oConn.Open()

        'sValue                
        oCommand = New SqlCommand
        oCommand.Connection = oConn
        oCommand.CommandText = "INSERT INTO form_data (form_data_id,page_id,form_field_definition_id,submitted_date) VALUES (@form_data_id,@page_id,@form_field_definition_id,GetDate())"
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
        oCommand.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCommand.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = nFormFieldDefId
        oCommand.ExecuteNonQuery()
        oCommand.Dispose()

        oConn.Close()
    End Sub

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
        oConn = New SqlConnection(sConn)
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub
End Class
