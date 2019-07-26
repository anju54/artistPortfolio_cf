<!--- This is used for mapping the color related operation --->
<cfset VARIABLES.colorService = CreateObject('component', 'component.colorService') />

<cfset VARIABLES.colorArray = VARIABLES.colorService.getAllColors() />

<cfif StructKeyExists(session,"stLoggedInuser")>
	<cfset colorArray =  SerializeJSON(colorArray,'struct')/>
	<cfoutput>#colorArray#</cfoutput>
<cfelse>
		<cfset VARIABLES.returnData = "session expired"/>
		<cfoutput>#returnData#</cfoutput>
</cfif>
