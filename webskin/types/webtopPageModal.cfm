<cfsetting enablecfoutputonly="true">
<!--- @@allowredirect: 0 --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="stParam.bodyInclude" default="">

<cfset request.fc.bShowTray = false />

<skin:view typename="dmHTML" webskin="webtopHeaderModal" />

<cfif not structKeyExists(url, "typename")>
	<cfset url.typename = url.type />
</cfif>
<!--- body --->
<cfif isValid("uuid", url.objectid)>
	<skin:view objectid="#url.objectid#" typename="#stObj.typename#" webskin="#url.bodyView#" />
<cfelseif structKeyExists(stParam, "bodyInclude") AND len(stParam.bodyInclude)>
	<cfmodule template="#stParam.bodyInclude#">
<cfelse>
	<skin:view typename="#url.typename#" webskin="#url.bodyView#" />
</cfif>

<skin:view typename="dmHTML" webskin="webtopFooterModal" />


<cfsetting enablecfoutputonly="false">