$(document).ready(function () {

  if ($("input[id$='organization_name']").val()) {
    $("div[id$='yesNoOrganization']").css("display", "block");
  }

  var contactAddressCheck = $("input");
  findContactAddressValue(contactAddressCheck);
  function findContactAddressValue(cad) {
    var foundValue = 0;
    var y_n = 0;
    for (var i = 0; i < cad.length; i++) {
      var id = cad[i].id;
      if (cad[i].checked == true) {
        if (id.includes('useWhichContactAddress')) {
          if ((id.includes('1')) || (id.includes('2'))) {
            $("div[id$='buildAlternativeAddress']").css("display", "block");
            foundValue++;
          }
        }
      }

      if (id.includes('thirdPartyPresenceL2b')) {

        if (id.includes('0')) {
          $("div#thirdPartyPresenceL2BGroup").css("display", "block");

          foundValue++;
        }
      }
      if (id.includes('thirdPartyPresenceB2l')) {
        if (id.includes('0')) {
          $("div#thirdPartyPresenceB2lGroup").css("display", "block");

          foundValue++;
        }
      }

      if (foundValue == 4) {
        break;
      }
    }
  }

  function validateSelects(input) {
    // Need to utilize include() here
    $("span.error-message").css("visibility", "hidden");
    var returnResult = false;
    var select_value = input.value;
    var select_id = input.id;
    //        On database all 'Please select' have value -2
    if (select_value == -2) {

      $("span#" + select_id + ".error-message").css("visibility", "visible");
      $("span#" + select_id).text("Please make a selection.");
    } else {
      $("span#" + select_id + ".error-message").css("visibility", "hidden");
      $("span#" + select_id).text("");
      returnResult = true;
    }

    if ((select_id == 'contact_describe_id') && (select_value == '10')) {
      $("div#otherDescribeYourselfText").css("display", "block");
    } else {
      $("input#otherDescribeYourself").html("");
      $("div#otherDescribeYourselfText").css("display", "none");
    }

    if ((select_id == 'category_id') && (select_value == 0)) {
      $("div#other_category").css("display", "block");
    } else if ((select_id == 'category_id') && (select_value == -2)) {
      $("span#" + select_id + ".error-message").css("visibility", "visible");
      $("span#" + select_id + ".error-message").text("Please make a selection.");
      $("input#otherItemCategory").text("");
      $("div#other_category").css("display", "none");
    } else if ((select_id == 'category_id') && (select_value > 0)) {
      $("span#" + select_id + ".error-message").css("visibility", "hidden");
      $("span#" + select_id + ".error-message").text("");
      $("input#other_item_category").text("");
      $("div#other_category").css("display", "none");
    }

    if ((select_id == 'us_state_id') && (select_value != '-2')) {

      $("select[id$='country_id']").val("US");
    }
    
    return returnResult;
  }


  $('select').on('change', function () {
    validateSelects(this);
  });
  
  $('input').on('change', function () {

    var y_n = null;
    var getOrgNameVal = null;
    if (this.id.includes('useWhichContactAddress')) {
      y_n = $(this).val();
      if ((y_n == 1) || (y_n == 2)) {
        $("div#buildAlternativeAddress").css("display", "block");
      } else {
        $("div#buildAlternativeAddress").css("display", "none");
      }
    } else if (this.id.includes('thirdPartyPresenceL2b')) {
      y_n = $(this).val();

      if (y_n == 1) {
        $("div#thirdPartyPresenceL2BGroup").css("display", "block");
      } else {
        $("div#thirdPartyPresenceL2BGroup").css("display", "none");
      }
    } else if (this.id.includes('thirdPartyPresenceB2l')) {
      y_n = $(this).val();

      if (y_n == 1) {
        $("div#thirdPartyPresenceB2lGroup").css("display", "block");
      } else {
        $("div#thirdPartyPresenceB2lGroup").css("display", "none");
      }

    } else if (this.id.includes('displayBorrowerOrganizationName')) {
      y_n = $(this).val();
      try {
        getOrgNameVal = $("input[class='org_name']").val();
      } catch (err) {

      }

      if ((y_n == 1) && (getOrgNameVal == "")) {
        $("span#organizationName.error-message").css("visibility", "visible");
        $("span#organizationName.error-message").text("Please provide an organization name.");
      } else {
        $("span#organizationName.error-message").text("");
        $("span#organizationName.error-message").css("visibility", "hidden");
      }
    } else if (this.id.includes('display_home_phone')) {
      y_n = $(this).val();
      try {
        var getHomePhone = $("input[class='home_phone']").val();
      } catch (err) {

      }

      if ((y_n == 1) && (getHomePhone == "")) {
        $("span#home_phone.error-message").css("visibility", "visible");
        $("span#home_phone.error-message").text("Please provide your Home Phone.");
      } else {
        $("span#home_phone.error-message").text("");
        $("span#home_phone.error-message").css("visibility", "hidden");
      }
    } else if (this.id.includes('display_cell_phone')) {
      y_n = $(this).val();
      try {
        var getCellPhone = $("input[class='cell_phone']").val();
      } catch (err) {

      }

      if ((y_n == 1) && (getCellPhone == "")) {
        $("span#cell_phone.error-message").css("visibility", "visible");
        $("span#cell_phone.error-message").text("Please provide your Cell Phone.");
      } else {
        $("span#cell_phone.error-message").text("");
        $("span#cell_phone.error-message").css("visibility", "hidden");
      }
    } else if (this.id.includes('display_alternative_phone')) {
      y_n = $(this).val();
      try {
        var getAlternativePhone = $("input[class='alternative_phone']").val();
      } catch (err) {

      }

      if ((y_n == 1) && (getAlternativePhone == "")) {
        $("span#alternative_phone.error-message").css("visibility", "visible");
        $("span#alternative_phone.error-message").text("Please provide your Alternative Phone.");
      } else {
        $("span#alternative_phone.error-message").text("");
        $("span#alternative_phone.error-message").css("visibility", "hidden");
      }


    } else if (this.id.includes('organization_name')) {
      $("div#yesNoOrganization").css("display", "block");
    } else if (this.id.includes('item_count')) {

      if (isNaN(this.value)) {
        $("span#item_count.error-message").css("visibility", "visible");
        $("span#item_count.error-message").text("Please provide an item count");
      } else {
        $("span#item_count.error-message").text("");
        $("span#item_count.error-message").css("visibility", "hidden");
      }

    } else if (this.id.includes('item_description')) {

      if (this.value == '') {
        $("span#item_description.error-message").css("visibility", "visible");
        $("span#item_description.error-message").text("Please provide an item description");
      } else {
        $("span#item_description.error-message").text("");
        $("span#item_description.error-message").css("visibility", "hidden");
      }
//
    } else if (this.id.includes('uploaded_picture')) {
        displayImage(this);
//
    } else {
      return false;
    }

  });
  function displayImage(input) {

    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        var imagePreviewID = $("img[id$=imagePreview]");
        imagePreviewID.attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }

  }

});

