<%@ Control Language="VB" Inherits="BaseUserControl"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.sqlClient " %>
<%@ Import Namespace="System.Web.Security.Membership"%>

<script runat="server">
    Dim nVersion As Integer

    Private sConn As String = ConfigurationManager.ConnectionStrings("SiteConnectionString").ConnectionString.ToString()
    Private oConn As New SqlConnection(sConn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim nRate1Total As Integer = 0
        Dim nRate2Total As Integer = 0
        Dim nRate3Total As Integer = 0
        Dim nRate4Total As Integer = 0
        Dim nRate5Total As Integer = 0
        Dim nRate1Percent As Integer = 0
        Dim nRate2Percent As Integer = 0
        Dim nRate3Percent As Integer = 0
        Dim nRate4Percent As Integer = 0
        Dim nRate5Percent As Integer = 0
        Dim nTotal As Integer
        Dim sHeight1 As String = ""
        Dim sHeight2 As String = ""
        Dim sHeight3 As String = ""
        Dim sHeight4 As String = ""
        Dim sHeight5 As String = ""

        sSQL = "SELECT * FROM page_rating_summary WHERE page_id=" & Me.PageID
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        While oDataReader.Read()
            If CInt(oDataReader("rating")) = 1 Then
                nRate1Total = CInt(oDataReader("total"))
            ElseIf CInt(oDataReader("rating")) = 2 Then
                nRate2Total = CInt(oDataReader("total"))
            ElseIf CInt(oDataReader("rating")) = 3 Then
                nRate3Total = CInt(oDataReader("total"))
            ElseIf CInt(oDataReader("rating")) = 4 Then
                nRate4Total = CInt(oDataReader("total"))
            ElseIf CInt(oDataReader("rating")) = 5 Then
                nRate5Total = CInt(oDataReader("total"))
            End If
        End While
        oDataReader.Close()
        nTotal = nRate1Total + nRate2Total + nRate3Total + nRate4Total + nRate5Total

        If Not nTotal = 0 Then
            nRate1Percent = (nRate1Total / nTotal) * 60 '100
            nRate2Percent = (nRate2Total / nTotal) * 60 '100
            nRate3Percent = (nRate3Total / nTotal) * 60 '100
            nRate4Percent = (nRate4Total / nTotal) * 60 '100
            nRate5Percent = (nRate5Total / nTotal) * 60 '100
        Else
            nRate1Percent = 0
            nRate2Percent = 0
            nRate3Percent = 0
            nRate4Percent = 0
            nRate5Percent = 0
        End If

        If nRate1Percent > 0 Then sHeight1 = "height:" & nRate1Percent & "px;background:#ffaa00;"
        If nRate2Percent > 0 Then sHeight2 = "height:" & nRate2Percent & "px;background:#ffaa00;"
        If nRate3Percent > 0 Then sHeight3 = "height:" & nRate3Percent & "px;background:#ffaa00;"
        If nRate4Percent > 0 Then sHeight4 = "height:" & nRate4Percent & "px;background:#ffaa00;"
        If nRate5Percent > 0 Then sHeight5 = "height:" & nRate5Percent & "px;background:#ffaa00;"

        rate1.Attributes.Add("style", sHeight1 & "width:10px;")
        rate2.Attributes.Add("style", sHeight2 & "width:10px;")
        rate3.Attributes.Add("style", sHeight3 & "width:10px;")
        rate4.Attributes.Add("style", sHeight4 & "width:10px;")
        rate5.Attributes.Add("style", sHeight5 & "width:10px;")

        lblTotalVoters.Text = nTotal & " " & GetLocalResourceObject("PeopleHaveRated") '"people have rated this content."

        'Authenticate for displaying 'View comments'
        'If Not IsNothing(GetUser) Then
        '    lnkComments.Visible = True
        '    lnkComments.OnClientClick = "modalDialog('dialogs/page_comments.aspx');return false"
        'Else
        '    lnkComments.Visible = False
        'End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim sSQL As String
        Dim oConn As SqlConnection
        Dim oCommand As SqlCommand
        Dim oDataReader As SqlDataReader
        oConn = New SqlConnection(sConn)
        oConn.Open()

        Dim nRating As Integer
        Dim sIP As String = HttpContext.Current.Request.UserHostAddress
        Dim bInsert As Boolean = True
        Dim nTotal As Integer = 0

        If rdoRating1.Checked Then
            nRating = 1
        ElseIf rdoRating2.Checked Then
            nRating = 2
        ElseIf rdoRating3.Checked Then
            nRating = 3
        ElseIf rdoRating4.Checked Then
            nRating = 4
        ElseIf rdoRating5.Checked Then
            nRating = 5
        Else
            Exit Sub
        End If

        sSQL = "SELECT * FROM page_rating_voters WHERE page_id=" & Me.PageID & " AND ip='" & sIP & "'"
        oCommand = New SqlCommand(sSQL, oConn)
        oDataReader = oCommand.ExecuteReader()
        If oDataReader.Read() Then
            bInsert = False
            lblSubmitStatus.Text = GetLocalResourceObject("YouHaveRated") '"You have already rated this content."
        End If
        oDataReader.Close()

        If bInsert Then
            sSQL = "INSERT INTO page_ratings (page_id,rating,comment) VALUES (" & Me.PageID & "," & nRating & ",'" & Replace(txtComment.Text, "'", "''") & "')"
            oCommand = New SqlCommand(sSQL, oConn)
            oCommand.ExecuteNonQuery()

            sSQL = "INSERT INTO page_rating_voters (page_id,ip) VALUES (" & Me.PageID & ",'" & sIP & "')"
            oCommand = New SqlCommand(sSQL, oConn)
            oCommand.ExecuteNonQuery()

            sSQL = "SELECT * FROM page_rating_summary WHERE page_id=" & Me.PageID & " AND rating=" & nRating
            oCommand = New SqlCommand(sSQL, oConn)
            oDataReader = oCommand.ExecuteReader()
            If Not oDataReader.Read() Then
                sSQL = "INSERT INTO page_rating_summary (page_id,rating, total) VALUES (" & Me.PageID & "," & nRating & ",1)"
            Else
                nTotal = CInt(oDataReader("total"))
                sSQL = "UPDATE page_rating_summary set total=" & (nTotal + 1) & " where page_id=" & Me.PageID & " and rating=" & nRating
            End If
            oDataReader.Close()

            oCommand = New SqlCommand(sSQL, oConn)
            oCommand.ExecuteNonQuery()

            lblSubmitStatus.Text = GetLocalResourceObject("ThankYou") '"Thank you for your feedback."

            'clear form
            txtComment.Text = ""
            rdoRating1.Checked = False
            rdoRating2.Checked = False
            rdoRating3.Checked = False
            rdoRating4.Checked = False
            rdoRating5.Checked = False
        End If

        panelRating.Visible = False
        Page.Master.FindControl("placeholderBody").FindControl("panelBody").Visible = False
        
        If Not IsNothing(Page.Master.FindControl("placeholderPublishingInfo")) Then
            Page.Master.FindControl("placeholderPublishingInfo").Visible = False
        End If
        Page.Master.FindControl("placeholderBodyTop").Visible = False
        Page.Master.FindControl("placeholderBodyBottom").Visible = False
        Page.Master.FindControl("placeholderFileView").Visible = False
        Page.Master.FindControl("placeholderFileDownload").Visible = False
        Page.Master.FindControl("placeholderListing").Visible = False
        Page.Master.FindControl("placeholderCategoryInfo").Visible = False
        'Page.Master.FindControl("placeholderContentRating").Visible = False
        Page.Master.FindControl("placeholderComments").Visible = False
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews")) Then
            Page.Master.FindControl("placeholderStatPageViews").Visible = False
        End If
        If Not IsNothing(Page.Master.FindControl("placeholderStatPageViews_Vertical")) Then
            Page.Master.FindControl("placeholderStatPageViews_Vertical").Visible = False
        End If
        
        panelThankYou.Visible = True
    End Sub
    
    Protected Sub btnBack_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect(HttpContext.Current.Items("_page"))
    End Sub
</script>


<asp:Panel ID="panelRating" runat="server">

<div style="border-top:#d0d0d0 1px solid;margin-top:7px;margin-bottom:7px;"></div>
<table border=0>
<tr>
<td valign="top">
    <asp:Label ID="lblRate" meta:resourcekey="lblRate" runat="server" Font-Size=XX-Small Text="How would you rate the usefulness of this content?"></asp:Label>
    <table>
    <tr>
    <td></td>
    <td align=center style="font-size:xx-small">1</td>
    <td align=center style="font-size:xx-small">2</td>
    <td align=center style="font-size:xx-small">3</td>
    <td align=center style="font-size:xx-small">4</td>
    <td align=center style="font-size:xx-small">5</td>
    <td></td>
    </tr>
    <tr>
    <td><asp:Label ID="lblPoor" meta:resourcekey="lblPoor" runat="server" Font-Size=XX-Small Text="Poor"></asp:Label></td>
    <td><asp:RadioButton ID="rdoRating1" runat="server" GroupName="groupRating" /></td>
    <td><asp:RadioButton ID="rdoRating2" runat="server" GroupName="groupRating" /></td>
    <td><asp:RadioButton ID="rdoRating3" runat="server" GroupName="groupRating" /></td>
    <td><asp:RadioButton ID="rdoRating4" runat="server" GroupName="groupRating" /></td>
    <td><asp:RadioButton ID="rdoRating5" runat="server" GroupName="groupRating" /></td>
    <td><asp:Label ID="lblOutstanding" meta:resourcekey="lblOutstanding" runat="server" Font-Size=XX-Small Text="Outstanding"></asp:Label></td>
    </tr>
    <tr>
    <td colspan=7><!-- Visible=false -->
        <asp:Label ID="lblComment" Visible=false runat="server" Font-Size=XX-Small Text="Why did you give the content this rating? (optional)"></asp:Label>
    </td>
    </tr>
    <tr>
    <td colspan=7><!-- Visible=false -->
        <asp:TextBox ID="txtComment" Visible=false TextMode=MultiLine Rows=3 Width="260px" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td colspan=7 align=right>        
        <asp:Button ID="btnSubmit" meta:resourcekey="btnSubmit" Font-Size=XX-Small runat="server" Text="Submit" />
    </td>
    </tr>
    </table>
</td>
<td valign=top style="padding-left:30px">

    <asp:Label ID="lblRateThisContent" meta:resourcekey="lblRateThisContent" runat="server" Text="Content rating" Font-Size=XX-Small></asp:Label>:
    <table height="100%" border=0>
    <tr>
        <td valign=bottom><table cellpadding=0 cellspacing=0 id="rate1" runat=server><tr><td></td></tr></table></td>
        <td valign=bottom><table cellpadding=0 cellspacing=0 id="rate2" runat=server><tr><td></td></tr></table></td>
        <td valign=bottom><table cellpadding=0 cellspacing=0 id="rate3" runat=server><tr><td></td></tr></table></td>
        <td valign=bottom><table cellpadding=0 cellspacing=0 id="rate4" runat=server><tr><td></td></tr></table></td>
        <td valign=bottom><table cellpadding=0 cellspacing=0 id="rate5" runat=server><tr><td></td></tr></table></td>
    </tr>
    <tr>
        <td colspan=5 height="1px" style="background:#a0a0a0"></td>
    </tr>
    <tr>
        <td align=right style="font-size:xx-small">1</td>
        <td align=right style="font-size:xx-small">2</td>
        <td align=right style="font-size:xx-small">3</td>
        <td align=right style="font-size:xx-small">4</td>
        <td align=right style="font-size:xx-small">5</td>
    </tr>
    </table>
    &nbsp;<asp:Label ID="lblTotalVoters" runat="server" Font-Size=XX-Small Text=""></asp:Label>

</td>
</tr>
</table>
<br />
</asp:Panel>

<asp:Panel ID="panelThankYou" runat="server" Visible="false">
<p>
    <asp:Label ID="lblSubmitStatus" runat="server" Font-Bold=true Text=""></asp:Label>
</p>
<p>
    <asp:Button ID="btnBack" meta:resourcekey="btnBack" runat="server" Text="Back To Page" OnClick="btnBack_Click" />
</p>
</asp:Panel>


