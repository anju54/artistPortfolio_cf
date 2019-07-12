<!-- This is used for mapping the logout requests -->
<cfset VARIABLES.authenticationService = CreateObject('component', 'component.authenticationService') />

<cfset VAR userLoggedOut = VARIABLES.authenticationService.doLogout() />
