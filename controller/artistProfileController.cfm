<!--- This is used for mapping the artist profile related operation --->

<!---This is used for calling the method for artistProfileService component--->
<cfset VARIABLES.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<cfset VARIABLES.method = URL.action />
<cfset VARIABLES.returnData = ""/>
<cfset VARIABLES.aErrMsg = ""/>

<cfswitch expression = "#method#">

	<cfcase value = "uploadProfilePic">

		<cfif StructKeyExists(session,"stLoggedInuser")>

			<cfset VARIABLES.aErrMsg = VARIABLES.artistprofileService.validateImage(form) />

			<cfif StructCount(aErrMsg) gt 0>
				<cfset VARIABLES.aErrMsg =  SerializeJSON(aErrMsg)/>
				<cfoutput>#aErrMsg#</cfoutput>
			<cfelse>
			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.uploadProfilePic(form) />
			<cfoutput>#returnData#</cfoutput>
			</cfif>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "updateProfilePic">

		<cfif StructKeyExists(session,"stLoggedInuser")>

			<cfset aErrMsg = VARIABLES.artistprofileService.validateImage(form) />

			<cfif StructCount(aErrMsg) gt 0>
				<cfset VARIABLES.aErrMsg =  SerializeJSON(aErrMsg)/>
				<cfoutput>#aErrMsg#</cfoutput>

			<cfelse>
			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.updateProfilePic(form) />
			<cfoutput>#returnData#</cfoutput>
			</cfif>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "getProfilePic">

		<cfif StructKeyExists(session,"stLoggedInuser")>

			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getProfilePic() />
			<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "getPublicProfilePicById">

		<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getPublicProfilePicById(artistId=URL.artistId) />
		<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "getArtistProfile">
		<cfif StructKeyExists(session,"stLoggedInuser")>

			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getArtistProfileByUserId() />
			<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "getPublicProfile">

		<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getPublicprofileInfo(artistId=URL.id) />
		<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "saveArtistProfile">
		<cfif StructKeyExists(session,"stLoggedInuser")>

			<cfset VARIABLES.data = toString( getHttpRequestData().content ) />
			<cfset VARIABLES.data = deserializeJSON( data ) />

			<cfset VARIABLES.aErrMsg = VARIABLES.artistprofileService.validationOfArtistdata(data) />

			<cfif StructCount(aErrMsg) gt 0>
				<cfset VARIABLES.aErrMsg =  SerializeJSON(aErrmsg)/>
				<cfoutput>#aErrMsg#</cfoutput>
			<cfelse>
				<cfset VARIABLES.returnData = VARIABLES.artistprofileService.createArtistProfile(data) />
				<cfoutput>#returnData#</cfoutput>
			</cfif>

		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "deleteProfilePic">
		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.deleteProfilePic() />
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "paginationForPublicPainting">
		<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getPublicPainting(offset=URL.counter,artistId=URL.id) />
		<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "updateArtistProfile">

		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset VARIABLES.requestBody = toString( getHttpRequestData().content ) />
			<cfset VARIABLES.data = deserializeJSON( requestBody )>

			<cfset VARIABLES.aErrMsg = VARIABLES.artistprofileService.validationOfArtistdata(data) />

			<cfif StructCount(aErrmsg) GT 0>
				<cfset VARIABLES.aErrMsg =  SerializeJSON(aErrmsg)/>
				<cfoutput>#aErrMsg#</cfoutput>
			<cfelse>
				<cfset VARIABLES.returnData = VARIABLES.artistprofileService.updateArtistProfile(data) />
				<cfoutput>#returnData#</cfoutput>
			</cfif>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "getArtistId">
		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getArtistProfileIdByUserId() />
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "getAllProfilePic">
		<cfset VARIABLES.profilePicData = VARIABLES.artistprofileService.getAllprofilePicInformation(offset=URL.offset) />
		<cfset VARIABLES.profilePicData =  SerializeJSON(profilePicData,'struct')/>
		<cfoutput>#profilePicData#</cfoutput>
	</cfcase>

	<cfcase value = "countOfProfilePic">
		<cfset VARIABLES.returnData = VARIABLES.artistprofileService.countOfProfilePic() />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

</cfswitch>