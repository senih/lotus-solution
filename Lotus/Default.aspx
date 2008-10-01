<%@ Page Language="VB" AutoEventWireup="false" ValidateRequest="false" EnableEventValidation="false" ViewStateEncryptionMode="Never" enableViewStateMac="false" CodeFile="~/default.aspx.vb" Inherits="_Default" %>
<%@ OutputCache Location="None" VaryByParam="none"%>

<asp:Content ID="contentPlaceholderSearch" ContentPlaceHolderID="placeholderSearch" runat="server">
    <asp:Panel defaultbutton="btnSearch" ID="panelSearchProduct" runat="server" CssClass="boxSearch" Wrap="false" visible="true"> 
        <asp:Label runat="server" ID="lblSearch" AssociatedControlID="txtSearch"></asp:Label> 
        <asp:TextBox ID="txtSearch" runat="server" CssClass="txtSearch" Width="100px" ValidationGroup="SearchProduct"></asp:TextBox>
        <asp:Button ID="btnSearch" meta:resourcekey="btnSearch" CssClass="btnSearch" SkinID="btnSearch" runat="server" UseSubmitBehavior=false ValidationGroup="SearchProduct" Text="Search" OnClick="btnSearch_Click" />
        <asp:RequiredFieldValidator ID="rfv11" runat="server" ErrorMessage="*" ValidationGroup="SearchProduct" ControlToValidate="txtSearch" ></asp:RequiredFieldValidator>
    </asp:Panel>
</asp:Content>

<asp:Content ID="contentPlaceholderTitle" ContentPlaceHolderID="placeholderTitle" runat="server">
    <asp:Literal ID="litTitle" runat="server"></asp:Literal>    
</asp:Content>

<asp:Content ID="contentPlaceholderTopMenu" ContentPlaceHolderID="placeholderTopMenu" runat="server">
    <span id="idAddNewTop" class="topmenu" visible="false" runat="server">
    [<asp:LinkButton id="lnkAddNewTop" CssClass="topmenu" meta:resourcekey="lnkAddNewTop" ValidationGroup="AddNewTop" runat="server">Add New</asp:LinkButton>]&nbsp;
    </span>
</asp:Content>

<asp:Content ID="contentPlaceholderBottomMenu" ContentPlaceHolderID="placeholderBottomMenu" runat="server">
    <span id="idAddNewBottom" class="bottommenu" visible="false" runat="server">
    [<asp:LinkButton id="lnkAddNewBottom" CssClass="bottommenu" meta:resourcekey="lnkAddNewBottom" ValidationGroup="AddNewBottom" runat="server">Add New</asp:LinkButton>]&nbsp;
    </span>
</asp:Content>

<asp:Content ID="contentPlaceholderLeft" ContentPlaceHolderID="placeholderLeft" runat="server">
</asp:Content>

<asp:Content ID="contentPlaceholderListing" ContentPlaceHolderID="placeholderListing" runat="server">
    <div runat="server" id="idListing">
    <asp:Literal id="litPlayer" runat="server"></asp:Literal>
    <asp:Panel ID="panelDataList" runat="server" visible="False">
    
        <table id="idDataListHeaderContainer" summary="" runat="server" cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
        <td style="width:100%">
            <div id="idDataListHeader" runat="server" class="paging">
            <asp:LinkButton ID="pgDataListFirst" meta:resourcekey="pgDataListFirst" runat="server">First</asp:LinkButton> <span style="color:#ACA899">|</span>
            <asp:LinkButton ID="pgDataListPrevious" meta:resourcekey="pgDataListPrevious" runat="server">Prev</asp:LinkButton> <span style="color:#ACA899">|</span>
            <asp:Label ID="lblDataListPagingInfo" font-bold="true" runat="server" Text=""></asp:Label> <span style="color:#ACA899">|</span>
            <asp:LinkButton ID="pgDataListNext" meta:resourcekey="pgDataListNext" runat="server">Next</asp:LinkButton> <span style="color:#ACA899">|</span>
            <asp:LinkButton ID="pgDataListLast" meta:resourcekey="pgDataListLast" runat="server">Last</asp:LinkButton>
            </div>          
        </td>
        <td style="white-space:nowrap;padding-top:3px;font-size:9px"><asp:Literal ID="litOrderBy" Text="Order By:" runat="server"></asp:Literal>&nbsp;</td>
        <td style="text-align:right;padding-top:5px;">
            <asp:DropDownList ID="dropListingOrdering" AutoPostBack="true" OnSelectedIndexChanged="dropListingOrdering_SelectedIndexChanged" runat="server">
            <asp:ListItem meta:resourcekey="optTitle" Value="title" Text="Title"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optAuthor" Value="owner" Text="Author"></asp:ListItem>                                
            <asp:ListItem meta:resourcekey="optPersonLastUpdating" Value="last_updated_by" Text="Person Last Updating"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optPublishDate" Value="first_published_date" Text="Publish Date"></asp:ListItem>            
            <asp:ListItem meta:resourcekey="optLastUpdatedDate" Value="last_updated_date" Text="Last Updated Date"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optRating" Value="rating" Text="Rating"></asp:ListItem>     
            <asp:ListItem meta:resourcekey="optComments" Value="comments" Text="Comments"></asp:ListItem>  
            <asp:ListItem meta:resourcekey="optDownloadSize" Value="file_size" Text="Download Size"></asp:ListItem>         
            <asp:ListItem meta:resourcekey="optTotalDownloads" Value="total_downloads" Text="Total Downloads"></asp:ListItem> 
            <asp:ListItem meta:resourcekey="optDownloadsToday" Value="downloads_today" Text="Downloads Today"></asp:ListItem>  
            <asp:ListItem meta:resourcekey="optTotalHits" Value="total_hits" Text="Total Hits"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optHitsToday" Value="hits_today" Text="Hits Today"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optPrice" Value="current_price" Text="Price"></asp:ListItem>
            </asp:DropDownList>        
        </td>
        </tr>
        </table>      
         
        <div style="margin-top:5px;margin-bottom:5px">
            <asp:Literal id="litDataListHeader" runat="server"></asp:Literal>
            <asp:DataList ID="dlDataList" Width="100%" runat="server"></asp:DataList>
            <asp:Literal id="litDataListFooter" runat="server"></asp:Literal>
        </div>        
        
        <table id="panelQuickAdd" summary="" runat="server" cellpadding="2" cellspacing="0" style="background:white;border:#E0E0E0 1px solid;margin-top:15px;margin-bottom:15px;">
        <tr>
            <td rowspan="5" valign="top" style="padding-top:3px">
            <img src="systems/images/ico_quickadd.gif" />
            </td>
            <td colspan="3" style="padding-top:3px">
            <asp:Label runat="server" id="lblQuickAdd" meta:resourcekey="lblQuickAdd" Text="Quick Add" Font-Bold="True"></asp:Label>
            </td>
        </tr>
        <tr>
            <td><asp:Label runat="server" id="lblQuickTitle" meta:resourcekey="lblQuickTitle" Text="Title"></asp:Label></td><td>:</td>
            <td><asp:TextBox runat="server" id="txtQuickTitle"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="QuickAdd" ControlToValidate="txtQuickTitle" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td><asp:Label runat="server" id="lblQuickSummary" meta:resourcekey="lblQuickSummary" Text="Summary"></asp:Label></td><td>:</td>
            <td><asp:TextBox runat="server" id="txtQuickSummary"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label runat="server" id="lblQuickFile" meta:resourcekey="lblQuickFile" Text="File"></asp:Label></td><td>:</td>
            <td style="padding-right:7px"><asp:FileUpload runat="server" id="fileQuick"></asp:FileUpload></td>
        </tr>
        <tr>
            <td style="padding-bottom:7px">
            <asp:Button id="btnQuickAdd" ValidationGroup="QuickAdd" meta:resourcekey="btnQuickAdd" runat="server" Text="   Publish   "></asp:Button>
            </td><td colspan="2">&nbsp;</td>
        </tr>
        </table>
        
        
        <div id="idDataListFooter" runat="server">
        <asp:HiddenField ID="hidPageIndex" Value="0" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="hidPageCount"  runat="server"></asp:HiddenField>

        <div class="paging">
        <asp:LinkButton ID="pgDataListFirst2" meta:resourcekey="pgDataListFirst" runat="server">First</asp:LinkButton> <span style="color:#ACA899">|</span>
        <asp:LinkButton ID="pgDataListPrevious2" meta:resourcekey="pgDataListPrevious" runat="server">Prev</asp:LinkButton> <span style="color:#ACA899">|</span>
        <asp:Label font-bold="true" id="lblDataListPagingInfo2" runat="server" Text=""></asp:Label> <span style="color:#ACA899">|</span>
        <asp:LinkButton ID="pgDataListNext2" meta:resourcekey="pgDataListNext" runat="server">Next</asp:LinkButton> <span style="color:#ACA899">|</span>
        <asp:LinkButton ID="pgDataListLast2" meta:resourcekey="pgDataListLast" runat="server">Last</asp:LinkButton>
        </div> 
        </div> 
            
    </asp:Panel> 
    </div>   
