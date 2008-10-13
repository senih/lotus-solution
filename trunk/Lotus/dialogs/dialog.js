function modalDialogShow_IE(url,width,height) //IE
  {
  return window.showModalDialog(url,window,
    "dialogWidth:"+width+"px;dialogHeight:"+height+"px;edge:Raised;center:Yes;help:No;Resizable:Yes;Maximize:Yes");
  }
function modalDialogShow_Moz(url,width,height) //Moz
    {
    var left = screen.availWidth/2 - width/2;
    var top = screen.availHeight/2 - height/2;
    activeModalWin = window.open(url, "", "width="+width+"px,height="+height+",left="+left+",top="+top+",scrollbars=yes,resizable=yes");
    window.onfocus = function(){if (activeModalWin.closed == false){activeModalWin.focus();};};
    
    }
function modalDialog2(url,width,height)
  {
  if(navigator.appName.indexOf('Microsoft')!=-1)
    return modalDialogShow_IE(url,width,height); //IE 
  else
    modalDialogShow_Moz(url,width,height); //Moz  
  }

function modalDialog(url,width,height,title)
  {
  icOpenDlg(url,width,parseInt(height)+30+'px');
  if(title)icTitleDlg(title);
  }
var icImgPath='';
var icTitle='';
function icTitleDlg(sTitle)
    {
    icTitle=sTitle;
    }
function icWait(me)
    {
    var oMdlDlg=$('idMdlDlg');
    if(oMdlDlg.style.display=='block')
        {
        var oMdlWait=$('idMdlWait');
        oMdlWait.innerHTML='';

        /*Title*/       
        var dvTitle=document.createElement("div");
        dvTitle.setAttribute("id","idMdlTitle");        
        dvTitle.style.cssText='text-align:left;font-family:Arial;font-size:10pt;color:#333333;font-weight:bold;padding-left:7px;padding-top:3px;padding-bottom:7px;background:#cccccc;height:20px';
        dvTitle.innerHTML=oMdlDlg.contentWindow.document.title;        
        if(icTitle!='')dvTitle.innerHTML=icTitle;
        icTitle='';/*Clear*/
        
        /*Close Button*/
        var lnkClose=document.createElement("div");
        lnkClose.onclick=icCloseDlg;
        lnkClose.style.position='absolute';
        lnkClose.style.cursor='pointer';
        lnkClose.style.left=parseInt($('idMdlWait').style.width)-20+'px';
        lnkClose.style.top='3px';        
        var imgClose=document.createElement("img");
        imgClose.src=icImgPath+"close.gif";
        imgClose.style.border=0;        
        lnkClose.appendChild(imgClose);

        oMdlWait.appendChild(dvTitle);    
        oMdlWait.appendChild(lnkClose);               
        oMdlWait.style.display='block';
        if(oMdlDlg.src.toLowerCase().lastIndexOf('.jpg')!=-1 ||
           oMdlDlg.src.toLowerCase().lastIndexOf('.gif')!=-1 ||
           oMdlDlg.src.toLowerCase().lastIndexOf('.png')!=-1 )
           {
           oMdlDlg.contentWindow.document.body.style.margin="0px";
           }           

        /*Put content on top*/
        oMdlDlg.style.zIndex=12;
        oMdlWait.style.zIndex=11;
        var oUA=window.navigator.userAgent;
        var bIsIE=(oUA.indexOf("MSIE")>=0);
        if(bIsIE)oMdlWait.style.filter='alpha(opacity=85)';
        else
            {
            oMdlWait.style.MozOpacity=0.85;
            oMdlWait.style.opacity=0.85;
            }
        }
    }
