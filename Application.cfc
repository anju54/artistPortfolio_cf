<!---
  --- Application
  --- -----------
  ---
  --- author: anjuk
  --- date:   5/22/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cfset this.name = 'artistPortfolioApp'>
	<cfset this.sessionManagement  = true />
	<cfset this.sessionTimeout     = CreateTimeSpan(0, 5, 0, 0) />

	<cffunction name="OnRequestStart">
	</cffunction>

</cfcomponent>