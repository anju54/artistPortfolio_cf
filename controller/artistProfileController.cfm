<!--- This is used for mapping the artist profile related information --->

<!---This is used for calling the method for creating artist profile--->

<cfset application.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset method = #URL.action# />

<cfswitch expression = "#method#">

	<cfcase value = "uploadProfilePic">
		<cfset isInserted = application.artistprofileService.uploadProfilePic(form) />

	</cfcase>

	<cfcase value = "getProfilePic">
		<cfset profilePicInfo = application.artistprofileService.getProfilePic() />
		<cfset jsondata =  SerializeJSON(profilePicInfo,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistProfile">
		<cfset artistProfileData = application.artistprofileService.getArtistProfileByUserId() />
		<cfset jsondata =  SerializeJSON(artistProfileData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "saveArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody )>
		<cfset isInserted = application.artistprofileService.createArtistProfile(data) />

	</cfcase>

	<cfcase value = "updateArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody )>
		<cfset isInserted = application.artistprofileService.updateArtistProfile(data) />

	</cfcase>

	<cfcase value = "getArtistId">
		<cfset artistProfileData = application.artistprofileService.getArtistProfileIdByUserId() />
	</cfcase>

	 <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase>

</cfswitch>