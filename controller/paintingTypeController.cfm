<!--- This is used for mapping the painting type related operation --->
<cfset variables.paintingTypeService = CreateObject('component', 'component.painitngTypeService') />

<cfset paintingTypeStruct = variables.paintingTypeService.getAllPaintings() />

<cfset jsondata =  SerializeJSON(paintingTypeStruct,'struct')/>
	<cfoutput>#jsondata#</cfoutput>
