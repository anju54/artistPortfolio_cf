<!--- controller for mapping user registration request --->

<!--- recieve data coming from UI --->
<cfset VARIABLES.requestBody = toString( getHttpRequestData().content ) />
<cfif isJSON( requestBody )>

	<cfset requestBody = deserializeJSON( requestBody )>
</cfif>

<cfset VARIABLES.signupService = CreateObject('component', 'component.signupService') />
<cfset VARIABLES.aErrMsg = VARIABLES.signupService.validateuser(requestBody) />

<cfif ArrayIsEmpty(aErrmsg)>

	<cfset VARIABLES.isInserted = VARIABLES.signupService.addUser(requestBody) />
	<cfset isInserted =  SerializeJSON(isInserted)/>
	<cfoutput>#isInserted#</cfoutput>
<cfelse>
	<cfset aErrmsg =  SerializeJSON(aErrmsg)/>
	<cfoutput>#aErrmsg#</cfoutput>
</cfif>
