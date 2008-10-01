/**
* 
* Copyright 2005, addObject.com. All Rights Reserved
* Author Jack Hermanto, www.addobject.com
*/
var nlsScroller = new Object();

function NlsScrollerIco(path) {
  if (!path||path=="") {
    var allScs = (document.getElementsByTagName ? document.getElementsByTagName("SCRIPT"): document.scripts);
    for (var i=0;i<allScs.length;i++) {
      if (allScs[i].src.toLowerCase().indexOf("nlsscroller.js")>=0) {path=allScs[i].src.replace(/nlsscroller.js/gi, "img/");break;}
    }
  }
  this.next = path+"next.gif";
  this.nextover  = path+"nextover.gif";
  this.prev = path+"prev.gif";
  this.prevover  = path+"prevover.gif";
  this.resume = path+"play.gif";
  this.resumeover = path+"playover.gif";
  this.stop = path+"stop.gif";
  this.stopover = path+"stopover.gif";
  this.backgrd = path+"bg.gif";
  this.modeauto  = path+"modeauto.gif";
  this.modeman  = path+"modeman.gif";
  return this;
}

function NlsScroller(s) {
  //private
  this.scrlId = s;
  this.intRef = null;
  this.blockObj = null;
  this.helper = null;
  this.effWin = null;
  this.ico = new NlsScrollerIco();

  nlsScroller[s] = this;
  
  //properties
  this.mode="AUTO"; //MANUAL;
  this.effect=new NlsEffContinuous(); //default effect
  
  this.showToolbar = true;
  this.toolbar=["MODE","PLAY","PREV","NEXT"];
  this.contents = [];
  this.scrollerWidth = 150;
  this.scrollerHeight = 80;
  this.scrollerSpeed = 3500;
  this.stylePref = "";
  this.stopOnMouseOver = true;
  
  //methods
  this.setEffect = scrl_setEffect;
  this.setContents = scrl_setContents;
  this.render = scrl_render;
  this.start = scrl_start;
  this.stop= scrl_stop;
  this.resume = scrl_resume;
  this.prev=function() {this.effect.prev()} ;
  this.next=function() {this.effect.next()} ;
  
  this.toggleMode = scrl_toggleMode;
  this.scrollerOnMouseOver=function() {}
  this.scrollerOnMouseOut=function() {}
  
  return this;
}

function scrl_setContents(cnt) {
  cnt = cnt.replace(/<span>nlsscroller-break<\/span>/gi, "<span>nlsscroller-break</span>");
  this.contents = cnt.split("<span>nlsscroller-break</span>");
}

