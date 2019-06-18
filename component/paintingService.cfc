<!---
  --- paintingService
  --- ---------------
  ---
  --- author: anjuk
  --- date:   6/12/19
  --->

<cfcomponent accessors="true" output="false" persistent="false">

	<!--- This is used to upload painting by artist_id --->
	<cffunction name="uploadPainting" access="public" output="false" returntype="Any">

		<cfargument name="form" type="any" required="true"/>
		<cfset flag = false />

		<!--- Fetch profile name from session object --->
		<cfset profileName = session.artistProfileId.profileName />
		<cfset destination = "../media/artist/" & profileName & "/" />
		<cfset storedDestinationAdress = "/media/artist/" & profileName & "/" />

		<cfif len(trim(form.fileUpload))>
		  <cffile action="upload"
		     fileField="fileUpload"
		     destination="#expandPath("#destination#")#">

		</cfif>
		<!--- Fetch user_id from session object --->
		<cfset userId = "#session.user.userId#">

		<cfset newFileName = GetTickCount() & cffile.ATTEMPTEDSERVERFILE />
		<cfset paintingDestination = destination & newFileName />
		<cfset source = destination & cffile.ATTEMPTEDSERVERFILE />

		<!--- To rename the file name --->
		<cffile
		action = "rename"
		destination = "#expandPath("#paintingDestination#")#"
		source = "#expandPath("#source#")#">

		<cfquery datasource="artistPortfolio" result="uploadPainting">

			insert into media( filename_original, path ) values (

			<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedDestinationAdress#">
			)
		</cfquery>
		<!--- get the primary key of the inserted record --->
		<cfset paintingId = uploadPainting["GENERATEDKEY"] />

		<cfset artistId = "#session.artistProfileId.artistProfileId#">

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

		<cfreturn true/>
	</cffunction>

	<!--- This is used to create thumbnail of images --->
	<cffunction name="createThumbnailofImages" access="public" output="false" returntype="Any">

		<cfargument name="form" type="any" required="true"/>
		<cfargument name="fileName" type="string" required="true" default="">
		<cfargument name="mediaId" type="any" required="true">

		<cfset flag = false />

		<!--- Fetch profile name from session object --->
		<cfset profileName = session.artistProfileId.profileName />
		<cfset destination = "../media/artist/" & profileName & "/" & "thumb/" />
		<cfset storedThumbDestination = "/media/artist/" & profileName & "/" & "thumb/" />

		<cfset thumbDestination = "../media/artist/" & profileName & "/" & "thumb/" & fileName />

		<cfset myImage=ImageNew(form.fileUpload)>
		<cfset  ImageResize(myImage,"50%","","blackman",2)>

		<cfimage source="#myImage#" action="write" destination="#expandPath("#thumbDestination#")#" overwrite="yes">

		<!--- <cfif len(trim(myImage))> --->
<!--- 		  <cffile action="upload" --->
<!--- 		     fileField="fileUpload" --->
<!--- 		     destination="#expandPath("#destination#")#"> --->

<!--- 		</cfif> --->
		<!--- Fetch user_id from session object --->
		<cfset userId = "#session.user.userId#">

		<cfset newFileName = fileName />
		<cfset paintingDestination = destination & newFileName />
		<cfset source = destination & cffile.ATTEMPTEDSERVERFILE />

		<!--- To rename the file name --->
		<!--- <cffile --->
<!--- 		action = "rename" --->
<!--- 		destination = "#expandPath("#paintingDestination#")#" --->
<!--- 		source = "#expandPath("#source#")#"> --->

		<cfquery datasource="artistPortfolio" result="uploadPainting">

			update media set filename =
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#">,
			path_thumb =
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#storedThumbDestination#">
			where media_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mediaId#">
		</cfquery>

		<cfreturn />
	</cffunction>

	<!--- This is used to show all painting by artist id --->
	<cffunction name="showAllPaintingByArtistId" access="public" output="false" returntype="any">

		<cfset artistId = "#session.artistProfileId.artistProfileId#">

		<cfquery datasource="artistPortfolio" name="showAllPaintingByartistId">

			select filename_original , path, media.media_id from media inner join artist_media_bridge as amb on
			media.media_id = amb.media_id
            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
		</cfquery>

		<cfreturn showAllPaintingByartistId/>
	</cffunction>

	<cffunction name="showPublicPaintingByArtistId" access="public" output="false" returntype="Any">
		<!--- TODO: Implement Method --->
		<cfreturn />
	</cffunction>

	<cffunction name="paginationForAllPainting" access="public" output="true" returntype="Any">

		<cfargument name="offset" type="numeric" required="true" >

		<cfset artistId = "#session.artistProfileId.artistProfileId#">
		<cfset limitValue = 4 />

		<cfquery datasource="artistPortfolio" name="paginationForAllPaintings">

			select filename , path_thumb,path,filename_original, media.media_id, is_public
			from media inner join
			artist_media_bridge as amb on media.media_id = amb.media_id
            where artist_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#artistId#">
			limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#limitValue#">
		</cfquery>

		<cfreturn paginationForAllPaintings>
	</cffunction>

	<cffunction name="setIspublicOrprivate" access="public" returntype="void">

		<cfargument name="mediaId" type="numeric" required="true" >
		<cfargument name="publicOrPrivate" type="string" required="true" >

		<cfquery datasource="artistportfolio" name="setPublicOrPrivate">

			update artist_media_bridge set is_public =
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicOrPrivate#">
			 where media_id =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mediaId#">
		</cfquery>
	</cffunction>

	<!--- This is used to delete artist's painting by media id --->
	<cffunction name="deletePainting" access="public" returntype="boolean">

		<cfargument name="mediaId" required="true" >
		<cfset flag = false />

		<cfquery name="deletePainting" datasource="artistPortfolio">
			delete from media where media_id =
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mediaId#">
		</cfquery>

		<cfif #deletePainting.recordCount# gt 0>
			<cfset flag = true />
		</cfif>
	</cffunction>

</cfcomponent>