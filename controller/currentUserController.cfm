
<cfset sessionValue = getSessionData() />
<cfset jsondata =  SerializeJSON(sessionValue)/>
<cfoutput>#jsondata#</cfoutput>

<!--- This is used to get session data for current user --->
<cffunction name="getSessiondata"  access="public" output="false" returnType="any">

	<cfif StructKeyExists(session.stLoggedInuser,"fullName")>

		<cfset data = '#session.stLoggedInuser#' />
		<cfreturn data>
	</cfif>

</cffunction>
