<%@ Page Language="VB" %>
<%@ Import namespace="System.Web.Security.Membership"%>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">   
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsNothing(GetUser()) Then
            Exit Sub
        Else
            If Roles.IsUserInRole(GetUser.UserName.ToString(), "Administrators") Or _
                    Roles.IsUserInRole(GetUser.UserName, "Newsletters Managers") Then
                'Continue
            Else
                Exit Sub
            End If
        End If
        
        Dim sCulture As String = Request.QueryString("c")
        If Not sCulture = "" Then
            Dim ci As New CultureInfo(sCulture)
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
        idTitle.Text = GetLocalResourceObject("idTitle.Text")
        btnUpdate.Text = GetLocalResourceObject("btnUpdate.Text")
        btnCancel.Text = GetLocalResourceObject("btnCancel.Text")
        
    End Sub
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="idTitle" meta:resourcekey="idTitle" runat="server">Stylesheet</title>
    <script language="javascript" type="text/javascript">
    <!--
    function onload() 
        {
       if(navigator.appName.indexOf('Microsoft')!=-1)
              {//IE
              var id2 = dialogArguments.document.getElementById("divCSSId").innerText;
              var sCSS = dialogArguments.document.getElementById(id2).value;
              document.getElementById("txtStyle").value=sCSS
              }
          else
              {
              var id2 = window.opener.document.getElementById("divCSSId").innerHTML;
              var sCSS = window.opener.document.getElementsByName(id2)[0].value;
              document.getElementById("txtStyle").value=sCSS
              }
        }

    function btnUpdate_onclick() 
        {
        var sCSS = document.getElementById("txtStyle").value;
        if(navigator.appName.indexOf('Microsoft')!=-1)
            {//IE
            var id = dialogArguments.document.getElementById("divEditorId").innerText;
            var oIFrame = dialogArguments.document.getElementById("idContentedt" + id);
            if (!oIFrame) oIFrame=dialogArguments.document.getElementById("idContentoEdit_" + id);
            //alert(oIFrame)
            _applyStyle(oIFrame.contentWindow, sCSS)
            
            var id2 = dialogArguments.document.getElementById("divCSSId").innerText
            dialogArguments.document.getElementById(id2).value=sCSS;            
            }
        else
            {
            var id = window.opener.document.getElementById("divEditorId").innerHTML;
            var oIFrame = window.opener.document.getElementById("idContentedt" + id);
            if (!oIFrame) oIFrame=window.opener.document.getElementById("idContentoEdit_" + id);

            _applyStyle(oIFrame.contentWindow, sCSS)
            
            var id2 = window.opener.document.getElementById("divCSSId").innerHTML;
            window.opener.document.getElementsByName(id2)[0].value=sCSS;
            }
        self.close()
        }

    function _applyStyleIE(frm, txtStyle) 
        {
        //var frm=document.getElementById(frm).contentWindow;
        var ss=null;
        if (frm.document.styleSheets.length>0) 
            {
            ss=frm.document.styleSheets[0];
            } 
        else 
            {
            ss = frm.document.createStyleSheet();
            }
        ss.cssText=txtStyle;
        }

    function _applyStyleFF(frm, txtStyle) 
        {
        //var frm=document.getElementById(frm).contentWindow;
        var ss=frm.document.getElementById("_news_style");
        if (ss) ss.parentNode.removeChild(ss);    
        ss = frm.document.createElement("STYLE");
        ss.id="_news_style";
        ss.appendChild(frm.document.createTextNode(txtStyle));
        var head=frm.document.getElementsByTagName("head")[0];
        head.appendChild(ss);
        }
      
    function _applyStyle(frm,txtStyle) 
        {
        if (window.navigator.userAgent.indexOf("MSIE") >=0) 
            {
            _applyStyleIE(frm, txtStyle);
            } 
        else 
            {
            _applyStyleFF(frm, txtStyle);
            }
        }
    // -->
    </script>
</head>
<body language="javascript" onload="onload()">
<form runat="server" name="form1">
    <table align="center">
    <tr>
        <td>
            <textarea id="txtStyle" cols="20" style="width: 400px; height: 250px" rows="2"></textarea>
        </td>
    </tr>
    <tr><td>
      <asp:button ID="btnUpdate" meta:resourcekey="btnUpdate" runat="server" Text=" OK " style="width:120px" OnClientClick="btnUpdate_onclick();return false;" />
      <asp:button ID="btnCancel" meta:resourcekey="btnCancel" runat="server" Text=" Cancel " style="width:120px" OnClientClick="self.close();return false;" />
   </td>
    </tr>
    </table></form>
</body>
</html>
