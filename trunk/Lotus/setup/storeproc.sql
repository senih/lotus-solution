if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[listing_templates]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[listing_templates] (
		[id] [int] IDENTITY(1,1) NOT NULL,
		[template_name] [nvarchar](50) NOT NULL,
		[template] [ntext] NOT NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	ALTER TABLE [dbo].[listing_templates] WITH NOCHECK ADD 
		CONSTRAINT [PK_listing_templates] PRIMARY KEY  CLUSTERED 
		(
			[id]
		)  ON [PRIMARY] 
	INSERT INTO listing_templates (template_name,template) VALUES ('Basic Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap"></td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('News/Journal Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%DISPLAY_DATE%] - [%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Article List - Community Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_DATE%] - [%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">Hits today: [%HITS_TODAY%] &nbsp;Total: [%TOTAL_HITS%]</td><td style="font-size:10px;text-align:right">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Article List - Corporate Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_DATE%] - [%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">Hits: [%TOTAL_HITS%]</td><td style="font-size:10px;text-align:right">&nbsp;</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Directory - Community Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;height:18px;font-family:arial;font-weight:bold;color:#333333;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-size:11px;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;[%HIDE_PRICING_INFO%]">PRICE: [%PRICING_INFO%]</td></tr></table></td></tr><tr><td style="border-bottom:#DDDDDD 1px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><div style="font-size:10px;width:250px;">Hits today: [%HITS_TODAY%] &nbsp;Total: [%TOTAL_HITS%]</div></td><td style="font-size:10px;white-space:nowrap;width:100%">[%LAST_UPDATED_DATE%]</td><td style="font-size:10px;text-align:right;white-space:nowrap;">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Directory - Corporate Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:100px;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px">[%RATING%] </td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="text-align:center"><img style="margin:3px;margin-right:10px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]&sz=100"  alt="" /></td><td valign="top" style="width:100%;height:100%">[%SUMMARY%]</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('File Downloads - Basic Style','<table style="width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="height:100%" valign="top"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="padding:7px;[%HIDE_FILE_DOWNLOAD%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/></td><td valign="top" style="width:100%;padding:7px;padding-top:20px;height:100%"><div style="margin-bottom:12px;"><span style="font-family:Arial;font-weight:bold;">[%TITLE%]</span>&nbsp;<a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div><div><a href="[%FILE_DOWNLOAD_URL%]">[%FILE_DOWNLOAD%]</a>&nbsp;([%FILE_SIZE%])</div></td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('File Downloads - Community Style','<table style="margin-top:10px;margin-bottom:10px;width:100%;border:#BEC7D1 1px solid;height:120px;" cellpadding="0" cellspacing="0"><tr><td valign="top"><div style="padding:7px;font-size:10px;[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/><span style="text-decoration:none"><br />([%FILE_SIZE%])</span><br />[%FILE_DOWNLOAD%]</a><div style="padding-top:3px;font-size:9px;[%HIDE_RATING%]">[%RATING%]</div><div style="font-size:9px;white-space:nowrap;[%HIDE_FILE_DOWNLOAD%]">Downloads: [%TOTAL_DOWNLOADS%]</div></div></td><td valign="top" style="border-left:#BEC7D1 1px solid;width:100%;background:#fcfcfc"><table style="width:100%" cellpadding="0" cellspacing="0"><tr><td valign="top" style="padding:7px;padding-top:6px;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;height:18px;"><a style="font-family:arial;font-weight:bold;font-size:10px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a><span style="font-size:10px"> - [%LAST_UPDATED_DATE%]</span></td></tr><tr><td style="padding:7px;width:100%;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('File Downloads - Corporate Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:90px;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;height:100%" valign="top"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="border-right:#DDDDDD 1px solid;[%HIDE_FILE_DOWNLOAD%]"><div style="padding:7px;font-size:10px;"><a href="[%FILE_DOWNLOAD_URL%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/><span style="text-decoration:none"><br />([%FILE_SIZE%])</span><br />[%FILE_DOWNLOAD%]</a></div></td><td valign="top" style="width:100%;padding:7px;background:#f7f7f7;height:100%"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Gallery Listing - Shop Style','<div style="margin-top:15px;margin-right:40px;height:150px;"><div style="padding-top:5px;border:#E0E0E0 1px solid;height:100px;text-align:center;"><a style="[%HIDE_FILE_VIEW_LISTING%]" target="[%LINK_TARGET%]" href="[%FILE_NAME%]"><img onmouseover="float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');float.imgClear()" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]&sz=90" border="0" /></a></div><div style="font-size:9px">[%TITLE%]</div><div style="font-size:9px">[%SUMMARY%] [%PRICING_INFO%]</div><div style="font-size:9px;"><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a>&nbsp;<span style="[%HIDE_PAYPAL_ADD_TO_CART%]"><span style="color:c0c0c0">|</span>&nbsp;<a href="[%PAYPAL_ADD_TO_CART_URL%]">Buy</a></span></div></div>')
	INSERT INTO listing_templates (template_name,template) VALUES ('General Listing - Shop Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:100px;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px">[%RATING%] </td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="text-align:center"><img style="margin:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]&sz=100"  alt="" /><div style="[%HIDE_PAYPAL_ADD_TO_CART%];">[%PRICING_INFO%]<br /><br /><a href="[%PAYPAL_ADD_TO_CART_URL%]"><img src="resources/1/btnBuyNow.jpg" border="0" style="margin-left:3px;margin-right:10px" /></a></div></td><td valign="top" style="height:100%">[%SUMMARY%]</td></tr></table></td></tr></table>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Photo Gallery - Community Style','<div style="margin-top:15px;margin-right:40px;height:170px;"><div style="padding-top:5px;border:#E0E0E0 1px solid;height:100px;text-align:center;"><a style="[%HIDE_FILE_VIEW_LISTING%]" target="[%LINK_TARGET%]" href="[%FILE_NAME%]"><img onmouseover="float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');float.imgClear()" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]&sz=90" border="0" /></a></div><div style="font-size:9px">[%TITLE%]&nbsp;<i style="color:#888888">- [%LAST_UPDATED_BY%]</i></div><div style="font-size:9px">[%SUMMARY%]</div><div>[%RATING%]</div><div style="font-size:9px">Downloads: [%TOTAL_DOWNLOADS%]</div><div style="font-size:9px;"><span style="[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]">Download</a>&nbsp;<span style="color:#c0c0c0">|</span></span><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div></div>')
	INSERT INTO listing_templates (template_name,template) VALUES ('Photo Gallery - Corporate Style','<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="background:#f7f7f7"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td valign="top"><div style="height:100px;width:100px"><img style="margin:5px" onmouseover="float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');float.imgClear()" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]&sz=90" border="0" align="left" /></div></td><td style="width:100%;padding:7px;height:100%" valign="top">[%SUMMARY%]<div>Downloads: [%TOTAL_DOWNLOADS%]</div><div>File Size: [%FILE_SIZE%]</div><div><span style="[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]">Download</a>&nbsp;<span style="color:#c0c0c0">|</span></span><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div></td></tr></table></td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">&nbsp;</td><td style="font-size:10px;text-align:right">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr></table>')
END
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_type')
  alter table listing_templates add listing_type int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_property')
  alter table listing_templates add listing_property int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_columns')
  alter table listing_templates add listing_columns int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_page_size')
  alter table listing_templates add listing_page_size int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_use_categories')
  alter table listing_templates add listing_use_categories bit DEFAULT 0 WITH VALUES
GO
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_default_order')
  alter table listing_templates add listing_default_order nvarchar(255) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='listing_script')
  alter table listing_templates add listing_script NTEXT NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='template_header')
  alter table listing_templates add template_header NTEXT NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_templates' and sysobjects.type='U' and syscolumns.name='template_footer')
  alter table listing_templates add template_footer NTEXT NULL
Go

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[channels]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[channels] (
		[channel_id] [int] IDENTITY (1, 1) NOT NULL ,
		[channel_name] [nvarchar] (50)  NULL ,
		[default_template_id] [int] NULL ,
		[permission] [int] NULL,
		[disable_collaboration] [bit] NULL 
		) ON [PRIMARY]
	ALTER TABLE [dbo].[channels] WITH NOCHECK ADD 
		CONSTRAINT [PK_channels] PRIMARY KEY  CLUSTERED 
		(
			[channel_id]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_rating_summary]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[page_rating_summary] (
		[page_id] [int] NOT NULL ,
		[rating] [int] NOT NULL ,
		[total] [int] NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[page_rating_summary] WITH NOCHECK ADD 
		CONSTRAINT [PK_page_rating_summary] PRIMARY KEY  CLUSTERED 
		(
			[page_id],
			[rating]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_rating_voters]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[page_rating_voters] (
		[page_rating_voter_id] [int] IDENTITY (1, 1) NOT NULL ,
		[page_id] [int] NULL ,
		[ip] [nvarchar] (50)  NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[page_rating_voters] WITH NOCHECK ADD 
		CONSTRAINT [PK_page_rating_voters] PRIMARY KEY  CLUSTERED 
		(
			[page_rating_voter_id]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_ratings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[page_ratings] (
		[page_rating_id] [int] IDENTITY (1, 1) NOT NULL ,
		[page_id] [int] NULL ,
		[rating] [int] NULL ,
		[comment] [nvarchar] (255)  NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[page_ratings] WITH NOCHECK ADD 
		CONSTRAINT [PK_page_ratings] PRIMARY KEY  CLUSTERED 
		(
			[page_rating_id]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_modules]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[page_modules] (
		[page_module_id] [int] IDENTITY (1, 1) NOT NULL ,
		[module_file] [nvarchar] (50)  NULL ,
		[embed_in] [nvarchar] (50)  NULL ,
		[placeholder_id] [nvarchar] (50)  NULL ,
		[module_data] [nvarchar] (255)  NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[page_modules] WITH NOCHECK ADD 
		CONSTRAINT [PK_page_modules] PRIMARY KEY  CLUSTERED 
		(
			[page_module_id]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[placeholders]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[placeholders] (
		[placeholder_id] [nvarchar] (50)  NOT NULL ,
		[display_name] [nvarchar] (50)  NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[placeholders] WITH NOCHECK ADD 
		CONSTRAINT [PK_placeholders] PRIMARY KEY  CLUSTERED 
		(
			[placeholder_id]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[modules]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[modules] (
		[module_file] [nvarchar] (50)  NOT NULL ,
		[display_name] [nvarchar] (50)  NULL,
		[owner] [nvarchar] (50)  NULL
	) ON [PRIMARY]
	ALTER TABLE [dbo].[modules] WITH NOCHECK ADD 
		CONSTRAINT [PK_modules] PRIMARY KEY  CLUSTERED 
		(
			[module_file]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pages]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[pages] (
		[page_id] [int] NOT NULL ,
		[version] [int] NOT NULL ,
		[parent_id] [int] NULL ,
		[sorting] [int] NULL ,
		[channel_id] [int] NULL ,
		[use_default_template] [bit] NOT NULL ,
		[template_id] [int] NULL ,
		[page_type] [int] NULL ,
		[file_name] [nvarchar] (50)  NULL ,
		[title] [nvarchar] (255)  NULL ,
		[summary] [ntext]  NULL ,
		[picture] [nvarchar] (50)  NULL ,
		[price] [money] NULL,
		[link_text] [nvarchar] (50)  NULL ,
		[link_placement] [nvarchar] (50)  NULL ,
		[content_left] [ntext]  NULL ,
		[content_body] [ntext]  NULL ,
		[content_right] [ntext]  NULL ,
		[file_attachment] [nvarchar] (50)  NULL ,
		[file_size] [real] NULL ,
		[owner] [nvarchar] (50)  NULL ,
		[created_date] [datetime] NULL ,
		[last_updated_date] [datetime] NULL ,
		[last_updated_by] [nvarchar] (50)  NULL ,
		[published_start_date] [smalldatetime] NULL ,
		[published_end_date] [smalldatetime] NULL ,
		[meta_keywords] [ntext]  NULL ,
		[meta_description] [ntext]  NULL ,
		[status] [nvarchar] (50)  NULL ,
		[is_hidden] [bit] NOT NULL ,
		[is_system] [bit] NOT NULL ,
		[page_module] [nvarchar] (255)  NULL ,
		[use_discussion] [bit] NOT NULL ,
		[use_rating] [bit] NOT NULL ,
		[allow_links_crawled] [bit] NOT NULL ,
		[allow_page_indexed] [bit] NOT NULL ,
		[is_marked_for_archival] [bit] NULL ,
		[editor_review_by] [nvarchar] (50)  NULL ,
		[publisher_review_by] [nvarchar] (50)  NULL ,
		[notes] [ntext]  NULL,
		[display_date] [smalldatetime] NULL,
		[properties] [nvarchar] (255) NULL,
		[properties2] [ntext] NULL ,
		[https] [bit] NOT NULL DEFAULT 0,
		[root_id] [int] NULL,
		[event_all_day] [bit] NULL,
		[event_start_date] [datetime] NULL,
		[event_end_date] [datetime] NULL	 
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	ALTER TABLE [dbo].[pages] WITH NOCHECK ADD 
		CONSTRAINT [PK_pages] PRIMARY KEY  CLUSTERED 
		(
			[page_id],
			[version]
		)  ON [PRIMARY] 
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[templates]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[templates] (
		[template_id] [int] IDENTITY (1, 1) NOT NULL ,
		[template_name] [nvarchar] (50)  NULL ,
		[folder_name] [nvarchar] (50)  NULL
	) ON [PRIMARY]
	ALTER TABLE [dbo].[templates] WITH NOCHECK ADD 
		CONSTRAINT [PK_templates] PRIMARY KEY  CLUSTERED 
		(
			[template_id]
		)  ON [PRIMARY] 
	END
GO

IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='community_001')
BEGIN
    insert into templates (template_name,folder_name) values ('Community 001', 'community_001')
END
GO
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_001')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 001', 'corporate_001')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_002')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 002', 'corporate_002')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_003')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 003', 'corporate_003')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_004')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 004', 'corporate_004')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_005')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 005', 'corporate_005')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='corporate_006')
BEGIN
    insert into templates (template_name,folder_name) values ('Corporate 006', 'corporate_006')
END
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_001')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 001', 'fresh_001')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_002')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 002', 'fresh_002')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_003')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 003', 'fresh_003')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_004')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 004', 'fresh_004')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_005')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 005', 'fresh_005')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_006')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 006', 'fresh_006')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_007')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 007', 'fresh_007')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='fresh_008')
BEGIN
    insert into templates (template_name,folder_name) values ('Fresh 008', 'fresh_008')
END
go

IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='simple_blue')
BEGIN
    insert into templates (template_name,folder_name) values ('Simple Blue', 'simple_blue')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='simple_green')
BEGIN
    insert into templates (template_name,folder_name) values ('Simple Green', 'simple_green')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='simple_orange')
BEGIN
    insert into templates (template_name,folder_name) values ('Simple Orange', 'simple_orange')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='simple_red')
BEGIN
    insert into templates (template_name,folder_name) values ('Simple Red', 'simple_red')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='tab_blue')
BEGIN
    insert into templates (template_name,folder_name) values ('Tab Blue', 'tab_blue')
END
go
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='insite2008')
BEGIN
    insert into templates (template_name,folder_name) values ('Insite 2008', 'insite2008')
END
go

set identity_insert channels on
IF NOT EXISTS (SELECT channel_name FROM channels 
         WHERE channel_name='General')
BEGIN
	insert into channels (channel_id, channel_name, default_template_id, permission, disable_collaboration) values (1,'General',1,1,0)
END
set identity_insert channels off
GO

IF NOT EXISTS (SELECT file_name FROM pages 
         WHERE file_name='default.aspx')
BEGIN
	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties, root_id) values (
	1,1,0,1,1,1,1,1,'default.aspx','Home','','Home','main','','<p><img style="BORDER-RIGHT: #dcdcdc 5px solid; BORDER-TOP: #dcdcdc 5px solid; MARGIN-BOTTOM: 4px; BORDER-LEFT: #dcdcdc 5px solid; MARGIN-RIGHT: 7px; BORDER-BOTTOM: #dcdcdc 5px solid" alt="" src="resources/1/flower_yellow.jpg" align="left" border="0" />Lorem ipsum fierent mnesarchum ne vel, et usu posse takimata omittantur, pro ut tale erant sapientem. Et regione tibique ancillae nam. Tale modus iuvaret eu usu. Id labore semper voluptatum vel. Eu labore suscipit nam, in simul qualisque pri. </p>
	<p>Tempor nostrud explicari est eu, vim moderatius cotidieque ad, id novum everti qui. Per an errem iriure appareat, pri harum volumus definiebas eu, has ut munere vituperata. His diam consetetur et, ut sit quot utinam efficiantur, adhuc invenire assentior mei eu. Ne est nullam regione, porro admodum ei sit. Pro et velit dicant adolescens, ius at prodesset accommodare.Lorem ipsum fierent mnesarchum ne vel, et usu posse takimata omittantur, pro ut tale erant sapientem. Et regione tibique ancillae nam. Tale modus iuvaret eu usu. Id labore semper voluptatum vel. Eu labore suscipit nam, in simul qualisque pri. Tempor nostrud explicari est eu, vim moderatius cotidieque ad, id novum everti qui. </p>
	<p>Lorem ipsum fierent mnesarchum ne vel, et usu posse takimata omittantur, pro ut tale erant sapientem. Et regione tibique ancillae nam. Tale modus iuvaret eu usu. Id labore semper voluptatum vel. Eu labore suscipit nam, in simul qualisque pri. Lorem ipsum fierent mnesarchum ne vel, et usu posse takimata omittantur, pro ut tale erant sapientem. Et regione tibique ancillae nam. Tale modus iuvaret eu usu. Id labore semper voluptatum vel. Eu labore suscipit nam, in simul qualisque pri.</p>','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',0,0,'',0,0,1,1,0,'','','',getdate(),'',1
	)
END
GO

----------------------

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='price')
  alter table pages add price money NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='sale_price')
  alter table pages add sale_price money NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='weight')
  alter table pages add weight decimal(18, 0) NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='sku')
  alter table pages add sku nvarchar(50) NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='units_in_stock')
  alter table pages add units_in_stock int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='discount_percentage')
  alter table pages add discount_percentage money NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='properties')
  alter table pages add properties nvarchar(255) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='event_all_day')
  alter table pages add event_all_day bit NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='event_start_date')
  alter table pages add event_start_date datetime NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='event_end_date')
  alter table pages add event_end_date datetime NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='https')
  alter table pages add https bit DEFAULT 0 WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='root_id')
	alter table pages add root_id int NULL
GO
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='use_comments')
  alter table pages add use_comments bit NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='properties2')
  alter table pages add properties2 ntext DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='is_listing')
  alter table pages add is_listing bit DEFAULT 0 WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_type')
  alter table pages add listing_type int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_property')
  alter table pages add listing_property int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_datetime_format')
  alter table pages add listing_datetime_format nvarchar(50) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_columns')
  alter table pages add listing_columns int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_page_size')
  alter table pages add listing_page_size int NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='link')
  alter table pages add link ntext DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='link_target')
  alter table pages add link_target nvarchar(50) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='is_link')
  alter table pages add is_link bit DEFAULT 0 WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_template_id')
  alter table pages add listing_template_id int NULL
GO
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_use_categories')
  alter table pages add listing_use_categories bit DEFAULT 0 WITH VALUES
GO
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='elements')
  alter table pages add elements ntext DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_elements')
  alter table pages add listing_elements ntext DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='first_published_date')
  alter table pages add first_published_date datetime NULL
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='listing_default_order')
  alter table pages add listing_default_order nvarchar(255) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='file_view')
  alter table pages add file_view nvarchar(50) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='file_view_listing')
  alter table pages add file_view_listing nvarchar(50) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='tangible')
  alter table pages add tangible bit DEFAULT 0 WITH VALUES
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='pages' and sysobjects.type='U' and syscolumns.name='meta_title')
  alter table pages add meta_title ntext NULL
Go

ALTER TABLE pages ALTER COLUMN [created_date] DATETIME NULL
ALTER TABLE pages ALTER COLUMN [last_updated_date] DATETIME NULL
--ALTER TABLE pages ALTER COLUMN [summary] [ntext] NULL

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='channels' and sysobjects.type='U' and syscolumns.name='disable_collaboration')
  alter table channels add disable_collaboration bit DEFAULT 0 WITH VALUES
Go

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_comments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[page_comments] (
		[id] [int] IDENTITY(1,1) NOT NULL,
		[page_id] [int] NOT NULL,
		[message] [ntext] NOT NULL,
		[posted_by] [nvarchar](50) NOT NULL,
		[posted_date] [smalldatetime] NOT NULL,
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	ALTER TABLE [dbo].[page_comments] WITH NOCHECK ADD 
		CONSTRAINT [PK_page_comments] PRIMARY KEY  CLUSTERED 
		(
			[id]
		)  ON [PRIMARY] 
END
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='page_comments' and sysobjects.type='U' and syscolumns.name='email')
  alter table page_comments add email nvarchar(255) DEFAULT '' WITH VALUES
Go
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='page_comments' and sysobjects.type='U' and syscolumns.name='url')
  alter table page_comments add url nvarchar(255) DEFAULT '' WITH VALUES
Go

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'pages_comments_count' AND type = 'V') 
	DROP VIEW pages_comments_count
GO
CREATE VIEW dbo.pages_comments_count
AS
SELECT     page_id, COUNT(id) AS comments
FROM         dbo.page_comments
GROUP BY page_id
GO

--*******************************
--Insert content to Pages table
--*******************************

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_InsertContent' AND type = 'P')
   DROP PROCEDURE advcms_InsertContent
GO

CREATE PROCEDURE dbo.advcms_InsertContent (
    @refpageid  int,
    @refposition nvarchar(50),
    @islisting bit,

    @page_id    int,
    @version    int,
    @channel_id   int,
    @use_default_template bit,
    @template_id    int = NULL,
    @file_name   nvarchar(50),
    @file_size int,
    @title      nvarchar(255),
    @summary    ntext = NULL,   
    @price      money = NULL,
    @sale_price money = NULL,
    @discount_percentage int = NULL,
    @link_text  nvarchar(50),
    @link_placement  nvarchar(50),
    @content_left   ntext,
    @content_body   ntext,
    @content_right   ntext,
    @file_attachment nvarchar(255),
    @owner     nvarchar(50),
    @created_date   datetime,
    @last_updated_date datetime,
    @last_updated_by    nvarchar(50),
    @published_start_date datetime = NULL,
    @published_end_date datetime = NULL,
    @meta_keywords ntext,
    @meta_description ntext,
    @status nvarchar(50),
    @is_hidden bit,
    @is_system bit,
    @page_module nvarchar(255),
    @page_type int,
    @use_discussion bit,
    @use_rating bit,
    @use_comments bit,
    @allow_links_crawled bit,
    @allow_page_indexed bit,
    @is_marked_for_archival bit,
    @notes ntext,
    @display_date datetime = NULL,
    @properties nvarchar(255),
    @properties2 ntext,
    @root_id int,
    @https bit,
    @event_start_date datetime,
    @event_end_date datetime,
    @event_all_day bit,
    @is_listing bit,
	@listing_template_id int,
	@elements ntext,
	@listing_elements ntext,
    @link ntext,
    @link_target nvarchar(50),
    @is_link bit,
    @file_view nvarchar(255),
    @file_view_listing nvarchar(255),
    @tangible bit
) AS

DECLARE @SORT_INC int
SET @SORT_INC = 2

DECLARE @sorting int, @parent_id int, @tmplink_placement nvarchar(50)

DECLARE pages CURSOR FOR SELECT sorting, parent_id, link_placement FROM pages_latest_version WHERE page_id=@refpageid
OPEN pages
FETCH NEXT FROM pages INTO @sorting, @parent_id, @tmplink_placement
IF @@FETCH_STATUS=0 AND @islisting = 0
BEGIN
    IF @refposition='BEFORE'
        SET @sorting = @sorting-1
    else
        SET @sorting = @sorting+1
END
ELSE
    SET @sorting=0
    
CLOSE pages
DEALLOCATE pages

IF @refposition='UNDER'
BEGIN
    SET @parent_id = @refpageid
    IF @islisting = 0
    BEGIN
        DECLARE pages CURSOR FOR SELECT max(sorting) FROM pages WHERE parent_id=@refpageid
        OPEN pages
        FETCH NEXT FROM pages INTO @sorting
        IF @@FETCH_STATUS=0
            SET @sorting = @sorting + @SORT_INC
        ELSE
            SET @sorting = @SORT_INC
        CLOSE pages
        DEALLOCATE pages
    END
    ELSE
        SET @sorting=0
