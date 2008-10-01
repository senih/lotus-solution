var insiteEffectList={
  barn:"progid:DXImageTransform.Microsoft.Barn(Duration=0.5,motion=out,orientation=vertical);",
  blinds:"progid:DXImageTransform.Microsoft.Blinds(Duration=0.5,Bands=8,direction=right);",
  checkerboard:"progid:DXImageTransform.Microsoft.Checkerboard(Duration=0.5,Direction=right,SquaresX=20,SquaresY=20);",
  fade:"progid:DXImageTransform.Microsoft.Fade(Duration=0.5,Overlap=1.00);",
  inset:"progid:DXImageTransform.Microsoft.Inset(Duration=0.5);",
  iris:"progid:DXImageTransform.Microsoft.Iris(Duration=0.5,irisstyle=CIRCLE,motion=in);",
  pixelate:"progid:DXImageTransform.Microsoft.Pixelate(Duration=0.5,MaxSquare=10);",
  radialwipe:"progid:DXImageTransform.Microsoft.RadialWipe(Duration=0.5,wipestyle=WEDGE)",
  randombars:"progid:DXImageTransform.Microsoft.RandomBars(Duration=0.5,Orientation=horizontal);",
  randomdissolve:"progid:DXImageTransform.Microsoft.RandomDissolve(Duration=0.5);",
  slide:"progid:DXImageTransform.Microsoft.Slide(Duration=0.5,slidestyle=HIDE,Bands=5);",
  spiral:"progid:DXImageTransform.Microsoft.Spiral(Duration=0.5,GridSizeX=64,GridSizeY=64);",
  stretch:"progid:DXImageTransform.Microsoft.Stretch(Duration=0.5,stretchstyle=HIDE);",
  strips:"progid:DXImageTransform.Microsoft.Strips(Duration=0.5,motion=rightdown);",
  wheel:"progid:DXImageTransform.Microsoft.Wheel(Duration=0.5,spokes=10);",
  gradienwipe:"progid:DXImageTransform.Microsoft.GradientWipe(Duration=0.5,GradientSize=0.75,wipestyle=0,motion=forward);",
  zigzag:"progid:DXImageTransform.Microsoft.Zigzag(Duration=0.5,GridSizeX=8,GridSizeY=8);"
};

var insiteMenuInst=new Object();
var insiteIsIE=(window.navigator.userAgent.indexOf("MSIE") >=0);
function InsiteMenu(id) {
  this.id=id;
  this.width="100%";
  this.selectedMenu=null;
  this.arrMenus=[];
  this.useEffect=true;
  this.effect="randomdissolve";//checkerboard, gradienwipe, randomdissolve
  insiteMenuInst[id]=this;
  return this;
}

