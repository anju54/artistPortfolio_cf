<!--- <!--- --->
<!---   --- artistProfileService --->
<!---   --- -------------------- --->
<!---   --- --->
<!---   --- author: anjuk --->
<!---   --- date:   5/28/19 --->
<!---   ---> --->
<!--- <cfcomponent accessors="true" output="false" persistent="false"> --->

<!--- 	<!--- This is used to create artist profile basic information with painting type ---> --->
<!--- 	<cffunction name="createArtistProfile" displayname="createArtistProfile" access="public" output="false" returntype="Any"> --->

<!--- 		<cfargument name="data" type="any" required="true"/> --->
<!--- 		<cfset var isInserted = false /> --->

<!--- 		<!--- Fetch email from session object ---> --->
<!--- 		<cfif StructKeyExists(session.stLoggedInuser,"fullName")> --->
<!--- 			<cfset email = '#session.stLoggedInuser.userEmail#' /> --->

<!--- 			<!--- insert artist profile record in artist_profile table ---> --->
<!--- 			<cfquery name = "addArtistProfileData" datasource = 'artistPortfolio'> --->

<!--- 				insert into artist_profile (`profile_name`, `facebook_info`, `twitter_info`, `linkedIn_url`, `about_me`, --->
<!--- 			 	`user_id`, `color_id`) VALUES ( --->

<!--- 					<cfqueryparam value="#arguments.data.profileName#"  cfsqltype="CF_SQL_VARCHAR">, --->
<!--- 					<cfqueryparam value="#arguments.data.facebookInfo#" cfsqltype="CF_SQL_VARCHAR">, --->
<!--- 					<cfqueryparam value="#arguments.data.twitterInfo#"  cfsqltype="CF_SQL_VARCHAR">, --->
<!--- 					<cfqueryparam value="#arguments.data.linkedInInfo#" cfsqltype="CF_SQL_VARCHAR">, --->
<!--- 					<cfqueryparam value="#arguments.data.aboutMe#"      cfsqltype="CF_SQL_VARCHAR">, --->

<!--- 					( select user_id from users where users.email_id = <cfqueryparam value="#email#" cfsqltype="CF_SQL_varchar"> ), --->
<!--- 					( select color_id from color where color.color_name = <cfqueryparam value="#arguments.data.color#" cfsqltype="CF_SQL_varchar"> ) --->

<!--- 				) --->
<!--- 			</cfquery> --->

<!--- 			<cfif #addArtistProfileData.recordCount# EQ 1> --->
<!--- 				<cfset isInserted = true> --->
<!--- 			</cfif> --->
<!--- 		</cfif> --->

<!--- 		<cfreturn isInserted/> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="updateArtistProfile" access="public" output="false"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getArtistProfileById" access="public" output="false" returntype="Any"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="deleteArtistProfileByid" access="public" output="false" returntype="Any"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getListOfPaintingTypeByArtistProfileId" access="public" output="false" returntype="Array"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getArtistProfileByProfileName" access="public" output="false" returntype="Any"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getArtistPublicProfileInfo" access="public" output="false" returntype="Any"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getProfilePicByArtistProfileId" access="public" output="false" returntype="void"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- 	<cffunction name="getAllArtistId" access="public" output="false" returntype="Array"> --->
<!--- 		<!--- TODO: Implement Method ---> --->
<!--- 		<cfreturn /> --->
<!--- 	</cffunction> --->

<!--- </cfcomponent> --->