</asp:Content>

<asp:Content ID="contentPlaceholderBody" ContentPlaceHolderID="placeholderBody" runat="server">
    <asp:Literal id="litBodyStart" runat="server"></asp:Literal>

    <!-- LOGIN -->
    <asp:Panel ID="panelLogin" runat="server" Visible="False">
    <asp:Login ID="Login1" meta:resourcekey="Login1" runat="server" PasswordRecoveryText="Password Recovery" TitleText="" OnPreRender="Login1_PreRender">
        <LabelStyle HorizontalAlign="Left" Wrap="False" />
    </asp:Login>
    <br />
    </asp:Panel>
    
    <!-- MODULE TOP -->
    <asp:Panel ID="panelModuleTop" runat="server" />    
    
    <!-- CONTENT VIEW -->    
    <asp:Panel ID="panelBody" runat="server" />
   
    <!-- MODULE BOTTOM -->
    <asp:Panel ID="panelModuleBottom" runat="server" />    
    
    <asp:Literal id="litBodyEnd" runat="server"></asp:Literal>

</asp:Content>

<asp:Content ID="contentPlaceholderAuthoring" ContentPlaceHolderID="placeholderAuthoring" runat="server">
 
    <!-- AUTHORING -->
    <asp:HiddenField ID="hidLinkPlacement" runat="server" Value="" />
    <asp:Panel ID="panelAuthoring" runat="server" Visible=false>

        <table summary="" cellpadding="5" cellspacing="0" border="0">
        <!-- Url -->
        <tr runat=server ID=panelUrl>
            <td style="padding-top:3px"><asp:Label ID="lblUrl" meta:resourcekey="lblUrl" runat="server" Text="URL"></asp:Label></td>
            <td>:</td>
            <td nowrap="nowrap"> 
                <asp:Label ID="lblBaseHref" runat="server" Text=""></asp:Label><asp:Label ID="lblFileName3" runat="server" Text=""></asp:Label>          
                <asp:TextBox ID="txtFileName" runat="server" width="70px" MaxLength="50"></asp:TextBox> 
                <asp:Label ID="lblAspx" runat="server" Text=".aspx"></asp:Label> &nbsp;
                <asp:Label ID="lblFileExistsLabel" meta:resourcekey="lblFileExistsLabel" runat="server" Text="File already exists." ForeColor=red Visible=false></asp:Label>           
            </td>
        </tr>
               
        <!-- Title -->
        <tr>
            <td><asp:Label ID="lblTitle" meta:resourcekey="lblTitle" runat="server" Text="Title"></asp:Label></td>
            <td>:</td>
            <td width="100%">
                <table summary="" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                <td style="white-space:nowrap">
                <asp:TextBox ID="txtTitle" runat="server" width="250px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv2" runat="server" ErrorMessage="*" ValidationGroup="Authoring" ControlToValidate="txtTitle" ></asp:RequiredFieldValidator> 
            
                
                </td>
                <td style="text-align:right;white-space:nowrap">
                <asp:Panel ID="panelNormalOrLinked" Visible="false" runat="server">                 
                    <asp:RadioButton ID="rdoNormalPage" meta:resourcekey="rdoNormalPage" Value="1" Text="Normal Page" Checked=True runat="server" GroupName="NormalOrLinked"></asp:RadioButton>
                    <asp:RadioButton ID="rdoLinkedPage" meta:resourcekey="rdoLinkedPage" Value="2" Text="Linked Page" runat="server" GroupName="NormalOrLinked"></asp:RadioButton>
                </asp:Panel>
                </td>
                </tr>
                </table>            
            </td>
        </tr>
        
        <!-- Summary -->
        <tr runat=server id="panelSummary" visible=false>
            <td colspan="3">
            <fieldset id="fldsetSummary" runat="server" style="padding:14px;padding-top:0px;">
                <legend>
                    <asp:Literal meta:resourcekey="lblSummary" runat="server"></asp:Literal>
                </legend>
                <br />
                <table summary="" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                <td valign="top" style="padding-bottom:4px">
                    <asp:LinkButton ID="lnkAdvEdit2" meta:resourcekey="lnkAdvEdit" runat="server" onclick="lnkAdvance">Advanced Mode</asp:LinkButton>               
                    <asp:LinkButton ID="lnkQuickEdit2" meta:resourcekey="lnkQuickEdit" runat="server" Visible=false onclick="lnkQuick">Quick Mode</asp:LinkButton> 
                </td>
                <td align="right" valign="top" style="padding-bottom:4px">
                    <table summary="" cellpadding="0" cellspacing="0">
                    <tr>
                    <td style="padding-left:3px;padding-right:3px;padding-top:1px">
                        <asp:Label ID="lblInsertPageResources2" meta:resourcekey="lblInsertPageResources" runat="server" Text="Insert:"></asp:Label>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <img src="systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertPageLinks2" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <img src="systems/images/ico_InsertResources.gif" style="margin-top:3px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertResources2" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
                    </td>
                    </tr>
                    </table>                    
                </td>
                </tr>
                <tr>
                  <td colspan ="3">
                    <editor:WYSIWYGEditor runat="server" ID="txtSummary" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="240" HeightAdjustment="-80" QuickHeightAdjustment="-20" Text="" />
                    <div style="text-align:right;font-style:italic;font-size:8pt;padding-top:4px;">
                        <asp:Literal id="litSummaryNote" meta:resourcekey="litSummaryNote" runat="server"></asp:Literal>
                    </div>
                  </td>
                </tr>                
                </table>
            </fieldset>
            </td>
        </tr>
        <tr runat=server id="panelSummarySource" visible=false>
            <td colspan="3">
            <fieldset id="fldsetSummarySrc" runat="server" style="padding:14px;padding-top:0px;width:90%">
                <legend>
                    <asp:Literal meta:resourcekey="lblSummary" runat="server"></asp:Literal>
                </legend>
                <br />
                <asp:TextBox ID="txtSummary2" Width="99%" Height="150" TextMode="MultiLine" runat="server"></asp:TextBox>
            </fieldset>
            </td>
        </tr>
        <%--
        <tr runat=server id="panelSummary" visible=false>
            <td valign="top"><asp:Label ID="lblSummary" meta:resourcekey="lblSummary" runat="server" Text="Summary"></asp:Label></td>
            <td valign="top">:</td>
            <td>
                <table summary="" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                <td valign="top">
                    <asp:LinkButton ID="lnkAdvEdit2" meta:resourcekey="lnkAdvEdit" runat="server" onclick="lnkAdvance">Advanced Mode</asp:LinkButton>               
                    <asp:LinkButton ID="lnkQuickEdit2" meta:resourcekey="lnkQuickEdit" runat="server" Visible=false onclick="lnkQuick">Quick Mode</asp:LinkButton> 
                </td>
                <td align="right" valign="top">
                    <table summary="" cellpadding="0" cellspacing="0">
                    <tr>
                    <td style="padding-left:3px;padding-right:3px;padding-top:1px">
                        <asp:Label ID="lblInsertPageResources2" meta:resourcekey="lblInsertPageResources" runat="server" Text="Insert:"></asp:Label>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <img src="systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertPageLinks2" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <img src="systems/images/ico_InsertResources.gif" style="margin-top:3px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertResources2" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
                    </td>
                    </tr>
                    </table>                    
                </td>
                </tr>
                <tr>
                  <td colspan ="3">
                    <editor:WYSIWYGEditor runat="server" ID="txtSummary" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="100px" Text="" />
                    <div style="text-align:right;font-style:italic;font-size:8pt;padding-bottom:7px;">Summary will be displayed on listing page.</div>
                  </td>
                </tr>                
                </table>
            
        </td>
        </tr>
        <tr runat=server id="panelSummarySource" visible=false>
            <td valign="top"><asp:Label ID="lblSummary2" meta:resourcekey="lblSummary" runat="server" Text="Summary"></asp:Label></td>
            <td valign="top">:</td>
            <td>
            
            </td>
        </tr>
        --%>

        <!-- Display Date -->
        <tr runat=server id="panelDisplayDate" visible=false>
            <td valign=top style="padding-top:7px" nowrap="nowrap">
                <asp:Label ID="lblDisplayDate" meta:resourcekey="lblDisplayDate" runat="server" Text="Display Date"></asp:Label>
            </td>
            <td valign=top style="padding-top:7px">:</td>
            <td valign=top>
                <table summary="" style="margin-top:3px;width:450px" cellpadding="0" cellspacing="0">
                <tr>
                <td><asp:RadioButton ID="rdoDateSpec" Checked="True" GroupName="dispDate" runat="server"></asp:RadioButton></td>
                <td>
                <asp:DropDownList ID="dropNewsYear" runat="server">
                <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
                <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
                <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
                <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
                <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
                <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
                <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
                <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
                <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
                <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
                <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                </asp:DropDownList>
                </td>
                <td>
                <asp:DropDownList ID="dropNewsMonth" runat="server">
                <asp:ListItem Text="1" Value="1" Selected=True></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                <asp:ListItem Text="9" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                </asp:DropDownList>
                </td>
                <td>
                <asp:DropDownList ID="dropNewsDay" runat="server">
                <asp:ListItem Text="1" Value="1" Selected=True></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem><asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem><asp:ListItem Text="5" Value="5"></asp:ListItem>
                <asp:ListItem Text="6" Value="6"></asp:ListItem><asp:ListItem Text="7" Value="7"></asp:ListItem>
                <asp:ListItem Text="8" Value="8"></asp:ListItem><asp:ListItem Text="9" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem><asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem><asp:ListItem Text="13" Value="13"></asp:ListItem>
                <asp:ListItem Text="14" Value="14"></asp:ListItem><asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="16" Value="16"></asp:ListItem><asp:ListItem Text="17" Value="17"></asp:ListItem>
                <asp:ListItem Text="18" Value="18"></asp:ListItem><asp:ListItem Text="19" Value="19"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem><asp:ListItem Text="21" Value="21"></asp:ListItem>
                <asp:ListItem Text="22" Value="22"></asp:ListItem><asp:ListItem Text="23" Value="23"></asp:ListItem>
                <asp:ListItem Text="24" Value="24"></asp:ListItem><asp:ListItem Text="25" Value="25"></asp:ListItem>
                <asp:ListItem Text="26" Value="26"></asp:ListItem><asp:ListItem Text="27" Value="27"></asp:ListItem>
                <asp:ListItem Text="28" Value="28"></asp:ListItem><asp:ListItem Text="29" Value="29"></asp:ListItem>
                <asp:ListItem Text="30" Value="30"></asp:ListItem><asp:ListItem Text="31" Value="31"></asp:ListItem>
                </asp:DropDownList>
                </td>
                <td style="white-space:nowrap">&nbsp;
                <asp:CheckBox Text="" id="chkTime" runat="server"></asp:CheckBox>&nbsp;&nbsp;
                </td>
                <td style="width:100%">
                <div id="divTime" runat="server">
                <asp:DropDownList ID="dropHour" runat="server">
                <asp:ListItem Text="01" Value="1"></asp:ListItem>
                <asp:ListItem Text="02" Value="2"></asp:ListItem>
                <asp:ListItem Text="03" Value="3"></asp:ListItem>
                <asp:ListItem Text="04" Value="4"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="06" Value="6"></asp:ListItem>
                <asp:ListItem Text="07" Value="7"></asp:ListItem>
                <asp:ListItem Text="08" Value="8"></asp:ListItem>
                <asp:ListItem Text="09" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                <asp:ListItem Text="12" Value="12"></asp:ListItem>
                <asp:ListItem Text="13" Value="13"></asp:ListItem>
                <asp:ListItem Text="14" Value="14"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="16" Value="16"></asp:ListItem>
                <asp:ListItem Text="17" Value="17"></asp:ListItem>
                <asp:ListItem Text="18" Value="18"></asp:ListItem>
                <asp:ListItem Text="19" Value="19"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="21" Value="21"></asp:ListItem>
                <asp:ListItem Text="22" Value="22"></asp:ListItem>
                <asp:ListItem Text="23" Value="23"></asp:ListItem>
                <asp:ListItem Text="24" Value="0"></asp:ListItem>
                </asp:DropDownList>&nbsp;:
                <asp:DropDownList ID="dropMinute" runat="server">
                <asp:ListItem Text="00" Value="0"></asp:ListItem>
                <asp:ListItem Text="05" Value="5"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                <asp:ListItem Text="20" Value="20"></asp:ListItem>
                <asp:ListItem Text="25" Value="25"></asp:ListItem>
                <asp:ListItem Text="30" Value="30"></asp:ListItem>
                <asp:ListItem Text="35" Value="35"></asp:ListItem>
                <asp:ListItem Text="40" Value="40"></asp:ListItem>
                <asp:ListItem Text="45" Value="45"></asp:ListItem>
                <asp:ListItem Text="50" Value="50"></asp:ListItem>
                <asp:ListItem Text="55" Value="55"></asp:ListItem>
                </asp:DropDownList>
                </div>
                </td>
                </tr>
                </table>
                <div style="margin-top:3px">
                <asp:RadioButton ID="rdoDateAuto" Text="Automatic" GroupName="dispDate" runat="server"></asp:RadioButton>                
                </div>
                <script language="javascript" type="text/javascript">
                <!--
                var _daysInMonth=[31,28,31,30,31,30,31,31,30,31,30,31];
                function isLeapYear(year) { return ((year%4) == 0);}
                function validateDate(idDate, idMonth, idYear) 
                    {
                    var year = idYear.value;
                    var month = idMonth.value;
                    var day = idDate.value;
                    
                    var numDate=_daysInMonth[month-1];
                    if (month==2 && isLeapYear(year)) numDate++;
                    if (idDate.value>numDate) {idDate.value=numDate;}    
                    }
                // -->
                </script>
            </td>
        </tr>

        <!-- Content -->
        <tr runat=server id="panelContentLabel"><td colspan="3"></td></tr>
        <tr runat=server id="panelContent">
            <td colspan="3">
            <fieldset id="fldsetContent" runat="server" style="padding:14px;padding-top:0px;">
                <legend>
                    <asp:Literal meta:resourcekey="lblContent" runat="server"></asp:Literal>
                </legend>
                <br />
                <table summary="" cellpadding="0" cellspacing="0" style="width:100%">
                <tr>
                <td style="padding-bottom:4px">
                    <asp:LinkButton ID="lnkAdvEdit" meta:resourcekey="lnkAdvEdit" runat="server" onclick="lnkAdvance">Advanced Mode</asp:LinkButton>               
                    <asp:LinkButton ID="lnkQuickEdit" meta:resourcekey="lnkQuickEdit" runat="server" Visible=false onclick="lnkQuick">Quick Mode</asp:LinkButton> 
                </td>
                <td align="right" style="padding-bottom:4px;">
                    <table summary="" cellpadding="0" cellspacing="0">
                    <tr>
                    <td style="padding-left:3px;padding-right:3px;padding-top:1px">
                        <asp:Label ID="lblInsertPageResources" meta:resourcekey="lblInsertPageResources" runat="server" Text="Insert:"></asp:Label>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertPageLinks" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertResources.gif" style="margin-top:3px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertResources" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
                    </td>
                    </tr>
                    </table>                    
                </td>
                </tr>
                </table>
                
                <asp:HiddenField ID="hidEditorPurpose" runat="server" />
                
                <div style="font-style:italic;text-align:right;font-size:9px">
                <asp:Label id="lblPutBreakTag" visible="False" meta:resourcekey="lblPutBreakTag" runat="server" Text="Put [break] tag to break up long text and place a 'Read More' link."></asp:Label>
                </div>
                
                <editor:WYSIWYGEditor runat="server" ID="txtBody" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="460" HeightAdjustment="-110" Text="" />
            </fieldset>
            </td>
        </tr>
        <tr runat=server id="panelContentSource" visible=false>
            <td colspan="3">
            <fieldset id="fldsetContentSrc" runat="server" style="padding:14px;padding-top:0px;width:90%">
                <legend>
                    <asp:Literal meta:resourcekey="lblContent2" runat="server"></asp:Literal>
                </legend>
                <br />
                <asp:TextBox ID="txtBody2" Width="99%" Height="350" TextMode="MultiLine" runat="server"></asp:TextBox>
            </fieldset>
            </td>
        </tr>
