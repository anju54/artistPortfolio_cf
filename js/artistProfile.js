var artistId = 0;
var arrayOfErr = new Object();
var typeOfProfilePic = "";
var imageName = "";
var actionInProfileData = "save";

$(document).ready(function() {

    getArtistProfileId();
    getAllPaintingType(); 
    getAllColors();
    getArtistProfileData();

    if(!artistId>0){
        $('#myPaintingNav').hide();
        $('#previewProfile').hide();
    }

    $("#update").click(function() {
        
        saveProfileData(actionInProfileData);
    });

    var type ="artist";

    $("#editUpdateBtn").click(function(event) {

        event.preventDefault();
        var form = $('#uploadimage')[0];
        var data = new FormData(form);

        if(!artistId>0){
            $('#profilePicShowError').text("First create artist account!!");
            $('#profilePicModal').remove();
            return false;
        }
        
        if(typeOfProfilePic == "save"){
            uploadProfilePic(data,type,imageName);
        }else if(typeOfProfilePic=="update"){
            updateProfilePic(data);
        }
        
    }); 

    //binds to onchange event of your input field
    $('#file').bind('change', function() {

        ValidateSingleInput(this);

        //this.files[0].size gets the size of your file.
       var size = this.files[0].size ;
       if( size> 800 * 1024 ){
           //swal("please upload image lesser then 800kb");
           $('#profilePicShowError').show();
           $('#profilePicShowError').text("please upload image lesser then 800kb");
       }
    
    });
    
    showProfilePic();
    
    $("#deleteImage").click(function () {
        swal({
            title: "Are you sure?",
            text: "Once deleted, you will not be able to recover",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
        .then((willDelete) => {
            if (willDelete) {
                deleteProfile();
                // swal("Poof! Your profile pic has been deleted!", {
                //     icon: "success",
                // });
            } else {
                swal("Your imaginary file is safe!");
            }
        });
    });

    $('body').on('click', '#uploadimage input', function(){
        $('#imageUploadError').hide();
    });
});

// This method is used to fetch artist profile related data if it is exists
function getArtistProfileData(){
    
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getArtistProfile` ,
        type: "GET",
        crossDomain: true,
        data: {},
        headers: {
            "Content-Type": "application/json",
        },
        'async': false,
        success: function (response) {
            response = JSON.parse(response);
            if(response.length>0){
                actionInProfileData = "update";
                if(response[0].PROFILE_PIC_ID){
                    typeOfProfilePic = "update";    
                }else{
                    typeOfProfilePic = "save";
                }
                getUserDetail();
                setProfileData(response); 
                $("#saveImage").show();
            }             
        },
        error: function(error) {
        }             
    });
}

// This is used to set artist profile data 
function setProfileData(response){
console.log(response);

    if(response[0].PROFILE_NAME){
        $('#profileName').parent().remove();
        $("label:contains('Profile Name')").remove();
        $("#pName").show();
        $("#profileN").text(response[0].PROFILE_NAME);
    }
    $('#name').val(response[0].fname+" "+response.lname);
    $('#firstName').val(response[0].fname);
    $('#firstName').attr("disabled","disabled");
    $('#lastName').val(response[0].lname);
    $('#lastName').attr("disabled","disabled");
    $('#fbUrl').val(response[0].FACEBOOK_INFO);
    $('#twitterUrl').val(response[0].TWITTER_INFO);
    $('#linkedInUrl').val(response[0].LINKEDIN_URL);
    $('#aboutMe').val(response[0].ABOUT_ME);
    $('#email').text(response[0].email);
    $('#bgcol').val(response[0].COLOR_NAME);
    var paintingTypeList = response.paintingType;

    var list = "" ;
    if(response.length == 1 && response[0].PAINTING_NAME == null ){
    	$('#optionPaintingType').text("Select Painting type");
    	return false;
    }
    for(var i=0; i<response.length;i++){

        var res = response[i].PAINTING_TYPE_ID+"_paintingType";        
        $('#'+res).prop("checked",true);
        list += response[i].PAINTING_NAME + ",";
       
    }
    if(list.length > 50){
        
        var res = list.substr(0,50);
        res += "...."; 
        $('#optionPaintingType').text(res);
    }else{
        var length = list.length;
        //var indexVal = list.indexOf(",");
        var result = list.substr(0,length-1);
        $('#optionPaintingType').text(result);
    }
    
}

// This is used to save artist profile data 
function saveProfileData(type){

   $('#msg').text('');
    arrayOfErr = {};
    var fbUrl = $("#fbUrl").val();
    var twitterUrl = $('#twitterUrl').val();
    var linkedInUrl = $('#linkedInUrl').val();
    var aboutMe = $('#aboutMe').val();
    var profileName = $('#profileName').val();
    
    var paintingList = [];
    var newList = [];

    $.each($("input[name='paintingList']:checked"), function(){            
        paintingList.push($(this).attr('id'));
    });
    var color = $('#bgcol :selected').val();

    for(i = 0; i<paintingList.length; i++){

        var str = paintingList[i];
        var id = str.substr(0,1);
        newList.push(id);
    }
    if(actionInProfileData=="update"){
        profileName = "";
    } 
    data = { "profileName":profileName,
            "facebookUrl": fbUrl,
            "twitterUrl": twitterUrl,
            "linkedInUrl": linkedInUrl,
            "aboutMe": aboutMe,
            "colorName": color,
            "paintingTypeList" : newList }
    
    validate();
    console.log(arrayOfErr);
    
    if( Object.keys(arrayOfErr).length > 0){
        return false;
    }else{
        
        data = JSON.stringify(data);
        showLoader();
       
        if(actionInProfileData=="update"){
            action = "updateArtistProfile";
        }else{ action = "saveArtistProfile" };

        $.ajax({
            url:  `${baseUrl}/controller/artistProfileController.cfm?action=${action}` ,
            type: "POST",
            crossDomain: true,
            data: data,
            headers: {
                "Content-Type": "application/json",
            },
            'async': false,
            success: function (response) {
                if(response ==="true "){
                    swal("data saved successfully!!");     
                    showProfilePic() ;
                    $("#saveImage").show();
                    getArtistProfileData();
                    getArtistProfileId();
                }else if(response === "false "){
                    $('#msg').show();
                    $('#msg').text("Some error occured while creating artist account!");
                } else{
                    response = JSON.parse(response);
                    
                    for (const [key, value] of Object.entries(response)) {
                        
                        var k = key.toLowerCase();
                        $('#'+k).text(value);
                        $('#'+k).show();
                    }
                } 
            },
            error: function( error) {
            },  
            complete: function () { 
                hideLoader();
            }            
        });
    }
}

// This is used to delete profile pic
function deleteProfile(){

    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=deleteProfilePic` ,
        type: "Get",
        crossDomain: true,
        data: {},
        'async': false,
        success: function (response) {
            
            if(response){  
                swal("Poof! Your profile pic has been deleted!", {
                    icon: "success",
                });
                $('#profileImage').attr("src","../assets/images/default-profile-pic.png");
                $('#deleteImage').hide();
            }else{
                swal("error deleting profile pic");
            }
        },
        error: function( ) {}         
    });
}

