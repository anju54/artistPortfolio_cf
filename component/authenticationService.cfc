<!---
  --- This is used to checking the login credentail and then allowing user to do login and logout
  --- --------------
  ---
  --- author: anjuk
  --- date:   5/24/19
  --->
<cfcomponent accessors="true" output="false" persistent="false" displayname="authenticationService">

	<!--- This is used for validating the user input data --->
	<cffunction name="validateUser" access="public" output="false" returntype="Array">

		<cfargument name="userEmail" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cftry>
			<cfset var aErrorMsg = ArrayNew(1) />
			<!--- validate the email --->
			<cfif NOT isValid('email', arguments.userEmail)>
				<cfset arrayAppend(aErrorMsg, 'Please provide a valid email address')>
			</cfif>

			<!--- validate the password --->
			<cfif arguments.userPassword EQ ''>
				<cfset arrayAppend(aErrorMsg, 'Please provide a password')>
			</cfif>
			<cfif NOT
			    ( len(arguments.userPassword) GTE 6
			    AND refind('[A-Z]',arguments.userPassword)
			    AND refind('[a-z]',arguments.userPassword)
			    AND refind('[0-9]',arguments.userPassword)
			    AND refind('[.!@##$&*]',arguments.userPassword)
			     )>
				   <cfset arrayAppend(aErrorMsg, 'Wrong password ...! it should contain 6 to 20 characters which contain at least one numeric digit, one uppercase and one lowercase letter')>
		    </cfif>

		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:authenticationService ,
					function:validateUser, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn aErrorMsg/>
	</cffunction>

	<!--- method to check whether the login credentials are correct--->
	<cffunction name="doLogin" access="public" output="false" returntype="any">

		<cfargument name="userEmail" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />

		<cfset var isUserLoggedIn = false />
		<cfset password = Hash(userPassword) />

		<cftry>

			<cfquery name="rsLoginUser" datasource = 'artistPortfolio'>
				select email_id,password,first_name,last_name ,role.role as role from users inner join role on users.role_id = role.role_id
				where email_id =  <cfqueryparam value="#arguments.userEmail#" cfsqltype="cf_sql_varchar" /> and
				password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar" />

			</cfquery>

			<cfif #rsLoginUser.RecordCount# EQ 1>

				<cfset fullName = rsLoginUser.first_name &' ' & rsLoginUser.last_name />
				<cfset session.stLoggedInuser = {'userEmail' = rsLoginUser.email_id, 'role' = rsLoginUser.role, 'fullName' = #fullName#} />

				<cfset userId = getUserId() />
				<cfset var isUserLoggedIn = true />
				<cfreturn session.stLoggedInuser />
			<cfelse>
				<cfset var isUserLoggedIn = false />
				<cfreturn isUserLoggedIn>
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:authenticationService ,
					function:doLogin, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>

	</cffunction>

	<!--- This is used for processing the logout requests --->
	<cffunction name="doLogout" access="public" output="false" returntype="void">

		<cfset structdelete(session, 'stLoggedInUser') />
		<cfset structdelete(session, 'user') /> artistProfileId
		<cfset structdelete(session, 'artistProfileId') />
		<cflogout />

	</cffunction>

	<!--- This is used to get current userId and then save it to session object --->
	<cffunction name="getUserId" access="public" output="false" returntype="numeric">

		<cftry>
			<!--- Fetch email from session object --->
			<cfif StructKeyExists(session.stLoggedInuser,"fullName")>
				<cfset email = '#session.stLoggedInuser.userEmail#' />

				<!--- This is used to get current user id --->
				<cfquery datasource="artistPortfolio" name="getUserIdQuery">
						select user_id from users where email_id = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar" > ;
				</cfquery>

				<cfset session.user = {'userId' = getUserIdQuery.user_id } />
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:authenticationService ,
					function:getUserId, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>
		<cfreturn getUserIdQuery.user_id/>
	</cffunction>

</cfcomponent>