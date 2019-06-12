
<cfset variable.colorService = CreateObject('component', 'component.colorService') />

<cfset colorArray = variable.colorService.getAllColors() />

<cfset jsondata =  SerializeJSON(colorArray,'struct')/>
	<cfoutput>#jsondata#</cfoutput>