<%--        <tr runat=server id="panelContentLabel">
            <td><asp:Label ID="lblContent" meta:resourcekey="lblContent" runat="server" Text="Content"></asp:Label></td>
            <td>:</td>
            <td>
            
                <table summary="" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                <td>
                    <asp:LinkButton ID="lnkAdvEdit" meta:resourcekey="lnkAdvEdit" runat="server" onclick="lnkAdvance">Advanced Mode</asp:LinkButton>               
                    <asp:LinkButton ID="lnkQuickEdit" meta:resourcekey="lnkQuickEdit" runat="server" Visible=false onclick="lnkQuick">Quick Mode</asp:LinkButton> 
                </td>
                <td align=right>
                    <table summary="" cellpadding="0" cellspacing="0">
                    <tr>
                    <td style="padding-left:3px;padding-right:3px;padding-top:1px">
                        <asp:Label ID="lblInsertPageResources" meta:resourcekey="lblInsertPageResources" runat="server" Text="Insert:"></asp:Label>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertPageLinks.gif" style="margin-top:5px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertPageLinks" meta:resourcekey="lnkInsertPageLinks" runat="server">Page Links</asp:LinkButton>&nbsp;
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <IMG SRC="systems/images/ico_InsertResources.gif" style="margin-top:3px" />
                    </td>
                    <td style="padding-left:3px;padding-right:3px;">
                        <asp:LinkButton ID="lnkInsertResources" meta:resourcekey="lnkInsertResources" runat="server">Resources</asp:LinkButton>
                    </td>
                    </tr>
                    </table>                    
                </td>
                </tr>
                </table>
                
            </td>
        </tr>
        <tr runat=server id="panelContent">   
            <td colspan="3" style="padding-bottom:10px;padding-top:0px" nowrap="nowrap">            
                <asp:HiddenField ID="hidEditorPurpose" runat="server" />
                
                <div style="font-style:italic;text-align:right;font-size:9px">
                <asp:Label id="lblPutBreakTag" visible="False" meta:resourcekey="lblPutBreakTag" runat="server" Text="Put [break] tag to break up long text and place a 'Read More' link."></asp:Label>
                </div>
                
                <editor:WYSIWYGEditor runat="server" ID="txtBody" scriptPath="systems/editor/scripts/" EditMode="XHTMLBody" Width="100%" Height="280px" Text="" />
            </td>
        </tr>        
        <tr runat=server id="panelContentSource" visible=false>
            <td colspan="3" style="padding-bottom:10px;padding-top:0px" nowrap="nowrap"> 
                <asp:Label ID="lblContent2" meta:resourcekey="lblContent2" runat="server" Text="Content"></asp:Label> :
                <div style="height:5px"></div>          
                <asp:TextBox ID="txtBody2" Width="99%" Height="300" TextMode="MultiLine" runat="server"></asp:TextBox>
            </td>
        </tr>--%>
        
        <tr runat=server id="panelContentLink" style="display:none">
            <td style="white-space:nowrap"> 
                <asp:Label ID="lblLinkTo" meta:resourcekey="lblLinkTo" runat="server" Text="Link To"></asp:Label>
            </td>
            <td>:</td>
            <td>        
                <asp:TextBox ID="txtLinkTo" Text="http://" Width="250px" runat="server"></asp:TextBox>
                <asp:CheckBox ID="chkLinkNewWindow" meta:resourcekey="chkLinkNewWindow" Text="Opens new window" runat="server"></asp:CheckBox>
            </td>
        </tr>        
        
        <!-- Sorting -->
        <tr runat=server id="panelListOrdering">
            <td valign="top" style="white-space:nowrap">
                <asp:Label ID="lblPageOrder" meta:resourcekey="lblPageOrder" runat="server" Text="Page Order"></asp:Label>
            </td>
            <td valign="top">:</td>
            <td colspan="3" style="padding-bottom:5px">
                <table summary="" cellpadding="0" cellspacing="0" style="margin-top:3px">
                <tr>
                <td>
                <asp:HiddenField ID="hidRefPos" runat="server" Value="UNDER" />
                <asp:HiddenField ID="hidRefPage" runat="server" Value="" />
                <asp:ListBox ID="lstOrdering" runat="server" width="205px"></asp:ListBox>
                </td>
                <td style="padding:2px">
                <asp:Button id="btnUp" meta:resourcekey="btnUp" runat="server" Text=" Up " Width="70px"></asp:Button><br />
                <asp:Button id="btnDown" meta:resourcekey="btnDown" runat="server" Text=" Down " Width="70px"></asp:Button>                
                </td>
                </tr>
                </table>   
                
                <script language="JavaScript" type="text/javascript">
                <!--
                function _doUp(oList,oRefPage,oRefPos)
                    {
                    oList.value = "new";
                    var selIdx = oList.selectedIndex;
                    if (selIdx<=0) return;
                    var tmpOpt = oList.options[selIdx-1];
                    var opt = new Option();
                    opt.value=oList.options[selIdx].value;
                    opt.text = oList.options[selIdx].text;
                    oList.options[selIdx-1] = opt;
                    oList.options[selIdx] = tmpOpt;
                    oList.selectedIndex = selIdx-1;

                    oRefPage.value=tmpOpt.value; //ref page
                    oRefPos.value="BEFORE"; // ref pos :under, before, after
                    }
                function _doDown(oList,oRefPage,oRefPos)
                    {
                    oList.value = "new";
                    var selIdx = oList.selectedIndex;
                    if (selIdx<0 || selIdx==oList.options.length-1) return;
                    var tmpOpt = oList.options[selIdx+1];
                    var opt = new Option();
                    opt.value = oList.options[selIdx].value;
                    opt.text = oList.options[selIdx].text;
                    oList.options[selIdx+1] = opt;
                    oList.options[selIdx] = tmpOpt; 
                    oList.selectedIndex = selIdx+1;

                    oRefPage.value=tmpOpt.value; //ref page
                    oRefPos.value="AFTER"; // ref pos :under, before, after
                    }
                // -->
                </script>
                
            </td>
        </tr>
        
        <!-- LISTING Category -->
        <tr runat=server id="panelListingCategory" visible="false">
            <td valign="top">
                <asp:Label ID="lblListingCategory" meta:resourcekey="lblListingCategory" runat="server" Text="Category"></asp:Label>
            </td>
            <td valign="top">:</td>
            <td>
            <asp:ListBox id="dropListingCategory" SelectionMode="Multiple" runat="server"></asp:ListBox>            
            </td>
        </tr>
        
        <tr runat="server" id="panelAddFile">
            <td colspan="3">
            <asp:CheckBox ID="chkAddFile" meta:resourcekey="chkAddFile" runat="server" Text="Add File"></asp:CheckBox><br />
            <table summary="" runat="server" ID="tblAddFile" cellpadding="0" cellspacing="0" style="display:none;margin-left:22px;margin-top:7px;margin-bottom:7px">
            <tr>
            <td valign="top" style="padding-right:10px;">
                <div style="padding-bottom:3px">
                    <asp:Label id="lblFileDownload" meta:resourcekey="lblFileDownload" Text="FILE DOWNLOAD" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
                </div>
                <div style="padding-bottom:3px">
                    <asp:FileUpload id="fileDownload" runat="server"></asp:FileUpload>
                </div>                
                <div>                    
                    <asp:Literal ID="litDownloadThumb" runat="server"></asp:Literal>
                </div>
                <div>
                    <asp:Label ID="lblDownloadFileName" runat="server"></asp:Label>
                </div>                
                <div>
                    <asp:CheckBox id="chkDelDownload" meta:resourcekey="chkDelDownload" runat="server" Visible="false" Text="Delete File"></asp:CheckBox>
                </div>
                <br />
            </td>
            <td></td>
            </tr>
            <tr>
            <%--<td valign="top" style="padding-right:10px;padding-left:10px;border-left:#cccccc 1px solid">--%>
            <td valign="top" style="padding-right:10px;">
                <div style="padding-bottom:3px">
                    <asp:Label id="lblPreviewOnPage" meta:resourcekey="lblPreviewOnPage" Text="PREVIEW ON PAGE" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
                    <asp:Label id="lblPreviewOnPage_FileType" runat="server" Font-Size="9px" Text="(FLV, MP3, JPG, GIF, PNG)"></asp:Label>
                </div>
                <div style="padding-bottom:3px">
                    <asp:FileUpload id="fileView" runat="server"></asp:FileUpload>
                </div>                
                <div>                    
                    <asp:Literal ID="litViewThumb" runat="server"></asp:Literal>
                </div>
                <div>
                    <asp:Label ID="lblViewFileName" runat="server"></asp:Label>
                </div>                
                <div>
                    <asp:CheckBox id="chkDelView" meta:resourcekey="chkDelDownload" runat="server" Visible="false" Text="Delete File"></asp:CheckBox>
                </div>
                
            </td>
            <td id="idPreviewOnListing" runat="server" valign="top" style="padding-left:10px;border-left:#cccccc 1px solid">
                <div style="padding-bottom:3px">
                    <asp:Label id="lblPreviewOnListing" meta:resourcekey="lblPreviewOnListing" Text="PREVIEW ON LISTING" Font-Size="9px" Font-Bold="True" runat="server"></asp:Label>
                    <asp:Label id="lblPreviewOnListing_FileType" runat="server" Font-Size="9px" Text="(JPG, GIF, PNG)"></asp:Label>
                </div> 
                <div style="padding-bottom:3px">
                    <asp:FileUpload id="fileViewListing" runat="server"></asp:FileUpload>
                    <asp:DropDownList id="dropResize" runat="server">
                        <asp:ListItem Text="100x100 pixels" Value="100" Selected=True></asp:ListItem>
                        <asp:ListItem Text="120x120 pixels" Value="120"></asp:ListItem>
                        <asp:ListItem Text="150x150 pixels" Value="150"></asp:ListItem>
                        <asp:ListItem Text="175x175 pixels" Value="175"></asp:ListItem>
                        <asp:ListItem Text="200x200 pixels" Value="200"></asp:ListItem>
                        <asp:ListItem Text="225x225 pixels" Value="225"></asp:ListItem>
                        <asp:ListItem Text="250x250 pixels" Value="250"></asp:ListItem>
                        <asp:ListItem Text="Actual Size" meta:resourcekey="optActualSize" Value="0"></asp:ListItem>
                    </asp:DropDownList>                       
                </div>                
            
                <div>                    
                    <asp:Literal ID="litViewListingThumb" runat="server"></asp:Literal>
                </div>
                <div>
                    <asp:Label ID="lblViewListingFileName" runat="server"></asp:Label>
                </div>                
                <div>
                    <asp:CheckBox id="chkDelViewListing" meta:resourcekey="chkDelDownload" runat="server" Visible="false" Text="Delete File"></asp:CheckBox>
                </div>
                
            </td>            
            </tr>
            </table>            
            </td>
        </tr>
                
        <tr runat=server id="panelListingConfig">
            <td colspan="3">
            <asp:CheckBox ID="chkIsListing" meta:resourcekey="chkIsListing" runat="server" Text="Make this page a listing/gallery"></asp:CheckBox><br />
            <table summary="" runat="server" ID="tblListingConfig" cellpadding="0" cellspacing="0" style="margin-left:16px;margin-top:7px;margin-bottom:7px">
            <tr>
            <td>
                <table summary="" cellpadding="4" cellspacing="0">               
                <tr>
                <td><asp:Label runat="server" ID="lblListingTemplate" meta:resourcekey="lblListingTemplate" Text="Template"></asp:Label></td>
                <td>:</td>
                <td>
                <asp:DropDownList ID="dropListingTemplates" runat="server">
                </asp:DropDownList>
                </td>
                </tr>
                </table>
            </td>
            </tr>
            </table> 
            </td>
        </tr>   
             
        <!-- Optional -->
        <tr>
            <td colspan="3" style="padding-top:10px">
            
                <table summary="" style="background-image:url('systems/images/bg_box3.gif');border:#D4D6DD 3px solid;width:410px">
                
                <tr runat=server id="panelOptional">
                <td style="padding:10px;padding-right:0px" nowrap="nowrap">
                <asp:Label ID="lblOptionalSettings" meta:resourcekey="lblOptionalSettings" runat="server" Text="Optional Settings" Font-Bold=true></asp:Label>
                </td>
                <td style="font-weight:bold">:</td>
                <td style="padding:10px" nowrap="nowrap">
                <asp:LinkButton ID=lnkPageProperties meta:resourcekey="lnkPageProperties" runat="server" text="Page Properties"></asp:LinkButton>&nbsp;&nbsp;
                <asp:LinkButton ID=lnkPublishingDate meta:resourcekey="lnkPublishingDate" runat="server" text="Publishing Schedule"></asp:LinkButton>&nbsp;&nbsp;
                <asp:LinkButton ID="lnkAdditionalContent" meta:resourcekey="lnkAdditionalContent" runat="server" text="Additional Content"></asp:LinkButton>&nbsp;&nbsp;
                <asp:LinkButton ID="lnkPageShop" meta:resourcekey="lnkPageShop" runat="server" text="Shop"></asp:LinkButton>&nbsp;&nbsp;
                <asp:LinkButton ID=lnkCustomProperties meta:resourcekey="lnkCustomProperties" runat="server" text="Custom Properties"></asp:LinkButton>
                </td>
                </tr>
                </table>
            
            </td>
        </tr>           
       
        <!-- Advanced Save Buttons -->
        <tr id="panelAdvancedSave" runat=server>
            <td colspan="3" nowrap="nowrap" valign="baseline" style="padding-top:15px">              
            
                <asp:Panel ID="panelSaveOptions" runat="server">                    
                    <asp:Label id="lblSelectAction" meta:resourcekey="lblSelectAction" runat="server" Text="Select action after saving.."></asp:Label>
                    <div style="margin:3px"></div>
                    <asp:RadioButtonList ID="rdoSavingOptions" runat="server">
                        <asp:ListItem meta:resourcekey="optNone" Value=1 Text=" None (Continue editing)." Selected=True></asp:ListItem>
                        <asp:ListItem meta:resourcekey="optFinishLock" Value=3 Text=" Finish & Lock for Later Editing (Other users won't be able to edit this page)."></asp:ListItem>
                        <asp:ListItem meta:resourcekey="optFinishUnlock" Value=2 Text=" Finish & Unlock (Other users will be able to edit this page)."></asp:ListItem>
                        <asp:ListItem meta:resourcekey="optSend" Value=4 Text=" Send for Publishing or Approval."></asp:ListItem>
                    </asp:RadioButtonList>
                    <br />
                </asp:Panel>
               
                <asp:Button ID="btnCreatePage" meta:resourcekey="btnCreatePage" runat="server" Text=" Create Page " visible=false ValidationGroup="Authoring"></asp:Button>
                <asp:Button ID="btnCreateAndPublishPage" meta:resourcekey="btnCreateAndPublishPage" runat="server" Text=" Publish " visible=false ValidationGroup="Authoring"></asp:Button>
                <asp:Button ID="btnSave" meta:resourcekey="btnSave" runat="server" Text="  Save  " visible=false ValidationGroup="Authoring"></asp:Button>
                <asp:Button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " visible=false></asp:Button>
            
            </td>
        </tr>
        
        <!-- Simple Save Buttons -->
        <tr id="panelSimpleSave" runat=server>
            <td colspan="3" nowrap="nowrap" valign=baseline style="padding-top:15px">
                <asp:Button ID="btnCreatePage2" meta:resourcekey="btnCreatePage2" runat="server" Text=" Create Page " ValidationGroup="Authoring" />
                <asp:Button ID="btnCreateAndPublishPage2" meta:resourcekey="btnCreateAndPublishPage" runat="server" Text=" Publish " visible=false ValidationGroup="Authoring"></asp:Button>
                <asp:Button ID="btnSave2" meta:resourcekey="btnSave2" runat="server" Text="  Save  " ValidationGroup="Authoring" />
                <asp:Button ID="btnSaveAndFinish" meta:resourcekey="btnSaveAndFinish" runat="server" Text=" Save & Finish " ValidationGroup="Authoring" />
                <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" runat="server" Text=" Send for Review " ValidationGroup="Authoring"/>
                <asp:Button ID="btnCancel2" meta:resourcekey="btnCancel2" runat="server" Text=" Cancel " />
            </td>
        </tr>
        </table>

        <br />  
    </asp:Panel>
    
    <!-- RENAME -->
    <asp:Panel ID="panelRename" runat="server" Visible=false>     
        <table summary="" cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td valign="baseline"><asp:Label id="lblUrl2" meta:resourcekey="lblUrl" runat="server" Text="URL"></asp:Label></td>
            <td valign="baseline">:</td>
            <td valign="baseline" style="white-space:nowrap">
                <asp:Label ID="lblBaseHref2" runat="server" Text=""></asp:Label>
                <asp:TextBox id="txtFileName2" width="90px" runat="server"></asp:TextBox>
                .aspx &nbsp;
                <asp:Label ID="lblFileExistsLabel2" meta:resourcekey="lblFileExistsLabel" runat="server" Text="File already exists." ForeColor=red Visible=false></asp:Label>           
            </td>
        </tr>
        <tr>
            <td colspan="3" valign="baseline" style="padding-top:15px;white-space:nowrap">
                <asp:Button ID="btnRename" meta:resourcekey="btnRename" runat="server" Text=" Update " />
                <asp:Button ID="btnCancel4" meta:resourcekey="btnCancel4" runat="server" Text=" Cancel " />
            </td>
        </tr>
        </table>
        <br /> 
    </asp:Panel>
    
    <!-- DELETE -->
    <asp:Panel ID="panelDelete" runat="server" Visible=false>  
        <p>
        <asp:Label ID="lblDeleteConfirm" meta:resourcekey="lblDeleteConfirm" runat="server" Text="Are you sure you wish to delete this page?"></asp:Label>
        </p>        
        <asp:Button ID="btnDelete" meta:resourcekey="btnDelete" runat="server" Text=" Delete "></asp:Button>
        <asp:Button ID="btnDeleteCancel" meta:resourcekey="btnDeleteCancel" runat="server" Text=" Cancel " />
        <br /><br />
    </asp:Panel>
    <asp:Panel ID="panelDeleteNotAllowed" runat="server" Visible=false>  
        <p>
        <asp:Label ID="lblDeleteNotAllowed" meta:resourcekey="lblDeleteNotAllowed" runat="server" Text="The page can't be deleted as it has one or more sub pages."></asp:Label>
        </p>        
        <asp:Button ID="btnBackToPage" meta:resourcekey="btnBackToPage" runat="server" Text=" Back to page " />
        <br /><br />
    </asp:Panel>
       
    <!-- MOVE (STEP 1) -->
    <asp:Panel ID="panelMoveStep1" runat="server" Visible=false>
        <p>
        <!--Please select a menu under which you'd like to place this page.-->
        <asp:Label ID="lblMoveStep1" meta:resourcekey="lblMoveStep1" Font-Bold=true runat="server" Text="Please select a new position:"></asp:Label>
        </p>
        
        <asp:Label id="lblTopNavigation" meta:resourcekey="lblTopNavigation" runat="server" Font-Bold=true Text="Top Navigation"></asp:Label>
        <div style="margin:3px"></div>
        <asp:TreeView ID="treeTop" runat="server" ShowLines=true></asp:TreeView><br /> 
        <asp:Label id="lblMainNavigation" meta:resourcekey="lblMainNavigation" runat="server" Font-Bold=true Text="Main Navigation"></asp:Label>
        <div style="margin:3px"></div>       
        <asp:TreeView ID="treeMain" runat="server" ShowLines=true></asp:TreeView><br />
        <asp:Label id="lblBottomNavigation" meta:resourcekey="lblBottomNavigation" runat="server" Font-Bold=true Text="Bottom Navigation"></asp:Label>
        <div style="margin:3px"></div>
        <asp:TreeView ID="treeBottom" runat="server" ShowLines=true></asp:TreeView><br />
        <asp:Button ID="btnMoveStep1Cancel" meta:resourcekey="btnMoveStep1Cancel" runat="server" Text=" Cancel " /><br /><br />      
    </asp:Panel>     
    
    <!-- MOVE (STEP 2) -->
    <asp:Panel ID="panelMoveStep2" runat="server" Visible=false>
        <p>
        <asp:Label ID="lblMoveStep2" Font-Bold=true meta:resourcekey="lblMoveStep2" runat="server" Text="Now you can specify the ordering here:"></asp:Label>
        </p>
        <table summary="" >
        <tr>
            <td>         
                <asp:HiddenField ID="hidMoveRefPos" runat="server" Value="UNDER" />
                <asp:HiddenField ID="hidMoveRefPage" runat="server" Value="" />
                <asp:ListBox ID="lstMoveOrdering" Rows=5 Width="200px" runat="server"></asp:ListBox>
            
                <script language="JavaScript" type="text/javascript">
                <!--
                function _doUp(oList,oRefPage,oRefPos)
                    {
                    oList.value = "new";
                    var selIdx = oList.selectedIndex;
                    if (selIdx<=0) return;
                    var tmpOpt = oList.options[selIdx-1];
                    var opt = new Option();
                    opt.value=oList.options[selIdx].value;
                    opt.text = oList.options[selIdx].text;
                    oList.options[selIdx-1] = opt;
                    oList.options[selIdx] = tmpOpt;
                    oList.selectedIndex = selIdx-1;

                    oRefPage.value=tmpOpt.value; //ref page
                    oRefPos.value="BEFORE"; // ref pos :under, before, after
                    }
                function _doDown(oList,oRefPage,oRefPos)
                    {
                    oList.value = "new";
                    var selIdx = oList.selectedIndex;
                    if (selIdx<0 || selIdx==oList.options.length-1) return;
                    var tmpOpt = oList.options[selIdx+1];
                    var opt = new Option();
                    opt.value = oList.options[selIdx].value;
                    opt.text = oList.options[selIdx].text;
                    oList.options[selIdx+1] = opt;
                    oList.options[selIdx] = tmpOpt; 
                    oList.selectedIndex = selIdx+1;

                    oRefPage.value=tmpOpt.value; //ref page
                    oRefPos.value="AFTER"; // ref pos :under, before, after
                    }
                // -->
                </script>
            </td>
            <td>
                <asp:Button id="btnMoveUp" meta:resourcekey="btnMoveUp" runat="server" Text=" Up " Width="70px"></asp:Button><br />
                <asp:Button id="btnMoveDown" meta:resourcekey="btnMoveDown" runat="server" Text=" Down " Width="70px"></asp:Button>                
            </td>
        </tr>
        <tr>
            <td style="padding-top:10px">
                <asp:Button ID="btnMove" meta:resourcekey="btnMove" runat="server" Text="  Move  " />  
                <asp:Button ID="btnMoveStep2Cancel" meta:resourcekey="btnMoveStep2Cancel" runat="server" Text=" Cancel " />                
            </td>
        </tr>
        </table> 
        <br />               
    </asp:Panel>
    
    <!-- MOVE (Ver 2) -->
    <asp:Panel runat="server" ID="panelMoveVer2"  Visible=false > 
    <table summary="" >
      <tr>
        <td>
          <asp:DropDownList ID="ddlMove" runat="server" style="display:block ">
            <asp:ListItem meta:resourcekey="optUnder" Text="Under" Value="Under" Selected=True></asp:ListItem>
            <asp:ListItem meta:resourcekey="optBefore" Text="Before" Value="Before"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optAfter" Text="After" Value="After"></asp:ListItem>
          </asp:DropDownList>
          <asp:DropDownList ID="ddlMove2" runat="server" style="display:none">
            <asp:ListItem meta:resourcekey="optMain" Text="Main" Value="main" Selected=True></asp:ListItem>
            <asp:ListItem meta:resourcekey="optTop" Text="Top" Value="top"></asp:ListItem>
            <asp:ListItem meta:resourcekey="optBottom" Text="Bottom" Value="bottom"></asp:ListItem>
          </asp:DropDownList>
          <script language="javascript" type="text/javascript">
          <!--
            function HideShow(oEl1,oEl2)
              {
              oEl1.style.display="none";
              oEl2.style.display="block";
              }
            // -->
          </script>
        </td>
        <td>
          <asp:TextBox ID="txtFileNameMove" runat="server" ></asp:TextBox>
        </td>
      </tr>
      <tr>
        <td>
          <asp:Button ID="btnMove3" meta:resourcekey="btnMove3" runat="server" Text=" Move "></asp:Button>
        </td>
        <td>
          <asp:Button ID="btnCancel3" meta:resourcekey="btnCancel3" runat="server" Text=" Cancel "></asp:Button>
        </td>
      </tr>
    </table>
    
    </asp:Panel>
           
