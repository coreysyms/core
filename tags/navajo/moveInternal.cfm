<cfsetting enablecfoutputonly="Yes">
<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$ 

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/navajo/moveInternal.cfm,v 1.18 2003/12/08 05:43:06 paul Exp $
$Author: paul $
$Date: 2003/12/08 05:43:06 $
$Name: milestone_2-2-1 $
$Revision: 1.18 $

|| DESCRIPTION || 
$Description: $
$TODO: $

|| DEVELOPER ||
$Developer: Paul Harrison (harrisonp@cbs.curtin.edu.au)$
$Developer: Brendan Sisson (brendan@daemon.com.au)$

|| ATTRIBUTES ||
$in: url.objectId$
$in: url.direction$
$out:$
--->
<!--- set long timeout for template to prevent data-corruption on incomplete tree.moveBranch() --->
<cfsetting requesttimeout="90">

<cfimport taglib="/farcry/farcry_core/tags/navajo/" prefix="nj">
<cfimport taglib="/farcry/fourq/tags/" prefix="q4">
<cfinclude template="/farcry/farcry_core/admin/includes/cfFunctionWrappers.cfm">

<cfparam name="url.objectId">
<cfparam name="url.direction">

<q4:contentobjectget objectId="#url.objectId#" r_stObject="stobj">

<cfscript>
	typename = stObj.typename;
	oNav = createObject("component", application.types.dmNavigation.typePath);
	oAudit = createObject("component","#application.packagepath#.farcry.audit");
	oAuthentication = request.dmSec.oAuthentication;	
	stuser = oAuthentication.getUserAuthenticationData();
	if (stObj.typename IS 'dmNavigation')
	{
		qGetParent = request.factory.oTree.getParentID(objectID = stObj.objectID);
		parentObjectID = qGetParent.parentID;	
	}
	else
	{
		// likely to be a parent object with aObjects property (eg. dmHTML, dmNews)
		qGetParent = oNav.getParent(objectid=stObj.objectID);
		parentObjectID = qGetParent.objectID;
	}	
	//get permissions for this action
	//iState = request.dmsec.oAuthorisation.checkInheritedPermission(permissionName="Edit",objectid=parentobjectid,bThrowOnError=1);	
	iState = 1; //temp till i implement cfc dmsec
</cfscript>

<!--- get parent object --->
<q4:contentobjectget objectId="#parentObjectId#" r_stObject="stParentObject">

<!--- 
<cftry> --->
<!--- exclusive lock tree.moveBranch() to prevent corruption --->
<cflock name="moveBranchNTM" type="EXCLUSIVE" timeout="3" throwontimeout="Yes">

<cfscript>
	if (iState NEQ 1)
		writeoutput("<script>alert('You do not have permission to modify the node.');</script>");
	else		
	{
		if(len(parentObjectID))
		{
			if(stObj.typename IS "dmnavigation")
			{
				qGetChildren = request.factory.oTree.getChildren(dsn=application.dsn,objectid=parentObjectID);
				bottom = qGetChildren.recordCount;
				for(i=1;i LTE qGetChildren.recordCount;i = i + 1)
				{
					if (qGetChildren.objectid[i] IS stObj.objectID)
					{
						thisPosition = i;
						break;
					}
				}
				
				//get the new position
				if( url.direction is "up" AND thisPosition NEQ 1)
					newPosition = thisPosition - 1;
				else if( url.direction is "down" AND thisPosition LT bottom)
					newPosition = thisPosition + 1;
				else if ( url.direction is "top" )
					newPosition = 1;
				else if( url.direction eq "bottom" )	
					newPosition = bottom;
				//make the move	
				request.factory.oTree.moveBranch(dsn=application.dsn,objectid=stobj.objectid,parentid=parentobjectid,pos=newposition);	
				application.factory.oaudit.logActivity(objectid="#URL.objectid#",auditType="sitetree.movenode", username=StUser.userlogin, location=cgi.remote_host, note="object moved to child position #newposition#");
				updateTree(objectID =parentObjectID);
			}
			else		
			{
				
				key = "aObjectIds";
			
				// find the position of the object within the parent that we are moving 
				pos = ListFind(ArrayToList(stParentObject[key]), stobj.objectID);
			
				//  find the objects new position 
				if( url.direction EQ "up" AND pos NEQ 1)
				{
					newPos = pos - 1;
					arraySwap( stParentObject[key], pos, newPos );
				}
				else if( url.direction eq "down" AND (pos lt ArrayLen(stParentObject[key])) )
				{
					newPos = pos + 1;
					arraySwap( stParentObject[key], pos, newPos );
				}
				else if ( url.direction eq "top" )
				{
					newPos = 1;
					arrayDeleteAt( stParentObject[key], pos );
					arrayInsertAt( stParentObject[key], newPos, url.objectID );
				}
				else if( url.direction eq "bottom" )
				{
					newPos = ArrayLen(stParentObject[key]);
					arrayDeleteAt( stParentObject[key], pos );
					arrayAppend( stParentObject[key], url.objectID );
				}
				//update the object
				stParentObject.datetimecreated = createODBCDate("#datepart('yyyy',stParentObject.datetimecreated)#-#datepart('m',stParentObject.datetimecreated)#-#datepart('d',stParentObject.datetimecreated)#");
				stParentObject.datetimelastupdated = createODBCDate(now());
				oType = createobject("component", application.types[stParentObject.typename].typePath);
				oType.setData(stProperties=stParentObject,auditNote="object moved to child position #newpos#");	
				oaudit.logActivity(objectid="#URL.objectid#",auditType="sitetree.movenode", username=StUser.userlogin, location=cgi.remote_host, note="object moved to child position #newpos#");
				updateTree(objectID =parentObjectID);
			}
		}
	}	
</cfscript>

</cflock>
	<!--- <cfcatch>
		<h2>moveBranch Lockout</h2>
		<p>Another editor is currently modifying the hierarchy.  Please refresh the site overview tree and try again.</p>
		<cfabort>
	</cfcatch>
</cftry> --->


<cfsetting enablecfoutputonly="No">