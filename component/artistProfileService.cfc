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
			<cfset VAR isInserted = false />

			<!--- Fetch email from session object --->
			<cfif StructKeyExists(session,"stLoggedInuser")>

				<cftransaction>
					<cfset VAR addArtistProfiledata = QueryNew("")/>
					<!--- insert artist profile record in artist_profile table --->
					<cfquery name = "addArtistProfiledata" result="result">

						INSERT INTO artist_profile ( profile_name, facebook_info, twitter_info, linkedIn_url, about_me,
					 	user_id, color_id) VALUES (

							<cfqueryparam value="#arguments.form.profileName#"  cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.form.facebookUrl#"  cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.form.twitterUrl#"   cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.form.linkedInUrl#"  cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.form.aboutMe#"      cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#session.user.userId#"      	  cfsqltype="cf_sql_integer"> ,
							( SELECT color_id FROM color WHERE color_name =
								<cfqueryparam value="#arguments.form.colorName#"   cfsqltype="cf_sql_varchar">
							)
						)
					</cfquery>

					<cfset VAR paintingTypeList = "#arguments.form.paintingTypeList#" />

					<cfif not ArrayIsEmpty(arguments.form.paintingTypeList)>

						<cfset VAR addPaintingTypeForArtist = QueryNew("")/>

						<!--- This is used to add list of painting type to database --->
						<cfquery name="addPaintingTypeForArtist" result="addPaintingTypeForArtistRes">

							insert into artist_painting_list_bridge(artist_profile_id, painting_id) values
							<cfloop from = "1" to = "#ArrayLen(paintingTypeList)#" index = "i">
								 <cfif i NEQ 1>,</cfif>
								(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#result["GENERATEDKEY"]#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">
								)

							</cfloop>

						</cfquery>
					</cfif>
				</cftransaction>
					<cfif result.recordCount>

						<cfset isInserted = true/>
						<cfset VAR fullPath = "../media/artist/" & arguments.form.profileName & "/" />

						<!--- Check whether the directory exists. --->
						<cfif not DirectoryExists(fullPath)>

							<!--- create folder with the artist profile name inside media/artist/ folder --->
							<cfdirectory action="create" directory="#expandPath("#fullPath#")#">

							<!--- Create folder for storing thumbnail of images --->
							<cfset thumbPath = fullPath & "thumb" & "/" />
							<cfdirectory action="create" directory="#expandPath("#thumbPath#")#">
						</cfif>
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
			<cfset VAR isInserted = false />
			<cftransaction>
			<cfquery name="updateArtist"  result="updateResult">

				UPDATE artist_profile SET
				facebook_info = <cfqueryparam value="#arguments.form.facebookUrl#" cfsqltype="CF_SQL_varchar"> ,
				twitter_info  = <cfqueryparam value="#arguments.form.twitterUrl#"   cfsqltype="CF_SQL_varchar">  ,
				about_me      = <cfqueryparam value="#arguments.form.aboutMe#"          cfsqltype="CF_SQL_varchar">,
				linkedIn_url  = <cfqueryparam value="#arguments.form.linkedInUrl#"  cfsqltype="CF_SQL_varchar">,
				color_id      = ( select color_id from color where
				color_name    = <cfqueryparam value="#arguments.form.colorName#" cfsqltype="cf_sql_varchar"> )
				WHERE artist_profile_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
			</cfquery>

			<cfset VAR paintingTypeList = #arguments.form.paintingTypeList# />

			<cfquery  name="deleteExistingPaintingType" result="deleteExistingPaintingTypeResult">

				DELETE FROM artist_painting_list_bridge WHERE artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
			</cfquery>

			<cfif not ArrayIsEmpty(arguments.form.paintingTypeList)>

				<!--- This is used to add list of painting type to database --->
				<cfquery name="addPaintingTypeForArtist" >

					INSERT INTO artist_painting_list_bridge(artist_profile_id, painting_id) VALUES
					<cfloop from = "1" to = "#ArrayLen("#arguments.form.paintingTypeList#")#" index = "i">
						 <cfif i NEQ 1>,</cfif>
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#paintingTypeList[i]#">
						)

					</cfloop>

				</cfquery>

			</cfif>
			</cftransaction>
			<cfif updateResult.recordCount>
				<cfset isInserted = true/>
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

		<cfset VAR getArtistProfileByUserId = QueryNew("")/>
		<cftry>

			<cfquery  name="getArtistProfileByUserId">

					SELECT ap.artist_profile_id,profile_name,facebook_info,twitter_info,linkedIn_url,about_me,
						pt.painting_name,pt.painting_type_id,c.color_name,ap.profile_pic_id
						FROM artist_profile AS ap LEFT JOIN artist_painting_list_bridge aplb
						on ap.artist_profile_id = aplb.artist_profile_id
	                    LEFT JOIN painting_type pt ON aplb.painting_id = pt.painting_type_id
	                    LEFT JOIN color AS c ON c.color_id = ap.color_id
						WHERE ap.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.userId#">
			</cfquery>
		<cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:artistProfileService ,
					function:getArtistProfileByUserId, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
		<cfreturn getArtistProfileByUserId/>
	</cffunction>

	<cffunction name="getArtistProfileIdByUserId" access="public" output="true" returntype="numeric">

		<cfset VAR artist_profile_id = 0/>
		<cfset VAR profileName = ""/>
		<cfset VAR getArtistProfileIdByUserId = QueryNew("") />
		<cftry>
			<cfquery  name="getArtistProfileIdByUserId">

				SELECT artist_profile_id, profile_name FROM artist_profile AS ap INNER JOIN users AS u ON u.user_id = ap.user_id
				WHERE u.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.userId#">
			</cfquery>

			<cfif getArtistProfileIdByUserId.RecordCount>

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

		<cfset VAR paginationForPublicPaintings = QueryNew("")/>
		<cftry>
			<cfset VAR pageLimit = 8/>
			<cfquery  name="paginationForPublicPaintings">

				SELECT filename , path_thumb,path,filename_original, media.media_id, is_public
				FROM media INNER JOIN
				artist_media_bridge AS amb ON media.media_id = amb.media_id
	            WHERE artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
				AND amb.is_public = "true"
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#pageLimit#">;
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
		<cfset VAR getAllProfilePic = QueryNew("")/>
		<cftry>
		<cfset VAR pageLimit = 8/>
			<cfquery name="getAllProfilePic" >

				SELECT filename_original, path,ap.artist_profile_id, users.first_name, users.last_name FROM media
				 RIGHT JOIN artist_profile ap
				ON media.media_id = ap.profile_pic_id INNER JOIN users ON users.user_id = ap.user_id
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#pageLimit#">;
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

		<cfset VAR selectProfilePic = QueryNew("") />
		<cftry>
			<cfquery name="selectProfilePic"  result="profilePicResult">

				SELECT filename_original , path FROM media INNER JOIN artist_profile ap ON
				media.media_id = ap.profile_pic_id
	        	WHERE artist_profile_id =
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
		<cfset VAR selectProfilePic = QueryNew("")/>
			<cftry>
			<cfquery name="selectProfilePic"  result="profilePicResult">

				SELECT filename_original , path FROM media INNER JOIN artist_profile ap ON
				media.media_id = ap.profile_pic_id
	        	WHERE artist_profile_id =
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
			<cfset VAR flag = false />

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

			<cftransaction>
			<cfquery name="uploadImage"  result="profilePicUpload">

				insert into media( filename_original, path ) values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="/media/profile-pics/">
				)
			</cfquery>

			<cfset getArtistProfileIdByUserId() />

			<cfif profilePicUpload.recordCount>

				<cfquery result="updateProfilePicId" >

					UPDATE artist_profile SET profile_pic_id =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#profilePicUpload["GENERATEDKEY"]#">
					WHERE artist_profile_id =
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
				</cfquery>
			</cfif>
			</cftransaction>
				<cfif updateProfilePicId.recordCount>
					<cfset VAR flag = true />
					<cfelse>
						<cfset VAR flag = false />
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
	<cffunction name="deleteProfilePic" access="public" output="true" returntype="boolean">

		<cftry>
			<cfset VAR flag = true />
			<cftransaction>
			<cfquery  name="getProfilePicId">

				SELECT profile_pic_id FROM artist_profile WHERE artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
			</cfquery>

			<cfif not getProfilePicId.profile_pic_id eq 0>

				<cfquery  result="deleteProfilePic">

					UPDATE artist_profile SET profile_pic_id = NULL WHERE artist_profile_id =
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#"> ;
				</cfquery>
			</cfif>

			<cfif deleteProfilePic.recordCount>

				<cfquery  result="deleteFromArtist">
					delete from media where media_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#getProfilePicId.profile_pic_id#"> ;
				</cfquery>
			</cfif>
		</cftransaction>
			<cfif deleteFromArtist.recordCount>
				<cfset VAR flag = true />
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
		<cfset VARIABLES.returnData = QueryNew("")/>
		<cftry>
			<cfquery  name="getPublicProfileInfo">

				SELECT ap.artist_profile_id,profile_name,facebook_info,twitter_info,linkedIn_url,about_me,
						pt.painting_name,pt.painting_type_id,c.color_name,users.first_name,users.last_name,users.email_id
						FROM artist_profile AS ap
	                    left JOIN artist_painting_list_bridge aplb
						ON ap.artist_profile_id = aplb.artist_profile_id
	                    left JOIN painting_type pt ON aplb.painting_id = pt.painting_type_id
	                    left JOIN color AS c ON c.color_id = ap.color_id
	                    left JOIN users ON ap.user_id = users.user_id
						WHERE ap.artist_profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
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
			<cfset VAR isUpdated = false />

			<cfif len(trim(form.fileUpload))>
			  <cffile action="upload"
			     fileField="fileUpload"
			     destination="#expandPath("../media/profile-pics/")#">

			</cfif>

			<cfset VAR fileName = session.artistProfile.artistProfileId & cffile.ATTEMPTEDSERVERFILE />
			<cfset VAR destination = "../media/profile-pics/" & fileName />
			<cfset VAR source = "../media/profile-pics/" & cffile.ATTEMPTEDSERVERFILE />

			<cffile
			action = "rename"
			destination = "#expandPath("#destination#")#"
			source = "#expandPath("#source#")#">

			<cfquery  name="updateProfilePic" result="updateProfilePicResult">

				update media set filename_original =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#"> where media_id =
				( select profile_pic_id from artist_profile where artist_profile_id =
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">  )
			</cfquery>

			<cfif updateProfilePicResult.recordCount>
				<cfset VAR isUpdated = true />
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

		<cfset VAR countOfProfilePic = 0 />
		<cfset VAR getCountOfprofilePic = QueryNew("")>

		<cfquery name="getCountOfprofilePic" >

			SELECT COUNT(*) AS countOfProfilePic FROM media
				 RIGHT JOIN artist_profile ap
				ON media.media_id = ap.profile_pic_id INNER JOIN users ON users.user_id = ap.user_id;
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

		<cfif compareNoCase(field,"facebookUrl") eq 0 and arguments.data Neq "">

			<cfset VAR result = REMatchNoCase("(?:(?:http|https):\/\/)?(?:www.)?facebook.com\/(?:(?:\w)*##!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?",#arguments.data#)>
			<cfset VAR fbPatternForMobileRes = REMatchNoCase("(?:(?:http|https):\/\/)?(?:m.)?facebook.com\/(?:(?:\w)*##!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?",#arguments.data#)>
			<cfif arrayIsEmpty(result) and arrayIsEmpty(fbPatternForMobileRes)>
				<cfset arrayOfErr.fberror = "facebook url is not valid" />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"twitter") eq 0 and arguments.data Neq "">

			<cfset VAR twitterResult = REMatchNoCase("http://twitter.com/(##!/)?[a-zA-Z0-9_]{1,15}",#arguments.data#) />
			<cfset VAR twitterRes = REMatchNoCase("https://twitter.com/(##!/)?[a-zA-Z0-9_]{1,15}",#arguments.data#) />

			<cfif arrayIsEmpty(twitterResult) and arrayIsEmpty(twitterRes)>
				<cfset arrayOfErr.terror = "twitterUrl url is not valid" />
			</cfif>
		</cfif>
		<cfif compareNoCase(field,"linkedInUrl") eq 0>

			<cfset VAR linkedinResult = REMatchNoCase("^https:\/\/[a-z]{2,3}\.linkedin\.com\/.*$",#arguments.data#) />

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

		<cfargument name="profileName" type="string" required="true"/>
		<cfset VAR errorMsg = ""/>

		<cfif not StructKeyExists(session,"artistProfile")>
			<cfif arguments.profileName EQ "">
				<cfset arrayOfErr.profilenameerror = "Profile name cant be empty!!" />
			<cfelse>
				<cfquery name="checkForDuplicateProfileName" >

					SELECT profile_name FROM artist_profile WHERE profile_name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.profileName#">;
				</cfquery>

				<cfif checkForDuplicateProfileName.recordCount gt 0>
					<cfset arrayOfErr.profilenameerror = "Artist exists with the given profile name.!!" />
				</cfif>
			</cfif>
		</cfif>

	</cffunction>

	<!--- This is used for validating the input image --->
	<cffunction access="public" name="validateImage" returntype="Struct">

		<cfargument name="data" type="any" required="true"/>
		<cfset VAR extension = data.imageName.lastIndexOf(".")/>
		<cfset extension = mid(data.imageName,extension+2,len(data.imageName))/>

		<cfset VAR jpgType = compareNoCase(extension,"jpg")  />
		<cfset VAR pngType = compareNoCase(extension,"jpeg") />
		<cfset VAR jpegType = compareNoCase(extension,"png") />

		 <cfif  not ( ( jpgType eq 0 ) or ( pngType eq 0 ) or ( jpegType eq 0) )>

			<cfset arrayOfErr.fileType = "This file type is not allowed, allowed extensions are jpg,png and jpeg!"/>
		</cfif>
		<cfset VAR fileSizeValue = fileSizeValidation(form)/>

		<cfreturn VARIABLES.arrayOfErr/>
	</cffunction>

	<!--- This is used for file size validation --->
	<cffunction access="public" name="fileSizeValidation" returntype="void">

		<cfargument name="form" type="any" required="true"/>
		<cftry>
			<cfif len(trim(form.fileUpload))>
					<cffile action="upload"
					fileField="fileUpload"
					destination="#expandPath("../media/")#"
					nameconflict="MAKEUNIQUE">
			</cfif>
			<cfif cffile.filesize GT (800 * 1024)>
	             <cfset arrayOfErr.fileSize = "You picture cannot be more then 800k!!" />
			 </cfif>
			 <cffile
	                 action="DELETE"
	                 file="#ExpandPath("../media/#cffile.ATTEMPTEDSERVERFILE#")#"
	          />
	     <cfcatch type="any" >
			<cflog application="true" file="artistPortfolioError"
			text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:getPublicPainting, Line:#cfcatch.TagContext[1].Line#">

		</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>