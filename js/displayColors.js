
//This is used to fetch all the colors
function getAllColors(token){

    $.ajax({
        url:  `${baseUrl}/controller/colorController.cfm` ,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization','Bearer '+token);
        },
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            
            var data = JSON.parse(response);
            populateColorsList(data);             
        },
        error: function( error) {
        }             
    });
}

//This is used for creating color dropdown list
function populateColorsList(response){

    for(var i=0; i<response.length;i++){
        var listRow = '<option value='+response[i].COLOR_NAME+ '>' +response[i].COLOR_NAME+'</option>';        
        $("#bgcol").append(listRow);
    }
}

var expanded = false;

function showCheckboxesForColrs() {
    var checkboxes = document.getElementById("checkboxesColors");
    if (!expanded) {
    checkboxes.style.display = "block";
    expanded = true;
    } else {
    checkboxes.style.display = "none";
    expanded = false;
    }
}   
$(document).mouseup(function(e) 
{
    var container = $("#checkboxesColors");
    if (!container.is(e.target) && container.has(e.target).length === 0) 
    {
        container.hide();
    }
});
