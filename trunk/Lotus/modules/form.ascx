<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Private nPageId As Integer
    Private sStorage As String
    Private dv As DataView

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        nPageId = Me.PageID

        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
    
        If Me.IsAdministrator Or Me.IsAuthor Then
        
            If Request.QueryString("mode") = "edit" Then
            
                '~~~ Prepare Panels ~~~
                panelEditForm.Visible = True
                panelViewForm.Visible = False
                panelValues.Visible = False
                panelResults.Visible = False
                panelFormSettings.Visible = False
            
                panelLinks.Visible = True
                lnkViewForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page")
                lnkResults.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=data"
                lnkFormSettings.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=set"
                lnkEditForm.NavigateUrl = ""
                '~~~ /Prepare Panels ~~~
            
                SqlDataSource1.DeleteCommand = "DELETE FROM [form_field_definitions] WHERE [form_field_definition_id] = @form_field_definition_id"
                SqlDataSource1.UpdateCommand = "UPDATE [form_field_definitions] SET [form_field_name] = @form_field_name, [sorting] = @sorting, [input_type] = @input_type, [width] = @width, [height] = @height, [default_value] = @default_value, [page_id] = @page_id, [is_required] = @is_required WHERE [form_field_definition_id] = @form_field_definition_id"
                SqlDataSource1.SelectCommand = "SELECT * FROM [form_field_definitions] WHERE ([page_id] = @page_id)"
                SqlDataSource1.SelectParameters("page_id").DefaultValue = nPageId

                ddlInputType.Attributes.Add("onchange", "validateInputType(document.getElementById('" & ddlInputType.ClientID & "'),document.getElementById('" & divWidth.ClientID & "'),document.getElementById('" & divHeight.ClientID & "'));return false;")

                lblFieldExists.Visible = False
            
                'EXIT
                oConn.Close()
                Exit Sub
            ElseIf Request.QueryString("mode") = "data" Then
            
                '~~~ For download authorization ~~~
                Session("allow") = True
            
                '~~~ Prepare Panels ~~~
                panelEditForm.Visible = False
                panelViewForm.Visible = False
                panelValues.Visible = False
                panelResults.Visible = True
                panelFormSettings.Visible = False
            
                panelLinks.Visible = True
                lnkViewForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page")
                lnkEditForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=edit"
                lnkFormSettings.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=set"
                lnkResults.NavigateUrl = ""
                '~~~ /Prepare Panels ~~~
            
                ShowFormData()
            
                If GridView1.Rows.Count = 0 Then
                    btnDelete.Visible = False
                    btnDownloadCsv.Visible = False
                    lblNoRecords.Visible = True
                Else
                    lblNoRecords.Visible = False
                End If
                btnDelete.OnClientClick = "if(_getSelection(document.getElementById('" & hidDataToDel.ClientID & "'))){return confirm('" & GetLocalResourceObject("DeleteDataConfirm") & "')}else{return false}"

                'EXIT
                oConn.Close()
                Exit Sub
            ElseIf Request.QueryString("mode") = "set" Then
            
                '~~~ Prepare Panels ~~~
                panelEditForm.Visible = False
                panelViewForm.Visible = False
                panelValues.Visible = False
                panelResults.Visible = False
                panelFormSettings.Visible = True
            
                panelLinks.Visible = True
                lnkViewForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page")
                lnkResults.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=data"
                lnkEditForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=edit"
                lnkFormSettings.NavigateUrl = ""
                '~~~ /Prepare Panels ~~~
            
                oCmd = New SqlCommand
                oCmd.Connection = oConn
            
                oCmd.CommandText = "SELECT * FROM form_settings WHERE page_id=@page_id"
                oCmd.CommandType = CommandType.Text
                oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
                reader = oCmd.ExecuteReader
                Dim bSettingExists As Boolean = False
                If reader.Read Then
                    bSettingExists = True
                    txtEmail.Text = reader("email").ToString
                    txtFormHeader.Text = reader("header").ToString
                    txtFormFooter.Text = reader("footer").ToString
                    txtThankYouMessage.Text = reader("thank_you_message").ToString
                    If IsDBNull(reader("return_to_form")) Then
                        chkReturnToForm.Checked = False
                    Else
                        chkReturnToForm.Checked = CBool(reader("return_to_form"))
                    End If
                End If
                reader.Close()
            
                If Not bSettingExists Then
                    oCmd.CommandText = "INSERT INTO form_settings (page_id) VALUES (@page_id)"
                    oCmd.CommandType = CommandType.Text
                    oCmd.Parameters.Item("@page_id").Value = nPageId
                    oCmd.ExecuteNonQuery()
                End If
            
                oCmd.Dispose()
            
                'EXIT
                oConn.Close()
                Exit Sub
            ElseIf Request.QueryString("mode") = "ok" Then
                oCmd = New SqlCommand
                oCmd.Connection = oConn
                oCmd.CommandText = "SELECT * FROM form_settings WHERE page_id=" & nPageId
                oCmd.CommandType = CommandType.Text
                reader = oCmd.ExecuteReader
                If reader.Read Then
                    panelThankYou.Visible = True
                    lblThankYou.Text = reader("thank_you_message").ToString
                End If
                reader.Close()
                oCmd.Dispose()

            ElseIf Request.QueryString("pvid") <> "" Then
            
                '~~~ Prepare Panels ~~~
                panelValues.Visible = True
                panelViewForm.Visible = False
                panelEditForm.Visible = False
                panelResults.Visible = False
                panelFormSettings.Visible = False
            
                panelLinks.Visible = False
                '~~~ /Prepare Panels ~~~
            
                'Ini utk persist value form_field_definition_id (dipake wkt Add value)
                SqlDataSource2.SelectParameters("form_field_definition_id").DefaultValue = Request.QueryString("pvid")
        
                SqlDataSource2.SelectCommand = "SELECT * FROM form_field_values WHERE form_field_definition_id=@form_field_definition_id"
                SqlDataSource2.DeleteCommand = "DELETE FROM form_field_values WHERE form_field_value_id=@form_field_value_id"
                SqlDataSource2.UpdateCommand = "UPDATE form_field_values SET is_default=@is_default,display_value=@display_value WHERE form_field_value_id=@form_field_value_id"
                GridView3.DataBind()

                oCmd = New SqlCommand
                oCmd.Connection = oConn
                oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE form_field_definition_id=@form_field_definition_id"
                oCmd.CommandType = CommandType.Text
                oCmd.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = Request.QueryString("pvid")
                reader = oCmd.ExecuteReader
                If reader.Read Then
                    lblTitle.Text = reader("form_field_name").ToString
                End If
                reader.Close()
                oCmd.Dispose()

                'EXIT
                oConn.Close()
                Exit Sub
            Else
                'CONTINUE
            End If
        Else
            'CONTINUE
        End If
            
        '~~~ Prepare Panels ~~~
        Dim bFormEmpty As Boolean = False
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        If Not reader.Read Then
            'Form Empty      
            bFormEmpty = True
        End If
        reader.Close()
        oCmd.Dispose()
        If bFormEmpty Then
            panelViewForm.Visible = False
        Else
            panelViewForm.Visible = True
        End If
        panelValues.Visible = False
        panelEditForm.Visible = False
        panelResults.Visible = False
        panelFormSettings.Visible = False
    
        If Me.IsAdministrator Or Me.IsAuthor Then
            panelLinks.Visible = True
            lnkEditForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=edit"
            lnkResults.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=data"
            lnkFormSettings.NavigateUrl = "~/" & HttpContext.Current.Items("_page") & "?mode=set"
            lnkViewForm.NavigateUrl = ""
        Else
            panelLinks.Visible = False
        End If
    
        lnkReturnToForm.NavigateUrl = "~/" & HttpContext.Current.Items("_page")
        '~~~ /Prepare Panels ~~~


        '~~~~~~~~~ FORM SETTINGS ~~~~~~~~~
        sStorage = Server.MapPath("resources") & "\Forms\" & nPageId & "\"
        Dim sFormHeader As String = ""
        Dim sFormFooter As String = ""

        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_settings WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        If reader.Read Then
            sFormHeader = reader("header").ToString
            sFormFooter = reader("footer").ToString()
            If Not sFormHeader = "" Then
                sFormHeader = "<div style=""margin:15px""></div>" & sFormHeader & "<div style=""margin:15px""></div>"
            End If
            If Not sFormFooter = "" Then
                sFormFooter = "<div style=""margin:15px""></div>" & sFormFooter & "<div style=""margin:15px""></div>"
            End If
        End If
        reader.Close()
            
        '~~~~~~~~~ RENDER FIELDS ~~~~~~~~~
        Dim i As Integer
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id ORDER BY sorting"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        panelForm.Controls.Add(New LiteralControl(sFormHeader))
        panelForm.Controls.Add(New LiteralControl("<table cellpadding=""0"" cellspacing=""0""><tr><td colspan=""3""></td></tr>"))
        While reader.Read
        
            panelForm.Controls.Add(New LiteralControl("<tr><td valign=""top"" style=""padding-top:7px"">" & reader("form_field_name") & "</td><td valign=""top"" style=""padding:5px;padding-top:7px"">:&nbsp;</td><td valign=""top"" style=""padding:5px"">"))
        
            If reader("input_type").ToString = "date" Then

                Dim oDropMonth As DropDownList = New DropDownList
                oDropMonth.ID = "prop_month" & reader("form_field_definition_id")
                For i = 1 To 12
                    oDropMonth.Items.Add(New ListItem(i, i))
                Next
                panelForm.Controls.Add(oDropMonth)

                Dim oDropDay As DropDownList = New DropDownList
                oDropDay.ID = "prop_day" & reader("form_field_definition_id")
                For i = 1 To 31
                    oDropDay.Items.Add(New ListItem(i, i))
                Next
                panelForm.Controls.Add(oDropDay)

                Dim oDropYear As DropDownList = New DropDownList
                oDropYear.ID = "prop_year" & reader("form_field_definition_id")
                For i = 2003 To 2015
                    oDropYear.Items.Add(New ListItem(i, i))
                Next
                panelForm.Controls.Add(oDropYear)

                oDropMonth.Text = Date.Now.Month
                oDropDay.Text = Date.Now.Day
                oDropYear.Text = Date.Now.Year

                oDropMonth.Attributes.Add("onchange", "validateDate(document.getElementById('" & oDropDay.ClientID & "'), document.getElementById('" & oDropMonth.ClientID & "'), document.getElementById('" & oDropYear.ClientID & "'))")
                oDropDay.Attributes.Add("onchange", "validateDate(document.getElementById('" & oDropDay.ClientID & "'), document.getElementById('" & oDropMonth.ClientID & "'), document.getElementById('" & oDropYear.ClientID & "'))")
                oDropYear.Attributes.Add("onchange", "validateDate(document.getElementById('" & oDropDay.ClientID & "'), document.getElementById('" & oDropMonth.ClientID & "'), document.getElementById('" & oDropYear.ClientID & "'))")

            Else
                Dim oFormManager As FormManager = New FormManager
                panelForm.Controls.Add(oFormManager.GetControl(reader("input_type").ToString, reader("width"), reader("height"), reader("form_field_definition_id"), "prop" & reader("form_field_definition_id"), reader("default_value").ToString))
                oFormManager = Nothing
            End If

            If CBool(reader("is_required")) And Not reader("input_type").ToString = "checkbox" And Not reader("input_type").ToString = "checklist" And Not reader("input_type").ToString = "date" And Not reader("input_type").ToString = "html" Then
                Dim oRfv As RequiredFieldValidator = New RequiredFieldValidator
                oRfv.ControlToValidate = "prop" & reader("form_field_definition_id")
                oRfv.ErrorMessage = " *"
                panelForm.Controls.Add(oRfv)
            End If
        
            If reader("input_type").ToString = "number" Or reader("input_type").ToString = "money" Then
                Dim oNv As CompareValidator = New CompareValidator
                oNv.ControlToValidate = "prop" & reader("form_field_definition_id")
                oNv.Type = ValidationDataType.Double
                oNv.ErrorMessage = " *"
                oNv.ID = "oNv" & reader("form_field_definition_id")
                panelForm.Controls.Add(oNv)
            End If
        
            panelForm.Controls.Add(New LiteralControl("</td></tr>"))

        End While
        panelForm.Controls.Add(New LiteralControl("</table>"))
        panelForm.Controls.Add(New LiteralControl(sFormFooter))
        reader.Close()
        oConn.Close()

    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        Dim reader As SqlDataReader

        'Get nFormDataId
        Dim nFormDataId As Integer = 1
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "Select max(form_data_id) from form_data"
        oCmd.CommandType = CommandType.Text
        reader = oCmd.ExecuteReader()
        If reader.Read Then
            If Not IsDBNull(reader(0)) Then
                nFormDataId = CInt(reader(0)) + 1
            End If
        End If
        reader.Close()
        oCmd.Dispose()
    
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO form_data_impressions (form_data_id,page_id) VALUES (@form_data_id,@page_id)"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@form_data_id", SqlDbType.Int).Value = nFormDataId
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()

        '~~~~~~~~~ CONSTRUCT VALUES FOR SAVING ~~~~~~~~~
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id ORDER BY form_field_definition_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        Dim sInputType As String = ""
        Dim nFormFieldDefId As Integer

        Dim sValue As String = ""
        Dim bValue As Boolean = False
        Dim nValue As Nullable(Of Decimal)
        Dim dValue As Nullable(Of Date)

        Dim oFormManager As FormManager = New FormManager

        While reader.Read
            sInputType = reader("input_type").ToString
            nFormFieldDefId = CInt(reader("form_field_definition_id"))
            sValue = ""
            bValue = False

            If sInputType = "dropdown" Then
                sValue = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), DropDownList).SelectedValue
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
            ElseIf sInputType = "radio" Then
                sValue = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), RadioButtonList).SelectedValue
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
            ElseIf sInputType = "listbox_multiple" Or sInputType = "listbox_single" Then
                Dim oListBox As ListBox = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), ListBox)
                Dim oItem As ListItem
                For Each oItem In oListBox.Items
                    If oItem.Selected Then
                        sValue += "-##-" & oItem.Value
                    End If
                Next
                If Not sValue = "" Then
                    sValue = sValue.Substring(4)
                    oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
                Else
                    oFormManager.InsertEmpty(nFormDataId, nPageId, nFormFieldDefId)
                End If
            ElseIf sInputType = "checklist" Then
                Dim oCheckList As CheckBoxList = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), CheckBoxList)
                Dim oItem As ListItem
                For Each oItem In oCheckList.Items
                    If oItem.Selected Then
                        sValue += "-##-" & oItem.Value
                    End If
                Next
                If Not sValue = "" Then
                    sValue = sValue.Substring(4)
                    oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
                Else
                    oFormManager.InsertEmpty(nFormDataId, nPageId, nFormFieldDefId)
                End If
            ElseIf sInputType = "checkbox" Then
                bValue = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), CheckBox).Checked
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
            ElseIf sInputType = "long_text" Or sInputType = "short_text" Then
                sValue = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), TextBox).Text
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
                CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), TextBox).Text = ""
            ElseIf sInputType = "html" Then
                sValue = CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), InnovaStudio.WYSIWYGEditor).Text
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
            ElseIf sInputType = "number" Or sInputType = "money" Then
                If Not CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), TextBox).Text = "" Then
                    nValue = Convert.ToDecimal(CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), TextBox).Text)
                    oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
                    CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), TextBox).Text = ""
                Else
                    oFormManager.InsertEmpty(nFormDataId, nPageId, nFormFieldDefId)
                End If
            ElseIf sInputType = "date" Then
                Dim nMonth As Integer = CType(Me.FindControl("prop_month" & reader("form_field_definition_id").ToString()), DropDownList).SelectedValue
                Dim nDay As Integer = CType(Me.FindControl("prop_day" & reader("form_field_definition_id").ToString()), DropDownList).SelectedValue
                Dim nYear As Integer = CType(Me.FindControl("prop_year" & reader("form_field_definition_id").ToString()), DropDownList).SelectedValue
                dValue = New DateTime(nYear, nMonth, nDay)
                oFormManager.InsertData(nFormDataId, nPageId, nFormFieldDefId, sInputType, sValue, bValue, nValue, dValue)
            ElseIf sInputType = "file" Then
                oFormManager.UploadData(nFormDataId, nPageId, nFormFieldDefId, CType(Me.FindControl("prop" & reader("form_field_definition_id").ToString()), FileUpload), sStorage)
            Else
                'noop
            End If

        End While
        reader.Close()
    
        Dim bReturn As Boolean = False
        Dim bEmail As Boolean = False
        Dim sEmails As String = ""
        Dim sEmail As String = ""
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_settings WHERE page_id=" & nPageId
        oCmd.CommandType = CommandType.Text
        reader = oCmd.ExecuteReader
        If reader.Read Then
            lblThankYou.Text = reader("thank_you_message").ToString
            If IsDBNull(reader("return_to_form")) Then
                bReturn = False
            Else
                bReturn = CBool(reader("return_to_form"))
                sEmails = reader("email").ToString '& ";"
                If sEmails <> "" Then
                    bEmail = True
                End If
            End If
  
        End If
        reader.Close()
        oCmd.Dispose()
    

        If bEmail Then
            Dim sBody As String = ""
            Dim sFieldName As String = ""
            Dim sFieldValue As String
            oCmd = New SqlCommand
            oCmd.Connection = oConn
            oCmd.CommandText = "SELECT form_data.*,def.form_field_name,def.input_type from form_data inner join (select * from form_field_definitions ) as def ON (def.form_field_definition_id = form_data.form_field_definition_id) WHERE form_data.page_id=" & nPageId & "and form_data.form_data_id=" & nFormDataId & " order by def.sorting"
            oCmd.CommandType = CommandType.Text
            reader = oCmd.ExecuteReader
            While reader.Read
                sFieldValue = ""
                sInputType = reader("input_type").ToString

                If sInputType = "dropdown" Or _
                    sInputType = "radio" Or _
                    sInputType = "listbox_single" Or _
                    sInputType = "short_text" Then

                    sFieldValue = reader("value1").ToString

                ElseIf sInputType = "listbox_multiple" Or _
                    sInputType = "checklist" Then
                    sFieldValue = reader("value2").ToString.Replace("-##-", ",")

                ElseIf sInputType = "long_text" Or _
                    sInputType = "html" Then

                    sFieldValue = reader("value2").ToString

                ElseIf sInputType = "checkbox" Then

                    If IsDBNull(reader("value3")) Then
                        sFieldValue = False
                    Else
                        sFieldValue = CBool(reader("value3"))
                    End If

                ElseIf sInputType = "money" Then

                    If Not IsDBNull(reader("value4")) Then
                        sFieldValue = FormatNumber(Convert.ToDecimal(reader("value4")), 2)
                    End If

                ElseIf sInputType = "number" Then

                    If Not IsDBNull(reader("value5")) Then
                        sFieldValue = FormatNumber(Convert.ToDecimal(reader("value5")), 2)
                    End If

                ElseIf sInputType = "date" Then

                    sFieldValue = FormatDateTime(CDate(reader("value6")), DateFormat.ShortDate)

                ElseIf sInputType = "file" Then

                    If Not IsDBNull(reader("value1")) Then
                        sFieldValue = reader("value1").ToString
                    End If
                End If

                sFieldName = sFieldName & reader("form_field_name") & ": " & sFieldValue & vbCrLf
            End While

            reader.Close()
            oCmd.Dispose()
            oConn.Close()
            'Label1.Text = sFieldName
            Dim oSmtpClient As SmtpClient = New SmtpClient
            Dim oMailMessage As MailMessage = New MailMessage
            Dim sFrom As String = ""

            For Each sEmail In sEmails.Split(";")
                If sEmail <> "" Then
                    Try
                        'Dim oSmtpSection As Net.Configuration.SmtpSection = CType(ConfigurationManager.GetSection("system.net/mailSettings/smtp"), Net.Configuration.SmtpSection)
                        'sFrom = oSmtpSection.From.ToString
                        Dim ToMail As MailAddress = New MailAddress(sEmail)
                        'oMailMessage.From = New MailAddress(sFrom, sFrom)
                        oMailMessage.To.Clear()
                        oMailMessage.To.Add(ToMail)
                        oMailMessage.Subject = GetLocalResourceObject("subject") & " (" & HttpContext.Current.Items("_page") & ")" ' Perlu dibuat subject
                        oMailMessage.IsBodyHtml = False
                        oMailMessage.Body = sFieldName
                        oSmtpClient.Send(oMailMessage)
                    Catch ex As Exception
                    End Try
                End If
    
            Next

        End If

        If bReturn Then
            'Response.Redirect(HttpContext.Current.Items("_page") & "?mode=ok")
        Else
            panelForm.Visible = False
            panelSubmit.Visible = False
            panelThankYou.Visible = True
        End If

    End Sub

    Sub ShowFormData()
        Dim i As Integer = 2
        Dim nItem As Integer
        Dim oCollRich As Collection = New Collection
    
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        'oConn.Open()        
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        While reader.Read
            If reader("input_type") = "html" Or reader("input_type") = "file" Then
                oCollRich.Add(i)
            End If
            i = i + 1
        End While
        reader.Close()
        oCmd.Dispose()
        'oConn.Close()
    
        Dim oFormManager As FormManager = New FormManager
        dv = New DataView(oFormManager.GetData(nPageId))

        GridView1.DataSource = dv
        GridView1.DataBind()
    
        'HTML Format
        Dim oLabel As HtmlGenericControl
        For i = 0 To GridView1.Rows.Count - 1
            For Each nItem In oCollRich
                oLabel = New HtmlGenericControl
                oLabel.InnerHtml = Server.HtmlDecode(GridView1.Rows(i).Cells(nItem).Text)
                GridView1.Rows(i).Cells(nItem).Controls.Add(oLabel)
            Next
        Next

        oFormManager = Nothing
    End Sub

    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)

        If Not hidSortExpression.Value = "" Then
            If hidSortDirection.Value = "DESCENDING" Then
                dv.Sort = hidSortExpression.Value & " ASC"
            Else
                dv.Sort = hidSortExpression.Value & " DESC"
            End If
        End If

        GridView1.DataSource = dv
        GridView1.PageIndex = e.NewPageIndex
        GridView1.DataBind()

        'NEW
        Dim i As Integer = 2
        Dim nItem As Integer
        Dim oCollRich As Collection = New Collection
    
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        While reader.Read
            If reader("input_type") = "html" Or reader("input_type") = "file" Then
                oCollRich.Add(i)
            End If
            i = i + 1
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()
        'HTML Format
        Dim oLabel As HtmlGenericControl
        For i = 0 To GridView1.Rows.Count - 1
            For Each nItem In oCollRich
                oLabel = New HtmlGenericControl
                oLabel.InnerHtml = Server.HtmlDecode(GridView1.Rows(i).Cells(nItem).Text)
                GridView1.Rows(i).Cells(nItem).Controls.Add(oLabel)
            Next
        Next
    End Sub

    Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)
        If hidSortExpression.Value = e.SortExpression.ToString Then
            If hidSortDirection.Value = "DESCENDING" Then
                dv.Sort = e.SortExpression & " DESC"
                hidSortDirection.Value = "ASCENDING"
            Else
                dv.Sort = e.SortExpression & " ASC"
                hidSortDirection.Value = "DESCENDING"
            End If
        Else
            hidSortExpression.Value = e.SortExpression.ToString
            dv.Sort = e.SortExpression & " ASC"
            hidSortDirection.Value = "DESCENDING"
        End If
        GridView1.DataSource = dv
        GridView1.DataBind()
    
        'NEW
        Dim i As Integer = 2
        Dim nItem As Integer
        Dim oCollRich As Collection = New Collection
    
        Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        While reader.Read
            If reader("input_type") = "html" Or reader("input_type") = "file" Then
                oCollRich.Add(i)
            End If
            i = i + 1
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()
        'HTML Format
        Dim oLabel As HtmlGenericControl
        For i = 0 To GridView1.Rows.Count - 1
            For Each nItem In oCollRich
                oLabel = New HtmlGenericControl
                oLabel.InnerHtml = Server.HtmlDecode(GridView1.Rows(i).Cells(nItem).Text)
                GridView1.Rows(i).Cells(nItem).Controls.Add(oLabel)
            Next
        Next
    End Sub

    'Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
    '    Dim oCmd As SqlCommand
    '    oConn.Open()
    
    '    oCmd = New SqlCommand("DELETE FROM form_data WHERE page_id=@page_id AND form_data_id=@form_data_id")
    '    oCmd.CommandType = CommandType.Text
    '    oCmd.Connection = oConn
    '    oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
    '    oCmd.Parameters.Add("@form_data_id", SqlDbType.Int).Value = CInt(GridView1.Rows(CInt(e.RowIndex.ToString)).Cells(1).Text)
    '    oCmd.ExecuteNonQuery()
    '    oCmd.Dispose()
    
    '    oCmd = New SqlCommand("DELETE FROM form_data_impressions WHERE form_data_id=@form_data_id")
    '    oCmd.CommandType = CommandType.Text
    '    oCmd.Connection = oConn
    '    oCmd.Parameters.Add("@form_data_id", SqlDbType.Int).Value = CInt(GridView1.Rows(CInt(e.RowIndex.ToString)).Cells(1).Text)
    '    oCmd.ExecuteNonQuery()
    '    oCmd.Dispose()
    
    '    oConn.Close()
    
    '    Dim oFormManager As FormManager = New FormManager
    '    dv = New DataView(oFormManager.GetData(nPageId))
    
    '    If Not hidSortExpression.Value = "" Then
    '        If hidSortDirection.Value = "DESCENDING" Then
    '            dv.Sort = hidSortExpression.Value & " ASC"
    '        Else
    '            dv.Sort = hidSortExpression.Value & " DESC"
    '        End If
    '    End If
    
    '    GridView1.DataSource = dv
    '    GridView1.DataBind()
    
    '    oFormManager = Nothing
    'End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oCmd As SqlCommand
        oConn.Open()
    
        Dim Item As String
        For Each Item In hidDataToDel.Value.Split("|")
            oCmd = New SqlCommand("DELETE FROM form_data WHERE page_id=@page_id AND form_data_id=@form_data_id")
            oCmd.CommandType = CommandType.Text
            oCmd.Connection = oConn
            oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
            oCmd.Parameters.Add("@form_data_id", SqlDbType.Int).Value = CInt(Item)
            oCmd.ExecuteNonQuery()
            oCmd.Dispose()
    
            oCmd = New SqlCommand("DELETE FROM form_data_impressions WHERE form_data_id=@form_data_id")
            oCmd.CommandType = CommandType.Text
            oCmd.Connection = oConn
            oCmd.Parameters.Add("@form_data_id", SqlDbType.Int).Value = CInt(Item)
            oCmd.ExecuteNonQuery()
            oCmd.Dispose()
        Next

        oConn.Close()
    
        Dim oFormManager As FormManager = New FormManager
        dv = New DataView(oFormManager.GetData(nPageId))
    
        If Not hidSortExpression.Value = "" Then
            If hidSortDirection.Value = "DESCENDING" Then
                dv.Sort = hidSortExpression.Value & " ASC"
            Else
                dv.Sort = hidSortExpression.Value & " DESC"
            End If
        End If
    
        GridView1.DataSource = dv
        GridView1.DataBind()
    
        If GridView1.Rows.Count = 0 Then
            btnDelete.Visible = False
            btnDownloadCsv.Visible = False
            lblNoRecords.Visible = True
        Else
            lblNoRecords.Visible = False
        End If
    
        oFormManager = Nothing
    
        'NEW
        Dim i As Integer = 2
        Dim nItem As Integer
        Dim oCollRich As Collection = New Collection
    
        'Dim oCmd As SqlCommand
        Dim reader As SqlDataReader
        oConn.Open()
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        reader = oCmd.ExecuteReader
        While reader.Read
            If reader("input_type") = "html" Or reader("input_type") = "file" Then
                oCollRich.Add(i)
            End If
            i = i + 1
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()
        'HTML Format
        Dim oLabel As HtmlGenericControl
        For i = 0 To GridView1.Rows.Count - 1
            For Each nItem In oCollRich
                oLabel = New HtmlGenericControl
                oLabel.InnerHtml = Server.HtmlDecode(GridView1.Rows(i).Cells(nItem).Text)
                GridView1.Rows(i).Cells(nItem).Controls.Add(oLabel)
            Next
        Next
    End Sub

    '################# NEW #################

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_page") & "?mode=edit")
    End Sub

    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '   Form Fields Management
    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Protected Sub btnAddField_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oCmd As SqlCommand
        oConn.Open()
        Dim reader As SqlDataReader
  
        oCmd = New SqlCommand
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM form_field_definitions WHERE page_id=@page_id AND form_field_name=@form_field_name"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.Parameters.Add("@form_field_name", SqlDbType.NVarChar).Value = txtFieldName.Text
        reader = oCmd.ExecuteReader
        If reader.Read Then
            reader.Close()
            oCmd.Dispose()
            lblFieldExists.Visible = True
            lblFieldExists.Text = GetLocalResourceObject("FieldExists")
            Exit Sub
        End If
        reader.Close()
        oCmd.Dispose()
    
    
        oCmd = New SqlCommand
        oCmd.CommandType = CommandType.Text
        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO form_field_definitions (page_id,form_field_name,sorting,input_type,default_value,width,height,is_required) " & _
                        "values (@page_id,@form_field_name,@sorting,@input_type,@default_value,@width,@height,@is_required)"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.Parameters.Add("@form_field_name", SqlDbType.NVarChar).Value = txtFieldName.Text
        oCmd.Parameters.Add("@sorting", SqlDbType.Int).Value = IIf(txtSorting.Text = "", DBNull.Value, txtSorting.Text)
        oCmd.Parameters.Add("@input_type", SqlDbType.NVarChar).Value = ddlInputType.SelectedValue
        oCmd.Parameters.Add("@default_value", SqlDbType.NVarChar).Value = txtDefault.Text
        oCmd.Parameters.Add("@width", SqlDbType.Int).Value = IIf(txtWidth.Text = "", DBNull.Value, txtWidth.Text)
        oCmd.Parameters.Add("@height", SqlDbType.Int).Value = IIf(txtHeight.Text = "", DBNull.Value, txtHeight.Text)
        oCmd.Parameters.Add("@is_required", SqlDbType.Bit).Value = cbRequired.Checked
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()

        txtFieldName.Text = ""
        txtWidth.Text = ""
        txtHeight.Text = ""
        txtSorting.Text = ""
        txtDefault.Text = ""
        GridView2.DataBind()
    End Sub

    Protected Sub GridView2_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs)
        SqlDataSource1.UpdateParameters("input_type").DefaultValue = CType(GridView2.Rows(e.RowIndex).FindControl("ddlInputType2"), DropDownList).SelectedValue
        SqlDataSource1.UpdateParameters("page_id").DefaultValue = nPageId
    End Sub

    Protected Sub GridView2_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To GridView2.Rows.Count - 1
            Try
                CType(GridView2.Rows(i).Cells(8).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub

    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '   Field Values Management
    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Protected Sub btnAddValue_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oCmd As SqlCommand = New SqlCommand
        oCmd.CommandType = CommandType.Text
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO form_field_values (form_field_definition_id,display_value,is_default) " & _
                        "values (@form_field_definition_id,@display_value,@is_default)"
        oCmd.CommandType = CommandType.Text
        'MsgBox(SqlDataSource2.SelectParameters("form_field_definition_id").DefaultValue)
        oCmd.Parameters.Add("@form_field_definition_id", SqlDbType.Int).Value = SqlDataSource2.SelectParameters("form_field_definition_id").DefaultValue
        oCmd.Parameters.Add("@display_value", SqlDbType.NVarChar).Value = txtDisplayValue.Text
        oCmd.Parameters.Add("@is_default", SqlDbType.Bit).Value = cbIsDefault.Checked
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()

        txtDisplayValue.Text = ""
        cbIsDefault.Checked = False
        GridView3.DataBind()
    End Sub

    Protected Sub GridView3_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm2") & "')){return true;}else {return false;}"
        For i = 0 To GridView3.Rows.Count - 1
            Try
                CType(GridView3.Rows(i).Cells(3).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub

    Function ShowInputType(ByVal sInputType As String, ByVal nFormFieldDefId As Integer) As String
        Dim sValuesLink As String = " &nbsp;<a href=""" & HttpContext.Current.Items("_page") & "?pvid=" & nFormFieldDefId & """>" & GetLocalResourceObject("EditValues") & "</a>"
        Select Case sInputType
            Case "dropdown" : Return "DropDown" & sValuesLink
            Case "radio" : Return "Radio Button" & sValuesLink
            Case "listbox_multiple" : Return "ListBox (Multi Selection)" & sValuesLink
            Case "listbox_single" : Return "ListBox (Single Selection)" & sValuesLink
            Case "checklist" : Return "CheckBox List" & sValuesLink
            Case "checkbox" : Return "CheckBox"
            Case "short_text" : Return "TextBox"
            Case "long_text" : Return "TextArea"
            Case "html" : Return "WYSIWYG Editor"
            Case "number" : Return "TextBox (Number)"
            Case "money" : Return "TextBox (Money)"
            Case "date" : Return "Date Picker"
            Case "file" : Return "File Upload"
            Case Else : Return ""
        End Select
    End Function

    Protected Sub btnSaveSettings_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oCmd As SqlCommand
        oConn.Open()
    
        oCmd = New SqlCommand
        oCmd.Connection = oConn
            
        oCmd.CommandText = "UPDATE form_settings set header=@header, footer=@footer, thank_you_message=@thank_you_message, email=@email,return_to_form=@return_to_form WHERE page_id=@page_id"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = nPageId
        oCmd.Parameters.Add("@header", SqlDbType.NText).Value = txtFormHeader.Text
        oCmd.Parameters.Add("@footer", SqlDbType.NText).Value = txtFormFooter.Text
        oCmd.Parameters.Add("@thank_you_message", SqlDbType.NText).Value = txtThankYouMessage.Text
        oCmd.Parameters.Add("@return_to_form", SqlDbType.Bit).Value = chkReturnToForm.Checked
        oCmd.Parameters.Add("@email", SqlDbType.NText).Value = txtEmail.Text

        oCmd.ExecuteNonQuery()
    
        oCmd.Dispose()
        oConn.Close()
    
        Response.Redirect(HttpContext.Current.Items("_page") & "?mode=set")
    End Sub

    Protected Sub btnDownloadCsv_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
    
        Dim oFormManager As FormManager = New FormManager
        Dim dt As DataTable = oFormManager.GetData(nPageId)
        oFormManager = Nothing
    
        Dim dr As DataRow
        Dim sb As StringBuilder = New StringBuilder
        Dim i As Integer
        Dim nCount As Integer = dt.Columns.Count
        For i = 0 To nCount - 1
            sb.Append(dt.Columns(i))
            If i < nCount - 1 Then
                sb.Append(",")
            End If
        Next
        sb.AppendLine()
        For Each dr In dt.Rows
            For i = 0 To nCount - 1
                sb.Append(dr(i).ToString())
                If i < nCount - 1 Then
                    sb.Append(",")
                End If
            Next
            sb.AppendLine()
        Next

        Response.ContentType = "Application/x-msexcel"
        Response.AddHeader("content-disposition", "attachment;filename=""data.csv""")
        Response.Write(sb.ToString)
        Response.End()
    End Sub
</script>


<asp:Panel ID="panelLinks" runat="server">
    <table cellpadding="0" cellspacing="0" style="background-image:url('systems/images/bg_box.gif');border:#D4D6DD 3px solid;margin-top:15px;margin-bottom:15px;">
    <tr>
    <td style="padding:10px;padding-right:25px;padding-left:20px">
        <asp:HyperLink ID="lnkViewForm" meta:resourcekey="lnkViewForm" runat="server" Text="View Form"></asp:HyperLink>&nbsp;|&nbsp;
        <asp:HyperLink ID="lnkEditForm" meta:resourcekey="lnkEditForm" runat="server" Text="Edit Form"></asp:HyperLink>&nbsp;|&nbsp;
        <asp:HyperLink ID="lnkFormSettings" meta:resourcekey="lnkFormSettings" runat="server" Text="Settings"></asp:HyperLink>&nbsp;|&nbsp;
        <asp:HyperLink ID="lnkResults" meta:resourcekey="lnkResults" runat="server" Text="Results"></asp:HyperLink>
    </td>
    </tr>
    </table>
</asp:Panel>


<asp:Panel ID="panelResults" runat="server">
    <asp:GridView ID="GridView1" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="top" CellPadding="7" HeaderStyle-HorizontalAlign=Left AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8"
        AllowPaging="true" PageSize="8" runat="server" AllowSorting="true" 
        OnPageIndexChanging="GridView1_PageIndexChanging"
        OnSorting="GridView1_Sorting">
        <Columns>
        <asp:TemplateField ItemStyle-VerticalAlign=top HeaderText="">
        <ItemTemplate>
            <input name="chkSelect" type="checkbox" />
            <input name="hidSelect" type="hidden" value="<%#Eval("Id") %>" />           
        </ItemTemplate>
        </asp:TemplateField>
        </Columns>
        <%--<asp:CommandField ShowDeleteButton="true" DeleteText="Delete" />--%>
    </asp:GridView>
    <asp:HiddenField ID="hidSortExpression" runat="server" />
    <asp:HiddenField ID="hidSortDirection" runat="server" />
    
    <div style="margin:15px"></div>
    <asp:HiddenField ID="hidDataToDel" runat="server" />
    <asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text="Delete selected"  />&nbsp;
    <asp:Button ID="btnDownloadCsv" meta:resourcekey="btnDownloadCsv" runat="server" Text="Download CSV"  OnClick="btnDownloadCsv_Click" />
    
    &nbsp;&nbsp;<asp:Label ID="lblNoRecords" meta:resourcekey="lblNoRecords" Font-Bold="true" runat="server" Text="No Records." Visible="false"></asp:Label>
        
    <script language="javascript">
    function _getSelection(oEl)
        {
        var bReturn=false;
        var sTmp="";
        for(var i=0;i<document.getElementsByName("chkSelect").length;i++)
            {
            var oInput=document.getElementsByName("chkSelect")[i];        
            if(oInput.checked==true)
                {
                sTmp+= "|" + document.getElementsByName("hidSelect")[i].value;
                //alert(document.getElementsByName("hidSelect")[i].value)
                bReturn=true;
                }
            }
        oEl.value=sTmp.substring(1);
        return bReturn;
        }
    </script>
</asp:Panel>


<asp:Panel ID="panelViewForm" runat="server">

    <asp:Panel ID="panelThankYou" runat="server" Visible="false">
        <div style="margin:15px"></div>
        <asp:Label ID="lblThankYou" Font-Bold="true" runat="server"></asp:Label>
        <div style="margin:15px"></div>
        <asp:HyperLink ID="lnkReturnToForm" meta:resourcekey="lnkReturnToForm" Text="Return to form" runat="server"></asp:HyperLink>
    </asp:Panel>
    
    <script language="javascript" type="text/javascript">
    <!--
    var _daysInMonth=[31,28,31,30,31,30,31,31,30,31,30,31];
    function isLeapYear(year) { return ((year%4) == 0);}
    function validateDate(idDate, idMonth, idYear) 
        {
        var year = idYear.value;
        var month = idMonth.value;
        var day = idDate.value;

        var numDate=_daysInMonth[month-1];
        if (month==2 && isLeapYear(year)) numDate++;
        if (idDate.value>numDate) {idDate.value=numDate;}    
        }
    // -->
    </script>
    
    <asp:Panel ID="panelForm" runat="server"></asp:Panel>

    <asp:Panel ID="panelSubmit" runat="server">
        <div style="margin:20px"></div>
        <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Submit " OnClick="btnSubmit_Click" />
    </asp:Panel>

</asp:Panel>


<asp:Panel ID="panelEditForm" runat="server" visible="false">
    
    <asp:GridView ID="GridView2" runat="server"
        HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="top" CellPadding="7"  AutoGenerateColumns="False"
        HeaderStyle-HorizontalAlign="Left" AlternatingRowStyle-BackColor="#f6f7f8" DataSourceID="SqlDataSource1"  
        HeaderStyle-BackColor="#d6d7d8" AllowPaging="True" PageSize="12" AllowSorting="True" DataKeyNames="form_field_definition_id" OnRowUpdating="GridView2_RowUpdating" OnPreRender="GridView2_PreRender">
        <Columns>
        <asp:BoundField DataField="form_field_name" meta:resourcekey="colFieldName" ItemStyle-Wrap="false" HeaderText="Field Name" />
        <asp:TemplateField meta:resourcekey="colInputType" HeaderText="Input Type">
            <ItemTemplate>
                <div style="white-space:nowrap"><%#ShowInputType(Eval("input_type"),Eval("form_field_definition_id"))%></div>           
            </ItemTemplate>
            <EditItemTemplate>
                <asp:DropDownList ID="ddlInputType2" runat="server" selectedValue='<%#Bind("input_type")%>'>
                <asp:ListItem Text="TextBox" Value="short_text"></asp:ListItem>
                <asp:ListItem Text="TextArea" Value="long_text"></asp:ListItem>
                <asp:ListItem Text="ListBox (Single Selection)" Value="listbox_single"></asp:ListItem>
                <asp:ListItem Text="ListBox (Multi Selection)" Value="listbox_multiple"></asp:ListItem>
                <asp:ListItem Text="DropDown" Value="dropdown"></asp:ListItem>
                <asp:ListItem Text="Radio Button" Value="radio"></asp:ListItem>
                <asp:ListItem Text="CheckBox List" Value="checklist"></asp:ListItem>
                <asp:ListItem Text="CheckBox" Value="checkbox"></asp:ListItem>
                <asp:ListItem Text="WYSIWYG Editor" Value="html"></asp:ListItem>
                <asp:ListItem Text="TextBox (Money)" Value="money"></asp:ListItem>
                <asp:ListItem Text="TextBox (Number)" Value="number"></asp:ListItem>
                <asp:ListItem Text="Date Picker" Value="date"></asp:ListItem>
                <asp:ListItem Text="File Upload" Value="file"></asp:ListItem>           
                </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:BoundField meta:resourcekey="colWidth" DataField="width" ControlStyle-Width="40" HeaderText="Width"/>
        <asp:BoundField meta:resourcekey="colHeight" DataField="height" ControlStyle-Width="40" HeaderText="Height"/>
        <asp:BoundField meta:resourcekey="colDefaultValue" DataField="default_value" HeaderText="Default Value"/>
        <asp:BoundField meta:resourcekey="colSorting" DataField="sorting" ControlStyle-Width="40" HeaderText="Sorting" ItemStyle-HorizontalAlign="center"/>
        <asp:CheckBoxField meta:resourcekey="colIsRequired" DataField="is_required" HeaderText="Is Required" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false"/>
        <asp:CommandField meta:resourcekey="cmdEdit" ShowEditButton="True" ButtonType="Link" /> 
        <asp:CommandField meta:resourcekey="cmdDelete" ShowDeleteButton="True" ButtonType="Link" />
        </Columns>
        <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" VerticalAlign="Top" Wrap="False" />
        <AlternatingRowStyle BackColor="#F6F7F8" />
    </asp:GridView>
  
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
        <DeleteParameters>
            <asp:Parameter Name="form_field_definition_id" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:Parameter Name="page_id" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="form_field_name" Type="String" />
            <asp:Parameter Name="sorting" Type="Int32" />
            <asp:Parameter Name="input_type" Type="String" />
            <asp:Parameter Name="width" Type="Int32" />
            <asp:Parameter Name="height" Type="Int32" />
            <asp:Parameter Name="default_value" Type="String" />
            <asp:Parameter Name="page_id" Type="Int32" />
            <asp:Parameter Name="is_required" Type="Boolean" />
            <asp:Parameter Name="form_field_definition_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    
    <div style="margin:15px"></div>
    
    <table>
    <tr>
        <td><asp:Label ID="lblFieldName" meta:resourcekey="lblFieldName" runat="server" Text="Field Name"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtFieldName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rvf1" runat="server" ControlToValidate="txtFieldName" ErrorMessage="*" ValidationGroup="AddField"></asp:RequiredFieldValidator>
            <asp:Label ID="lblFieldExists" runat="server" Visible="false" ForeColor="red" Text=""></asp:Label>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblInputType" meta:resourcekey="lblInputType" runat="server" Text="Input Type"></asp:Label></td>
        <td>:</td>
        <td>
            <table>
            <tr>
            <td>
                <asp:DropDownList ID="ddlInputType" runat="server">
                <asp:ListItem Text="TextBox" Value="short_text"></asp:ListItem>
                <asp:ListItem Text="TextArea" Value="long_text"></asp:ListItem>
                <asp:ListItem Text="ListBox (Single Selection)" Value="listbox_single"></asp:ListItem>
                <asp:ListItem Text="ListBox (Multi Selection)" Value="listbox_multiple"></asp:ListItem>
                <asp:ListItem Text="DropDown" Value="dropdown"></asp:ListItem>
                <asp:ListItem Text="Radio Button" Value="radio"></asp:ListItem>
                <asp:ListItem Text="CheckBox List" Value="checklist"></asp:ListItem>
                <asp:ListItem Text="CheckBox" Value="checkbox"></asp:ListItem>
                <asp:ListItem Text="WYSIWYG Editor" Value="html"></asp:ListItem>
                <asp:ListItem Text="TextBox (Money)" Value="money"></asp:ListItem>
                <asp:ListItem Text="TextBox (Number)" Value="number"></asp:ListItem>
                <asp:ListItem Text="Date Picker" Value="date"></asp:ListItem>
                <asp:ListItem Text="File Upload" Value="file"></asp:ListItem>  
                </asp:DropDownList>
            </td>
            <td style="white-space:nowrap">                
                <table id="divWidth" runat="server" cellpadding="0" cellspacing="0">
                <tr>
                <td style="padding-left:3px"><asp:Label ID="lblWidth" meta:resourcekey="lblWidth" runat="server" Text="Width:"></asp:Label></td>
                <td style="padding-left:3px"><asp:TextBox ID="txtWidth" runat="server" Width="50px"></asp:TextBox></td>
                </tr>
                </table>
            </td>
            <td>
                <table id="divHeight" runat="server" cellpadding="0" cellspacing="0">
                <tr>
                <td style="padding-left:3px"><asp:Label ID="lblHeight" meta:resourcekey="lblHeight" runat="server" Text="Height:"></asp:Label></td>
                <td style="padding-left:3px"><asp:TextBox ID="txtHeight" runat="server" Width="50px"></asp:TextBox></td>
                </tr>
                </table>
            </td>
            </tr>
            </table>
        
            <script language="javascript" type="text/javascript">
            <!--
            var w;
            var h;
            function validateInputType(oI,ow,oh)
                {
                w=ow;
                h=oh;
                switch (oI.value)
                    {
                    case "short_text": hide("h");break;
                    case "long_text":hide("n");break;
                    case "listbox_single":hide("n");break;
                    case "listbox_multiple":hide("n");break;
                    case "html":hide("n");break;
                    case "money":hide("h");break;
                    case "number":hide("h");break;
                    default:hide("a");
                    }
                }
         
            function hide(s)
                {
                if (s=="n")
                    {
                    h.style.display="block";
                    w.style.display="block";
                    }
                else if (s=="a")
                    {
                    h.style.display="none";
                    w.style.display="none";
                    }
                else if (s=="h")
                    {
                    h.style.display="none";
                    w.style.display="block";
                    }  
                }             
            // -->
            </script>        
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblDefaultValue" meta:resourcekey="lblDefaultValue" runat="server" Text="Default Value"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtDefault" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblSorting" meta:resourcekey="lblSorting" runat="server" Text="Sorting"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtSorting" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv2" ControlToValidate="txtSorting" runat="server" ValidationGroup="AddField" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblIsRequired" meta:resourcekey="lblIsRequired" runat="server" Text="Is Required"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:CheckBox ID="cbRequired" runat="server" />
        </td>
    </tr>
    </table>
    <div style="margin:15px"></div>
    <asp:Button ID="btnAddField" meta:resourcekey="btnAddField" runat="server" Text=" Add Field " ValidationGroup="AddField" OnClick="btnAddField_Click" />
</asp:Panel>


<asp:Panel ID="panelValues" runat="server">
    <div style="margin:15px"></div>
    <asp:Label ID="lblTitle" Font-Bold="true" runat="server"></asp:Label>
    <div style="margin:15px"></div>
  
    <asp:GridView ID="GridView3" runat="server"
        HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="top" CellPadding="7"  AutoGenerateColumns="False"
        HeaderStyle-HorizontalAlign="Left" AlternatingRowStyle-BackColor="#f6f7f8" DataSourceID="SqlDataSource2" DataKeyNames="form_field_value_id"  
        HeaderStyle-BackColor="#d6d7d8" AllowPaging="True" PageSize="8" AllowSorting="True" 
        OnPreRender="GridView3_PreRender">
        <Columns>
            <asp:BoundField DataField="display_value" meta:resourcekey="colDisplayValue" HeaderStyle-Wrap="False"  HeaderText="Value"/>
            <asp:CheckBoxField DataField="is_default" meta:resourcekey="colIsDefault" HeaderStyle-Wrap="False"  HeaderText="Is Default"></asp:CheckBoxField>
            <asp:CommandField meta:resourcekey="colValueEdit" ShowEditButton="True" /> 
            <asp:CommandField meta:resourcekey="colValueDelete" ShowDeleteButton="True" /> 
        </Columns>
        <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" VerticalAlign="Top" Wrap="False" />
        <AlternatingRowStyle BackColor="#F6F7F8" />
    </asp:GridView>

    <div style="margin:15px"></div>
    
    <table>
    <tr>
        <td><asp:Label ID="lblDisplayValue" meta:resourcekey="lblDisplayValue" runat="server" Text="Value"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:TextBox ID="txtDisplayValue" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv3" ControlToValidate="txtDisplayValue" runat="server" ValidationGroup="AddValue" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="lblIsDefault" meta:resourcekey="lblIsDefault" runat="server" Text="Is Default"></asp:Label></td>
        <td>:</td>
        <td>
            <asp:CheckBox ID="cbIsDefault" runat="server" />
        </td>
    </tr>
    </table>    
    <div style="margin:15px"></div>  
    <asp:Button ID="btnAddValue" meta:resourcekey="btnAddValue" runat="server" Text=" Add Value " ValidationGroup="AddValue" OnClick="btnAddValue_Click" />
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text=" Back " OnClick="btnBack_Click" />
  
  
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>">
        <SelectParameters>
            <asp:Parameter Name="form_field_definition_id" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="display_value" Type="String" />
            <asp:Parameter Name="is_default" Type="Boolean" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="form_field_definition_id" Type="Int32" />
            <asp:Parameter Name="display_value" Type="String" />
            <asp:Parameter Name="is_default" Type="Boolean" />
        </InsertParameters>
    </asp:SqlDataSource>
</asp:Panel>


<asp:Panel ID="panelFormSettings" runat="server">
    <table cellpadding="0" cellspacing="0">
    <tr>
        <td style="padding-top:7px;" valign="top"><asp:Label ID="lblFormHeader" meta:resourcekey="lblFormHeader" runat="server" Text="Form Header"></asp:Label></td>
        <td style="padding:5px;padding-top:7px;" valign="top">:&nbsp;</td>
        <td style="padding-top:5px">
            <asp:TextBox ID="txtFormHeader" TextMode="multiLine" width="250" Height="50" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="padding-top:7px;" valign="top"><asp:Label ID="lblFormFooter" meta:resourcekey="lblFormFooter" runat="server" Text="Form Footer"></asp:Label></td>
        <td style="padding:5px;padding-top:7px;" valign="top">: </td>
        <td style="padding-top:5px">
            <asp:TextBox ID="txtFormFooter" TextMode="multiLine" width="250" Height="50" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="padding-top:7px;" valign="top"><asp:Label ID="lblThankYouMessage" meta:resourcekey="lblThankYouMessage" runat="server" Text="Thank You Message"></asp:Label></td>
        <td style="padding:5px;padding-top:7px;" valign="top">: </td>
        <td style="padding-top:5px">
            <asp:TextBox ID="txtThankYouMessage" TextMode="multiLine" width="250" Height="50" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="padding-top:7px;" valign="top"><asp:Label ID="lblEmail" meta:resourcekey="lblEmail" runat="server" Text="Email:"></asp:Label></td>
        <td style="padding:5px;padding-top:7px;" valign="top">: </td>
        <td style="padding-top:5px">
            <asp:TextBox ID="txtEmail" width="250" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td style="padding-top:7px;" valign="top"><asp:Label ID="lblReturnToForm" meta:resourcekey="lblReturnToForm" runat="server" Text="Return to Form"></asp:Label></td>
        <td style="padding:5px;padding-top:7px;" valign="top">:&nbsp;</td>
        <td style="padding-top:5px">
            <asp:CheckBox ID="chkReturnToForm" runat="server" />
        </td>
    </tr>
    </table>
    <div style="margin:15px"></div>
    <asp:Button ID="btnSaveSettings" meta:resourcekey="btnSaveSettings" runat="server" Text=" Save " OnClick="btnSaveSettings_Click" />
</asp:Panel>
<%--<asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
--%>