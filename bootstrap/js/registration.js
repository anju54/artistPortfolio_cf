$(document).ready(function() {

    $("#submitbtn").click(function() {

        var fnameVal = $('#fname').val();
        var lnameVal = $('#lname').val();
        var emailVal = $('#email').val();
    
        var data = {
            "fname": fnameVal,
            "lname": lnameVal,
            "email": emailVal
        };
        data = JSON.stringify(data);
    
        /*
            ajax call for post request to save the user information in user table
        */
        $.ajax({
            url: `${baseUrl}/api/admin/user`,
            type: "POST",
            crossDomain: true,
                xhrFields : {
            withCredential : true
        },
            data: data,
            headers: {
                "Content-Type": "application/json",
            }
        });

    });   

});