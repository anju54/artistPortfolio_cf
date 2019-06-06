// this is used to reset the old password and save the new password
$(document).ready(function() {

    var token = getUrlParameter('token');
    var id = getUrlParameter('id');
    
    $("#setPassword").click(function() {

    var newPswrdVal = $('#newPassword').val();
    var confirmPswrdVal = $('#confirmPassword').val();

    if(validate()){

        if(confirmPswrdVal != newPswrdVal){
            $('#error').show();
            $('#error').text("new password and confirm password are not matched!!");
        } else{
            var data = { "password" : newPswrdVal };
            data = JSON.stringify(data);  
            setPassword(data,id,token);
        }
    }      
});

});

// method used to set new password 
function setPassword(data,id,token){

    $.ajax({
        url: `${baseUrl}/api/user/set_password/valid?token=${token}&id=${id}`, 
        type: "POST",
        crossDomain: true,
        data: data,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            $('#successMsg').show();
            $('#successMsg').text("New password has been created!! now you can login.")
            location.href=('./signin.html')            
        }
            
    });
}

// method to get url parameter
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),sParameterName,i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};

function hideErrorTag(){
    $('#error').hide();
}

// used for validating the form
function validate(){
    
    var newPswrdVal = $('#newPassword').val();
    var confirmPswrdVal = $('#confirmPassword').val();

    if( validatePassword(newPswrdVal) && validatePassword(confirmPswrdVal) ) {
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
       $('#error').show();
       var msg = ('Wrong password ...!  it should contain 6 to 20 characters which contain at'+ 
        'least one numeric digit, one uppercase and one lowercase letter');
        $('#error').text(msg);
        return false;
    }
}

// check for empty
function isEmpty(field, data){

    var error = "";
    if (data === ''|| data === null || data === undefined) {
        $('#error').show();
        error = "You didn't enter "+field+".";
        $('#error').text(error);
        return false;
    } 
    return true;
}
