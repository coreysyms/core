<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/packages/farcry/_versioning/approveEmail_draft_dd.cfm,v 1.17.4.1 2004/11/25 02:46:09 paul Exp $
$Author: paul $
$Date: 2004/11/25 02:46:09 $
$Name: milestone_2-2-1 $
$Revision: 1.17.4.1 $

|| DESCRIPTION || 
$Description: sends email for draft news like object $
$TODO: $

|| DEVELOPER ||
$Developer: Brendan Sisson (brendan@daemon.com.au) $

|| ATTRIBUTES ||
$in: $
$out:$
--->

<cfsetting enablecfoutputonly="Yes">

<cfimport taglib="/farcry/fourq/tags/" prefix="q4">

<!--- get object details --->
<q4:contentobjectget objectID="#arguments.objectID#" r_stObject="stObj">

<!--- get dmProfile object --->
<cfscript>
o_profile = createObject("component", application.types.dmProfile.typePath);
stProfile = o_profile.getProfile(userName=stObj.lastupdatedby);
</cfscript>

<!--- send email to lastupdater to let them know object is sent back to draft --->
<cfif stProfile.emailAddress neq "" AND stProfile.bReceiveEmail>

    <cfif isdefined("session.dmProfile.emailAddress") and session.dmProfile.emailAddress neq "">
        <cfset fromEmail = session.dmProfile.emailAddress>
    <cfelse>
        <cfset fromEmail = stProfile.emailAddress>
    </cfif>

<cfmail to="#stProfile.emailAddress#" from="#fromEmail#" subject="#application.config.general.sitetitle# - Object sent back to Draft">
Hi <cfif len(stProfile.firstName) gt 0>#stProfile.firstName#<cfelse>#stProfile.userName#</cfif>,

Your object "<cfif stObj.label neq "">#stObj.label#<cfelse>undefined</cfif>" has been sent back to draft.

<cfif arguments.comment neq "">
Comments added on status change:
#arguments.comment#
</cfif>

You may edit this page by browsing to the following location:

<cfif isDefined("arguments.approveURL")>
#urldecode(arguments.approveURL)#&objectID=#arguments.objectID#&status=draft
<cfelse>	
#application.config.general.adminServer##application.url.farcry#/index.cfm?section=dynamic&objectID=#arguments.objectID#&status=draft
</cfif>

</cfmail>

</cfif>

<cfsetting enablecfoutputonly="no">