// this method is used to map the logout feature
$(document).ready(function() {

    $("#logout").click(function(event) {
    	logout(); 
    }); 
    
 });

 //This is used for calling the ajax call for logout
function logout(){
    
    $.ajax({
        url: `${baseUrl}/controller/logoutController.cfm`,
        type: "GET",
        crossDomain: true,
        'async': false,
        success: function (result) {
            
            swal("successfuly logout from the application");
            $('#logout').attr("href","../views/index.html");
            window.location.href = '../views/index.html';
        } 
    });   
}