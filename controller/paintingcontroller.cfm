<cfset variables.paintingService = CreateObject('component', 'component.paintingService') />

<cfset method = #URL.action# />

<cfswitch expression = "#method#">

	<cfcase value = "deletePainting">
		<cfset paintingId = #URL.id# />  <!--- painting id --->
		<cfset isDeleted = variables.paintingService.deletePainting(mediaId=#paintingId#) />
	</cfcase>

	<cfcase value = "uploadpainting">

		<cfset aErrMsg = variables.paintingService.validateImage(form) />
		<cfif ArrayIsEmpty(aErrmsg)>
			<cfset isUploaded = variables.paintingService.uploadPainting(form) />
			<cfset jsondata =  SerializeJSON(isUploaded)/>
			<cfoutput>#jsondata#</cfoutput>
		<cfelse>
			<cfset jsondata =  SerializeJSON(aErrmsg)/>
			<cfoutput>#jsondata#</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value = "countPainting">
		<cfset count = variables.paintingService.countPainting() />
		<cfoutput>#count#</cfoutput>
	</cfcase>

	<cfcase value = "showPaintingByArtistId">

		<cfset data = variables.paintingService.showAllPaintingByArtistId() />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "setIspublicOrprivate">

		<cfset data = variables.paintingService.setIspublicOrprivate(mediaId=#URL.mediaId#,publicOrPrivate=#URL.isPublic#) />
	</cfcase>

	<cfcase value = "paginationForAllPainting">
		<cfset offset = #URL.counter# />
		<cfset data = variables.paintingService.paginationForAllPainting(offset=#offset#) />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	<cfcase value = "displayLastUploadedImage">

		<cfset data = variables.paintingService.displayLastUploadedImage() />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	 <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase>

</cfswitch>