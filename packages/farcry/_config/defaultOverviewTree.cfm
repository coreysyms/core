<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/packages/farcry/_config/defaultOverviewTree.cfm,v 1.2 2004/07/09 04:08:48 paul Exp $
$Author: paul $
$Date: 2004/07/09 04:08:48 $
$Name: milestone_2-2-1 $
$Revision: 1.2 $

|| DESCRIPTION || 
$Description: deploys overview tree config $
$TODO: $

|| DEVELOPER ||
$Developer: Paul Harrison (harrisonp@cbs.curtin.edu.au) $

|| ATTRIBUTES ||
$in: $
$out:$
--->

<cfset stStatus = StructNew()>
<cfset stConfig = StructNew()>
<cfset aTmp = ArrayNew(1)>

<cfscript>
stConfig.editHandler = "/farcry/farcry_core/admin/config/overviewTree.cfm";
stConfig.bUseHIResInsert = '0';
stConfig.insertJSdmImageHiRes = "<img alt='""+theNode['ALT']+""' src='#application.url.webroot#/images/""+theNode['OPTIMISEDIMAGE']+""'>";
stConfig.insertJSdmHTML = "<a href='##stOverview['menu']['insert']['dmHTML']##?objectId=""+lastSelectedId+""'>""+theNode['TITLE']+""</a>";
stConfig.insertJSdmFile = "<a href='#application.url.webroot#/download.cfm?DownloadFile=""+lastSelectedId+""' target='_blank'>""+theNode['TITLE']+""</a>";
stConfig.insertJSdmFlash = "<OBJECT classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab####version=""+theNode['FLASHVERSION']+""' WIDTH='""+theNode['FLASHWIDTH']+""'  HEIGHT='""+theNode['FLASHHEIGHT']+""'  ALIGN='""+theNode['FLASHALIGN']+""'><PARAM NAME='movie' VALUE='http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##application.url.webroot#/files/""+theNode['FLASHMOVIE']+""'><PARAM NAME='quality' VALUE='""+theNode['FLASHQUALITY']+""'><PARAM NAME='play' VALUE='""+theNode['FLASHPLAY']+""'><PARAM NAME='menu' VALUE='""+theNode['FLASHMENU']+""'><PARAM NAME='loop' VALUE='""+theNode['FLASHLOOP']+""'><PARAM NAME='FlashVars' VALUE='""+theNode['FLASHPARAMS']+""'><EMBED SRC='http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/#application.url.webroot#/files/""+theNode['FLASHMOVIE']+""' QUALITY='""+theNode['FLASHQUALITY']+""' WIDTH='""+theNode['FLASHWIDTH']+""' HEIGHT='""+theNode['FLASHHEIGHT']+""' FLASHVARS='""+theNode['FLASHPARAMS']+""' ALIGN='""+theNode['FLASHALIGN']+""' MENU='""+theNode['FLASHMENU']+""' PLAY='""+theNode['FLASHPLAY']+""' LOOP='""+theNode['FLASHLOOP']+""' TYPE='application/x-shockwave-flash' PLUGINSPAGE='http://www.macromedia.com/go/getflashplayer'></EMBED></OBJECT>";
stConfig.insertJSdmImage = "<img alt='""+theNode['ALT']+""' src='#application.url.webroot#/images/""+theNode['IMAGEFILE']+""'>";
</cfscript>

<cfwddx action="CFML2WDDX" input="#stConfig#" output="wConfig">

<cftry>
	<cfquery datasource="#arguments.dsn#" name="qDelete">
		delete from #application.dbowner#config
		where configname = '#arguments.configName#'
	</cfquery>
	
	<cfquery datasource="#arguments.dsn#" name="qUpdate">
		INSERT INTO #application.dbowner#config
		(configName, wConfig)
		VALUES
		('#arguments.configName#', '#wConfig#')
	</cfquery>
	
	<cfset stStatus.message = "#arguments.configName# created successfully">
	<cfcatch>
		<cfset stStatus.message = cfcatch.message>
		<cfset stStatus.detail = cfcatch.detail>
	</cfcatch>
</cftry>