InsiteMenu.prototype.RENDER=function() {
  var d=document, sTop="", sMenu="", prevPr=0, selMenu=null, selPrMenu=null, mn=null;
  d.write("<table cellpadding=0 cellspacing=0 width=\""+this.width+"\"><tr class=\"topbar\"><td style=\"height:100%;padding-left:5px;padding-top:3px;padding-bottom:3px\" valign=\"bottom\" nowrap>");
  for (var i=0;i<this.arrMenus.length;i++) {
    mn=this.arrMenus[i];
    if (mn[1] == 0) {
      //sTop+="<span id=\""+this.id+"_"+mn[0]+"\" onmouseover=\"top_over(this)\" onclick=\"menu_click('"+mn[3]+"','"+mn[4]+"');\" class=\"top\" style=\"cursor:pointer;padding-top:4px;padding-bottom:4px;padding-left:10px;padding-right:10px;\">"+mn[2]+"</span>";
      sTop+="<td id=\""+this.id+"_"+mn[0]+"\" onmouseover=\"top_over(this)\" onclick=\"menu_click('"+mn[3]+"','"+mn[4]+"');\" class=\"top\" style=\"cursor:pointer;padding-top:4px;padding-bottom:4px;padding-left:10px;padding-right:10px;\" nowrap>"+mn[2]+"</td>";
      prevPr=0;
    } else {
      if (mn[1]!=prevPr) {
        sMenu+="<table cellpadding=0 cellspacing=0 id=\""+this.id+"_"+mn[1]+"_members\" style=\"display:none;\"><tr>";
        prevPr=mn[1];
      }
      sMenu+="<td id=\""+this.id+"_"+mn[0]+"\" onmouseover=\"member_over(this)\" onmouseout=\"member_out(this)\" onclick=\"menu_click('"+mn[3]+"','"+mn[4]+"');\" class=\"member\" style=\"cursor:pointer;height:18px;padding-left:10px;padding-right:10px;\" nowrap>"+mn[2]+"</td>";
      if (i==this.arrMenus.length-1 || this.arrMenus[i+1][1]!=prevPr) { sMenu+="</tr></table>"; }
    }
    if (this.selectedMenu==mn[0]) { if(mn[1]==0) {selPrMenu=this.selectedMenu; selMenu=null;} else {selMenu=this.selectedMenu; selPrMenu=mn[1];} }
  }
  sMenu+="<table cellpadding=0 cellspacing=0 id=\""+this.id+"_empty_members\" style=\"display:none;\"><tr><td class=\"member\" style=\"cursor:pointer;height:18px;padding-left:10px;padding-right:10px;\">&nbsp;</td></tr></table>"
  d.write("<table cellspacing=0 cellpadding=0><tr>");
  d.write(sTop);
  d.write("</tr></table>");
  d.write("</td></tr>");
  d.write("<tr><td class=\"memberbar\" style=\"padding-left:5px;\"><table cellpadding=0 cellspacing=0><tr><td id='submenu_"+this.id+"'>");
  d.write(sMenu);  
  d.write("</td></tr></table></td></tr></table>");
  
  if (selPrMenu) { top_over(document.getElementById(this.id+"_"+selPrMenu)) }
  if (selMenu) { member_over(document.getElementById(this.id+"_"+selMenu)) }
}

/*****************************************************
    MENU FUNCTIONS
*****************************************************/
var oActiveMenu;
function top_over(oTop)
    {
    if(!oTop)return;//yus

    if(oActiveMenu)
        {
        //reset previous highlighted menu
        var oMembers=document.getElementById(oActiveMenu.id+"_members");
        if (oMembers) oMembers.style.display="none"; else { document.getElementById(oActiveMenu.id.substring(0, oActiveMenu.id.indexOf("_"))+"_empty_members").style.display="none"; }
        oActiveMenu.className="top"; // Updated
        }
    
    //highlight current menu
    oTop.className="top_hover"; // Updated
    
    //fading
    var oMembers = document.getElementById(oTop.id + "_members");
    if (oMembers) {
      var mId=oTop.id.substring(0, oTop.id.indexOf("_"));
      if (insiteMenuInst[mId].useEffect && insiteIsIE) {
        var cntr=document.getElementById("submenu_"+mId);
        cntr.style.filter=insiteEffectList[insiteMenuInst[mId].effect];
        if (cntr.filters.length>0) {
            cntr.filters[0].apply();
            oMembers.style.display="block";
            cntr.filters[0].play();
        }
      } else {
          applyOpacity(oMembers.id,0);//spy tdk flicker, di-nol-kan
          doFade(oMembers.id);
          oMembers.style.display="block";
      }
    } else {
        document.getElementById(oTop.id.substring(0, oTop.id.indexOf("_")) + "_empty_members").style.display="block";
    }
    
    //set active menu
    oActiveMenu=oTop;
    }
function member_over(oMembers)
    {   
    oMembers.className="member_hover";
    }
function member_out(oMembers)
    {
    oMembers.className="member";
    }
//function menu_click(url, id, obj) 
function menu_click(url, sTarget) 
    {
    if(sTarget=="" || sTarget=="_self")window.location.href=url;
    else window.open(url);
    }

/*****************************************************
    UTILITIES
*****************************************************/
function doFade(id)
    {   
    var nT=0;
    for(i=0;i<100;i++)
        {
        setTimeout("applyOpacity('"+id+"',"+i+")",(nT*5));
        nT++;
        }
    }
function applyOpacity(id,nVal)
    {
    var oStyle=document.getElementById(id).style;
    oStyle.filter="alpha(opacity="+nVal+")";
    oStyle.opacity=nVal/100;
    oStyle.KMozOpacity=nVal/100;
    oStyle.KHtmlOpacity=nVal/100;   
    if(nVal==99)
        {
        //nStart=0;
        oStyle.filter=0;
        }
    }