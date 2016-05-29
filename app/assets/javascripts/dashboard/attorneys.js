$(document).on('ready page:load', function (event) {

	$("#validate_new_attorney").validate({
		errorElement: "span",
		rules: {
			'attorney[contact_attributes][company_name]': {
				required: true,
				remote: {
					url: '/attorneys/checkUniqueSignName/?id='+$('#attorney_contact_attributes_company_name').attr('data-attorneyid'),
					type: 'post'
				}				
			},
			'attorney[attorney]': {
				required: true
			},			
			'attorney[address_attributes][zipcode]':{
				minlength: 4,
				maxlength: 5,
				digits: true,
				number: true
			},
			'attorney[contact_attributes][phone1_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			},
			'attorney[contact_attributes][phone2_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			},
			'attorney[contact_attributes][phone3_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			}									
		},
		messages: {
			'attorney[contact_attributes][company_name]': {
				required: "Firm can't be blank!",
				remote: 'Firm already present.'
			},
			'attorney[attorney]':{
				required: "Attorney can't be blank."
			},
			'attorney[address_attributes][zipcode]': {
				number: 'Only number allow.',
				digits: 'Only number allow',
				minlength: 'Only 4 digit allow',
				maxlength: 'Only 5 digit allow'				
			},
			'attorney[contact_attributes][phone1_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			},
			'attorney[contact_attributes][phone2_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			},
			'attorney[contact_attributes][phone3_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			}
		}
	})

});