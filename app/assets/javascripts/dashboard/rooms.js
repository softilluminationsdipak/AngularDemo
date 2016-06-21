$(document).on('ready page:load', function (event) {

	$("#validate_new_room").validate({
		errorElement: "span",
		rules: {
			'room[name]': {
				required: true,
			},
			'room[minute_units]':{
				required: true,
				number: true
			},
			'room[duration_units]': {
				number: true,
				required: true
			}
		},
		messages: {
			'room[name]': {
				required: "Name can't be blank."
			},
			'room[minute_units]': {
				number: 'Only number allow.',
				required: "Can't be blank"
			},
			'room[duration_units]':{
				number: 'Only number allow.',
				required: "Can't be blank"
			}
		}
	})

});