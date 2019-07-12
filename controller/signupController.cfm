<!--- controller for mapping user registration request --->

<!--- recieve data coming from UI --->
<cfset VAR requestBody = toString( getHttpRequestData().content ) />
<cfif isJSON( requestBody )>

	<cfset requestBody = deserializeJSON( requestBody )>
</cfif>

<cfset VARIABLES.signupService = CreateObject('component', 'component.signupService') />
<cfset VAR aErrMsg = VARIABLES.signupService.validateuser(data) />

<cfif ArrayIsEmpty(aErrmsg)>

	<cfset VAR isInserted = VARIABLES.signupService.addUser(data) />
	<cfset isInserted =  SerializeJSON(isInserted)/>
	<cfoutput>#isInserted#</cfoutput>
<cfelse>
	<cfset aErrmsg =  SerializeJSON(aErrmsg)/>
	<cfoutput>#aErrmsg#</cfoutput>
</cfif>
