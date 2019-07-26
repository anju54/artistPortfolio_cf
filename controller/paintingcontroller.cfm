<cfset VARIABLES.paintingService = CreateObject('component', 'component.paintingService') />

<cfset VARIABLES.method = URL.action />
<cfset VARIABLES.returnData = ""/>
<cfset VARIABLES.aErrMsg = ""/>

<cfswitch expression = "#method#">

	<cfcase value = "deletePainting">

		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset returnData = VARIABLES.paintingService.deletePainting(mediaId=URL.id) />  <!--- painting id --->
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "uploadpainting">

		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset aErrMsg = VARIABLES.paintingService.validateImage(form) />

			<cfif StructCount(aErrMsg) gt 0>
				<cfset VARIABLES.aErrMsg =  SerializeJSON(aErrMsg)/>
				<cfoutput>#aErrMsg#</cfoutput>
			<cfelse>
				<cfset VARIABLES.returnData = ( VARIABLES.paintingService.uploadPainting(form) ) />
				<cfoutput>#returnData#</cfoutput>
			</cfif>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "countPainting">
		<cfif StructKeyExists(session,"stLoggedInuser")>
			<cfset VARIABLES.returnData = VARIABLES.paintingService.countPainting() />
			<cfoutput>#returnData#</cfoutput>
		<cfelse>
			<cfset VARIABLES.returnData = "session expired"/>
			<cfoutput>#returnData#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "countPublicPainting">

		<cfset VARIABLES.returnData = VARIABLES.paintingService.countPublicPainting(artistId=URL.id) />
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "showPaintingByArtistId">
		<cfset VARIABLES.returnData = VARIABLES.paintingService.showAllPaintingByArtistId() />
		<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

	<cfcase value = "setIspublicOrprivate">
		<cfset VARIABLES.returnData = VARIABLES.paintingService.setIspublicOrprivate(mediaId=#URL.mediaId#,publicOrPrivate=URL.isPublic)/>
	</cfcase>

	<cfcase value = "paginationForAllPainting">
		<cfset VARIABLES.returnData = VARIABLES.paintingService.paginationForAllPainting(offset=URL.counter)/>
		<cfset VARIABLES.returnData =  SerializeJSON(returnData,'struct')/>
		<cfoutput>#returnData#</cfoutput>
	</cfcase>

</cfswitch>