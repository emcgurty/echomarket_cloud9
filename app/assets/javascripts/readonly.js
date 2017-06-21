$(document).ready(function () {

     $(".search").hide();  //css('display', 'none');
     var whichDiv = "#item";
     $(whichDiv).show();
});

 
   function displaySearchDivs(input) {

     event.preventDefault();
     $(".search").hide();  //css('display', 'none');
     var whichDiv = "div.search#" + input  ;
     $(whichDiv).show();
     
  }     
      
 