function icOpenDlg(url,w,h)
    {
    w=parseInt(w)+'px';h=parseInt(h)+'px'; 
    
    var oScripts=document.getElementsByTagName("script"); 
    var sDlgPath;
    for(var i=0;i<oScripts.length;i++)
      {
      var sSrc=oScripts[i].src.toLowerCase();
      if(sSrc.indexOf("dialog.js")!=-1) sDlgPath=oScripts[i].src.replace(/dialog.js/,"");
      }
    icImgPath=sDlgPath+'images/';
    if(!$('idMdlDlg'))
        {
        var oframe;
        if (document.all)
          {
          oframe=document.createElement('<iframe style="display:none" onload="icWait(this)"></iframe>');
          }
        else if(document.getElementById) 
          {
          oframe= document.createElement('iframe');
          oframe.onload=function()
            {
            icWait(this)
            }
          }
        if (oframe) 
            {
            oframe.setAttribute("id","idMdlDlg");
            oframe.src=icImgPath+"blank.gif";
            oframe.frameBorder=0;
            oframe.scrolling="auto";
            document.body.appendChild(oframe);
            }
        }
    if(!$('idMdlBg'))
        {
        var dvMdlBg=document.createElement("div");
        dvMdlBg.setAttribute("id","idMdlBg");
        dvMdlBg.style.display='none'; 
        document.body.appendChild(dvMdlBg);  
        }
    if(!$('idMdlWait'))
        {
        var dvMdlWait=document.createElement("div");
        dvMdlWait.setAttribute("id","idMdlWait");
        dvMdlWait.style.display='none'; 
        document.body.appendChild(dvMdlWait);  
        } 
        
    var oMdlDlg=$('idMdlDlg');      
    var oMdlBg=$('idMdlBg');
    oMdlBg.style.backgroundColor='#333333';
    
    var oUA=window.navigator.userAgent;
    var bIsIE=(oUA.indexOf("MSIE")>=0);
    var bIsIE7=(oUA.indexOf("MSIE 7.0")>=0);
    var bIsIE6=(oUA.indexOf("MSIE 6.0")>=0);
    if(bIsIE7) bIsIE6=false;    
    
    if(bIsIE)oMdlBg.style.filter='alpha(opacity=40)';
    else 
        {
        oMdlBg.style.MozOpacity=0.40;
        oMdlBg.style.opacity=0.40;
        }
    oMdlBg.style.zIndex=10;
    oMdlBg.style.display='block';    
    //if(window.XMLHttpRequest==null)
    if(bIsIE6)
        {/*IE6  
    left:expression((ignoreMe=document.documentElement.scrollLeft?document.documentElement.scrollLeft:document.body.scrollLeft)+"px");
    top:expression((ignoreMe=document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop)+"px");*/
        
        oMdlBg.style.position='absolute';
        oMdlBg.style.left=document.documentElement.scrollLeft+"px";
        oMdlBg.style.top=document.documentElement.scrollTop+"px";
        oMdlBg.style.width=document.documentElement.clientWidth+"px";
        oMdlBg.style.height=document.documentElement.clientHeight+"px";
        }
    else
        {
        oMdlBg.style.position="fixed";  
        oMdlBg.style.left=0;
        oMdlBg.style.top=0;
        oMdlBg.style.width="100%";
        oMdlBg.style.height="100%";
        }

    var oMdlWait=$('idMdlWait');
    oMdlWait.style.backgroundColor='#ffffff';
    oMdlWait.style.border='#cccccc 7px solid';
    var oUA=window.navigator.userAgent;
    var bIsIE=(oUA.indexOf("MSIE")>=0);
    if(bIsIE)oMdlWait.style.filter='alpha(opacity=100)';
    else 
        {
        oMdlWait.style.MozOpacity=0.99;
        oMdlWait.style.opacity=0.99;
        }
    oMdlWait.style.width=w;oMdlWait.style.height=h;

    oMdlWait.style.zIndex=12;
    var imgAnim=document.createElement("img");    
    imgAnim.src=icImgPath+"animated_progress.gif";
    imgAnim.setAttribute("id","imgAnim");
    imgAnim.style.margin='15px';
    oMdlWait.appendChild(imgAnim); 
    //if(window.XMLHttpRequest==null)
    if(bIsIE6) 
    oMdlWait.style.position='absolute';
    else oMdlWait.style.position='fixed';
    oMdlWait.style.visibility='hidden';
    oMdlWait.style.display='block';   

    oMdlDlg.style.width=w;
    oMdlDlg.style.height=parseInt(h)-30+'px';/*Adjustment*/
    oMdlDlg.style.backgroundColor='#ffffff';
    oMdlDlg.style.border='#aaaaaa 1px solid';
    oMdlDlg.style.zIndex=11;
    oMdlDlg.style.visibility='hidden';
    oMdlDlg.style.display='block';  
    //if(window.XMLHttpRequest==null)
    if(bIsIE6) 
    oMdlDlg.style.position='absolute';
    else oMdlDlg.style.position='fixed';    
    posCenter();
    oMdlWait.style.visibility='visible'; 
    oMdlDlg.style.visibility='visible';
    oMdlDlg.src=url; 
    
    /*onresize*/
  if (window.attachEvent)window.attachEvent('onresize', posCenter);
  else if (window.addEventListener)window.addEventListener('resize', posCenter, false);
  else window.onresize=posCenter;
  /*onscroll*/
  if(document.all)document.documentElement.onscroll=posCenter;
    }
