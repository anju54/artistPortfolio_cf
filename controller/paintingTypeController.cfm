
<cfset variable.paintingTypeService = CreateObject('component', 'component.painitngTypeService') />

<cfset paintingTypeStruct = variable.paintingTypeService.getAllPaintings() />

<cfset jsondata =  SerializeJSON(paintingTypeStruct,'struct')/>
	<cfoutput>#jsondata#</cfoutput>
