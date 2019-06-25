<!-- This is used for mapping the logout requests -->
<cfset variables.authenticationService = CreateObject('component', 'component.authenticationService') />

<cfset userLoggedOut = variables.authenticationService.doLogout() />
