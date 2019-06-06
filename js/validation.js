//This is used for validating the signup page
function validate(){
    
    var password = $('#password').val();
    var fname = $('#fname').val();
    var lname = $('#lname').val();
    
    
    var email = $('#email').val();
   // var userType = $("input[name='userType']:checked").val();

    if( isEmpty("First Name",fname) 
        && isEmpty("Last Name", lname)  && validateEmail( email) && validatePassword(password)  ) {
        return true;

    } else return false;
}

// check for password
function validatePassword(password) {
    
    var error = "";
    if(!isEmpty("Password", password)){

        return false;
    }
    var passw = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
    if(password.match(passw)) { 
        
        return true;
    } else{ 
    	 $('#passwordErrorMsg').show();
        $('#passwordErrorMsg').text('Wrong password ...!  it should contain 6 to 20 characters which contain at'+ 
        'least one numeric digit, one uppercase and one lowercase letter');
        return false;
    }
}

// check for email
function validateEmail(email){
    if(!isEmpty("email", email)){
        $('#emailErrorMsg').show();
        return false;
    }
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (!reg.test(email)) {
        $('#emailErrorMsg').show();
        $('#emailErrorMsg').text('Please provide a valid email address');
        return false;
    }else{
        $('#emailErrorMsg').hide();
    }

    return true;
}

// check for empty
function isEmpty(field, data){
    var error = "";
    
    if (data === ''|| data === null || data === undefined) {
        error = "You didn't enter "+field+".";
        if(field == 'First Name'){
            $('#fnameError').show();
            $('#fnameError').text(error);
        }else if(field == 'Last Name'){
            $('#lnameError').show(); 
            $('#lnameError').text(error);
        }else if(field == 'Password'){
        	
        	$('#passwordErrorMsg').show();
            $('#passwordErrorMsg').text(error);
        
        }else{
            $('#emailErrorMsg').show();
            $('#emailErrorMsg').text(error);
        }
        return false;
    } 
    return true;
}