function validateItemDashBoard() {
  
  // get new item div that's visible
  //alert('in item dash');
  var i_return_value = true;
  var p_return_value = true;
  var t_return_value = true;
  var c_return_value = true;
  var getVisibleDiv = $("div.new_item");
  var i_changed = $("input[type=hidden][id*='item_changed']");
  var p_changed = $("input[type=hidden][id*='preference_changed']");
                  $("input[type=hidden][id*='preference_changed']");   
  var t_changed = $("input[type=hidden][id='transfer_changed']");   
  var c_changed = $("input[type=hidden][id='condition_changed']"); 
  
  for (var i = 0; i < getVisibleDiv.length; i++) {
  
  if (getVisibleDiv[i].id == 'new' && i_changed.val() == 1) {
    //alert("new - 1");
    i_return_value = validateItem();
  }
  
  if (getVisibleDiv[i].id == 'preference'  && p_changed.val() == 1) {
     //alert("p - 1");
     p_return_value = validateCP();
  }
  
  if (getVisibleDiv[i].id == 'transfer'  && t_changed.val() == 1) {
     //alert("t` - 1");
     t_return_value = validateTransfer();
  }
  
  if (getVisibleDiv[i].id =='condition'  && c_changed.val() == 1) {
    //alert("c - 1");
    c_return_value = validateCondtion();
  }
  
  }
  
  return (i_return_value || p_return_value || t_return_value || c_return_value); 
  
}

function validateTransfer() {
  
  var result_result = true;
  return result_result;
  
}

function validateCondtion() {
  
  var result_result = true;
  return result_result;
  
}


function validateCP() {
  
  // Must choose at least one value
  var result_result = true;
  return result_result;
  
}

