/**
* nlsmenu_nlstree_intg.js v.1.2.1
* Copyright 2005-2006, addobject.com. All Rights Reserved
* Author Jack Hermanto, www.addobject.com
*/
NlsTree.prototype.nlsMenuAsCtxMenu = null;
NlsNode.prototype.nlsMenuAsCtxMenu = null;

NlsTree.prototype.setNlsMenuAsGlobalCtxMenu = function(ctx) {
  if (this.opt.evCtxMenu!=null) this.opt.evCtxMenu=true;
  this.nlsMenuAsCtxMenu = ctx;
  ctx.container=this;
};

NlsTree.prototype.setNlsMenuAsNodeCtxMenu = function(id, ctx) {
  if (this.opt.evCtxMenu!=null) this.opt.evCtxMenu=true;
  var nd = this.nLst[this.genIntId(id)];
  nd.nlsMenuAsCtxMenu = ctx;
  if (ctx.mId) ctx.container=this;
};

function nlsMenuAsContextMenu(ev, id) {
  if (!this.opt.enableCtx) return false;
  var sNd=this.nLst[id]; var ctx=null;
  if (sNd.nlsMenuAsCtxMenu && sNd.nlsMenuAsCtxMenu.mId) ctx=sNd.nlsMenuAsCtxMenu; else 
  if (sNd.nlsMenuAsCtxMenu=="DEFAULT") ctx=null; else
  if (sNd.nlsMenuAsCtxMenu=="NONE") return false; else ctx=this.nlsMenuAsCtxMenu;
  if (!ctx) return true;
  
  if (this.opt.multiSel && this.isSelected(sNd.orgId)) {
      /*check if all the ctx menu*/
      var sNds=this.getSelNodes();
      for (var i=0; i<sNds.length; i++) {
        var t=(sNds[i].ctxMenu==null?this.ctxMenu:sNds[i].ctxMenu);
        if (t!=null && t.mId!=ctx.mId) {this.selectNode(id); break;}
      }
    } else {
      this.selectNode(id);
  }
  //this.selectNode(id);
  if (this.tmId) clearTimeout(this.tmId);
  nlsMenuMgr[ctx.mgrId].hideMenus();
  nlsMenuMgr[ctx.mgrId].clearTimeout();
  ctx.showMenu(ev.clientX, ev.clientY, ev.clientX, ev.clientY, "", null);
  return false;
};