function redirectArtistPublicProfile(){
    $('#previewProfile').attr("href","./artistPublicProfile.cfm");
}

// this is used for validation the form
function validate(){

    var profileNameVal = $('#profileName').val();
    var colorVal = $('#bgcol :selected').val();

    var fbUrl = $("#fbUrl").val();
    var twitterUrl = $('#twitterUrl').val();
    var linkedInUrl = $('#linkedInUrl').val();
    var aboutMe = $('#aboutMe').val();
    
    if(actionInProfileData=="update"){
        isURLvalid("Facebook",fbUrl);
        isURLvalid("LinkedIn",linkedInUrl);
        isURLvalid("twitter",twitterUrl) ;
        checkForlength("Facebook",fbUrl);
        checkForlength("LinkedIn",linkedInUrl)
        checkForlength("twitter",twitterUrl);
        checkForAboutMe("aboutMe",aboutMe)
    }else{
        isEmpty("Profile Name", profileNameVal);
        isEmpty("color", colorVal);
        isURLvalid("Facebook",fbUrl);
        isURLvalid("LinkedIn",linkedInUrl);
        isURLvalid("twitter",twitterUrl) ;
        checkForlength("Facebook",fbUrl);
        checkForlength("LinkedIn",linkedInUrl)
        checkForlength("twitter",twitterUrl);
        checkForAboutMe("aboutMe",aboutMe)
    }
   
    
}

