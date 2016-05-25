$(document).on('ready page:load', function (event) {

	$("#validate_new_letter").validate({
		errorElement: "span",
		rules: {
			'letter[name]': {
				required: true,
				remote: {
					url: '/letters/checkUniqueSignName/?id='+$('#letter_name').attr('data-letterId'),
					type: 'post'
				}
			},
			'letter[body]': {
				required: true
			}
		},
		messages: {
			'letter[name]': {
				required: "Name can't be blank!",
				remote: 'Name already present.'
			},
			'letter[body]': {
				required: "Body can't be blank!",				
			}
		}
	})

	$("#vertical_slide").hide();
	$('#v_toggle').click(function(event){
		event.stopPropagation();
		if($( "#vertical_slide" ).is( ":hidden" )){
	    $( "#vertical_slide" ).show("slow");
	  }else{
	    $("#vertical_slide" ).slideUp();
	  }		
	})

});