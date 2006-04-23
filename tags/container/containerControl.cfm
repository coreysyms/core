<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$ 

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/container/containerControl.cfm,v 1.5 2004/06/14 00:48:42 paul Exp $
$Author: paul $
$Date: 2004/06/14 00:48:42 $
$Name: milestone_2-2-1 $
$Revision: 1.5 $

|| DESCRIPTION || 
$Description: Edit widget for containers $
$TODO: $

|| DEVELOPER ||
$Developer: Paul Harrison (harrisonp@cbs.curtin.edu.au)$

|| ATTRIBUTES ||
$in: $
$out:$
--->

<cfparam name="attributes.objectID" default="">

<cfoutput>
<script>
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
  popUpWin.focus();
}
	
</script>

<style>
	.widget
	{
		color: ##333;
		background: ##ccc;
		text-decoration : none;
		font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
		font-weight : bold;
		font-size : 12px;
		border: 1px solid black;
		width:auto;
		height:auto;
		clear:both; 
		margin-left:2px;
		/*float:left;*/
	}
</style>
</cfoutput>
<cfoutput>
<cfset Attributes.label = reReplaceNoCase(attributes.label,"$*.*_","")>
<div class="widget">
	<a href="javascript:void(0)" onClick="popUpWindow('#application.url.farcry#/navajo/editContainer.cfm?containerID=#attributes.objectID#',100,200,600,600);"><img style="float:left; " border="0" src="#application.url.farcry#/images/treeImages/containeredit.gif" alt="Edit Container Content"></a><strong>&nbsp;Container Label : #attributes.label#</strong>
</div>	
</cfoutput>	






