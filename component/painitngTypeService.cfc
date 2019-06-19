<!---
  --- painitngTypeService
  --- -------------------
  ---
  --- author: anjuk
  --- date:   6/7/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<!--- This is used to display all the paintings stored in database --->
	<cffunction name="getAllPaintings" displayname="getAllPaintings" access="public" output="false" returntype="query">

		<cfquery datasource="artistPortfolio" name="getAllPaintings">
			select * from painting_type;
		</cfquery>
		<cfreturn getAllPaintings />
	</cffunction>

</cfcomponent>