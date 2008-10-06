<%@ Control Language="VB" AutoEventWireup="false" CodeFile="LoginRegister.ascx.vb" Inherits="modules_LoginRegister" %>
<style type="text/css">
    .style1
    {
        width: 736px;
        border-collapse: collapse;
    }
</style>
<table class="style1">
    <tr>
        <td style="width:50%;">
            <asp:Label ID="lblLogin" meta:resourcekey="lblLogin" runat="server" Text="Login" CssClass="subTitle"></asp:Label>
        </td>
        <td style="width:50%;">
            <asp:Label ID="lblLogintxt" meta:resourcekey="lblLogintxt" runat="server" Text="If you have profile with us, please login below:"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="lblRegister" runat="server" meta:resourcekey="lblRegister" Text="Create profile" CssClass="subTitle"></asp:Label>
        </td>
        <td rowspan="2">
            <asp:Label ID="lblregistertxt" meta:resourcekey="lblRegistertxt" runat="server" Text="Tuka treba da pishuva neshto kako Doklolku nemate profil, ve molime kreirajte so shto ke ni ovozmozite podobar, bla bla ..."></asp:Label>
            <br />

            <asp:Button ID="btnregister" runat="server" Text="Register" />
        </td>
    </tr>
    <tr>
        <td>

            <asp:Login ID="Login1" runat="server">
            </asp:Login>
        </td>
    </tr>
</table>
