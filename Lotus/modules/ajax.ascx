<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ajax.ascx.cs" Inherits="modules_ajax" %>

<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
<asp:Label ID="Label1" runat="server" Text="Label">
</asp:Label><asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="Button1" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
<asp:Button ID="Button1" runat="server" Text="Button" onclick="Button1_Click" />
