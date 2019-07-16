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

		<cftry>
			<cfset VAR getAllColors = "" />
			<cfset VAR getAllColors = QueryNew("")/>

			<cfquery name="getAllColors" >
				SELECT * FROM color;
			</cfquery>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:colorService ,
					function:getAllColors, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>
	<cfreturn getAllColors>
	</cffunction>
</cfcomponent>