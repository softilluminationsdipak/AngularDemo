$(document).on('ready page:load', function (event) {

	$("#validate_new_appointment").validate({
		errorElement: "span",
		rules: {
			'appointment[date]': {
				required: true
			},
			'appointment[contact_id]': {
				required: true
			},			
			'appointment[room_id]':{
				required: true
			}									
		},
		messages: {
			'appointment[date]': {
				required: "can't be blank!"				
			},
			'appointment[contact_id]':{
				required: "can't be blank."
			},
			'appointment[room_id]': {
				required: "can't be blank."				
			}
		}
	})

});