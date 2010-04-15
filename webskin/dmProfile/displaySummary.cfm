<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Summary --->
<!--- @@description: Short profile summary for Webtop overview --->

<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<cfoutput>
	<dl id="profile" class="dl-style2">
		<dt>#application.rb.getResource("coapi.dmProfile.properties.name@label","Name")#</dt>
		<dd><cfif len(trim(stObj.firstname)) or len(stObj.lastName)>#stObj.firstName# #stObj.lastName#<cfelse>-</cfif></dd>
		<dt>#geti18Property("emailAddress")#</dt>
		<dd><cfif len(stObj.emailAddress)>#stObj.emailAddress#<cfelse>-</cfif></dd>
		<dt>#geti18Property("position")#</dt>
		<dd><cfif len(stObj.position)>#stObj.position#<cfelse>-</cfif></dd>
		<dt>#geti18Property("department")#</dt>
		<dd><cfif len(stObj.department)>#stObj.department#<cfelse>-</cfif></dd>
		<dt>#geti18Property("phone")#</dt>
		<dd><cfif len(stObj.phone)>#stObj.phone#<cfelse>-</cfif></dd>
		<dt>#geti18Property("fax")#</dt>
		<dd><cfif len(stObj.fax)>#stObj.fax#<cfelse>-</cfif></dd>
		<dt>#geti18Property("locale")#</dt>
		<dd><cfif len(stObj.locale)>#stObj.locale#<cfelse>-</cfif></dd>
		<skin:view typename="dmProfile" objectid="#stObj.objectid#" webskin="displaySummaryDetails#application.security.getCurrentUD()#" alternateHTML="" />
	</dl>
	
	<!--- link to edit profile and change password --->
	<h3>Your settings</h3>
	<ul class="webtop">
		<li>
			<small>
				<a href="#application.url.farcry#/conjuror/invocation.cfm?objectID=#session.dmProfile.objectID#&method=editOwn" target="content" title="#application.rb.getResource('coapi.dmProfile.general.editprofile@label','Edit your profile')#">#application.rb.getResource('coapi.dmProfile.general.editprofile@label','Edit your profile')#</a>
			</small>
		</li>
		<skin:view typename="dmProfile" objectid="#stObj.objectid#" webskin="displaySummaryOptions#application.security.getCurrentUD()#" alternateHTML="" />
	</ul>
</cfoutput>
		
<cfsetting enablecfoutputonly="false" />