END

IF @link_placement<>''
BEGIN
SET @tmplink_placement = @link_placement     
END

DECLARE max_pageid CURSOR FOR SELECT MAX(page_id) FROM PAGES
OPEN max_pageid
FETCH NEXT FROM max_pageid INTO @page_id
IF @@FETCH_STATUS=0
    SET @page_id=@page_id+1
ELSE
    SET @page_id=1

INSERT INTO PAGES (page_id,
    version, parent_id, sorting, channel_id, 
    use_default_template, template_id, file_name, file_size, title, 
    summary, price, link_text, link_placement, content_left, content_body, 
    content_right, file_attachment, owner, created_date, last_updated_date, 
    last_updated_by, published_start_date, published_end_date, meta_keywords, 
    meta_description, status, is_hidden, is_system, page_module, page_type, use_discussion, use_rating, use_comments,
    allow_links_crawled, allow_page_indexed, is_marked_for_archival, notes, display_date, properties, properties2, https, root_id, event_all_day, event_start_date, event_end_date, is_listing, listing_template_id, elements, listing_elements, link, link_target, is_link, sale_price, discount_percentage, file_view, file_view_listing, tangible
) VALUES (@page_id,
    @version, @parent_id, @sorting, @channel_id, 
    @use_default_template, @template_id, @file_name, @file_size, @title, @summary, @price,
    @link_text, @tmplink_placement, @content_left, @content_body, 
    @content_right, @file_attachment, @owner,  @created_date, @last_updated_date, 
    @last_updated_by, @published_start_date, @published_end_date, 
    @meta_keywords, @meta_description, @status, 
    @is_hidden, @is_system, @page_module, @page_type, 
    @use_discussion, @use_rating, @use_comments, @allow_links_crawled, @allow_page_indexed,
    @is_marked_for_archival, @notes, @display_date, @properties, @properties2, @https, @root_id, @event_all_day, @event_start_date, @event_end_date, @is_listing, @listing_template_id, @elements, @listing_elements, @link, @link_target, @is_link, @sale_price, @discount_percentage, @file_view, @file_view_listing, @tangible
)

IF @islisting = 0
BEGIN
    DECLARE @newsorting int, @tmppageid int, @tmpversion int

    DECLARE allpages CURSOR FOR SELECT page_id, version, sorting FROM pages_latest_version WHERE parent_id=@parent_id ORDER BY sorting ASC
    OPEN allpages
    FETCH NEXT FROM allpages INTO @tmppageid, @tmpversion, @sorting

    DECLARE @count int
    SET @count = @SORT_INC
    WHILE @@FETCH_STATUS=0
    BEGIN
        UPDATE pages SET sorting=@count WHERE page_id=@tmppageid AND version=@tmpversion
        SET @count = @count+@SORT_INC
        FETCH NEXT FROM allpages INTO @tmppageid, @tmpversion, @sorting
    END
    CLOSE allpages
    DEALLOCATE allpages
END
SELECT * FROM PAGES WHERE page_id=@page_id

GO


--*******************************
--Get Latest Version
--*******************************

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_GET_LATEST_CONTENT_VERSION' AND type = 'P')
   DROP PROCEDURE advcms_GET_LATEST_CONTENT_VERSION
GO

CREATE PROCEDURE dbo.advcms_GET_LATEST_CONTENT_VERSION
    @page_id int
AS
DECLARE @maxversion int
DECLARE pages CURSOR FOR SELECT MAX(version) FROM pages WHERE page_id=@page_id
OPEN pages
FETCH NEXT FROM pages INTO @maxversion
IF @@FETCH_STATUS=0
    SELECT * FROM pages_working WHERE page_id=@page_id AND version=@maxversion
ELSE
    SELECT * FROM pages_working WHERE page_id=-1    
GO

--*******************************
--Check out content
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_CHECKOUT_CONTENT' AND type = 'P')
   DROP PROCEDURE advcms_CHECKOUT_CONTENT
GO

CREATE PROCEDURE dbo.advcms_CHECKOUT_CONTENT
    @page_id int,
    @version int,
    @checkout_by nvarchar(50)
AS
DECLARE @newversion int
SET @newversion = @version+1
INSERT INTO PAGES (page_id,
    version, parent_id, sorting, channel_id, 
    use_default_template, template_id, file_name, file_size, title, 
    summary, price, link_text, link_placement, content_left, content_body, 
    content_right, file_attachment, owner, created_date, last_updated_date, 
    last_updated_by, published_start_date, published_end_date,
    meta_title, meta_keywords, meta_description, status, is_hidden, 
    is_system, page_module, page_type, use_discussion, use_rating, use_comments,
    allow_links_crawled, allow_page_indexed, is_marked_for_archival, notes, display_date, properties, properties2, https, root_id, event_all_day, event_start_date, event_end_date, is_listing, listing_type, listing_property, listing_datetime_format, listing_columns, listing_page_size, listing_template_id, listing_use_categories, elements, listing_elements, first_published_date, listing_default_order, link, link_target, is_link, sale_price, discount_percentage, weight, sku, units_in_stock, file_view, file_view_listing, tangible
) 
SELECT page_id,
    @newversion, parent_id, sorting, channel_id, 
    use_default_template, template_id, file_name, file_size, title, 
    summary, price, link_text, link_placement, content_left, content_body, 
    content_right, file_attachment, owner, created_date, last_updated_date, 
    @checkout_by, published_start_date, published_end_date,
    meta_title, meta_keywords, meta_description, 'locked', is_hidden, 
    is_system, page_module, page_type, use_discussion, use_rating, use_comments,
    allow_links_crawled, allow_page_indexed, is_marked_for_archival, notes, display_date, properties, properties2, https, root_id, event_all_day, event_start_date, event_end_date, is_listing, listing_type, listing_property, listing_datetime_format, listing_columns, listing_page_size, listing_template_id, listing_use_categories, elements, listing_elements, first_published_date, listing_default_order, link, link_target, is_link, sale_price, discount_percentage, weight, sku, units_in_stock, file_view, file_view_listing, tangible
FROM PAGES
WHERE page_id=@page_id and version=@version

SELECT * FROM pages WHERE page_id=@page_id AND version=@newversion
GO

--*******************************
--move content
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_MOVE_CONTENT' AND type = 'P')
   DROP PROCEDURE advcms_MOVE_CONTENT
GO

CREATE PROCEDURE dbo.advcms_MOVE_CONTENT
    @page_id int,
    @version int,
    @refpageid int,
    @refposition nvarchar(10),
    @link_placement nvarchar(50)
AS

DECLARE @SORT_INC int
SET @SORT_INC = 2

DECLARE @sorting int, @parent_id int, @tmplink_placement nvarchar(50)

DECLARE pages CURSOR FOR SELECT sorting, parent_id, link_placement FROM pages_latest_version WHERE page_id=@refpageid
OPEN pages
FETCH NEXT FROM pages INTO @sorting, @parent_id, @tmplink_placement
IF @@FETCH_STATUS=0
BEGIN
    IF @refposition='BEFORE'
        SET @sorting = @sorting-1
    else
        SET @sorting = @sorting+1
END
CLOSE pages
DEALLOCATE pages

IF @refposition='UNDER'
BEGIN
    SET @parent_id = @refpageid
    DECLARE pages CURSOR FOR SELECT isnull(max(sorting), 0) FROM pages WHERE parent_id=@refpageid
    OPEN pages
    FETCH NEXT FROM pages INTO @sorting
    IF @@FETCH_STATUS=0
        SET @sorting = @sorting + @SORT_INC
    ELSE
        SET @sorting = @SORT_INC
    CLOSE pages
    DEALLOCATE pages
END

IF @link_placement <> ''
BEGIN
    SET @tmplink_placement = @link_placement
END

UPDATE pages SET parent_id=@parent_id, sorting=@sorting, link_placement=@tmplink_placement WHERE page_id=@page_id AND version=@version

--update sorting

DECLARE @newsorting int, @tmppageid int, @tmpversion int

DECLARE allpages CURSOR FOR 
SELECT page_id, version, sorting FROM 
  (SELECT page_id, version, sorting FROM pages_latest_version WHERE parent_id=@parent_id AND sorting<>0
   UNION ALL
   SELECT page_id, version, sorting FROM pages_published WHERE page_id=@page_id AND sorting<>0
  ) AS TEMP ORDER BY TEMP.sorting ASC

OPEN allpages
FETCH NEXT FROM allpages INTO @tmppageid, @tmpversion, @newsorting

DECLARE @count int
SET @count = @SORT_INC
WHILE @@FETCH_STATUS=0
BEGIN
    UPDATE pages SET sorting=@count WHERE page_id=@tmppageid AND version=@tmpversion
    SET @count = @count+@SORT_INC
    FETCH NEXT FROM allpages INTO @tmppageid, @tmpversion, @newsorting
END
CLOSE allpages
DEALLOCATE allpages

--end of update sorting

SELECT * FROM PAGES WHERE page_id=@page_id AND version=@version

GO

--*******************************
--update previous content status
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_PublishContent' AND type = 'P')
   DROP PROCEDURE advcms_PublishContent
GO

CREATE PROCEDURE dbo.advcms_PublishContent
    @page_id int,
    @version int
AS

Declare @dtpublish datetime
set @dtpublish = (select first_published_date from pages where page_id=@page_id and version=@version)
if @dtpublish is null
begin
	UPDATE pages SET first_published_date=GetDate() WHERE page_id=@page_id and version=@version
end
UPDATE pages SET status='published_archived' WHERE page_id=@page_id AND status='published'
UPDATE pages SET status='archived' WHERE page_id=@page_id AND status IN ('unlocked')
UPDATE pages SET status='published' WHERE page_id=@page_id and version=@version

SELECT * FROM pages WHERE page_id=@page_id and version=@version

GO


--*******************************
--update previous content status when delete
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ArchiveContent' AND type = 'P')
   DROP PROCEDURE advcms_ArchiveContent
GO

CREATE PROCEDURE dbo.advcms_ArchiveContent
    @page_id int,
    @version int
AS
UPDATE pages SET status='published_archived' WHERE page_id=@page_id AND status='published'
UPDATE pages SET status='archived' WHERE page_id=@page_id AND status IN ('unlocked')
UPDATE pages SET status='archived' WHERE page_id=@page_id and version=@version
SELECT * FROM pages WHERE page_id=@page_id and version=@version

GO

--*******************************
--Create channel
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_CreateChannel' AND type = 'P')
   DROP PROCEDURE advcms_CreateChannel
GO

CREATE PROCEDURE dbo.advcms_CreateChannel
    @channel_name nvarchar(50),
    @default_template_id int,
    @permission int,
    @disable_collaboration bit
AS
INSERT INTO channels (channel_name, default_template_id, permission, disable_collaboration) 
VALUES (@channel_name, @default_template_id, @permission, @disable_collaboration)
SELECT * FROM channels WHERE channel_id=SCOPE_IDENTITY()
GO

--*******************************
--Create template
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_CreateTemplate' AND type = 'P')
   DROP PROCEDURE advcms_CreateTemplate
GO

CREATE PROCEDURE dbo.advcms_CreateTemplate
    @template_name nvarchar(50),
    @folder_name nvarchar(50)
AS
INSERT INTO templates (template_name, folder_name) 
VALUES (@template_name, @folder_name)
SELECT * FROM templates WHERE template_id=SCOPE_IDENTITY()
GO

--*******************************
--get publised pages view
--*******************************
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'pages_published' AND type = 'V') 
	DROP VIEW pages_published
GO

CREATE VIEW dbo.pages_published
as
select top 100 percent
    allpages.page_id,
    allpages.version,
    allpages.parent_id,
    allpages.sorting,
    allpages.page_template_id as template_id,
    allpages.page_type,
    allpages.file_name as file_name,
    allpages.title,
    allpages.summary,
    allpages.price,
    allpages.link_text,
    allpages.link_placement,
    allpages.content_left,
    allpages.content_body,
    allpages.content_right,
    allpages.file_attachment,
    allpages.file_size,
    allpages.owner,
    allpages.created_date,
    allpages.last_updated_date,
    allpages.last_updated_by,
    allpages.published_start_date,
    allpages.published_end_date,
    allpages.meta_title,
    allpages.meta_keywords,
    allpages.meta_description,
    allpages.status,
    allpages.is_hidden,
    allpages.is_system,
    allpages.page_module,
    allpages.use_discussion,
    allpages.use_rating,
    allpages.use_comments,
    allpages.allow_links_crawled,
    allpages.allow_page_indexed,
    allpages.is_marked_for_archival,
    allpages.notes,
    allpages.display_date,
    allpages.properties,
    allpages.properties2,
    allpages.root_id,
    allpages.https,
    allpages.event_all_day,
    allpages.event_start_date,
    allpages.event_end_date,
    allpages.is_listing,
    allpages.listing_datetime_format,
	allpages.listing_template_id,
	allpages.elements,
	allpages.listing_elements,
	allpages.first_published_date,
    allpages.link,
    allpages.link_target,
    allpages.is_link,
	allpages.sale_price,
	allpages.discount_percentage,
	allpages.weight,
	allpages.sku,
	allpages.units_in_stock,
	allpages.file_view,
	allpages.file_view_listing,
	allpages.tangible,
    templates.template_name,
    templates.folder_name,
    channels.channel_id,
    channels.channel_name,
    channels.permission as channel_permission,
    channels.disable_collaboration as disable_collaboration,
    listing_templates.listing_script as listing_script,
    listing_templates.listing_type as listing_type,
	listing_templates.listing_property as listing_property,
	listing_templates.listing_columns as listing_columns,
	listing_templates.listing_page_size as listing_page_size,
	listing_templates.listing_use_categories as listing_use_categories,
	listing_templates.listing_default_order as listing_default_order
from (
select pages.*, template_id as page_template_id from pages where use_default_template=0 and status='published'
union all
select pages.*, channels.default_template_id as page_template_id from pages join channels on pages.channel_id=channels.channel_id where 
use_default_template=1  and status='published'
) as allpages join templates on allpages.page_template_id=templates.template_id
join channels on allpages.channel_id=channels.channel_id
left outer join listing_templates on allpages.listing_template_id=listing_templates.id
order by allpages.parent_id, allpages.sorting

GO

--*******************************
--Latest Version
--*******************************
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'pages_latest_version' AND type = 'V') 
	DROP VIEW pages_latest_version
GO

CREATE VIEW dbo.pages_latest_version
AS
SELECT pages.* 
FROM  pages join 
      (SELECT page_id, MAX(version) AS latest_version
        FROM          pages
        WHERE      status <> 'archived'
        GROUP BY page_id
       ) as tempTable ON pages.page_id = tempTable.page_id AND pages.version=tempTable.latest_version
GO

--*******************************
--get working copy view
--*******************************
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'pages_working' AND type = 'V') 
	DROP VIEW pages_working 
GO

CREATE VIEW dbo.pages_working
as
select top 100 percent
    allpages.page_id,
    allpages.version,
    allpages.parent_id,
    allpages.sorting,
    allpages.use_default_template,
    allpages.page_template_id as template_id,
    allpages.page_type,
    allpages.file_name as file_name,
    allpages.title,
    allpages.summary,
    allpages.price,
    allpages.link_text,
    allpages.link_placement,
    allpages.content_left,
    allpages.content_body,
    allpages.content_right,
    allpages.file_attachment,
    allpages.file_size,
    allpages.owner,
    allpages.created_date,
    allpages.last_updated_date,
    allpages.last_updated_by,
    allpages.published_start_date,
    allpages.published_end_date,
    allpages.meta_title,
    allpages.meta_keywords,
    allpages.meta_description,
    allpages.status,
    allpages.is_hidden,
    allpages.is_system,
    allpages.page_module,
    allpages.use_discussion,
    allpages.use_rating,
    allpages.use_comments,
    allpages.allow_links_crawled,
    allpages.allow_page_indexed,
    allpages.is_marked_for_archival,
    allpages.notes,
    allpages.display_date,
    allpages.properties,
    allpages.properties2,
    allpages.root_id,
    allpages.https,
    allpages.event_all_day,
    allpages.event_start_date,
    allpages.event_end_date,
    allpages.is_listing,
    allpages.listing_datetime_format,
	allpages.listing_template_id,
	allpages.elements,
	allpages.listing_elements,
	allpages.first_published_date,
    allpages.link,
    allpages.link_target,    
    allpages.is_link, 
	allpages.sale_price,
	allpages.discount_percentage,
	allpages.weight,
	allpages.sku,
	allpages.units_in_stock,
	allpages.file_view,
	allpages.file_view_listing,
	allpages.tangible,
    templates.template_name,
    templates.folder_name,
    channels.channel_id,
    channels.channel_name,
    channels.permission as channel_permission,
    channels.disable_collaboration as disable_collaboration,
    listing_templates.listing_script as listing_script,
    listing_templates.listing_type as listing_type,
	listing_templates.listing_property as listing_property,
	listing_templates.listing_columns as listing_columns,
	listing_templates.listing_page_size as listing_page_size,
	listing_templates.listing_use_categories as listing_use_categories,
	listing_templates.listing_default_order as listing_default_order,
    pages_published.title as title2,
    pages_published.file_name as file_name2,
    pages_published.link_text as link_text2,
    pages_published.summary as summary2,
    pages_published.content_body as content_body2,
    pages_published.display_date as display_date2,
    pages_published.price as price2,
    pages_published.event_all_day as event_all_day2,
    pages_published.event_start_date as event_start_date2,
    pages_published.event_end_date as event_end_date2,
    pages_published.file_attachment as file_attachment2,
    pages_published.version as version2,
    pages_published.is_listing as is_listing2,
    pages_published.link as link2,
    pages_published.link_target as link_target2,
    pages_published.is_link as is_link2,
    pages_published.last_updated_by as last_updated_by2,
    pages_published.last_updated_date as last_updated_date2,
    pages_published.file_size as file_size2,
    pages_published.sale_price as sale_price2,
	pages_published.discount_percentage as discount_percentage2,
	pages_published.weight as weight2,
	pages_published.sku as sku2,
	pages_published.units_in_stock as units_in_stock2,
	pages_published.file_view as file_view2,
	pages_published.file_view_listing as file_view_listing2,
	pages_published.tangible as tangible2,
	pages_published.listing_script as listing_script2,
    pages_published.listing_type as listing_type2,
	pages_published.listing_property as listing_property2,
	pages_published.listing_columns as listing_columns2,
	pages_published.listing_page_size as listing_page_size2,
	pages_published.listing_use_categories as listing_use_categories2,
	pages_published.listing_default_order as listing_default_order2
from (
select pages.*, template_id as page_template_id from pages_latest_version as pages where use_default_template=0 AND status not in ('published_archived','archived')
union all
select pages.*, channels.default_template_id as page_template_id from pages_latest_version as pages join channels on pages.channel_id=channels.channel_id 
where use_default_template=1  AND status not in ('published_archived' ,'archived')
) as allpages left join templates on allpages.page_template_id=templates.template_id
left join channels on allpages.channel_id=channels.channel_id
left outer join listing_templates on allpages.listing_template_id=listing_templates.id
left join pages_published as pages_published on allpages.page_id=pages_published.page_id
order by allpages.parent_id, allpages.sorting

GO

--*******************************
--Update channel, include sub content.
--*******************************
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_UpdateChannel_RECUR' AND type = 'P')
   DROP PROCEDURE advcms_UpdateChannel_RECUR
GO
CREATE PROCEDURE dbo.advcms_UpdateChannel_RECUR
    @page_id int,
    @version int,
    @channel_id int
AS
SELECT NULL
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_UpdateChannel' AND type = 'P')
   DROP PROCEDURE advcms_UpdateChannel
GO
create procedure dbo.advcms_UpdateChannel (
    @page_id int,
    @version int,
    @channel_id int
) AS
UPDATE pages SET channel_id=@channel_id WHERE page_id=@page_id AND @version=@version

DECLARE @tmppage_id int, @tmpversion int
DECLARE childPages CURSOR LOCAL FOR SELECT page_id, version FROM pages_latest_version WHERE parent_id=@page_id
OPEN childPages
FETCH NEXT FROM childPages INTO @tmppage_id, @tmpversion
WHILE @@FETCH_STATUS=0
BEGIN
    EXECUTE advcms_UpdateChannel_RECUR @page_id=@tmppage_id, @version=@tmpversion, @channel_id=@channel_id
    FETCH NEXT FROM childPages INTO @tmppage_id, @tmpversion
END
CLOSE childPages
DEALLOCATE childPages
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_UpdateChannel_RECUR' AND type = 'P')
   DROP PROCEDURE advcms_UpdateChannel_RECUR
GO
create procedure dbo.advcms_UpdateChannel_RECUR (
    @page_id int,
    @version int,
    @channel_id int
) AS
UPDATE pages SET channel_id=@channel_id WHERE page_id=@page_id AND @version=@version
DECLARE @tmppage_id int, @tmpversion int
DECLARE childPages CURSOR LOCAL FOR SELECT page_id, version FROM pages_latest_version WHERE parent_id=@page_id
OPEN childPages
FETCH NEXT FROM childPages INTO @tmppage_id, @tmpversion
WHILE @@FETCH_STATUS=0
BEGIN
    EXECUTE advcms_UpdateChannel @page_id=@tmppage_id, @version=@tmpversion, @channel_id=@channel_id
    FETCH NEXT FROM childPages INTO @tmppage_id, @tmpversion
END
CLOSE childPages
DEALLOCATE childPages
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_FIX_SORTING' AND type = 'P')
   DROP PROCEDURE advcms_FIX_SORTING
GO

-- ADDITIONAL --

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_GetPath' AND type = 'P')
   DROP PROCEDURE advcms_GetPath
GO
CREATE PROCEDURE dbo.advcms_GetPath
    @page_id int
AS
BEGIN
	DECLARE @parent_id int, @file_name nvarchar(50), @title nvarchar(255), @link_text nvarchar(255)

    	CREATE TABLE #PagePath (IndexId int IDENTITY (0, 1) NOT NULL,page_id int, parent_id int, file_name nvarchar(50), title nvarchar(255), link_text nvarchar(255))

	-- Current
	DECLARE pagesTmp CURSOR LOCAL FOR SELECT parent_id, file_name, title, link_text FROM pages_published WHERE page_id=@page_id
	OPEN pagesTmp
	FETCH NEXT FROM pagesTmp INTO @parent_id, @file_name, @title, @link_text
	WHILE @@FETCH_STATUS=0
	BEGIN
    		FETCH NEXT FROM pagesTmp INTO @parent_id, @file_name, @title, @link_text
	END
	CLOSE pagesTmp
	DEALLOCATE pagesTmp

	--IF @link_text <> NULL OR @link_text<>''
	--	SET @title=@link_text
	INSERT INTO #PagePath (page_id, parent_id, file_name, title,link_text) VALUES (@page_id,@parent_id,@file_name,@title,@link_text)

	WHILE @parent_id <> 0
	BEGIN
		IF NOT EXISTS (SELECT parent_id FROM pages_published WHERE page_id = @page_id)
			SET @parent_id = 0 -- Kalau ada yg blm terpublish, berhenti
			
		SET @page_id = (SELECT parent_id FROM pages_published WHERE page_id = @page_id)

		DECLARE pagesTmp CURSOR LOCAL FOR SELECT parent_id, file_name, title, link_text FROM pages_published WHERE page_id=@page_id
		OPEN pagesTmp
		FETCH NEXT FROM pagesTmp INTO @parent_id, @file_name, @title, @link_text
		WHILE @@FETCH_STATUS=0
		BEGIN
    			FETCH NEXT FROM pagesTmp INTO @parent_id, @file_name, @title, @link_text
		END
		CLOSE pagesTmp
		DEALLOCATE pagesTmp

		--IF @link_text <> NULL OR @link_text<>''
		--	SET @title=@link_text
		INSERT INTO #PagePath (page_id, parent_id, file_name, title,link_text) VALUES (@page_id,@parent_id,@file_name,@title,@link_text)
	END
	SELECT * FROM #PagePath ORDER BY IndexId DESC

	DROP TABLE #PagePath
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_GetPath2' AND type = 'P')
   DROP PROCEDURE advcms_GetPath2
GO
CREATE PROCEDURE dbo.advcms_GetPath2
    @page_id int
