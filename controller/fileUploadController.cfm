
<cfset requestBody = ( getHttpRequestData().content ) />

<cfdump var="#requestBody#">
<cfset application.fileUpload = CreateObject('component', 'component.fileUpload') />

<cfset imageUploaded = application.fileUpload.uploadImage(requestBody) />