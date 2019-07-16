<!--- This is used for mapping the artist profile related operation --->

<!---This is used for calling the method for artistProfileService component--->
<cfset VARIABLES.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset method = #URL.action# />
<cfset VARIABLES.returnData = ""/>
<cfset VARIABLES.aErrMsg = ""/>

<cfswitch expression = "#method#">

	<cfcase value = "uploadProfilePic">
		<cfset returnData = VARIABLES.artistprofileService.uploadProfilePic(form) />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "updateProfilePic">
		<cfset returnData = VARIABLES.artistprofileService.updateProfilePic(form) />
	</cfcase>

	<cfcase value = "getProfilePic">
		<cfset returnData = VARIABLES.artistprofileService.getProfilePic() />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfilePicById">

		<cfset returnData = VARIABLES.artistprofileService.getPublicProfilePicById(artistId=#URL.artistId#) />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistProfile">
		<cfset  returnData = VARIABLES.artistprofileService.getArtistProfileByUserId() />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "getPublicProfile">

		<cfset  returnData = VARIABLES.artistprofileService.getPublicprofileInfo(artistId=#URL.id#) />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "saveArtistProfile">
		<cfset data = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( data ) />

		<cfset aErrMsg = VARIABLES.artistprofileService.validationOfArtistdata(data) />

		<cfif StructCount(aErrMsg) gt 0>
			<cfset aErrMsg =  SerializeJSON(aErrmsg)/>
			<cfoutput>#aErrMsg#</cfoutput>
			<cfelse>
			<cfset returnData = VARIABLES.artistprofileService.createArtistProfile(data) />
			<cfoutput>#returnData#</cfoutput>

		</cfif>
	</cfcase>

	<cfcase value = "deleteProfilePic">
		<cfset returnData = VARIABLES.artistprofileService.deleteProfilePic() />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "paginationForPublicPainting">
		<cfset returnData = VARIABLES.artistprofileService.getPublicPainting(offset=#URL.counter#,artistId=#URL.id#) />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "updateArtistProfile">
		<cfset requestBody = toString( getHttpRequestData().content ) />
		<cfset data = deserializeJSON( requestBody )>

		<cfset aErrMsg = VARIABLES.artistprofileService.validationOfArtistdata(data) />

		<cfif StructCount(aErrmsg) GT 0>
			<cfset aErrMsg =  SerializeJSON(aErrmsg)/>
			<cfoutput>#aErrMsg#</cfoutput>
		<cfelse>
			<cfset returnData = VARIABLES.artistprofileService.updateArtistProfile(data) />
			<cfoutput>#returnData#</cfoutput>
		</cfif>

	</cfcase>

	<cfcase value = "getArtistId">
		<cfset returnData = VARIABLES.artistprofileService.getArtistProfileIdByUserId() />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "getAllProfilePic">
		<cfset VARIABLES.profilePicData = VARIABLES.artistprofileService.getAllprofilePicInformation(offset=#URL.offset#) />
		<cfset profilePicData =  SerializeJSON(profilePicData,'struct')/>
		<cfoutput>#profilePicData#</cfoutput>
	</cfcase>

	<cfcase value = "countOfProfilePic">
		<cfset returnData = VARIABLES.artistprofileService.countOfProfilePic() />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

</cfswitch>