//render the scroller
function scrl_render(plc) {
  var pos="relative", dsp="none";
  if (window.navigator.appName=="Microsoft Internet Explorer" && window.navigator.appVersion.indexOf("MSIE 4") != -1) {
    pos="absolute"; dsp="block";
  }

  var autoTool = "<table id='"+this.scrlId+"auto' border='0' cellpadding='0' cellspacing='0' "+(this.mode=="MANUAL"?"style='display:none'":"")+"><tr>";
  autoTool += "<td onmouseover=\"scrl_tbMouseOver('"+this.scrlId+"play')\" onmouseout=\"scrl_tbMouseOut('"+this.scrlId+"play')\" onclick='nlsScroller."+this.scrlId+".resume();'><img id='"+this.scrlId+"play' src='"+this.ico.resume+"' ><img id='"+this.scrlId+"playover' src='"+this.ico.resumeover+"' style='display:none'></td>";
  autoTool += "<td onmouseover=\"scrl_tbMouseOver('"+this.scrlId+"pause')\" onmouseout=\"scrl_tbMouseOut('"+this.scrlId+"pause')\" onclick='nlsScroller."+this.scrlId+".stop();'><img id='"+this.scrlId+"pause' src='"+this.ico.stop+"'><img id='"+this.scrlId+"pauseover' src='"+this.ico.stopover+"' style='display:none'></td>";
  autoTool+="</tr></table>";
  var manTool = "<table id='"+this.scrlId+"manual' border='0' cellpadding='0' cellspacing='0' "+(this.mode=="AUTO"?"style='display:none'":"")+"><tr>";
  manTool+="<td onmouseover=\"scrl_tbMouseOver('"+this.scrlId+"prev')\" onmouseout=\"scrl_tbMouseOut('"+this.scrlId+"prev')\" onclick='nlsScroller."+this.scrlId+".prev();'><img id='"+this.scrlId+"prev' src='"+this.ico.prev+"'><img id='"+this.scrlId+"prevover' src='"+this.ico.prevover+"' style='display:none'></td>";
  manTool+="<td onmouseover=\"scrl_tbMouseOver('"+this.scrlId+"next')\" onmouseout=\"scrl_tbMouseOut('"+this.scrlId+"next')\" onclick='nlsScroller."+this.scrlId+".next();'><img id='"+this.scrlId+"next' src='"+this.ico.next+"'><img id='"+this.scrlId+"nextover' src='"+this.ico.nextover+"' style='display:none'></td>";
  manTool+="</tr></table>";
  var modeTool = "<table border='0' cellpadding='0' cellspacing='0'><tr><td onclick='nlsScroller."+this.scrlId+".toggleMode();'><img id='"+this.scrlId+"mode' src='"+this.ico.modeauto+"' "+(this.mode=="MANUAL"?"style='display:none'":"")+"><img id='"+this.scrlId+"modeover' src='"+this.ico.modeman+"' "+(this.mode=="AUTO"?"style='display:none'":"")+"></td></tr></table>";
  
  var str = "";
  for (var i=0; i<this.contents.length; i++) {
    str += ("<div id='"+this.scrlId+"line"+i+"' style='display:"+dsp+";position:absolute;top:0px;width:100%;height:100%' class='"+this.stylePref+"frmcontent'><table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'><tr><td class='"+this.stylePref+"content'>" + this.contents[i] + "</td></tr></table></div>");
  }
  str += ("<div id='"+this.scrlId+"Helper' style='display:"+dsp+";position:absolute;top:0px;width:100%;height:100%' class='"+this.stylePref+"effhelper'><table width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td></td></tr></table></div>");
  str = ("<div id=\""+this.scrlId+"\" class='"+this.stylePref+"scroller' style='position:"+pos+";overflow:hidden;clip:rect(0px "+this.scrollerWidth+"px "+this.scrollerHeight+"px 0px);width:"+this.scrollerWidth+"px;height:"+this.scrollerHeight+"px;' onmouseover=\"scrl_onMouseOver('"+this.scrlId+"')\" onmouseout=\"scrl_onMouseOut('"+this.scrlId+"')\"><div id=\""+this.scrlId+"EffWin\" style='position:absolute;width:100%;height:100%;top:0px;left:0px;'>" + str + "</div></div>" );
  str = "<table border='0' cellpadding='0' cellspacing='0' class='"+this.stylePref+"scrollerFrame'><tr><td>" + str + "</td></tr>";
  if (this.showToolbar && this.toolbar.length>0) str +="<tr><td class='"+this.stylePref+"toolbar' background='"+this.ico.backgrd+"' align='center'><table width='100%' height='18px' border='0' cellpadding='0' cellspacing='0'><tr><td width='20px'>&nbsp;</td><td align='center'>"+autoTool+manTool+"</td><td width='20px'>"+modeTool+"</td></tr></table></td></tr>";
  str +="</table>";
  
  if (plc) {
    var tPlc = NlsGetElementById(plc);
    tPlc.innerHTML = str; 
  } else {
    document.write(str); str="";
  }
  this.helper = NlsGetElementById(this.scrlId+"Helper");
  this.effWin = NlsGetElementById(this.scrlId+"EffWin");
  return str;
}

function scrl_start() {
  var line = null;
  this.blockObj=[];
  for (var i=0; i<this.contents.length; i++) {
    line = NlsGetElementById(this.scrlId+"line"+i);
    this.blockObj[this.blockObj.length] = line;
    with (line.style) { zIndex=this.contents.length-i; display = "";}
  }
  this.effect.init(this);
  this.stop();
  if (this.effect.name=="NlsEffContinuous") {
    this.intRef = window.setTimeout("eval(nlsScroller."+this.scrlId+".effect.run())", this.scrollerSpeed);
  } else {
    if (this.mode=="AUTO") {
      this.intRef = window.setInterval("eval(nlsScroller."+this.scrlId+".effect.run())", this.scrollerSpeed);
    }
  }
}

function scrl_toggleMode() {
  
  if (this.mode=="AUTO") {
    if (this.effect.name=="NlsEffContinuous") { alert("Manual mode not available in this effect"); return;}
    this.mode="MANUAL";
    this.stop();
    NlsGetElementById(this.scrlId+"mode").style.display="none";
    NlsGetElementById(this.scrlId+"modeover").style.display="";
    NlsGetElementById(this.scrlId+"manual").style.display="";
    NlsGetElementById(this.scrlId+"auto").style.display="none";
  } else if (this.mode=="MANUAL") {
    this.mode="AUTO";
    this.effect.cfg["topicsequence"]="next";
    this.resume();
    NlsGetElementById(this.scrlId+"mode").style.display="";
    NlsGetElementById(this.scrlId+"modeover").style.display="none";
    NlsGetElementById(this.scrlId+"manual").style.display="none";
    NlsGetElementById(this.scrlId+"auto").style.display="";
  }
}

