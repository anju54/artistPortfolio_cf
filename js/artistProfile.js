$(document).ready(function() {
   
    $('#update').hide(); 
    //$("#saveImage").hide();
    $('#updateImage').hide();

    //getUserDetail();
    getArtistProfileId();
    getAllPaintingType(); 
    getAllColors();
    getArtistProfileData();

    $("#save").click(function() {
        saveProfileData();  
    });
    $("#update").click(function() {
        updateProfile();
    });

    var type ="artist";

    $("#updateImage").click(function(event) {

        event.preventDefault();

        var form = $('#uploadimage')[0];
        var data = new FormData(form);
        updateProfilePic(data,type);
    });

    $("#saveImage").click(function(event) {

        event.preventDefault();
        var form = $('#uploadimage')[0];
        var data = new FormData(form);
        uploadProfilePic(data,type);
    }); 
   
    var id = window.localStorage.getItem("ARTIST");
    if(id==0){
        getLoggedArtistProfile(username);  
    }
    
    //getLoggedArtistProfile(username); 

    
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
                swal("Poof! Your profile pic has been deleted!", {
                    icon: "success",
                });
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
            console.log(response);
            if(response.length>0){
                setProfileData(response); 
                $('#save').hide();
                $('#update').show();
                
                //$('#deleteImage').show();
            }             
        },
        error: function(error) {
            
            //swal(error.responseJSON.message)
        }             
    });
}

