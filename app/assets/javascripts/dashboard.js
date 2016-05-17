// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require dashboard/modernizr.custom.js
//= require dashboard/matchMedia.js
//= require dashboard/jquery.js
//= require jquery_ujs
//= require dashboard/bootstrap.js
//= require dashboard/jquery.storageapi.js
// require login/parsley.min.js
//= require dashboard/jquery.easing.js
//= require dashboard/animo.js
//= require dashboard/jquery.slimscroll.min.js
//= require dashboard/screenfull.js
//= require dashboard/jquery.localize.js
//= require dashboard/demo-rtl.js
//= require dashboard/index.js
//= require dashboard/jquery.flot.js
//= require dashboard/jquery.flot.tooltip.min.js
//= require dashboard/jquery.flot.resize.js
//= require dashboard/jquery.flot.pie.js
//= require dashboard/jquery.flot.time.js
//= require dashboard/jquery.flot.categories.js
//= require dashboard/jquery.flot.spline.min.js
//= require dashboard/jquery.classyloader.min.js
//= require dashboard/moment-with-locales.min.js
//= require dashboard/demo-flot.js
//= require dashboard/jquery.validate.js
//= require dashboard/jquery.inputmask.bundle.js
//= require dashboard/bootstrap-datetimepicker.min.js
//= require dashboard/select2.js
//= require dashboard/app.js
//= require jquery_nested_form
//= require dashboard/clinics.js
//= require turbolinks


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

// Functions for clinic modules
function sameAsServiceLocation(checkBox){
	if($("#clinic_same_as_service_location").is(':checked') == true  ){
		$("#clinic_billing_address_attributes_street").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_street2").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_city").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_state").attr('disabled', 'disabled')
		$("#clinic_billing_address_attributes_zip").attr('disabled', 'disabled')
	}else{
		$("#clinic_billing_address_attributes_street").removeAttr('disabled')
		$("#clinic_billing_address_attributes_street2").removeAttr('disabled')
		$("#clinic_billing_address_attributes_city").removeAttr('disabled')
		$("#clinic_billing_address_attributes_state").removeAttr('disabled')
		$("#clinic_billing_address_attributes_zip").removeAttr('disabled')		
	}
}
