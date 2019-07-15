<!-- This is used for mapping the logout requests -->
<cfset VARIABLES.authenticationService = CreateObject('component', 'component.authenticationService') />

<cfset VARIABLES.userLoggedOut = VARIABLES.authenticationService.doLogout() />
