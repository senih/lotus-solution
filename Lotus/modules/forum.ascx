<%@ Control Language="VB" AutoEventWireup="false" CodeFile="forum.ascx.vb" Inherits="modules_forum" %>
<asp:HiddenField ID="hfSubjectId" runat="server" Value="0" />
<asp:HiddenField ID="hfParentId" runat="server" Value="0" />

<asp:Panel ID="pnlRegisterAndLogin" Visible="false" runat="server">
    <p>
    <asp:HyperLink ID="lnkRegisterHere" meta:resourcekey="lnkRegisterHere" runat="server">Register Now</asp:HyperLink> 
    <asp:Literal ID="litAndStartPosting" meta:resourcekey="litAndStartPosting" runat="server"> and start posting!</asp:Literal> 
    <asp:Literal ID="litIfYouHaveAccount" meta:resourcekey="litIfYouHaveAccount" runat="server">If you already have an account, </asp:Literal>
    <asp:HyperLink ID="lnkLoginHere" meta:resourcekey="lnkLoginHere" runat="server">please login here</asp:HyperLink>.
    </p>
</asp:Panel>

<!--View forum-->
<asp:Panel ID="pnlViewForum" runat="server">
    <asp:Literal runat="server" ID="litNewForumEmpty"></asp:Literal>
    <asp:Repeater ID="repCat" runat="server" DataSourceID="dsRepeater">
        <ItemTemplate>
        <table cellpadding=0 cellspacing=0 width="100%">
            <tr class="frm_category_bar">
                <td align="left" style="padding:5px">
                    <asp:Label runat="server" CssClass="frm_category_title" Text='<%# Eval("Category") %>' />
                </td>
                <td align="right" style="padding:5px">
                    <asp:Literal ID="litNewForum" runat="server" Text=""></asp:Literal>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:GridView ID="grdForum" runat="server" DataSourceID="dsForum" AutoGenerateColumns=false Width="100%" gridlines="none" CellPadding=5>
                        <Columns>
                            <asp:TemplateField ItemStyle-VerticalAlign="top"  ItemStyle-HorizontalAlign="Left" HeaderStyle-CssClass="frm_forum_header" ItemStyle-CssClass="frm_forum_item">  
                                <HeaderTemplate ><%=GetLocalResourceObject("colFORUMS")%></HeaderTemplate>
                                <ItemTemplate >
                                    <asp:literal runat="server" id="litColForum"></asp:literal>
                                </ItemTemplate>                                
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="180px"  ItemStyle-HorizontalAlign="Left"  HeaderStyle-CssClass="frm_forum_header" ItemStyle-CssClass="frm_forum_item">
                                <HeaderTemplate ><%=GetLocalResourceObject("colLASTPOST")%></HeaderTemplate>
                                <ItemTemplate >
                                    <asp:literal runat="server" id="litColLastPost"></asp:literal>                                
                                </ItemTemplate>                                  
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="center"  HeaderStyle-CssClass="frm_forum_header" ItemStyle-CssClass="frm_forum_item">
                                <HeaderTemplate ><%=GetLocalResourceObject("colTHREADS")%></HeaderTemplate>
                                <ItemTemplate >
                                    <asp:literal runat="server" id="litColThread"></asp:literal>
                                </ItemTemplate>                                  
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsForum" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
                        <SelectParameters >
                            <asp:Parameter Name="category" Type="String" />
                            <asp:Parameter Name="page_id" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>            
                </td>
            </tr>           
        </table>
        <br>
        </ItemTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="dsRepeater" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
        <SelectParameters >
            <asp:Parameter Name="page_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Panel>

<!--View Threads-->
<asp:Panel ID="pnlViewThreads" runat="server">
<table cellpadding="2" cellspacing="2" width="100%">
<tr>
    <td>
        <asp:Label ID="lblForumTitle" runat="server" CssClass="frm_title"></asp:Label><br><br>
        <asp:Label ID="lblForumDesc" runat="server"></asp:Label>
    </td>
</tr>    
<tr>
    <td>
        &nbsp;
    </td>
