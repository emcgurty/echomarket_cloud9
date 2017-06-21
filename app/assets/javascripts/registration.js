$(document).ready(function ($) {

// size_of_menu();
//    $(window).resize(function () {
//        size_of_menu();
//    })
//    
    $('select').on('change', function () {
//        alert("select change");
    });
    $('input').on('change', function () {

    });
   

});

//function size_of_menu() {
//    
//    var nav_menu = $("div#nav").css("width");
//
//    $("div.application_footer").css("width", nav_menu);
//    
//    return true;
//}


function getChildID(parentID) {
    var child_id = null;
    child_id = parentID.replace('rb:', '');
    var lastColon = child_id.lastIndexOf(":");
    if (lastColon > 0) {
        var lengthOfSelectId = child_id.length;
        child_id = child_id.substring(lastColon + 1, lengthOfSelectId);
    }
    return child_id;
}

