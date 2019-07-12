<cfset VARIABLES.paintingService = CreateObject('component', 'component.paintingService') />

<cfset method = #URL.action# />
<cfset VARIABLES.returnData = ""/>
<cfset VARIABLES.aErrMsg = ""/>

<cfswitch expression = "#method#">

	<cfcase value = "deletePainting">
		<cfset returnData = VARIABLES.paintingService.deletePainting(mediaId=#URL.id#) />  <!--- painting id --->
	</cfcase>

	<cfcase value = "uploadpainting">
		<cfset aErrMsg = VARIABLES.paintingService.validateImage(form) />

		<cfif ArrayIsEmpty(aErrMsg)>
			<cfset returnData = SerializeJSON ( VARIABLES.paintingService.uploadPainting(form) ) />
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset aErrMsg =  SerializeJSON(aErrMsg)/>
			<cfoutput>#aErrMsg#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "countPainting">
		<cfset returnData = VARIABLES.paintingService.countPainting() />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "countPublicPainting">

		<cfset returnData = VARIABLES.paintingService.countPublicPainting(artistId=#URL.id#) />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "showPaintingByArtistId">
		<cfset returnData = VARIABLES.paintingService.showAllPaintingByArtistId() />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "setIspublicOrprivate">
		<cfset returnData = VARIABLES.paintingService.setIspublicOrprivate(mediaId=#URL.mediaId#,publicOrPrivate=#URL.isPublic#) />
	</cfcase>

	<cfcase value = "paginationForAllPainting">
		<cfset returnData = VARIABLES.paintingService.paginationForAllPainting(offset=#URL.counter#) />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "displayLastUploadedImage">

		<cfset returnData = VARIABLES.paintingService.displayLastUploadedImage() />
		<cfset returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

</cfswitch>