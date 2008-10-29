<%@ Control Language="C#" AutoEventWireup="true" CodeFile="chat.ascx.cs" Inherits="modules_chat" %>
<script type="text/javascript" >
 <!--
    function doClear(theText) {        
            theText.value = ""      
    }
 // -->
 </script>


<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>

<asp:Panel ID="ChatPanel" runat="server">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table>
            <tr>
                <td>
                    Time: <asp:Label ID="TimeLabel" runat="server"></asp:Label><hr />
                </td>
            </tr>
            <tr>
                <td></td>
            </tr>
            <tr>
                <td style="height:200px; width:450px;" valign="top">
                    <asp:PlaceHolder ID="ChatPlaceHolder" runat="server"></asp:PlaceHolder>
                </td>
            </tr>
            <tr>
                <td><hr /></td>
            </tr>
        </table>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="SendButton" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="ChatTimer" EventName="Tick" />
    </Triggers>
</asp:UpdatePanel>
<table>
    <tr>
        <td>
            <asp:TextBox ID="MessageTextBox" runat="server" Width="350px" 
                onFocus="doClear(this)" TextMode="MultiLine"></asp:TextBox>
        </td>
        <td>
            <asp:Button ID="SendButton" runat="server" Text="Send" Width="100px" 
                onclick="SendButton_Click" Height="50px"/>
        </td>
    </tr>
    <tr>
        <td></td>
        <td>
            <asp:Button ID="EndChatButton" runat="server" onclick="EndChatButton_Click" 
                Text="End Chat" Width="100px" />
        </td>
    </tr>
</table>
<asp:Timer ID="ChatTimer" runat="server" Interval="2000">
</asp:Timer>
</asp:Panel>
