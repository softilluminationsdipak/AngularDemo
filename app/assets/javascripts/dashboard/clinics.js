$(document).on('ready page:load', function (event) {
  $("#all_insurance_carrier_assignment_policy").change(function(){
    $(".insurance_carrier_assignment_policy").prop('checked', $(this).prop("checked"));
  });  
});
