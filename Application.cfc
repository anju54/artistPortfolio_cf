<!---
  --- Application
  --- -----------
  ---
  --- author: anjuk
  --- date:   5/22/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cfset this.name = 'artistPortfolioApp'>
	<cfset this.datasource = 'artistPortfolio' />
	<cfset this.sessionManagement  = true />
	<cfset this.sessionTimeout     = CreateTimeSpan(0, 5, 0, 0) />

	<!--- <cffunction name="onApplicationStart" returntype="boolean"> --->
<!--- 		<cfreturn true /> --->
<!--- 	</cffunction> --->

	<cffunction name="OnRequestStart">
	</cffunction>

</cfcomponent>