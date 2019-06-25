<!--- This is used for mapping the color related operation --->
<cfset variables.colorService = CreateObject('component', 'component.colorService') />

<cfset colorArray = variables.colorService.getAllColors() />

<cfset jsondata =  SerializeJSON(colorArray,'struct')/>
	<cfoutput>#jsondata#</cfoutput>