</asp:Content>

<asp:Content ID="contentPlaceholderRight" ContentPlaceHolderID="placeholderRight" runat="server">
</asp:Content>

<asp:Content ID="contentPlaceholderPageInfo" ContentPlaceHolderID="placeholderPageInfo" runat="server">

    <table summary="" cellpadding="0" cellspacing="0" style="width:470px;margin-bottom:5px">
    <tr>
    <td style="background-image:url('systems/images/pageinfo_topleft.gif');">
    <div style="width:16px;height:25px"></div>
    </td>
    <td valign="bottom" style="width:100%;font-size:x-small;font-family:verdana;font-weight:bold;color:white;padding-bottom:4px;background-image:url('systems/images/pageinfo_topcenter.gif');">
    <asp:Literal ID="litPageInfo" meta:resourcekey="litPageInfo" runat="server"></asp:Literal>
    </td>
    <td style="background-image:url('systems/images/pageinfo_topright.gif');">
    <div style="width:16px;height:25px"></div>
    </td>
    </tr>
    <tr>
    <td colspan="3" valign="top" style="border:#9FAEB0 1px solid;border-top:none;padding:1px;padding-top:0px;background:#E6E7E8;">
<%--    <div runat=server id="panelAuthoringLinks" style="height:57px;border:#9BAFCA 1px solid;border-bottom:none;background:url('systems/images/pageinfo_bg.gif') repeat-x #E1E5E8;padding-left:5px">--%>
        <div runat=server id="panelAuthoringLinks" style="height:57px;border:#9BAFCA 1px solid;border-bottom:none;background:#FFFFFF;padding-left:5px">
            <asp:ImageButton ID="lnkNewPage" meta:resourcekey="imgAddNew" CausesValidation=false runat="server"></asp:ImageButton>

            <asp:ImageButton ID="lnkEdit" meta:resourcekey="imgEdit" CausesValidation="false" runat="server"></asp:ImageButton>
            <asp:ImageButton ID="lnkRename" meta:resourcekey="imgRename" CausesValidation="false" runat="server"></asp:ImageButton>
            <asp:ImageButton ID="lnkDelete" meta:resourcekey="imgDelete" CausesValidation="false" runat="server"></asp:ImageButton>
            <asp:ImageButton ID="lnkMove" meta:resourcekey="imgMove" CausesValidation="false" runat="server"></asp:ImageButton>
            <asp:ImageButton ID="lnkSubmit" meta:resourcekey="imgSubmit" CausesValidation="false" runat="server"></asp:ImageButton>
        </div>
        <div runat=server id="panelApprovalInfo" style="font-size:x-small;font-family:verdana;padding-left:7px;padding-top:3px;border:#9BAFCA 1px solid;border-top:none;border-bottom:none;">
            
            <table summary="" cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
            <td valign="top">
            <div style="width:90px;font-size:x-small;font-family:verdana;">
            <asp:Label ID="lblPageStatusLabel" meta:resourcekey="lblPageStatusLabel" runat="server" Text="Page Status"></asp:Label>
            </div>
            </td>
            <td valign="top" style="font-size:x-small;font-family:verdana;">:</td>
            <td style="width:100%;padding-left:4px;font-size:x-small;font-family:verdana;">
                <asp:Label ID="lblPageStatus" runat="server" Text=""></asp:Label>
                <asp:LinkButton ID="lnkForceUnlock" meta:resourcekey="lnkForceUnlock" CausesValidation=false runat="server">Force Unlock</asp:LinkButton>
                <asp:LinkButton ID="lnkUnlock" meta:resourcekey="lnkUnlock" CausesValidation=false runat="server">Unlock</asp:LinkButton>
                &nbsp;

                <asp:Panel ID="panelEditorApproval" runat="server">            
                    <asp:LinkButton ID="lnkApprove" meta:resourcekey="lnkApprove" CausesValidation=false runat="server">Approve</asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="lnkDecline" meta:resourcekey="lnkDecline" CausesValidation=false runat="server">Decline</asp:LinkButton>&nbsp;
                    <asp:HyperLink ID="lnkApprovalAssistant" meta:resourcekey="lnkApprovalAssistant" runat="server">Approval Assistant</asp:HyperLink>
                </asp:Panel>
                
                <asp:Panel ID="panelPublisherApproval" runat="server">
                    <asp:LinkButton ID="lnkApprove2" meta:resourcekey="lnkApprove2" CausesValidation=false runat="server">Approve</asp:LinkButton>
                    <asp:LinkButton ID="lnkDecline2" meta:resourcekey="lnkDecline2" CausesValidation=false runat="server">Decline</asp:LinkButton>
                    <asp:HyperLink ID="lnkApprovalAssistant2" meta:resourcekey="lnkApprovalAssistant2" runat="server">Approval Assistant</asp:HyperLink>
                </asp:Panel>            
            </td>
            </tr>
            </table>

        </div>
        <div runat=server id="pannelChannelInfo" style="font-size:x-small;font-family:verdana;padding-left:7px;padding-top:3px;border:#9BAFCA 1px solid;border-top:none;border-bottom:none;">
            
            <table summary="" cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
            <td valign="top">
            <div style="width:90px;font-size:x-small;font-family:verdana;">
            <asp:Label ID="lblChannelLabel" meta:resourcekey="lblChannelLabel" runat="server" Text="Channel" width="90px"></asp:Label>
            </div>
            </td>
            <td valign="top" style="font-size:x-small;font-family:verdana;">:</td>
            <td style="width:100%;padding-left:4px;font-size:x-small;font-family:verdana;">
            <asp:Label ID="lblChannelName" runat="server" Text=""></asp:Label>&nbsp;
            <asp:LinkButton ID="lnkChangeChannel" meta:resourcekey="lnkChangeChannel" runat="server">Change</asp:LinkButton>
            </td>
            </tr>
            </table>
        
        </div>
        <div runat=server id="Div1" style="font-size:x-small;font-family:verdana;padding-left:7px;padding-top:3px;border:#9BAFCA 1px solid;border-top:none;border-bottom:none;">
              <asp:LinkButton ID=lnkPageElements meta:resourcekey="lnkPageElements" runat="server" text="Page Elements"></asp:LinkButton>&nbsp;&nbsp;
        </div>
        <div runat=server id="pannelVersionAndMoreInfo" style="font-size:x-small;font-family:verdana;padding-left:7px;padding-top:0px;border:#9BAFCA 1px solid;border-top:none;border-bottom:none;text-align:right;">
            <table summary="" cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
            <td valign="top" style="width:100%;text-align:right">
            <asp:LinkButton ID="lnkVersionHistory" Font-Size="7pt" meta:resourcekey="lnkVersionHistory" runat="server" text="Version History"></asp:LinkButton>
            </td>
            <td style="padding-top:1px;padding-right:3px;padding-left:10px;padding-right:5px">
            <asp:LinkButton ID="lnkMoreInfo" runat="server"><asp:Image id="imgMoreInfo" meta:resourcekey="imgMoreInfo" ImageUrl="systems/images/showInfo.gif" AlternateText="" BorderWidth="0" runat="server"></asp:Image></asp:LinkButton>            
            <asp:LinkButton ID="lnkMoreInfoHide" runat="server"><asp:Image id="imgHideInfo" meta:resourcekey="imgHideInfo" ImageUrl="systems/images/hideInfo.gif" AlternateText="" BorderWidth="0" runat="server"></asp:Image></asp:LinkButton>
            </td>
            </tr>
            </table>
        </div>
        <div id="_divMoreInfo" style="display:none;font-size:x-small;font-family:verdana;padding-top:3px;border:#9BAFCA 1px solid;border-top:none;border-bottom:none;">
            <div style="background:#F8F9F9;border-top:#e0e0e0 1px solid;padding:7px;">

                <asp:Literal ID="lblMoreInfo" visible="true" runat="server"></asp:Literal>
                
            </div>
        </div>
        <div style="border:#9BAFCA 1px solid;border-top:none;height:3px"></div>
    </td>
    </tr>
    <tr><td colspan="3" style="height:12px"></td></tr>
    <tr id="idListingEmpty" runat="server" visible="false">
        <td colspan="3" style="padding:5px;padding-top:0px;background:url('systems/images/bg_box3.gif') #F8F9F9;border:#e0e0e0 3px solid;text-align:center;font-size:10px">
            <div style="text-transform:uppercase;font-family:arial;font-weight:bold;font-size:14px;margin:5px"><asp:Literal id="litListingEmpty" meta:resourcekey="litListingEmpty" runat="server"></asp:Literal></div>
            <asp:Literal id="litClickAddNewLink" meta:resourcekey="litClickAddNewLink" runat="server">Click <b>Add New</b> link to add a new entry (page).</asp:Literal>
        </td>
    </tr>
    </table>

    
    <script language="javascript" type="text/javascript">
    <!-- 
    function _showMoreInfo(oEl1,oEl2)
        {
        oEl1.style.display="none";
        oEl2.style.display="";
        var divMoreInfo = document.getElementById("_divMoreInfo");
        divMoreInfo.style.display="";
        divMoreInfo.style.top = 5;
        divMoreInfo.style.left = 5;
        }
    function _hideMoreInfo(oEl1,oEl2)
        {
        oEl1.style.display="";
        oEl2.style.display="none";
        var divMoreInfo = document.getElementById("_divMoreInfo");
        divMoreInfo.style.display="none";
        }
    // -->
    </script>
    