</tr>    
<tr>
    <td>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td><asp:Literal runat="server" ID="litFrmPath" Text="Category:General"></asp:Literal></td>
                <td align="right">
                    <asp:Literal ID="litEditForum" runat="server" Text=""></asp:Literal>&nbsp;
                    <asp:Literal ID="litDeleteForum" runat="server" Text=""></asp:Literal>&nbsp;
                    <asp:Literal ID="litNewThread" runat="server" Text=""></asp:Literal>
                </td>
            </tr>
        </table>
    </td>    
</tr>
<tr>
    <td>
        <asp:GridView ID="grdThreads" runat="server" DataSourceID="dsThreads" AutoGenerateColumns=false Width="100%" GridLines="none" CellPadding=5 AllowPaging=true PageSize="10">
        <Columns>
            <asp:TemplateField ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="top" HeaderStyle-CssClass="frm_thread_header" ItemStyle-CssClass="frm_thread_item">
                <HeaderTemplate><%=GetLocalResourceObject("colTHREADS")%></HeaderTemplate>
                <ItemTemplate>
                    <asp:Literal runat="server" ID="litThrThread"></asp:Literal>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-HorizontalAlign="left" HeaderStyle-Width="160px" HeaderStyle-CssClass="frm_thread_header" ItemStyle-CssClass="frm_thread_item">
                <HeaderTemplate ><%=GetLocalResourceObject("colLASTPOST")%></HeaderTemplate>
                <ItemTemplate >
                    <asp:Literal runat="server" ID="litThrLastPost"></asp:Literal>
                </ItemTemplate>                                
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-HorizontalAlign="center" HeaderStyle-Width="60px" HeaderStyle-CssClass="frm_thread_header" ItemStyle-CssClass="frm_thread_item">
                <HeaderTemplate ><%=GetLocalResourceObject("colVIEWED")%></HeaderTemplate>
                <ItemTemplate >
                    <asp:Literal runat="server" ID="litThrViewed"></asp:Literal>
                </ItemTemplate>                                
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" ItemStyle-Wrap=true HeaderStyle-CssClass="frm_thread_header" ItemStyle-CssClass="frm_thread_item">
                <HeaderTemplate ><%=GetLocalResourceObject("colREPLIES")%></HeaderTemplate>
                <ItemTemplate >
                    <asp:Literal runat="server" ID="litThrReplies"></asp:Literal>
                </ItemTemplate>                                
            </asp:TemplateField>
        </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="dsThreads" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
        <SelectParameters >
            <asp:Parameter Name="parent_id" Type="Decimal" />
        </SelectParameters>
        </asp:SqlDataSource>
    </td>
<tr>
</table>
<div style="display:block;padding:4px">
    <div style="display:block;padding:5px;" class="frm_statusbox">
        <%=GetLocalResourceObject("frmStatus")%>&nbsp;<asp:Literal runat="server" ID="litForumStatus"></asp:Literal><asp:Literal runat="server" ID="litToggleLockForum"></asp:Literal><br>
        <%=GetLocalResourceObject("frmTotalTopics")%>&nbsp;<asp:Literal runat="server" ID="litForumTopics"></asp:Literal><br>
        <%=GetLocalResourceObject("frmTotalPosts")%>&nbsp;<asp:Literal runat="server" ID="litForumPosts"></asp:Literal><br>
        <%=GetLocalResourceObject("frmViewed")%>&nbsp;<asp:Literal runat="server" ID="litForumViewed"></asp:Literal>&nbsp;<%=GetLocalResourceObject("frmTimes")%>
    </div> 
</div> 
</asp:Panel>

