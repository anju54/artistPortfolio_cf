<!--- This is used for mapping the artist profile related information --->

<!---This is used for calling the method for creating artist profile--->
<cfset requestBody = toString( getHttpRequestData().content ) />
<cfset data = deserializeJSON( requestBody )>

<cfset application.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset isInserted = application.artistprofileService.createArtistProfile(data) />
<cfdum<a href="../views/signin.html"></a>p var="#isInserted#">