function validateItem() {

  
  var return_value = true;
  var item_id = null;
  var item_value = null;
  var getItemInputs = $("input[type=text].items");
  //alert(getItemInputs);
  for (var i = 0; i < getItemInputs.length; i++) {
    
    item_id = getItemInputs[i].id;
    item_id = item_id.replace('items_item_', '');
    //alert(item_id);
    item_value = getItemInputs[i].value;
    if (item_id.includes('item_count')) {
        //alert("found item Count");
      if ((isNaN(item_value)) || (item_value == '')) {
        $("span#" + item_id + ".error-message").css("visibility", "visible");
        $("span#" + item_id + ".error-message").text("Please provide an item count.");
        return_value = false;
      }

    } else if (item_id.includes('item_description')) {

      if (item_value == '') {
        $("span#" + item_id + ".error-message").css("visibility", "visible");
        $("span#" + item_id + ".error-message").text("Please provide a item description.");
        return_value = false;
      }
    } else if (item_id.includes('other_item_category')) {
      if ($("div#other_category").css("display") == 'block') {
        if (item_value == '') {

          $("span#" + item_id + ".error-message").css("visibility", "visible");
          $("span#" + item_id + ".error-message").text("Please provide your Item Category.");
          return_value = false;
        }
      }

    } else {
    }

  }

  var getItemSelect = $(".items.select");
  //alert(getItemSelect);
  for (var i = 0; i < getItemSelect.length; i++) {
    
    item_id = getItemSelect[i].id;
    //alert("select if");
    item_id = item_id.replace('items_item_', '');
    //alert(item_id);
    item_value = getItemSelect[i].value
    //alert(item_value)

    if (item_value == -2) {

      $("span#" + item_id + ".error-message").css("visibility", "visible");
      $("span#" + item_id + ".error-message").text("Please make a selection.");
      return_value = false;
    }
  }
  

     try {
       var imagePreviewID = $("img[id$=imagePreview]");
        if (imagePreviewID.attr('src').includes("images")) {
          $("span#imagePreview" + ".error-message").css("visibility", "visible");
          $("span#imagePreview" + ".error-message").text("Please upload an image of your item.");  
          return_value = false;
       }
        }
      catch(err) {
        $("span#imagePreview" + ".error-message").css("visibility", "visible");
        $("span#imagePreview" + ".error-message").text("Please upload an image of your item.");
        return_value = false;
      
     }
 
  return return_value;
}

function validateAlternativeAddress() {


  var return_value = true;
  if ($("div#buildAlternativeAddress").css("display") == 'block') {

    var item_id = null;
    var item_value = null;
    var getItemInputs = $("input[type=text].alternativeAddress");
    for (var i = 0; i < getItemInputs.length; i++) {
      item_id = getItemInputs[i].id;
      item_value = getItemInputs[i].value;
      if (item_id.includes('addressLine1')) {

        if (item_value == '') {

          $("span#" + item_id + "_alternative.error-message").css("visibility", "visible");
          $("span#" + item_id + "_alternative.error-message").text("Please provide your first Address Line.");
          return_value = false;
        }
      } else if (item_id.includes('city')) {

        if (item_value == '') {
          try {
            $("span#" + item_id + "_alternative.error-message").css("visibility", "visible");
          } catch (err) {

          }
          $("span#" + item_id + "_alternative.error-message").text("Please provide your City.");
          return_value = false;
        }
      } else if (item_id.includes('postalCode')) {

        if (item_value == '') {
          $("span#" + item_id + "_alternative.error-message").css("visibility", "visible");
          $("span#" + item_id + "_alternative.error-message").text("Please provide your Postal Code.");
          return_value = false;
        }
      } else {
      }


    }

    var getItemSelect = $(".alternativeAddress.select");
    for (var i = 0; i < getItemSelect.length; i++) {
      item_id = getItemSelect[i].id;
      item_value = getItemSelect[i].value;
      if (item_id.includes('countryId')) {
        if (item_value == -2) {
          $("span#" + item_id + "_alternative.error-message").css("visibility", "visible");
          $("span#" + item_id + "_alternative.error-message").text("Please make a selection.");
          return_value = false;
        }
      }
    }
  }
  return return_value;
}


function size_of_menu() {

  var bmw = $("ul#nav.borrower_menu").css("width");
  var lmw = $("ul#nav.lender_menu").css("width");
  var imw = $("div#index_div").css("width");
  var div_top = $("div#content.center_content").css("width");
  if (bmw) {

    $("div.borrower_registration").css("width", bmw);
    $("div.application_footer").css("width", bmw);
  } else if (imw) {

    $("div.application_footer").css("width", imw);
  } else if (lmw) {

    $("div.lender_registration").css("width", lmw);
    $("div.application_footer").css("width", lmw);
  } else {
    $("div.application_footer").css("width", div_top);
  }

  return true;
}