<!--View Replies-->
<asp:Panel ID="pnlReplies" runat="server" Visible="false">
<table cellpadding="2" cellspacing="2" width="100%">
    <tr>
        <td>
            <asp:Label ID="lblThreadTitle" runat="server" class="frm_title"></asp:Label><br>
            <br><br>
        <td>
    </tr>
    <tr>
        <td>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td><asp:Literal runat="server" ID="litThreadPath" Text="Category:General"></asp:Literal></td>
                    <td align="right"><asp:Literal ID="litNewThread2" runat="server" Text=""></asp:Literal></td>
                </tr>
            </table>
        </td>    
    </tr>    
    <tr>
        <td>
            <table cellpadding="5" cellspacing=0 width="100%" style="border-collapse:collapse">
                <tr><td colspan=2 class="frm_post_bar"><div style="float:left"><asp:Literal runat="server" ID="litThreadHeader" ></asp:Literal></div><div style="float:right"><asp:literal runat="server" ID="litThreadId"></asp:literal></div></td></tr>
                <tr><td rowspan=2 class="frm_post_infopanel" width="120" valign="top" align="center"><asp:Literal runat="server" ID="litThreadInfo" ></asp:Literal></td><td valign="top" class="frm_post_subject"><asp:Literal runat="server" ID="litThreadSubject" ></asp:Literal></td></tr>
                <tr><td valign="top" class="frm_post_message"><asp:Literal runat="server" ID="litThreadMessage" ></asp:Literal></td></tr>
            </table>
            <br>            
        </td>
    </tr>
    <tr>
        <td>
        <asp:GridView ID="grdReplies" EnableTheming="false" runat="server" DataSourceID="dsReplies" AutoGenerateColumns=false Width="100%" GridLines=None ShowHeader=false ShowFooter=false AllowPaging=true PageSize="10">            
            <Columns>
                <asp:TemplateField>                    
                    <ItemTemplate>                       
                        <table cellpadding="5" cellspacing=0 width="100%" style="border-collapse:collapse">
                            <tr><td colspan=2 class="frm_post_bar"><div style="float:left"><asp:Literal runat="server" ID="litRepliesHeader" ></asp:Literal></div><div style="float:right"><asp:literal runat="server" ID="litRepliesId"></asp:literal></div></td></tr>
                            <tr><td rowspan=2 class="frm_post_infopanel" width="120" valign="top" align="center"><asp:Literal runat="server" ID="litRepliesUserInfo" ></asp:Literal></td><td valign="top" class="frm_post_subject"><asp:Literal runat="server" ID="litRepliesSubject" ></asp:Literal></td></tr>
                            <tr><td valign="top" class="frm_post_message"><asp:Literal runat="server" ID="litRepliesMessage" ></asp:Literal></td></tr>
                        </table>
                        <br>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
         
        </asp:GridView>
        <asp:SqlDataSource ID="dsReplies" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
            <SelectParameters >
                <asp:Parameter Name="parent_id" Type="Decimal" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        </td>
    </tr>
</table>
</asp:Panel>

<!--Create forum-->
<asp:Panel ID="pnlCreateDiscussion" runat="server" Visible="false">
<asp:HiddenField ID="hfType" runat="server" Value="F" />
<asp:HiddenField ID="hfReplyTo" runat="server" Value="0" />
<table width="100%" cellpadding=2 cellspacing=1>
    <asp:panel runat="server" Visible="true" ID="pnlCategory">
    <tr>
        <td valign="top"><%=GetLocalResourceObject("litCategory")%></td>
        <td valign="top">:</td>
        <td>
            <script>
                function categoryChanged(dd) {
                    var c=document.getElementById("spanNewCat");
                    if (dd.value=="NEWCAT") {
                        c.style.display="";
                    } else {
                        c.style.display="none";
                    }
                }
                function checkCategory(source, arguments) {
                    var dd = document.getElementById("<%=ddCategory.clientId%>");
                    var txtNew = document.getElementById("<%=txtNewCat.clientId%>"); 
                    if (dd.value=="NEWCAT" && txtNew.value=="") {
                        arguments.IsValid=false;
                        return;
                    }
                    arguments.IsValid=true; 
                }
            </script>
            <asp:DropDownList ID="ddCategory" runat="server" onchange="categoryChanged(this)"></asp:DropDownList>
            <span id="spanNewCat" style="<%=iif(ddCategory.SelectedValue<>"NEWCAT","display:none", "") %>">
                <asp:TextBox ID="txtNewCat" runat="server"></asp:TextBox>
                <asp:CustomValidator runat=server ClientValidationFunction="checkCategory" EnableClientScript=true ValidationGroup="SaveDiscussion" SetFocusOnError="true" ErrorMessage="*"></asp:CustomValidator>
            </span>
        </td>
    </tr>
    </asp:panel>
    <tr>
        <td valign="top">
            <%=GetLocalResourceObject("litSubject")%>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtSubject" ValidationGroup="SaveDiscussion" ErrorMessage="*" SetFocusOnError="true"></asp:RequiredFieldValidator>
        </td>
        <td valign="top">:</td>
        <td nowrap>
            <asp:TextBox ID="txtSubject" runat="server" MaxLength="255" Width="99%"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top"><%=GetLocalResourceObject("litMessage")%></td>
        <td valign="top">:</td>
        <td>
            <asp:LinkButton ID="lnkAdvEdit" runat="server">Advanced Mode</asp:LinkButton>               
            <asp:LinkButton ID="lnkQuickEdit" runat="server" Visible=false>Quick Mode</asp:LinkButton>
            <editor:WYSIWYGEditor runat="server" ID="txtMessage" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="280px" Text=""/>
        </td>
    </tr>
    <asp:panel runat="server" ID="pnlStatus" Visible="false">
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td valign="top"><%=GetLocalResourceObject("litStatus")%></td>
        <td valign="top">:</td>
        <td>
            <asp:DropDownList runat="server" ID="ddStatus">
                <asp:ListItem meta:resourcekey="statusUnlocked" Text="unlocked" Value ="unlocked" Selected=true ></asp:ListItem>
                <asp:ListItem meta:resourcekey="statusLocked" Text="locked" Value ="locked"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>    
    </asp:panel>     
    
    <asp:panel runat="server" ID="pnlNoRelply" Visible="false">
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td colspan="3" style="background-color:#d7d7d7;font-weight:bold">
            <%=GetLocalResourceObject("litOPTIONS")%>
        </td>
    </tr>
    <tr>
        <td valign="top"><%=GetLocalResourceObject("litNoReply")%></td>
        <td valign="top">:</td>
        <td>
            <asp:CheckBox ID="cbNoReply" runat="server"  Checked="False" />
        </td>
    </tr>
    </asp:panel>
    <tr>
        <td colspan=3>
            <br><br>
            <asp:Button ID="btnCreate" runat="server" Text="Create" meta:resourcekey="btnCreate" ValidationGroup="SaveDiscussion"/>
            <asp:Button ID="btnUpdate" runat="server" Text="Save" meta:resourcekey="btnSave" visible="False" ValidationGroup="SaveDiscussion"/>
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" meta:resourcekey="btnCancel" />
        </td>
    </tr>
