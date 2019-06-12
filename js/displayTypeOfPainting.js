//This is used to get all the painting type
function getAllPaintingType(){

    $.ajax({
        url:  `${baseUrl}/controller/paintingTypeController.cfm` ,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
       
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
            populatePaintingTypeList(response);             
        },
        error: function( error) {
           
        }             
    });
}

//this is used for populating painting type list
function populatePaintingTypeList(response){
    //var list =[];
    for(var i=0; i<response.length;i++){
        var listRow = ' <label for="one">'+
                  '<input name="paintingList" type="checkbox" id="'+response[i].PAINTING_TYPE_ID+"_paintingType"+ '"value="' +response[i].PAINTING_NAME+ '" />' 
                  +response[i].PAINTING_NAME+ '</label>';
        $("#checkboxes").append(listRow);
    }
}

var expanded = false;

function showCheckboxes() {
    var checkboxes = document.getElementById("checkboxes");
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
    var container = $("#checkboxes");
    if (!container.is(e.target) && container.has(e.target).length === 0) 
    {
        container.hide();
    }
});