function ValidateContactInformation() {

  var returnValue = true;
  var foundComponent = 0;
  var cdi = null;
  var ocdi = null;
  var firstName = null;
  var lastName = null;
  var addressLine1 = null;
  var city = null;
  var postalCode = null;
  var countryId = null
  var orgName = null;
  var uid = null;
  var this_class = null;
  $("span.error-message").css("visibility", "hidden");
  $("select").each(function () {
    uid = this.id;
    this_class = $(this).attr("class");
    if (this.id.includes('contact_describe_id')) {
      cdi = this.value;
      foundComponent++;
    } else if ((this.id == 'countryId') && (this_class == 'primary')) {
      countryId = this.value;

      foundComponent++;
    } else if (foundComponent == 2) {
      return false;
    } else {
    }
  });
  foundComponent = 0;
  $("input").each(function () {
    uid = this.id;
    this_class = $(this).attr("class");
    if (uid.includes('otherDescribeYourself')) {
      ocdi = this.value;
      foundComponent++;
    } else if (uid == 'organizationName') {
      orgName = this.value;
      foundComponent++;
    } else if (uid == 'firstName') {
      firstName = this.value;
      foundComponent++;
    } else if (uid == 'lastName') {
      lastName = this.value;
      foundComponent++;
    } else if ((uid == 'addressLine1') && (this_class == 'primary')) {
      addressLine1 = this.value;
      foundComponent++;
    } else if ((uid == 'city') && (this_class == 'primary')) {
      city = this.value;
      foundComponent++;
    } else if ((uid == 'postalCode') && (this_class == 'primary')) {
      postalCode = this.value;
      foundComponent++;
    } else if (foundComponent == 10) {

      return false;
    }

  });

  if ((cdi == 100) && (ocdi == '')) {
    $("span#otherDescribeYourself.error-message").css("visibility", "visible");
    $("span#otherDescribeYourself.error-message").text("Please provide an 'Other' description");
    returnValue = false;
  }

  if (cdi == -2) {

    $("span#contact_describe_id.error-message").css("visibility", "visible");
    $("span#contact_describe_id.error-message").text("Please make a selection");
    returnValue = false;
  }

  if (countryId == -2) {
    $("span#countryId.error-message").css("visibility", "visible");
    $("span#countryId.error-message").text("Please provide your Country");
    returnValue = false;
  }

  if (firstName == '') {
    $("span#firstName.error-message").css("visibility", "visible");
    $("span#firstName.error-message").text("Please provide your First Name");
    returnValue = false;
  }

  if (lastName == '') {
    $("span#lastName.error-message").css("visibility", "visible");
    $("span#lastName.error-message").text("Please provide your Last Name");
    returnValue = false;
  }

  if (city == '') {
    $("span#city.error-message").css("visibility", "visible");
    $("span#city.error-message").text("Please provide your City");
    returnValue = false;
  }

  if (postalCode == '') {
    $("span#postalCode.error-message").css("visibility", "visible");
    $("span#postalCode.error-message").text("Please provide your PostalCode");
    returnValue = false;
  }

  if (addressLine1 == '') {
    $("span#addressLine1.error-message").css("visibility", "visible");
    $("span#addressLine1.error-message").text("Please provide your first Address Line ");
    returnValue = false;
  }

  return returnValue;
}

function displayPhone() {

  // var home_phone = null;
  // var cell_phone = null;
  // var alternative_phone = null;
  // var foundComponent = 0;
  // $("input").each(function () {
  //   if (this.id == 'rb:home_phone') {
  //   home_phone = this.value;
  //     foundComponent++;
  //   } else if (this.id == 'rb:cell_phone') {
  //     cell_phone = this.value;
  //     foundComponent++;
  //   } else if (this.id == 'rb:alternativePhone') {
  //     alternative_phone = this.value;
  //     foundComponent++;
  //   } else if (foundComponent == 3) {
  //     return false;
  //   }
  // });
  // try {
  //   if (home_phone) {
  //     $("div#display_homePhone.phone").css("display", "block");
  //   } else {
  //     $("div#display_homePhone.phone").css("display", "none");
  //   }
  // } catch (err) {
  //   $("div#display_homePhone.phone").css("display", "none");
  // }

  // try {
  //   if (cell_phone) {
  //     $("div#display_cell_phone.phone").css("display", "block");
  //   } else {
  //     $("div#display_cell_phone.phone").css("display", "none");
  //   }
  // } catch (err) {
  //   $("div#display_cell_phone.phone").css("display", "none");
  // }

  // try {
  //   if (alternative_phone) {
  //     $("div#display_alternativePhone.phone").css("display", "block");
  //   } else {
  //     $("div#display_alternativePhone.phone").css("display", "none");
  //   }
  // } catch (err) {
  //   $("div#display_alternativePhone.phone").css("display", "none");
  // }

  // if ((home_phone) || (cell_phone) || (alternative_phone)) {
  //   $("div#display_phone.div_p").css("display", "block");
  // } else {
  //   $("div#display_phone.div_p").css("display", "none");
  // }


}


function removeImage() {
  var imagePreviewID = $("img[id$=imagePreview]");
  imagePreviewID.attr('src', '');
  var imageFileInput = $("input[id$=imageFileName]");
  // imageFileInput.replaceWith( imageFileInput.val('').clone( true ) );
  // Really bad, disables ImagePreview functionality
  imageFileInput.val("");
}

