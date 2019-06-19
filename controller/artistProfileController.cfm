<!--- This is used for mapping the artist profile related operation --->

<!---This is used for calling the method for artistProfileService component--->
<cfset application.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset method = #URL.action# />

<cfswitch expression = "#method#">

	<cfcase value = "uploadProfilePic">
		<cfset isInserted = application.artistprofileService.uploadProfilePic(form) />
	</cfcase>

	<cfcase value = "updateProfilePic">
		<cfset isInserted = application.artistprofileService.updateProfilePic(form) />

	</cfcase>

	<cfcase value = "getProfilePic">
		<cfset profilePicInfo = application.artistprofileService.getProfilePic() />
		<cfset jsondata =  SerializeJSON(profilePicInfo,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfilePicById">
		<cfset artistId = #URL.artistId# />
		<cfset profilePicInfo = application.artistprofileService.getPublicProfilePicById(artistId=#artistId#) />
		<cfset jsondata =  SerializeJSON(profilePicInfo,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistProfile">
		<cfset artistProfileData = application.artistprofileService.getArtistProfileByUserId() />
		<cfset jsondata =  SerializeJSON(artistProfileData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfile">
		<cfset artistId = #URL.id# />
		<cfset artistProfileData = application.artistprofileService.getPublicprofileInfo(artistId=#artistId#) />
		<cfset jsondata =  SerializeJSON(artistProfileData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "saveArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody ) />
		<cfset isInserted = application.artistprofileService.createArtistProfile(data) />
	</cfcase>

	<cfcase value = "deleteProfilePic">
		<cfset isInserted = application.artistprofileService.deleteprofilePic() />
	</cfcase>

	<cfcase value = "paginationForPublicPainting">
		<cfset offset = #URL.counter# />
		<cfset data = application.artistprofileService.getPublicPainting(offset=#offset#) />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "updateArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody )>
		<cfset isInserted = application.artistprofileService.updateArtistProfile(data) />
		<cfoutput>#isInserted#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistId">
		<cfset artistProfileData = application.artistprofileService.getArtistProfileIdByUserId() />
		<cfoutput>#artistProfileData#</cfoutput>
	</cfcase>

	<cfcase value = "getAllProfilePic">
		<cfset profilePicData = application.artistprofileService.getAllprofilePicInformation() />
		<cfset jsondata =  SerializeJSON(profilePicData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	 <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase>

</cfswitch>