<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.sqlClient"%>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        panelLogin.Visible = True
        panelShipments.Visible = False
        panelNewShipment.Visible = False
        If Not (IsNothing(GetUser())) Then
            If Roles.IsUserInRole(GetUser.UserName, "Administrators") Then
                panelLogin.Visible = False
                panelShipments.Visible = True
                panelNewShipment.Visible = True

                SqlDataSource1.ConnectionString = sConn
                SqlDataSource1.SelectCommand = "SELECT shipping_cost.* FROM shipping_cost"
                SqlDataSource1.DeleteCommand = "DELETE FROM [shipping_cost] WHERE [ship_cost_id] = @ship_cost_id"
                
                gvShipments.DataBind()

                'Add state for selected country
                ddCountry_SelectedIndexChanged(sender, Nothing)
            End If
        End If

        'add atribute
        txtFlatAmount.Attributes.Add("onchange", "clearPair(document.getElementById('" & txtPercentage.ClientID & "'));")
        txtPercentage.Attributes.Add("onchange", "clearPair(document.getElementById('" & txtFlatAmount.ClientID & "'));")

        txtMinWeight.Text = FormatNumber(0, 2)
        txtTotal.Text = FormatNumber(0, 2)
        txtMaxWeight.Text = FormatNumber(99999.99, 2)
        txtTotal2.Text = FormatNumber(99999.99, 2)
    End Sub

    Function showCalculation(ByVal flat As String, ByVal perc As String) As String
        Dim sCalculation As String = ""
        If flat = "" Then
            sCalculation = "Percentage (" & perc & "%)"
        Else
            sCalculation = "Flat Amount (" & Me.CurrencySymbol & FormatNumber(flat, 2) & ")"
        End If
        Return sCalculation
    End Function

    Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
        Response.Redirect(HttpContext.Current.Items("_path"))
    End Sub

    Protected Sub Login1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Login1.PasswordRecoveryUrl = "~/" & Me.LinkPassword & "?ReturnUrl=" & HttpContext.Current.Items("_path")
    End Sub

    Protected Sub gvShipments_PreRender(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer
        Dim sScript As String = "if(confirm('" & GetLocalResourceObject("DeleteConfirm") & "')){return true;}else {return false;}"
        For i = 0 To gvShipments.Rows.Count - 1
            Try
                CType(gvShipments.Rows(i).Cells(5).Controls(0), LinkButton).Attributes.Add("onclick", sScript)
            Catch ex As Exception
            End Try
        Next
    End Sub

    Protected Sub gvShipments_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        gvShipments.DataBind()
    End Sub
    
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Not Me.IsUserLoggedIn Then Exit Sub
        Dim oCmd As SqlCommand = New SqlCommand
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "INSERT INTO shipping_cost (description, weight_from,weight_to,total_from,total_to,location,ship_cost,percentage_cost) " & _
                           "values (@description,@weight_from,@weight_to,@total_from,@total_to,@location,@ship_cost,@percentage_cost)"

        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@description", SqlDbType.NVarChar).Value = txtDescription.Text
        oCmd.Parameters.Add("@weight_from", SqlDbType.Decimal).Value = txtMinWeight.Text
        oCmd.Parameters.Add("@weight_to", SqlDbType.Decimal).Value = txtMaxWeight.Text
        oCmd.Parameters.Add("@total_from", SqlDbType.Decimal).Value = txtTotal.Text
        oCmd.Parameters.Add("@total_to", SqlDbType.Decimal).Value = txtTotal2.Text
        oCmd.Parameters.Add("@location", SqlDbType.NVarChar).Value = ddCountry.SelectedValue & IIf(ddState.SelectedValue = "", "", " " & ddState.SelectedValue)
        oCmd.Parameters.Add("@ship_cost", SqlDbType.Money)
        oCmd.Parameters.Add("@percentage_cost", SqlDbType.Decimal)

        If txtFlatAmount.Text = "" Then
            oCmd.Parameters("@ship_cost").Value = DBNull.Value
            oCmd.Parameters("@percentage_cost").Value = txtPercentage.Text
        Else
            oCmd.Parameters("@ship_cost").Value = txtFlatAmount.Text
            oCmd.Parameters("@percentage_cost").Value = DBNull.Value
        End If
        oCmd.ExecuteNonQuery()
        oCmd.Dispose()
        oConn.Close()
        gvShipments.DataBind()
        txtDescription.Text = ""
        txtPercentage.Text = ""
        txtFlatAmount.Text = ""
    End Sub

    Protected Sub ddCountry_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim oCmd As SqlCommand = New SqlCommand
        Dim reader As SqlDataReader
        Dim oListItem As ListItem
        Dim nCount As Integer = 0
        ddState.Items.Clear()
        oListItem = New ListItem
        oListItem.Text = "All"
        oListItem.Value = ""
        ddState.Items.Insert(nCount, oListItem)

        oConn.Open()
        oCmd.Connection = oConn
        oCmd.CommandText = "SELECT * FROM [country_state_lookup] where [country]=@country"
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@country", SqlDbType.NVarChar).Value = ddCountry.SelectedValue
        reader = oCmd.ExecuteReader
        While reader.Read
            nCount += 1
            oListItem = New ListItem
            oListItem.Text = reader("state")
            oListItem.Value = reader("state_code")
            ddState.Items.Insert(nCount, oListItem)
        End While
        reader.Close()
        oCmd.Dispose()
        oConn.Close()
    End Sub

</script>

<asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server"  PasswordRecoveryText="Password Recovery" TitleText="" OnLoggedIn="Login1_LoggedIn" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
</asp:Panel> 

<asp:Panel ID="panelShipments" runat="server">
    <asp:GridView ID="gvShipments" runat="server" AllowSorting="true"
        AlternatingRowStyle-BackColor="#f6f7f8" HeaderStyle-BackColor="#d6d7d8" 
        CellPadding="7" HeaderStyle-HorizontalAlign="Left"
        GridLines="None" AutoGenerateColumns="False" AllowPaging="True" 
        DataKeyNames="ship_cost_id" DataSourceID="SqlDataSource1" 
        OnPreRender="gvShipments_PreRender">
        <Columns>
        <asp:BoundField DataField="description" meta:resourcekey="lblDescription" HeaderText="Description:" />
        
        <asp:TemplateField HeaderStyle-HorizontalAlign="right" ItemStyle-HorizontalAlign="right" meta:resourcekey="lblWeight" HeaderText="Weight:">
        <ItemTemplate>
        <%#FormatNumber(Eval("weight_from"), 2) & "-" & FormatNumber(Eval("weight_to"), 2)%>
        </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField HeaderStyle-HorizontalAlign="right" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" meta:resourcekey="lblTotal" HeaderText="Total:">
        <ItemTemplate>
        <%#FormatNumber(Eval("total_from"),2) & "-" & FormatNumber(Eval("total_to"), 2)%>
        </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField HeaderStyle-Wrap="false" meta:resourcekey="lblLocation" HeaderText="Location:">
        <ItemTemplate>
        <%#Eval("location")%>
        </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField HeaderStyle-Wrap="false" meta:resourcekey="lblCalculation" HeaderText="Shipping:">
        <ItemTemplate>
        <%#showCalculation(Eval("ship_cost", ""), Eval("percentage_cost", ""))%>
        </ItemTemplate>
        </asp:TemplateField>
                       
        <asp:CommandField DeleteText="Delete" meta:resourcekey="lblDelete" ShowDeleteButton="True" />
        </Columns>
        <HeaderStyle BackColor="#D6D7D8" HorizontalAlign="Left" />
        <AlternatingRowStyle BackColor="#F6F7F8" />
    </asp:GridView>
    <div style="margin:15px"></div>
</asp:Panel>

<asp:Panel ID="panelNewShipment" runat="server">
<table width="550px">
<tr>
<td>
    <asp:Label ID="lblDescription" meta:resourcekey="lblDescription2" runat="server" Text="Description"></asp:Label>
</td>
<td>:</td>
<td>
    <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
</td>    
</tr>
<tr>
<td>
    <asp:Label ID="lblWeight" meta:resourcekey="lblWeight2" runat="server" Text="Weight"></asp:Label>
</td>
<td>:</td>
<td>
 <asp:TextBox ID="txtMinWeight" Width="30" runat="server" Text="0" ></asp:TextBox> 
 &nbsp;&nbsp;<%=GetLocalResourceObject("to")%>&nbsp;&nbsp;
 <asp:TextBox ID="txtMaxWeight" Width="60" runat="server" Text="99999.99" ></asp:TextBox> 

 <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*"  ValidationGroup="shipment" ClientValidationFunction="WeightValidation"></asp:CustomValidator>
 <script language="javascript" type="text/javascript"><!--
    function WeightValidation (source, arguments)
      {
      w1 = document.getElementById("<%=txtMinWeight.ClientId %>");
      w2=document.getElementById("<%=txtMaxWeight.ClientId %>");
      arguments.IsValid=!((w1.value=="") || (w2.value==""));
      }
  //--></script>
</td>    
</tr>
<tr>
<td>
    <asp:Label ID="lblTotal2" meta:resourcekey="lblTotal" runat="server" Text="Total"></asp:Label>
    (<%=Me.CurrencySymbol%>)
</td>
<td>:</td>
<td>
 <asp:TextBox ID="txtTotal" Width="30" runat="server" Text="0" ></asp:TextBox> 
 &nbsp;&nbsp;<%=GetLocalResourceObject("to")%>&nbsp;&nbsp;
 <asp:TextBox ID="txtTotal2" Width="60" runat="server" Text="99999.99" ></asp:TextBox> 
 
 <asp:CustomValidator ID="TotalValidation" runat="server" ErrorMessage="*"  ValidationGroup="shipment" ClientValidationFunction="TotalValidation"></asp:CustomValidator>
 <script language="javascript" type="text/javascript"><!--
    function TotalValidation (source, arguments)
      {
      t1 = document.getElementById("<%=txtTotal.ClientId %>");
      t2=document.getElementById("<%=txtTotal2.ClientId %>");
      arguments.IsValid=!((t1.value=="") || (t2.value==""));
      }
  //--></script>
    
</td>    
</tr>
<tr>
  <td><%=GetLocalResourceObject("Country")%></td><td>:</td>
  <td>
      <asp:DropDownList id="ddCountry" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddCountry_SelectedIndexChanged">
            <asp:ListItem value=""></asp:ListItem>
            <asp:ListItem value="AF">Afghanistan</asp:ListItem>
            <asp:ListItem value="AL">Albania</asp:ListItem>
            <asp:ListItem value="DZ">Algeria</asp:ListItem>
            <asp:ListItem value="AS">American Samoa</asp:ListItem>
            <asp:ListItem value="AD">Andorra</asp:ListItem>
            <asp:ListItem value="AO">Angola</asp:ListItem>
            <asp:ListItem value="AI">Anguilla</asp:ListItem>
            <asp:ListItem value="AQ">Antarctica</asp:ListItem>
            <asp:ListItem value="AG">Antigua and Barbuda</asp:ListItem>
            <asp:ListItem value="AR">Argentina</asp:ListItem>
            <asp:ListItem value="AM">Armenia</asp:ListItem>
            <asp:ListItem value="AW">Aruba</asp:ListItem>
            <asp:ListItem value="AC">Ascension Island</asp:ListItem>
            <asp:ListItem value="AU">Australia</asp:ListItem>
            <asp:ListItem value="AT">Austria</asp:ListItem>
            <asp:ListItem value="AZ">Azerbaijan</asp:ListItem>
            <asp:ListItem value="BS">Bahamas</asp:ListItem>
            <asp:ListItem value="BH">Bahrain</asp:ListItem>
            <asp:ListItem value="BD">Bangladesh</asp:ListItem>
            <asp:ListItem value="BB">Barbados</asp:ListItem>
            <asp:ListItem value="BY">Belarus</asp:ListItem>
            <asp:ListItem value="BE">Belgium</asp:ListItem>
            <asp:ListItem value="BZ">Belize</asp:ListItem>
            <asp:ListItem value="BJ">Benin</asp:ListItem>
            <asp:ListItem value="BM">Bermuda</asp:ListItem>
            <asp:ListItem value="BT">Bhutan</asp:ListItem>
            <asp:ListItem value="BO">Bolivia</asp:ListItem>
            <asp:ListItem value="BA">Bosnia and Herzegovina</asp:ListItem>
            <asp:ListItem value="BW">Botswana</asp:ListItem>
            <asp:ListItem value="BV">Bouvet Island</asp:ListItem>
            <asp:ListItem value="BR">Brazil</asp:ListItem>
            <asp:ListItem value="IO">British Indian Ocean Territory</asp:ListItem>
            <asp:ListItem value="BN">Brunei</asp:ListItem>
            <asp:ListItem value="BG">Bulgaria</asp:ListItem>
            <asp:ListItem value="BF">Burkina Faso</asp:ListItem>
            <asp:ListItem value="BI">Burundi</asp:ListItem>
            <asp:ListItem value="KH">Cambodia</asp:ListItem>
            <asp:ListItem value="CM">Cameroon</asp:ListItem>
            <asp:ListItem value="CA">Canada</asp:ListItem>
            <asp:ListItem value="CV">Cape Verde</asp:ListItem>
            <asp:ListItem value="KY">Cayman Islands</asp:ListItem>
            <asp:ListItem value="CF">Central African Republic</asp:ListItem>
            <asp:ListItem value="TD">Chad</asp:ListItem>
            <asp:ListItem value="CL">Chile</asp:ListItem>
            <asp:ListItem value="CN">China</asp:ListItem>
            <asp:ListItem value="CX">Christmas Island</asp:ListItem>
            <asp:ListItem value="CC">Cocos (Keeling) Islands</asp:ListItem>
            <asp:ListItem value="CO">Colombia</asp:ListItem>
            <asp:ListItem value="KM">Comoros</asp:ListItem>
            <asp:ListItem value="CD">Congo (DRC)</asp:ListItem>
            <asp:ListItem value="CG">Congo</asp:ListItem>
            <asp:ListItem value="CK">Cook Islands</asp:ListItem>
            <asp:ListItem value="CR">Costa Rica</asp:ListItem>
            <asp:ListItem value="CI">Côte d'Ivoire</asp:ListItem>
            <asp:ListItem value="HR">Croatia</asp:ListItem>
            <asp:ListItem value="CU">Cuba</asp:ListItem>
            <asp:ListItem value="CY">Cyprus</asp:ListItem>
            <asp:ListItem value="CZ">Czech Republic</asp:ListItem>
            <asp:ListItem value="DK">Denmark</asp:ListItem>
            <asp:ListItem value="DJ">Djibouti</asp:ListItem>
            <asp:ListItem value="DM">Dominica</asp:ListItem>
            <asp:ListItem value="DO">Dominican Republic</asp:ListItem>
            <asp:ListItem value="EC">Ecuador</asp:ListItem>
            <asp:ListItem value="EG">Egypt</asp:ListItem>
            <asp:ListItem value="SV">El Salvador</asp:ListItem>
            <asp:ListItem value="GQ">Equatorial Guinea</asp:ListItem>
            <asp:ListItem value="ER">Eritrea</asp:ListItem>
            <asp:ListItem value="EE">Estonia</asp:ListItem>
            <asp:ListItem value="ET">Ethiopia</asp:ListItem>
            <asp:ListItem value="FK">Falkland Islands (Islas Malvinas)</asp:ListItem>
            <asp:ListItem value="FO">Faroe Islands</asp:ListItem>
            <asp:ListItem value="FJ">Fiji Islands</asp:ListItem>
            <asp:ListItem value="FI">Finland</asp:ListItem>
            <asp:ListItem value="FR">France</asp:ListItem>
            <asp:ListItem value="GF">French Guiana</asp:ListItem>
            <asp:ListItem value="PF">French Polynesia</asp:ListItem>
            <asp:ListItem value="TF">French Southern and Antarctic Lands</asp:ListItem>
            <asp:ListItem value="GA">Gabon</asp:ListItem>
            <asp:ListItem value="GM">Gambia, The</asp:ListItem>
            <asp:ListItem value="GE">Georgia</asp:ListItem>
            <asp:ListItem value="DE">Germany</asp:ListItem>
            <asp:ListItem value="GH">Ghana</asp:ListItem>
            <asp:ListItem value="GI">Gibraltar</asp:ListItem>
            <asp:ListItem value="GR">Greece</asp:ListItem>
            <asp:ListItem value="GL">Greenland</asp:ListItem>
            <asp:ListItem value="GD">Grenada</asp:ListItem>
            <asp:ListItem value="GP">Guadeloupe</asp:ListItem>
            <asp:ListItem value="GU">Guam</asp:ListItem>
            <asp:ListItem value="GT">Guatemala</asp:ListItem>
            <asp:ListItem value="GG">Guernsey</asp:ListItem>
            <asp:ListItem value="GN">Guinea</asp:ListItem>
            <asp:ListItem value="GW">Guinea-Bissau</asp:ListItem>
            <asp:ListItem value="GY">Guyana</asp:ListItem>
            <asp:ListItem value="HT">Haiti</asp:ListItem>
            <asp:ListItem value="HM">Heard Island and McDonald Islands</asp:ListItem>
            <asp:ListItem value="HN">Honduras</asp:ListItem>
            <asp:ListItem value="HK">Hong Kong SAR</asp:ListItem>
            <asp:ListItem value="HU">Hungary</asp:ListItem>
            <asp:ListItem value="IS">Iceland</asp:ListItem>
            <asp:ListItem value="IN">India</asp:ListItem>
            <asp:ListItem value="ID">Indonesia</asp:ListItem>
            <asp:ListItem value="IR">Iran</asp:ListItem>
            <asp:ListItem value="IQ">Iraq</asp:ListItem>
            <asp:ListItem value="IE">Ireland</asp:ListItem>
            <asp:ListItem value="IM">Isle of Man</asp:ListItem>
            <asp:ListItem value="IL">Israel</asp:ListItem>
            <asp:ListItem value="IT">Italy</asp:ListItem>
            <asp:ListItem value="JM">Jamaica</asp:ListItem>
            <asp:ListItem value="JP">Japan</asp:ListItem>
            <asp:ListItem value="JO">Jordan</asp:ListItem>
            <asp:ListItem value="JE">Jersey</asp:ListItem>
            <asp:ListItem value="KZ">Kazakhstan</asp:ListItem>
            <asp:ListItem value="KE">Kenya</asp:ListItem>
            <asp:ListItem value="KI">Kiribati</asp:ListItem>
            <asp:ListItem value="KR">Korea</asp:ListItem>
            <asp:ListItem value="KW">Kuwait</asp:ListItem>
            <asp:ListItem value="KG">Kyrgyzstan</asp:ListItem>
            <asp:ListItem value="LA">Laos</asp:ListItem>
            <asp:ListItem value="LV">Latvia</asp:ListItem>
            <asp:ListItem value="LB">Lebanon</asp:ListItem>
            <asp:ListItem value="LS">Lesotho</asp:ListItem>
            <asp:ListItem value="LR">Liberia</asp:ListItem>
            <asp:ListItem value="LY">Libya</asp:ListItem>
            <asp:ListItem value="LI">Liechtenstein</asp:ListItem>
            <asp:ListItem value="LT">Lithuania</asp:ListItem>
            <asp:ListItem value="LU">Luxembourg</asp:ListItem>
            <asp:ListItem value="MO">Macao SAR</asp:ListItem>
            <asp:ListItem value="MK">Macedonia, Former Yugoslav Republic of</asp:ListItem>
            <asp:ListItem value="MG">Madagascar</asp:ListItem>
            <asp:ListItem value="MW">Malawi</asp:ListItem>
            <asp:ListItem value="MY">Malaysia</asp:ListItem>
            <asp:ListItem value="MV">Maldives</asp:ListItem>
            <asp:ListItem value="ML">Mali</asp:ListItem>
            <asp:ListItem value="MT">Malta</asp:ListItem>
            <asp:ListItem value="MH">Marshall Islands</asp:ListItem>
            <asp:ListItem value="MQ">Martinique</asp:ListItem>
            <asp:ListItem value="MR">Mauritania</asp:ListItem>
            <asp:ListItem value="MU">Mauritius</asp:ListItem>
            <asp:ListItem value="YT">Mayotte</asp:ListItem>
            <asp:ListItem value="MX">Mexico</asp:ListItem>
            <asp:ListItem value="FM">Micronesia</asp:ListItem>
            <asp:ListItem value="MD">Moldova</asp:ListItem>
            <asp:ListItem value="MC">Monaco</asp:ListItem>
            <asp:ListItem value="MN">Mongolia</asp:ListItem>
            <asp:ListItem value="MS">Montserrat</asp:ListItem>
            <asp:ListItem value="MA">Morocco</asp:ListItem>
            <asp:ListItem value="MZ">Mozambique</asp:ListItem>
            <asp:ListItem value="MM">Myanmar</asp:ListItem>
            <asp:ListItem value="NA">Namibia</asp:ListItem>
            <asp:ListItem value="NR">Nauru</asp:ListItem>
            <asp:ListItem value="NP">Nepal</asp:ListItem>
            <asp:ListItem value="AN">Netherlands Antilles</asp:ListItem>
            <asp:ListItem value="NL">Netherlands, The</asp:ListItem>
            <asp:ListItem value="NC">New Caledonia</asp:ListItem>
            <asp:ListItem value="NZ">New Zealand</asp:ListItem>
            <asp:ListItem value="NI">Nicaragua</asp:ListItem>
            <asp:ListItem value="NE">Niger</asp:ListItem>
            <asp:ListItem value="NG">Nigeria</asp:ListItem>
            <asp:ListItem value="NU">Niue</asp:ListItem>
            <asp:ListItem value="NF">Norfolk Island</asp:ListItem>
            <asp:ListItem value="KP">North Korea</asp:ListItem>
            <asp:ListItem value="MP">Northern Mariana Islands</asp:ListItem>
            <asp:ListItem value="NO">Norway</asp:ListItem>
            <asp:ListItem value="OM">Oman</asp:ListItem>
            <asp:ListItem value="PK">Pakistan</asp:ListItem>
            <asp:ListItem value="PW">Palau</asp:ListItem>
            <asp:ListItem value="PS">Palestinian Authority</asp:ListItem>
            <asp:ListItem value="PA">Panama</asp:ListItem>
            <asp:ListItem value="PG">Papua New Guinea</asp:ListItem>
            <asp:ListItem value="PY">Paraguay</asp:ListItem>
            <asp:ListItem value="PE">Peru</asp:ListItem>
            <asp:ListItem value="PH">Philippines</asp:ListItem>
            <asp:ListItem value="PN">Pitcairn Islands</asp:ListItem>
            <asp:ListItem value="PL">Poland</asp:ListItem>
            <asp:ListItem value="PT">Portugal</asp:ListItem>
            <asp:ListItem value="PR">Puerto Rico</asp:ListItem>
            <asp:ListItem value="QA">Qatar</asp:ListItem>
            <asp:ListItem value="RE">Reunion</asp:ListItem>
            <asp:ListItem value="RO">Romania</asp:ListItem>
            <asp:ListItem value="RU">Russia</asp:ListItem>
            <asp:ListItem value="RW">Rwanda</asp:ListItem>
            <asp:ListItem value="WS">Samoa</asp:ListItem>
            <asp:ListItem value="SM">San Marino</asp:ListItem>
            <asp:ListItem value="ST">São Tomé and Príncipe</asp:ListItem>
            <asp:ListItem value="SA">Saudi Arabia</asp:ListItem>
            <asp:ListItem value="SN">Senegal</asp:ListItem>
            <asp:ListItem value="YU">Serbia and Montenegro</asp:ListItem>
            <asp:ListItem value="SC">Seychelles</asp:ListItem>
            <asp:ListItem value="SL">Sierra Leone</asp:ListItem>
            <asp:ListItem value="SG">Singapore</asp:ListItem>
            <asp:ListItem value="SK">Slovakia</asp:ListItem>
            <asp:ListItem value="SI">Slovenia</asp:ListItem>
            <asp:ListItem value="SB">Solomon Islands</asp:ListItem>
            <asp:ListItem value="SO">Somalia</asp:ListItem>
            <asp:ListItem value="ZA">South Africa</asp:ListItem>
            <asp:ListItem value="GS">South Georgia and the South Sandwich Islands</asp:ListItem>
            <asp:ListItem value="ES">Spain</asp:ListItem>
            <asp:ListItem value="LK">Sri Lanka</asp:ListItem>
            <asp:ListItem value="SH">St. Helena</asp:ListItem>
            <asp:ListItem value="KN">St. Kitts and Nevis</asp:ListItem>
            <asp:ListItem value="LC">St. Lucia</asp:ListItem>
            <asp:ListItem value="PM">St. Pierre and Miquelon</asp:ListItem>
            <asp:ListItem value="VC">St. Vincent and the Grenadines</asp:ListItem>
            <asp:ListItem value="SD">Sudan</asp:ListItem>
            <asp:ListItem value="SR">Suriname</asp:ListItem>
            <asp:ListItem value="SJ">Svalbard and Jan Mayen</asp:ListItem>
            <asp:ListItem value="SZ">Swaziland</asp:ListItem>
            <asp:ListItem value="SE">Sweden</asp:ListItem>
            <asp:ListItem value="CH">Switzerland</asp:ListItem>
            <asp:ListItem value="SY">Syria</asp:ListItem>
            <asp:ListItem value="TW">Taiwan</asp:ListItem>
            <asp:ListItem value="TJ">Tajikistan</asp:ListItem>
            <asp:ListItem value="TZ">Tanzania</asp:ListItem>
            <asp:ListItem value="TH">Thailand</asp:ListItem>
            <asp:ListItem value="TP">Timor-Leste</asp:ListItem>
            <asp:ListItem value="TG">Togo</asp:ListItem>
            <asp:ListItem value="TK">Tokelau</asp:ListItem>
            <asp:ListItem value="TO">Tonga</asp:ListItem>
            <asp:ListItem value="TT">Trinidad and Tobago</asp:ListItem>
            <asp:ListItem value="TA">Tristan da Cunha</asp:ListItem>
            <asp:ListItem value="TN">Tunisia</asp:ListItem>
            <asp:ListItem value="TR">Turkey</asp:ListItem>
            <asp:ListItem value="TM">Turkmenistan</asp:ListItem>
            <asp:ListItem value="TC">Turks and Caicos Islands</asp:ListItem>
            <asp:ListItem value="TV">Tuvalu</asp:ListItem>
            <asp:ListItem value="UG">Uganda</asp:ListItem>
            <asp:ListItem value="UA">Ukraine</asp:ListItem>
            <asp:ListItem value="AE">United Arab Emirates</asp:ListItem>
            <asp:ListItem value="UK">United Kingdom</asp:ListItem>
            <asp:ListItem value="US">United States</asp:ListItem>
            <asp:ListItem value="UM">United States Minor Outlying Islands</asp:ListItem>
            <asp:ListItem value="UY">Uruguay</asp:ListItem>
            <asp:ListItem value="UZ">Uzbekistan</asp:ListItem>
            <asp:ListItem value="VU">Vanuatu</asp:ListItem>
            <asp:ListItem value="VA">Vatican City</asp:ListItem>
            <asp:ListItem value="VE">Venezuela</asp:ListItem>
            <asp:ListItem value="VN">Vietnam</asp:ListItem>
            <asp:ListItem value="VI">Virgin Islands</asp:ListItem>
            <asp:ListItem value="VG">Virgin Islands, British</asp:ListItem>
            <asp:ListItem value="WF">Wallis and Futuna</asp:ListItem>
            <asp:ListItem value="YE">Yemen</asp:ListItem>
            <asp:ListItem value="ZM">Zambia</asp:ListItem>
            <asp:ListItem value="ZW">Zimbabwe</asp:ListItem>
        </asp:DropDownList>   
    <asp:RequiredFieldValidator ID="rv1" ControlToValidate="ddCountry" ValidationGroup="shipment" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
  </td>
</tr>
<tr >
  <td><%=GetLocalResourceObject("State")%></td><td>:</td>
  <td>
  <table cellpadding="0" cellspacing="0">
  <tr>
  <td>
    <asp:DropDownList ID="ddState" runat="server">
    </asp:DropDownList>
  </td>
  </tr>
  </table>
  </td>
</tr>
<tr>
<td>
    <%=GetLocalResourceObject("FlatAmount")%> (<%=Me.CurrencySymbol%>)
</td>
<td>:</td>
<td>
 <asp:TextBox ID="txtFlatAmount" Width="60" runat="server"></asp:TextBox> 
 &nbsp;&nbsp;<%=GetLocalResourceObject("Percentage")%>&nbsp;&nbsp;
 <asp:TextBox ID="txtPercentage" Width="30" runat="server"></asp:TextBox> 
 <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*"  ValidationGroup="shipment" ClientValidationFunction="CalValidation"></asp:CustomValidator>
 <script language="javascript" type="text/javascript"><!--
    function CalValidation (source, arguments)
      {
      t1 = document.getElementById("<%=txtFlatAmount.ClientId %>");
      t2=document.getElementById("<%=txtPercentage.ClientId %>");
      arguments.IsValid=!((t1.value=="") && (t2.value==""));
      }
    function clearPair (oPair)
      {
      oPair.value="";
      }  
  //--></script>
    
</td>    
</tr>
</table>
<div style="margin:15px"></div>
<asp:SqlDataSource ID="SqlDataSource1" runat="server">
  <DeleteParameters>
    <asp:Parameter Name="ship_cost_id" Type="Int32" />
  </DeleteParameters>
</asp:SqlDataSource>
<asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text=" Add Shipment " ValidationGroup="shipment" OnClick="btnSave_Click" />

</asp:Panel>