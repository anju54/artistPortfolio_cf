<!--- This is used for mapping the painting type related operation --->
<cfset VARIABLES.paintingTypeService = CreateObject('component', 'component.painitngTypeService') />

<cfset VARIABLES.paintingTypeStruct = VARIABLES.paintingTypeService.getAllPaintings() />

<cfset paintingTypeStruct =  SerializeJSON(paintingTypeStruct,'struct')/>
	<cfoutput>#paintingTypeStruct#</cfoutput>
