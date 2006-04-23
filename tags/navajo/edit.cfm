<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$ 

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/navajo/edit.cfm,v 1.22.2.1 2004/08/17 06:10:32 brendan Exp $
$Author: brendan $
$Date: 2004/08/17 06:10:32 $
$Name: milestone_2-2-1 $
$Revision: 1.22.2.1 $

|| DESCRIPTION || 
$Description: General edit conjurer template.$
$TODO: This legacy code needs to be revisited 
-- should have a more generic object invocation methodology GB$

|| DEVELOPER ||
$Developer: Brendan Sisson (brendan@daemon.com.au)$
$Developer: Paul Harrison (harrisonp@cbs.curtin.edu.au)$

|| ATTRIBUTES ||
$in: url.Objectid$
$out:$
--->
<cfsetting enablecfoutputonly="yes">
<cfinclude template="/farcry/farcry_core/admin/includes/utilityFunctions.cfm">
<cfinclude template="/farcry/farcry_core/admin/includes/cfFunctionWrappers.cfm">

<!--- enforce some validation --->
<cfparam name="url.objectid" type="uuid">
<cfparam name="url.typename" default="" type="string">

<cfscript>
	// Legacy support for old pages referring to URL.type
	if (isDefined("URL.type"))
		URL.typename = URL.type;
	// auto-type lookup if required
	if (NOT len(url.typename)) {
		q4 = createObject("component", "farcry.fourq.fourq");
		url.typename = q4.findType(objectid=url.objectid);
		//its possible that missing objects will kill this so we only want to create object if we actually get a typename result
		if (NOT len(url.typename))
			abort();
	}
</cfscript>

<!--- First check permissions --->
<cfscript>
	bHasPermission = request.dmsec.oAuthorisation.checkInheritedPermission(permissionName='edit',objectid=URL.objectid);
</cfscript>
<cfif NOT bHasPermission GTE 0>
	<h1>You do not have permission to edit this object</h1>
	<cfabort>
</cfif>

<!--- set up page header --->
<cfimport taglib="/farcry/farcry_core/tags/admin/" prefix="admin">
<admin:header>

<cfimport taglib="/farcry/fourq/tags/" prefix="q4">

<!--- work out package epath --->
<cfscript>
	oType = createObject("component", application.types[url.typename].typePath);
	stObj = oType.getData(objectid=url.objectid,dsn=application.dsn);
</cfscript>

<!--- delete underlying draft --->
<cfif isDefined("URL.deleteDraftObjectID")>
	<cfscript>
		//Delete the copied draft object containers
		oCon = createObject('component','#application.packagepath#.rules.container');
		oCon.delete(objectid="#URL.deleteDraftObjectID#");
		//Delete the copied draft object
		oType.deletedata(objectId="#URL.deleteDraftObjectID#");
		//Log this activity against live object
		oAuthentication = request.dmSec.oAuthentication;	
		stuser = oAuthentication.getUserAuthenticationData();
		application.factory.oaudit.logActivity(objectid="#url.objectid#",auditType="delete", username=StUser.userlogin, location=cgi.remote_host, note="Deleted Draft Object (#stObj.title#)");
	</cfscript>
	<!--- get parent for update tree --->
	<cf_getNavigation objectId="#url.ObjectId#" bInclusive="1" r_stObject="stNav" r_ObjectId="navIdSrcPerm">
	<!--- update tree --->
	<cf_updateTree objectId="#navIdSrcPerm#" complete=0>
	<!--- reload overview page --->
	<cfoutput>
		<script language="JavaScript">
			parent['editFrame'].location.href = '#application.url.farcry#/edittabOverview.cfm?objectid=#url.ObjectID#';
		</script>
	</cfoutput>
</cfif>
<!--- See if we can edit this object --->
<cfscript>
oVersioning = createObject("component","#application.packagepath#.farcry.versioning");
oLocking = createObject("component","#application.packagepath#.farcry.locking");
if (structKeyExists(stObj,"versionID") AND structKeyExists(stObj,"status"))
{			
	stRules = oVersioning.getVersioningRules(objectid=url.objectid);
	oVersioning.checkEdit(stRules=stRules,stObj=stObj);
}

if (structCount(stObj))
{
	checkForLockRet=oLocking.checkForLock(objectid=url.objectid);
	if (checkForLockRet.bSuccess)
	{
		lockRet = oLocking.lock(objectid=url.objectid,typename=url.typename);
		if (lockRet.bSuccess)
		{
			oType.edit(objectid=url.objectid);
		}
		else
		{
			dump(packagepath);
			abort();
		}
	}
	else if (not checkForLockRet.bSuccess and checkForLockRet.lockedBy eq "#session.dmSec.authentication.userlogin#_#session.dmSec.authentication.userDirectory#")	
	{
		oType.edit(objectid=url.objectid);
	}
	else
	{
		writeoutput(checkForLockRet.message);
		abort();
	}
}	
			
</cfscript>
	  
<admin:footer>

<cfsetting enablecfoutputonly="No">