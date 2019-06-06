<!--- <cfdump var="#session.stLoggedInuser#"> --->
<cfset sessionValue = getSessionData() />
<cfset jsondata =  SerializeJSON(sessionValue)/>
<cfoutput>#jsondata#</cfoutput>

<!--- This is used to get session data for current user --->
<cffunction name="getSessiondata"  access="public" output="false" returnType="any">

	<cfif StructKeyExists(session.stLoggedInuser,"fullName")>

		<cfset data = '#session.stLoggedInuser#' />

		<!--- <cfset sessionArr = ArrayNew(1)> --->
<!--- 		<cfset sessionArr[1] = data.fullName /> --->
<!--- 		<cfset sessionArr[2] = data.userEmail /> --->
<!--- 		<cfset sessionArr[3] = data.role /> --->

		<cfreturn data>
	</cfif>

</cffunction>


<!--- <cfset data = '#session.stLoggedInuser#' /> --->
<!--- <cfoutput>#data.fullName#</cfoutput> --->
<!--- <cfdump var="#data.fullName#"> --->