<!---
  --- artistProfileService
  --- This is used to handle operation related to artist profile page
  --- --------------------
  ---
  --- author: anjuk
  --- date:   5/28/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cfset VARIABLES.arrayOfErr = StructNew()/>  <!--- used for storing the error msg related to artist add and update --->

	<!--- This is used to create artist profile basic information with painting type --->
	<cffunction name="createArtistProfile" displayname="createArtistProfile" access="public" output="false" returntype="boolean">

		<cfargument name="form" type="struct" required="true"/>
		<cftry>
			<cfset var isInserted = false />

			<!--- Fetch email from session object --->
			<cfif StructKeyExists(session.stLoggedInuser,"fullName")>

				<!--- insert artist profile record in artist_profile table --->
				<cfquery name = "addArtistProfiledata" datasource = "artistPortfolio" result="result">

					insert into artist_profile ( profile_name, facebook_info, twitter_info, linkedIn_url, about_me,
				 	user_id, color_id) values (

						<cfqueryparam value="#arguments.form.profileName#"  cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.form.facebookUrl#"  cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.form.twitterUrl#"   cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.form.linkedInUrl#"  cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.form.aboutMe#"      cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#session.user.userId#"      cfsqltype="CF_SQL_INTEGER"> ,
						( select color_id from color where color_name =
							<cfqueryparam value="#arguments.form.colorName#"   cfsqltype="CF_SQL_VARCHAR">
							)
					)
				</cfquery>

				<!--- get the primary key of the inserted record --->
				<!--- <cfset variables.artistProfileId = result["GENERATEDKEY"] /> --->

				<!--- <cfset var size = ArrayLen("#arguments.form.paintingTypeList#") /> --->
				<cfset var paintingTypeList = "#arguments.form.paintingTypeList#" />

				<cfif not ArrayIsEmpty(arguments.form.paintingTypeList)>

					<!--- This is used to add list of painting type to database --->
					<cfquery name="addPaintingTypeForArtist" datasource="artistPortfolio">

						insert into artist_painting_list_bridge(artist_profile_id, painting_id) values
						<cfloop from = "1" to = "#size#" index = "i">
							 <cfif i NEQ 1>,</cfif>
							(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#result["GENERATEDKEY"]#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">
							)

						</cfloop>

					</cfquery>
				</cfif>

					<cfif #result.recordCount# GT 0>

						<cfset var isInserted = true>
						<cfset var fullPath = "../media/artist/" & arguments.form.profileName & "/" />

						<!--- create folder with the artist profile name inside media/artist/ folder --->
						<cfdirectory action="create" directory="#expandPath("#fullPath#")#">

						<!--- Create folder for storing thumbnail of images --->
						<cfset thumbPath = fullPath & "thumb" & "/" />
						<cfdirectory action="create" directory="#expandPath("#thumbPath#")#">
					</cfif>
				</cfif>

		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:createArtistProfile, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn isInserted/>
	</cffunction>

	<!--- This is used to update artist profile information --->
	<cffunction name="updateArtistProfile" access="public" output="false">

		<cfargument name="form" type="any" required="true"/>
		<cftry>
			<cfset var isInserted = false />

			<!--- <cfset variables.artistId = "#session.artistProfile.artistProfileId#"> --->
			<cfquery name="updateArtist" datasource="artistPortfolio" result="updateResult">

				update artist_profile set
				facebook_info = <cfqueryparam value="#arguments.form.facebookUrl#" cfsqltype="CF_SQL_VARCHAR"> ,
				twitter_info  = <cfqueryparam value="#arguments.form.twitterUrl#"   cfsqltype="CF_SQL_VARCHAR">  ,
				about_me      = <cfqueryparam value="#arguments.form.aboutMe#"          cfsqltype="CF_SQL_VARCHAR">,
				linkedIn_url  = <cfqueryparam value="#arguments.form.linkedInUrl#"  cfsqltype="CF_SQL_VARCHAR">,
				color_id      = ( select color_id from color where
				color_name    = <cfqueryparam value="#arguments.form.colorName#" cfsqltype="cf_sql_varchar"> )
				where artist_profile_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
			</cfquery>

			<cfset var paintingTypeList = #arguments.form.paintingTypeList# />

			<cfquery datasource="artistPortfolio" name="deleteExistingPaintingType" result="deleteExistingPaintingTypeResult">

				delete from  artist_painting_list_bridge where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
			</cfquery>

			<cfif not ArrayIsEmpty(arguments.form.paintingTypeList)>

				<!--- This is used to add list of painting type to database --->
				<cfquery name="addPaintingTypeForArtist" datasource="artistPortfolio">

					insert into artist_painting_list_bridge(artist_profile_id, painting_id) values
					<cfloop from = "1" to = "#ArrayLen("#arguments.form.paintingTypeList#")#" index = "i">
						 <cfif i NEQ 1>,</cfif>
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">
						)

					</cfloop>

				</cfquery>
			</cfif>

			<cfif #updateResult.recordCount# GT 0>
				<cfset var isInserted = true>
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:updateArtistProfile, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn isInserted/>
	</cffunction>

	<!--- This is used to get artist profile information by user_id --->
	<cffunction name="getArtistProfileByUserId" access="public" output="false" returntype="query">

		<cfset var getArtistProfileByUserId = QueryNew("")/>
		<cftry>

			<cfquery datasource="artistPortfolio" name="getArtistProfileByUserId">
					select ap.artist_profile_id,profile_name,facebook_info,twitter_info,linkedIn_url,about_me,
						pt.painting_name,pt.painting_type_id,c.color_name,ap.profile_pic_id
						from artist_profile as ap left join artist_painting_list_bridge aplb
						on ap.artist_profile_id = aplb.artist_profile_id
	                    left join painting_type pt on aplb.painting_id = pt.painting_type_id
	                    left join color as c on c.color_id = ap.color_id
						where ap.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.userId#">
			</cfquery>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getArtistProfileByUserId, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn getArtistProfileByUserId/>
	</cffunction>

	<!--- This is used to delete artist profile by artist_profile_id --->
	<cffunction name="deleteArtistProfileByid" access="public" output="false" returntype="boolean">

		<cftry>
			<!--- Fetch user_id from session object --->
			<cfset variables.artistId = "#session.artistProfile.artistProfileId#">
			<cfset var flag = false>
			<cfquery name="deleteArtist" datasource="artistPortfolio">

				delete from artist_profile where artsit_profile_id =
							<cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
			</cfquery>

			<cfif deleteArtist.recordCount GT 0>
				<cfset var flag = true />
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:deleteArtistProfileByid, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn flag/>
	</cffunction>

	<cffunction name="getArtistProfileIdByUserId" access="public" output="true" returntype="numeric">

		<cftry>
			<cfquery datasource="artistPortfolio" name="getArtistProfileIdByUserId">
				select artist_profile_id, profile_name from artist_profile as ap inner join users as u on u.user_id = ap.user_id
				where u.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.userId#">
			</cfquery>

			<cfif getArtistProfileIdByUserId.RecordCount gt 0>

				<cfset session.artistProfile = {'artistProfileId' = getArtistProfileIdByUserId.artist_profile_id,
												'profileName' = getArtistProfileIdByUserId.profile_name } />
			</cfif>

		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getArtistProfileIdByUserId, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>
		<cfif getArtistProfileIdByUserId.artist_profile_id Eq "">
			<cfreturn 0/>
		<cfelse>
			<cfreturn getArtistProfileIdByUserId.artist_profile_id />
		</cfif>

	</cffunction>

	<!--- This is used to get artist public paintings --->
	<cffunction name="getPublicPainting" access="public" output="false" returntype="query">

		<cfargument name="offset" type="numeric" required="true" >
		<cfargument name="artistId" type="numeric" required="true">

		<cfset var paginationForPublicPaintings = QueryNew("")/>
		<cftry>
			<cfset var limitValue = 4 />

			<cfquery datasource="artistPortfolio" name="paginationForPublicPaintings">

				select filename , path_thumb,path,filename_original, media.media_id, is_public
				from media inner join
				artist_media_bridge as amb on media.media_id = amb.media_id
	            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
				and amb.is_public = "true"
				limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#limitValue#">
			</cfquery>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getPublicPainting, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn paginationForPublicPaintings/>

	</cffunction>

	<!--- This is used to fetch all the profile pic present in the application --->
	<cffunction name="getAllprofilePicInformation" access="public" output="false" returntype="query">

		<cfargument name="offset" type="numeric" required="true" >
		<cfset var getAllProfilePic = QueryNew("")/>
		<cftry>
			<cfquery name="getAllProfilePic" datasource="artistPortfolio">
				select filename_original, path,ap.artist_profile_id, users.first_name, users.last_name from media
				 right join artist_profile ap
				on media.media_id = ap.profile_pic_id inner join users on users.user_id = ap.user_id
				limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,8;
			</cfquery>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getPublicPainting, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn  getAllProfilePic/>
	</cffunction>

	<!--- This is used to get profile pic information --->
	<cffunction name="getProfilePic" access="public" output="false" returntype="query">

		<cfset var selectProfilePic = QueryNew("") />
		<cftry>
			<cfquery name="selectProfilePic" datasource="artistPortfolio" result="profilePicResult">

				select filename_original , path from media inner join artist_profile ap on
				media.media_id = ap.profile_pic_id
	        	where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
			</cfquery>

		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getProfilePic, Line:#cfcatch.TagContext[1].Line#">
		</cfcatch>
		</cftry>

		<cfreturn selectProfilePic/>
	</cffunction>

	<!--- This is used to get profile pic information --->
	<cffunction name="getPublicProfilePicById" access="public" output="false" returntype="query">

		<cfargument name="artistId" required="true" type="numeric">
		<cfset var selectProfilePic = QueryNew("")/>
			<cftry>
			<cfquery name="selectProfilePic" datasource="artistPortfolio" result="profilePicResult">
				select filename_original , path from media inner join artist_profile ap on
				media.media_id = ap.profile_pic_id
	        	where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
			</cfquery>
			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
				text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
						function:getPublicProfilePicById, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn  selectProfilePic/>
	</cffunction>

	<!--- This is used to upload profile picture--->
	<cffunction name="uploadProfilePic" access="public" output="false" returntype="boolean">

		<cfargument name="form" type="any" required="true"/>
		<cftry>
			<cfset var flag = false />

			<cfif len(trim(form.fileUpload))>
			  <cffile action="upload"
			     fileField="fileUpload"
			     destination="#expandPath("../media/profile-pics/")#">

			</cfif>

			<cfset fileName = session.user.userId & cffile.ATTEMPTEDSERVERFILE />
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
			<!--- <cfset var profilePicId = profilePicUpload["GENERATEDKEY"] /> --->

			<cfset getArtistProfileIdByUserId() />

			<cfif #profilePicUpload.recordCount# gt 0>

				<cfset var flag = true />
				<cfquery result="updateProfilePicId" datasource="artistPortfolio">
					update artist_profile set profile_pic_id =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#profilePicUpload["GENERATEDKEY"]#">
					where artist_profile_id =
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
				</cfquery>

				<cfif #updateProfilePicId.recordCount# gt 0>
					<cfset var flag = true />
					<cfelse>
						<cfset var flag = false />
				</cfif>
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:uploadProfilePic, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn  flag/>
	</cffunction>

	<!--- This is used to delete profile pic --->
	<cffunction name="deleteprofilePic" access="public" output="true" returntype="boolean">

		<cftry>
			<cfset var flag = true />

			<cfquery datasource="artistPortfolio" name="getProfilePicId">

				select profile_pic_id from artist_profile where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
			</cfquery>

			<cfif not  #getProfilePicId.profile_pic_id# eq 0>

				<cfquery datasource="artistPortfolio" result="deleteProfilePic">
					update artist_profile set profile_pic_id = null where artist_profile_id =
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
				</cfquery>

			</cfif>

			<cfif #deleteProfilePic.recordCount# gt 0>

				<cfquery datasource="artistPortfolio" result="deleteFromArtist">
					delete from media where media_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#getProfilePicId.profile_pic_id#"> ;

				</cfquery>
			</cfif>

			<cfif #deleteFromArtist.recordCount# gt 0>
				<cfset var flag = false />
			</cfif>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:deleteprofilePic, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn  flag />
	</cffunction>

	<!--- This is used to get artist public profile page data --->
	<cffunction name="getPublicprofileInfo" access="public" output="true" returntype="Query">

		<cfargument name="artistId" required="true">
		<cfset var getPublicProfileInfo = QueryNew("")/>
		<cftry>
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
		<cfcatch type="any" >
		<cflog application="true" file="artistPortfolioError"
		text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
				function:getPublicprofileInfo, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn getPublicprofileInfo />
	</cffunction>

	<!--- This is used for updating artist profile picture --->
	<cffunction name="updateProfilePic"  access="public" returntype="boolean">

		<cfargument name="form" type="struct" required="true"/>
		<cftry>
			<cfset var isUpdated = false />

			<cfif len(trim(form.fileUpload))>
			  <cffile action="upload"
			     fileField="fileUpload"
			     destination="#expandPath("../media/profile-pics/")#">

			</cfif>
			<!--- Fetch user_id from session object --->
			<!--- <cfset variables.userId = "#session.user.userId#"> --->

			<cfset var fileName = session.artistProfile.artistProfileId & cffile.ATTEMPTEDSERVERFILE />
			<cfset var destination = "../media/profile-pics/" & fileName />
			<cfset var source = "../media/profile-pics/" & cffile.ATTEMPTEDSERVERFILE />

			<cffile
			action = "rename"
			destination = "#expandPath("#destination#")#"
			source = "#expandPath("#source#")#">

			<cfquery datasource="artistPortfolio" name="updateProfilePic" result="updateProfilePicResult">

				update media set filename_original =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#"> where media_id =
				( select profile_pic_id from artist_profile where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">  )
			</cfquery>

			<cfif updateProfilePicResult.recordCount Gt 0>
				<cfset var isUpdated = true />
			</cfif>
		<cfcatch type="any" >
		<cflog application="true" file="artistPortfolioError"
		text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
				function:updateProfilePic, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn  isUpdated />
	</cffunction>

	<cffunction access="public" name="countOfProfilePic" returntype="numeric">

		<cfset var countOfProfilePic = 0 />

		<cfquery name="getCountOfprofilePic" datasource="artistPortfolio">
			select count(*) as countOfProfilePic from media
				 right join artist_profile ap
				on media.media_id = ap.profile_pic_id inner join users on users.user_id = ap.user_id;
		</cfquery>

		<cfreturn getCountOfprofilePic.countOfProfilePic />
	</cffunction>

	<!--- This is used for validating artist profile data --->
	<cffunction access="public" name="validationOfArtistdata" returntype="Struct">

		<cfargument name="form" type="struct" required="true"/>

		<cfset checkForColor(field="color",data=#arguments.form.colorName#)>
		<cfset checkForLength(field="twitter",data=#arguments.form.twitterUrl#)/>
		<cfset checkForLength(field="linkedInUrl",data=#arguments.form.linkedInUrl#)/>
		<cfset checkForLength(field="facebookUrl",data=#arguments.form.facebookUrl#)/>
		<cfset checkForLength(field="aboutMe",data=#arguments.form.aboutMe#)/>
		<cfset checkForDuplicateProfileName(profileName=#arguments.form.profileName#)/>
		<cfset checkForPatternValidation(field="twitter",data=#arguments.form.twitterUrl#)/>
		<cfset checkForPatternValidation(field="linkedInUrl",data=#arguments.form.linkedInUrl#)/>
		<cfset checkForPatternValidation(field="facebookUrl",data=#arguments.form.facebookUrl#)/>

		<cfreturn VARIABLES.arrayOfErr/>

	</cffunction>

	<!--- This is used for validating optional color field --->
	<cffunction access="public" name="checkForColor" returntype="void">

		<cfargument name="data" type="string" required="true"/>

		<cfif not StructKeyExists(session,"artistProfile")>
			<cfif arguments.data EQ "" OR arguments.data EQ "Select">
				<cfset arrayOfErr.colorerror = "Please select any color for your profile!!" />
			</cfif>
		</cfif>

	</cffunction>

	<!--- This is used to validate pattern for facebook,twitter,linkedin --->
	<cffunction access="public" name="checkForPatternValidation" returntype="void">

		<cfargument name="field" type="string" required="true"/>
		<cfargument name="data" type="string" required="true"/>

		<cfif compareNoCase(field,"facebookUrl") eq 0>

				<cfset var result = REMatchNoCase("(?:(?:http|https):\/\/)?(?:www.)?facebook.com\/(?:(?:\w)*##!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?",#arguments.data#)>
			<cfif arrayIsEmpty(result) AND arguments.data Neq "">
				<cfset arrayOfErr.fberror = "facebook url is not valid" />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"twitter") eq 0 and arguments.data Neq "">

			<cfset var twitterResult = REMatchNoCase("http://twitter.com/(##!/)?[a-zA-Z0-9_]{1,15}",#arguments.data#) />
			<cfset var twitterRes = REMatchNoCase("https://twitter.com/(##!/)?[a-zA-Z0-9_]{1,15}",#arguments.data#) />

			<cfif arrayIsEmpty(twitterResult) and arrayIsEmpty(twitterRes)>
				<cfset arrayOfErr.terror = "twitterUrl url is not valid" />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"linkedInUrl") eq 0>

			<cfset var linkedinResult = REMatchNoCase("^https:\/\/[a-z]{2,3}\.linkedin\.com\/.*$",#arguments.data#) />

			<cfif arrayIsEmpty(linkedinResult) and arguments.data Neq "">
				<cfset arrayOfErr.lerror = "linkedInUrl url is not valid" />
			</cfif>
		</cfif>

	</cffunction>

	<!--- This is used for validating the artist profile data --->
	<cffunction access="public" name="checkForLength" returntype="void">

		<cfargument name="field" type="string" required="true"/>
		<cfargument name="data" type="string" required="true"/>

		<cfset VAR errMsg = "enter the data below 100!!"/>

		<cfif compareNoCase(field,"facebookUrl") eq 0>
			<cfif len(arguments.data) gt 100>
				<cfset arrayOfErr.fberror = #errMsg# />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"linkedInUrl") eq 0>
			<cfif len(arguments.data) gt 100>
				<cfset arrayOfErr.lerror = #errMsg# />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"twitterUrl") eq 0>
			<cfif len(arguments.data) gt 100>
				<cfset arrayOfErr.terror = #errMsg# />
			</cfif>
		</cfif>

		<cfif compareNoCase(field,"aboutMe") eq 0>
			<cfif len(arguments.data) gt 255>
				<cfset arrayOfErr.aboutmeerr = "Enter the data below 255!!" />
			</cfif>
		</cfif>

	</cffunction>

	<!--- This is used to check for duplicate profile name. --->
	<cffunction access="public" name="checkForDuplicateProfileName" returntype="void">

		<cfargument name="profileName" type="string" required="true">
		<cfset errorMsg = ""/>

		<cfif not StructKeyExists(session,"artistProfile")>
			<cfif arguments.profileName EQ "">
				<cfset arrayOfErr.profilenameerror = "Profile name cant be empty!!" />
			<cfelse>
				<cfquery name="checkForDuplicateProfileName" datasource="artistPortfolio">
					select profile_name from artist_profile where profile_name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.profileName#">;
				</cfquery>

				<cfif checkForDuplicateProfileName.recordCount gt 0>
					<cfset arrayOfErr.profilenameerror = "Artist exists with the given profile name.!!" />
				</cfif>
			</cfif>
		</cfif>

	</cffunction>

</cfcomponent>