</asp:Content>

<asp:Content ID="contentPlaceholderScript" ContentPlaceHolderID="placeholderScript" runat="server">
    <!-- FLOAT -->
    <asp:Panel id="panelPopWorkspace" runat="server"> 
    <table summary="" cellpadding=0 cellspacing=0 id="popWorkspace" style="display:none;border:#9FAEB0 1px solid;background:#E6E7E8;position:absolute;">
    <tr>
    <td style="padding:1px;font-family:Verdana;font-weight:normal;font-size:x-small;text-align:left">  
         <div style="padding:7px;border:#9BAFCA 1px solid;border-bottom:none;background:url('systems/float/popbg.gif') repeat-x #D6DDDF;">
             <table summary="" >
             <tr>
             <td valign="top">
                 <div style="padding:3px;font-size:9px" id="idAccount" runat="server">
                    <asp:HyperLink ID="lnkAccount" meta:resourcekey="lnkAccount" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Account</asp:HyperLink><br />
                    <asp:Literal ID="litAccount" meta:resourcekey="litAccount" runat="server">
                    Update your profile.
                    </asp:Literal> 
                </div>  
                <div style="padding:3px;font-size:9px" id="idPreferences" runat="server">                    
                    <asp:HyperLink ID="lnkPreferences" meta:resourcekey="lnkPreferences" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Preferences</asp:HyperLink><br />
                    <asp:Literal ID="litPreferences" meta:resourcekey="litPreferences" runat="server">
                    Customize your working panels.
                    </asp:Literal>     
                </div>
                 <div style="padding:3px;font-size:9px" id="idPages" runat="server">
                    <asp:HyperLink ID="lnkPages" meta:resourcekey="lnkPages" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Pages</asp:HyperLink><br />
                    <asp:Literal ID="litPages" meta:resourcekey="litPages" runat="server">
                    List of pages in your channels.
                    </asp:Literal>  
                </div>
                 <div style="padding:3px;font-size:9px" id="idResources" runat="server">
                    <asp:HyperLink ID="lnkResources" meta:resourcekey="lnkResources" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Resources</asp:HyperLink><br />
                    <asp:Literal ID="litResources" meta:resourcekey="litResources" runat="server">
                    Manage images & multimedia files.
                    </asp:Literal>  
                </div>
                 <div style="padding:3px;font-size:9px" id="idApproval" runat="server">
                    <asp:HyperLink ID="lnkApproval" meta:resourcekey="lnkApproval" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Approval</asp:HyperLink><br />
                    <asp:Literal ID="litApproval" meta:resourcekey="litApproval" runat="server">
                    List of pages waiting for your approval.
                    </asp:Literal>   
                </div>
             </td>
             <td valign="top">
                <div style="padding:3px;font-size:9px" id="idEvents" runat="server">
                    <asp:HyperLink ID="lnkEvents" meta:resourcekey="lnkEvents" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Events</asp:HyperLink><br />
                    <asp:Literal ID="litEvents" meta:resourcekey="litEvents" runat="server">
                    Create and manage events.
                    </asp:Literal>  
                </div>
                <div style="padding:3px;font-size:9px" id="idPolls" runat="server">
                    <asp:HyperLink ID="lnkPolls" meta:resourcekey="lnkPolls" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Polls</asp:HyperLink><br />
                    <asp:Literal ID="litPolls" meta:resourcekey="litPolls" runat="server">
                    Create and manage polls.
                    </asp:Literal>    
                </div>
                <div style="padding:3px;font-size:9px" id="idNewsletters" runat="server">
                    <asp:HyperLink ID="lnkNewsletters" meta:resourcekey="lnkNewsletters" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Newsletters</asp:HyperLink><br />
                    <asp:Literal ID="litNewsletters" meta:resourcekey="litNewsletters" runat="server">
                    Create and manage email newsletters.
                    </asp:Literal>   
                </div>
                <div style="padding:3px;font-size:9px" id="idCustomListing" runat="server">
                    <asp:HyperLink ID="lnkCustomListing" meta:resourcekey="lnkCustomListing" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Custom Listing</asp:HyperLink><br />
                    <asp:Literal ID="litCustomListing" meta:resourcekey="litCustomListing" runat="server">
                    Create and embed custom listing.
                    </asp:Literal>   
                </div>
                <div style="padding:3px;font-size:9px" id="idShop" runat="server">
                    <asp:HyperLink ID="lnkShop" meta:resourcekey="lnkShop" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Shop</asp:HyperLink><br />
                    <asp:Literal ID="litShop" meta:resourcekey="litShop" runat="server">
                    Manage Online Shop.
                    </asp:Literal>     
                </div>
             </td>
             </tr>
             </table>
         </div>
         <div style="height:9px;border:#9BAFCA 1px solid;border-top:none;background:url(systems/float/popbg_bottom.gif)"></div>
    </td>
    </tr>
    </table>
    </asp:Panel>
    
    <asp:Panel id="panelPopAdmin" runat="server"> 
    <table summary="" cellpadding=0 cellspacing=0 id="popAdmin" style="display:none;border:#9FAEB0 1px solid;background:#E6E7E8;position:absolute;">
    <tr>
    <td style="padding:1px;font-family:Verdana;font-weight:normal;font-size:x-small;text-align:left">
        <div style="padding:7px;border:#9BAFCA 1px solid;border-bottom:none;background:url('systems/float/popbg.gif') repeat-x #D6DDDF;">
             <table summary="" style="width:250px">
             <tr>
             <td valign="top">
                 <div style="padding:3px;font-size:9px" id="idChannels" runat="server">
                    <asp:HyperLink ID="lnkChannels" meta:resourcekey="lnkChannels" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Channels</asp:HyperLink><br />
                    <asp:Literal ID="litChannels" meta:resourcekey="litChannels" runat="server">
                    Create and manage channels - website divisions that also control user access.                   
                    </asp:Literal>
                </div>  
                <div style="padding:3px;font-size:9px" id="idUsers" runat="server">                    
                    <asp:HyperLink ID="lnkUsers" meta:resourcekey="lnkUsers" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Users</asp:HyperLink><br />
                    <asp:Literal ID="litUsers" meta:resourcekey="litUsers" runat="server">
                    Create, manage and assign users to channels.
                    </asp:Literal>     
                </div>
                 <div style="padding:3px;font-size:9px" id="idRegistrationSettings" runat="server">
                    <asp:HyperLink ID="lnkRegistrationSettings" meta:resourcekey="lnkRegistrationSettings" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Registration Settings</asp:HyperLink><br />
                    <asp:Literal ID="litRegistrationSettings" meta:resourcekey="litRegistrationSettings" runat="server">
                    Configure site user registration.
                    </asp:Literal>     
                </div>
                 <div style="padding:3px;font-size:9px" id="idTemplates" runat="server">
                    <asp:HyperLink ID="lnkTemplates" meta:resourcekey="lnkTemplates" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Templates</asp:HyperLink><br />
                    <asp:Literal ID="litTemplates" meta:resourcekey="litTemplates" runat="server">
                    Register your templates here.
                    </asp:Literal>
                </div>
                 <div style="padding:3px;font-size:9px" id="idModules" runat="server">
                    <asp:HyperLink ID="lnkModules" meta:resourcekey="lnkModules" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Modules</asp:HyperLink><br />
                    <asp:Literal ID="litModules" meta:resourcekey="litModules" runat="server">
                    Register your modules here.
                    </asp:Literal> 
                </div>
                <div style="padding:3px;font-size:9px" id="idLocalization" runat="server">
                    <asp:HyperLink ID="lnkLocalization" meta:resourcekey="lnkLocalization" runat="server" Font-Size="9px" Font-Bold="true" ForeColor="#505870">Sites & Localization</asp:HyperLink><br />
                    <asp:Literal ID="litLocalization" meta:resourcekey="litLocalization" runat="server">
                    Create and manage sites & localization.
                    </asp:Literal>
                </div>
             </tr>
             </table>
         </div>
         <div style="height:9px;border:#9BAFCA 1px solid;border-top:none;background:url(systems/float/popbg_bottom.gif)"></div>
    </td>
    </tr>
    </table>
    </asp:Panel>
    <!-- FLOAT -->
    
    <!-- SHOULD ALWAYS VISIBLE -->
    <asp:HiddenField id="hidEditorType" runat="server" value=""></asp:HiddenField>
    <asp:HiddenField id="hidPlaceHolder" runat="server"></asp:HiddenField>
    <asp:HiddenField id="hidModule" runat="server"></asp:HiddenField>
    <asp:HiddenField id="hidMove" runat="server"></asp:HiddenField>
    <asp:Button runat="server" id="btnModulePosition" Text="Button"></asp:Button>
    
    <script language="javascript" type="text/javascript">
    <!--
    function windowOpen(url,width,height)
	    {
	    //window.open(url,"","width="+width+"px,height="+height+"px;toolbar=no,menubar=no,location=no,directories=no,status=yes")
        var x=(window.screen.width-width)/2, y=(window.screen.height-height)/2;
        window.open(url, "", "left="+x+",top="+y+",width="+width+",height="+height);
	    }
    // -->
    </script>
    <!-- /SHOULD ALWAYS VISIBLE -->
    
    <!-- IMAGE FLOAT -->
    <div id="popImage" style="position:absolute;border:#cccccc 1px solid;display:none;overflow:hidden;background:white">
        <img id="popImageView" alt="" style="margin:20px;vertical-align:middle;" src="systems/images/blank.gif"/>
    </div>
    <script type="text/javascript" language="javascript">var float=new ICFloat();float.add("popImage");</script>
    <!-- /IMAGE FLOAT -->
    
    <asp:Label id="lblRawUrl" runat="server" Text=""></asp:Label>
</asp:Content>