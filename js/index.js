var counter = 0;
var totalPageNo = 0;
$(document).ready(function() {

	history.pushState({}, '');
    getUserDetail();
    getCountOfProfilePic();

    if(totalPageNo <= 0){
        //totalPageNo = 1;
        $('#pagination-demo').hide();
        $('#portfolio').hide();
        //$('#warningMsg').text("Artist has not uploded any Painting yet!!");
    }
    
    $('#sidebar').hide();
    $('#sidebarLogOut').hide();
    $('#selecArtistHeader').hide();

    //showAllProfilePics();   
   console.log(totalPageNo);
    if(totalPageNo > 0){

        $('#pagination-demo').show();
        $('#pagination-demo').twbsPagination({
            totalPages: totalPageNo,
            visiblePages: 3,
            onPageClick: function (event, page) {
                $('#publicImgDiv').empty();
                showAllProfilePics(page);
            }
        });
    }
});

function setName(response){    

    $('#sidebar').show();
    $('#sidebarLogOut').hide();
    $('#signinButton').hide();
    
    $("#fullName").text(response.fullName) ;
    $("#name").text(response.fullName) ;
    
	var fullName = response.fullName;
	$("#email").text(response.userEmail) ;  
}

function getUserDetail(){

    $.ajax({
        url:  `http://172.16.8.78:90/controller/currentUserController.cfm` ,
        type: "GET",
        crossDomain: true,
        data: {},
        success: function (response) {
			
			console.log("1....");
			if(response){
				console.log(response);
				response = JSON.parse(response);
	            setName(response); 
            }   
        },
        error: function( ) {
        }         
    });
}

function showAllProfilePics(pageNo){
console.log(pageNo);
    var limit = 8;
    counter = pageNo *  limit - limit  ;
    if(!pageNo){
        counter = 0;
    }
    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=getAllProfilePic&offset=${counter}` ,
        type: "GET",
        crossDomain: true,
        async: false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
            if(response.length){
                $('#selecArtistHeader').show();
                setAllProfile(response);
                counter = counter + 3;
                $('#loadMore').show(); 
            } else if(counter == 0){
                $('#loadMore').hide();
            }
            else{
                //swal('There are no more Artist!!');
            }     
        },
        error: function( error) {
        },
        complete: function(){   
        }          
    });
}

function setAllProfile(response){

    for(var i=0; i<response.length;i++){
        var fullName = response[i].FIRST_NAME +" "+ response[i].LAST_NAME;

        if(response[i].PATH===null){
            response[i].PATH =  "/assets/images/";
            response[i].FILENAME_ORIGINAL = "default-profile-pic.png";
        }
        var col =   '<div class="col-md-3 col-sm-6 portfolio-item">'+
            '<a class="portfolio-link" href="./artistPublicProfile.html?id='+response[i].ARTIST_PROFILE_ID+'">'+
            '<div class="portfolio-hover">'+
                '<div class="portfolio-hover-content">'+
                '<i class="fas fa-plus fa-3x"></i>'+
                '</div>'+
            '</div>'+
            '<img class="img-fluid img-fixed-size" src="'+response[i].PATH+response[i].FILENAME_ORIGINAL+'" alt="">'+
            '</a>'+
            '<div class="portfolio-caption">'+
            '<h4>'+fullName+'</h4>'+
            
            '</div>'+
        '</div>';

        $('#publicImgDiv').append(col);
    }    
}

function redirectpage(response){
    
    if(response=='ROLE_ARTIST'){
        
        $('#redirectBtn').attr("href",'./profile.html?email='+response.username+'&val=edit');
        //window.location.href = './profile.html?email='+response.username+'&val=edit' ;
    }else if(response=='ROLE_ORGADMIN'){
        $('#redirectBtn').attr("href",'./orgAdminProfile.html?email='+response.username+'&val=edit');
        //window.location.href = './orgAdminProfile.html?email='+response.username+'&val=edit' ;
    }
    
}

// This is used to get the count of painting present by artist id.
function getCountOfProfilePic(){

    $.ajax({
        url:  `${baseUrl}/controller/artistProfileController.cfm?action=countOfProfilePic` ,
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

    var remainder = countOfPainting % 8;
    
    if( remainder <= 7 && remainder != 0){
        console.log("1..");
        totalPageNo = Math.floor(countOfPainting/8)+1 ;
    }else{
        totalPageNo = countOfPainting / 8;
    }
    console.log(totalPageNo);
}