function checkForAboutMe(field, data){
   
    if(data.length > 255){
        
        var error = "Enter the About me below 255";
        arrayOfErr["aboutmeerr"] = error;
        $('#aboutmeerr').show();
        $('#aboutmeerr').text(error);
    }
}

function checkForlength(field, data){

    var error = "Enter the data below 100";
    if ( data.length > 100 ){

        if(field=="LinkedIn"){
            arrayOfErr["LinkedIn"] = error;
            $('#lerror').show;
            $('#lerror').text(error);
               
        }else if(field=="Facebook"){
            arrayOfErr["Facebook"] = error;
            $('#fberror').show;
            $('#fberror').text(error);    
        }else if(field=="twitter"){
            arrayOfErr["twitter"] = error;
            $('#terror').show;
            $('#terror').text(error);
        }
    }
}

// check for empty
function isEmpty(field, data){
    
    var error = "";
   
    if (data === ''|| data === null || data === undefined || data === "Select") {
        
        error = "You didn't enter "+field+".";
        if(field=="Profile Name"){
            $('#profilenameerror').show();
            $('#profilenameerror').text(error);
            arrayOfErr["profilename"] = error;
        }else if(field=="First Name"){
             $('#fnameError').show();
             $('#fnameError').text(error);
            arrayOfErr["firstName"] = error;
        }else if(field =="color"){
             $('#colorerror').show();
            $('#colorerror').text(error);
            arrayOfErr[field] = error;
        }
    } 
}

