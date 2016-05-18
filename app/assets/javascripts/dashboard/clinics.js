$(document).on('ready page:load', function (event) {
  $("#all_insurance_carrier_assignment_policy").change(function(){
    $(".insurance_carrier_assignment_policy").prop('checked', $(this).prop("checked"));
  });  
});


$(document).on('ready page:load', function (event) {

	$("#validate_new_clinic").validate({
		errorElement: "span",
		rules: {
			'clinic[contact_attributes][company_name]': {
				required: true
			},
			'clinic[contact_attributes][email1]': {
				email: true
			},
			'clinic[address_attributes][zipcode]': {
				minlength: 4,
				maxlength: 5,
				digits: true,
				number: true
			},
			'clinic[contact_attributes][phone1_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			},
			'clinic[contact_attributes][phone2_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			},
			'clinic[billing_address_attributes][zipcode]':{
				minlength: 4,
				maxlength: 5,
				digits: true,
				number: true				
			}
		},
		messages: {
			'clinic[contact_attributes][company_name]': {
				required: "Clinic name can't be blank."
			},
			'clinic[contact_attributes][email1]': {
				email: 'Please enter an email address.'
			},
			'clinic[contact_attributes][phone1_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			},
			'clinic[contact_attributes][phone2_ext]': {
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'				
			}
		}
	});
	
	$('.phone_number').inputmask('(999) 999-9999')
	$('.tax_number').inputmask('999-99-9999')
});


$("#validate_new_clinic2").validate({
	errorElement: "span",
	rules: {
		'clinic[clinic_preference_attributes][overdue_fee_percentage]': {
			digits: true,
			number: true,
			minlength: 1,
			maxlength: 2
		}
	},
	messages: {
		'clinic[clinic_preference_attributes][overdue_fee_percentage]': {
			digits: 'Number Only',
			number: 'Number Only',
			minlength: 'Only 1 digit allow',
			maxlength: 'Max 2 digit allow'
		}		
	}
})

$("#validate_new_clinic3").validate({
	errorElement: "span",
	rules: {
		'clinic[clinic_preference_attributes][hcfa_top_margin]': {
			number: true
		},
		'clinic[clinic_preference_attributes][hcfa_left_margin]': {
			number: true
		}		
	},
	messages: {
		'clinic[clinic_preference_attributes][hcfa_top_margin]': {
			number: 'Number Only'
		},
		'clinic[clinic_preference_attributes][hcfa_left_margin]': {
			number: 'Number Only'
		}
	}
})


// Functions for clinic modules
function sameAsServiceLocation(checkBox){
	if($("#clinic_same_as_service_location").is(':checked') == true  ){
		$("#clinic_billing_address_attributes_street").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_street2").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_city").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_state").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_zipcode").attr('disabled', 'disabled')
	}else{
		$("#clinic_billing_address_attributes_street").removeAttr('disabled')
		$("#clinic_billing_address_attributes_street2").removeAttr('disabled')
		$("#clinic_billing_address_attributes_city").removeAttr('disabled')
		$("#clinic_billing_address_attributes_state").removeAttr('disabled')
		$("#clinic_billing_address_attributes_zipcode").removeAttr('disabled')		
	}
}

jQuery(function() {
  return $("[data-behavior='delete']").on("click", function(e) {
    e.preventDefault();
    return swal({
      title: 'Are you sure?',
      text: 'You will not be able to recover this data!',
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#DD6B55',
      confirmButtonText: 'Yes, delete it!',
      cancelButtonText: 'Cancel',
      closeOnConfirm: false,
    }, (function(_this) {
      return function(confirmed) {
        if (confirmed) {
          $.ajax({
            url: $(_this).attr("href"),
            dataType: "JSON",
            method: "DELETE",
            success: function() {
              swal('Deleted!', 'Your data has been deleted.', 'success');
              $("." + $(_this).attr('data-klass')).remove();
            }
          });
        }else {
          $(_this).html('<em class="fa fa-trash"></em> Delete')
        }
      };
    })(this));
  });
});