// This is used to set artist profile data 
function setProfileData(response){

    if(response[0].PROFILE_NAME){
        $('#profileName').parent().remove();
        $("label:contains('Profile Name')").remove();
        $("#pName").show();
        $("#profileN").text(response[0].PROFILE_NAME);
    }
    $('#name').val(response[0].fname+" "+response.lname);
    $('#firstName').val(response[0].fname);
    $('#lastName').val(response[0].lname);
    $('#fbUrl').val(response[0].FACEBOOK_INFO);
    $('#twitterUrl').val(response[0].TWITTER_INFO);
    $('#linkedInUrl').val(response[0].LINKEDIN_URL);
    $('#aboutMe').val(response[0].ABOUT_ME);
    $('#email').text(response[0].email);
    $('#bgcol').val(response[0].COLOR_NAME);
    var paintingTypeList = response.paintingType;

    var list = "" ;
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
function saveProfileData(){

   $('#msg').text('');

    var email = window.localStorage.getItem("USERNAME");
    var fbUrl = $("#fbUrl").val();
    var twitterUrl = $('#twitterUrl').val();
    var linkedInUrl = $('#linkedInUrl').val();
    var aboutMe = $('#aboutMe').val();
    var profileName = $('#profileName').val();
    
   
    if(validate("save")){

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
       
        data = {
           
            "profileName":profileName,
            "facebookUrl": fbUrl,
            "twitterUrl": twitterUrl,
            "linkedinUrl": linkedInUrl,
            "aboutMe": aboutMe,
            "colorName": color,
            "paintingTypeList" : newList
        }
        
        data = JSON.stringify(data);
        showLoader();
        $.ajax({
            url:  `${baseUrl}/controller/artistProfileController.cfm?action=saveArtistProfile` ,
            type: "POST",
            crossDomain: true,
            data: data,
           
            headers: {
                "Content-Type": "application/json",
            },
            'async': false,
            success: function (response) {
                
                window.localStorage.setItem("ARTIST",response);
                if(response){
                    swal("data saved successfully!!");  
                    getLoggedArtistProfile();    
                    showProfilePic() ;
                    $("#saveImage").show();
                    getArtistProfileData();
                }  
            },
            error: function( error) {

                // var errorMsg = error.responseJSON.message;

                // if(errorMsg.includes("Profile")){
                //     $('#profileNameError').show();
                //     $('#profileNameError').text(error.responseJSON.message)
                // }if(errorMsg.includes("Facebook")){
                //     $('#fbError').show();
                //     $('#fbError').text(errorMsg);
                // }else if(errorMsg.includes("Twitter")){
                //     $('#tError').show();
                //     $('#tError').text(errorMsg);
                // }else if(errorMsg.includes("LinkdIn")){
                //     $('#lError').show();
                //     $('#lError').text(errorMsg);
                // }
                // else{
                //     $('#msg').show();
                //     $('#msg').text(errorMsg);
                // }
            },  
            complete: function () {
                
                hideLoader();
            }            
        });
    }  
}

// This is used to save artist profile data
function updateProfile(){

    $('#msg').text('');
    var email = window.localStorage.getItem("USERNAME");
    var fbUrl = $("#fbUrl").val();
    var twitterUrl = $('#twitterUrl').val();
    var linkedInUrl = $('#linkedInUrl').val();
    var aboutMe = $('#aboutMe').val();
    var lName = $('#lastName').val();
    var fName = $('#firstName').val();
   
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

    if(validate("update")){

        data = {
            
            "fName":fName,
            "lName":lName,
            "facebookUrl": fbUrl,
            "twitterUrl": twitterUrl,
            "linkedinUrl": linkedInUrl,
            "aboutMe": aboutMe,
            "email":email,
            "paintingType" : newList,
            "colorName":color
        }
        console.log(data); 
        data = JSON.stringify(data);
    
        $.ajax({
            url:  `${baseUrl}/controller/artistProfileController.cfm?action=updateArtistProfile` ,
            type: "POST",
            crossDomain: true,
            data: data,
           
            headers: {
                "Content-Type": "application/json",
            },
            'async': false,
            success: function (response) {
                
                $('#msg').show();
                swal("data  updated");          
            },
            error: function(error) {
                var err = error.responseJSON.message;
                if(err.includes("Facebook")){
                    $('#fbError').show();
                    $('#fbError').text(err);
                }else if(err.includes("Twitter")){
                    $('#tError').show();
                    $('#tError').text(err);
                }else if(err.includes("linkdIn")){
                    $('#lError').show();
                    $('#lError').text(err);
                }
                else{
                    $('#msg').show();
                    $('#msg').text(error.responseJSON.message);
                    
                }
                
            }             
        });
    }
    

}

// This is used to get logged in ArtistProfile Id
function getLoggedArtistProfile(username){

    $.ajax({
        url:  `${baseUrl}/api/artist-profile/loggedIn/${username}` ,
        type: "GET",
        crossDomain: true,
        data: {},
        
        headers: {
            "Content-Type": "application/json",
        },
        'async': false,
        success: function (response) {
            if(response){

                window.localStorage.setItem("ARTIST",response);  
                var existingArtist = window.localStorage.getItem("ARTIST");
                showProfilePic();    
            }  
        },
        error: function( ) {
           
        }         
    });
}

// This is used to delete profile pic
function deleteProfile(){

    var email = window.localStorage.getItem("USERNAME");
    $.ajax({
        url:  `${baseUrl}/api/media/profile-pic/${email}` ,
        type: "DELETE",
        crossDomain: true,
        data: {},
       
        success: function (response) {
              if(response!=null){  
                $('#profileImage').attr("src","./assets/images/default-profile-pic.png");
                $('#updateImage').hide();
                $('#saveImage').show();
                $('#deleteImage').hide();
              }
        },
        error: function( ) {
        }         
    });
}

function redirectArtistPublicProfile(){

    var id = window.localStorage.getItem("ARTIST");
    $('#previewProfile').attr("href","./artistPublicProfile.html?id="+id);
}

// this is used for validation the form
function validate(type){
    
    // var fname = $('#fname').val();
    var profileNameVal = $('#profileName').val();
    var colorVal = $('#bgcol :selected').val();

    var fbUrl = $("#fbUrl").val();
    var twitterUrl = $('#twitterUrl').val();
    var linkedInUrl = $('#linkedInUrl').val();

    if(type=="save"){

        if(  isEmpty("Profile Name", profileNameVal) && isEmpty("color", colorVal) ) {          
        
            if(isURLvalid("Facebook",fbUrl) && isURLvalid("twitter",twitterUrl) 
                && isURLvalid("LinkedIn",linkedInUrl)){
                    return true;
                }else{
                    return false;
                }
        
        } else return false;
    }else{

        if(isEmpty("color", colorVal) ) {         
       
            if(isURLvalid("Facebook",fbUrl) && isURLvalid("twitter",twitterUrl) 
            && isURLvalid("LinkedIn",linkedInUrl)){
                return true;
            }else{
                return false;
            }
        } else return false;
    }
    
   
}

// check for empty
function isEmpty(field, data){
    
    var error = "";
   
    if (data === ''|| data === null || data === undefined || data === "Select") {
        
        error = "You didn't enter "+field+".";
        if(field=="Profile Name"){
            $('#profileNameError').show();
            $('#profileNameError').text(error);
        }else if(field=="First Name"){
            $('#fnameError').show();
            $('#fnameError').text(error);
        }else if(field =="color"){
            $('#colorError').show();
            $('#colorError').text(error);
        }
        return false;
    } 
    return true;
}

function hideError(){
    $('#profileNameError').hide();
    $('#profilePicShowError').hide();
}

function hidefbError(){
    $('#fbError').text('');
}

function hideTError(){
    $('#tError').text('');
}

function hideLError(){
    $('#lError').text('');
}

function hideMainError(){
    $('#msg').hide();
}

function hideColorError(){
    $('#colorError').hide();
}

function isURLvalid(field,data){
    
    var facebookUrlPattern =/^(https?:\/\/)?((w{3}\.)?)facebook.com\/.*/i;
    var twitterUrlPattern = /^(https?:\/\/)?((w{3}\.)?)twitter\.com\/(#!\/)?[a-z0-9_]+$/i;
    var linkedinUrlPattern = /(ftp|http|https):\/\/?(?:www\.)?linkedin.com(\w+:{0,1}\w*@)?(\S+)(:([0-9])+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
    
    // /^(https?:\/\/)?((w{3}\.)?)linkedin.com\/.*/i;
    
    var error = "";

    if(field=="LinkedIn"){
       
        if (data === ''|| data === null || data === undefined)return true;
        if(data.match(linkedinUrlPattern)){
            return true;
        }else{
            error = "you entered wrong "+field+" URL!!";
            $('#lError').show;
            $('#lError').text(error);
            return false;
        }  
    }else if(field=="Facebook"){
        if (data === ''|| data === null || data === undefined)return true;

        if(data.match(facebookUrlPattern)){
            return  true;
        }else{
            error = "You entered wrong "+field+" URL!!";
            $('#fbError').show;
            $('#fbError').text(error);
            return false;
        }
    }else if(field=="twitter"){
        if (data === ''|| data === null || data === undefined)return true;

        if(data.match(twitterUrlPattern)){
           return true;
        }else{
            error = "You entered wrong "+field+" URL!! ";
            $('#tError').show;
            $('#tError').text(error);
            return false;
        }
    }
}

// This method is used to get artist id.
function getArtistProfileId(){

    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getArtistId` ,
        type: "GET",
        crossDomain: true,
        data: {},
       
        success: function (response) {
			console.log(response);  
        },
        error: function( ) {
        }         
    });
}

//This is used for uplaoding the profile pic
function uploadProfilePic(file){

    $('#profilePicShowError').text('');
   // hideLoader();
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
               if(response!=null){
                swal("profile pic  uploaded!!"); 
                showProfilePic(token);
                $('#deleteImage').show();
               }   
            },
            error: function(error) {
                $('#profilePicShowError').text(error.responseJSON.message);
                
            },
            complete: function(){
        
                $('#file').val('');
                $('#profilePicShowError').text('');
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
            if(response){
                response = JSON.parse(response);
                console.log(response);

                setProfilePic(response);  
                $('#updateImage').show(); 
                $('#saveImage').hide(); 
                $('#deleteImage').show(); 
            }else{
                $('#saveImage').show(); 
                $('#deleteImage').hide();
                $('#updateImage').hide();
            }          
        },
        error: function( error) {
            
            $('#profilePicShowError').text(error.responseJSON.message);
        }             
    });
}

//This is used to set the profile pic
function setProfilePic(response){
   
    path = baseUrl + response[0].PATH + response[0].FILENAME_ORIGINAL;
    console.log(path);
    $('#profileImage').attr("src",path);
}

//This is used for making ajax call for updating the profile pic
function updateProfilePic(file){
    
    if(file!=null){

        $.ajax({

            url:  `${baseUrl}/api/media/profile-pic` ,
            type: "PUT",
            enctype: "multipart/form-data",
            crossDomain: true,
            processData: false,  // it prevent jQuery form transforming the data into a query string
            contentType: false,
            data: file,
           
            success: function (response) {
                if(response!=null){
                    swal("Profile pic updated");
                }
            },
            error: function (error) {
                console.log(error);
                $('#profilePicShowError').text(error.responseJSON.message);
            },
            complete: function () {
                showProfilePic(token);
            }
        });

    }
   
    
 }