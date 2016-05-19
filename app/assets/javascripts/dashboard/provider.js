$(document).on('ready page:load', function (event) {

	$("#validate_new_provider").validate({
		errorElement: "span",
		rules: {
			'provider[clinic_id]': {
				required: true
			},
		},
		messages: {
			'provider[clinic_id]': {
				required: "Clinic can't be blank."
			},
		}
	})
});