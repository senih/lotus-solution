/*Copyright InsiteCreation.com*/
function ICExpPanel(id) {
  this.id=id;
  this.tm=null;
  this.exp=true;
  this.speed=5;
  this.steps=10;
  this.orgDim=[];
  
  var dv=document.getElementById(id);
  
  dv.style.overflow="hidden";
  this.orgDim[0]=parseInt(dv.style.width); 
  this.orgDim[1]=parseInt(dv.style.height); 
  
  if(dv.style.display=="none") {
    this.exp=false;
    dv.style.height="1px";
  }
  
  this.expand=function() {
    var me=this;
    this.exp=true; 
    if(dv.style.display=="none") dv.style.display="block";
    this.tm=window.setInterval(function(){animExpand(me, dv);}, this.speed); 
  };
  
  this.collapse=function() {
    var me=this;
    this.exp=false; 
    this.tm=setInterval(function(){animCollapse(me, dv);}, this.speed); 
  };
  
  this.panelClick=function() {
    if(this.exp) this.collapse(); else this.expand();
  };
  
  function animExpand(pn, dv) {
    var h=parseInt(dv.style.height)+pn.steps;
    if(h>=pn.orgDim[1]) {
      h=pn.orgDim[1];
      clearInterval(pn.tm);
      pn.tm=null;
    }
    dv.style.height=h+"px";
  };
  
  function animCollapse(pn, dv) {
    var h=parseInt(dv.style.height)-pn.steps;
    if(h<=0) {
      h=1;
      dv.style.display="none";
      clearInterval(pn.tm);
      pn.tm=null;
    }
    dv.style.height=h+"px";
  };
}

function icPanelClick(btn, panel) {
  panel.panelClick();
  if(panel.exp) btn.src="collapse.gif"; else btn.src="expand.gif";
}