<cfsetting enablecfoutputonly="Yes">
<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/packages/types/_dmLink/edit.cfm,v 1.4 2003/07/15 07:04:15 brendan Exp $
$Author: brendan $
$Date: 2003/07/15 07:04:15 $
$Name: b131 $
$Revision: 1.4 $

|| DESCRIPTION || 
$Description: dmLink Edit Handler $
$TODO: $

|| DEVELOPER ||
$Developer: Brendan Sisson (brendan@daemon.com.au) $

|| ATTRIBUTES ||
$in: url.killplp (optional)$
--->
<cfimport taglib="/farcry/farcry_core/tags/farcry" prefix="farcry">
<cfimport taglib="/farcry/farcry_core/tags/navajo/" prefix="nj">
<cfparam name="url.killplp" default="0">

<!--- work out if called from tree or dynamic admin --->
<nj:treeGetRelations 
	typename="#stObj.typename#"
	objectId="#stObj.objectid#"
	get="parents"
	r_lObjectIds="ParentID"
	bInclusive="1">
				
<cfif len(parentId)>
	<cfset cancelPath = "#application.url.farcry#/edittabOverview.cfm?objectid=#stObj.objectid#">
<cfelse>
		<cfset cancelPath = "#application.url.farcry#/navajo/genericAdmin.cfm?typename=#stObj.typename#">	
</cfif>

<cfoutput>
<farcry:plp 
	owner="#session.dmSec.authentication.userlogin#_#stObj.objectID#"
	stepDir="/farcry/farcry_core/packages/types/_dmLink/plpEdit"
	cancelLocation="#cancelPath#"
	iTimeout="15"
	stInput="#stObj#"
	bDebug="0"
	bForceNewInstance="#url.killplp#"
	r_stOutput="stOutput"
	storage="file"
	storagedir="#application.fourq.plpstorage#"
	redirection="server"
	r_bPLPIsComplete="bComplete">

	<farcry:plpstep name="start" template="start.cfm">
	<farcry:plpstep name="categories" template="categories.cfm">
	<farcry:plpstep name="complete" template="complete.cfm" bFinishPLP="true">
</farcry:plp> 
</cfoutput>

<cfif isDefined("bComplete") and bComplete>

	<!--- unlock object --->
	<cfinvoke component="#application.packagepath#.farcry.locking" method="unlock" returnvariable="unlockRet">
		<cfinvokeargument name="stObj" value="#stOutput#"/>
		<cfinvokeargument name="objectid" value="#stOutput.objectid#"/>
		<cfinvokeargument name="typename" value="#stOutput.typename#"/>
	</cfinvoke>
	
	<!--- check if editing from tree ---> 
	<nj:treeGetRelations 
		typename="#stOutput.typename#"
		objectId="#stOutput.objectid#"
		get="parents"
		r_lObjectIds="ParentID"
		bInclusive="1">
				
	<cfif len(parentId)>
		<!--- update tree --->
		<nj:updateTree objectId="#parentID#">
		
		<!--- reload overview page --->
		<cfoutput>
			<script language="JavaScript">
				parent['editFrame'].location.href = '#application.url.farcry#/edittabOverview.cfm?objectid=#stOutput.objectid#';
			</script>
		</cfoutput>
	<cfelse>
		<!--- return to generic admin --->
		<cflocation url="#application.url.farcry#/navajo/genericAdmin.cfm?#CGI.QUERY_STRING#&typename=#stOutput.typename#" addtoken="no">
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="No">
