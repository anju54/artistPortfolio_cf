var counter = 0;

$(document).ready(function() {

	history.pushState({}, '');
	getUserDetail();
    
    $('#sidebar').hide();
    $('#sidebarLogOut').hide();
    $('#selecArtistHeader').hide();

    showAllProfilePics();   
   
    $('#loadMore').click(function () {
        showAllProfilePics();
    });
   
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

function showAllProfilePics(){

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
            console.log(response);
            if(response.length){
                $('#selecArtistHeader').show();
                setAllProfile(response);
                counter = counter + 3;
                $('#loadMore').show(); 
            } else if(counter == 0){
                //swal("There are No Artist!");
                //$('#noArtist').text("There are No Artist!");
                $('#loadMore').hide();
            }
            else{
                swal('There are no more Artist!!')
                $('#loadMore').hide();
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
            var col =   '<div class="col-md-4 col-sm-6 portfolio-item">'+
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