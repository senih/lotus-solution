<%@ Control Language="VB" Inherits="BaseUserControl"%>

<script runat="server">
    Sub handleView(ByVal sender As Object, ByVal e As AdCreatedEventArgs)
        If e.NavigateUrl = "http://www.insitecreation.com" Then
            '
        Else
            '
        End If
    End Sub
</script>

<asp:AdRotator 
    ID="AdRotator1" 
    runat="server" 
    AdvertisementFile="banner.xml" 
    Target="_blank" 
    OnAdCreated="handleView" />