function isURLvalid(field,data){
    
    var facebookUrlPattern ="(?:(?:http|https):\/\/)?(?:www.)?facebook.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?";
    var fburLForMobile = "(?:(?:http|https):\/\/)?(?:m.)?facebook.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?";
    var twitterUrlPattern = /^(https?:\/\/)?((w{3}\.)?)twitter\.com\/(#!\/)?[a-z0-9_]+$/i;
    var linkedinUrlPattern = /(ftp|http|https):\/\/?(?:www\.)?linkedin.com(\w+:{0,1}\w*@)?(\S+)(:([0-9])+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
    
    // /^(https?:\/\/)?((w{3}\.)?)linkedin.com\/.*/i;
    
    var error = "";
    if(data!=""){
        if(field=="LinkedIn"){
       
            if (data === ''|| data === null || data === undefined)return true;
            if(data.match(linkedinUrlPattern)){
                //return true;
            }else{
                error = "you entered wrong "+field+" url!!";
                arrayOfErr["linkedInUrl"] = error;
                $('#lerror').show;
                $('#lerror').text(error);
            }  
        }else if(field=="Facebook"){
            if (data === ''|| data === null || data === undefined)return true;
            // var flag = data.includes("https:/m.facebook.com")
            if(data.match(facebookUrlPattern) || data.match(fburLForMobile) ){
                //return  true;
            }else{
                error = "You entered wrong "+field+" url!!";
                arrayOfErr["facebookUrl"] = error;
                $('#fberror').show;
                $('#fberror').text(error);
            }
        }else if(field=="twitter"){
            if (data === ''|| data === null || data === undefined)return true;
    
            if(data.match(twitterUrlPattern)){
               //return true;
            }else{
                error = "You entered wrong "+field+" url!! ";
                arrayOfErr["twitterUrl"] = error;
                $('#terror').show;
                $('#terror').text(error);
            }
        }
    }
    
}

//This is used for uplaoding the profile pic
function uploadProfilePic(file){
    
    $('#profilePicShowError').text('');
    showLoader();
    if(file!=null){

        $.ajax({
            url:  `${baseUrl}/controller/artistProfileController.cfm?action=uploadProfilePic` ,
            type: "POST",
            enctype: "multipart/form-data",
            crossDomain: true,
            processData: false,  // it prevent jQuery form transforming the data into a query string
            contentType: false,
            data: file,
            success: function (response) {
               hideLoader();
               if(response=="true "){
                   
                    swal("profile pic  uploaded!!"); 
                    showProfilePic();
                    $('#deleteImage').show();
                    $('#profilePicModal').hide();
               }else{
                response = JSON.parse(response);
                $('#profilePicShowError').show();
                $('#profilePicShowError').text(response.FILESIZE);
                $('#profilePicShowError').text(response.FILETYPE);
               }
            },
            error: function(error) {   
            },
            complete: function(){
                $('#file').val('');
                //$('#profilePicShowError').text('');
                hideLoader();
            }         
        });
    }  
}


//This is used for making ajax call displaying the profile pic
function showProfilePic(){
    
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getProfilePic`,
        type: "GET",
        crossDomain: true,
        data: {},
        headers: {
            "Content-Type": "application/json",
        },
        'async': false,
        success: function (response) {
           
            response = JSON.parse(response);
            
            if(response.length>0 && response[0].PATH && response[0].FILENAME_ORIGINAL){

                setProfilePic(response);  
                $('#updateImage').show();  
                 $('#deleteImage').show(); 
                $('#saveImage').hide();
            }else{
                // $('#saveImage').show(); 
                // $('#deleteImage').hide();
                // $('#updateImage').hide();
            }          
        },
        error: function( error) {
            
           // $('#profilePicShowError').text(error.responseJSON.message);
        }             
    });
}

//This is used to set the profile pic
function setProfilePic(response){
     
    path = baseUrl + response[0].PATH + response[0].FILENAME_ORIGINAL;
    
    $('#profileImage').attr("src",path);
}

//This is used for making ajax call for updating the profile pic
function updateProfilePic(data){ 

    if(file!=null){

        $.ajax({
            url:  `${baseUrl}/controller/artistProfileController.cfm?action=updateProfilePic` ,
            type: "Post",
            enctype: "multipart/form-data",
            crossDomain: true,
            processData: false,  // it prevent jQuery form transforming the data into a query string
            contentType: false,
            data: data,
            async:false,
            success: function (response) {
                
                if(response=="true "){
                    swal("Profile pic updated");
                    $('#profilePicModal').hide();
                }else{
                    response = JSON.parse(response);
                    $('#profilePicShowError').show();
                    $('#profilePicShowError').text(response.FILESIZE);
                    $('#profilePicShowError').text(response.FILETYPE);
                }
            },
            error: function (error) {
                
                //$('#profilePicShowError').text(error.responseJSON.message);
            },
            complete: function () {
                showProfilePic();
            }
        });
    }
   
 }

function redirectArtistPublicProfile(){

    var artistId = getArtistProfileId();
    $('#previewProfile').attr("href","./artistPublicProfile.cfm?id="+artistId);
}

// This method is used to get artist id.
function getArtistProfileId(){
    
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getArtistId` ,
        type: "GET",
        crossDomain: true,
        data: {},
       
        success: function (response) {
            if(response>0){
                $('#myPaintingNav').show();
                $('#previewProfile').show();
                artistId = response; 
                //$("#saveImage").show();
            } 
        },
        error: function( ) {     
        }         
    });
    
    return artistId ;
}


var _validFileExtensions = [".jpg", ".jpeg", ".png"];    
function ValidateSingleInput(oInput) {
    if (oInput.type == "file") {
        var sFileName = oInput.value;
        imageName = sFileName;
        extractImageName(imageName);
        
         if (sFileName.length > 0) {
            var blnValid = false;
            for (var j = 0; j < _validFileExtensions.length; j++) {
                var sCurExtension = _validFileExtensions[j];
                if (sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                    blnValid = true;
                    break;
                }
            }
             
            if (!blnValid) {
                //swal("Sorry, this file is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
                $('#profilePicShowError').text("Sorry, this file is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
                oInput.value = "";
                return false;
            }
        }
    }
    return true;
}

// This is used to extarct image name from complete fath
function extractImageName(fullPath){

    var index = imageName.lastIndexOf("\\");
    imageName = fullPath.substr(index+1,fullPath.length);
    $("#imageName").val(imageName);
}

function hideError(){
    $('#profilenameerror').hide();
    $('#profilePicShowError').hide();
}

function hidefberror(){
    $('#fberror').text('');
}

function hideterror(){
    $('#terror').text('');
}

function hideLError(){
    $('#lerror').text('');
}

function hideMainError(){
    $('#msg').hide();
    $('#aboutmeerr').hide();

}

function hidecolorerror(){
    $('#colorerror').hide();
}

function hideProfileErr(){
    $('#profilePicShowError').hide();
}
