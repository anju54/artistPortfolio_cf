function showLoader() {
    
    var div= document.createElement("div");
    div.className += 'overlay';
    div.id += 'overlay';
    document.body.appendChild(div);
    var div = '<div id="loader"><img id="loader-img" src="../assets/images/loader.gif"/></div>';
    $('#overlay').append(div);
}

function hideLoader(){
    $('#overlay').remove();
}