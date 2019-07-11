<!--- This is used for mapping the artist profile related operation --->

<!---This is used for calling the method for artistProfileService component--->
<cfset variables.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset method = #URL.action# />

<cfswitch expression = "#method#">

	<cfcase value = "uploadProfilePic">
		<cfset isUploaded = variables.artistprofileService.uploadProfilePic(form) />
		<cfoutput>#isUploaded#</cfoutput>
	</cfcase>

	<cfcase value = "updateProfilePic">
		<cfset isInserted = variables.artistprofileService.updateProfilePic(form) />
	</cfcase>

	<cfcase value = "getProfilePic">
		<cfset profilePicInfo = variables.artistprofileService.getProfilePic() />
		<cfset jsondata =  SerializeJSON(profilePicInfo,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfilePicById">
		<cfset artistId = #URL.artistId# />
		<cfset profilePicInfo = variables.artistprofileService.getPublicProfilePicById(artistId=#artistId#) />
		<cfset jsondata =  SerializeJSON(profilePicInfo,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistProfile">
		<cfset artistProfileData = variables.artistprofileService.getArtistProfileByUserId() />
		<cfset jsondata =  SerializeJSON(artistProfileData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfile">
		<cfset artistId = #URL.id# />
		<cfset artistProfileData = variables.artistprofileService.getPublicprofileInfo(artistId=#artistId#) />
		<cfset jsondata =  SerializeJSON(artistProfileData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "saveArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody ) />

		<cfset aErrMsg = variables.artistprofileService.validationOfArtistdata(data) />

		<cfif StructCount(aErrMsg) gt 0>
			<cfset jsondata =  SerializeJSON(aErrmsg)/>
			<cfoutput>#jsondata#</cfoutput>
			<cfelse>
			<cfset isInserted = variables.artistprofileService.createArtistProfile(data) />
			<cfoutput>#isInserted#</cfoutput>

		</cfif>
	</cfcase>

	<cfcase value = "deleteProfilePic">
		<cfset isDeleted = variables.artistprofileService.deleteprofilePic() />
		<cfoutput>#isDeleted#</cfoutput>
	</cfcase>

	<cfcase value = "paginationForPublicPainting">
		<cfset offset = #URL.counter# />
		<cfset data = variables.artistprofileService.getPublicPainting(offset=#offset#,artistId=#URL.id#) />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "updateArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody )>

		<cfset aErrMsg = variables.artistprofileService.validationOfArtistdata(data) />

		<cfif StructCount(aErrmsg) GT 0>
			<cfset jsondata =  SerializeJSON(aErrmsg)/>
			<cfoutput>#jsondata#</cfoutput>
		<cfelse>
			<cfset isInserted = variables.artistprofileService.updateArtistProfile(data) />
			<cfoutput>#isInserted#</cfoutput>
		</cfif>

	</cfcase>

	<cfcase value = "getArtistId">
		<cfset artistProfileData = variables.artistprofileService.getArtistProfileIdByUserId() />
		<cfoutput>#artistProfileData#</cfoutput>
	</cfcase>

	<cfcase value = "getAllProfilePic">
		<cfset profilePicData = variables.artistprofileService.getAllprofilePicInformation(offset=#URL.offset#) />
		<cfset jsondata =  SerializeJSON(profilePicData,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "countOfProfilePic">
		<cfset count = variables.artistprofileService.countOfProfilePic() />
		<cfoutput>#count#</cfoutput>
	</cfcase>

</cfswitch>