AS
BEGIN
	DECLARE @parent_id int, @page_type int, @file_name nvarchar(50), @title nvarchar(255), @link_text nvarchar(255), @published_start_date smalldatetime, @published_end_date smalldatetime, @is_hidden bit, @is_system bit, @channel_name nvarchar(50), @channel_permission int, @disable_collaboration bit, @last_updated_date datetime, @status nvarchar(50), @owner nvarchar(50), @title2 nvarchar(255), @link_text2 nvarchar(255)


    	CREATE TABLE #PagePath (IndexId int IDENTITY (0, 1) NOT NULL,page_id int, parent_id int, page_type int, file_name nvarchar(50), title nvarchar(255), link_text nvarchar(255), published_start_date smalldatetime, published_end_date smalldatetime, is_hidden bit, is_system bit, channel_name nvarchar(50), channel_permission int, disable_collaboration bit, last_updated_date datetime, status nvarchar(50), owner nvarchar(50), title2 nvarchar(255), link_text2 nvarchar(255))

	-- Current
	DECLARE pagesTmp CURSOR LOCAL FOR SELECT parent_id, page_type, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2 FROM pages_working WHERE page_id=@page_id
	OPEN pagesTmp
	FETCH NEXT FROM pagesTmp INTO @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2
	WHILE @@FETCH_STATUS=0
	BEGIN
    		FETCH NEXT FROM pagesTmp INTO @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2
	END
	CLOSE pagesTmp
	DEALLOCATE pagesTmp

	--IF @link_text <> NULL OR @link_text<>''
	--	SET @title=@link_text
	INSERT INTO #PagePath (page_id, parent_id, page_type, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2) VALUES (@page_id, @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2)

	WHILE @parent_id <> 0 -- @page_id <> 1
	BEGIN
		SET @page_id = (SELECT parent_id FROM pages_working WHERE page_id = @page_id)

		DECLARE pagesTmp CURSOR LOCAL FOR SELECT parent_id, page_type, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2 FROM pages_working WHERE page_id=@page_id
		OPEN pagesTmp
		FETCH NEXT FROM pagesTmp INTO @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2
		WHILE @@FETCH_STATUS=0
		BEGIN
    			FETCH NEXT FROM pagesTmp INTO @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2
		END
		CLOSE pagesTmp
		DEALLOCATE pagesTmp

		--IF @link_text <> NULL OR @link_text<>''
		--	SET @title=@link_text
		INSERT INTO #PagePath (page_id, parent_id, page_type, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2) VALUES (@page_id, @parent_id, @page_type, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2)
	END
	SELECT * FROM #PagePath ORDER BY IndexId DESC

	DROP TABLE #PagePath
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ShowPageMenu' AND type = 'P')
   DROP PROCEDURE advcms_ShowPageMenu
GO
CREATE PROC dbo.advcms_ShowPageMenu
	@page_id int
AS
BEGIN
	DECLARE @parent_id int
	Select @parent_id=parent_id from pages_published where page_id=@page_id
	
	DECLARE @listing_property int, @is_listing bit --same level
	select @listing_property=listing_property, @is_listing=is_listing from pages_published where page_id=@parent_id
	
	DECLARE @listing_property2 int, @is_listing2 bit --page within
	select @listing_property2=listing_property, @is_listing2=is_listing from pages_published where page_id=@page_id


	if (@is_listing=0 or(@is_listing=1 and @listing_property=1)) and 
		(@is_listing2=0 or(@is_listing2=1 and @listing_property2=1))
	begin
		select * from (
		select * from pages_published where parent_id=@parent_id
		union all
		select * from pages_published where parent_id=@page_id
		) as tmp order by parent_id, sorting
	end
	
	if (@is_listing=0 or(@is_listing=1 and @listing_property=1)) and 
		(@is_listing2=1 and @listing_property2<>1)
	begin
		select * from pages_published where parent_id=@parent_id order by sorting
	end
	
	if (@is_listing=1 and @listing_property<>1) and 
		(@is_listing2=0 or(@is_listing2=1 and @listing_property2=1))
	begin
		select * from pages_published where parent_id=@page_id order by sorting
	end
	
	if (@is_listing=1 and @listing_property<>1) and 
		(@is_listing2=1 and @listing_property2<>1)
	begin
		select * from pages_published where @page_id=0 --no return
	end
	
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ShowPageMenu2' AND type = 'P')
   DROP PROCEDURE advcms_ShowPageMenu2
GO
CREATE PROC dbo.advcms_ShowPageMenu2
	@page_id int
AS
BEGIN
	DECLARE @parent_id int
	Select @parent_id=parent_id from pages_working where page_id=@page_id
	
	DECLARE @listing_property int, @is_listing bit --same level
	select @listing_property=listing_property, @is_listing=is_listing from pages_working where page_id=@parent_id
	
	DECLARE @listing_property2 int, @is_listing2 bit --page within
	select @listing_property2=listing_property, @is_listing2=is_listing from pages_working where page_id=@page_id

	if (@is_listing=0 or(@is_listing=1 and @listing_property=1)) and 
		(@is_listing2=0 or(@is_listing2=1 and @listing_property2=1))
	begin
		select * from (
		select * from pages_working where parent_id=@parent_id and is_system=0
		union all
		select * from pages_working where parent_id=@page_id and is_system=0
		) as tmp order by parent_id, sorting
	end
	
	if (@is_listing=0 or(@is_listing=1 and @listing_property=1)) and 
		(@is_listing2=1 and @listing_property2<>1)
	begin
		select * from pages_working where parent_id=@parent_id and is_system=0 order by sorting
	end
	
	if (@is_listing=1 and @listing_property<>1) and 
		(@is_listing2=0 or(@is_listing2=1 and @listing_property2=1))
	begin
		select * from pages_working where parent_id=@page_id and is_system=0 order by sorting
	end
	
	if (@is_listing=1 and @listing_property<>1) and 
		(@is_listing2=1 and @listing_property2<>1)
	begin
		select * from pages_working where @page_id=0 and is_system=0--no return
	end

END
GO


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ShowTopBottomMenu' AND type = 'P')
   DROP PROCEDURE advcms_ShowTopBottomMenu
GO
CREATE PROC dbo.advcms_ShowTopBottomMenu 
	@page_id int
AS
BEGIN
	DECLARE @root int, @parent_id int

	SET @parent_id = (SELECT parent_id FROM pages_working WHERE page_id = @page_id)
	WHILE @parent_id <> 0
	BEGIN		
		SET @page_id=@parent_id
		SET @parent_id = (SELECT parent_id FROM pages_working WHERE page_id = @page_id)		
	END
	SET @root=@page_id

	Select * From pages_published where parent_id= @root AND (link_placement='top' or link_placement='bottom') order by parent_id, sorting
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ShowTopBottomMenu2' AND type = 'P')
   DROP PROCEDURE advcms_ShowTopBottomMenu2
GO
CREATE PROC dbo.advcms_ShowTopBottomMenu2
	@page_id int
AS
BEGIN
	DECLARE @root int, @parent_id int

	SET @parent_id = (SELECT parent_id FROM pages_working WHERE page_id = @page_id)
	WHILE @parent_id <> 0
	BEGIN		
		SET @page_id=@parent_id
		SET @parent_id = (SELECT parent_id FROM pages_working WHERE page_id = @page_id)		
	END
	SET @root=@page_id

	Select * From pages_working where parent_id=@root AND (link_placement='top' or link_placement='bottom') order by parent_id, sorting
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_PageMain2' AND type = 'P')
   DROP PROCEDURE advcms_PageMain2
GO
CREATE procedure advcms_PageMain2 (@page_id int) as
--set nocount on

declare @current int, @maxlvl int, @listingProperty int, @isListing bit
select @current=root_id from pages where page_id=@page_id
select @listingProperty=listing_property, @isListing=is_listing from pages_working where page_id=@current
select @maxlvl=3

declare @level int, @line int
create table #stack (item int, sorting int, listing_property int, is_listing bit, level int)
insert into #stack values (@current, 0, @listingProperty, @isListing, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         select top 1 @current=item, @listingProperty=listing_property, @isListing=is_listing from #stack where level=@level order by sorting asc
         
         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current
    
         if @isListing=0 or @listingProperty=1 --@listingProperty<>2 and @listingProperty<>3
         begin
             insert #stack
                select page_id, sorting, listing_property, is_listing, @level + 1
                from pages_working
                where parent_id = @current and link_placement='main' order by sorting

             if @@rowcount > 0
                select @level = @level + 1
         end
      end
   else
      select @level = @level - 1
end -- while
drop table #stack

select  
    t2.page_id, t2.parent_id, t2.sorting, t2.listing_property, t2.file_name, t2.title, t2.link_text, 
    t2.published_start_date, t2.published_end_date, t2.is_hidden, t2.is_system, t2.channel_name, 
    t2.channel_permission, t2.disable_collaboration, t2.last_updated_date, t2.status, t2.owner, 
    t2.title2, t2.link_text2, t2.is_link, t2.link_target, t2.link_target2, 
    t1.level as lvl
from @tmp as t1 left join pages_working as t2 on (t1.page_id=t2.page_id) order by t1.recidx

GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_PageMain' AND type = 'P')
   DROP PROCEDURE advcms_PageMain
GO
CREATE procedure advcms_PageMain (@page_id int) as
--set nocount on

declare @current int, @maxlvl int, @listingProperty int, @isListing bit
select @current=root_id from pages where page_id=@page_id
select @listingProperty=listing_property, @isListing=is_listing from pages_published where page_id=@current
select @maxlvl=3

declare @level int, @line int
create table #stack (item int, sorting int, listing_property int, is_listing bit, level int)
insert into #stack values (@current, 0, @listingProperty, @isListing, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         select top 1 @current=item, @listingProperty=listing_property, @isListing=is_listing from #stack where level=@level order by sorting asc
         
         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current
    
         if @isListing=0 or @listingProperty=1 --@listingProperty<>2 and @listingProperty<>3
         begin
             insert #stack
                select page_id, sorting, listing_property, is_listing, @level + 1
                from pages_published
                where parent_id = @current and link_placement='main' order by sorting

             if @@rowcount > 0
                select @level = @level + 1
         end
      end
   else
      select @level = @level - 1
end -- while
drop table #stack

select  
    t2.page_id, t2.sorting, t2.parent_id, t2.listing_property, t2.file_name, 
    t2.title, t2.link_text, t2.published_start_date, t2.published_end_date, 
    t2.is_hidden, t2.is_system, t2.channel_name, t2.channel_permission,
    t1.level as lvl, t2.is_link, t2.link_target 
from @tmp as t1 left join pages_published as t2 on (t1.page_id=t2.page_id) order by t1.recidx
GO


-- Optimize

IF EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_parent')
   DROP INDEX pages.IX_parent
GO

CREATE NONCLUSTERED INDEX IX_parent ON pages (parent_id)
GO

IF EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_link_placement')
   DROP INDEX pages.IX_link_placement
GO

CREATE NONCLUSTERED INDEX IX_link_placement ON pages (link_placement)
GO

IF EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_file_name')
   DROP INDEX pages.IX_file_name
GO

CREATE NONCLUSTERED INDEX IX_file_name ON pages (file_name)
GO

IF NOT EXISTS (SELECT file_name FROM pages 
         WHERE file_name='preferences.aspx')
BEGIN

    DECLARE @nPageId int
    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1

    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,8,40,1,1,1,1,'preferences.aspx','Preferences','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/preferences.ascx',0,0,1,1,0,'','','',getdate()
    )

END
GO

update pages set sorting=2 where sorting is null;
update pages set sorting=2 where file_name='account.aspx';
update pages set sorting=4 where file_name='preferences.aspx';
update pages set sorting=6 where file_name='pages.aspx';
update pages set sorting=8 where file_name='resources.aspx';
update pages set sorting=10 where file_name='approval.aspx';
update pages set sorting=2 where file_name='admin_channels.aspx';
update pages set sorting=4 where file_name='admin_users.aspx';
update pages set sorting=6 where file_name='admin_templates.aspx';
update pages set sorting=8 where file_name='admin_modules.aspx';
GO

--*******************************
--Events
--*******************************

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[events]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[events] (
	    [event_id] [int] IDENTITY (1, 1) NOT NULL ,
	    [title] [nvarchar] (50) NOT NULL ,
	    [description] [nvarchar] (255) NULL ,
	    [is_allday] [bit] NOT NULL ,
	    [from_date] [datetime] NOT NULL ,
	    [to_date] [datetime] NOT NULL ,
	    [repeat] [int] NOT NULL ,
	    [until] [smalldatetime] NOT NULL ,
	    [reminder] [int] NULL ,
	    [reminder_id] [int] NULL ,
	    [page] [nvarchar] (50) NULL ,
	    [type] [int] NULL ,
	    [author] [nvarchar] (50) NULL ,
	    [parent_id] [int] NOT NULL
    ) ON [PRIMARY]
END

GO

DECLARE @nPageIdTmp int
DECLARE @nPageId int
DECLARE @nSortingMax int

IF NOT EXISTS (SELECT file_name FROM pages 
    WHERE file_name='events.aspx' OR file_name='event_new.aspx' OR file_name='event_edit.aspx')
BEGIN
    SET @nPageIdTmp = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageIdTmp,1,8,2,1,1,1,1,'events.aspx','Events','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/events.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,@nPageIdTmp,2,1,1,1,1,'event_new.aspx','New Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_new.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,@nPageIdTmp,4,1,1,1,1,'event_edit.aspx','Edit Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_edit.ascx',0,0,0,0,0,'','','',getdate()
    )
    
    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,@nPageIdTmp,6,1,1,1,1,'event_embed.aspx','Embed Upcoming Event List','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_embed.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nSortingMax = (SELECT MAX(sorting) FROM pages WHERE parent_id=8) + 2
    update pages set sorting=@nSortingMax where file_name='events.aspx';
END

GO

ALTER TABLE events ALTER COLUMN [description] NVARCHAR(255) NULL

GO

--*******************************
--Polls
--*******************************

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[poll_answers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[poll_answers] (
	    [poll_answer_id] [int] IDENTITY (1, 1) NOT NULL ,
	    [poll_id] [int] NOT NULL ,
	    [answer] [ntext] NULL ,
	    [total] [int] NULL 
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[polls]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[polls] (
	    [poll_id] [int] IDENTITY (1, 1) NOT NULL ,
	    [question] [nvarchar] (50) NULL 
    ) ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[poll_voters]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[poll_voters] (
        [poll_voter] [int] IDENTITY (1, 1) NOT NULL ,
        [poll_id] [int] NOT NULL ,
        [ip_voter] [varchar] (50) NOT NULL
    ) ON [PRIMARY]
END
GO

ALTER TABLE polls ALTER COLUMN [question] NVARCHAR(255) NULL
GO


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_SiteMap2' AND type = 'P')
   DROP PROCEDURE advcms_SiteMap2
GO
CREATE procedure advcms_SiteMap2 (@root_id int, @maxlvl int = 5, @link_placement nvarchar(50) = 'main') as

declare @current int, @listingProperty int, @isListing bit
select @current=@root_id
select @listingProperty=listing_property, @isListing=is_listing from pages_working where page_id=@current

declare @level int, @line int
create table #stack (item int, sorting int, listing_property int, is_listing bit, level int)
insert into #stack values (@current, 0, @listingProperty, @isListing, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         select top 1 @current=item, @listingProperty=listing_property, @isListing=is_listing from #stack where level=@level order by sorting asc
         
         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current

         if @isListing=0 or @listingProperty=1 --@listingProperty<>2 and @listingProperty<>3
         begin
             insert #stack
                select page_id, sorting, listing_property, is_listing, @level + 1
                from pages_working
                where parent_id = @current and link_placement=@link_placement and is_system=0 order by sorting

             if @@rowcount > 0
                select @level = @level + 1
         end
      end
   else
      select @level = @level - 1
end -- while
drop table #stack

if @link_placement<>'main' 
    delete from @tmp where page_id=@root_id

select  
    t2.page_id, t2.parent_id, t2.sorting, t2.listing_property, t2.file_name, t2.title, t2.link_text, 
    t2.published_start_date, t2.published_end_date, t2.is_hidden, t2.is_system, t2.channel_name, 
    t2.channel_permission, t2.disable_collaboration, t2.last_updated_date, t2.status, t2.owner, 
    t2.title2, t2.link_text2, t2.is_link, t2.link_target, t2.link_target2,
    t1.level as lvl
from @tmp as t1 left join pages_working as t2 on (t1.page_id=t2.page_id) order by t1.recidx

go

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_SiteMap' AND type = 'P')
   DROP PROCEDURE advcms_SiteMap
GO
CREATE procedure advcms_SiteMap (@root_id int, @maxlvl int = 5, @link_placement nvarchar(50) = 'main') as

declare @current int, @listingProperty int, @isListing bit
select @current=@root_id
select @listingProperty=listing_property, @isListing=is_listing from pages_published where page_id=@current

declare @level int, @line int
create table #stack (item int, sorting int, listing_property int, is_listing bit, level int)
insert into #stack values (@current, 0, @listingProperty, @isListing, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         select top 1 @current=item, @listingProperty=listing_property, @isListing=is_listing from #stack where level=@level order by sorting asc
         
         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current
    
         if @isListing=0 or @listingProperty=1 --@listingProperty<>2 and @listingProperty<>3
         begin
             insert #stack
                select page_id, sorting, listing_property, is_listing, @level + 1
                from pages_published
                where parent_id = @current and link_placement=@link_placement and is_system=0 order by sorting

             if @@rowcount > 0
                select @level = @level + 1
         end

		
      end
   else
      select @level = @level - 1
end -- while
drop table #stack

if @link_placement<>'main' 
    delete from @tmp where page_id=@root_id

select  
    t2.page_id, t2.sorting, t2.parent_id, t2.listing_property, t2.file_name, 
    t2.title, t2.link_text, t2.published_start_date, t2.published_end_date, 
    t2.is_hidden, t2.is_system, t2.channel_name, t2.channel_permission,
    t1.level as lvl, t2.is_link, t2.link_target
from @tmp as t1 left join pages_published as t2 on (t1.page_id=t2.page_id) order by t1.recidx

go

-- Sitemap

UPDATE pages set is_system=0, page_module='' where [file_name]='sitemap.aspx'
IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='sitemap.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('sitemap.ascx','Site Map','admin')
END

/*
DECLARE @nPageId int

SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
IF NOT EXISTS (SELECT file_name FROM pages WHERE file_name='admin_localization.aspx')
BEGIN
    INSERT INTO pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,3,10,1,1,1,1,'admin_localization.aspx','Localization','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/localization.ascx',0,0,0,0,0,'','','',getdate())
END*/

GO

-- Locales

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[locales]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[locales] (
	    [locale_id] [int] IDENTITY (1, 1) NOT NULL ,
	    [home_page] [nvarchar] (50) NULL, 
	    [description] [nvarchar] (255) NULL, 
	    [instruction_text] [nvarchar] (255) NULL, 
	    [culture] [nvarchar] (50) NULL, 
	    [active] [bit] NULL
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[locales] WITH NOCHECK ADD 
        CONSTRAINT [PK_locales] PRIMARY KEY  CLUSTERED 
        (
            [locale_id]
        )  ON [PRIMARY] 

END
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_name')
  alter table locales add site_name nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_address')
  alter table locales add site_address nvarchar(255) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_city')
  alter table locales add site_city nvarchar(100) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_state')
  alter table locales add site_state nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_country')
  alter table locales add site_country nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_zip')
  alter table locales add site_zip nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_phone')
  alter table locales add site_phone nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_fax')
  alter table locales add site_fax nvarchar(50) DEFAULT '' WITH VALUES
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='site_email')
  alter table locales add site_email nvarchar(50) DEFAULT '' WITH VALUES
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='locales' and sysobjects.type='U' and syscolumns.name='culture')
  ALTER TABLE locales ADD [culture] [nvarchar] (50)
Go
IF NOT EXISTS (SELECT * FROM locales WHERE home_page='default.aspx')
BEGIN
    INSERT INTO locales (home_page,description,instruction_text,culture,active) values 
    ('default.aspx','United States (US English)','Select Country/Region','en-US',1)
END
go
IF EXISTS (SELECT * FROM locales WHERE home_page='default.aspx' AND culture IS NULL)
BEGIN
    UPDATE locales set culture='en-US' where home_page='default.aspx'
END
go

--  German

IF NOT EXISTS (SELECT * FROM locales WHERE home_page='default-de.aspx')
BEGIN
    INSERT INTO locales (home_page,description,instruction_text,culture,active) values 
    ('default-de.aspx','Germany (German)','Auswahl Land / Region','de-DE',0)
END
go
IF EXISTS (SELECT * FROM locales WHERE home_page='default-de.aspx' AND culture IS NULL)
BEGIN
    UPDATE locales set culture='de-DE' where home_page='default-de.aspx'
END
go
DECLARE @nPageId int
SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
IF NOT EXISTS (SELECT * FROM pages WHERE file_name='default-de.aspx')
BEGIN
    INSERT INTO pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties, root_id) values (
    @nPageId,1,0,1,1,1,1,1,'default-de.aspx','Home','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',0,0,'',0,0,0,0,0,'','','',getdate(),'',@nPageId
    )
END

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_GetRegion' AND type = 'P')
   DROP PROCEDURE advcms_GetRegion
GO
CREATE PROCEDURE dbo.advcms_GetRegion
	@root_id int
AS
BEGIN
	DECLARE @parent_id int, @root int, @file_name nvarchar(50)

	SET @file_name = (SELECT file_name FROM pages_working where page_id=@root_id)
	SELECT * FROM locales WHERE home_page=@file_name
END

GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_DeleteLocale' AND type = 'P')
   DROP PROCEDURE advcms_DeleteLocale
GO
CREATE PROCEDURE dbo.advcms_DeleteLocale 
	@locale_id int
AS
BEGIN
	DECLARE @file_name nvarchar(50), @page_id int
	SET @file_name=(select home_page from locales where locale_id=@locale_id)
	SET @page_id = (SELECT page_id FROM pages_working  WHERE file_name=@file_name)

	DECLARE @a nvarchar(250)
	SELECT @a = '%_' + CAST(@page_id AS VARCHAR(20)) + '.aspx'
	DELETE FROM pages WHERE file_name like @a and is_system=1
	DELETE FROM pages WHERE page_id=@page_id
	DELETE FROM locales WHERE locale_id=@locale_id
	
	SELECT * FROM locales WHERE locale_id=@locale_id
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_InsertLocale' AND type = 'P')
   DROP PROCEDURE advcms_InsertLocale
GO
CREATE PROCEDURE dbo.advcms_InsertLocale 
	@home_page nvarchar(50), @description nvarchar(255), @instruction_text nvarchar(255), @culture nvarchar(50), @channel_id int, @active bit, @site_name nvarchar(50), @site_address nvarchar(255), @site_city nvarchar(100), @site_state nvarchar(50), @site_country nvarchar(50), @site_zip nvarchar(50), @site_phone nvarchar(50), @site_fax nvarchar(50), @site_email nvarchar(50)
