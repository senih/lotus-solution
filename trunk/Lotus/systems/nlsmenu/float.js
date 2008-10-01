/**
* float.js v.1.0
* Copyright 2005-2006, addobject.com. All Rights Reserved
* Author Jack Hermanto, www.addobject.com
*/
function NlsFloatMenu() {
  var fMenu=null;
  var yPos=0;
  var p=new Object();    
  var tm=null;
  var iv=null;
  var t=0;

  this.init=function(panel) {
    fMenu=document.getElementById(panel);
    yPos=parseInt(fMenu.style.top);
    p.x1=yPos;
  };
  
  this.scrollMenu=function() {
    if (!tm && !iv) {
      tm=setTimeout(moveFloat, 200);
    }
  };
  
  function moveFloat() {
    var scrOffY = window.scrollY?window.scrollY:document.body.scrollTop;
    if (scrOffY+yPos==p.x2) return;
    p.x2=scrOffY+yPos;
    setPoint(p);
    iv=setInterval(scrollXY, 10);      
  };
  
  function setPoint(p) {p.c1=p.x1+(p.x2-p.x1)*1/3; p.c2=p.x2;};

  function scrollXY() {
    if (t<30) {
      var a = effect_bezier(t/30, p.x1, p.x2, p.c1, p.c2);      
      fMenu.style.top = a+"px";
      t++;
    } else {
      fMenu.style.top=p.x2+"px";
      clearInterval(iv);
      tm=null; iv=null;
      p.x1=p.x2; t=0;
      moveFloat();
    }
  };
};
