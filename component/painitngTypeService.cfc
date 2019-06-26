<!---
  --- painitngTypeService is used to handle operation related to type of painting.
  --- -------------------
  ---
  --- author: anjuk
  --- date:   6/7/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<!--- This is used to display all the paintings stored in database --->
	<cffunction name="getAllPaintings" displayname="getAllPaintings" access="public" output="false" returntype="query">

		<cftry>
			<cfset var getAllPaintings = QueryNew("")/>

			<cfquery datasource="artistPortfolio" name="getAllPaintings">
				select * from painting_type;
			</cfquery>

		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingtypeService ,
					function:getAllPaintings, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>
		<cfreturn getAllPaintings />
	</cffunction>

</cfcomponent>