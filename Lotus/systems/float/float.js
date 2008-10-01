var ic_tm=null;
var icIsIE=(window.navigator.userAgent.indexOf("MSIE") >=0);

function ICFloat() {
  this.arFloats=[];
  
  this.add=function(id) {
    this.arFloats[this.arFloats.length]=id;
    var e=ic_getElement(id), me=this;
    e.onmouseover=function () {if(ic_tm) {clearTimeout(ic_tm); ic_tm=null;}};
    e.onmouseout=function () {me.doHide(id);};
  };
  
  this.hide=function(id) {
    var e=ic_getElement(id);
    if(e) e.style.display="none";
    if(ic_tm) {clearTimeout(ic_tm); ic_tm=null;}
  };
  
  this.hideAll=function() {
    for(var i=0;i<this.arFloats.length;i++) {
      this.hide(this.arFloats[i]);
    };
  };
  
  this.imgSet=function(url)//yus
    {
    document.getElementById("popImageView").src=url
    document.getElementById("popImageView").style.display="block";
    }
  this.imgClear=function()//yus
    {
    document.getElementById("popImageView").style.display="none";
    document.getElementById("popImageView").src="systems/images/blank.gif";
    }
    
  this.doShow=function(ev, id) {
    var e=ic_getElement(id);
    if(e) {
      //if(e.style.display=="block") return;
      this.hideAll();
      if(icIsIE){
        e.style.filter="progid:DXImageTransform.Microsoft.Fade(Duration=0.5,Overlap=1.00);";
        if (e.filters.length>0) {
            e.filters[0].apply();
            e.style.display="block";
            var p=ic_getXY(ev.srcElement, e);
            e.style.left=p.x+"px";
            e.style.top=p.y+"px";            
            e.filters[0].play();
        }     
      } else {
        ic_applyOpacity(id,50);
        e.style.display="block";
        var p=ic_getXY(ev.target, e);
        e.style.left=p.x+"px";
        e.style.top=p.y+"px";
        ic_doFade(id);
      }
    }
  };
  
  this.doHide=function(id) {
    var me=this;
    if(!ic_tm) {ic_tm=setTimeout(function(){me.hide(id)}, 100); return;}
  };
};

function ic_getElement(id) {
  if(document.getElementById) return document.getElementById(id);
  else if(document.all) return document.all(id );
}

function ic_getXY(oEl, fEl) {
  var tmp=oEl, x=0, y=0, yh=oEl.offsetHeight;
  while(tmp) {
    x+=tmp.offsetLeft; y+=tmp.offsetTop; tmp=tmp.offsetParent;
  }
  var w=window, d=document.body, de=document.documentElement;
  var sX = w.scrollX||d.scrollLeft||de.scrollLeft;
  var sY = w.scrollY||d.scrollTop||de.scrollTop;
  var cW=w.innerWidth||d.clientWidth, cH=w.innerHeight||d.clientHeight;
  if(icIsIE) {cW=de.offsetWidth; cH=de.offsetHeight; } 
  var mW=fEl.style.width;
  var mH=fEl.style.height;
  if(mW!=null && mW!="") mW=parseInt(mW,10); else mW=fEl.offsetWidth;
  if(mH!=null && mH!="") mH=parseInt(mH,10); else mH=fEl.offsetHeight;
  
  var pX=0, pY=0;
  //alert(sY + "-" + mH + "-" + y + "-" + cH + "-" + yh);  
  if(x-sX+mW<cW) {pX=x;} else {pX=cW-mW+sX;}  
  if(y+yh-sY+mH<cH) {pY=y+yh;} else {pY=y-mH;}
  
  return {x:pX, y:pY};
};

/*----------------------------------------*/
function ic_doFade(id)
    {   
    var nT=0;
    for(i=0;i<100;i++)
        {
        setTimeout("ic_applyOpacity('"+id+"',"+i+")",(nT*5));
        nT++;
        }
    }
function ic_applyOpacity(id,nVal)
    {
    var oStyle=document.getElementById(id).style;
    oStyle.filter="progid:DXImageTransform.Microsoft.Alpha(opacity="+nVal+")";
    oStyle.opacity=nVal/100;
    oStyle.KMozOpacity=nVal/100;
    oStyle.KHtmlOpacity=nVal/100;   
    if(nVal==99)
        {
        //nStart=0;
        oStyle.filter=0;
        }
    }