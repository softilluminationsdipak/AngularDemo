$(document).on('ready page:load', function (event) {

	$("#validate_new_referrer").validate({
		errorElement: "span",
		rules: {
			'referrer[source]': {
				required: true,
				remote: {
					url: '/referrers/checkUniqueSignName/?id='+$('#referrer_source').attr('data-ReferrerId'),
					type: 'post'
				}				
			},
			'referrer[address_attributes][zipcode]':{
				minlength: 4,
				maxlength: 5,
				digits: true,
				number: true
			},
			'referrer[contact_attributes][phone1_ext]': {
				number: true,
				digits: true,
				minlength: 1,
				maxlength: 1
			}
		},
		messages: {
			'referrer[source]': {
				required: "Referrer can't be blank!",
				remote: 'Referrer already present.'
			},
			'referrer[address_attributes][zipcode]': {
				number: 'Only number allow.',
				digits: 'Only number allow',
				minlength: 'Only 4 digit allow',
				maxlength: 'Only 5 digit allow'				
			},
			'referrer[contact_attributes][phone1_ext]':{
				number: 'Number Only.',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 1 digit allow'
			}
		}
	})

});