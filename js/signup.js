$(document).ready(function() {

    $("#signUp").click(function() {
        registration();
    }); 
});

// This is used for making ajax call for registration
function registration(){

     var emailVal = $('#email').val();
     var passwordVal = $('#password').val();
     var fNameVal = $('#fname').val().replace(/[^a-zA-Z0-9]/g, '');
     var lNameVal = $('#lname').val().replace(/[^a-zA-Z0-9]/g, '');
     var usertypeVAl = $("input[name='userType']:checked").val();
     
     var postData = {
    		 fname : fNameVal,
    		 lname : lNameVal,
    		 email : emailVal,
    		 password : passwordVal
     }
   
     if(validate()){
    	 
    	 showLoader();
    	 $.ajax({

    	        url:  `${baseUrl}/controller/signupController.cfm` ,
    	        type: "POST",
    	        dataType: "json",
    	        data: JSON.stringify(postData),
    	        contentType: "application/json",
    	        
    	        success: function (response) {
    	            console.log(response);
    	            
    	            if(!response){
    	            	$('#mainErrMsg').show();
    	            	$('#mainErrMsg').text("This user is already registered with us!");
    	            	
    	            }else{
    	            	alert("Congratulations!! account has been created successfully!");
	    	            $('#msg').text("Congratulations!! account has been created successfully!");
	    	            window.location.href = './signin.html';
	    	        }
    	        },
    	        error: function(error) {
    	        	console.log(error);
    	        	
    	        },
    	        complete: function () {
    	            hideLoader();               
    	        }
    	    });
     }
}

// This is used for hiding the error tag after giving the input
function hideFnameFunction(){
    $('#fnameError').hide();
}
function hideLnameFunction(){
    $('#lnameError').hide();
}
function hideEmailFunction(){
    $('#emailErrorMsg').hide();
    $('#mainErrMsg').hide();
}
function hidepasswordFunction(){
    $('#passwordErrorMsg').hide();
}
