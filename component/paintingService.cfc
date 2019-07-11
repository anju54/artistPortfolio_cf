<!---
	--- paintingService is used to handle all the operation related to painting uploaded by artist.
	--- ---------------
	---
	--- author: anjuk
	--- date:   6/12/19
	--->
<cfcomponent>

	<!--- This is used to upload painting by artist_id --->
	<cffunction name="uploadPainting" access="public" output="false" returntype="Any">

		<cfargument name="form" type="any" required="true"/>
		<cftry>
			<cfset var flag = false />

			<!--- Fetch profile name from session object --->
			<cfset variables.profileName = session.artistProfile.profileName />

			<cfset var destination = "../media/artist/" & profileName & "/" />
			<cfset var storedDestinationAdress = "/media/artist/" & profileName & "/" />
			<cfif len(trim(form.fileUpload))>
				<cffile action="upload" fileField="fileUpload" destination="#expandPath("#destination#")#">
			</cfif>

			<!--- Fetch user_id from session object --->
			<cfset var userId = "#session.user.userId#">

			<cfset var newFileName = GetTickCount() & cffile.ATTEMPTEDSERVERFILE />
			<cfset var paintingDestination = destination & newFileName />
			<cfset var source = destination & cffile.ATTEMPTEDSERVERFILE />

			<!--- To rename the file name --->
			<cffile action = "rename" destination = "#expandPath("#paintingDestination#")#" source = "#expandPath("#source#")#">

			<cfquery datasource="artistPortfolio" result="uploadPainting">

				insert into media( filename_original, path ) values (

				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedDestinationAdress#">
				)
			</cfquery>

			<!--- get the primary key of the inserted record --->
			<cfset var paintingId = uploadPainting["GENERATEDKEY"] />
			<cfset var artistId = "#session.artistProfile.artistProfileId#">

			<!--- update media information in the bridge table --->
			<cfquery datasource="artistPortfolio" result="updatePainitngBridge">

				insert artist_media_bridge ( artist_id , media_id ) values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#paintingId#">
				)
			</cfquery>

			<cfif uploadPainting.recordCount gt 0 and updatePainitngBridge.recordCount gt 0>
				<cfset createThumbnailofImages(form=form,fileName=#newFileName#,mediaId=#paintingId#) />
				<cfset flag = true />
			</cfif>
			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:uploadPainting, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn flag/>
	</cffunction>

	<!--- This is used to create thumbnail of images --->
	<cffunction name="createThumbnailofImages" access="public" output="false" returntype="boolean">

		<cfargument name="form"  required="true"/>
		<cfargument name="fileName" type="string" required="true" default="">
		<cfargument name="mediaId" type="numeric" required="true">

		<cftry>
			<cfset var flag = false />

			<!--- Fetch profile name from session object --->
			<cfset profileName = session.artistProfile.profileName />

			<cfset var destination = "../media/artist/" & profileName & "/" & "thumb/" />
			<cfset var storedThumbDestination = "/media/artist/" & profileName & "/" & "thumb/" />
			<cfset var thumbDestination = "../media/artist/" & profileName & "/" & "thumb/" & fileName />

			<cfset myImage=ImageNew(form.fileUpload)>
			<cfset  ImageResize(myImage,"50%","","blackman",2)>
			<cfimage source="#myImage#" action="write" destination="#expandPath("#thumbDestination#")#" overwrite="yes">

			<cfset var userId = "#session.user.userId#">
			<cfset var newFileName = fileName />
			<cfset var paintingDestination = destination & newFileName />
			<cfset var source = destination & cffile.ATTEMPTEDSERVERFILE />

			<cfquery datasource="artistPortfolio" result="uploadPainting">

				update media set filename =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
				path_thumb =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedThumbDestination#">
				where media_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mediaId#">
			</cfquery>
			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:createThumbnailofImages, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn flag/>
	</cffunction>

	<!--- This is used to show all painting by artist id --->
	<cffunction name="showAllPaintingByArtistId" access="public" output="false" returntype="query">

		<cftry>
			<cfset var showAllPaintingByartistId = QueryNew("") />

			<cfset var artistId = "#session.artistProfile.artistProfileId#">

			<cfquery datasource="artistPortfolio" name="showAllPaintingByartistId">

				select filename_original , path, media.media_id from media inner join artist_media_bridge as amb on
				media.media_id = amb.media_id
	            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
			</cfquery>

			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:showAllPaintingByArtistId, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn showAllPaintingByartistId/>
	</cffunction>

	<!--- This is used to handle the pagination in showing artist paintings --->
	<cffunction name="paginationForAllPainting" access="public" output="true" returntype="query">

		<cfargument name="offset" type="numeric" required="true" >
		<cfset var paginationForAllPaintings = QueryNew("")/>

		<cftry>
			<cfset artistId = "#session.artistProfile.artistProfileId#">
			<cfset limitValue = 4 />
			<cfquery datasource="artistPortfolio" name="paginationForAllPaintings">

				select filename , path_thumb,path,filename_original, media.media_id, is_public
				from media inner join
				artist_media_bridge as amb on media.media_id = amb.media_id
	            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
	              order by media_id desc
				limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#limitValue#">
					;
			</cfquery>

			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:paginationForAllPainting, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn paginationForAllPaintings>
	</cffunction>

	<!--- This is used to display last uploaded image --->
	<cffunction name="displayLastUploadedImage" access="public" returntype="query">

		<cfset var artistId = "#session.artistProfile.artistProfileId#">
		<cfset var selectLastImage = QueryNew("")/>
		<cfquery datasource="artistPortfolio" name="selectLastImage" result="resultOfLastImage">

			select filename , path_thumb,path,filename_original, media.media_id, is_public
				from media inner join
				artist_media_bridge as amb on media.media_id = amb.media_id
	            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
				order by media.media_id desc limit 1;
		</cfquery>

		<cfreturn selectLastImage />
	</cffunction>

	<!--- This is used to mark painting as public or private --->
	<cffunction name="setIspublicOrprivate" access="public" returntype="void">

		<cfargument name="mediaId" type="numeric" required="true" >
		<cfargument name="publicOrPrivate" type="string" required="true" >
		<cftry>
			<cfquery datasource="artistportfolio" name="setPublicOrPrivate">

				update artist_media_bridge set is_public =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicOrPrivate#">
				 where media_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mediaId#">

			</cfquery>
			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:setIspublicOrprivate, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- This is used for counting the number of media stored in table by artist id --->
	<cffunction name="countPainting" access="public" returntype="numeric">

		<cfset var artistId = "#session.artistProfile.artistProfileId#">

		<cfif not artistId Eq 0>

			<cfquery datasource="artistPortfolio" name="countPainting" result="countPaintingResult">
			select count(media.media_id) as countOfPainting
				from media inner join
				artist_media_bridge as amb on media.media_id = amb.media_id
	            where artist_id =
	            <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">

			</cfquery>
		</cfif>

		<cfreturn countPainting.countOfPainting />
	</cffunction>

	<!--- This is used for counting the number of public media stored in table by artist id --->
	<cffunction name="countPublicPainting" access="public" returntype="numeric">

		<cfargument name="artistId" required="true" type="numeric">

		<cfquery datasource="artistPortfolio" name="countPublicPainting" result="countPaintingResult">
			select count(media.media_id) as countOfPainting
				from media inner join
				artist_media_bridge as amb on media.media_id = amb.media_id
	            where artist_id =
	            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
	            and amb.is_public = "true";

		</cfquery>
		<cfreturn countPainting.countOfPainting />
	</cffunction>


	<!--- This is used to delete artist's painting by media id --->
	<cffunction name="deletePainting" access="public" returntype="boolean">

		<cfargument name="mediaId" required="true" >
		<cftry>
			<cfset var flag = false />

			<cfquery name="deletePainting" datasource="artistPortfolio">
				delete from media where media_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mediaId#">
			</cfquery>
			<cfif #deletePainting.recordCount# gt 0>
				<cfset flag = true />
			</cfif>

			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:deletePainting, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn flag/>
	</cffunction>

	<!--- This is used for validating the input image --->
	<cffunction access="public" name="validateImage" returntype="Array">

		<cfargument name="form" type="any" required="true"/>
		<cfset var aErrorMsg = ArrayNew(1) />
		<cfif not isImageFile(form.fileUpload)>
			<cfset arrayAppend(aErrorMsg, 'This file type is not allowed!')>
		</cfif>
		<cfreturn aErrorMsg/>
	</cffunction>


</cfcomponent>
