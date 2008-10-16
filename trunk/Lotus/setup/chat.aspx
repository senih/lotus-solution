<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chat.aspx.cs" Inherits="setup_chat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
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
                    <tr>
                        <td>
                            <asp:TextBox ID="MessageTextBox" runat="server" Width="300px"></asp:TextBox>
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
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="SendButton" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="Timer1" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <asp:Timer ID="Timer1" runat="server" Interval="2000">
    </asp:Timer>
    </form>
</body>
</html>
