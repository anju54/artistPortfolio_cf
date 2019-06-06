<!--- This is used to map login request for any particular user --->
<cfset requestBody = toString( getHttpRequestData().content ) />
<cfset data = deserializeJSON( requestBody )>

<cfset application.authenticationService = CreateObject('component', 'component.authenticationService') />
<cfset aErrMsg = application.authenticationService.validateuser(data.email,data.password)>

<cfif ArrayIsEmpty(aErrmsg)>
	<cfset isUserLoggedIn = application.authenticationService.doLogin(data.email,data.password)>
	<cfset jsondata =  SerializeJSON(isUserLoggedIn)/>
	<cfoutput>#jsondata#</cfoutput>
</cfif>

<cfif Arraylen(aErrmsg) GT 0>
	<cfset jsondata =  SerializeJSON(aErrmsg)/>
	<cfoutput>#jsondata#</cfoutput>
</cfif>

<!--- <cfif StructIsEmpty(isUserLoggedIn)> --->
<!--- 	<cfset jsondata="Given credential are incorrect"> --->
<!--- 	<cfset jsondata =  SerializeJSON(isUserLoggedIn)/> --->
<!--- 	<cfoutput>#jsondata#</cfoutput> --->
<!--- </cfif> --->