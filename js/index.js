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
console.log("2....");
    $.ajax({
        url:  `${baseUrl}/controller/currentUserController.cfm` ,
        type: "GET",
        crossDomain: true,
        data: {},
       
        success: function (response) {
			console.log(response);
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
        url:  `${baseUrl}/api/media/all/artist/profile-pics/${counter}/3` ,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            
            if(response.length){
                $('#selecArtistHeader').show();
                setAllProfile(response);
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
            counter++;           
        },
        error: function( error) {
        },
        complete: function(){   
        }          
    });
}

function setAllProfile(response){

    for(var i=0; i<response.length;i++){

        if(response[i].media){

            var col =   '<div class="col-md-4 thumbnail img-responsive">'+
                            '<img style="height:300px" class="work" alt="'+response[i].fullName+'"'+
                            'src="'+ baseUrl + response[i].media.path + response[i].media.fileName +'" ></img>'+
                            '<a style="cursor: pointer; text-align:centre" id="'+response[i].artistProfileId+
                            '" href="./artistPublicProfile.html?id='+response[i].artistProfileId+'">'+response[i].fullName+'</a>';
                        '</div>';

            $('#publicImgDiv').append(col);
        }else{

            var col =   '<div class="col-md-4 thumbnail img-responsive">'+
                            '<img style="height:300px" class="work" alt="'+response[i].fullName+'"'+
                            'src="./assets/images/default-profile-pic.png" ></img>'+
                            '<a style="cursor: pointer; text-align:centre" id="'+response[i].artistProfileId+
                            '" href="./artistPublicProfile.html?id='+response[i].artistProfileId+'">'+response[i].fullName+'</a>';
                        '</div>';
            $('#publicImgDiv').append(col);
        }            
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