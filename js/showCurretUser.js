$(document).ready(function() {

    getUserDetail();
});

// This method is used to get principal user information.
function getUserDetail(){

    $.ajax({
        url:  `${baseUrl}/controller/currentUserController.cfm` ,
        type: "GET",
        crossDomain: true,
        data: {},
       
        success: function (response) {
			console.log(response);
			response = JSON.parse(response);
            setName(response);    
        },
        error: function( ) {
        }         
    });
}

// This method is used to set user data to the text field
function setName(response){
    
    
    $("#fullName").text(response.fullName) ;
    $("#name").text(response.fullName) ;
    var fullNameSplit = response.fullName.split(" ");
    $("#firstName").val(fullNameSplit[0]) ;
    $("#lastName").val(fullNameSplit[1]) ;
    $('#firstName').attr("disabled","disabled");
    $('#lastName').attr("disabled","disabled");
    
    $("#email").text(response.userEmail) ;
}
