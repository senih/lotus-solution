<%@ Control Language="C#" AutoEventWireup="true" CodeFile="chat.ascx.cs" Inherits="modules_chat" %>

<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table>
        <tr>
            <td>
                <asp:Label ID="TimeLabel" runat="server"></asp:Label>
            </td>
            <td></td>
        </tr>
            <tr>
                <td colspan="2">
                    <asp:TextBox ID="ChatTextBox" runat="server" Height="200px" 
                        TextMode="MultiLine" Width="400px"></asp:TextBox>
                </td>
            </tr>
        </table>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="SendButton" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="Timer1" />
    </Triggers>
</asp:UpdatePanel>
<table>
    <tr>
        <td>
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <asp:TextBox ID="MessageTextBox" runat="server" Width="300px"></asp:TextBox>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="SendButton" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
            
        </td>
        <td>
            <asp:Button ID="SendButton" runat="server" Text="Send" Width="100px" 
                onclick="SendButton_Click" />
        </td>
    </tr>
    <tr>
        <td></td>
        <td>
            <asp:Button ID="EndChatButton" runat="server" Text="End Chat" Width="100px" />
        </td>
    </tr>
</table>
<asp:Timer ID="Timer1" runat="server" Interval="2000">
</asp:Timer>
