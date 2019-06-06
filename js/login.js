$(document).ready(function() {

    $("#loginBtn").click(function() {
        
        login();
    }); 
    
    var email = window.localStorage.getItem("EMAIL"); 
    if(email){
    	window.location.href = './profile.html';
    }
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
            	
            	//window.localStorage.setItem("EMAIL",response.UserEmail); 
            	//window.localStorage.setItem('session',JSON.stringify(response));
            	
            	redirectPage(response);
            	if(!response){
            		 $('#error').show(); 
            		 $('#error').text("Email and password that you entered is wrong!!")
            	}
            },
            error: function(error) {
            	console.log(error);
            	 $('#error').show(); 
            	 $('#error').text(error.statusText);
            },
            complete: function () {
                hideLoader();
            }
        });       
    }   
}

function redirectPage(response){
    
    if(response.role=='ROLE_ARTIST'){
        window.location.href = '../views/profile.html' ;
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