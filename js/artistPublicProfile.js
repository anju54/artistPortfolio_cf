var counter = 0;
var totalPageNo = 0;
$(document).ready(function() {

    showPublicPaintings(counter); 
    console.log(totalPageNo);
    $('#pagination-demo').twbsPagination({
        totalPages: totalPageNo,
        visiblePages: 3,
        onPageClick: function (event, page) {
            $('#publicImgDiv').empty();
            showPublicPaintings(page);
        }
    });

    $(".likeButton").click(function(){

        var mediaId = this.id;
        addLikes(mediaId);
        console.log(mediaId);

    });
});

function addLikes(id){

    $.ajax({
        url:  `${baseUrl}/controller/paintingcontroller.cfm?action=countPublicPainting` ,
        type: "GET",
        crossDomain: true,
        async:false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            calculateTotalPageNo(response);
            
        },
        error: function( ) {
        }         
    });    
}



//This is used for displaying all the public images
function showPublicPaintings(pageNo){

    var id = getUrlParameter('id');
    var limit = 4;
    counter = pageNo *  limit - limit  ;
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=paginationForPublicPainting&counter=${counter}&id=${id}` ,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
           
            getCountOfPublicPaintings();
            if(response.length){
                $('#publicImgDiv').empty();
                setAllPaintings(response); 
            } 
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
    console.log(response);
    for(var i=0; i<paintingList.length;i++){

        var col =   '<div class="mainContainer">'+
                    '<div class="col-md-3  col-padding " >'+
                        '<img class="work" alt="img not loaded" class="image" id="'+paintingList[i].MEDIA_ID+
                        '"'+
                        'src="'+ baseUrl + paintingList[i].PATH_THUMB + paintingList[i].FILENAME +'" ></img>'+
                        '<div class="middle">'+
                            '<button type="submit" class="likeButton"  id="'+paintingList[i].MEDIA_ID+
                            '"'+
                            '><i class="fa fa-thumbs-up topright"></i></button>'+
                            '<button type="submit" class="commentButton" id="'+paintingList[i].MEDIA_ID+
                            'comment"'+
                            '><i class="fa fa-comments-o" style="font-size:48px;color:red"></i></button>'+
                        '</div></div>'
                    '</div>';

        $('#publicImgDiv').append(col);          
    }    
}

//This is used to preview the images when user hover the image
function publicImagePreview(source){
    var source1 = source;
    var index = source.indexOf('thumb');
    source = source.substring(0,index)+source1.substring(index+5);
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

// This is used to get the count of painting present by artist id.
function getCountOfPublicPaintings(){

    var id = getUrlParameter('id');
    $.ajax({
        url:  `${baseUrl}/controller/paintingcontroller.cfm?action=countPublicPainting&id=${id}` ,
        type: "GET",
        crossDomain: true,
        async:false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            console.log(response);
            calculateTotalPageNo(response);
            
        },
        error: function( ) {
        }         
    });
}

//This is used to get the total page number to show the paintings
function calculateTotalPageNo(countOfPainting){

    var remainder = countOfPainting % 4;
    if( remainder==1 || remainder == 2 || remainder == 3){
        totalPageNo = countOfPainting / 4 + 1;
    }else{
        totalPageNo = countOfPainting / 4;
    }
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