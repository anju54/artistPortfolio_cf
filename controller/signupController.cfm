<!--- controller for mapping user registration request --->

<!--- recieve data coming from UI --->
<cfset requestBody = toString( getHttpRequestData().content ) />
<cfif isJSON( requestBody )>

	<cfset data = deserializeJSON( requestBody )>
</cfif>

<cfset application.signupService = CreateObject('component', 'component.signupService') />
<cfset aErrMsg = application.signupService.validateuser(data) />

<cfif ArrayIsEmpty(aErrmsg)>

	<cfset isInserted = application.signupService.addUser(data) />
	<cfset jsondata =  SerializeJSON(isInserted)/>
	<cfoutput>#jsondata#</cfoutput>
<cfelse>
	<cfset jsondata =  SerializeJSON(aErrmsg)/>
	<cfoutput>#jsondata#</cfoutput>
</cfif>
