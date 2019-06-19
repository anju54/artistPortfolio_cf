<!---
  --- colorService
  --- ------------
  ---
  --- author: anjuk
  --- date:   6/6/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<!--- This is used to display all the colors stored in the database --->
	<cffunction name="getAllColors" returntype="query" access="public" displayname="getAllColors">
		<cfset var getAllColors = "" />

		<cfquery name="getAllColors" datasource="artistPortfolio">
			SELECT * FROM color;
		</cfquery>

	<cfreturn getAllColors>
	</cffunction>
</cfcomponent>