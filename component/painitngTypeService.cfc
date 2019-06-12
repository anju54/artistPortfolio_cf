<!---
  --- painitngTypeService
  --- -------------------
  ---
  --- author: anjuk
  --- date:   6/7/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cffunction name="getAllPaintings" displayname="getAllPaintings" access="public" output="false" returntype="query">

		<cfquery datasource="artistPortfolio" name="getAllPaintings">
			select * from painting_type;
		</cfquery>
		<cfreturn getAllPaintings />
	</cffunction>

</cfcomponent>