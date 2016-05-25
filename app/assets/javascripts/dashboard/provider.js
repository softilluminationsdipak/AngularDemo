$(document).on('ready page:load', function (event) {

	$("#validate_new_provider").validate({
		errorElement: "span",
		rules: {
			// 'provider[clinic_id]': {
			// 	required: true
			// },
			'provider[license]': {
				maxlength: 10
			},
			'provider[npi_uid]': {
				number: true,
				maxlength: 10
			},
			'provider[signature_name]': {
				required: true,
				remote: {
					url: '/providers/checkUniqueSignName/?id='+$('#provider_signature_name').attr('data-providerId'),
					type: 'post'
				}
			},
			'provider[email]': {
				email: true
			}
		},
		messages: {
			// 'provider[clinic_id]': {
			// 	required: "Clinic can't be blank."
			// },
			'provider[license]': {
				maxlength: "Max 10 digit allow."
			},
			'provider[signature_name]': {
				required: "Full name is required.",
				remote: 'Fullname already present.'
			},
			'provider[npi_uid]': {
				number: 'Only number allow',
				maxlength: 'Max 10 digit allow'
			}
		}
	})
});