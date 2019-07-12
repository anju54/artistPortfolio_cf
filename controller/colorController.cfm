<!--- This is used for mapping the color related operation --->
<cfset VARIABLES.colorService = CreateObject('component', 'component.colorService') />

<cfset VARIABLES.colorArray = VARIABLES.colorService.getAllColors() />

<cfset colorArray =  SerializeJSON(colorArray,'struct')/>
<cfoutput>#colorArray#</cfoutput>