//resume the scroller
function scrl_resume() {
  if (!this.effect) return;
  if (this.effect.name=="NlsEffContinuous") {
    this.effect.run();
  } else {
    if (this.intRef==null) { 
      this.intRef = window.setInterval("eval(nlsScroller."+this.scrlId+".effect.run())", this.scrollerSpeed);
    }
  }
}

//stop the scroller
function scrl_stop() {
  if (!this.effect) return;
  if (this.effect.name=="NlsEffContinuous") {
    this.effect.stop();
    if (this.intRef) {window.clearTimeout(this.intRef); this.intRef = null;}
  } else {
    if (this.intRef) {window.clearInterval(this.intRef); this.intRef = null;}
  }
}

function scrl_setEffect(eff) {
  if (!eff) return;
  if (eff.name=="NlsEffContinuous") {
    if (NlsGetElementById(this.scrlId+"mode")) {
      if (this.mode=="MANUAL") this.toggleMode();
    } else {
      this.mode="AUTO";
    }
  }
  this.stop();
  this.effect=eff;
}

function NlsGetElementById(id) {
    if (document.all) {
        return document.all(id);
    } else
    if (document.getElementById) {
        return document.getElementById(id);
    }
}

function scrl_exitView(dirc, pos, bound) {
  switch (dirc) {
    case "up":; case "left": return (pos<=bound);
    case "down":; case "right":return (pos>=bound);
  }
}

function scrl_previousTopic() {
  this.cfg["topicsequence"]="prev";
  this.run();
}

function scrl_nextTopic() {
  this.cfg["topicsequence"]="next";
  this.run();
}

function scrl_setTopic() {
  var cnt=this.scr.blockObj.length
  if (this.cfg["topicsequence"]=="next") {
    if (this.crTpc==cnt-1) this.crTpc=0; else this.crTpc++;
  } else {
    if (this.crTpc==0) this.crTpc=cnt-1; else this.crTpc--;
  }
}

function scrl_tbMouseOver(b) {
  NlsGetElementById(b).style.display="none";
  NlsGetElementById(b+"over").style.display="";
}

function scrl_tbMouseOut(b) {
  NlsGetElementById(b).style.display="";
  NlsGetElementById(b+"over").style.display="none";
}

function scrl_onMouseOver(scrlId) {
  var scr=nlsScroller[scrlId];
  if (scr.mode=="MANUAL") return;
  if (scr.stopOnMouseOver) scr.stop();
  scr.scrollerOnMouseOver();
}

function scrl_onMouseOut(scrlId) {
  var scr=nlsScroller[scrlId];
  if (scr.mode=="MANUAL") return;
  if (scr.stopOnMouseOver) scr.resume();
  scr.scrollerOnMouseOut();
}

/*
** NLSScroller Continuous Scroll Effect.
** Arguments:
** conf: comma separated key=value pair, must not contains space. 
** The keys are:
** direction: <up, down, left, right>
** speed : scrolling speed
** step : number, default 1
** delay : amount of delay time before scrolling next topic
*/

