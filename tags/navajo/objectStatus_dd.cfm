<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$ 

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/navajo/objectStatus_dd.cfm,v 1.11 2003/04/30 07:15:18 andrewr Exp $
$Author: andrewr $
$Date: 2003/04/30 07:15:18 $
$Name: b131 $
$Revision: 1.11 $

|| DESCRIPTION || 
$Description: Changes the status of objects to approved/draft/pending. Intended for use with dynamic data pages $
$TODO: Fix date handling, for we have had to add a hack to convert custom date properties to ODBC$

|| DEVELOPER ||
$Developer: Unknown$

|| ATTRIBUTES ||
$in: url.Objectid$
$out:$
--->

<cfsetting enablecfoutputonly="Yes">
<cfimport taglib="/farcry/fourq/tags/" prefix="q4">
<cfimport taglib="/farcry/farcry_core/tags/navajo/" prefix="nj">

<cfparam name="attributes.lObjectIDs" default=""> <!---objects to have their status changed-required --->
<cfparam name="attributes.status" default=""> <!--- status to change to - required --->
<cfparam name="rMsg" default="msg"> <!--- The message returned to the caller - optional --->
<cfparam name="form.commentlog" default=""> <!--- hack --->

<cfloop index="attributes.objectID" list="#attributes.lObjectIDs#">
	<q4:contentobjectget objectId="#attributes.objectId#" r_stObject="stObj">
		<cfif not structkeyexists(stObj, "status")>
			<cfoutput>
			<script>
				 alert("This object type has no approval process attached to it.");
			</script>
			</cfoutput>
			<cfexit>
		</cfif>

		<cfif attributes.status eq "approved">
			<cfset status = "approved">
			<cfset permission = "approve">
			<cfset active = 1>

			<!--- send out emails informing object has been approved --->
			<cfinvoke component="#application.packagepath#.farcry.versioning" method="approveEmail_approved_dd">
				<cfinvokeargument name="objectId" value="#attributes.objectId#"/>
				<cfinvokeargument name="comment" value="#attributes.commentlog#"/>
			</cfinvoke>
		<cfelseif attributes.status eq "draft">
			<cfset status = 'draft'>
			<cfset permission = "approve">

			<!--- send out emails informing object is sent back to draft --->
			<cfinvoke component="#application.packagepath#.farcry.versioning" method="approveEmail_draft_dd">
				<cfinvokeargument name="objectId" value="#attributes.objectId#"/>
				<cfinvokeargument name="comment" value="#attributes.commentlog#"/>
			</cfinvoke>

			<cfset active = 0>
		<cfelseif attributes.status eq "requestApproval">
			<cfset status = "pending">
			<cfset permission = "requestApproval">
			<cfset active = 0>

			<!--- send out emails informing object needs approval --->
			<cfinvoke component="#application.packagepath#.farcry.versioning" method="approveEmail_pending_dd">
				<cfinvokeargument name="objectId" value="#attributes.objectId#"/>
				<cfinvokeargument name="comment" value="#attributes.commentlog#"/>
			</cfinvoke>
		<cfelse>
			<cfthrow errorcode="navajo" message="Unknown status passed">
		</cfif>

		<!--- update the structure data for object update --->
		<cfscript>
		stObj.datetimecreated = createODBCDateTime("#datepart('yyyy',stObj.datetimecreated)#-#datepart('m',stObj.datetimecreated)#-#datepart('d',stObj.datetimecreated)#");
		stObj.datetimelastupdated = now();
			
		if (structkeyexists(stObj, "expirydate")){
    		stObj.expirydate = createODBCDateTime("#datepart('yyyy',stObj.expirydate)#-#datepart('m',stObj.expirydate)#-#datepart('d',stObj.expirydate)#");
			stObj.publishdate = createODBCDateTime("#datepart('yyyy',stObj.publishdate)#-#datepart('m',stObj.publishdate)#-#datepart('d',stObj.publishdate)#");
		}

		//only if the comment log exists - do we actually append the entry
		if (isDefined("attributes.commentLog") AND attributes.commentLog neq "") {
			if (structkeyexists(stObj, "commentLog")){
				buildLog =  "#chr(13)##chr(10)##session.dmSec.authentication.canonicalName#" & "(#dateformat(now(),'dd/mm/yyyy')# #timeformat(now(), 'HH:mm:ss')#):#chr(13)##chr(10)#     Status changed: #stobj.status# -> #status##chr(13)##chr(10)# #attributes.commentLog#";
				stObj.commentLog = buildLog & "#chr(10)##chr(13)#" & stObj.commentLog;
			}
		}

		stObj.status = status;	
		</cfscript>
		
		<!--- HACK to allow Custom Objects that have extra dates to be converted to OBDC Date Time --->
		<cfloop collection="#stObj#" item="field">
			<cfif StructKeyExists(Evaluate("application.types."&stObj.typeName&".stProps"), field)>
				<cfif Evaluate("application.types."&stObj.typeName&".stProps."&field&".metaData.type") EQ "date">
					<cfset fieldName= "stObj."&field>
					<cfset fieldValue = Evaluate("stObj.#field#")>
					<cfset temp = setVariable(fieldName, CreateODBCDateTime(fieldValue))>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- work out if custom package or not --->
		<cfscript>
		if (application.types['#stObj.typename#'].bCustomType)
			thisPackagePath = "#application.custompackagepath#.types.#stObj.typename#";
		else
			thisPackagePath = "#application.packagepath#.types.#stObj.typename#";
		</cfscript>
		
		<q4:contentobjectdata objectid="#stObj.objectID#"
            typename="#thisPackagePath#"
            stProperties="#stObj#">		
		
	</cfloop>
	
	<cfset "caller.#attributes.rMsg#" = "#listLen(attributes.lObjectIds)# object(s) status changed"> 

<cfsetting enablecfoutputonly="No">
