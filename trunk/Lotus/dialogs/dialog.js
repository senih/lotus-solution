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
function modalDialog(url,width,height)
	{
	if(navigator.appName.indexOf('Microsoft')!=-1)
		return modalDialogShow_IE(url,width,height); //IE	
	else
		modalDialogShow_Moz(url,width,height); //Moz	
	}

//Used For Login
//function clearFormAction()
//    {P7_setScroller('p7scroller1','p7s1content1',0,0);
//    document.getElementsByTagName('form')[0].action="";
//    }
//window.onload=clearFormAction;