function NlsEffContinuous(conf) {
  var me=this;
  this.scr=null;
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["direction"]="up";
  this.cfg["speed"]=50;
  this.cfg["step"]=1;
  this.cfg["delay"]=0;
  if (conf && conf!="") {
    var tcnf=conf.replace(/\s+/gi, "").toLowerCase().split(",");
    var keyval ="";
    for (var i=0;i<tcnf.length;i++) { keyval=tcnf[i].split("="); this.cfg[keyval[0]]=keyval[1]; }
  }
  this.crTpc=0;
  this.lsTpc=null;

  this.name="NlsEffContinuous";
  
  this.init=function(scr) {
    this.scr=scr;
    this.scr.effWin.style.height="";
    this.crTpc=0;
    
    var line=null; var tmpPos=0;
    for (var i=0; i<this.scr.blockObj.length; i++) {
      line=this.scr.blockObj[i];
      line.style.height="";
      with(line.style) {
        switch (this.cfg["direction"]) {
          case "up":   left = 0; top = tmpPos+"px"; tmpPos += line.offsetHeight; break;
          case "down": left = 0; tmpPos += line.offsetHeight; top = (this.scr.scrollerHeight-tmpPos) + "px"; break;
          case "left": top = 0; left = tmpPos+"px"; tmpPos += line.offsetWidth; break;
          case "right":top = 0; tmpPos += line.offsetWidth; left = (this.scr.scrollerWidth-tmpPos) + "px"; break;       
        }
      }
    }
    this.lsTpc=line;
  }
  
  this.run=function() {
    var step=1;
    switch (this.cfg["direction"]) {
      case "up":this.runScroll=runUp; step=-this.cfg["step"];break;
      case "down":this.runScroll=runDown; step=+this.cfg["step"];break;
      case "left":this.runScroll=runLeft; step=-this.cfg["step"];break;
      case "right":this.runScroll=runRight; step=+this.cfg["step"];break;    
    }
    this.stop();
    this.rtprop["tmId"] = window.setInterval(function() { me.runScroll(step); }, +me.cfg["speed"]);
  }
  
  this.runScroll=function() {}

  function runUp(step) {
    var line, pos, bound;
    for (var i=0; i<this.scr.blockObj.length; i++) {
      line=this.scr.blockObj[i];
      pos = parseInt(line.style.top) + step;  
      bound=-line.offsetHeight;
      if (scrl_exitView(this.cfg["direction"], pos, bound)) {
        var t=parseInt(this.lsTpc.style.top) + parseInt(this.lsTpc.offsetHeight);
        if (t > this.scr.scrollerHeight) { line.style.top = (t)+"px"; } else { line.style.top = (this.scr.scrollerHeight) + "px"; }
        this.lsTpc=line;
        if (+this.cfg["delay"]>0) { this.stop(); window.setTimeout(function() {me.run();}, +this.cfg["delay"]); }
      } else {
        line.style.top = pos+"px";
      }
    }  
  }

  function runDown(step) {
    var line, pos, bound;
    bound=this.scr.scrollerHeight;
    for (var i=0; i<this.scr.blockObj.length; i++) {
      line=this.scr.blockObj[i];
      pos = parseInt(line.style.top) + step;  
      if (scrl_exitView(this.cfg["direction"], pos, bound)) {
        var t=parseInt(this.lsTpc.style.top);
        if (t<0) { line.style.top = (t-line.offsetHeight) + "px"; } else { line.style.top = -line.offsetHeight + "px"; }
        this.lsTpc=line;
        if (+this.cfg["delay"]>0) { this.stop(); window.setTimeout(function() {me.run();}, +this.cfg["delay"]); }
      } else {
        line.style.top = pos+"px";
      }
    }
  }

  function runLeft(step) {
    var line, pos, bound;
    for (var i=0; i<this.scr.blockObj.length; i++) {
      line=this.scr.blockObj[i];
      pos = parseInt(line.style.left) + step;  
      bound=-line.offsetWidth;
      if (scrl_exitView(this.cfg["direction"], pos, bound)) {
        var t=parseInt(this.lsTpc.style.left) + parseInt(this.lsTpc.offsetWidth);//scr.scrollerWidth;
        if (t > this.scr.scrollerWidth) {line.style.left=(t)+"px";} else {line.style.left=(this.scr.scrollerWidth)+"px";}
        this.lsTpc=line;
        if (+this.cfg["delay"]>0) { this.stop(); window.setTimeout(function() {me.run();}, +this.cfg["delay"]); }
      } else {
        line.style.left = pos+"px"; 
      }
    }  
  }  

  function runRight(step) {
    var line, pos, bound;
    bound=this.scr.scrollerWidth;
    for (var i=0; i<this.scr.blockObj.length; i++) {
      line=this.scr.blockObj[i];
      pos = parseInt(line.style.left) + step;  
      if (scrl_exitView(this.cfg["direction"], pos, bound)) {
        var t=parseInt(this.lsTpc.style.left);
        if (t<0) {line.style.left = (t-line.offsetWidth) + "px";} else {line.style.left = -line.offsetWidth + "px";}
        this.lsTpc=line;
        if (+this.cfg["delay"]>0) { this.stop(); window.setTimeout(function() {me.run();}, +this.cfg["delay"]); }
      } else {
        line.style.left = pos+"px"; 
      }
    }
  }
  
  this.stop=function() {
    if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
  }
  
}

/*
** NLSScroller Slide effect.
** Arguments:
** conf: comma separated key=value pair, must not contains space. 
** The keys are:
** type  : <out, in, shift> 
** direction: <up, down, left, right>
** speed : the time delay before topic displayed, number default 5
** step : number, default 1
** smartnavigation : true/false
*/

