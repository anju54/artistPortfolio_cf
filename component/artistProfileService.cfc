<!---
  --- artistProfileService
  --- --------------------
  ---
  --- author: anjuk
  --- date:   5/28/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<!--- This is used to create artist profile basic information with painting type --->
	<cffunction name="createArtistProfile" displayname="createArtistProfile" access="public" output="false" returntype="Any">

		<cfargument name="form" type="any" required="true"/>
		<cfset var isInserted = false />

		<!--- Fetch email from session object --->
		<cfif StructKeyExists(session.stLoggedInuser,"fullName")>
			<cfset email = '#session.stLoggedInuser.userEmail#' />

			<!--- Fetch user_id from session object --->
			<cfset userId = "#session.user.userId#">

			<!--- insert artist profile record in artist_profile table --->
			<cfquery name = "addArtistProfiledata" datasource = 'artistPortfolio' result="result">

				insert into artist_profile (`profile_name`, `facebook_info`, `twitter_info`, `linkedIn_url`, `about_me`,
			 	`user_id`, `color_id`) VALUES (

					<cfqueryparam value="#arguments.form.profileName#"  cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.form.facebookUrl#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.form.twitterUrl#"  cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.form.linkedInUrl#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.form.aboutMe#"      cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#userId#" cfsqltype="cf_sql_integer"> ,

					( select color_id from color where color_name = <cfqueryparam value="#arguments.form.colorName#" cfsqltype="cf_sql_varchar"> )
				)
			</cfquery>

			<!--- get the primary key of the inserted record --->
			<cfset artistProfileId = result["GENERATEDKEY"] />

			<cfset size = ArrayLen("#arguments.form.paintingTypeList#") />
			<cfset paintingTypeList = "#arguments.form.paintingTypeList#" />

			<cfif not ArrayIsEmpty(arguments.form.paintingTypeList)>

				<!--- This is used to add list of painting type to database --->
				<cfquery name="addPaintingTypeForArtist" datasource="artistPortfolio">

					insert into artist_painting_list_bridge(artist_profile_id, painting_id) values
					<cfloop from = "1" to = "#size#" index = "i">
						 <cfif i NEQ 1>,</cfif>
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#artistProfileId#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">
						)

					</cfloop>

				</cfquery>
				<cfif #result.recordCount# GT 0>
					<cfset isInserted = true>
					<cfset fullPath = "../media/artist/" & form.profileName & "/" />
					<!--- create folder with the artist profile name inside media/artist/ folder --->
					<cfdirectory action="create" directory="#expandPath("#fullPath#")#">
					<!--- Create folder for storing thumbnail of images --->
					<cfset thumbPath = fullPath & "thumb" & "/" />
					<cfdirectory action="create" directory="#expandPath("#thumbPath#")#">
				</cfif>
			</cfif>

		</cfif>

		<cfreturn isInserted/>
	</cffunction>

	<!--- This is used to update artist profile information --->
	<cffunction name="updateArtistProfile" access="public" output="false">

		<cfargument name="form" type="any" required="true"/>
		<cfset isInserted = false />

		<cfset artistId = "#session.artistProfileId.artistProfileId#">
		<cfquery name="updateArtist" datasource="artistPortfolio" result="updateResult">

			update artist_profile set
			facebook_info = <cfqueryparam value="#arguments.form.facebookUrl#" cfsqltype="CF_SQL_VARCHAR"> ,
			twitter_info  = <cfqueryparam value="#arguments.form.twitterUrl#"   cfsqltype="CF_SQL_VARCHAR">  ,
			about_me      = <cfqueryparam value="#arguments.form.aboutMe#"          cfsqltype="CF_SQL_VARCHAR">,
			linkedIn_url  = <cfqueryparam value="#arguments.form.linkedInUrl#"  cfsqltype="CF_SQL_VARCHAR">,
			color_id      = ( select color_id from color where
			color_name    = <cfqueryparam value="#arguments.form.colorName#" cfsqltype="cf_sql_varchar"> )
			where artist_profile_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#"> ;
		</cfquery>

		<cfif not ArrayIsEmpty(arguments.form.paintingType)>

			<cfset size = ArrayLen(arguments.form.paintingType) />
			<cfset paintingTypeList = arguments.form.paintingType />
			<cfset artistId = "#session.artistProfileId.artistProfileId#">
			<!--- This is used to add list of painting type to database --->
			<cfloop from = "1" to = "#size#" index = "i">

				<cfquery name="updatePaintingTypeForArtist" datasource="artistPortfolio">

					update artist_painting_list_bridge set artist_profile_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">,
					painting_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">

				</cfquery>
			</cfloop>

		</cfif>
		<cfif #updateResult.recordCount# GT 0>
			<cfset isInserted = true>
		</cfif>
		<cfreturn isInserted/>
	</cffunction>

	<!--- This is used to get artist profile information by user_id --->
	<cffunction name="getArtistProfileByUserId" access="public" output="false" returntype="query">

		<!--- Fetch user_id from session object --->
		<cfset userId = "#session.user.userId#">

		<cfquery datasource="artistPortfolio" name="getArtistProfileByUserId">
				select ap.artist_profile_id,profile_name,facebook_info,twitter_info,linkedIn_url,about_me,
					pt.painting_name,pt.painting_type_id,c.color_name
					from artist_profile as ap left join artist_painting_list_bridge aplb
					on ap.artist_profile_id = aplb.artist_profile_id
                    left join painting_type pt on aplb.painting_id = pt.painting_type_id
                    left join color as c on c.color_id = ap.color_id
					where ap.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#userId#">
		</cfquery>

		<cfreturn getArtistProfileByUserId/>
	</cffunction>

	<!--- This is used to delete artist profile by artist_profile_id --->
	<cffunction name="deleteArtistProfileByid" access="public" output="false" returntype="boolean">

		<!--- Fetch user_id from session object --->
		<cfset artistId = "#session.artistProfileId.artistProfileId#">
		<cfset var flag = false>
		<cfquery name="deleteArtist" datasource="artistPortfolio">

			delete from artist_profile where artsit_profile_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
		</cfquery>

		<cfif deleteArtist.recordCount GT 0>
			<cfset var flag = true />
		</cfif>
		<cfreturn flag/>
	</cffunction>

	<cffunction name="getArtistProfileIdByUserId" access="public" output="true" returntype="numeric">

		<!--- Fetch user_id from session object --->
		<cfset userId = "#session.user.userId#">

		<cfquery datasource="artistPortfolio" name="getArtistProfileIdByUserId">
			select artist_profile_id, profile_name from artist_profile as ap inner join users as u on u.user_id = ap.user_id
			where u.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#userId#">
		</cfquery>

		<cfset session.artistProfileId = {'artistProfileId' = getArtistProfileIdByUserId.artist_profile_id,
											'profileName' = getArtistProfileIdByUserId.profile_name } />
		<cfreturn getArtistProfileIdByUserId.artist_profile_id />
	</cffunction>

	<cffunction name="getPublicPainting" access="public" output="false" returntype="Any">

		<cfargument name="offset" type="numeric" required="true" >

		<cfset artistId = "#session.artistProfileId.artistProfileId#">
		<cfset limitValue = 4 />

		<cfquery datasource="artistPortfolio" name="paginationForPublicPaintings">

			select filename , path_thumb,path,filename_original, media.media_id, is_public
			from media inner join
			artist_media_bridge as amb on media.media_id = amb.media_id
            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
			and amb.is_public = "true"
			limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#limitValue#">
		</cfquery>

		<cfreturn paginationForPublicPaintings>

	</cffunction>

	<!--- This is used to fetch all the profile pic present in the application --->
	<cffunction name="getAllprofilePicInformation" access="public" output="false" returntype="query">

		<cfquery name="getAllProfilePic" datasource="artistPortfolio">
			select filename_original, path,ap.artist_profile_id, users.first_name, users.last_name from media
			 inner join artist_profile ap
			on media.media_id = ap.profile_pic_id inner join users on users.user_id = ap.user_id
		</cfquery>

		<cfreturn getAllProfilePic/>
	</cffunction>

	<!--- This is used to get profile pic information --->
	<cffunction name="getProfilePic" access="public" output="false" returntype="query">

		<cfset artistId = "#session.artistProfileId.artistProfileId#">


		<cfquery name="selectProfilePic" datasource="artistPortfolio" result="profilePicResult">
			select filename_original , path from media inner join artist_profile ap on
			media.media_id = ap.profile_pic_id
        	where artist_profile_id =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
		</cfquery>

		<cfreturn selectProfilePic/>
	</cffunction>

	<!--- This is used to upload profile picture--->
	<cffunction name="uploadProfilePic" access="public" output="false" returntype="boolean">

		<cfargument name="form" type="any" required="true"/>
		<cfset var.flag = false />

		<cfif len(trim(form.fileUpload))>
		  <cffile action="upload"
		     fileField="fileUpload"
		     destination="#expandPath("../media/profile-pics/")#">

		</cfif>
		<!--- Fetch user_id from session object --->
		<cfset userId = "#session.user.userId#">

		<cfset fileName = userId & cffile.ATTEMPTEDSERVERFILE />
		<cfset destination = "../media/profile-pics/" & fileName />
		<cfset source = "../media/profile-pics/" & cffile.ATTEMPTEDSERVERFILE />

		<cffile
		action = "rename"
		destination = "#expandPath("#destination#")#"
		source = "#expandPath("#source#")#">

		<cfquery name="uploadImage" datasource="artistPortfolio" result="profilePicUpload">

			insert into media( filename_original, path ) values (

			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="/media/profile-pics/">

			)
		</cfquery>
		<!--- get the primary key of the inserted record --->
		<cfset profilePicId = profilePicUpload["GENERATEDKEY"] />

		<cfif #profilePicUpload.recordCount# gt 0>

			<cfset flag = true />
			<cfquery result="updateProfilePicId" datasource="artistPortfolio">
				update artist_profile set profile_pic_id =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#profilePicId#">
			</cfquery>
			<cfif #updateProfilePicId.recordCount# gt 0>
				<cfset flag = true />
				<cfelse>
					<cfset flag = false />
			</cfif>
		</cfif>

		<cfreturn flag/>
	</cffunction>

	<cffunction name="getPublicprofileInfo" access="public" output="true" returntype="Query">

		<cfargument name="artistId" required="true">
		<cfquery datasource="artistPortfolio" name="getPublicProfileInfo">
			select ap.artist_profile_id,profile_name,facebook_info,twitter_info,linkedIn_url,about_me,
					pt.painting_name,pt.painting_type_id,c.color_name,users.first_name,users.last_name,users.email_id
					from artist_profile as ap
                    left join artist_painting_list_bridge aplb
					on ap.artist_profile_id = aplb.artist_profile_id
                    left join painting_type pt on aplb.painting_id = pt.painting_type_id
                    left join color as c on c.color_id = ap.color_id
                    left join users on ap.user_id = users.user_id
					where ap.artist_profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
		</cfquery>
		<cfreturn getPublicprofileInfo />
	</cffunction>
</cfcomponent>