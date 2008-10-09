<%@ Page Language="C#" AutoEventWireup="true" CodeFile="address.aspx.cs" Inherits="setup_address" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
            onselectedindexchanged="DropDownList1_SelectedIndexChanged" Width="150px">
        </asp:DropDownList><br /><br />
        <asp:DropDownList ID="DropDownList2" runat="server" Enabled="False" 
            Width="150px">
        </asp:DropDownList>    
    </div>
    </form>
</body>
</html>