</table>
</asp:Panel>

<!--Delete discussion-->
<asp:Panel ID="pnlDeleteDiscussion"  runat="server" Visible="false">
    <asp:Literal runat="server" ID="litDelDiscussion"></asp:Literal><br><br>
    <asp:Button ID="btnDelete" runat="server" Text="Delete" meta:resourcekey="btnDelete" />
    <asp:Button ID="btnCancelDelete" runat="server" Text="Cancel" meta:resourcekey="btnCancel"/>
</asp:Panel>

<!--View search result-->
<asp:Panel runat="server" ID="pnlSearchResult">
<asp:GridView runat="server" ID="grdSearchForum" EnableTheming="false" DataSourceID="dsSearchForum" AutoGenerateColumns=false Width="100%" GridLines="None" ShowHeader="false" ShowFooter="false" AllowPaging="true" PageSize="10">
    <EmptyDataTemplate>
        <asp:literal runat="server" ID="litNoResult" meta:resourcekey="litNoResult" Text="Your search did not match any posts in the forum."></asp:literal>
    </EmptyDataTemplate>
    <Columns>
        <asp:TemplateField>
            <ItemTemplate>
                <p>
                    <div style="font-weight:bold"><asp:Literal ID="litSearchTitle" runat="server"></asp:Literal></div>
                    <div><asp:Literal ID="litSearchContent" runat="server"></asp:Literal></div>
                </p>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:SqlDataSource ID="dsSearchForum" runat="server" ConnectionString="<%$ ConnectionStrings:SiteConnectionString %>" >
</asp:SqlDataSource>
</asp:Panel>

<!--Search forum-->
<asp:Panel ID="pnlSearchForum" runat="server" DefaultButton="btnSearchForum">
<br>
<table>
    <tr>
        <td><asp:Literal runat="server" meta:resourcekey="litSearchForum" Text="Search Forum"></asp:Literal></td>
        <td><asp:TextBox runat="server" ID="txtSearchForum" Width="150px"></asp:TextBox></td>
        <td><asp:Button runat="server" ID="btnSearchForum" meta:resourcekey="litBtnSearchForum" Text="Search Forum" /></td>
    </tr>
</table>
</asp:Panel>