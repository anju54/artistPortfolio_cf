<cfcomponent displayname="signupService">

	<!--- <cfargument name="form" type="any" required="true"/> --->

	<!---fetch role id from db by role name--->

	<!--- This is used for adding user to the system --->
	<cffunction name="addUser" access="public" returntype="boolean">

		<cfargument name="data" type="any" required="true"/>
		<cfset var isInserted = false />
		<cfset roleId = 1 />
		<cfset password = Hash(data.password) />

		<cfset row = checkForDuplicateEmailId("#data.email#")>
		<cfif row EQ 0>
			<!--- insert user record in users table --->
			<cfquery name = "addUser" result="addUserResult" datasource = 'artistPortfolio'>

				insert into users(first_name, last_name, email_id, password, role_id)
				values (
							<cfqueryparam value="#arguments.data.fname#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.data.lname#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.data.email#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#password#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#roleId#" cfsqltype="CF_SQL_INTEGER">
						)
			</cfquery>

			<cfif #addUserResult.recordCount# gt 0>
				<cfset var isInserted = true />
			<cfelse>
				<cfset var isInserted = false />
			</cfif>
		</cfif>

		<cfreturn isInserted/>
	</cffunction>


	<!--- This is used for validating the user input data --->
	<cffunction name="validateUser" access="public" output="false" returntype="Array">

		<cfargument name="data" type="any" required="true" />

		<cfset var aErrorMsg = ArrayNew(1) />
		<!--- validate the email --->
		<cfif NOT isValid('email', arguments.data.email)>
			<cfset arrayAppend(aErrorMsg, 'Please provide a valid email address')>
		</cfif>

		<!--- validate the fname --->
		<cfif arguments.data.fname EQ ''>
			<cfset arrayAppend(aErrorMsg, 'First name cant be empty')>
		</cfif>

		<!--- validate the password --->
		<cfif arguments.data.password EQ ''>
			<cfset arrayAppend(aErrorMsg, 'Please provide a password')>
		</cfif>
		<cfif NOT
		    ( len(arguments.data.password) GTE 6
		    AND refind('[A-Z]',arguments.data.password)
		    AND refind('[a-z]',arguments.data.password)
		    AND refind('[0-9]',arguments.data.password)
		    AND refind('[.!@##$&*]',arguments.data.password)
		     )>
			   <cfset arrayAppend(aErrorMsg, 'Wrong password ...! it should contain 6 to 20 characters which contain at least one numeric digit, one uppercase and one lowercase letter')>
	    </cfif>

		<cfreturn aErrorMsg/>
	</cffunction>

	<!--- This is used for handling duplicate email id data insertion in database --->
	<cffunction name="checkForDuplicateEmailId" returnType="numeric">

		<cfargument name="emailId" type="string" />

		<cfquery name="getUserId" datasource = 'artistPortfolio'>
			select count(*) as rowvalue from users where email_id = <cfqueryparam value="#arguments.emailId#" />;
		</cfquery>
		<cfreturn getUserId.rowvalue>
	</cffunction>

</cfcomponent>