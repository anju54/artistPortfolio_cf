//This is used for validating the signup page
var arrayOfErr = new Object();
function validate(){
    
    var password = $('#password').val();
    var fname = $('#fname').val();
    var lname = $('#lname').val();  
    var email = $('#email').val();

    isEmpty("First Name",fname) ;
    isEmpty("Last Name", lname);
    validateEmail( email);
    validatePassword(password);
}

// check for password
function validatePassword(password) {
    
    var error = "";
    if(!isEmpty("Password", password)){    
    }
    var passw =  /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{6,})/;
    
    if(password!=""){
        if(password.match(passw)) {  
        } else{ 
            arrayOfErr["passwordErrorMsg"] = error;
             $('#passwordErrorMsg').show();
            $('#passwordErrorMsg').text('Wrong password ...!  it should contain 6 to 20 characters which contain at'+ 
            'least one numeric digit, one uppercase and one lowercase letter');
        }
    }
}

// check for email
function validateEmail(email){
    if(!isEmpty("email", email)){
        $('#emailErrorMsg').show(); 
    }
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (!reg.test(email)) {
        var error = 'Please provide a valid email address'
        arrayOfErr["emailErrorMsg"] = error;
        $('#emailErrorMsg').show();
        $('#emailErrorMsg').text(error);  
    }else{
        $('#emailErrorMsg').hide();
    }
}

// check for empty
function isEmpty(field, data){
    var error = "";
    
    if (data === ''|| data === null || data === undefined) {
        error = "You didn't enter "+field+".";
        if(field == 'First Name'){
            arrayOfErr["fnameError"] = error;
            $('#fnameError').show();
            $('#fnameError').text(error);
        }else if(field == 'Last Name'){
            arrayOfErr["lnameError"] = error;
            $('#lnameError').show(); 
            $('#lnameError').text(error);
        }else if(field == 'Password'){
        	arrayOfErr["passwordErrorMsg"] = error;
        	$('#passwordErrorMsg').show();
            $('#passwordErrorMsg').text(error);
        
        }else{
            arrayOfErr["emailErrorMsg"] = error;
            $('#emailErrorMsg').show();
            $('#emailErrorMsg').text(error);
        }
    } 
}
