$(document).ready(function () {

     // setting the default div
     $(".new_item").hide();  //css('display', 'none');
     var whichDiv = "#new";
     $(whichDiv).show();
     
     
     $("[name^='items[item]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='item_changed']");   
      foundItemChangedHidden.val(1);

      });
      
      $("[name^='items[contact_preference]']").change(function() {
          //alert("cp changed");
      var foundItemChangedHidden = $("input[type=hidden][id*='preference_changed']");   
      foundItemChangedHidden.val(1);

      });
      
       $("[name^='items[lender_transfer]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='transfer_changed']");   
      foundItemChangedHidden.val(1);

      });
    
       $("[name^='items[lender_item_condition]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='condition_changed']");   
      foundItemChangedHidden.val(1);

      });
      
});

 
   function displayNewItemDivs(input) {

     event.preventDefault();
     $(".new_item").hide();  //css('display', 'none');
     var whichDiv = "div.new_item#" + input  ;
     //alert(whichDiv);
     $(whichDiv).show();
     
  }     
      
 