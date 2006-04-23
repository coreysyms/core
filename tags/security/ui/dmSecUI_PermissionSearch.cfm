<cfsetting enablecfoutputonly="Yes">
<!--- 
|| BEGIN FUSEDOC ||

|| Copyright ||
Daemon Pty Limited 1995-2001
http://www.daemon.com.au/

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/security/ui/dmSecUI_PermissionSearch.cfm,v 1.1 2003/04/08 08:52:20 paul Exp $
$Author: paul $
$Date: 2003/04/08 08:52:20 $
$Name: b131 $
$Revision: 1.1 $

|| DESCRIPTION || 
UI for listing for permissions.

|| USAGE ||

|| DEVELOPER ||
Matt Dawson (mad@daemon.com.au)

|| ATTRIBUTES ||

|| HISTORY ||
$Log: dmSecUI_PermissionSearch.cfm,v $
Revision 1.1  2003/04/08 08:52:20  paul
CFC security updates

Revision 1.2  2002/09/12 01:15:47  geoff
no message

Revision 1.1.1.1  2002/08/22 07:18:17  geoff
no message

Revision 1.1  2001/11/18 16:15:22  matson
moved all files to custom tags daemon_security/UI (dmSecUI)

Revision 1.2  2001/11/12 10:54:47  matson
massive update here. navajo is now base install

Revision 1.1.1.1  2001/10/29 15:04:22  matson
no message

Revision 1.1.1.1  2001/09/26 22:02:02  matson
no message


|| END FUSEDOC ||
--->

<cfoutput><span class="formtitle">Permissions</span><p></p></cfoutput>

<!--- User directory selection --->
<cfscript>
	oAuthorisation = request.dmsec.oAuthorisation;
	oAuthentication = request.dmsec.oAuthentication;
	
	stPolicyStore = oAuthorisation.getPolicyStore();
	aPermissions = oAuthorisation.getAllPermissions();
	
</cfscript>
<cfset lastType="">

<cfoutput>
<table cellpadding="5" cellspacing="0" border="1" style="margin-left:30px;">
	<tr class="dataheader">
		<td>Type</td>
		<td>Name</td>
		<td>Notes</td>
</tr>
</cfoutput>

<cfloop index="i" from="1" to="#ArrayLen(aPermissions)#">
<cfoutput>
	<cfif lastType neq aPermissions[i].PermissionType>
		<cfset lastType = aPermissions[i].PermissionType>
		
		<tr class="#IIF(i MOD 2, de("dataOddRow"), de("dataEvenRow"))#">
			<td>#aPermissions[i].PermissionType#</td>
	<cfelse>
		<tr>
			<td>&nbsp;</td>
	</cfif>

	<td><a href="?tag=PermissionCreateEdit&PermissionId=#aPermissions[i].PermissionId#">#aPermissions[i].PermissionName#</a></td>
	<td><cfif aPermissions[i].PermissionNotes neq "">#aPermissions[i].PermissionNotes#<cfelse><em>n/a</em></cfif></td>
	
</tr>
</cfoutput>
</cfloop>
	
<cfoutput>
</table>
<p></p>
<span class="frameMenuBullet" style="margin-left:30px;">&raquo;</span> <a href="?tag=PermissionExport">Export Permissions</a>&nbsp;&nbsp;&nbsp;
<span class="frameMenuBullet">&raquo;</span> <a href="?tag=PermissionImport">Import Permissions</a><p></p>
</cfoutput>

<cfsetting enablecfoutputonly="No">