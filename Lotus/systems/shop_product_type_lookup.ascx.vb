Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security.Membership
Imports System.Web.Security.roles
Imports System.Collections.Generic


Partial Class systems_product_type_lookup
    Inherits BaseUserControl

    Private sConn As String
    Private oConn As SqlConnection
    Private propId As String

    Public Sub New()
        sConn = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    End Sub

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
        oConn = Nothing
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNothing(GetUser) Then
            pnlProdType.Visible = False
            panelLogin.Visible = True
            panelLogin.FindControl("Login1").Focus()
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Then
                propId = Request.QueryString("propid")

                pnlProdType.Visible = True
                panelLogin.Visible = False

                If Not IsPostBack Then

                    pnlCreate.Visible = False
                    pnlLookup.Visible = False
                    pnlProdType.Visible = False

                    If propId <> "" Then
                        Dim mode As String = Request.QueryString("mode")
                        If mode = "new" Then
                            'show create form
                            pnlCreate.Visible = True
                            LoadCreateForm(propId)
                            btnUpdate.Visible = False
                            btnSubmit.Visible = True
                        ElseIf mode = "edit" Then
                            'show edit form
                            pnlCreate.Visible = True
                            LoadEditForm(propId, Request.QueryString("code"))
                            btnUpdate.Visible = True
                            btnSubmit.Visible = False
                        ElseIf mode = "del" Then
                            'delete the record
                            DeletePropertyValue(propId, Request.QueryString("code"))
                            Response.Redirect(GetCurrentPage() & "?propid=" & propId)
                        ElseIf mode = "list" Then
                            pnlProdType.Visible = True

                            oConn = New SqlConnection(sConn)
                            oConn.Open()
                            Dim reader As SqlDataReader

                            Dim nProdTypeId As Integer = 0
                            Dim sql As String = "Select product_type_id from product_property_definition where product_property_id=@product_property_id"
                            Dim oCommand As New SqlCommand(sql)
                            oCommand.CommandType = CommandType.Text
                            oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = propId
                            oCommand.Connection = oConn
                            reader = oCommand.ExecuteReader()
                            If reader.Read Then
                                nProdTypeId = reader("product_type_id")
                            End If
                            reader.Close()

                            sql = "Select * from product_property_definition where product_type_id=@product_type_id and input_type=@input_type order by sorting "
                            oCommand = New SqlCommand(sql)
                            oCommand.CommandType = CommandType.Text
                            oCommand.Parameters.Add("@product_type_id", SqlDbType.Int).Value = nProdTypeId
                            oCommand.Parameters.Add("@input_type", SqlDbType.NVarChar, 50).Value = "Selection"
                            oCommand.Connection = oConn
                            reader = oCommand.ExecuteReader()

                            grdTypeProp.DataSource = reader
                            grdTypeProp.DataBind()
                            reader.Close()

                            sql = "Select * from product_types order by description "
                            oCommand = New SqlCommand(sql)
                            oCommand.CommandType = CommandType.Text
                            oCommand.Connection = oConn
                            reader = oCommand.ExecuteReader()

                            ddProdType.Items.Clear()
                            ddProdType.Items.Add(New ListItem("", ""))
                            While reader.Read
                                ddProdType.Items.Add(New ListItem(reader("description").ToString, reader("product_type_id").ToString))
                            End While
                            reader.Close()
                            ddProdType.SelectedValue = nProdTypeId

                            oConn.Close()
                        Else
                            pnlLookup.Visible = True
                            lnkNew.NavigateUrl = "~/" & GetCurrentPage() & "?propId=" & propId & "&mode=new"
                            LoadLookup(propId)
                        End If
                    Else
                        'load page type
                        pnlProdType.Visible = True
                        LoadProductType()
                    End If
                End If
            End If
        End If
    End Sub

    Protected Function NVL(ByVal obj As Object, ByVal repVal As String) As String
        If (IsDBNull(obj)) Then Return repVal
        Return obj.ToString
    End Function

    Protected Function GetCurrentPage() As String
        Return HttpContext.Current.Items("_page")
    End Function

    Private Sub LoadCreateForm(ByVal propId As Integer)
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from product_property_definition where product_property_id=@product_property_id"
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = propId
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        'construct form
        If reader.Read Then
            litDispVal.Text = reader("product_property_name")

            Dim vl As String = NVL(reader("value1_name"), "")
            Dim ft As String = NVL(reader("value1_input_type"), "")
            If vl <> "" Then
                litVal1.Text = vl
                If ft = "Long Text" Then
                    txtVal1.TextMode = TextBoxMode.MultiLine
                    txtVal1.Columns = 40
                    txtVal1.Rows = 6
                End If
            Else
                tabCreate.FindControl("trVal1").Visible = False
            End If

            vl = NVL(reader("value2_name"), "")
            ft = NVL(reader("value2_input_type"), "")
            If vl <> "" Then
                litVal2.Text = vl
                If ft = "Long Text" Then
                    txtVal2.TextMode = TextBoxMode.MultiLine
                    txtVal2.Columns = 40
                    txtVal2.Rows = 6
                End If
            Else
                tabCreate.FindControl("trVal2").Visible = False
            End If

            vl = NVL(reader("value3_name"), "")
            ft = NVL(reader("value3_input_type"), "")
            If vl <> "" Then
                litVal3.Text = vl
                If ft = "Long Text" Then
                    txtVal3.TextMode = TextBoxMode.MultiLine
                    txtVal3.Columns = 40
                    txtVal3.Rows = 6
                End If
            Else
                tabCreate.FindControl("trVal3").Visible = False
            End If
        End If

        'set property id
        hdPropId.Value = propId

        reader.Close()
        oConn.Close()
    End Sub

    Private Sub LoadEditForm(ByVal propId As Integer, ByVal code As String)
        LoadCreateForm(propId)

        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from product_property_values where product_property_id=@product_property_id and code=@code "
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = propId
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = code
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        If reader.Read Then
            hdPropId.Value = propId
            txtCode.Text = reader("code").ToString
            hidCode.Value = reader("code").ToString
            txtDispVal.Text = reader("display_value").ToString
            txtVal1.Text = NVL(reader("value1"), "")
            txtVal2.Text = NVL(reader("value2"), "")
            txtVal3.Text = NVL(reader("value3"), "")
            chkIsDefault.Checked = Convert.ToBoolean(NVL(reader("is_default"), "0"))
        End If

        reader.Close()
        oConn.Close()
    End Sub

    Private Sub LoadLookup(ByVal propId As Integer)
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from product_property_definition where product_property_id=@product_property_id"
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = propId
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        'create grid header
        If reader.Read Then
            grdLookups.Columns(1).HeaderText = reader("product_property_name")

            lblPropertyName.Text = reader("product_property_name")

            Dim vl As String = NVL(reader("value1_name"), "")
            If vl <> "" Then
                grdLookups.Columns(2).HeaderText = vl
            Else
                grdLookups.Columns(2).Visible = False
            End If

            vl = NVL(reader("value2_name"), "")
            If vl <> "" Then
                grdLookups.Columns(3).HeaderText = vl
            Else
                grdLookups.Columns(3).Visible = False
            End If

            vl = NVL(reader("value3_name"), "")
            If vl <> "" Then
                grdLookups.Columns(4).HeaderText = vl
            Else
                grdLookups.Columns(4).Visible = False
            End If
        End If

        'load the data
        reader.Close()

        sql = "Select * from product_property_values where product_property_id=@product_property_id"
        Dim ds As New SqlDataSource
        ds.SelectCommand = sql
        ds.SelectCommandType = SqlDataSourceCommandType.Text
        ds.SelectParameters.Add("product_property_id", SqlDbType.Int)
        ds.SelectParameters("product_property_id").DefaultValue = propId
        ds.ConnectionString = sConn
        grdLookups.DataSource = ds
        grdLookups.DataBind()

        oConn.Close()

    End Sub

    Private Sub LoadProductType()
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from product_types order by description "
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        ddProdType.Items.Clear()
        ddProdType.Items.Add(New ListItem("", ""))
        While reader.Read
            ddProdType.Items.Add(New ListItem(reader("description").ToString, reader("product_type_id").ToString))
        End While

        reader.Close()
        oConn.Close()
    End Sub

    Private Sub DeletePropertyValue(ByVal propId As Integer, ByVal code As String)
        If Not Me.IsUserLoggedIn Then Exit Sub

        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Delete from product_property_values where product_property_id=@product_property_id and code=@code "
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = propId
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = code
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        grdTypeProp.DataSource = reader
        grdTypeProp.DataBind()

        reader.Close()
        oConn.Close()
    End Sub

    Protected Sub ddProdType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddProdType.SelectedIndexChanged
        'load all the custom fields for the page type.

        If ddProdType.SelectedValue = "" Then
            Return
        End If

        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Select * from product_property_definition where product_type_id=@product_type_id and input_type=@input_type order by sorting "
        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_type_id", SqlDbType.Int).Value = Convert.ToInt32(ddProdType.SelectedValue)
        oCommand.Parameters.Add("@input_type", SqlDbType.NVarChar, 50).Value = "Selection"
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()

        grdTypeProp.DataSource = reader
        grdTypeProp.DataBind()

        reader.Close()
        oConn.Close()
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        'save the lookup
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "Insert into product_property_values (product_property_id, code, display_value, value1, value2, value3, is_default) " & _
            "values(@product_property_id, @code, @display_value, @value1, @value2, @value3, @is_default) "

        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = Convert.ToInt32(hdPropId.Value)
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = txtCode.Text
        oCommand.Parameters.Add("@display_value", SqlDbType.NVarChar, 50).Value = txtDispVal.Text
        oCommand.Parameters.Add("@value1", SqlDbType.NText).Value = txtVal1.Text
        oCommand.Parameters.Add("@value2", SqlDbType.NText).Value = txtVal2.Text
        oCommand.Parameters.Add("@value3", SqlDbType.NText).Value = txtVal3.Text
        oCommand.Parameters.Add("@is_default", SqlDbType.Bit).Value = chkIsDefault.Checked
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()
        reader.Close()

        'set default value
        If chkIsDefault.Checked Then
            sql = "update product_property_values set is_default=0 where product_property_id=@product_property_id and code<>@code"
            oCommand = New SqlCommand(sql)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = Convert.ToInt32(hdPropId.Value)
            oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = txtCode.Text
            oCommand.Connection = oConn
            oCommand.ExecuteReader()
        End If

        oConn.Close()

        Response.Redirect(GetCurrentPage() & "?propid=" & Convert.ToInt32(hdPropId.Value))
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Not Me.IsUserLoggedIn Then Exit Sub

        'save the lookup
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim sql As String = "update product_property_values set code=@code,display_value=@display_value, value1=@value1, value2=@value2, value3=@value3, is_default=@is_default where product_property_id=@product_property_id and code=@original_code "

        Dim oCommand As New SqlCommand(sql)
        oCommand.CommandType = CommandType.Text
        oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = Convert.ToInt32(hdPropId.Value)
        oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = txtCode.Text
        oCommand.Parameters.Add("@original_code", SqlDbType.NVarChar, 255).Value = hidCode.Value
        oCommand.Parameters.Add("@display_value", SqlDbType.NVarChar, 50).Value = txtDispVal.Text
        oCommand.Parameters.Add("@value1", SqlDbType.NText).Value = txtVal1.Text
        oCommand.Parameters.Add("@value2", SqlDbType.NText).Value = txtVal2.Text
        oCommand.Parameters.Add("@value3", SqlDbType.NText).Value = txtVal3.Text
        oCommand.Parameters.Add("@is_default", SqlDbType.Bit).Value = chkIsDefault.Checked
        oCommand.Connection = oConn
        Dim reader As SqlDataReader = oCommand.ExecuteReader()
        reader.Close()

        'set default value
        If chkIsDefault.Checked Then
            sql = "update product_property_values set is_default=0 where product_property_id=@product_property_id and code<>@code"
            oCommand = New SqlCommand(sql)
            oCommand.CommandType = CommandType.Text
            oCommand.Parameters.Add("@product_property_id", SqlDbType.Int).Value = Convert.ToInt32(hdPropId.Value)
            oCommand.Parameters.Add("@code", SqlDbType.NVarChar, 255).Value = txtCode.Text
            oCommand.Connection = oConn
            oCommand.ExecuteReader()
        End If

        oConn.Close()

        Response.Redirect(GetCurrentPage() & "?propid=" & Convert.ToInt32(hdPropId.Value))
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(GetCurrentPage() & "?propId=" & hdPropId.Value)
    End Sub

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(Me.LinkShopProductTypeLookup & "?propId=" & Request.QueryString("propId") & "&mode=list")
    End Sub

    Protected Sub grdLookups_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grdLookups.PageIndexChanging
        pnlProdType.Visible = False
        pnlLookup.Visible = True
        lnkNew.NavigateUrl = "~/" & GetCurrentPage() & "?propId=" & propId & "&mode=new"
        grdLookups.PageIndex = e.NewPageIndex
        LoadLookup(propId)
    End Sub
End Class
