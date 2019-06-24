var c = 0;
var paintingList = [];
var counter = 0;
var countVal = 0;
$(document).ready(function() {

    showPaintings("loadMore");   
    $('#loadMore').click(function () {
        var type = "loadMore";
        showPaintings(type);
    });

    $('input[name=publicOrPrivate]').change( function(){
        var id = $(this).attr('id');
        setPublicOrprivate(id);
    });

    $("#saveImage").click(function(event) {

        event.preventDefault();

        var form = $('#uploadimage')[0];
        var data = new FormData(form);
        counter = 0;
        uploadPaintings(data);
    }); 

});

function bindEvent(){

    $('#imgDiv img').click(function(){
        var source = $(this).attr('src');
        imagePreview(source);
     });

     $('input[name=publicOrPrivate]').change( function(){
        var id = $(this).attr('id');
        setPublicOrprivate(id);
    });

     $(".deleteBtn").click(function () {
        swal({
            title: "Are you sure?",
            text: "Once deleted, you will not be able to recover",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
                if (willDelete) {
                    var id = this.id;
                    deletePainting(id);
                    swal("Poof! Your painting pic has been deleted!", {
                        icon: "success",
                    });
                } else {
                    swal("Your file is safe!");
                }
            });

            // var id = this.id;
            // deletePainting(id);
    });
}

// This is used to fetch all the painting of a particular artist
function showPaintings(type){
    
    if(type=="loadMore"){
        urlVar = `${baseUrl}/controller/paintingcontroller.cfm?action=paginationForAllPainting&counter=${counter}`;
    }
    if(type=="upload"){
        counter = 0;
        urlVar = `${baseUrl}/controller/paintingcontroller.cfm?action=displayLastUploadedImage`;
    }
    $.ajax({
        url:  urlVar,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            response = JSON.parse(response);
            getCountOfPaintings();
            if(response.length){

                for(var i=0; i<response.length; i++){
                    if(JSON.stringify(paintingList).indexOf(JSON.stringify(response[i])) === -1){
                        paintingList.push(response[i]);
                    }
                }
               $('#imgDiv').empty();
              
                setAllPaintings(response);
                if(type=="loadMore"){
                    counter = counter + 4;
                }
                    
                $('#loadMore').show(); 
            } else if(counter == 0){
                swal("There are No paintings!");
            } else {
                swal("There are No paintings!");
                $('#loadMore').hide();
            }
            //bindEvent();          
        },
        error: function( error) {  
        }             
    });
     
}

// This is used to create img tag for displaying painting
function setAllPaintings(response){
    
    for(var i=0; i<response.length;i++){

		var divid; 
        if (i%2 === 0) {
            divid= 'row'+c;
            c++;
            var row = '<div class="row" id="'+divid+'"></div>';
            $('#imgDiv').append(row);
        }

        var col =  '<div class=col-md-5>'+
        '<div class = "well">'+
            '<img style="height:200px" class="thumbnail img-responsive" alt="opps!! imgae is not loaded"'+
                'src="'+baseUrl + response[i].PATH_THUMB + response[i].FILENAME +'" />'+
                '<input type="checkbox" name="publicOrPrivate" class="form-check-input" id="'+response[i].MEDIA_ID+"_isPublic"+'">Public?'+
                '<button class="btn btn-success deleteBtn" id="'+response[i].MEDIA_ID+ '"'+
                '">Delete</input>';
                '</div></div>';
                
        $('#'+divid).append(col);
        var isPublic = response[i].IS_PUBLIC;
        if(isPublic=='true'){
            $('#'+response[i].MEDIA_ID+'_isPublic').prop('checked',true);
        } else $('#'+response[i].MEDIA_ID+'_isPublic').prop('checked',false);
    }
    bindEvent();
}

// This is used to preview when user hover the image to see the full image
function imagePreview(source){
    var source1 = source; 
    var index = source.indexOf('thumb');
    source = source.substring(0,index)+source1.substring(index+5);
    var div= document.createElement("div");
    div.className += 'over';
    div.id += 'over';
    document.body.appendChild(div);
    var div = '<div class="container" id="prev"><img style="max-height:500px;" id="prev-img" src="'+source+'"/>'+
    '<span style=color: white;><button id="closePrev" class="btn btn-primary" onClick="closePreview();">Close</button></span></div>';
    $('#over').append(div);
}

// This is used for closing the preview option
function closePreview(){
    $('#over').remove();
}

//This is used to set public or private the images 
function setPublicOrprivate(id){

    var isPublic;
    
    if ( $('#'+id).is(":checked")){
            isPublic = "true";
    }else{
            isPublic = "false";
    }
    var i = id.indexOf("_");
    var mediaId =  id.substring(0,i);

    $.ajax({
        url:  `${baseUrl}/controller/paintingController.cfm?action=setIspublicOrprivate&mediaId=${mediaId}&isPublic=${isPublic}` ,
        type: "POST",
        crossDomain: true,
        data: {},
        async: false,
       
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {     
        },
        error: function( error) {
        }             
    });
}

// This is used to delete the painting
function deletePainting(id){

    $.ajax({
        url:  `${baseUrl}/controller/paintingcontroller.cfm?action=deletePainting&id=${id}` ,
        type: "Get",
        crossDomain: true,
        data: {},
        async: false,
       
        success: function (response) {
              
        },
        error: function( ) {
        },
        complete: function () {

            $('#imgDiv').empty();
            counter = 0;
            var type = "loadMore";
            showPaintings(type);
            for(var i=0; i<paintingList.length; i++){
                if(paintingList[i].MEDIA_ID == id){
                    
                    paintingList.splice(i,1);
                }
            }
            //setAllPaintings(paintingList);
            //bindEvent();
        }         
    });
}


 
 //This is used for making ajax call for uploading painting
 function uploadPaintings(file){

    $('#imageUploadError').text('');
    showLoader();
    $.ajax({

        url:  `${baseUrl}/controller/paintingcontroller.cfm?action=uploadpainting` ,
        type: "POST",
        enctype: "multipart/form-data",
        crossDomain: true,
        processData: false,  // it prevent jQuery form transforming the data into a query string
        contentType: false,
        data: file,
        async:false,
        success: function (response) {
           swal("painting uploaded successfully");
           var type = "upload";
           showPaintings(type);
           hideLoader();
        },
        error: function(error) {    
            $('#imageUploadError').text(error.responseJSON.message)
        },
        complete: function () {
        
            paintingList=[];
            //showPaintings();
            hideLoader();
            bindEvent();
            $('#file').val('');
        }       
    });
    
 }

// This is used to get the count of painting present by artist id.
function getCountOfPaintings(){

    $.ajax({
        url:  `${baseUrl}/controller/paintingcontroller.cfm?action=countPainting` ,
        type: "GET",
        crossDomain: true,
        async:false,
        headers: {
            "Content-Type": "application/json",
        },
        success: function (response) {
            countVal = response;
            
        },
        error: function( ) {
        }         
    });
}