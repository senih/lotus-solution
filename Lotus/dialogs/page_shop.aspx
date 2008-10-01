<%@ Page Language="VB" %>
<%@ OutputCache Duration="1" VaryByParam="none"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)
    Private intPageId As Integer

    Protected Sub RedirectForLogin()
        If IsNothing(GetUser) Then
            Response.Write("Session Expired.")
            Response.End()
        Else
            'Authorization
            If Not Session(Request.QueryString("pg").ToString) Then
                'Session(nPageId.ToString) akan = true jika page bisa dibuka (di default.aspx/vb)
                Response.Write("Authorization Failed.")
                Response.End()
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RedirectForLogin()
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        btnClose.Text = GetLocalResourceObject("btnClose.Text")
        btnSave.Text = GetLocalResourceObject("btnSave.Text")
        lblDiscountPercentage.Text = GetLocalResourceObject("lblDiscountPercentage.Text")
        lblPrice.Text = GetLocalResourceObject("lblPrice.Text")
        lblPromotional.Text = GetLocalResourceObject("lblPromotional.Text")
        lblSalePrice.Text = GetLocalResourceObject("lblSalePrice.Text")
        lblSKU.Text = GetLocalResourceObject("lblSKU.Text")
        lblTangible.Text = GetLocalResourceObject("lblTangible.Text")
        lblUnits.Text = GetLocalResourceObject("lblUnits.Text")
        lblWeight.Text = GetLocalResourceObject("lblWeight.Text")
        litOptional.Text = GetLocalResourceObject("litOptional.Text")

        intPageId = CInt(Request.QueryString("pg"))
  
        If Not Page.IsPostBack Then

            Dim contentLatest As CMSContent
            Dim oContentManager As ContentManager = New ContentManager
            contentLatest = oContentManager.GetLatestVersion(intPageId)
            
            txtPrice.Text = FormatNumber(contentLatest.Price, 2)
            
            chkTangible.Checked = contentLatest.Tangible
            If Not contentLatest.Tangible Then
                'idWeight.Style.Add("display", "none")                
                'idUnits.Style.Add("display", "none")
                txtWeight.Attributes.Add("disabled", "")
            Else
                txtWeight.Attributes.Remove("disabled")
            End If
            'chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & idWeight.ClientID & "').style.display='block';document.getElementById('" & idUnits.ClientID & "').style.display='block';}else{document.getElementById('" & idWeight.ClientID & "').style.display='none';document.getElementById('" & idUnits.ClientID & "').style.display='none';}")
            'chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & idWeight.ClientID & "').style.display='block';}else{document.getElementById('" & idWeight.ClientID & "').style.display='none';}")
            chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & txtWeight.ClientID & "').disabled='';}else{document.getElementById('" & txtWeight.ClientID & "').disabled='false';}")
            txtUnitsInStock.Text = contentLatest.UnitsInStock
            txtWeight.Text = contentLatest.Weight.ToString
            txtSKU.Text = contentLatest.SKU.ToString
            
            txtSalePrice.Text = FormatNumber(contentLatest.SalePrice, 2)
            txtDiscountPercentage.Text = contentLatest.DiscountPercentage.ToString
            
            contentLatest = Nothing
            oContentManager = Nothing

            btnClose.OnClientClick = "self.close()"
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        RedirectForLogin()

        Dim contentLatest As CMSContent
        Dim oContentManager As ContentManager = New ContentManager
        contentLatest = oContentManager.GetLatestVersion(intPageId)
             
        Dim sSQL As String
        If txtSalePrice.Text = "" Then
            sSQL = "UPDATE pages set price=@price,tangible=@tangible,sale_price=null,discount_percentage=@discount_percentage,weight=@weight,sku=@sku,units_in_stock=@units_in_stock WHERE page_id=@page_id AND version=@version"
        Else
            sSQL = "UPDATE pages set price=@price,tangible=@tangible,sale_price=@sale_price,discount_percentage=@discount_percentage,weight=@weight,sku=@sku,units_in_stock=@units_in_stock WHERE page_id=@page_id AND version=@version"
        End If

        Dim oCmd As SqlCommand
        oCmd = New SqlCommand(sSQL)
        oCmd.CommandType = CommandType.Text
        oCmd.Parameters.Add("@page_id", SqlDbType.Int).Value = contentLatest.PageId
        oCmd.Parameters.Add("@version", SqlDbType.Int).Value = contentLatest.Version
        If txtPrice.Text = "" Then
            oCmd.Parameters.Add("@price", SqlDbType.Money).Value = 0
        Else
            oCmd.Parameters.Add("@price", SqlDbType.Money).Value = Convert.ToDecimal(txtPrice.Text)
        End If
        oCmd.Parameters.Add("@tangible", SqlDbType.Bit).Value = chkTangible.Checked
       
        If Not txtSalePrice.Text = "" Then
            oCmd.Parameters.Add("@sale_price", SqlDbType.Money).Value = Convert.ToDecimal(txtSalePrice.Text)
        End If
        If txtDiscountPercentage.Text = "" Then
            oCmd.Parameters.Add("@discount_percentage", SqlDbType.Money).Value = 0
        Else
            oCmd.Parameters.Add("@discount_percentage", SqlDbType.Money).Value = txtDiscountPercentage.Text
        End If
        
        oCmd.Parameters.Add("@sku", SqlDbType.NVarChar, 50).Value = txtSKU.Text
        If Not chkTangible.Checked Then
            oCmd.Parameters.Add("@weight", SqlDbType.Decimal).Value = 0
            oCmd.Parameters.Add("@units_in_stock", SqlDbType.Int).Value = 0
            
            'idWeight.Style.Add("display", "none")
            'idUnits.Style.Add("display", "none")
            txtWeight.Attributes.Add("disabled", "")
        Else
            oCmd.Parameters.Add("@weight", SqlDbType.Decimal).Value = Convert.ToDecimal(txtWeight.Text)
            oCmd.Parameters.Add("@units_in_stock", SqlDbType.Int).Value = Convert.ToInt32(txtUnitsInStock.Text)
        
            'idWeight.Style.Add("display", "block")
            'idUnits.Style.Add("display", "block")
            txtWeight.Attributes.Remove("disabled")
        End If
        'chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & idWeight.ClientID & "').style.display='block';document.getElementById('" & idUnits.ClientID & "').style.display='block';}else{document.getElementById('" & idWeight.ClientID & "').style.display='none';document.getElementById('" & idUnits.ClientID & "').style.display='none';}")
        'chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & idWeight.ClientID & "').style.display='block';}else{document.getElementById('" & idWeight.ClientID & "').style.display='none';}")
        chkTangible.Attributes.Add("onclick", "if(this.checked){document.getElementById('" & txtWeight.ClientID & "').disabled='';}else{document.getElementById('" & txtWeight.ClientID & "').disabled='false';}")
        
        oConn.Open()
        oCmd.Connection = oConn
        oCmd.ExecuteNonQuery()
        oCmd = Nothing
        oConn.Close()

        lblSaveStatus.Text = GetLocalResourceObject("DataUpdated")

        contentLatest = Nothing
        oContentManager = Nothing
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <base target="_self" />
    <title id="idTitle" meta:resourcekey="idTitle" runat="server"></title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <style type="text/css">
        body{font-family:verdana;font-size:11px;color:#666666;}
        td{font-family:verdana;font-size:11px;color:#666666}
        a:link{color:#777777}
        a:visited{color:#777777}
        a:hover{color:#111111}
    </style>
    <script type="text/javascript" language="javascript">
    function closeAndRefresh(sFileName)
        {        
        if(navigator.appName.indexOf("Microsoft")!=-1)
            {
            dialogArguments.navigate("../" + sFileName)
            }
        else
            {
            window.opener.location.href="../" + sFileName;
            }
        self.close();
        }
    function adjustHeight()
        {
        if(navigator.appName.indexOf('Microsoft')!=-1)
            document.getElementById('cellContent').height=204;
        else
            document.getElementById('cellContent').height=204;
        }
    </script>
</head>
<body onload="adjustHeight()" style="margin:5px;background-color:#E6E7E8">
<form id="form1" runat="server">
<script language="javascript">
function clientValidateWeight(source, arguments) 
    {
    var chkTangible=document.getElementById("<%=chkTangible.clientId%>");
    if (chkTangible.checked) 
        {
        var txtWeight=document.getElementById("<%=txtWeight.clientId%>");
        if(txtWeight.value=="") 
            {
            arguments.IsValid=false;
            return;   
            }
        }
    arguments.IsValid=true;    
    } 
function clientValidateUnits(source, arguments) 
    {
    var chkTangible=document.getElementById("<%=chkTangible.clientId%>");
    if (chkTangible.checked) 
        {
        var txtUnitsInStock=document.getElementById("<%=txtUnitsInStock.clientId%>");
        if(txtUnitsInStock.value=="") 
            {
            arguments.IsValid=false;
            return;   
            }
        }
    arguments.IsValid=true;    
    } 
</script>
<table style="width:100%" cellpadding="0" cellspacing="0">
<tr>
<td id="cellContent" valign="top">
    <table width="100%" cellpadding="2">
    <tr>
        <td style="white-space:nowrap"><asp:Label ID="lblSKU" meta:resourcekey="lblSKU" runat="server" Text="SKU"></asp:Label> <i style="font-size:8px">
            <asp:Literal ID="litOptional" meta:resourcekey="litOptional" Text="(optional)" runat="server"></asp:Literal></i></td>
        <td>:</td>
        <td><asp:TextBox ID="txtSKU" Width="70px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><asp:Label ID="lblPrice" meta:resourcekey="lblPrice" runat="server" Text="Price"></asp:Label></td>
        <td>:</td>
        <td><asp:TextBox ID="txtPrice" Width="70px" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfValidator1" ControlToValidate="txtPrice" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><asp:Label ID="lblTangible" meta:resourcekey="lblTangible" runat="server" Text="Tangible"></asp:Label></td>
        <td>:</td>
        <td><asp:CheckBox ID="chkTangible" runat="server" /></td>
    </tr>
    <tr runat="server" id="idWeight">
        <td style="white-space:nowrap"><asp:Label ID="lblWeight" meta:resourcekey="lblWeight" runat="server" Text="Weight"></asp:Label></td>
        <td>:</td>
        <td><asp:TextBox ID="txtWeight" Width="70px" runat="server"></asp:TextBox>
        <asp:CustomValidator runat="server" ID="cvWeight" ClientValidationFunction="clientValidateWeight" ErrorMessage="*" SetFocusOnError="true"></asp:CustomValidator>
        </td>
    </tr>
    <tr runat="server" id="idUnits" style="display:none">
        <td style="white-space:nowrap"><asp:Label ID="lblUnits" meta:resourcekey="lblUnits" runat="server" Text="Units In Stock"></asp:Label></td>
        <td>:</td>
        <td><asp:TextBox ID="txtUnitsInStock" Width="70px" runat="server"></asp:TextBox>
        <asp:CustomValidator runat="server" ID="cvUnits" ClientValidationFunction="clientValidateUnits" ErrorMessage="*" SetFocusOnError="true"></asp:CustomValidator>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="padding-top:4px;padding-bottom:4px">
            <asp:Label ID="lblPromotional" meta:resourcekey="lblPromotional" Font-Bold="true" runat="server" Text="Promotional"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblSalePrice" meta:resourcekey="lblSalePrice" runat="server" Text="Sale Price"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtSalePrice" meta:resourcekey="txtSalePrice" Width="70px" runat="server"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="white-space:nowrap">
            <asp:Label ID="lblDiscountPercentage" meta:resourcekey="lblDiscountPercentage" runat="server" Text="Discount Percentage"></asp:Label>
        </td>
        <td>:</td>
        <td><asp:TextBox ID="txtDiscountPercentage" meta:resourcekey="txtDiscountPercentage" Width="70px" runat="server"></asp:TextBox></td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td align="right" style="padding:10px;padding-right:15px">    
    <asp:Label ID="lblSaveStatus" runat="server" Text="" Font-Bold="true"></asp:Label>
    <asp:Button ID="btnClose" meta:resourcekey="btnClose" runat="server" Text=" Close " />
    <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " />
</td>
</tr>
</table>

</form>
</body>
</html>
