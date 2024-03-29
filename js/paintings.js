var c = 0;
var paintingList = [];
var counter = 0;
var totalPageNo = 0;
var imageName = "";
$(document).ready(function() {

    //showPaintings("loadMore",0);  
    getCountOfPaintings();

    if(totalPageNo <= 0){
        totalPageNo = 1;
        $('#pagination-demo').hide();
    }else{
        $('#pagination-demo').show();
    }

    bindPagination();
    
    $('input[name=publicOrPrivate]').change( function(){
        var id = $(this).attr('id');
        setPublicOrprivate(id);
    });

    $("#saveImage").click(function(event) {

        event.preventDefault();
        $('#imageUploadError').hide();
        var form = $('#uploadimage')[0];
        var data = new FormData(form);
        counter = 0;
        uploadPaintings(data);
        bindPagination();
    }); 

    //binds to onchange event of your input field
     $('#file').bind('change', function() {

        ValidateSingleInput(this);

        //this.files[0].size gets the size of your file.
       var size = this.files[0].size ;
       if( size> 800 * 1024 ){
           //swal("please upload image lesser then 800kb");
           $('#imageUploadError').show();
           $('#imageUploadError').text("please upload image lesser then 800kb");
       }
    
    });

});

//This is used for handling the pagination
function bindPagination(){

$('#pagination-demo').twbsPagination('destroy');

    $('#pagination-demo').twbsPagination({
        totalPages: totalPageNo,
        visiblePages: 3,
        onPageClick: function (event, page) {
            var type = "loadMore";
            showPaintings(type,page);
        }
    });
}

// This is used to bind delete and preview of image ( for the pusrpose of auto refresh).
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
                    bindPagination();
                    swal("Poof! Your painting pic has been deleted!", {
                        icon: "success",
                    });
                } else {
                    swal("Your file is safe!");
                }
            });
    });
}

// This is used to fetch all the painting of a particular artist
function showPaintings(type,pageNo){

    if(type=="loadMore"){
        var limit = 4;
        counter = pageNo * limit - limit ;
        if(pageNo == 0){
            counter = 0;
        }
        urlVar = `${baseUrl}/controller/paintingcontroller.cfm?action=paginationForAllPainting&counter=${counter}`;
    }
    if(type=="upload"){
        counter = 0;
        urlVar = `${baseUrl}/controller/paintingcontroller.cfm?action=paginationForAllPainting&counter=${counter}`;
    }
    $.ajax({
        url:  urlVar,
        type: "GET",
        crossDomain: true,
        data: {},
        async: false,
        headers: {   "Content-Type": "application/json" },
        success: function (response) {
            response = JSON.parse(response);
            if(!response.length){
                //$('#msgDiv').show();
                //$('#paintingsDiv').hide();
            }else{
                //$('#msgDiv').hide();
                //$('#paintingsDiv').show();
            }
            if(response.length){

                for(var i=0; i<response.length; i++){
                    if(JSON.stringify(paintingList).indexOf(JSON.stringify(response[i])) === -1){
                        paintingList.push(response[i]);
                    }
                }
               $('#imgDiv').empty();
               getCountOfPaintings();
               setAllPaintings(response);
            }         
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
            '<img style="height:200px;width:300px" class="thumbnail img-responsive" alt="opps!! imgae is not loaded"'+
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
            if(response=="true "){
                swal("Poof! Your painting pic has been deleted!", {
                    icon: "success",
                });
                $('#imgDiv').empty();
                var type = "loadMore";
                var pageNo = 1;
                showPaintings(type,pageNo);
                for(var i=0; i<paintingList.length; i++){
                    if(paintingList[i].MEDIA_ID == id){
                        paintingList.splice(i,1);
                    }
                }
            } else{
                swal("Error deleting profile pic");
            }
        },
        error: function( ) {},
        complete: function () {
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
            if(response == "true "){
                swal("painting uploaded successfully");
                var type = "upload";
                getCountOfPaintings();
                hideLoader();
            }else{
                response = JSON.parse(response);
                $('#imageUploadError').show();
                $('#imageUploadError').text(response.FILESIZE);
                $('#imageUploadError').text(response.FILETYPE);  
            }
        },
        error: function(error) {    
            $('#imageUploadError').text(error.responseJSON.message)
        },
        complete: function () {
        
            paintingList=[];
            hideLoader();
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
            if(response>4){
                $('#pagination-demo').show();
            }
            calculateTotalPageNo(response);
        },
        error: function( ) {
        }         
    });
}

//This is used to get the total page number to show the paintings
function calculateTotalPageNo(countOfPainting){

    var remainder = countOfPainting % 4;
    if( remainder==1 || remainder == 2 || remainder == 3){
        totalPageNo = Math.floor( countOfPainting / 4 + 1 );
    }else{
        totalPageNo = countOfPainting / 4;
    }
}

//This is used for file type validation
var _validFileExtensions = [".jpg", ".jpeg", ".png"];    
function ValidateSingleInput(oInput) {
    if (oInput.type == "file") {
        var sFileName = oInput.value;
        imageName = sFileName;
        extractImageName(imageName);
         if (sFileName.length > 0) {
            var blnValid = false;
            for (var j = 0; j < _validFileExtensions.length; j++) {
                var sCurExtension = _validFileExtensions[j];
                if (sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                    blnValid = true;
                    break;
                }
            }
             
            if (!blnValid) {
                //swal("Sorry, this file is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
                $('#imageUploadError').show();
                $('#imageUploadError').text("Sorry, this file is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
                oInput.value = "";
                return false;
            }
        }
    }
    return true;
}

function hideErr(){
    $('#imageUploadError').hide();
}

// This is used to extarct image name from complete fath
function extractImageName(fullPath){

    var index = imageName.lastIndexOf("\\");
    imageName = fullPath.substr(index+1,fullPath.length);
    $("#imageName").val(imageName);
}