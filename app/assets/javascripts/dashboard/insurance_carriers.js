$(document).on('ready page:load', function (event) {

	$("#validate_new_insurance_carrier").validate({
		errorElement: "span",
		rules: {
			'insurance_carrier[name]': {
				required: true,
				remote: {
					url: '/insurance_carriers/checkUniqueSignName/?id='+$('#insurance_carrier_name').attr('data-InsuranceCarrierId'),
					type: 'post'
				}				
			},
			'insurance_carrier[address_attributes][zipcode]': {
				minlength: 4,
				maxlength: 5,
				digits: true,
				number: true
			},			
			'insurance_carrier[contact_attributes][phone1_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			}			
		},
		messages: {
			'insurance_carrier[name]': {
				required: "Name can't be blank!",
				remote: 'Name already present.'
			},
			'insurance_carrier[contact_attributes][phone1_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			},
			'insurance_carrier[contact_attributes][zipcode]': {
				number: 'Only number allow.',
				digits: 'Only number allow',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'				
			}
		}
	})

});