<!--- This is used to get current user information --->
<cfset VARIABLES.sessionValue = getSessionData() />
<cfset sessionValue =  SerializeJSON(sessionValue)/>
<cfoutput>#sessionValue#</cfoutput>

<!--- This is used to get session data for current user --->
<cffunction name="getSessiondata"  access="public" output="false" returnType="any">
<!--- <cfdump var="#session#"> --->

	<cfif StructKeyExists(session,"stLoggedInuser")>

		<cfset VAR data = '#session.stLoggedInuser#' />
		<cfreturn data>
	<cfelse>
		<cfreturn false/>
	</cfif>

</cffunction>
