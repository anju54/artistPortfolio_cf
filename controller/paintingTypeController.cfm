<!--- This is used for mapping the painting type related operation --->
<cfset variable.paintingTypeService = CreateObject('component', 'component.painitngTypeService') />

<cfset paintingTypeStruct = variable.paintingTypeService.getAllPaintings() />

<cfset jsondata =  SerializeJSON(paintingTypeStruct,'struct')/>
	<cfoutput>#jsondata#</cfoutput>