AS
BEGIN
	DECLARE @nPageId int

	insert into locales (home_page, description, instruction_text, culture, active, site_name, site_address, site_city, site_state, site_country, site_zip, site_phone, site_fax, site_email) values (@home_page,@description,@instruction_text, @culture, @active, @site_name, @site_address, @site_city, @site_state, @site_country, @site_zip, @site_phone, @site_fax, @site_email)

	IF NOT EXISTS (SELECT *  FROM pages_working  WHERE file_name=@home_page)
	BEGIN
		SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1

		INSERT INTO pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date,root_id) values 
			(@nPageId,1,0,2,@channel_id,1,1,1,@home_page,'Home','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',0,0,'',0,0,1,1,0,'','','',getdate(),@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+1,1,@nPageId,2,@channel_id,1,1,1,'login_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Login','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/login.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+2,1,@nPageId,4,@channel_id,1,1,1,'registration_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Registration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/registration.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+3,1,@nPageId,10,@channel_id,1,1,1,'search_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Search','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/search.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+4,1,@nPageId,10,@channel_id,1,1,1,'shop_downloads'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Downloads','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_downloads.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+5,1,@nPageId,10,@channel_id,1,1,1,'shop_pcart'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Shopping Cart','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_pcart.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+6,1,@nPageId,10,@channel_id,1,1,1,'shop_pcompleted'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Order Completed','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_pcompleted.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
        DECLARE @nTempId int

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+7,1,@nPageId,20,@channel_id,1,1,1,'admin_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Admin','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	        
        DECLARE @nAdminId int
        SET @nAdminId = (SELECT page_id FROM pages WHERE file_name='admin_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+8,1,@nPageId,22,@channel_id,1,1,1,'workspace_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','My Workspace','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/workspace.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	        
        DECLARE @nWorkspaceId int
        SET @nWorkspaceId = (SELECT page_id FROM pages WHERE file_name='workspace_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+9,1,@nAdminId,2,@channel_id,1,1,1,'admin_users_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Users','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_users.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='admin_users_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+10,1,@nTempId,2,@channel_id,1,1,1,'admin_user_new_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','New User','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_user_new.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+11,1,@nTempId,4,@channel_id,1,1,1,'admin_user_info_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Edit User','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_user_info.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	        
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+12,1,@nTempId,6,@channel_id,1,1,1,'admin_users_import_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Import Users','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_users_import.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+13,1,@nAdminId,4,@channel_id,1,1,1,'admin_channels_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Channels','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channels.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='admin_channels_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+14,1,@nTempId,2,@channel_id,1,1,1,'admin_channel_new_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','New Channel','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channel_new.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+15,1,@nTempId,4,@channel_id,1,1,1,'admin_channel_info_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Edit Channel','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channel_info.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+16,1,@nAdminId,6,@channel_id,1,1,1,'approval_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Approval Assistant','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/approval.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+17,1,@nAdminId,8,@channel_id,1,1,1,'admin_templates_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Templates','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_templates.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='admin_templates_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+18,1,@nAdminId,10,@channel_id,1,1,1,'admin_modules_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Modules','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_modules.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='admin_modules_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+19,1,@nTempId,2,@channel_id,1,1,1,'admin_module_new_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','New Module','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_module_new.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+20,1,@nTempId,4,@channel_id,1,1,1,'admin_module_pages_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Embed Module','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_module_pages.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        --
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+21,1,@nWorkspaceId,2,@channel_id,1,1,1,'pages_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Pages','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/pages.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+22,1,@nWorkspaceId,4,@channel_id,1,1,1,'resources_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Resources','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/resources.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+23,1,@nWorkspaceId,6,@channel_id,1,1,1,'account_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Account','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/account.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+24,1,@nWorkspaceId,8,@channel_id,1,1,1,'preferences_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Preferences','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/preferences.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+25,1,@nWorkspaceId,10,@channel_id,1,1,1,'events_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Events','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/events.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='events_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+26,1,@nTempId,2,@channel_id,1,1,1,'event_new_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','New Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_new.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+27,1,@nTempId,4,@channel_id,1,1,1,'event_edit_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Edit Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_edit.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+28,1,@nTempId,6,@channel_id,1,1,1,'event_embed_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Embed Upcoming Event List','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_embed.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+29,1,@nWorkspaceId,12,@channel_id,1,1,1,'polls_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Polls','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/polls.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nTempId = (SELECT page_id FROM pages WHERE file_name='polls_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+30,1,@nTempId,2,@channel_id,1,1,1,'poll_info_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Poll Info','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_info.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+31,1,@nTempId,4,@channel_id,1,1,1,'poll_new_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','New Poll','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_new.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+32,1,@nTempId,6,@channel_id,1,1,1,'poll_pages_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Embed Poll','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_pages.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+33,1,@nAdminId,14,@channel_id,1,1,1,'admin_localization_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Localization','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/localization.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	    SET @nTempId = (SELECT page_id FROM pages WHERE file_name='admin_localization_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+34,1,@nTempId,2,@channel_id,1,1,1,'admin_site_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Site Info','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_site.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
		DECLARE @nNewslettersId int
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+35,1,@nWorkspaceId,16,@channel_id,1,1,1,'newsletters_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Newsletters','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        SET @nNewslettersId = (SELECT page_id FROM pages WHERE file_name='newsletters_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+36,1,@nNewslettersId,2,@channel_id,1,1,1,'newsletters_configure_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Configure Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_configure.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+37,1,@nNewslettersId,4,@channel_id,1,1,1,'newsletters_send_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Send Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_send.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+38,1,@nPageId,24,@channel_id,1,1,1,'pagenotfound_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','We''re sorry','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/pagenotfound.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+39,1,@nPageId,26,@channel_id,1,1,1,'password_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Password Recovery','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/password.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	

		Declare @nShopId int
		
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+40,1,@nWorkspaceId,18,@channel_id,1,1,1,'shop_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Shop','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
        SET @nShopId = (SELECT page_id FROM pages WHERE file_name='shop_'+CAST(@nPageId AS VARCHAR(20))+'.aspx')

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+41,1,@nShopId,2,@channel_id,1,1,1,'shop_config_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Configuration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_config.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+42,1,@nShopId,4,@channel_id,1,1,1,'shop_product_types_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Product Types','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_product_types.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+43,1,@nShopId,6,@channel_id,1,1,1,'shop_product_type_lookup_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Lookup','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_product_type_lookup.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)	

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+44,1,@nShopId,8,@channel_id,1,1,1,'shop_shipments_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Shipments','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_shipments.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+45,1,@nShopId,10,@channel_id,1,1,1,'shop_coupons_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Coupons','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_coupons.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+46,1,@nShopId,12,@channel_id,1,1,1,'shop_taxes_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Taxes','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_taxes.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
   		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+47,1,@nShopId,14,@channel_id,1,1,1,'shop_orders_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Orders','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_orders.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)

		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+48,1,@nTempId,12,@channel_id,1,1,1,'poll_results_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Poll Results','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_results.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+49,1,@nTempId,14,@channel_id,1,1,1,'event_view_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Events','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_view.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+50,1,@nPageId,38,@channel_id,1,1,1,'activate_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','User Registration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/activate.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+51,1,@nPageId,42,@channel_id,1,1,1,'subscription_update_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Update Subscription','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscription_update.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+52,1,@nPageId,44,@channel_id,1,1,1,'news_list_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','News List','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/news_list.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+53,1,@nNewslettersId,46,@channel_id,1,1,1,'mailing_lists_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Mailing Lists','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/mailing_lists.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+54,1,@nNewslettersId,48,@channel_id,1,1,1,'subscription_settings_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Settings','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscription_settings.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
			@nPageId+55,1,@nNewslettersId,50,@channel_id,1,1,1,'subscribers_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Subscribers','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscribers.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
        insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+56,1,@nAdminId,12,@channel_id,1,1,1,'registration_settings_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Registration Settings','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/registration_settings.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	        
	    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
	        @nPageId+57,1,@nWorkspaceId,20,@channel_id,1,1,1,'custom_listing_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Custom Listing','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/custom_listing.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
	        )
	        
    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+58,1,@nPageId,46,@channel_id,1,1,1,'tell_a_friend_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Search','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/tell_a_friend.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
			
    	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties,root_id) values (
    		@nPageId+59,1,@nPageId,48,@channel_id,1,1,1,'site_rss_'+CAST(@nPageId AS VARCHAR(20))+'.aspx','Search','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/site_rss.ascx',0,0,0,0,0,'','','',getdate(),'',@nPageId
			)
	
	END
	SELECT * FROM pages_working WHERE file_name=@home_page
END

GO


UPDATE pages SET parent_id=0 WHERE file_name='admin.aspx' OR file_name='workspace.aspx'


-- NEWSLETTERS

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

	CREATE TABLE [dbo].[newsletters] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[subject] [nvarchar] (50) NULL ,
	[message] [text] NULL ,
	[css] [text] NULL ,
	[form] [nvarchar] (50) NULL ,
	[receipients_type] [int] NULL ,
	[send_to] [ntext] NULL ,
	[author] [nvarchar] (50) NULL ,
	[created_date] [datetime] NULL 
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters_receipients]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

	CREATE TABLE [dbo].[newsletters_receipients] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[newsletters_id] [int] NOT NULL ,
	[email] [nvarchar] (50) NULL ,
	[status] [nvarchar] (50) NULL 
	) ON [PRIMARY]

GO

IF NOT EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_newsletters_receipients')
   CREATE NONCLUSTERED INDEX IX_newsletters_receipients ON newsletters_receipients (newsletters_id)
GO

/*
DECLARE @nPageIdTmp int
DECLARE @nPageId int
DECLARE @nSortingMax int

IF NOT EXISTS (SELECT file_name FROM pages 
    WHERE file_name='newsletters.aspx' OR file_name='newsletters_configure.aspx' OR file_name='newsletters_send.aspx')
BEGIN
    SET @nPageIdTmp = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageIdTmp,1,8,2,1,1,1,1,'newsletters.aspx','Newsletters','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,@nPageIdTmp,2,1,1,1,1,'newsletters_configure.aspx','Configure Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_configure.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
    insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date) values (
    @nPageId,1,@nPageIdTmp,4,1,1,1,1,'newsletters_send.aspx','Send Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_send.ascx',0,0,0,0,0,'','','',getdate()
    )

    SET @nSortingMax = (SELECT MAX(sorting) FROM pages WHERE parent_id=8) + 2
    update pages set sorting=@nSortingMax where file_name='newsletters.aspx';
END

GO*/

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='subscribe.ascx')
BEGIN

    insert into modules (module_file,display_name,owner) values (
    'subscribe.ascx','Subscription Form','admin')

END
GO


-----------------------------------------------------------


DECLARE @home_page nvarchar(50)
DECLARE @root_id int
DECLARE @channel_id int
DECLARE @nPageId int
DECLARE @file nvarchar(50)

DECLARE pagesTmp CURSOR LOCAL FOR SELECT home_page FROM locales
OPEN pagesTmp
FETCH NEXT FROM pagesTmp INTO @home_page
WHILE @@FETCH_STATUS=0
BEGIN
    	SET @root_id = (select page_id from pages_working where file_name=@home_page)
	SET @channel_id = (select channel_id from pages_working where file_name=@home_page)

	SET @nPageId = (SELECT MAX(page_id) FROM pages) + 1
	
	if @root_id=1
		SET @file='login.aspx'
	else
		SET @file='login_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT *  FROM pages  WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
		@nPageId,1,@root_id,2,@channel_id,1,1,1,@file,'Login','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/login.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/login.ascx', is_hidden=1, is_system=1 WHERE file_name=@file
    
	if @root_id=1
		SET @file='registration.aspx'
	else
		SET @file='registration_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
		@nPageId+1,1,@root_id,4,@channel_id,1,1,1,@file,'Registration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/registration.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/registration.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='search.aspx'
	else
		SET @file='search_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
    		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
    		@nPageId+2,1,@root_id,10,@channel_id,1,1,1,@file,'Search','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/search.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/search.ascx', is_hidden=1, is_system=1 WHERE file_name=@file
			
	if @root_id=1
		SET @file='shop_downloads.aspx'
	else
		SET @file='shop_downloads_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
    		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
    		@nPageId+3,1,@root_id,10,@channel_id,1,1,1,@file,'Downloads','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_downloads.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_downloads.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='shop_pcart.aspx'
	else
		SET @file='shop_pcart_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
    		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
    		@nPageId+4,1,@root_id,10,@channel_id,1,1,1,@file,'Shopping Cart','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_pcart.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_pcart.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='shop_pcompleted.aspx'
	else
		SET @file='shop_pcompleted_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
    		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
    		@nPageId+5,1,@root_id,10,@channel_id,1,1,1,@file,'Order Completed','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_pcompleted.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_pcompleted.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

		
    DECLARE @nTempId int

	if @root_id=1
		SET @file='admin.aspx'
	else
		SET @file='admin_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+6,1,@root_id,20,@channel_id,1,1,1,@file,'Admin','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/admin.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    DECLARE @nAdminId int
    SET @nAdminId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='workspace.aspx'
	else
		SET @file='workspace_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+7,1,@root_id,22,@channel_id,1,1,1,@file,'My Workspace','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/workspace.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/workspace.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    DECLARE @nWorkspaceId int
    SET @nWorkspaceId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_users.aspx'
	else
		SET @file='admin_users_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+8,1,@nAdminId,2,@channel_id,1,1,1,@file,'Users','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_users.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_users.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_user_new.aspx'
	else
		SET @file='admin_user_new_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+9,1,@nTempId,2,@channel_id,1,1,1,@file,'New User','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_user_new.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_user_new.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='admin_user_info.aspx'
	else
		SET @file='admin_user_info_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+10,1,@nTempId,4,@channel_id,1,1,1,@file,'Edit User','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_user_info.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_user_info.ascx', is_hidden=1, is_system=1 WHERE file_name=@file


	if @root_id=1
		SET @file='admin_users_import.aspx'
	else
		SET @file='admin_users_import_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+11,1,@nTempId,6,@channel_id,1,1,1,@file,'Import Users','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_users_import.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_users_import.ascx', is_hidden=1, is_system=1 WHERE file_name=@file


	if @root_id=1
		SET @file='admin_channels.aspx'
	else
		SET @file='admin_channels_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+12,1,@nAdminId,4,@channel_id,1,1,1,@file,'Channels','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channels.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_channels.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_channel_new.aspx'
	else
		SET @file='admin_channel_new_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+13,1,@nTempId,2,@channel_id,1,1,1,@file,'New Channel','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channel_new.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_channel_new.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='admin_channel_info.aspx'
	else
		SET @file='admin_channel_info_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+14,1,@nTempId,4,@channel_id,1,1,1,@file,'Edit Channel','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_channel_info.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_channel_info.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='approval.aspx'
	else
		SET @file='approval_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+15,1,@nWorkspaceId,6,@channel_id,1,1,1,@file,'Approval Assistant','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/approval.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/approval.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='admin_templates.aspx'
	else
		SET @file='admin_templates_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+16,1,@nAdminId,8,@channel_id,1,1,1,@file,'Templates','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_templates.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_templates.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_modules.aspx'
	else
		SET @file='admin_modules_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+17,1,@nAdminId,10,@channel_id,1,1,1,@file,'Modules','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_modules.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_modules.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_module_new.aspx'
	else
		SET @file='admin_module_new_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+18,1,@nTempId,2,@channel_id,1,1,1,@file,'New Module','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_module_new.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_module_new.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='admin_module_pages.aspx'
	else
		SET @file='admin_module_pages_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+19,1,@nTempId,4,@channel_id,1,1,1,@file,'Embed Module','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_module_pages.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_module_pages.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='pages.aspx'
	else
		SET @file='pages_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+20,1,@nWorkspaceId,2,@channel_id,1,1,1,@file,'Pages','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/pages.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/pages.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='resources.aspx'
	else
		SET @file='resources_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+21,1,@nWorkspaceId,4,@channel_id,1,1,1,@file,'Resources','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/resources.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/resources.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='account.aspx'
	else
		SET @file='account_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+22,1,@nWorkspaceId,6,@channel_id,1,1,1,@file,'Account','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/account.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/account.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='preferences.aspx'
	else
		SET @file='preferences_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+23,1,@nWorkspaceId,8,@channel_id,1,1,1,@file,'Preferences','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/preferences.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/preferences.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='events.aspx'
	else
		SET @file='events_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+24,1,@nWorkspaceId,10,@channel_id,1,1,1,@file,'Events','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/events.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/events.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='event_new.aspx'
	else
		SET @file='event_new_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+25,1,@nTempId,2,@channel_id,1,1,1,@file,'New Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_new.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/event_new.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='event_edit.aspx'
	else
		SET @file='event_edit_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+26,1,@nTempId,4,@channel_id,1,1,1,@file,'Edit Event','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_edit.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/event_edit.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='event_embed.aspx'
	else
		SET @file='event_embed_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
       		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+27,1,@nTempId,6,@channel_id,1,1,1,@file,'Embed Upcoming Event List','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_embed.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/event_embed.ascx', is_hidden=1, is_system=1, title='Embed Upcoming Event List' WHERE file_name=@file

	if @root_id=1
		SET @file='polls.aspx'
	else
		SET @file='polls_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
       		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+28,1,@nWorkspaceId,12,@channel_id,1,1,1,@file,'Polls','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/polls.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/polls.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='poll_info.aspx'
	else
		SET @file='poll_info_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+29,1,@nTempId,2,@channel_id,1,1,1,@file,'Poll Info','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_info.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/poll_info.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='poll_new.aspx'
	else
		SET @file='poll_new_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+30,1,@nTempId,4,@channel_id,1,1,1,@file,'New Poll','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_new.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/poll_new.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='poll_pages.aspx'
	else
		SET @file='poll_pages_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+31,1,@nTempId,6,@channel_id,1,1,1,@file,'Embed Poll','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_pages.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/poll_pages.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='admin_localization.aspx'
	else
		SET @file='admin_localization_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+32,1,@nAdminId,14,@channel_id,1,1,1,@file,'Localization','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/localization.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/localization.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	SET @nTempId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='admin_site.aspx'
	else
		SET @file='admin_site_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+33,1,@nTempId,2,@channel_id,1,1,1,@file,'Site Info','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/admin_site.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nTempId, channel_id=@channel_id, use_default_template=1, page_module='systems/admin_site.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	DECLARE @nNewslettersId int

	if @root_id=1
		SET @file='newsletters.aspx'
	else
		SET @file='newsletters_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+34,1,@nWorkspaceId,16,@channel_id,1,1,1,@file,'Newsletters','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/newsletters.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

    SET @nNewslettersId = (SELECT page_id FROM pages WHERE file_name=@file)

	if @root_id=1
		SET @file='newsletters_configure.aspx'
	else
		SET @file='newsletters_configure_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+35,1,@nNewslettersId,2,@channel_id,1,1,1,@file,'Configure Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_configure.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nNewslettersId, channel_id=@channel_id, use_default_template=1, page_module='systems/newsletters_configure.ascx', is_hidden=1, is_system=1, title='Configure Newsletter' WHERE file_name=@file

	if @root_id=1
		SET @file='newsletters_send.aspx'
	else
		SET @file='newsletters_send_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
        	insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+36,1,@nNewslettersId,4,@channel_id,1,1,1,@file,'Send Newsletter','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/newsletters_send.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nNewslettersId, channel_id=@channel_id, use_default_template=1, page_module='systems/newsletters_send.ascx', is_hidden=1, is_system=1, title='Send Newsletter' WHERE file_name=@file

	if @root_id=1
		SET @file='pagenotfound.aspx'
	else
		SET @file='pagenotfound_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+37,1,@root_id,24,@channel_id,1,1,1,@file,'We''re sorry','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/pagenotfound.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/pagenotfound.ascx', is_hidden=1, is_system=1, content_body='' WHERE file_name=@file

	if @root_id=1
		SET @file='password.aspx'
	else
		SET @file='password_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+38,1,@root_id,26,@channel_id,1,1,1,@file,'Password Recovery','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/password.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/password.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	DECLARE @nShopId int

	if @root_id=1
		SET @file='shop.aspx'
	else
		SET @file='shop_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+39,1,@nWorkspaceId,18,@channel_id,1,1,1,@file,'Shop','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nWorkspaceId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop.ascx', is_hidden=1, is_system=1, title='Shop' WHERE file_name=@file

	SET @nShopId = (SELECT page_id FROM pages WHERE file_name=@file)
	
	if @root_id=1
		SET @file='shop_config.aspx'
	else
		SET @file='shop_config_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+40,1,@nShopId,2,@channel_id,1,1,1,@file,'Configuration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_config.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_config.ascx', is_hidden=1, is_system=1 WHERE file_name=@file


	if @root_id=1
		SET @file='shop_product_types.aspx'
	else
		SET @file='shop_product_types_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+41,1,@nShopId,4,@channel_id,1,1,1,@file,'Product Types','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_product_types.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_product_types.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='shop_product_type_lookup.aspx'
	else
		SET @file='shop_product_type_lookup_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+42,1,@nShopId,6,@channel_id,1,1,1,@file,'Lookup','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_product_type_lookup.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_product_type_lookup.ascx', is_hidden=1, is_system=1, title='Lookup' WHERE file_name=@file
	
	if @root_id=1
		SET @file='shop_shipments.aspx'
	else
		SET @file='shop_shipments_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
	        @nPageId+43,1,@nShopId,8,@channel_id,1,1,1,@file,'Shipments','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_shipments.ascx',0,0,0,0,0,'','','',getdate(),''
	        )
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_shipments.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='shop_coupons.aspx'
	else
		SET @file='shop_coupons_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
		@nPageId+44,1,@nShopId,10,@channel_id,1,1,1,@file,'Coupons','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_coupons.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_coupons.ascx', is_hidden=1, is_system=1, title='Coupons' WHERE file_name=@file

	if @root_id=1
		SET @file='shop_orders.aspx'
	else
		SET @file='shop_orders_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
   		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
    		@nPageId+45,1,@nShopId,12,@channel_id,1,1,1,@file,'Orders','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_orders.ascx',0,0,0,0,0,'','','',getdate(),''
		)
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_orders.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='shop_taxes.aspx'
	else
		SET @file='shop_taxes_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+46,1,@nShopId,8,@channel_id,1,1,1,@file,'Taxes','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/shop_taxes.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nShopId, channel_id=@channel_id, use_default_template=1, page_module='systems/shop_taxes.ascx', is_hidden=1, is_system=1, title='Taxes' WHERE file_name=@file

	if @root_id=1
		SET @file='poll_results.aspx'
	else
		SET @file='poll_results_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+47,1,@root_id,34,@channel_id,1,1,1,@file,'Poll Results','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/poll_results.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/poll_results.ascx', is_hidden=1, is_system=1, title='Poll Results' WHERE file_name=@file

	if @root_id=1
		SET @file='event_view.aspx'
	else
		SET @file='event_view_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+48,1,@root_id,36,@channel_id,1,1,1,@file,'Events','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/event_view.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/event_view.ascx', is_hidden=1, is_system=1, title='Events' WHERE file_name=@file

	if @root_id=1
		SET @file='activate.aspx'
	else
		SET @file='activate_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+49,1,@root_id,38,@channel_id,1,1,1,@file,'User Registration','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/activate.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/activate.ascx', is_hidden=1, is_system=1, title='User Registration' WHERE file_name=@file

	if @root_id=1
		SET @file='subscription_update.aspx'
	else
		SET @file='subscription_update_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+50,1,@root_id,42,@channel_id,1,1,1,@file,'Update Subscription','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscription_update.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/subscription_update.ascx', is_hidden=1, is_system=1, title='Update Subscription' WHERE file_name=@file

	if @root_id=1
		SET @file='news_list.aspx'
	else
		SET @file='news_list_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+51,1,@root_id,44,@channel_id,1,1,1,@file,'News List','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/news_list.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/news_list.ascx', is_hidden=1, is_system=1, title='News List' WHERE file_name=@file

	if @root_id=1
		SET @file='mailing_lists.aspx'
	else
		SET @file='mailing_lists_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+52,1,@nNewslettersId,46,@channel_id,1,1,1,@file,'Mailing Lists','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/mailing_lists.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nNewslettersId, channel_id=@channel_id, use_default_template=1, page_module='systems/mailing_lists.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='subscription_settings.aspx'
	else
		SET @file='subscription_settings_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+53,1,@nNewslettersId,48,@channel_id,1,1,1,@file,'Settings','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscription_settings.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nNewslettersId, channel_id=@channel_id, use_default_template=1, page_module='systems/subscription_settings.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='subscribers.aspx'
	else
		SET @file='subscribers_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+54,1,@nNewslettersId,50,@channel_id,1,1,1,@file,'Subscribers','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/subscribers.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nNewslettersId, channel_id=@channel_id, use_default_template=1, page_module='systems/subscribers.ascx', is_hidden=1, is_system=1 WHERE file_name=@file


	if @root_id=1
		SET @file='registration_settings.aspx'
	else
		SET @file='registration_settings_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+55,1,@nAdminId,18,@channel_id,1,1,1,@file,'Registration Settings','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/registration_settings.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/registration_settings.ascx', is_hidden=1, is_system=1 WHERE file_name=@file
  
	if @root_id=1
		SET @file='custom_listing.aspx'
	else
		SET @file='custom_listing_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+56,1,@nWorkspaceId,20,@channel_id,1,1,1,@file,'Custom Listing','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/custom_listing.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@nAdminId, channel_id=@channel_id, use_default_template=1, page_module='systems/custom_listing.ascx', is_hidden=1, is_system=1 WHERE file_name=@file
       
       
	if @root_id=1
		SET @file='tell_a_friend.aspx'
	else
		SET @file='tell_a_friend_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+58,1,@root_id,46,@channel_id,1,1,1,@file,'Tell A Friend','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/tell_a_friend.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/tell_a_friend.ascx', is_hidden=1, is_system=1 WHERE file_name=@file

	if @root_id=1
		SET @file='site_rss.aspx'
	else
		SET @file='site_rss_'+CAST(@root_id AS VARCHAR(20))+'.aspx'
	IF NOT EXISTS (SELECT * FROM pages WHERE file_name=@file)
		insert into pages (page_id,version,parent_id,sorting,channel_id,use_default_template,template_id,page_type,file_name,title,summary,link_text,link_placement,content_left,content_body,content_right,file_attachment,file_size,owner,created_date,last_updated_date,last_updated_by,published_start_date,published_end_date,meta_keywords,meta_description,status,is_hidden,is_system,page_module,use_discussion,use_rating,allow_links_crawled,allow_page_indexed,is_marked_for_archival,editor_review_by,publisher_review_by,notes,display_date, properties) values (
			@nPageId+59,1,@root_id,48,@channel_id,1,1,1,@file,'Site Rss','','','main','','','','',0,'admin',getdate(),getdate(),'admin',NULL,NULL,'','','published',1,1,'systems/site_rss.ascx',0,0,0,0,0,'','','',getdate(),''
			)
	ELSE
		UPDATE pages set parent_id=@root_id, channel_id=@channel_id, use_default_template=1, page_module='systems/site_rss.ascx', is_hidden=1, is_system=1 WHERE file_name=@file
       
       
	FETCH NEXT FROM pagesTmp INTO @home_page
