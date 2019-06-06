<!---
  --- FileUpload
  --- ----------
  ---
  --- author: anjuk
  --- date:   5/31/19
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cffunction name="uploadImage" returnType="any" access="public">

		<cfargument name="imageData" type="any" required="true" />
		<cffile
			action       = "upload"
		    fileField    = "imageData"
		    destination  = "./media/"
		    accept       = "image/jpg"
		    nameConflict = "MakeUnique"
		/>
		<cfset msg = "your file has been uploaded!!">
	</cffunction>

</cfcomponent>