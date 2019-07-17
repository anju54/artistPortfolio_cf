<!---
	--- paintingService is used to handle all the operation related to painting uploaded by artist.
	--- ---------------
	---
	--- author: anjuk
	--- date:   6/12/19
	--->
<cfcomponent>

	<!--- Fetch profile name from session object --->
	<cfif StructKeyExists(session,"artistProfile")>
		<cfset VARIABLES.profileName = session.artistProfile.profileName />
	</cfif>

	<!--- used for storing the error msg related to artist add and update --->
	<cfset VARIABLES.arrayOfFileErr = StructNew()/>

	<!--- This is used to upload painting by artist_id --->
	<cffunction name="uploadPainting" access="public" output="false" returntype="Any">

		<cfargument name="form" type="any" required="true"/>
		<cftry>
			<cfset VAR flag = false />

			<cfset VAR destination = "../media/artist/" & profileName & "/" />
			<cfset VAR storedDestinationAdress = "/media/artist/" & profileName & "/" />
			<cfif len(trim(form.fileUpload))>
				<cffile action="upload" fileField="fileUpload" destination="#expandPath("#destination#")#">
			</cfif>

			<cfset VAR newFileName = GetTickCount() & cffile.ATTEMPTEDSERVERFILE />
			<cfset VAR paintingDestination = destination & newFileName />
			<cfset VAR source = destination & cffile.ATTEMPTEDSERVERFILE />

			<!--- To rename the file name --->
			<cffile action = "rename" destination = "#expandPath("#paintingDestination#")#" source = "#expandPath("#source#")#">

			<cfquery  result="uploadPainting">

				INSERT INTO media( filename_original, path ) VALUES (

				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedDestinationAdress#">
				)
			</cfquery>

			<!--- update media information in the bridge table --->
			<cfquery  result="updatePainitngBridge">

				INSERT artist_media_bridge ( artist_id , media_id ) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#uploadPainting["GENERATEDKEY"]#">
				)
			</cfquery>

			<cfif uploadPainting.recordCount gt 0 and updatePainitngBridge.recordCount gt 0>
				<cfset createThumbnailofImages(form=form,fileName=newFileName,mediaId=uploadPainting["GENERATEDKEY"]) />
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
			<cfset VAR flag = false />

			<cfset VAR destination = "../media/artist/" & #session.artistProfile.profileName# & "/" & "thumb/" />
			<cfset VAR storedThumbDestination = "/media/artist/" & #session.artistProfile.profileName# & "/" & "thumb/" />
			<cfset VAR thumbDestination = "../media/artist/" & #session.artistProfile.profileName# & "/" & "thumb/" & fileName />

			<cfset myImage=ImageNew(form.fileUpload)>
			<cfset  ImageResize(myImage,"50%","","blackman",2)>
			<cfimage source="#myImage#" action="write" destination="#expandPath("#thumbDestination#")#" overwrite="yes">

			<cfset VAR newFileName = fileName />
			<cfset VAR paintingDestination = destination & newFileName />
			<cfset VAR source = destination & cffile.ATTEMPTEDSERVERFILE />

			<cfquery  result="uploadPainting">

				UPDATE media SET filename =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
				path_thumb =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedThumbDestination#">
				WHERE media_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mediaId#">
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
			<cfset VAR showAllPaintingByartistId = QueryNew("") />

			<cfquery  name="showAllPaintingByartistId">

				SELECT filename_original , path, media.media_id FROM media INNER JOIN artist_media_bridge as amb on
				media.media_id = amb.media_id
	            WHERE artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
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
		<cfset VAR paginationForAllPaintings = QueryNew("")/>

		<cftry>
			<cfquery  name="paginationForAllPaintings">

				SELECT filename , path_thumb,path,filename_original, media.media_id, is_public
				FROM media INNER JOIN artist_media_bridge as amb on
				media.media_id = amb.media_id WHERE artist_id =
	            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.artistProfile.artistProfileId#">
	            ORDER BY media_id DESC LIMIT
	            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,4;
			</cfquery>

			<cfcatch type="any" >
				<cflog application="true" file="artistPortfolioError"
					text = "Exception error -- Exception type: #cfcatch.Type#,Diagnostics: #cfcatch.Message# , Component:paintingService ,
					function:paginationForAllPainting, Line:#cfcatch.TagContext[1].Line#">
			</cfcatch>
		</cftry>
		<cfreturn paginationForAllPaintings>
	</cffunction>

	<!--- This is used to mark painting as public or private --->
	<cffunction name="setIspublicOrprivate" access="public" returntype="void">

		<cfargument name="mediaId" type="numeric" required="true" >
		<cfargument name="publicOrPrivate" type="string" required="true" >
		<cftry>
			<cfquery  name="setPublicOrPrivate">

				UPDATE artist_media_bridge SET is_public =
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicOrPrivate#">
				 WHERE media_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mediaId#">

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

		<cfset VAR countPainting = queryNew("")/>

		<cfif StructKeyExists(session,"artistProfile")>

			<cfquery  name="countPainting" result="countPaintingResult">

			SELECT COUNT(media.media_id) as countOfPainting
				FROM media INNER JOIN
				artist_media_bridge AS amb ON media.media_id = amb.media_id
	            WHERE artist_id =
	            <cfqueryparam cfsqltype="cf_sql_integser" value="#session.artistProfile.artistProfileId#">

			</cfquery>
			<cfset countPainting = countPainting.countOfPainting/>
		</cfif>

		<cfreturn countPainting />
	</cffunction>

	<!--- This is used for counting the number of public media stored in table by artist id --->
	<cffunction name="countPublicPainting" access="public" returntype="numeric">

		<cfargument name="artistId" required="true" type="numeric">

		<cfquery  name="countPublicPainting" result="countPaintingResult">

			SELECT COUNT(media.media_id) AS countOfPainting
				FROM media INNER JOIN
				artist_media_bridge AS amb ON media.media_id = amb.media_id
	            WHERE artist_id =
	            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artistId#">
	            AND amb.is_public = "true";

		</cfquery>
		<cfreturn countPublicPainting.countOfPainting />
	</cffunction>


	<!--- This is used to delete artist's painting by media id --->
	<cffunction name="deletePainting" access="public" returntype="boolean">

		<cfargument name="mediaId" required="true" >
		<cftry>
			<cfset VAR flag = false />

			<cfquery name="deletePainting" result="deletePaintingResult">

				DELETE FROM media WHERE media_id =
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mediaId#">
			</cfquery>
			<cfif deletePaintingResult.recordCount gt 0>
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
	<cffunction access="public" name="validateImage" returntype="Struct">

		<cfargument name="data" type="any" required="true"/>
		<cfset VAR extension = data.imageName.lastIndexOf(".")/>
		<cfset extension = mid(data.imageName,extension+2,len(data.imageName))/>

		<cfset VAR jpgType = compareNoCase(extension,"jpg")  />
		<cfset VAR pngType = compareNoCase(extension,"jpeg") />
		<cfset VAR jpegType = compareNoCase(extension,"png") />

		 <cfif  not ( ( jpgType eq 0 ) or ( pngType eq 0 ) or ( jpegType eq 0) )>

			<cfset arrayOfFileErr.fileType = "This file type is not allowed, allowed extensions are jpg,png and jpeg!"/>
		</cfif>
		<cfset VAR fileSizeValue = fileSizeValidation(form)/>

		<cfreturn VARIABLES.arrayOfFileErr/>

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
	             <cfset arrayOfFileErr.fileSize = "You picture cannot be more then 800k!!" />
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
