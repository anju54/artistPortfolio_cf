<!-- This is used for mapping the logout requests -->
<cfset application.authenticationService = CreateObject('component', 'component.authenticationService') />

<cfset userLoggedOut = application.authenticationService.doLogout() />
