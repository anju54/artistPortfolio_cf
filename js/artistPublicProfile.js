var counter = 0;
$(document).ready(function() {

    showPublicPaintings(); 
    $('#loadMore').click(function () {
        showPublicPaintings(); 
    });
});

//This is used for displaying all the public images
function showPublicPaintings(){

    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=paginationForPublicPainting&counter=${counter}` ,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
            console.log(response);
            if(response.length){
                
                setAllPaintings(response); 
                $('#loadMore').show(); 
            } else if(counter == 0){
                $('#warningMsg').text("Opps! Artist has not uploaded any Painting Yet!!");
            //    swal("There are No paintings!");
            } else{
                swal('There are no more paintings')
                $('#loadMore').hide();
            } 
            counter = 4 + counter ;         
        },
        error: function( error) {
        }   ,
        complete: function () {     
            bindCall();
        }           
    });
     
}

// This is used to set all the imges to the page
function setAllPaintings(response){

    var paintingList = response;

    for(var i=0; i<paintingList.length;i++){

        var col =   '<div class="col-md-3  col-padding " >'+
                        '<img class="work" alt="img not loaded"'+
                        'src="'+ baseUrl + paintingList[i].PATH_THUMB + paintingList[i].FILENAME +'" ></img>'+
                    '</div>';

        $('#publicImgDiv').append(col);          
    }    
}

//This is used to preview the images when user hover the image
function publicImagePreview(source){
    var source1 = source;
    console.log(source);
    var index = source.indexOf('thumb');
    console.log(index);
    source = source.substring(0,index)+source1.substring(index+15);
    console.log(source);
    var div= document.createElement("div");
    div.className += 'over';
    div.id += 'over';
    document.body.appendChild(div);
    var div = '<div class="container" id="prev"><img style="max-height:500px;" id="prev-img" src="'+source+'"/>'+
        '<span style=color: white;><button id="closePrev" class="btn btn-primary" onClick="closePreview();">Close</button></span></div>';
    $('#over').append(div);

}

function bindCall(){
    $('#publicImgDiv img').click(function(){
        var source = $(this).attr('src');
        publicImagePreview(source);
    });
}

//This is used for closing the preview div
function closePreview(){
    $('#over').remove();
}

$(document).ready(function() {

    var id = getUrlParameter('id');
    getPublicProfilePic(id);
    getArtistProfileInfo(id);  
     
});

//This is used to fetch artist profile basic information
function getArtistProfileInfo(id){
    var id = getUrlParameter('id');
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getPublicProfile&id=${id}` ,
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
                setData(response); 
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

//This is used to set the artist basic information to artist profile page
function setData(response){

    $("#fullName").text(response[0].FIRST_NAME+" "+response[0].LAST_NAME) ;
    $("#name").text(response[0].FIRST_NAME+" "+response[0].LAST_NAME) ;
    $("#email").text(response[0].EMAIL_ID) ;
    $("#aboutMe").text(response[0].ABOUT_ME) ;
    
    $('#linkedin').attr("href",response[0].LINKEDIN_URL);
    $('#facebook').attr("href",response[0].FACEBOOK_INFO) ;   
    $('#twitter').attr("href",response.twitterUrl) ;

    var color = response[0].COLOR_NAME;
    $('#mainColorDiv').css({backgroundColor: color});
    $('#fh5co-work').css({backgroundColor: color});

    for(var i=0; i<response.length;i++){

        var listrow = '<h3 class="card-subtitle" id="paintingType">'+ response[i].PAINTING_NAME+'</h6>'
        $('#paintingType').append(listrow);
    }
}

// This method is used to get profile pic
function getPublicProfilePic(id){

    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getPublicProfilePicById&artistId=${id}` ,
        type: "GET",
        crossDomain: true,
        data: {},
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
            if(response){
                var path = baseUrl + response[0].PATH + response[0].FILENAME_ORIGINAL ;
                console.log(response[0].FILENAME);
                $('#profilePic').attr("src",path);
                 
            } else{
                var staticPath = "./assets/images/default-profile-pic.png";
                $('#profilePic').attr("src",staticPath);
            }
            
        },
        error: function( ) {
        }         
    });

}

// method to get url parameter
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),sParameterName,i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};