function NlsEffSlide(conf) {
  var me=this;
  this.scr=null;
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["type"]="shift";
  this.cfg["direction"]="left";
  this.cfg["speed"]=5;
  this.cfg["step"]=1;
  this.cfg["topicsequence"]="next";
  this.cfg["smartnavigation"]="true"; //manual mode only
  if (conf && conf!="") {
    var tcnf=conf.replace(/\s+/gi, "").toLowerCase().split(",");
    var keyval ="";
    for (var i=0;i<tcnf.length;i++) { keyval=tcnf[i].split("="); this.cfg[keyval[0]]=keyval[1]; }
  }
  this.rtprop["orgtype"]=this.cfg["type"];//original type
  
  this.crTpc=null;
  this.lsTpc=null;
  
  this.name="NlsEffSlide";
  
  this.init=function (scr) {
    this.scr=scr;
    this.crTpc=0;
    
    switch (this.cfg["type"]) {
      case "in":
        //this.crTpc=1;
        var line=null;
        for (var i=0; i<this.scr.blockObj.length; i++) {
          line=this.scr.blockObj[i];
          with (line.style) {
            switch (this.cfg["direction"]) {
              case "up":   left=0+"px"; top=this.scr.scrollerHeight+"px"; break;
              case "down": left=0+"px"; top=-line.offsetHeight+"px"; break;
              case "left": left=this.scr.scrollerWidth+"px"; top=0+"px"; break;
              case "right":left=-line.offsetWidth+"px"; top=0+"px"; break;       
            }
          }
        }
        with (this.scr.blockObj[0].style) {top=0+"px"; left=0+"px"; zIndex=this.scr.blockObj.length-1; }
        this.scr.blockObj[1].style.zIndex=this.scr.blockObj.length;
        break;
      case "out":
        for (var i=0; i<this.scr.blockObj.length; i++) { with (this.scr.blockObj[i].style) { left=0+"px"; top=0+"px"; } }      
        break;
      case "shift":
        //this.crTpc=1;
        var line=null;
        for (var i=0; i<this.scr.blockObj.length; i++) {
          line=this.scr.blockObj[i];
          with (line.style) {
            switch (this.cfg["direction"]) {
              case "up":   left=0+"px"; top=this.scr.scrollerHeight+"px"; break;
              case "down": left=0+"px"; top=-line.offsetHeight+"px"; break;
              case "left": left=this.scr.scrollerWidth+"px"; top=0+"px"; break;
              case "right":left=-line.offsetWidth+"px"; top=0+"px"; break;
            }
          }
        }
        this.scr.blockObj[0].style.top=0+"px";this.scr.blockObj[0].style.left=0+"px";
        this.lsTpc=this.scr.blockObj[0];
        break;
    }
  }
  
  this.run=function () {
    if (this.rtprop["tmId"]!=null) return;
    var step=1; var vert=true;
    switch (this.cfg["direction"]) {
      case "up":step=-this.cfg["step"]; vert=true;break;
      case "down":step=+this.cfg["step"]; vert=true;break;
      case "left":step=-this.cfg["step"]; vert=false;break;
      case "right":step=+this.cfg["step"]; vert=false;break;    
    }
    var cnt=this.scr.blockObj.length;
    switch(this.cfg["type"]) {
      case "out": 
        this.runScroll=runScrollOut;
        
        this.scr.blockObj[this.crTpc].style.zIndex=cnt;
        if (this.cfg["topicsequence"]=="next") {
          this.scr.blockObj[(this.crTpc==cnt-1?0:this.crTpc+1)].style.zIndex=cnt-1;
        } else {
          this.scr.blockObj[(this.crTpc==0?cnt-1:this.crTpc-1)].style.zIndex=cnt-1;
        }

        break;
      case "in": 
        this.setTopic();
        var nextTpc=this.scr.blockObj[this.crTpc] ;
        with (nextTpc.style) {
          switch (this.cfg["direction"]) {
            case "up": top=this.scr.scrollerHeight+"px"; left=0+"px"; break;
            case "down": top=-nextTpc.offsetHeight+"px"; left=0+"px"; break;
            case "left": left=this.scr.scrollerWidth+"px"; top=0+"px"; break;
            case "right": left=-nextTpc.offsetWidth+"px"; top=0+"px";break;
          }
        }
        nextTpc.style.zIndex=cnt;
        this.runScroll=runScrollIn; 
        break;
      case "shift": 
        this.setTopic();
        var nextTpc=this.scr.blockObj[this.crTpc] ;
        with (nextTpc.style) {
          switch (this.cfg["direction"]) {
            case "up": top=this.scr.scrollerHeight+"px"; left=0+"px"; break;
            case "down": top=-nextTpc.offsetHeight+"px"; left=0+"px"; break;
            case "left": left=this.scr.scrollerWidth+"px"; top=0+"px"; break;
            case "right": left=-nextTpc.offsetWidth+"px"; top=0+"px";break;
          }
        }
        nextTpc.style.zIndex=cnt;
        this.runScroll=runScrollShift; break;
    }
    if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    this.rtprop["tmId"] = window.setInterval(function() { me.runScroll(step, vert); }, +me.cfg["speed"]);
  }
  
  this.runScroll=function() {}
 
  function runScrollIn(step, vert) {
    var line=this.scr.blockObj[this.crTpc];
    var pos = parseInt((vert?line.style.top:line.style.left)) + step;
    var cnt=this.scr.blockObj.length;
    if ((this.cfg["direction"]=="up" && pos<=0)||
        (this.cfg["direction"]=="down" && pos>=0)||
        (this.cfg["direction"]=="left" && pos<=0)||
        (this.cfg["direction"]=="right" && pos>=0)
    ) {
      if (vert) line.style.top=0+"px"; else line.style.left=0+"px";
      for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}


      line.style.zIndex=cnt-1; 
      
      if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    } else {
      if (vert) line.style.top = pos+"px"; else line.style.left = pos+"px";
    }
  }
  
  function runScrollOut(step, vert) {
    var bound;
    var line=this.scr.blockObj[this.crTpc];
    var pos = parseInt((vert?line.style.top:line.style.left)) + step;
    switch (this.cfg["direction"]) {
      case "up": bound=-line.offsetHeight;break;
      case "down": bound=this.scr.scrollerHeight;break;
      case "left": bound=-line.offsetWidth;break;
      case "right": bound=this.scr.scrollerWidth;break;
    }  
    var cnt=this.scr.blockObj.length;
    if (scrl_exitView(this.cfg["direction"], pos, bound)) {
      with(line.style) {zIndex=0; left=0+"px"; top=0+"px";}

      this.setTopic();
        
        
      if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    } else {
      if (vert) line.style.top = pos+"px"; else line.style.left = pos+"px";
    }
  }
  
  function runScrollShift(step, vert) {
    var line=this.scr.blockObj[this.crTpc];
    var pos = parseInt((vert?line.style.top:line.style.left)) + step;
    var cnt=this.scr.blockObj.length;
    var dirt = this.cfg["direction"];
    if ((dirt=="up" && pos<=0)||(dirt=="down" && pos>=0)||(dirt=="left" && pos<=0)||(dirt=="right" && pos>=0) ) {
      if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
      if (vert) line.style.top=0+"px"; else line.style.left=0+"px";
      for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}
      
 
      this.lsTpc.style.zIndex=0;
      line.style.zIndex=cnt-1; 
      this.lsTpc=line;
      
      
    } else {
      if (vert) {
        line.style.top = pos+"px";
        if (dirt=="up") this.lsTpc.style.top=pos-parseInt(this.lsTpc.offsetHeight)+"px"; 
        else this.lsTpc.style.top=pos+parseInt(this.lsTpc.offsetHeight)+"px";
      } else {
        line.style.left = pos+"px";
        if (dirt=="left") this.lsTpc.style.left=pos-parseInt(this.lsTpc.offsetWidth)+"px"; 
        else this.lsTpc.style.left=pos+parseInt(this.lsTpc.offsetWidth)+"px"; 
      }
    }  
  }
  
  this.prev=function() {
    if (this.cfg["smartnavigation"]=="true") {
      this.cfg["topicsequence"]="prev";
      if (this.cfg["type"]!="shift") {
        this.cfg["type"]=(this.rtprop["orgtype"]=="in"?"out":"in");
      }      
      if ("leftright".indexOf(this.cfg["direction"]) >= 0) {
        this.cfg["direction"]="left";
      } else {
        this.cfg["direction"]="down";
      }
      this.run();
    } else {
      this.cfg["topicsequence"]="prev";
      this.run();
    }
  }
  
  this.next=function() {
    if (this.cfg["smartnavigation"]=="true") {
      this.cfg["topicsequence"]="next";
      if (this.cfg["type"]!="shift") {
        this.cfg["type"]=this.rtprop["orgtype"];
      }
      if ("leftright".indexOf(this.cfg["direction"]) >= 0) {
        this.cfg["direction"]="right";
      } else {
        this.cfg["direction"]="up";
      }
      this.run();
    } else {
      this.cfg["topicsequence"]="next";
      this.run();
    }  
  }
  
  this.setTopic=scrl_setTopic;
}

