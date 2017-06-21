$(document).ready(function () {

     $("[name^='participant[community]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='community_changed']");   
      foundItemChangedHidden.val(1);

      });
      

   $("[name^='participant[participant]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='participant_changed']");   
      foundItemChangedHidden.val(1);

      });
      
    $("[name^='participant[user]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='user_changed']");   
      foundItemChangedHidden.val(1);

      });
      
      $("[name^='participant[contact_preference]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='preference_changed']");   
      foundItemChangedHidden.val(1);

      });
      
       $("[name^='participant[lender_transfer]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='transfer_changed']");   
      foundItemChangedHidden.val(1);

      });
 
       $("[name^='participant[lender_item_condition]']").change(function() {
      var foundItemChangedHidden = $("input[type=hidden][id*='condition_changed']");   
      foundItemChangedHidden.val(1);

      });
 
});

 
   function displayUserDetailDivs(input) {
     event.preventDefault();
     $(".user_detail").hide();  
     var whichDiv = ".user_detail#" + input  ;
     $(whichDiv).show();
     
  }     
      
 