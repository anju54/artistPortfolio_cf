<!--- This is used to map login request for any particular user --->
<cfset requestBody = toString( getHttpRequestData().content ) />
<cfset data = deserializeJSON( requestBody )>

<cfset VARIABLES.authenticationService = CreateObject('component', 'component.authenticationService') />
<cfset VARIABLES.aErrMsg = VARIABLES.authenticationService.validateuser(data.email,data.password)>

<cfset VARIABLES.isUserLoggedIn = ""/>

<cfif ArrayIsEmpty(aErrmsg)>
	<cfset isUserLoggedIn = VARIABLES.authenticationService.doLogin(data.email,data.password)>
	<cfset isUserLoggedIn =  SerializeJSON(isUserLoggedIn)/>
	<cfoutput>#isUserLoggedIn#</cfoutput>

	<cfelse>
		<cfset aErrmsg =  SerializeJSON(aErrmsg)/>
		<cfoutput>#aErrmsg#</cfoutput>
</cfif>

