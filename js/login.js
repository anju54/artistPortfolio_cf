$(document).ready(function() {

    $("#loginBtn").click(function() {
        
        login();
    }); 
    
});

function login(){

    var emailVal = $('#email').val();
    var passwordVal = $('#password').val();
    
    if(validate()){

        var data = {
            email : emailVal,
            password : passwordVal
                };
        data = JSON.stringify(data);  
        showLoader();

        $.ajax({
            url:  `${baseUrl}/controller/authenticationController.cfm` ,
            type: "POST",
            crossDomain: true,
            data: data,
            dataType: "json",
            headers: {
                "Content-Type": "application/json",
            },
            success: function (response) {
            	
            	redirectPage(response);
            	if(!response){
            		 $('#error').show(); 
            		 $('#error').text("Email and password that you entered is wrong!!")
            	}
            },
            error: function(error) {
            },
            complete: function () {
                hideLoader();
            }
        });       
    }   
}

function redirectPage(response){
    
    if(response.role=='ROLE_ARTIST'){
        window.location.href = '../views/profile.cfm' ;
    }
}

function hideEmail(){
    $('#emailError').hide();
    $('#error').hide();
}

function hidePassword(){
    $('#passwordError').hide();
    $('#error').hide();
}