END
CLOSE pagesTmp
DEALLOCATE pagesTmp




-----------------------------------------------------------




if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[shipping_cost]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[shipping_cost] (
        [ship_cost_id] [int] IDENTITY (1, 1) NOT NULL ,
        [description] [nvarchar] (255) NULL,
        [ship_cost] [money] NULL ,
        [percentage_cost] [decimal] (5,2) NULL ,	
        [weight_from] [decimal] (12,2) NULL ,
        [weight_to] [decimal] (12,2) NULL ,
        [total_from] [money] NULL ,
        [total_to] [money] NULL ,
        [location] [nvarchar] (128) NULL
    ) ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[country_state_lookup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[country_state_lookup] (
	    [id] [int] IDENTITY (1, 1) NOT NULL ,
	    [country] [varchar] (50) NULL ,
	    [state_code] [varchar] (50) NULL ,
	    [state] [varchar] (50) NULL 
    ) ON [PRIMARY]

    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','AL','Alabama') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','AK','Alaska') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','AZ','Arizona') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','AR','Arkansas') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','CA','California') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','CO','Colorado') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','CT','Connecticut') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','DE','Delaware') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','DC','District of Columbia')
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','FL','Florida') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','GA','Georgia') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','HI','Hawaii') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','ID','Idaho') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','IL','Illinois') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','IN','Indiana') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','IA','Iowa') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','KS','Kansas') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','KY','Kentucky') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','LA','Louisiana') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','ME','Maine') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MD','Maryland') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MA','Massachusetts') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MI','Michigan') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MN','Minnesota') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MS','Mississippi') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MO','Missouri') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','MT','Montana') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NE','Nebraska') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NV','Nevada') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NH','New Hampshire') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NJ','New Jersey') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NM','New Mexico') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NY','New York') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','NC','North Carolina') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','ND','North Dakota') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','OH','Ohio') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','OK','Oklahoma') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','OR','Oren') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','PA','Pennsylvania') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','PR','Puerto Rico')
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','RI','Rhode Island') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','SC','South Carolina') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','SD','South Dakota') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','TN','Tennessee') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','TX','Texas') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','UT','Utah') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','VT','Vermont') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','VA','Virginia') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','WA','Washington') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','WV','West Virginia') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','WI','Wisconsin') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','WY','Wyoming') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','VI','Virgin Islands') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','AS','American Samoa') 
    insert into [country_state_lookup] ([country],[state_code],[state]) values ('US','GU','Guam') 
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[product_types]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[product_types](
		product_type_id [int] IDENTITY(1,1) NOT NULL,
		[description] nvarchar(255) NOT NULL,
		constraint pk_product_type primary key(product_type_id)
		)
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[product_property_definition]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[product_property_definition](
		product_property_id int IDENTITY(1,1) NOT NULL,
		product_property_name nvarchar(255) NOT NULL,
		sorting int NOT NULL,
		input_type nvarchar(50) NULL,
		default_value nvarchar(255) NULL,
		product_type_id int NOT NULL,
		value1_name ntext NULL,
		value2_name ntext NULL,
		value3_name ntext NULL,
		value1_input_type nvarchar(50) NULL,
		value2_input_type nvarchar(50) NULL,
		value3_input_type nvarchar(50) NULL,
		constraint pk_product_property_definition primary key(product_property_id)
		)
END

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='product_property_definition' and sysobjects.type='U' and syscolumns.name='display_in_product_listing')
  alter table product_property_definition add display_in_product_listing bit DEFAULT 0 WITH VALUES
Go

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[product_property_values]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[product_property_values](
		product_property_id int NOT NULL,
		code nvarchar(255) NOT NULL,
		display_value nvarchar(255) NOT NULL,
		value1 ntext NULL,
		value2 ntext NULL,
		value3 ntext NULL,
		is_default bit NULL,
		constraint pk_product_property_values primary key(product_property_id,code)
		)
END

ALTER TABLE newsletters_receipients ALTER COLUMN [email] NVARCHAR(100) NULL
ALTER TABLE newsletters_receipients ALTER COLUMN [status] NVARCHAR(255) NULL

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='newsletters' and sysobjects.type='U' and syscolumns.name='root_id')
  alter table newsletters add root_id int NULL
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='events' and sysobjects.type='U' and syscolumns.name='root_id')
  alter table events add root_id int NULL
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='polls' and sysobjects.type='U' and syscolumns.name='root_id')
  alter table polls add root_id int NULL
Go



-- FORM --

if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[form_field_definitions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[form_field_definitions] (
		[form_field_definition_id] [int] IDENTITY(1,1) NOT NULL,
		[form_field_name] [nvarchar](255) NOT NULL,
		[sorting] [int] NOT NULL,
		[input_type] [nvarchar](50) NOT NULL,
		[width] [int] NULL,
		[height] [int] NULL,
		[default_value] [nvarchar](255) NULL,
		[page_id] [int] NOT NULL,
		[is_required] [bit] NOT NULL
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[form_field_definitions] WITH NOCHECK ADD 
    CONSTRAINT [PK_form_field_definitions] PRIMARY KEY  CLUSTERED 
    (
        [form_field_definition_id]
    )  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[form_field_values]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[form_field_values] (
			[form_field_value_id] [int] IDENTITY(1,1) NOT NULL,
			[form_field_definition_id] [int] NOT NULL,
			[display_value] [nvarchar](255) NOT NULL,
			[is_default] [bit] NULL,
		) ON [PRIMARY]
	    
		ALTER TABLE [dbo].[form_field_values] WITH NOCHECK ADD 
		CONSTRAINT [PK_form_field_values] PRIMARY KEY  CLUSTERED 
		(
			[form_field_value_id]
		)  ON [PRIMARY] 
	END
ELSE
	BEGIN
		-- If Exists, check if it is empty or not
		IF NOT exists (select * from [dbo].[form_field_values])
		  BEGIN
			-- empty (backward compatible)
			DROP TABLE [dbo].[form_field_values]

			CREATE TABLE [dbo].[form_field_values] (
				[form_field_value_id] [int] IDENTITY(1,1) NOT NULL,
				[form_field_definition_id] [int] NOT NULL,
				[display_value] [nvarchar](255) NOT NULL,
				[is_default] [bit] NULL,
			) ON [PRIMARY]
		    
			ALTER TABLE [dbo].[form_field_values] WITH NOCHECK ADD 
			CONSTRAINT [PK_form_field_values] PRIMARY KEY  CLUSTERED 
			(
				[form_field_value_id]
			)  ON [PRIMARY] 
		  END
		ELSE
			BEGIN
				If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='form_field_values' and sysobjects.type='U' and syscolumns.name='form_field_value_id')
				  alter table form_field_values add form_field_value_id [int] IDENTITY(1,1) NOT NULL
			END
	END
GO



if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[form_data]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[form_data] (
		[form_data_id] [int] NOT NULL,
		[page_id] [int] NOT NULL,
		[form_field_definition_id] [int] NOT NULL,
		[value1] [nvarchar](255) NULL,
		[value2] [ntext] NULL,
		[value3] [bit] NULL,
		[value4] [money] NULL,
		[value5] [decimal](18, 2) NULL,
		[value6] [smalldatetime] NULL,
		[submitted_date] [datetime] NULL
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[form_data] WITH NOCHECK ADD 
    CONSTRAINT [PK_form_data] PRIMARY KEY  CLUSTERED 
    (
		[form_data_id],
		[page_id],
		[form_field_definition_id]
    )  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[form_settings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[form_settings] (
		[page_id] [int] NOT NULL,
		[header] [ntext] NULL,
		[footer] [ntext] NULL,
		[thank_you_message] [ntext] NULL
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[form_settings] WITH NOCHECK ADD 
    CONSTRAINT [PK_form_settings] PRIMARY KEY  CLUSTERED 
    (
        [page_id]
    )  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = 
object_id(N'[dbo].[form_data_impressions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[form_data_impressions] (
		[form_data_id] [int] NOT NULL,
		[page_id] [int] NOT NULL,
		[impressions] [int] NULL,
		[impression_date] [datetime] NULL
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[form_data_impressions] WITH NOCHECK ADD 
    CONSTRAINT [PK_form_data_impressions] PRIMARY KEY  CLUSTERED 
    (
        [form_data_id]
    )  ON [PRIMARY] 
END
GO

---------------------
declare @current int, @root_id int
declare @level int, @line int, @page_id int
DECLARE @home_page nvarchar(50)
DECLARE pagesTmp CURSOR LOCAL FOR SELECT home_page FROM locales
OPEN pagesTmp
FETCH NEXT FROM pagesTmp INTO @home_page
WHILE @@FETCH_STATUS=0
BEGIN
	SET @current = (select page_id from pages_working where file_name=@home_page)

	SET @root_id = @current

	create table #stack (item int, level int)
	insert into #stack values (@current, 1)
	select @level = 1
	declare @tmp table (page_id int, PRIMARY KEY (page_id))
	while @level > 0
	begin
	   if exists (select * from #stack where level = @level)
		  begin
			 select @current = item
			 from #stack
			 where level = @level
			 select @line = space(@level - 1) + @current
			 insert into @tmp (page_id) values(@line)
			 delete from #stack
			 where level = @level
				and item = @current
			 insert #stack
				select page_id, @level + 1
				from pages_working
				where parent_id = @current
			 if @@rowcount > 0
				select @level = @level + 1
		  end
	   else
		  select @level = @level - 1
	end -- while
	drop table #stack
	
	DECLARE pagesTmp2 CURSOR LOCAL FOR select page_id from @tmp
	OPEN pagesTmp2
	FETCH NEXT FROM pagesTmp2 INTO @page_id
	WHILE @@FETCH_STATUS=0
	BEGIN
		UPDATE pages set root_id=@root_id WHERE page_id=@page_id
		FETCH NEXT FROM pagesTmp2 INTO @page_id
	END
	CLOSE pagesTmp2
	DEALLOCATE pagesTmp2

	DELETE @tmp

	FETCH NEXT FROM pagesTmp INTO @home_page
END
CLOSE pagesTmp
DEALLOCATE pagesTmp
GO
-------------------------------

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='product_property_definition' and sysobjects.type='U' and syscolumns.name='display_name')
  alter table product_property_definition add display_name nvarchar(255) NULL
Go

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='page_modules' and sysobjects.type='U' and syscolumns.name='template_id')
	alter table page_modules add template_id int NULL
GO
If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='page_modules' and sysobjects.type='U' and syscolumns.name='sorting')
	alter table page_modules add sorting int NULL
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='form_settings' and sysobjects.type='U' and syscolumns.name='return_to_form')
  alter table form_settings add return_to_form bit NULL
Go


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_FixedPageMenu' AND type = 'P')
   DROP PROCEDURE advcms_FixedPageMenu
GO

CREATE PROC [dbo].[advcms_FixedPageMenu]
	@page_id int
AS
BEGIN
	select * from pages_published where parent_id=@page_id and sorting<>0
	order by parent_id, sorting
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_FixedPageMenu2' AND type = 'P')
   DROP PROCEDURE advcms_FixedPageMenu2
GO

CREATE PROC [dbo].[advcms_FixedPageMenu2]
	@page_id int
AS
BEGIN
	select * from pages_working where parent_id=@page_id and sorting<>0
	order by parent_id, sorting
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters_categories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[newsletters_categories] (
		[category_id] [int] IDENTITY (1, 1) NOT NULL ,
		[category] [nvarchar] (50) NULL ,
		[root_id] [int] NULL ,
		[active] [bit] NOT NULL 
	) ON [PRIMARY]
END
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='newsletters_categories' and sysobjects.type='U' and syscolumns.name='private')
  alter table newsletters_categories add private bit DEFAULT 0 WITH VALUES
Go

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters_subscribers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[newsletters_subscribers] (
		[id] [int] IDENTITY (1, 1) NOT NULL ,
		[name] [nvarchar] (50) NULL ,
		[email] [nvarchar] (50) NULL ,
		[category_id] [int] NULL ,
		[status] [bit] NULL ,
		[date_registered] [datetime] NULL ,
		[unsubscribe] [bit] NOT NULL 
	) ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters_map]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[newsletters_map] (
		[id] [int] IDENTITY (1, 1) NOT NULL ,
		[newsletter_id] [int] NULL ,
		[category_id] [int] NULL 
	) ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[newsletters_settings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[newsletters_settings] (
		[newsletters_setting_id] [int] IDENTITY (1, 1) NOT NULL ,
		[confirmation_subject] [ntext] NULL ,
		[confirmation_body] [ntext] NULL ,
		[confirmed_subject] [ntext] NULL ,
		[confirmed_body] [ntext] NULL ,
		[unsubscribe_signature] [ntext] NULL ,
		[unsubscribe_signature_text] [ntext] NULL ,
		[root_id] [int] NULL 
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

DECLARE @home_page nvarchar(255), @root_id int
DECLARE pagesTmp CURSOR LOCAL FOR SELECT home_page FROM locales
OPEN pagesTmp
FETCH NEXT FROM pagesTmp INTO @home_page
WHILE @@FETCH_STATUS=0
BEGIN
	SET @root_id = (select page_id from pages_working where file_name=@home_page)

	IF NOT EXISTS (SELECT * FROM newsletters_settings WHERE root_id=@root_id)
		insert into newsletters_settings (confirmation_subject,confirmation_body,unsubscribe_signature,unsubscribe_signature_text,root_id) values (
			'Subscription Confirmation',
			'Please click the link below to complete your subscription: <br /><a href="[%LinkConfirm%]">[%LinkConfirm%]</a><br /><br />Best Regards,<br/>[%SiteName%]<br /><a href="mailto:[%SiteEmail%]">[%SiteEmail%]</a>',
			'If you wish to discontinue receiving our Newsletter or to update your subscription preferences, please click <a href="[%LinkUnsubscribe%]">here</a>.',
			'If you wish to discontinue receiving our Newsletter or to update your subscription preferences, please click here: [%LinkUnsubscribe%]',
			@root_id
		)
		
	IF NOT EXISTS (SELECT * FROM newsletters_categories WHERE root_id=@root_id)
		insert into newsletters_categories (category,root_id,active) 
		VALUES ('News',@root_id,1)

	FETCH NEXT FROM pagesTmp INTO @home_page
END
CLOSE pagesTmp
DEALLOCATE pagesTmp
GO


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_PageTree2' AND type = 'P')
   DROP PROCEDURE advcms_PageTree2
GO
CREATE procedure advcms_PageTree2 (@page_id int, @maxlvl int, @placement nvarchar(50) = 'main') as
set nocount on

declare @current int
select @current=root_id from pages where page_id=@page_id

create table #tmpPages (page_id int, parent_id int, sorting int, PRIMARY KEY (page_id))
declare @currPr int, @tmpPr int, @listingProperty int, @isListing bit

select @currPr=@page_id
select @tmpPr=@page_id
while @tmpPr<>0
begin
    select @isListing=is_listing, @listingProperty=listing_property, @tmpPr=parent_id from pages_working where page_id=@tmpPr
    if @isListing=1 and (@listingProperty=2 or @listingProperty=3)
        select @currPr=@tmpPr
end

while @currPr <> 0
begin
    insert into #tmpPages (page_id, parent_id, sorting) select page_id, parent_id, sorting from pages_working where parent_id=@currPr and link_placement=@placement
    select @currPr=parent_id from pages_working where page_id=@currPr
end
insert into #tmpPages (page_id, parent_id, sorting) select page_id, parent_id, sorting from pages_working where page_id=@current

declare @level int, @line int
create table #stack (item int, sorting int, level int)
insert into #stack values (@current, 0, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         set @current=(select top 1 item from #stack where level=@level order by sorting asc)

         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current

         insert #stack
            select page_id, sorting, @level + 1
            from #tmpPages
            where parent_id = @current order by sorting
            
         if @@rowcount > 0
            select @level = @level + 1
      end
   else
      select @level = @level - 1
end -- while
drop table #stack
drop table #tmpPages

select  
    t2.page_id, t2.parent_id, t2.sorting, t2.listing_property, t2.file_name, t2.title, t2.link_text, 
    t2.published_start_date, t2.published_end_date, t2.is_hidden, t2.is_system, t2.channel_name, 
    t2.channel_permission, t2.disable_collaboration, t2.last_updated_date, t2.status, t2.owner, 
    t2.title2, t2.link_text2, t2.is_link, t2.link_target, t2.link_target2,
    t1.level as lvl
from @tmp as t1 left join pages_working as t2 on (t1.page_id=t2.page_id) order by t1.recidx

go


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_PageTree' AND type = 'P')
   DROP PROCEDURE advcms_PageTree
GO
CREATE procedure advcms_PageTree (@page_id int, @maxlvl int, @placement nvarchar(50) = 'main') as
set nocount on

declare @current int
select @current=root_id from pages where page_id=@page_id

create table #tmpPages (page_id int, parent_id int, sorting int, PRIMARY KEY (page_id))
declare @currPr int, @tmpPr int, @listingProperty int, @isListing bit

select @currPr=@page_id
select @tmpPr=@page_id
while @tmpPr<>0
begin
    select @isListing=is_listing, @listingProperty=listing_property, @tmpPr=parent_id from pages_published where page_id=@tmpPr
    if @isListing=1 and (@listingProperty=2 or @listingProperty=3)
        select @currPr=@tmpPr
end

while @currPr <> 0
begin
    insert into #tmpPages (page_id, parent_id, sorting) select page_id, parent_id, sorting from pages_published where parent_id=@currPr and link_placement=@placement
    select @currPr=parent_id from pages_published where page_id=@currPr
end
insert into #tmpPages (page_id, parent_id, sorting) select page_id, parent_id, sorting from pages_published where page_id=@current

declare @level int, @line int
create table #stack (item int, sorting int, level int)
insert into #stack values (@current, 0, 1)
select @level = 1

declare @tmp table (recidx int identity(1,1),  page_id int, level int, PRIMARY KEY (page_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level) and @level <= @maxlvl
      begin
         set @current=(select top 1 item from #stack where level=@level order by sorting asc)

         select @line = @current
         insert into @tmp (page_id, level) values(@line, @level-1)

         delete from #stack where level = @level and item = @current

         insert #stack
            select page_id, sorting, @level + 1
            from #tmpPages
            where parent_id = @current order by sorting
            
         if @@rowcount > 0
            select @level = @level + 1
      end
   else
      select @level = @level - 1
end -- while
drop table #stack
drop table #tmpPages

select  
    t2.page_id, t2.parent_id, t2.listing_property, t2.file_name, 
    t2.title, t2.link_text, t2.published_start_date, t2.published_end_date, 
    t2.is_hidden, t2.is_system, t2.channel_name, t2.channel_permission,
    t1.level as lvl, t2.is_link, t2.link_target
from @tmp as t1 left join pages_published as t2 on (t1.page_id=t2.page_id) order by t1.recidx

go


-------------------------------------------
-- Discussion
-------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[discussion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[discussion] (
	  [subject_id] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	  [parent_id] [decimal](18, 0) NOT NULL ,
	  [subject] [nvarchar] (255) NULL ,
	  [message] [ntext] NULL ,
	  [posted_by] [nvarchar] (64) NULL ,
	  [posted_date] [datetime] NULL ,
	  [type] [char] (1) NOT NULL ,
	  [category] [nvarchar] (64) NULL ,
	  [noreply] [bit] NULL,
	  [reply_to] [decimal] (18, 0) NULL,
	  [last_post_id] [decimal] (18, 0) NULL,
	  [status] varchar(16) NOT NULL,
	  [viewed] int NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	
	insert into discussion (parent_id,subject,message,posted_by,posted_date,type,category,noreply,reply_to,last_post_id,status,viewed) values (0,'General Topics','Use this forum to post general questions.','admin',GetDate(),'F','General Discussion',0,0,0,'unlocked',0)
END
GO


IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_CreateDiscussion' AND type = 'P')
   DROP PROCEDURE advcms_CreateDiscussion
GO

CREATE PROCEDURE advcms_CreateDiscussion (
    @parent_id decimal,
    @subject nvarchar(255),
    @message ntext,
    @posted_by nvarchar(64),
    @posted_date datetime,
    @type char (1),
    @category nvarchar(64),
    @noreply bit,
    @reply_to decimal,
    @last_post_id decimal,
    @status varchar(16)
) AS
Insert into discussion (parent_id, subject, message, posted_by, posted_date,
    type, category, noreply, reply_to, last_post_id, status)
values(@parent_id, @subject, @message, @posted_by, @posted_date,
    @type, @category, @noreply, @reply_to, @last_post_id, @status)

declare @newId decimal
set @newId=SCOPE_IDENTITY()

if @type='R' OR @type='Q' OR @type='T'
begin
    update discussion set last_post_id=@newId where subject_id=@parent_id
    if @type='R' OR @type='Q'
    begin
        update discussion set last_post_id=@newId where subject_id=(select parent_id from discussion where subject_id=@parent_id)
    end
end
    
Select * from discussion where subject_id=@newId

GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_DeleteDiscussion' AND type = 'P')
   DROP PROCEDURE advcms_DeleteDiscussion
GO

Create PROCEDURE advcms_DeleteDiscussion (
    @current decimal
) as

set nocount on
declare @level int, @line decimal
create table #stack (item decimal, level int)
insert into #stack values (@current, 1)
select @level = 1

declare @tmp table (subject_id decimal, PRIMARY KEY (subject_id))

while @level > 0
begin
   if exists (select * from #stack where level = @level)
      begin
         select @current = item
         from #stack
         where level = @level
         select @line = @current
         insert into @tmp (subject_id) values(@line)
         delete from #stack
         where level = @level
            and item = @current
         insert #stack
            select subject_id, @level + 1
            from discussion
            where parent_id = @current
         if @@rowcount > 0
            select @level = @level + 1
      end
   else
      select @level = @level - 1
end -- while
drop table #stack

Delete from discussion where subject_id in (select subject_id from @tmp)

GO


IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='forum.ascx')
BEGIN

    insert into modules (module_file,display_name,owner) values (
    'forum.ascx','Forum','admin')

END
GO

DELETE from modules WHERE module_file='events_public.ascx'
GO

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='news_list.ascx')
BEGIN

    insert into modules (module_file,display_name,owner) values (
    'news_list.ascx','Newsletter List','admin')

END
GO

UPDATE modules set display_name='Rss Feed' where module_file='rssfeed.ascx'

UPDATE modules set display_name='Newsletter Subscription Form' where module_file='subscribe.ascx'


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[registration_settings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[registration_settings] (
		[root_id] [int] NOT NULL,
		[enable] [bit] NULL,
		[confirmation_subject] [nvarchar](255) NULL,
		[confirmation_body] [ntext] NULL,
		[confirmed_subject] [nvarchar](255) NULL,
		[confirmed_body] [ntext] NULL,
		[option_type] [nvarchar](50) NULL,
		[option_description] [nvarchar](255) NULL,
		[opt1] [nvarchar](255) NULL,
		[channel1] [nvarchar](255) NULL,
		[opt2] [nvarchar](255) NULL,
		[channel2] [nvarchar](255) NULL,
		[opt3] [nvarchar](255) NULL,
		[channel3] [nvarchar](255) NULL,
		[opt4] [nvarchar](255) NULL,
		[channel4] [nvarchar](255) NULL,
		[opt5] [nvarchar](255) NULL,
		[channel5] [nvarchar](255) NULL,
	 CONSTRAINT [PK_registration_settings] PRIMARY KEY CLUSTERED 
		(
		[root_id]
		)ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

DECLARE @home_page nvarchar(255), @root_id int
DECLARE pagesTmp CURSOR LOCAL FOR SELECT home_page FROM locales
OPEN pagesTmp
FETCH NEXT FROM pagesTmp INTO @home_page
WHILE @@FETCH_STATUS=0
BEGIN
	SET @root_id = (select page_id from pages_working where file_name=@home_page)

	IF NOT EXISTS (SELECT * FROM registration_settings WHERE root_id=@root_id)
		insert into registration_settings (enable,confirmation_subject,confirmation_body,confirmed_subject,confirmed_body,root_id) values (
			1,'Registration Confirmation',
			'Please click the link below to complete your registration: <br /><a href="[%LinkConfirm%]">[%LinkConfirm%]</a><br /><br />Best Regards,<br/>[%SiteName%]<br /><a href="mailto:[%SiteEmail%]">[%SiteEmail%]</a>',
			'Your Login Info',
			'Thank you for your registration. Below is your login information:<br/><br/>UserName: [%UserName%]<br/>Password: [%Password%]<br/><br/>Best Regards,<br/>[%SiteName%]<br /><a href="mailto:[%SiteEmail%]">[%SiteEmail%]</a>',
			@root_id
		)
		
	FETCH NEXT FROM pagesTmp INTO @home_page
END
CLOSE pagesTmp
DEALLOCATE pagesTmp
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='form_settings' and sysobjects.type='U' and syscolumns.name='email')
  alter table form_settings add email ntext DEFAULT '' WITH VALUES
Go

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[listing_categories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[listing_categories] (
	    [listing_category_id] [int] IDENTITY(1,1) NOT NULL,
		[page_id] [int] NOT NULL,
		[listing_category_name] [nvarchar](255) NOT NULL,
		[sorting] [int] NULL
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[listing_categories] WITH NOCHECK ADD 
        CONSTRAINT [PK_listing_categories] PRIMARY KEY  CLUSTERED 
        (
            [listing_category_id]
        )  ON [PRIMARY] 

END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[listing_category_map]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[listing_category_map] (
	    [listing_category_map_id] [int] IDENTITY(1,1) NOT NULL,
		[listing_category_id] [int] NOT NULL,
		[page_id] [int] NOT NULL
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[listing_category_map] WITH NOCHECK ADD 
        CONSTRAINT [PK_listing_category_map] PRIMARY KEY  CLUSTERED 
        (
            [listing_category_map_id]
        )  ON [PRIMARY] 

END
GO

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='rssfeed.ascx')
BEGIN

	insert into modules (module_file,display_name,owner) values (
	'rssfeed.ascx', 'News Feed', 'admin')

END
GO

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='contact.ascx')
BEGIN

	insert into modules (module_file,display_name,owner) values (
	'contact.ascx', 'Contact Form', 'admin')

END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[guest_book]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[guest_book] (
		[guest_book_id] [int] IDENTITY(1,1) NOT NULL,
		[page_id] [int] NOT NULL,
		[name] [nvarchar](255) NOT NULL,
		[email] [nvarchar](255) NULL,
		[website] [nvarchar](255) NULL,
		[message] [ntext] NOT NULL,
		[posted_date] [smalldatetime] NOT NULL
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[guest_book] WITH NOCHECK ADD 
        CONSTRAINT [PK_guest_book] PRIMARY KEY  CLUSTERED 
        (
            [guest_book_id]
        )  ON [PRIMARY] 
	insert into modules (module_file,display_name,owner) values ('guest_book.ascx', 'Guest Book', 'admin')
END
GO



----------- Move Module Facility ----------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_module_sorting]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
    CREATE TABLE [dbo].[page_module_sorting] (
		[page_module_id] [int] NOT NULL,
		[file_name] [nvarchar](50)  NOT NULL,
		[placeholder_id] [nvarchar](50) NOT NULL,
		[sorting] [int] NOT NULL
    ) ON [PRIMARY]
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_ModuleSorting' AND type = 'P')
   DROP PROCEDURE advcms_ModuleSorting
GO

CREATE procedure advcms_ModuleSorting (@file nvarchar(50),@placeholder nvarchar(50)) as
set nocount on

DECLARE @id int, @placeholder_id nvarchar(50), @page_module_id int, @module_file nvarchar(50), @module_data nvarchar(255), @file_name nvarchar(50),@sorting int

-- Get all embedded module in certain placeholder on a page
CREATE TABLE #PageTree (page_module_id int, module_file nvarchar(50), module_data nvarchar(255),sorting int)

DECLARE pagesTmp CURSOR LOCAL FOR (SELECT page_modules.page_module_id,page_modules.module_file,page_modules.module_data,page_modules.placeholder_id,pages_working.file_name
	FROM pages_working INNER JOIN
	page_modules ON pages_working.file_name = page_modules.embed_in
	WHERE (pages_working.file_name = @file) AND (page_modules.placeholder_id = @placeholder)
	UNION ALL
	SELECT page_modules.page_module_id,page_modules.module_file,page_modules.module_data,page_modules.placeholder_id,pages_working.file_name
	FROM pages_working INNER JOIN
	page_modules ON dbo.pages_working.template_id = page_modules.template_id
	WHERE (pages_working.file_name = @file) AND (page_modules.placeholder_id = @placeholder)
	)
OPEN pagesTmp
FETCH NEXT FROM pagesTmp INTO @page_module_id,@module_file,@module_data,@placeholder_id,@file_name
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO #PageTree (page_module_id,module_file,module_data) VALUES (@page_module_id,@module_file,@module_data)
	FETCH NEXT FROM pagesTmp INTO @page_module_id,@module_file,@module_data,@placeholder_id,@file_name
END
CLOSE pagesTmp
DEALLOCATE pagesTmp

-- Give sorting number
DECLARE pagesTmp2 CURSOR LOCAL FOR (SELECT sorting,page_module_id
	FROM page_module_sorting  
	WHERE file_name = @file_name AND placeholder_id = @placeholder_id
	)
OPEN pagesTmp2
FETCH NEXT FROM pagesTmp2 INTO @sorting,@page_module_id
WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE #PageTree SET sorting = @sorting WHERE page_module_id=@page_module_id
	FETCH NEXT FROM pagesTmp2 INTO @sorting,@page_module_id
END
CLOSE pagesTmp2
DEALLOCATE pagesTmp2

-- Returns: page_module_id, module_file, module_data, sorting, placeholder_id
SELECT *,@placeholder_id as placeholder_id FROM #PageTree ORDER BY sorting

DROP TABLE #PageTree
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_Modules' AND type = 'P')
   DROP PROCEDURE advcms_Modules
GO

-- Returns records per placeholder (multiple recordset)
CREATE procedure advcms_Modules (@file nvarchar(50)) as
set nocount on

DECLARE @module_file nvarchar(50), @sorting int
DECLARE @tmpplace nvarchar(50)
DECLARE childPages CURSOR LOCAL FOR SELECT placeholder_id FROM page_modules GROUP BY placeholder_id
OPEN childPages
FETCH NEXT FROM childPages INTO @tmpplace
WHILE @@FETCH_STATUS=0
BEGIN	
    EXECUTE advcms_ModuleSorting @file, @tmpplace
    FETCH NEXT FROM childPages INTO @tmpplace
END
CLOSE childPages
DEALLOCATE childPages

GO

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='contact_simple.ascx')
BEGIN

    insert into modules (module_file,display_name,owner) values (
    'contact_simple.ascx','Contact Form (Simple)','admin')

END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_SitemapRecur' AND type = 'P')
   DROP PROCEDURE advcms_SitemapRecur
GO

CREATE PROCEDURE advcms_SitemapRecur
    @parent_id int, @lvl int, @maxlvl int, @link_placement nvarchar(50)
AS
BEGIN
	SET @lvl=@lvl+1
	IF @lvl <= @maxlvl
	BEGIN
		DECLARE @page_id int, @sorting int, @listingProperty int, @file_name nvarchar(50), @title nvarchar(255), @link_text nvarchar(255), @published_start_date smalldatetime, @published_end_date smalldatetime, @is_hidden bit, @is_system bit, @channel_name nvarchar(50), @channel_permission int, @is_link bit, @link_target nvarchar(50)

		DECLARE @lp int
		SET @lp = (SELECT listing_property FROM pages_published WHERE page_id=@parent_id)
		IF @lp=1
		BEGIN
			DECLARE pagesTmp CURSOR LOCAL FOR SELECT page_id, parent_id, sorting, listing_property, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, is_link, link_target FROM pages_published WHERE parent_id=@parent_id AND link_placement=@link_placement AND is_system=0 ORDER BY parent_id, sorting
			OPEN pagesTmp
			FETCH NEXT FROM pagesTmp INTO @page_id, @parent_id, @sorting, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @is_link, @link_target
			WHILE @@FETCH_STATUS=0
			BEGIN
				INSERT INTO #PageTree (page_id, parent_id, listing_property, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, is_link, link_target, lvl) VALUES (@page_id,@parent_id, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @is_link, @link_target, @lvl)

				IF @listingProperty<>2 AND @listingProperty<>3
				BEGIN
					EXEC advcms_SitemapRecur @page_id, @lvl, @maxlvl, @link_placement
				END

    				FETCH NEXT FROM pagesTmp INTO @page_id, @parent_id, @sorting, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @is_link, @link_target
			END
			CLOSE pagesTmp
			DEALLOCATE pagesTmp
		END
	END
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_SitemapRecur2' AND type = 'P')
   DROP PROCEDURE advcms_SitemapRecur2
GO

CREATE PROCEDURE advcms_SitemapRecur2
    @parent_id int, @lvl int, @maxlvl int, @link_placement nvarchar(50)
AS
BEGIN
	SET @lvl=@lvl+1
	IF @lvl <= @maxlvl
	BEGIN

		DECLARE @page_id int, @sorting int, @listingProperty int, @file_name nvarchar(50), @title nvarchar(255), @link_text nvarchar(255), @published_start_date smalldatetime, @published_end_date smalldatetime, @is_hidden bit, @is_system bit, @channel_name nvarchar(50), @channel_permission int, @disable_collaboration bit, @last_updated_date datetime, @status nvarchar(50), @owner nvarchar(50), @title2 nvarchar(255), @link_text2 nvarchar(255), @is_link bit, @link_target nvarchar(50), @link_target2 nvarchar(50)

		DECLARE @lp int
		SET @lp = (SELECT listing_property FROM pages_working WHERE page_id=@parent_id)
		IF @lp=1
		BEGIN
			DECLARE pagesTmp CURSOR LOCAL FOR SELECT page_id, parent_id, sorting, listing_property, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission, disable_collaboration, last_updated_date, status, owner, title2, link_text2, is_link, link_target, link_target2 FROM pages_working WHERE parent_id=@parent_id AND link_placement=@link_placement AND is_system=0 ORDER BY parent_id, sorting
			OPEN pagesTmp
			FETCH NEXT FROM pagesTmp INTO @page_id, @parent_id, @sorting, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2, @is_link, @link_target, @link_target2
			WHILE @@FETCH_STATUS=0
			BEGIN
				INSERT INTO #PageTree (page_id, parent_id, listing_property, file_name, title, link_text, published_start_date, published_end_date, is_hidden, is_system, channel_name, channel_permission,disable_collaboration, last_updated_date, status, owner, title2, link_text2, is_link, link_target, link_target2, lvl) VALUES (@page_id,@parent_id, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission,@disable_collaboration,@last_updated_date,@status,@owner,@title2,@link_text2,@is_link,@link_target,@link_target2,@lvl)

				IF @listingProperty<>2 AND @listingProperty<>3
				BEGIN
					EXEC advcms_SitemapRecur2 @page_id, @lvl, @maxlvl, @link_placement
				END

    				FETCH NEXT FROM pagesTmp INTO @page_id, @parent_id, @sorting, @listingProperty, @file_name, @title, @link_text, @published_start_date, @published_end_date, @is_hidden, @is_system, @channel_name, @channel_permission, @disable_collaboration, @last_updated_date, @status, @owner, @title2, @link_text2, @is_link, @link_target, @link_target2
			END
			CLOSE pagesTmp
			DEALLOCATE pagesTmp
		END
	END
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_TabTree' AND type = 'P')
   DROP PROCEDURE advcms_TabTree
GO

CREATE PROCEDURE [dbo].[advcms_TabTree]
    @parent_id int, @maxlvl int, @link_placement nvarchar(50)
AS
BEGIN
	CREATE TABLE #PageTree (IndexId int IDENTITY (0, 1) NOT NULL,page_id int, parent_id int, listing_property int, file_name nvarchar(50), title nvarchar(255), link_text nvarchar(255), published_start_date smalldatetime, published_end_date smalldatetime, is_hidden bit, is_system bit, channel_name nvarchar(50), channel_permission int, is_link bit, link_target nvarchar(50), lvl int)
	EXEC advcms_SitemapRecur @parent_id, 0 ,@maxlvl, @link_placement
	SELECT * FROM #PageTree
	DROP TABLE #PageTree
END
GO

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_TabTree2' AND type = 'P')
   DROP PROCEDURE advcms_TabTree2
GO

CREATE PROCEDURE [dbo].[advcms_TabTree2]
    @parent_id int, @maxlvl int, @link_placement nvarchar(50)
AS
BEGIN
	CREATE TABLE #PageTree (IndexId int IDENTITY (0, 1) NOT NULL,page_id int, parent_id int, listing_property int, file_name nvarchar(50), title nvarchar(255), link_text nvarchar(255), published_start_date smalldatetime, published_end_date smalldatetime, is_hidden bit, is_system bit, channel_name nvarchar(50), channel_permission int, disable_collaboration bit, last_updated_date datetime, status nvarchar(50), owner nvarchar(50), title2 nvarchar(255), link_text2 nvarchar(255), is_link bit, link_target nvarchar(50), link_target2 nvarchar(50), lvl int)
	EXEC advcms_SitemapRecur2 @parent_id, 0 ,@maxlvl, @link_placement
	SELECT * FROM #PageTree
	DROP TABLE #PageTree
END

GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='guest_book' and sysobjects.type='U' and syscolumns.name='hide')
  alter table guest_book add hide bit NULL
Go

-- UPGRADING --
UPDATE pages set is_listing=1, listing_columns=1 where page_type=11 or page_type=9 or page_type=5 or page_type=4 or page_type=10

UPDATE pages set listing_type=1, listing_property=2, listing_template_id=1 where page_type=5 -- Listing
UPDATE pages set listing_type=1, listing_property=1, listing_template_id=1 where page_type=9 -- Listing (Short)
UPDATE pages set listing_type=2, listing_property=2, listing_template_id=2 where page_type=4 -- News/Journal
UPDATE pages set listing_type=2, listing_property=2, listing_template_id=2 where page_type=10 -- Blog
UPDATE pages set listing_type=2, listing_property=2, listing_template_id=2 where page_type=11 -- Events
-- Others
UPDATE pages set listing_type=1, listing_property=1 where page_type=1 OR page_type=2 OR page_type=3 OR page_type=6 OR page_type=7 OR page_type=8

UPDATE pages set link_target='_blank' where page_type=7
-- /UPGRADING --

ALTER TABLE pages ALTER COLUMN [display_date] datetime NULL

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_views]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[page_views](
	[page_id] [int] NOT NULL,
	[query_string] [nvarchar](500) NOT NULL,
	[ip] [nvarchar](50) NOT NULL,
	[referer] [nvarchar](500) NOT NULL,
	[user_agent] [nvarchar](50) NOT NULL,
	[date_stamp] [smalldatetime] NOT NULL,
	[datetime_stamp] [datetime] NOT NULL
) ON [PRIMARY]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_downloads]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[page_downloads](
	[page_id] [int] NOT NULL,
	[ip] [nvarchar](50) NOT NULL,
	[user_agent] [nvarchar](50) NOT NULL,
	[date_stamp] [smalldatetime] NOT NULL,
	[datetime_stamp] [datetime] NOT NULL
) ON [PRIMARY]
END
GO

IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'pages_views_count_daily' AND type = 'V')
	DROP VIEW pages_views_count_daily
GO
CREATE VIEW dbo.pages_views_count_daily
AS
	SELECT pages_working.page_id, page_views.date_stamp, COUNT(pages_working.page_id) AS count
	FROM page_views INNER JOIN
	pages_working ON page_views.page_id = pages_working.page_id
	GROUP BY page_views.date_stamp, pages_working.page_id
GO

IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'pages_views_count' AND type = 'V')
	DROP VIEW pages_views_count
GO
CREATE VIEW dbo.pages_views_count
AS
	SELECT pages_working.page_id, COUNT(pages_working.page_id) AS total
	FROM pages_working INNER JOIN
	page_views ON pages_working.page_id = page_views.page_id
	GROUP BY pages_working.page_id
GO

IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'pages_downloads_count_daily' AND type = 'V')
	DROP VIEW pages_downloads_count_daily
