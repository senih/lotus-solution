<%@ Control Language="C#" AutoEventWireup="true" CodeFile="chat.ascx.cs" Inherits="modules_chat" %>
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<asp:Panel ID="AnonymousPanel" runat="server">
    Unauthorized !!!
</asp:Panel>
<asp:Panel ID="LoggedInPanel" runat="server">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
    <table>
        <tr>
            <td colspan="2">
                <asp:TextBox ID="ChatTextBox" TextMode="MultiLine" runat="server" Height="200px" Width="400px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="MessageTextBox" runat="server" Width="300px"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="SendButton" runat="server" Text="Send" 
                    onclick="SendButton_Click" Width="100px" />
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="EndChatButton" runat="server" onclick="EndChatButton_Click" 
                    Text="End Chat" Width="100px" />
            </td>
        </tr>
    </table>
</ContentTemplate>
</asp:UpdatePanel>
</asp:Panel>

