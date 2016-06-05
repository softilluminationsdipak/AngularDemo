$(document).on('ready page:load', function (event) {

	$("#validate_current_account").validate({
		errorElement: "span",
		rules: {
			'account[name]': {
				required: true
			},			
		},
		messages: {
			'account[name]':{
				required: "Name can't be blank."
			},
		}
	})
});

function enableButton(){
	plan_id = $("#plan_id").val();
	if(plan_id == ''){
		$("#commit").attr('disabled', 'disabled')
	}else{
		$("#commit").removeAttr('disabled')
	}
}