GO
CREATE VIEW dbo.pages_downloads_count_daily
AS
	SELECT pages_working.page_id, page_downloads.date_stamp, COUNT(pages_working.page_id) AS downloads_today
	FROM pages_working INNER JOIN
	page_downloads ON pages_working.page_id = page_downloads.page_id
	GROUP BY pages_working.page_id, page_downloads.date_stamp
GO

IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'pages_downloads_count' AND type = 'V')
	DROP VIEW pages_downloads_count
GO
CREATE VIEW dbo.pages_downloads_count
AS
	SELECT pages_working.page_id, COUNT(pages_working.page_id) AS total_downloads
	FROM pages_working INNER JOIN
	page_downloads ON pages_working.page_id = page_downloads.page_id
	GROUP BY pages_working.page_id
GO

IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'pages_ratings_count' AND type = 'V')
	DROP VIEW pages_ratings_count
GO
CREATE VIEW dbo.pages_ratings_count
AS
	SELECT TOP 100 PERCENT page_id, SUM(rating * total) AS ratings, COUNT(total) AS total_voters
	FROM page_rating_summary
	GROUP BY page_id
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[config_shop]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[config_shop](
		[root_id] [int] NOT NULL,
		[currency_symbol] [nvarchar](10) NOT NULL,
		[currency_separator] [nvarchar](50) NULL,
		[currency_code] [nvarchar](50) NOT NULL,
		[order_description] [nvarchar](255) NOT NULL,
		[terms] [ntext] NULL,
		[paypal_email] [nvarchar](50) NOT NULL,
		[paypal_url] [nvarchar](255) NOT NULL,
		[paypal_order_email_template] [ntext] NULL,
		[order_now_template] [ntext] NULL
	) ON [PRIMARY]

	ALTER TABLE [dbo].[config_shop] WITH NOCHECK ADD 
		CONSTRAINT [PK_config_shop] PRIMARY KEY  CLUSTERED 
		(
			[root_id]
		)  ON [PRIMARY] 
	
	INSERT INTO config_shop (root_id,currency_symbol,currency_separator,currency_code,order_description,terms,paypal_email,paypal_url,paypal_order_email_template, order_now_template) VALUES 
	(1,'$','','USD','Shopping Cart Total','Your Terms here...','','https://www.sandbox.paypal.com/us/cgi-bin/webscr','<html><head><title>Thank you for your order</title><style>td{font-family:Verdana;font-size:11px}</style></head><body style="font-family:Verdana;font-size:11px"><p>Dear Customer,</p><p><b>Thank you for your order!</b><p>Following is a list of items you purchased on [%ORDER_DATE%] - Order #[%ORDER_ID%]:</p>[%ORDER_DETAIL%]<p>If your order contains downloadable items, please visit:&nbsp;<a href="[%DOWNLOAD_LINK%]">[%DOWNLOAD_LINK%]</a></p><p>Sincerely,<br>Support Team<br><a href="[%WEBSITE_URL%]">[%WEBSITE_URL%]</a></p></body></html>','<table cellpadding="0" cellspacing="0" class="boxOrderNow"><tr><td class="boxHeaderOrderNow">Order Now!</td></tr><tr><td class="boxContentOrderNow"><b>[%TITLE%]</b><br />[%SUMMARY%]<br /><br /><table cellpadding="0" cellspacing="0"><tr style="[%HIDE_PRICE%]"><td style="text-align:right;padding:5px;padding-left:0px">List Price: </td><td style="font-size:14px;padding:5px"><strike>[%PRICE%]</strike></td></tr><tr><td style="text-align:right;padding:5px;padding-left:0px">Price:</td><td style="font-size:12px;font-weight:bold;padding:5px">[%CURRENT_PRICE%]</td></tr></table><br /><a href="[%PAYPAL_ADD_TO_CART_URL%]"/><img src="resources/1/btnBuyNow.jpg" alt="" border="0"/></a><br /></td></tr></table>')
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[orders]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY (1000000, 1) NOT NULL,
	[order_date] [datetime] NOT NULL,
	[order_by] [nvarchar](128) NOT NULL,
	[sub_total] [money] NOT NULL,
	[shipping] [money] NULL,	
	[tax] [money] NULL,
	[total] [money] NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[root_id] [int] NOT NULL,
	[shipping_first_name] [nvarchar](50) NULL,
	[shipping_last_name] [nvarchar](50) NULL,
	[shipping_company] [nvarchar](50) NULL,
	[shipping_address] [nvarchar](255) NULL,
	[shipping_city] [nvarchar](50) NULL,
	[shipping_state] [nvarchar](50) NULL,
	[shipping_country] [nvarchar](50) NULL,
	[shipping_zip] [nvarchar](50) NULL,
	[shipping_phone] [nvarchar](50) NULL,
	[shipping_fax] [nvarchar](50) NULL,
	[shipping_status] [nvarchar](50) NULL,
	[shipped_date] [datetime] NULL,
	[tracking_id] [nvarchar](50) NULL,
	[download_status] [nvarchar](50) NULL
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[orders] WITH NOCHECK ADD 
		CONSTRAINT [PK_orders] PRIMARY KEY  CLUSTERED 
		(
			[order_id]
		)  ON [PRIMARY] 
	
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[order_items]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[order_items](
		[order_item_id] [int] IDENTITY(1,1) NOT NULL,
		[order_id] [int] NOT NULL,
		[item_id] [int] NOT NULL,
		[item_desc] [nvarchar](255) NOT NULL,
		[price] [money] NOT NULL,
		[qty] [int] NOT NULL,
		[tangible] [bit] NOT NULL
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[order_items] WITH NOCHECK ADD 
		CONSTRAINT [PK_order_items] PRIMARY KEY  CLUSTERED 
		(
			[order_item_id]
		)  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[coupons]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[coupons](
	[coupon_id] [int] IDENTITY(1,1) NOT NULL,
	[coupon_type] [int] NOT NULL,
	[percent_off] [int] NULL,
	[amount_off] [int] NULL,
	[all_items] [bit] NOT NULL,
	[item_id] [int] NULL,
	[expire_date] [datetime] NOT NULL,
	[min_purchase] [int] NOT NULL,
	[code] [nvarchar](50) NOT NULL	
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[coupons] WITH NOCHECK ADD 
		CONSTRAINT [PK_coupons] PRIMARY KEY  CLUSTERED 
		(
			[coupon_id]
		)  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[taxes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[taxes](
	[tax_id] [int] IDENTITY(1,1) NOT NULL,
	[tax_rate] [decimal](5, 2) NOT NULL,
	[state] [nvarchar](128) NOT NULL,
	[country] [varchar](3) NOT NULL,
	[items_only] [bit] NOT NULL
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[taxes] WITH NOCHECK ADD 
		CONSTRAINT [PK_taxes] PRIMARY KEY  CLUSTERED 
		(
			[tax_id]
		)  ON [PRIMARY] 
END
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='form.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('form.ascx','Form','admin')
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custom_listings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[custom_listings](
	[custom_listing_id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NULL,
	[columns] [int] NOT NULL,
	[visible_records] [int] NOT NULL,
	[listing_template_id] [int] NOT NULL,
	[use_custom_entries] [bit] NOT NULL,
	[parent_id] [int] NULL,
	[use_box] [bit] NOT NULL
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[custom_listings] WITH NOCHECK ADD 
		CONSTRAINT [PK_custom_listings] PRIMARY KEY  CLUSTERED 
		(
			[custom_listing_id]
		)  ON [PRIMARY] 
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custom_listing_items]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[custom_listing_items](
	[custom_listing_item_id] [int] IDENTITY(1,1) NOT NULL,
	[custom_listing_id] [int] NOT NULL,
	[page_id] [int] NOT NULL,
	[impressions] [int] NULL,
	[impression_date] [datetime] NULL
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[custom_listing_items] WITH NOCHECK ADD 
		CONSTRAINT [PK_custom_listing_items] PRIMARY KEY  CLUSTERED 
		(
			[custom_listing_item_id]
		)  ON [PRIMARY] 
END
GO

DELETE FROM page_modules WHERE module_file='latest_news1.ascx'
DELETE FROM modules WHERE module_file='latest_news1.ascx'
DELETE FROM page_modules WHERE module_file='latest_news2.ascx'
DELETE FROM modules WHERE module_file='latest_news2.ascx'
DELETE FROM page_modules WHERE module_file='latest_news3.ascx'
DELETE FROM modules WHERE module_file='latest_news3.ascx'
DELETE FROM page_modules WHERE module_file='latest_news4.ascx'
DELETE FROM modules WHERE module_file='latest_news5.ascx'
DELETE FROM page_modules WHERE module_file='calendar.ascx'
DELETE FROM modules WHERE module_file='calendar.ascx'
DELETE FROM page_modules WHERE module_file='calendar_events.ascx'
DELETE FROM modules WHERE module_file='calendar_events.ascx'
DELETE FROM page_modules WHERE module_file='events_public.ascx'
DELETE FROM modules WHERE module_file='events_public.ascx'
DELETE FROM page_modules WHERE module_file='products_frontpage_featured.ascx'
DELETE FROM modules WHERE module_file='products_frontpage_featured.ascx'
DELETE FROM page_modules WHERE module_file='products_rotator.ascx'
DELETE FROM modules WHERE module_file='products_rotator.ascx'
DELETE FROM page_modules WHERE module_file='products_upcoming.ascx'
DELETE FROM modules WHERE module_file='products_upcoming.ascx'
DELETE FROM page_modules WHERE module_file='upcoming_events1.ascx'
DELETE FROM modules WHERE module_file='upcoming_events1.ascx'
DELETE FROM page_modules WHERE module_file='upcoming_events2.ascx'
DELETE FROM modules WHERE module_file='upcoming_events2.ascx'
DELETE FROM page_modules WHERE module_file='upcoming_events3.ascx'
DELETE FROM modules WHERE module_file='upcoming_events3.ascx'
DELETE FROM page_modules WHERE module_file='upcoming_events4.ascx'
DELETE FROM modules WHERE module_file='upcoming_events4.ascx'

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='latest_news_scroll.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('latest_news_scroll.ascx','Latest News (scrolling)','admin')
END

UPDATE pages set page_module='' where page_module='systems/form.ascx'

--Directory - Corporate Style
UPDATE listing_templates set template_name='Directory (Corporate Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px">[%RATING%] </td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="text-align:center"><img style="margin:3px;margin-right:10px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]"  alt="" /></td><td valign="top" style="width:100%;height:100%">[%SUMMARY%]</td></tr></table></td></tr></table>' WHERE template_name='Directory - Corporate Style'
--Gallery Listing - Shop Style
UPDATE listing_templates set template_name='Product Gallery', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=4,listing_page_size=12,listing_use_categories=0, template='<div style="margin-top:15px;margin-right:40px;height:150px;;line-height:12px"><div style="padding-top:5px;border:#E0E0E0 1px solid;height:100px;text-align:center;"><a style="[%HIDE_FILE_VIEW_LISTING%]" target="[%LINK_TARGET%]" href="[%FILE_NAME%]"><img onmouseover="float.imgClear();float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]" border="0" /></a></div><div style="font-size:9px">[%TITLE%]</div><div style="font-size:9px">[%SUMMARY%] [%PRICING_INFO%]</div><div style="font-size:9px;"><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a>&nbsp;<span style="[%HIDE_PAYPAL_ADD_TO_CART%]"><span style="color:c0c0c0">|</span>&nbsp;<a href="[%PAYPAL_ADD_TO_CART_URL%]">Buy</a></span></div></div>' WHERE template_name='Gallery Listing - Shop Style'
--General Listing - Shop Style
UPDATE listing_templates set template_name='Product List', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px">[%RATING%] </td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="text-align:center"><img style="margin:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]"  alt="" /><div style="[%HIDE_PAYPAL_ADD_TO_CART%];">[%PRICING_INFO%]<br /><br /><a href="[%PAYPAL_ADD_TO_CART_URL%]"><img src="resources/1/btnBuyNow.jpg" border="0" style="margin-left:3px;margin-right:10px" /></a></div></td><td valign="top" style="height:100%">[%SUMMARY%]</td></tr></table></td></tr></table>' WHERE template_name='General Listing - Shop Style'
--Photo Gallery - Community Style
UPDATE listing_templates set template_name='Photo Gallery (Community Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=4,listing_page_size=12,listing_use_categories=0, template='<div style="margin-top:15px;margin-right:40px;height:170px;line-height:12px"><div style="padding-top:5px;height:100px;border:#E0E0E0 1px solid;text-align:center;"><a style="[%HIDE_FILE_VIEW_LISTING%]" target="[%LINK_TARGET%]" href="[%FILE_NAME%]"><img onmouseover="float.imgClear();float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]" border="0" /></a></div><div style="font-size:9px">[%TITLE%]&nbsp;<i style="color:#888888">- [%LAST_UPDATED_BY%]</i></div><div style="font-size:9px">[%SUMMARY%]</div><div>[%RATING%]</div><div style="font-size:9px">Downloads: [%TOTAL_DOWNLOADS%]</div><div style="font-size:9px;"><span style="[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]">Download</a>&nbsp;<span style="color:#c0c0c0">|</span></span><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div></div>' WHERE template_name='Photo Gallery - Community Style'
--Photo Gallery - Corporate Style
UPDATE listing_templates set template_name='Photo Gallery (Corporate Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=2,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;height:80px;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="background:#f7f7f7"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td valign="top"><div style="height:100px;width:100px"><img style="margin:5px" onmouseover="float.imgClear();float.imgSet(''[%FILE_VIEW_LISTING_MORE_URL%]'');float.doShow(event, ''popImage'')" onmouseout="float.doHide(''popImage'');" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]" border="0" align="left" /></div></td><td style="width:100%;padding:7px;height:100%" valign="top">[%SUMMARY%]<div>Downloads: [%TOTAL_DOWNLOADS%]</div><div>File Size: [%FILE_SIZE%]</div><div><span style="[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]">Download</a>&nbsp;<span style="color:#c0c0c0">|</span></span><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div></td></tr></table></td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">&nbsp;</td><td style="font-size:10px;text-align:right">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr></table>' WHERE template_name='Photo Gallery - Corporate Style'
--Basic Style
UPDATE listing_templates set template_name='General List', listing_type=1,listing_property=3,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap"></td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>' WHERE template_name='Basic Style'
--News/Journal Style
UPDATE listing_templates set template_name='News/Journal (Community Style)', listing_type=2,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=1, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%DISPLAY_DATE%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>' WHERE template_name='News/Journal Style'
--Article List - Community Style
UPDATE listing_templates set template_name='Article List (Community Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_DATE%] - [%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">Hits today: [%HITS_TODAY%] &nbsp;Total: [%TOTAL_HITS%]</td><td style="font-size:10px;text-align:right">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr></table>' WHERE template_name='Article List - Community Style'
--Article List - Corporate Style
UPDATE listing_templates set template_name='Article List (Corporate Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%LAST_UPDATED_DATE%] - [%LAST_UPDATED_BY%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td style="font-size:10px;">Hits: [%TOTAL_HITS%]</td><td style="font-size:10px;text-align:right">&nbsp;</td></tr></table></td></tr></table>' WHERE template_name='Article List - Corporate Style'
--Directory - Community Style
UPDATE listing_templates set template_name='Directory (Community Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;height:18px;font-family:arial;font-weight:bold;color:#333333;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-size:11px;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;[%HIDE_PRICING_INFO%]">PRICE: [%PRICING_INFO%]</td></tr></table></td></tr><tr><td style="border-bottom:#DDDDDD 1px solid;padding:7px"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><div style="font-size:10px;width:250px;">Hits today: [%HITS_TODAY%] &nbsp;Total: [%TOTAL_HITS%]</div></td><td style="font-size:10px;white-space:nowrap;width:100%">[%LAST_UPDATED_DATE%]</td><td style="font-size:10px;text-align:right;white-space:nowrap;">[%COMMENTS%] comments &nbsp;[%RATING%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;border-bottom:#DDDDDD 1px solid;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table>' WHERE template_name='Directory - Community Style'
--File Downloads - Basic Style
UPDATE listing_templates set template_name='File Downloads (Basic Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="height:100%" valign="top"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="padding:7px;[%HIDE_FILE_DOWNLOAD%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/></td><td valign="top" style="width:100%;padding:7px;padding-top:20px;height:100%"><div style="margin-bottom:12px;"><span style="font-family:Arial;font-weight:bold;">[%TITLE%]</span>&nbsp;<a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div><div><a href="[%FILE_DOWNLOAD_URL%]">[%FILE_DOWNLOAD%]</a>&nbsp;([%FILE_SIZE%])</div></td></tr></table></td></tr></table>' WHERE template_name='File Downloads - Basic Style'
--File Downloads - Community Style
UPDATE listing_templates set template_name='File Downloads (Community Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;width:100%;border:#BEC7D1 1px solid;" cellpadding="0" cellspacing="0"><tr><td valign="top"><div style="padding:7px;font-size:10px;[%HIDE_FILE_DOWNLOAD%]"><a href="[%FILE_DOWNLOAD_URL%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/><span style="text-decoration:none"><br />([%FILE_SIZE%])</span><br />[%FILE_DOWNLOAD%]</a><div style="padding-top:3px;font-size:9px;[%HIDE_RATING%]">[%RATING%]</div><div style="font-size:9px;white-space:nowrap;[%HIDE_FILE_DOWNLOAD%]">Downloads: [%TOTAL_DOWNLOADS%]</div></div></td><td valign="top" style="border-left:#BEC7D1 1px solid;width:100%;background:#fcfcfc"><table style="width:100%" cellpadding="0" cellspacing="0"><tr><td valign="top" style="padding:7px;padding-top:6px;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;height:18px;"><a style="font-family:arial;font-weight:bold;font-size:10px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a><span style="font-size:10px"> - [%LAST_UPDATED_DATE%]</span></td></tr><tr><td style="padding:7px;width:100%;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table></td></tr></table>' WHERE template_name='File Downloads - Community Style'
--File Downloads - Corporate Style
UPDATE listing_templates set template_name='File Downloads (Corporate Style)', listing_type=1,listing_property=2,listing_default_order='last_updated_date',listing_columns=1,listing_page_size=12,listing_use_categories=0, template='<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;color:#333333;" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;height:100%" valign="top"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="border-right:#DDDDDD 1px solid;[%HIDE_FILE_DOWNLOAD%]"><div style="padding:7px;font-size:10px;"><a href="[%FILE_DOWNLOAD_URL%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/><span style="text-decoration:none"><br />([%FILE_SIZE%])</span><br />[%FILE_DOWNLOAD%]</a></div></td><td valign="top" style="width:100%;padding:7px;background:#f7f7f7;height:100%"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr></table></td></tr></table>' WHERE template_name='File Downloads - Corporate Style'

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='News/Journal (Basic Style)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template) VALUES ('News/Journal (Basic Style)',2,2,'last_updated_date',1,12,1,'<div style="padding:4px"><div>[%DISPLAY_DATE%]</div><b>[%TITLE%]</b><div>[%SUMMARY%] <a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">More</a></div></div>')
END
ELSE
BEGIN
	UPDATE listing_templates set template='<div style="padding:4px"><div>[%DISPLAY_DATE%]</div><b>[%TITLE%]</b><div>[%SUMMARY%] <a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">More</a></div></div>' WHERE template_name='News/Journal (Basic Style)'
END

GO

ALTER TABLE pages ALTER COLUMN [file_name] [nvarchar] (128)  NULL

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[calendar]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[calendar](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[subject] [nvarchar](255) NOT NULL,
		[location] [ntext] NULL,
		[start_time] [datetime] NOT NULL,
		[end_time] [datetime] NOT NULL,
		[all_day] [bit] NOT NULL,
		[is_rec] [bit] NOT NULL,
		[rec_end_type] [int] NULL,
		[rec_start] [datetime] NULL,
		[rec_end] [datetime] NULL,
		[rec_occurs] [int] NULL,
		[rec_type] [nvarchar](1) NULL,
		[rec_every] [int] NULL,
		[rec_days_in_week] [nvarchar](50) NULL,
		[nth_day_in_month] [int] NULL,
		[nth_day] [int] NULL,
		[weekday] [int] NULL,
		[month] [int] NULL,
		[notes] [ntext] NULL,
		[url] [nvarchar](255) NULL,
		[page_id] [int] NOT NULL
	) ON [PRIMARY]
	ALTER TABLE [dbo].[calendar] WITH NOCHECK ADD 
		CONSTRAINT [PK_calendar] PRIMARY KEY  CLUSTERED 
		(
			[id]
		)  ON [PRIMARY] 
	END
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='events.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('events.ascx','Events','admin')
END

GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='events_upcoming.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('events_upcoming.ascx','Upcoming Events (scrolling)','admin')
END

GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Music/Video List')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template) VALUES ('Music/Video List',1,3,'last_updated_date',1,12,0,'<table style="width:100%;"  cellpadding="0" cellspacing="0"><tr><td style="height:100%" valign="top"><table cellpadding="0" cellspacing="0" style="width:100%;height:100%"><tr><td valign="top" style="padding:7px;[%HIDE_FILE_VIEW%]"><img src="[%FILE_DOWNLOAD_ICON%]" border="0"/></td><td valign="top" style="width:100%;padding:7px;padding-top:20px;height:100%"><div style="margin-bottom:12px;"><span style="font-family:Arial;font-weight:bold;">[%TITLE%]</span>&nbsp;&nbsp;<a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Play</a></div><div><a href="[%FILE_VIEW_URL%]">Download</a></div></td></tr></table></td></tr></table>')
END

GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Software Screenshots')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template) VALUES ('Software Screenshots',1,3,'last_updated_date',4,40,0,'<div style="margin-top:15px;margin-right:40px;line-height:12px;height:135px"><div style="padding-top:5px;border:#E0E0E0 1px solid;text-align:center;height:90px"><a style="[%HIDE_FILE_VIEW%]" href="javascript:modalDialog(''[%FILE_VIEW_URL%]'', 800,600)"><img alt="" title="" src="[%FILE_VIEW_LISTING_URL%]" border="0" /></a></div><div style="font-size:9px">[%TITLE%]</div><div style="font-size:9px">[%SUMMARY%]</div><div style="font-size:9px;"><a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a></div></div>')
END

GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='General List (Include In Sitemap)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template) VALUES ('General List (Include In Sitemap)',1,1,'last_updated_date',1,12,0,'<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap"></td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" />[%SUMMARY%]</td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>')
END

GO

IF NOT EXISTS (SELECT module_file FROM modules 
         WHERE module_file='content_block.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values (
    'content_block.ascx','Content Block','admin')
END
GO

ALTER TABLE pages ALTER COLUMN [file_attachment] NVARCHAR(255) NULL
GO
ALTER TABLE pages ALTER COLUMN [file_view] NVARCHAR(255) NULL
GO
ALTER TABLE pages ALTER COLUMN [file_view_listing] NVARCHAR(255) NULL
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='playlist_flv.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('playlist_flv.ascx','Playlist - Videos (FLV)','admin')
END
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='playlist_images.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('playlist_images.ascx','Playlist - Images','admin')
END
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='playlist_media.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('playlist_media.ascx','Playlist - Media (Images, MP3 & FLV)','admin')
END
GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='playlist_mp3.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('playlist_mp3.ascx','Playlist - Music (MP3)','admin')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Playlist - Images')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,listing_script) VALUES ('Playlist - Images',1,3,'last_updated_date',1,50,0,'','<script type="text/javascript" src="[%APP_PATH%]systems/media/swfobject.js"></script><p id="[%UNIQUE_ID%]"><a href="http" & "://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p><script type="text/javascript">var s3 = new SWFObject("[%APP_PATH%]systems/media/imagerotator.swf", "playlist", "550", "400", "7");s3.addVariable("file","[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]");s3.addVariable("transition","random");s3.addVariable("backcolor","0x00000");s3.addVariable("frontcolor","0xD9CFE7");s3.addVariable("lightcolor","0xB5A0D3");s3.addVariable("shownavigation","true");s3.addVariable("overstretch","none");s3.addVariable("linktarget","_self");s3.addVariable("width","550");s3.addVariable("height","400");s3.write("[%UNIQUE_ID%]");</script>')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Playlist - Music (MP3)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,listing_script) VALUES ('Playlist - Music (MP3)',1,3,'last_updated_date',1,50,0,'','<script type="text/javascript" src="[%APP_PATH%]systems/media/swfobject.js"></script><p id="[%UNIQUE_ID%]"><a href="http" & "://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p><script type="text/javascript">var s3 = new SWFObject("[%APP_PATH%]systems/media/mp3player.swf", "playlist", "240", "135", "7");s3.addVariable("file","[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]");s3.addVariable("backcolor","0x00000");s3.addVariable("frontcolor","0xD9CFE7");s3.addVariable("lightcolor","0xB5A0D3");s3.addVariable("linktarget","_self");s3.addVariable("width","240");s3.addVariable("height","135");s3.addVariable("displayheight","0");s3.write("[%UNIQUE_ID%]");</script>')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Playlist - Videos (FLV)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,listing_script) VALUES ('Playlist - Videos (FLV)',1,3,'last_updated_date',1,50,0,'','<script type="text/javascript" src="[%APP_PATH%]systems/media/swfobject.js"></script><p id="[%UNIQUE_ID%]"><a href="http" & "://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p><script type="text/javascript">var s3 = new SWFObject("[%APP_PATH%]systems/media/flvplayer.swf", "playlist", "300", "312", "7");s3.addVariable("file","[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]");s3.addVariable("backcolor","0x00000");s3.addVariable("frontcolor","0xD9CFE7");s3.addVariable("lightcolor","0xB5A0D3");s3.addVariable("linktarget","_self");s3.addVariable("width","300");s3.addVariable("height","312");s3.addVariable("displayheight","200");s3.write("[%UNIQUE_ID%]");</script>')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Playlist - Media (Images, MP3 & FLV)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,listing_script) VALUES ('Playlist - Media (Images, MP3 & FLV)',1,3,'last_updated_date',1,50,0,'','<script type="text/javascript" src="[%APP_PATH%]systems/media/swfobject.js"></script><p id="[%UNIQUE_ID%]"><a href="http" & "://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p><script type="text/javascript">var s3 = new SWFObject("[%APP_PATH%]systems/media/mediaplayer.swf", "playlist", "300", "312", "7");s3.addVariable("file","[%APP_PATH%]systems/listing_xspf.aspx?pg=[%PAGE_ID%]");s3.addVariable("allowfullscreen","true");s3.addVariable("backcolor","0x00000");s3.addVariable("frontcolor","0xD9CFE7");s3.addVariable("lightcolor","0xB5A0D3");s3.addVariable("linktarget","_self");s3.addVariable("width","300");s3.addVariable("height","312");s3.addVariable("displayheight","200");s3.write("[%UNIQUE_ID%]");</script>')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='News/Journal (MP3)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,listing_script) VALUES ('News/Journal (MP3)',2,2,'last_updated_date',1,12,1,'<table style="margin-top:10px;margin-bottom:10px;background:#efefef;width:100%;" cellpadding="0" cellspacing="0"><tr><td style="padding:7px;padding-top:4px;height:18px;border-top:#b7b7b7 0px solid;background:url(''resources/1/boxheaderbg1.gif'') #e0e0e0;"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td><a style="color:#333333;font-family:arial;font-weight:bold;font-size:11px;white-space:nowrap" target="[%LINK_TARGET%]" href="[%FILE_NAME%]">[%TITLE%]</a></td><td style="text-align:right;font-size:10px;white-space:nowrap">[%DISPLAY_DATE%]</td></tr></table></td></tr><tr><td style="padding:7px;background:#f7f7f7;height:100%" valign="top"><img style="margin-right:7px;margin-bottom:3px;[%HIDE_FILE_VIEW_LISTING%]" src="[%FILE_VIEW_LISTING_URL%]" align="left" alt="" /><span id="id[%PAGE_ID%]"><a href="http" & "://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</span><script type="text/javascript">var sFile = "[%FILE_VIEW_URL%]";sFile = sFile.toLowerCase();if(sFile.indexOf(".mp3")!=-1){var s3 = new SWFObject("systems/media/mp3player.swf", "line", "240", "20", "7");s3.addVariable("file","[%FILE_VIEW_URL%]");s3.addVariable("repeat","true");s3.addVariable("showdigits","false");s3.addVariable("width","240");s3.addVariable("height","20");s3.write("id[%PAGE_ID%]");}else{document.getElementById("id[%PAGE_ID%]").style.display="none";}</script><div>[%SUMMARY%]</div></td></tr><tr><td style="border-bottom:#DDDDDD 2px solid;padding:7px"></td></tr></table>','<script type="text/javascript" src="[%APP_PATH%]systems/media/swfobject.js"></script>')
END
GO

IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='flash_001')
BEGIN
    insert into templates (template_name,folder_name) values ('Flash 001', 'flash_001')
END
GO
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='flash_002')
BEGIN
    insert into templates (template_name,folder_name) values ('Flash 002', 'flash_002')
END
GO
IF NOT EXISTS (SELECT * FROM templates WHERE folder_name='flash_003')
BEGIN
    insert into templates (template_name,folder_name) values ('Flash 003', 'flash_003')
END
GO

ALTER TABLE newsletters ALTER COLUMN [subject] nvarchar(255) NULL
GO

ALTER TABLE coupons ALTER COLUMN [percent_off]  decimal(18, 2) NULL
GO
ALTER TABLE coupons ALTER COLUMN [amount_off]  decimal(18, 2) NULL
GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='page_comments' and sysobjects.type='U' and syscolumns.name='hide')
  alter table page_comments add hide bit NULL
Go

-------------------------------------------------------
--Create Discussion
-------------------------------------------------------

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[discussion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    BEGIN
	    CREATE TABLE [dbo].[discussion] (
	      [subject_id] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	      [parent_id] [decimal](18, 0) NOT NULL ,
	      [subject] [nvarchar] (255) NULL ,
	      [message] [ntext] NULL ,
	      [posted_by] [nvarchar] (64) NULL ,
	      [posted_date] [datetime] NULL ,
	      [type] [char] (1) NOT NULL ,
	      [category] [nvarchar] (64) NULL ,
	      [noreply] [bit] NULL,
	      [reply_to] [decimal] (18, 0) NULL,
	      [last_post_id] [decimal] (18, 0) NULL,
	      [status] varchar(16) NOT NULL,
	      [viewed] int NULL,
	      [page_id] [int] NULL
	    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    	
    END 
ELSE
    BEGIN
        If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='discussion' and sysobjects.type='U' and syscolumns.name='page_id')
		Begin
          alter table discussion add page_id int NULL
		End
    END
GO

Update discussion set page_id=(
    select distinct top 1 page_id from pages join page_modules on (pages.file_name=page_modules.embed_in) where module_file='forum.ascx'
) where discussion.page_id is NULL
Go

IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'advcms_CreateDiscussion' AND type = 'P')
   DROP PROCEDURE advcms_CreateDiscussion
GO

CREATE PROCEDURE advcms_CreateDiscussion (
    @parent_id decimal,
    @subject nvarchar(255),
    @message ntext,
    @posted_by nvarchar(64),
    @posted_date datetime,
    @type char (1),
    @category nvarchar(64),
    @noreply bit,
    @reply_to decimal,
    @last_post_id decimal,
    @status varchar(16),
    @page_id int
) AS
Insert into discussion (parent_id, subject, message, posted_by, posted_date,
    type, category, noreply, reply_to, last_post_id, status, page_id)
