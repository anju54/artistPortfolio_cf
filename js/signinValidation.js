// This is used for validating the sigin form
function validate(){
    
    var password = $('#password').val();
    var emailVal = $('#email').val();
   
    if( validateEmail(emailVal) && validatePassword(password)) {
        return true;

    } else return false;
}

// check for password
function validatePassword(Password) {
    
    var error = "";
    if(!isEmpty("Password", Password)){
        return false;
    }
    var passw = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
    if(Password.match(passw)) { 
        $('#passwordError').hide();
        return true;
    } else{ 
        $('#passwordError').show();
        var error = 'Wrong password ...!  it should contain 6 to 20 characters which contain '+
        'at least one numeric digit, one uppercase and one lowercase letter';
        $('#passwordError').text(error);
        return false;
    }
}

// check for email
function validateEmail(email){

    if(!isEmpty("email", email)){
        return false;
    }
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (!reg.test(email)) {
        $('#emailError').show();
        $('#emailError').text("please provide valid email address");
        return false;
    }
    return true;
}

// check for empty
function isEmpty(field, data){
    var error = "";
    if (data === ''|| data === null || data === undefined) {
        error = "You didn't enter "+field+".";
        
        if(field=="email"){
            $('#emailError').text(error);
        }else if(field=="Password"){
            $('#passwordError').text(error);
        }
        return false;
    } 
    return true;
}
