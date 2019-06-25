<!--- controller for mapping user registration request --->

<!--- recieve data coming from UI --->
<cfset requestBody = toString( getHttpRequestData().content ) />
<cfif isJSON( requestBody )>

	<cfset data = deserializeJSON( requestBody )>
</cfif>

<cfset variables.signupService = CreateObject('component', 'component.signupService') />
<cfset aErrMsg = variables.signupService.validateuser(data) />

<cfif ArrayIsEmpty(aErrmsg)>

	<cfset isInserted = variables.signupService.addUser(data) />
	<cfset jsondata =  SerializeJSON(isInserted)/>
	<cfoutput>#jsondata#</cfoutput>
<cfelse>
	<cfset jsondata =  SerializeJSON(aErrmsg)/>
	<cfoutput>#jsondata#</cfoutput>
</cfif>