values(@parent_id, @subject, @message, @posted_by, @posted_date,
    @type, @category, @noreply, @reply_to, @last_post_id, @status, @page_id)

declare @newId decimal
set @newId=SCOPE_IDENTITY()

if @type='R' OR @type='Q' OR @type='T'
begin
    update discussion set last_post_id=@newId where subject_id=@parent_id
    if @type='R' OR @type='Q'
    begin
        update discussion set last_post_id=@newId where subject_id=(select parent_id from discussion where subject_id=@parent_id)
    end
end
    
Select * from discussion where subject_id=@newId

GO

IF NOT EXISTS (SELECT * FROM modules 
    WHERE module_file='helloworld.ascx')
BEGIN
	INSERT INTO modules (module_file, display_name, owner) VALUES ('helloworld.ascx','Hello World!','admin')
END

GO

If not exists(select sysobjects.name, syscolumns.name from sysobjects left join syscolumns on sysobjects.id=syscolumns.id where sysobjects.name='listing_categories' and sysobjects.type='U' and syscolumns.name='parent_id')
BEGIN
    alter table listing_categories add parent_id int NULL
END
GO

UPDATE listing_categories SET parent_id=0 WHERE parent_id is null
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[membership_add]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	CREATE TABLE [dbo].[membership_add] (
		[user_name] [nvarchar] (200)  NOT NULL ,
		[fileUrl] [varchar](200) NULL
	) ON [PRIMARY]
	ALTER TABLE [dbo].[membership_add] WITH NOCHECK ADD 
		CONSTRAINT [PK_user_name] PRIMARY KEY  CLUSTERED 
		(
			[user_name]
		)  ON [PRIMARY] 
	END
GO

IF NOT EXISTS (SELECT module_file FROM modules 
    WHERE module_file='forum_list.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values (
    'forum_list.ascx','Forum - Latest Posts','admin')
END
GO

--*******************************
--get publised pages view
--*******************************
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'pages_published_active' AND type = 'V') 
    DROP VIEW pages_published_active
GO

CREATE VIEW dbo.pages_published_active
as
select top 100 percent
    allpages.page_id,
    allpages.version,
    allpages.parent_id,
    allpages.sorting,
    allpages.page_template_id as template_id,
    allpages.page_type,
    allpages.file_name as file_name,
    allpages.title,
    allpages.summary,
    allpages.price,
    allpages.link_text,
    allpages.link_placement,
    allpages.content_left,
    allpages.content_body,
    allpages.content_right,
    allpages.file_attachment,
    allpages.file_size,
    allpages.owner,
    allpages.created_date,
    allpages.last_updated_date,
    allpages.last_updated_by,
    allpages.published_start_date,
    allpages.published_end_date,
    allpages.meta_title,
    allpages.meta_keywords,
    allpages.meta_description,
    allpages.status,
    allpages.is_hidden,
    allpages.is_system,
    allpages.page_module,
    allpages.use_discussion,
    allpages.use_rating,
    allpages.use_comments,
    allpages.allow_links_crawled,
    allpages.allow_page_indexed,
    allpages.is_marked_for_archival,
    allpages.notes,
    allpages.display_date,
    allpages.properties,
    allpages.properties2,
    allpages.root_id,
    allpages.https,
    allpages.event_all_day,
    allpages.event_start_date,
    allpages.event_end_date,
    allpages.is_listing,
    allpages.listing_datetime_format,
    allpages.listing_template_id,
    allpages.elements,
    allpages.listing_elements,
    allpages.first_published_date,
    allpages.link,
    allpages.link_target,
    allpages.is_link,
    allpages.sale_price,
    allpages.discount_percentage,
    allpages.weight,
    allpages.sku,
    allpages.units_in_stock,
    allpages.file_view,
    allpages.file_view_listing,
    allpages.tangible,
    templates.template_name,
    templates.folder_name,
    channels.channel_id,
    channels.channel_name,
    channels.permission as channel_permission,
    channels.disable_collaboration as disable_collaboration,
    listing_templates.listing_script as listing_script,
    listing_templates.listing_type as listing_type,
    listing_templates.listing_property as listing_property,
    listing_templates.listing_columns as listing_columns,
    listing_templates.listing_page_size as listing_page_size,
    listing_templates.listing_use_categories as listing_use_categories,
    listing_templates.listing_default_order as listing_default_order
from (
select pages.*, template_id as page_template_id from pages where use_default_template=0 and status='published'
union all
select pages.*, channels.default_template_id as page_template_id from pages join channels on pages.channel_id=channels.channel_id where 
use_default_template=1  and status='published'
) as allpages join templates on allpages.page_template_id=templates.template_id
join channels on allpages.channel_id=channels.channel_id
left outer join listing_templates on allpages.listing_template_id=listing_templates.id
where
    ((allpages.published_start_date<=CAST ( FLOOR( CAST( GETDATE() AS FLOAT ) ) AS SMALLDATETIME )) OR (allpages.published_start_date is NULL))
    and
    ((allpages.published_end_date>=CAST ( FLOOR( CAST( GETDATE() AS FLOAT ) ) AS SMALLDATETIME )) OR (allpages.published_end_date is NULL))
order by allpages.parent_id, allpages.sorting

GO

IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_views_current_h.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_views_current_h.ascx','Stat: Page Views (Current Page) - Horizontal','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_views_overall_h.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_views_overall_h.ascx','Stat: Page Views (Overall) - Horizontal','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_views_current_v.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_views_current_v.ascx','Stat: Page Views (Current Page) - Vertical','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_views_overall_v.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_views_overall_v.ascx','Stat: Page Views (Overall) - Vertical','admin')
END
GO


IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_visits_current_h.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_visits_current_h.ascx','Stat: Page Visits (Current Page) - Horizontal','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_visits_overall_h.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_visits_overall_h.ascx','Stat: Page Visits (Overall) - Horizontal','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_visits_current_v.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_visits_current_v.ascx','Stat: Page Visits (Current Page) - Vertical','admin')
END
GO
IF NOT EXISTS (SELECT module_file FROM modules WHERE module_file='stat_visits_overall_v.ascx')
BEGIN
    insert into modules (module_file,display_name,owner) values ('stat_visits_overall_v.ascx','Stat: Page Visits (Overall) - Vertical','admin')
END
GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='News/Journal (Box)')
BEGIN
	INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,template_header,template_footer) VALUES ('News/Journal (Box)',2,2,'last_updated_date',1,4,1,'<div style="padding:4px;padding-left:35px;text-align:left;"><div>[%DISPLAY_DATE%]</div><b>[%TITLE%]</b><div>[%SUMMARY%] <a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">More</a></div></div>','<div style="width:100%"><div style="padding-left:35px;padding-top:5px;text-align:left;font-weight:bold;font-size:9pt;font-family:Tahoma;background:url(''templates/community_001/images/boxheaderbg.gif'');color:#2c2c2c;height:22px;">[%TITLE%]</div>','<div style="padding-left:35px;text-align:left"><a href="[%READ_MORE%]">Read More</a></div></div>')
END

GO

IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Photo Gallery (AJAX Style)')
BEGIN
    INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,template_header,template_footer,listing_script) VALUES ('Photo Gallery (AJAX Style)',1,2,'last_updated_date',4,8,1,'<div style="margin-top:15px;margin-right:40px;height:170px;line-height:12px">'+CHAR(13)+'<div style="padding-top:5px;height:100px;border:#E0E0E0 1px solid;text-align:center;">'+CHAR(13)+'<img style="cursor:pointer" onclick="javascript:_openThis(''[%FILE_VIEW_URL%]'',''[%TITLE%]'',''idBox'')" alt="" title="" src="[%FILE_VIEW_LISTING_URL%]" border="0" />'+CHAR(13)+'</div>'+CHAR(13)+'<div style="font-size:9px">[%TITLE%] '+CHAR(13)+'<i style="color:#888888">- [%LAST_UPDATED_BY%]</i></div>'+CHAR(13)+'<div style="font-size:9px">[%SUMMARY%]</div><div>[%RATING%]</div>'+CHAR(13)+'<div style="font-size:9px">Downloads: [%TOTAL_DOWNLOADS%]</div>'+CHAR(13)+'<div style="font-size:9px;"><span style="[%HIDE_FILE_DOWNLOAD%]">'+CHAR(13)+'<a href="[%FILE_DOWNLOAD_URL%]">Download</a> <span style="color:#c0c0c0">|</span></span>'+CHAR(13)+'<a target="[%LINK_TARGET%]" href="[%FILE_NAME%]">Details</a>'+CHAR(13)+'</div>'+CHAR(13)+'</div>'+CHAR(13)+'','','','<script language="javascript" type="text/javascript">'+CHAR(13)+'     <!--'+CHAR(13)+'    var orgDim=[];'+CHAR(13)+'    var tm=null;'+CHAR(13)+'    var tm2=null;'+CHAR(13)+'    var img = new Image();'+CHAR(13)+'    var sTitle="";'+CHAR(13)+''+CHAR(13)+'    function _openImage(id)'+CHAR(13)+'        {'+CHAR(13)+'        '+CHAR(13)+'        orgDim[0]=parseInt(img.width)+24; '+CHAR(13)+'        orgDim[1]=parseInt(img.height)+28; '+CHAR(13)+'                '+CHAR(13)+'        var dv=document.getElementById(id);        '+CHAR(13)+'        dv.innerHTML="";//clean'+CHAR(13)+''+CHAR(13)+'        if(parseInt(dv.style.height)<=orgDim[1]) tm=window.setInterval(function(){animExpandHeight(dv);}, 15);//speed=30'+CHAR(13)+'        else tm=window.setInterval(function(){animCollapseHeight(dv);}, 15);'+CHAR(13)+'        }    '+CHAR(13)+'    function animExpandHeight(dv) '+CHAR(13)+'        {'+CHAR(13)+'        var h=parseInt(dv.style.height)+10;//steps=10'+CHAR(13)+'        if(h>=orgDim[1]) '+CHAR(13)+'            {'+CHAR(13)+'            h=orgDim[1];clearInterval(tm);tm=null;'+CHAR(13)+'            if(parseInt(dv.style.width)<=orgDim[0]) tm2=window.setInterval(function(){animExpandWidth(dv);}, 15);'+CHAR(13)+'            else tm2=window.setInterval(function(){animCollapseWidth(dv);}, 15);'+CHAR(13)+'            }'+CHAR(13)+'        dv.style.height=h+"px";'+CHAR(13)+'        '+CHAR(13)+'        dv.style.top=parseInt(dv.style.top)-5 + "px";'+CHAR(13)+'        }'+CHAR(13)+'    function animCollapseHeight(dv) '+CHAR(13)+'        {'+CHAR(13)+'        var h=parseInt(dv.style.height)-10;'+CHAR(13)+'        if(h<orgDim[1]) '+CHAR(13)+'            {'+CHAR(13)+'            h=orgDim[1];clearInterval(tm);tm=null;'+CHAR(13)+'            if(parseInt(dv.style.width)<=orgDim[0]) tm2=window.setInterval(function(){animExpandWidth(dv);}, 15);'+CHAR(13)+'            else tm2=window.setInterval(function(){animCollapseWidth(dv);}, 15);'+CHAR(13)+'            }'+CHAR(13)+'        dv.style.height=h+"px";'+CHAR(13)+'        '+CHAR(13)+'        dv.style.top=parseInt(dv.style.top)+5 + "px";'+CHAR(13)+'        }'+CHAR(13)+'    function animExpandWidth(dv) '+CHAR(13)+'        {'+CHAR(13)+'        var w=parseInt(dv.style.width)+10;'+CHAR(13)+'        if(w>=orgDim[0]) '+CHAR(13)+'            {'+CHAR(13)+'            w=orgDim[0];clearInterval(tm2);tm2=null;'+CHAR(13)+'            '+CHAR(13)+'            var oImg = document.createElement("img");'+CHAR(13)+'            oImg.src=img.src;'+CHAR(13)+'            dv.appendChild(oImg);'+CHAR(13)+'            '+CHAR(13)+'            var oDiv = document.createElement("DIV");'+CHAR(13)+'            oDiv.style.paddingTop="3px";'+CHAR(13)+'            oDiv.innerHTML="<table style=\"width:100%;\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"padding-left:12px;text-align:left;font-weight:bold;font-family:arial;font-size:8pt;color:#333333\">"+sTitle+"</td><td style=\"text-align:right;padding-right:12px;\"><a href=\"javascript:_closeThis()\" style=\"font-family:arial;font-size:16px;font-weight:bold;color:#a0a0a0\">Close</a></td></tr></table>"'+CHAR(13)+'            dv.appendChild(oDiv);'+CHAR(13)+'            }'+CHAR(13)+'        dv.style.width=w+"px";'+CHAR(13)+'        '+CHAR(13)+'        dv.style.left=parseInt(dv.style.left)-5 + "px";'+CHAR(13)+'        }'+CHAR(13)+'    function animCollapseWidth(dv)'+CHAR(13)+'        {'+CHAR(13)+'        var w=parseInt(dv.style.width)-10;'+CHAR(13)+'        if(w<orgDim[0]) '+CHAR(13)+'            {'+CHAR(13)+'            w=orgDim[0];clearInterval(tm2);tm2=null;'+CHAR(13)+''+CHAR(13)+'            var oImg = document.createElement("img");'+CHAR(13)+'            oImg.src=img.src;'+CHAR(13)+'            dv.appendChild(oImg);'+CHAR(13)+'            '+CHAR(13)+'            var oDiv = document.createElement("DIV");'+CHAR(13)+'            oDiv.innerHTML="<table style=\"width:100%;\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"padding-left:12px;text-align:left;font-weight:bold;font-family:arial;font-size:8pt;color:#333333\">"+sTitle+"</td><td style=\"text-align:right;padding-right:12px;\"><a href=\"javascript:_closeThis()\" style=\"font-family:arial;font-size:16px;font-weight:bold;color:#a0a0a0\">Close</a></td></tr></table>"'+CHAR(13)+'            oDiv.style.paddingTop="3px";'+CHAR(13)+'            dv.appendChild(oDiv);'+CHAR(13)+'            }'+CHAR(13)+'        dv.style.width=w+"px";'+CHAR(13)+'        '+CHAR(13)+'        dv.style.left=parseInt(dv.style.left)+5 + "px";'+CHAR(13)+'        }'+CHAR(13)+'        '+CHAR(13)+'    function _closeThis()'+CHAR(13)+'        {'+CHAR(13)+'        var idTmp=document.getElementById(''idBox'');'+CHAR(13)+'        idTmp.innerHTML=""; '+CHAR(13)+'        clearInterval(tm);tm=null;'+CHAR(13)+'        clearInterval(tm2);tm2=null;'+CHAR(13)+'        idTmp.style.display="none";'+CHAR(13)+'        var idProgress=document.getElementById(''idProgress''); '+CHAR(13)+'        idProgress.style.cssText="";'+CHAR(13)+'        }'+CHAR(13)+'    function _openThis(url,title,id)'+CHAR(13)+'        {'+CHAR(13)+'        var idTmp=document.getElementById(''idBox''); '+CHAR(13)+' '+CHAR(13)+'        var idTitle=document.getElementById(''idTitle''); '+CHAR(13)+'        idTitle=title;'+CHAR(13)+'        sTitle=title;'+CHAR(13)+'         '+CHAR(13)+'        idTmp.style.width="250px";'+CHAR(13)+'        idTmp.style.height="250px";        '+CHAR(13)+'        idTmp.style.top=document.documentElement.scrollTop + (parseInt(document.documentElement.clientHeight)/2)-125 + "px";'+CHAR(13)+'        idTmp.style.left=document.documentElement.scrollLeft + (parseInt(document.documentElement.clientWidth)/2)-125 + "px";'+CHAR(13)+'        '+CHAR(13)+'        var oImg = document.createElement("img");'+CHAR(13)+'        oImg.src="systems/images/animated_progress.gif";'+CHAR(13)+'        oImg.style.cssText="margin:10px";'+CHAR(13)+'        idTmp.appendChild(oImg);'+CHAR(13)+'        idTmp.style.display="block";'+CHAR(13)+'        '+CHAR(13)+'        img.src=url;'+CHAR(13)+'        img.onload=function(){_openImage(id)}; '+CHAR(13)+'        '+CHAR(13)+'        var idProgress=document.getElementById(''idProgress''); '+CHAR(13)+'        idProgress.style.cssText="position:absolute;top:"+document.documentElement.scrollTop+"px;left:"+document.documentElement.scrollLeft+"px;width:100%;height:1000px;background-color:black;moz-opacity:0.8;khtml-opacity:.8;opacity:.8;filter:alpha(opacity=80);z-index:100;";  '+CHAR(13)+'        }'+CHAR(13)+'    // -->'+CHAR(13)+'</script>'+CHAR(13)+''+CHAR(13)+'<div id="idBox" style="padding-top:12px;position:absolute;z-index:200;background-color:white;display:none;border:#333333 1px solid;text-align:center;"></div>'+CHAR(13)+'<div id="idProgress" onclick="javascript:_closeThis()"></div>'+CHAR(13)+'<div id="idBottom" style="display:none"><span id="idTitle"></span><a href="javascript:_closeThis()">Close</a></div>'+CHAR(13)+'')
END
GO
IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='Image Slideshow')
BEGIN
    INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,template_header,template_footer,listing_script) VALUES ('Image Slideshow',1,3,'last_updated_date',1,50,0,'<script language="javascript" type="text/javascript">'+CHAR(13)+'     <!--'+CHAR(13)+'     var n = [%INDEX%];'+CHAR(13)+'     sURL[n]="[%FILE_VIEW_URL%]";   '+CHAR(13)+'    // -->'+CHAR(13)+'</script>'+CHAR(13)+'<span style="display:none" id="title[%INDEX%]">[%TITLE%] &nbsp;<a style="[%HIDE%]" href="[%FILE_NAME%]">Detail</a></span>'+CHAR(13)+'<span style="display:none" id="sum[%INDEX%]">[%SUMMARY%]</span>'+CHAR(13)+''+CHAR(13)+'','<table style="width:610px" cellpadding="0" cellspacing="0">'+CHAR(13)+'<tr><td style="width:100%;">'+CHAR(13)+'<div id="idImageTitle" style="font-weight:bold;font-family:arial;font-size:16px"></div>'+CHAR(13)+'</td>'+CHAR(13)+'<td style="text-align:right;white-space:nowrap;color:#9a9b9c;font-family:arial;font-size:14px;font-weight:bold" valign="top">'+CHAR(13)+'<span id="idPageNum"></span>&nbsp;&nbsp;'+CHAR(13)+'<a style="color:#9a9b9c;font-family:arial;" href="javascript:_doPrev()">Prev</a>&nbsp;'+CHAR(13)+'<a style="color:#9a9b9c;font-family:arial;" href="javascript:_doNext()">Next</a>'+CHAR(13)+'</td></tr>'+CHAR(13)+'<tr><td colspan="2" style="padding-top:5px;padding-bottom:5px">'+CHAR(13)+'<div id="idImageSummary" style=""></div>'+CHAR(13)+'</td></tr>'+CHAR(13)+'</table>'+CHAR(13)+''+CHAR(13)+'','<div id="idBox" style="overflow:auto;width:600px;height:400px;border:#cacbcc 7px solid;margin-top:3px;"></div>'+CHAR(13)+'<script language="javascript" type="text/javascript">'+CHAR(13)+'     <!--'+CHAR(13)+'     img.src=sURL[0];'+CHAR(13)+'     img.onload=function(){_openImage(img)}; '+CHAR(13)+'     document.getElementById("idImageTitle").innerHTML=document.getElementById("title0").innerHTML;'+CHAR(13)+'     document.getElementById("idPageNum").innerHTML = "1 of " + (n+1);'+CHAR(13)+'     document.getElementById("idImageSummary").innerHTML=document.getElementById("sum0").innerHTML;'+CHAR(13)+'    // -->'+CHAR(13)+'</script>','<script language="javascript" type="text/javascript">'+CHAR(13)+'     <!--'+CHAR(13)+'     var img = new Image();'+CHAR(13)+'     var sURL=[]; '+CHAR(13)+'     var nCurrentImage=0;     '+CHAR(13)+''+CHAR(13)+'     function _doNext()'+CHAR(13)+'	{'+CHAR(13)+'	if(nCurrentImage<n)nCurrentImage=nCurrentImage+1;'+CHAR(13)+'	else return;'+CHAR(13)+'	_showProgress()'+CHAR(13)+''+CHAR(13)+'	var sImgUrl=sURL[nCurrentImage];'+CHAR(13)+'	img.src=sImgUrl;'+CHAR(13)+'	img.onload=function(){_openImage(img)}; '+CHAR(13)+''+CHAR(13)+'	document.getElementById("idImageTitle").innerHTML=document.getElementById("title"+nCurrentImage).innerHTML;'+CHAR(13)+'	document.getElementById("idPageNum").innerHTML = (nCurrentImage+1) + " of " + (n+1);'+CHAR(13)+'	document.getElementById("idImageSummary").innerHTML=document.getElementById("sum"+nCurrentImage).innerHTML;'+CHAR(13)+'	}'+CHAR(13)+'     function _doPrev()'+CHAR(13)+'	{'+CHAR(13)+'	if(nCurrentImage>0)nCurrentImage=nCurrentImage-1;'+CHAR(13)+'	else return;'+CHAR(13)+'	_showProgress()'+CHAR(13)+''+CHAR(13)+'	var sImgUrl=sURL[nCurrentImage];'+CHAR(13)+'	img.src=sImgUrl;'+CHAR(13)+'	img.onload=function(){_openImage(img)}; '+CHAR(13)+''+CHAR(13)+'	document.getElementById("idImageTitle").innerHTML=document.getElementById("title"+nCurrentImage).innerHTML;'+CHAR(13)+'	document.getElementById("idPageNum").innerHTML = (nCurrentImage+1) + " of " + (n+1);'+CHAR(13)+'	document.getElementById("idImageSummary").innerHTML=document.getElementById("sum"+nCurrentImage).innerHTML;'+CHAR(13)+'	}'+CHAR(13)+'     function _showProgress()'+CHAR(13)+'	{'+CHAR(13)+'	var oImg = document.createElement("img");'+CHAR(13)+'	oImg.src="systems/images/animated_progress.gif";'+CHAR(13)+'	oImg.style.cssText="margin:10px";'+CHAR(13)+'	var idBox=document.getElementById("idBox");'+CHAR(13)+'	idBox.innerHTML="";'+CHAR(13)+'	idBox.appendChild(oImg);'+CHAR(13)+'	}'+CHAR(13)+'     function _openImage(o)'+CHAR(13)+'	{'+CHAR(13)+'	var idBox=document.getElementById("idBox");'+CHAR(13)+'	idBox.innerHTML="";'+CHAR(13)+'	idBox.appendChild(o);'+CHAR(13)+'	}'+CHAR(13)+'    // -->'+CHAR(13)+'</script>'+CHAR(13)+'')
END
GO
IF NOT EXISTS (SELECT * FROM listing_templates 
    WHERE template_name='FAQ')
BEGIN
    INSERT INTO listing_templates (template_name,listing_type,listing_property,listing_default_order,listing_columns,listing_page_size,listing_use_categories,template,template_header,template_footer,listing_script) VALUES ('FAQ',1,3,'last_updated_date',1,12,0,'<div style="padding:10px;border-bottom:#c6c7c8 1px dotted">'+CHAR(13)+'<a onfocus="this.blur()" href="javascript:icPanelClick(this, panel[%PAGE_ID%]);" style="font-weight:bold">'+CHAR(13)+'[%TITLE%]</a>'+CHAR(13)+''+CHAR(13)+'<div id="panel[%PAGE_ID%]" style="width:100%;height:70px;padding-top:10px;display:none">'+CHAR(13)+'[%SUMMARY%]  <a href="[%FILE_NAME%]">More</a>'+CHAR(13)+'</div>'+CHAR(13)+''+CHAR(13)+'<script>'+CHAR(13)+'  var panel[%PAGE_ID%]=new ICExpPanel("panel[%PAGE_ID%]");'+CHAR(13)+'</script>'+CHAR(13)+'</div>','<div style="background:#f5f6f7;border-top:#c6c7c8 1px solid;margin-right:15px">'+CHAR(13)+''+CHAR(13)+''+CHAR(13)+'','</div>','<script type="text/javascript" src="[%APP_PATH%]systems/exppanel/exppanel.js"></script>'+CHAR(13)+'')
END
GO