function posCenter()
    {
    var oUA=window.navigator.userAgent;
    var bIsIE7=(oUA.indexOf("MSIE 7.0")>=0);
    var bIsIE6=(oUA.indexOf("MSIE 6.0")>=0);
    if(bIsIE7) bIsIE6=false;
    
    /*Yg tdk support position:fixed adl IE6, shg dialog di-move berdasarkan posisi scroll.
    Ciri IE6 adl. tdk support XMLHttpRequest (XMLHttpRequest=null)*/
  //var left=window.XMLHttpRequest==null?document.documentElement.scrollLeft:0;
  var left=bIsIE6?document.documentElement.scrollLeft:0;
  //var top=window.XMLHttpRequest==null?parseInt(document.documentElement.scrollTop)+15:15;/*Adjustment*/
  var top=bIsIE6?parseInt(document.documentElement.scrollTop)+15:15;/*Adjustment*/
  var oMdlDlg=$('idMdlDlg');
  oMdlDlg.style.left=Math.max((left+(getWindowWidth()-oMdlDlg.offsetWidth)/2),0)+'px';
  oMdlDlg.style.top=Math.max((top+(getWindowHeight()-oMdlDlg.offsetHeight)/2),0)+'px';
  
  //left=window.XMLHttpRequest==null?document.documentElement.scrollLeft:0;
  //top=window.XMLHttpRequest==null?document.documentElement.scrollTop:0;
  left=bIsIE6?document.documentElement.scrollLeft:0;
  top=bIsIE6?document.documentElement.scrollTop:0;
  var oMdlWait=$('idMdlWait');
  oMdlWait.style.left=Math.max((left+(getWindowWidth()-oMdlWait.offsetWidth)/2),0)+'px';
  oMdlWait.style.top=Math.max((top+(getWindowHeight()-oMdlWait.offsetHeight)/2),0)+'px';
    }
function icCloseDlg()
    {
    var oMdlDlg=$('idMdlDlg');var oMdlBg=$('idMdlBg');
    oMdlDlg.style.display=oMdlBg.style.display='none';
    
    /*detach event*/
  if (window.detachEvent)window.detachEvent('onresize', posCenter);
  else if (window.removeEventListener)window.removeEventListener('resize', posCenter, false);
  else window.onresize=null;
  
  var oMdlWait=$('idMdlWait');
  oMdlWait.innerHTML='';
  oMdlWait.style.display='none';
  
  oMdlDlg.style.display='none';
    }
function $(id){return document.getElementById(id)}
function getWindowWidth() 
    {
    if(self.innerWidth)return self.innerWidth;
    else if(document.documentElement && document.documentElement.clientWidth)return document.documentElement.clientWidth;
    else if(document.body)return document.body.clientWidth;
    return 0;
    }
function getWindowHeight() 
    {
    if(self.innerHeight)return self.innerHeight;
    else if(document.documentElement && document.documentElement.clientHeight)return document.documentElement.clientHeight;
    else if(document.body)return document.body.clientHeight;
    return 0;
    }