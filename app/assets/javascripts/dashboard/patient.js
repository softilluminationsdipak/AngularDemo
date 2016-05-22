
$(document).on('ready page:load', function (event) {

	$(".patient_category").change(function(event){
		$(".category_patient").val($(this).val());
	})


	$("#validate_new_patient").validate({
		errorElement: "span",
		rules: {
			'patient[contact_attributes][last_name]': {
				required: true
			},
			'patient[contact_attributes][first_name]': {
				required: true
			},
			'patient[overdue_fee_percentage]': {
				digits: true,
				number: true,
				maxlength: 2
			},
			'patient[contact_attributes][phone2_ext]': {
				digits: true,
				number: true,
				maxlength: 1
			},
			'patient[employer_address_attributes][zipcode]': {
				digits: true,
				number: true,
				maxlength: 5
			},
			'patient[address_attributes][zipcode]': {
				digits: true,
				number: true,
				maxlength: 5
			}
		},
		messages: {
			'patient[contact_attributes][last_name]': {
				required: "Last name can't be blank"
			},
			'patient[contact_attributes][first_name]': {
				required: "First name can't be blank"
			},
			'patient[overdue_fee_percentage]': {
				digits: "Only number",
				number: "Only number",
				maxlength: "Only 2 digit allow"
			},
			'patient[contact_attributes][phone2_ext]': {
				digit: 'Only number',
				number: 'Only number',
				maxlength: 'Only 1 digit'
			},
			'patient[employer_address_attributes][zipcode]': {
				digit: 'Only number allow',
				number: 'Only number allow',
				maxlength: 'Allow upto 5 digit'
			},
			'patient[address_attributes][zipcode]': {
				digit: 'Only number allow',
				number: 'Only number allow',
				maxlength: 'Allow upto 5 digit'				
			}
		}

	});

});