var counter = 0;

$(document).ready(function() {

	history.pushState({}, '');
	getUserDetail();
    
    $('#sideBar').hide();
    $('#selecArtistHeader').hide();
   
    showAllProfilePics();   
   
    $('#loadMore').click(function () {
        showAllProfilePics();
    });
   
});


function setName(response){    
console.log("3....");
 	$('#sideBar').show();
    $('#signinButton').hide();
    
    $("#fullName").text(response.fullName) ;
    $("#name").text(response.fullName) ;
    
	var fullName = response.fullName;
	$("#email").text(response.userEmail) ;  
}


function getUserDetail(){

    $.ajax({
        url:  `${baseUrl}/controller/currentUserController.cfm` ,
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
        data: {},
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
            var col =   '<div class="col-md-4 thumbnail img-responsive">'+
                            '<img style="height:300px" class="work" alt="'+fullName+'"'+
                            'src="'+ baseUrl + response[i].PATH + response[i].FILENAME_ORIGINAL +'" ></img>'+
                            '<a style="cursor: pointer; text-align:centre" id="'+response[i].ARTIST_PROFILE_ID+
                            '" href="./artistPublicProfile.html?id='+response[i].ARTIST_PROFILE_ID+'">'+fullName+'</a>';
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