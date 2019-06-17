<cfset variables.paintingService = CreateObject('component', 'component.paintingService') />

<cfset method = #URL.action# />

<cfswitch expression = "#method#">

	<cfcase value = "uploadpainting">
		<cfset isInserted = variables.paintingService.uploadPainting(form) />
	</cfcase>

	<cfcase value = "showPaintingByArtistId">

		<cfset data = variables.paintingService.showAllPaintingByArtistId() />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>



	<cfcase value = "paginationForAllPainting">
		<cfset offset = #URL.counter# />
		<cfset data = variables.paintingService.paginationForAllPainting(offset=#offset#) />
		<cfset jsondata =  SerializeJSON(data,'struct')/>
		<cfoutput>#jsondata#</cfoutput>
	</cfcase>

	 <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase>

</cfswitch>