/*
** NLSScroller Blank effect.
** Arguments:
** conf: comma separated key=value pair, must not contains space. 
** The keys are:
** speed : the time delay before topic displayed, default "speed=600"
*/

function NlsEffBlank(conf) {
  var me=this;
  this.scr=null;
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["speed"]=600;
  this.cfg["topicsequence"]="next";
  if (conf && conf!="") {
    var tcnf=conf.replace(/\s+/gi, "").toLowerCase().split(",");
    var keyval ="";
    for (var i=0;i<tcnf.length;i++) { keyval=tcnf[i].split("="); this.cfg[keyval[0]]=keyval[1]; }
  }
  this.crTpc=null;
  
  this.name="NlsEffBlank";
  
  this.init=function (scr) {
    this.scr=scr;
    var help=this.scr.helper;
    with (help.style) {display="";zIndex=0;top=0;left=0; }
    this.crTpc=0;
    for (var i=0; i<this.scr.blockObj.length; i++) { with (this.scr.blockObj[i].style) {left=0; top=0;} }
  }
  
  this.run=function () {
    if (this.rtprop["tmId"]!=null) return;
    this.setTopic();
    var cnt=this.scr.blockObj.length;
    for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}
    var line=this.scr.blockObj[this.crTpc];
    var helper=this.scr.helper;
    helper.style.zIndex=cnt+1;
    if (this.rtprop["tmId"]) { window.clearTimeout(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    this.rtprop["tmId"] = window.setTimeout(function() { me.runScroll(); }, +me.cfg["speed"]);
  }
 
  this.runScroll=function() {
    var cnt=this.scr.blockObj.length;
    var line=this.scr.blockObj[this.crTpc];
    line.style.zIndex=cnt;
    this.scr.helper.style.zIndex=0;
    if (this.rtprop["tmId"]) { window.clearTimeout(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
  }
  
  this.prev=scrl_previousTopic;
  this.next=scrl_nextTopic;
  this.setTopic=scrl_setTopic;
}


/*
** NLSScroller IE Transition effect.
** Supported in IE 5.5+ only
** Arguments:
** ieTransEff: array of IE transition effect
** default ["progid:DXImageTransform.Microsoft.Fade(Overlap=0.75); "]
*/
function NlsEffIETrans(ieTransEff) {
  var me=this;
  this.scr=null;
  this.ieTrans = (!ieTransEff || ieTransEff=="" ? ["progid:DXImageTransform.Microsoft.Fade(Overlap=1);"]: ieTransEff);
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["topicsequence"]="next";
  this.crTpc=null;
  
  this.name="NlsEffIETrans";
  
  this.init=function (scr) {
    this.scr=scr;
    this.crTpc=0; 
    for (var i=0; i<this.scr.blockObj.length; i++) { with (this.scr.blockObj[i].style) {left=0; top=0;} }
    this.rtprop["curTrans"]=-1;
  }
  
  this.run=function () {
    this.setTopic();
    var view=this.scr.effWin;
    if (this.rtprop["curTrans"]==this.ieTrans.length-1) this.rtprop["curTrans"]=0; else this.rtprop["curTrans"]++;
    view.style.filter=this.ieTrans[this.rtprop["curTrans"]];
    view.filters[0].apply();

    var cnt=this.scr.blockObj.length;
    for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}
    this.scr.blockObj[this.crTpc].style.zIndex=cnt;
    //if (this.crTpc==cnt-1) this.crTpc=0; else this.crTpc++;
    view.filters[0].play();
  }
  
  this.prev=scrl_previousTopic;
  this.next=scrl_nextTopic;
  this.setTopic=scrl_setTopic;
}


/*
** NLSScroller Wipe effect.
** Arguments: 
** conf : comma separated key=value pair, must not contains space. 
** the key are:
** type:  <horizontal, vertical, alternate>
** speed: <number, default 5, max 20>
** step:  <number, default 3, min 1, max 10>
** Ex> "type=alternate,speed=8"
*/
function NlsEffWipe(conf) {
  var me=this;
  this.scr=null;
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["type"]="alternate";
  this.cfg["speed"]=5;
  this.cfg["step"]=3;
  this.cfg["topicsequence"]="next";
  if (conf && conf!="") {
    var tcnf=conf.replace(/\s+/gi, "").toLowerCase().split(",");
    var keyval ="";
    for (var i=0;i<tcnf.length;i++) { keyval=tcnf[i].split("="); this.cfg[keyval[0]]=keyval[1]; }
  }
  this.crTpc=null;
  
  this.name="NlsEffWipe";
  
  this.init=function (scr) {
    this.scr=scr;
    var help=this.scr.helper;
    with (help.style) {display="";zIndex=0;top=0+"px";left=0+"px"; }
    this.crTpc=0;
    for (var i=0; i<this.scr.blockObj.length; i++) { with (this.scr.blockObj[i].style) {left=0+"px"; top=0+"px";} }
  }
  
  this.run=function () {
    if (this.rtprop["tmId"]!=null) return;
    this.setTopic();
    var cnt=this.scr.blockObj.length;
    var helper=this.scr.helper;
    with (helper.style) { 
      if (this.cfg["type"]=="vertical") { 
        this.rtprop["dir"]="v";
      } else if (this.cfg["type"]=="horizontal") {
        this.rtprop["dir"]="h";
      } else if (this.cfg["type"]=="alternate") {
        if (!this.rtprop.dir) {this.rtprop.dir="h";}
        this.rtprop["dir"]=(this.rtprop["dir"]=="v"?"h":"v");
      }
      if (this.rtprop["dir"]=="v") {
        height="1px";width="100%";top=(this.scr.scrollerHeight/2)+"px";left=0+"px";
      } else if (this.rtprop["dir"]=="h") {
        height="100%";width="1px";left=(this.scr.scrollerWidth/2)+"px";top=0+"px"; 
      }
      zIndex=cnt+1; 
    }
    
    this.rtprop["phase"] = 1;
    if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    this.rtprop["tmId"] = window.setInterval(function() { me.runScroll(); }, +me.cfg["speed"]);
  }
  
  this.runScroll=function() {
    var helper=this.scr.helper; var hs = helper.style;
    var covered=false; var bound=0;
    if (this.rtprop["dir"]=="v") {
      hs.height = parseInt(hs.height) + this.rtprop["phase"]*this.cfg["step"] + "px";
      bound = parseInt(hs.height);
      hs.top=(this.scr.scrollerHeight-bound)/2 +"px";
      covered = (bound >= this.scr.scrollerHeight);
    } else if (this.rtprop["dir"]=="h") {
      hs.width = parseInt(hs.width) + this.rtprop["phase"]*this.cfg["step"] + "px";
      bound = parseInt(hs.width);
      hs.left=(this.scr.scrollerWidth-bound)/2 + "px";
      covered = (bound >= this.scr.scrollerWidth);
    }
    
    if (covered && this.rtprop["phase"]==1) {
      var cnt=this.scr.blockObj.length;
      var line=this.scr.blockObj[this.crTpc];
      for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}    
      line.style.zIndex=cnt;
      this.rtprop["phase"]=-1;
    }
    if (this.rtprop["phase"]==-1 && bound==1) {
      if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
      hs.zIndex=0;
    }
  }
  
  this.prev=scrl_previousTopic;
  this.next=scrl_nextTopic;
  this.setTopic=scrl_setTopic;
}

/*
** NLSScroller Fade effect.
** Arguments: 
** conf : comma separated key=value pair, must not contains space. 
** the key are:
** type:  <horizontal, vertical, alternate>
** speed: <number, default 5, max 20>
** step:  <number, default 3, min 1, max 10>
** Ex> "type=alternate,speed=8"
*/
function NlsEffFade(conf) {
  var me=this;
  this.scr=null;
  this.rtprop=new Object();
  this.cfg=new Object();
  this.cfg["speed"]=5;
  this.cfg["step"]=1;
  this.cfg["topicsequence"]="next";
  if (conf && conf!="") {
    var tcnf=conf.replace(/\s+/gi, "").toLowerCase().split(",");
    var keyval ="";
    for (var i=0;i<tcnf.length;i++) { keyval=tcnf[i].split("="); this.cfg[keyval[0]]=keyval[1]; }
  }
  this.crTpc=null;
  this.name="NlsEffFade";
  
  var isIE=(window.navigator.appName=="Microsoft Internet Explorer");
  
  this.init=function (scr) {
    this.scr=scr;
    this.crTpc=0;
    with (this.scr.helper.style) {display="";zIndex=0;top=0;left=0; }
    for (var i=0; i<this.scr.blockObj.length; i++) { with (this.scr.blockObj[i].style) {left=0; top=0;} }
  }
  
  this.run=function () {
    if (this.rtprop["tmId"]!=null) return;
    this.setTopic();
    var cnt=this.scr.blockObj.length;
    var helper=this.scr.helper;
    with (helper.style) { 
      if (isIE) { 
        filter="progid:DXImageTransform.Microsoft.Alpha( style=0,opacity=50);" ;
        helper.filters[0].Opacity=0;
      } else {
        MozOpacity=0; 
      }
      zIndex=cnt+1;   
    }
    this.rtprop["opa"]=0;
    
    this.rtprop["phase"] = 1;
    if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
    this.rtprop["tmId"] = window.setInterval(function() { me.runScroll(); }, +me.cfg["speed"]);
  }
  
  this.runScroll=function() {
    var covered=false;
    this.rtprop["opa"]+=(this.rtprop["phase"]*parseInt(this.cfg["step"]));
    covered=(this.rtprop["opa"]>=99);
    if (isIE)  {
      this.scr.helper.filters[0].Opacity=this.rtprop["opa"];
    } else {
      this.scr.helper.style.MozOpacity=this.rtprop["opa"]/100;
    }
    
    if (covered && this.rtprop["phase"]==1) {
      var cnt=this.scr.blockObj.length;
      var line=this.scr.blockObj[this.crTpc];
      for (var i=0; i<cnt; i++) {if (i!=this.crTpc) this.scr.blockObj[i].style.zIndex=0;}    
      line.style.zIndex=cnt;
      this.rtprop["phase"]=-1;
    }
    if (this.rtprop["phase"]==-1 && this.rtprop["opa"]==0) {
      if (this.rtprop["tmId"]!=null) { window.clearInterval(this.rtprop["tmId"]); this.rtprop["tmId"]=null; }
      this.scr.helper.style.zIndex=0;
    }
  }
  
  this.prev=scrl_previousTopic;
  this.next=scrl_nextTopic;
  this.setTopic=scrl_setTopic;
  
}