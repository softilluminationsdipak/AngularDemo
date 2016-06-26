$(document).on('ready page:load', function (event) {

	$("#validate_new_diagnosis_code").validate({
		errorElement: "span",
		rules: {
			'diagnosis_code[clinic_id]': {
				required: true
			},			
			'diagnosis_code[name]': {
				required: true
			},			
			'diagnosis_code[code]':{
				required: true
			},
			'diagnosis_code[description]': {
				required: true
			}
		},
		messages: {
			'diagnosis_code[clinic_id]': {
				required: "Clinic can't be blank!"			
			},
			'diagnosis_code[name]': {
				required: "Name can't be blank!"			
			},
			'diagnosis_code[code]':{
				required: "Code can't be blank."
			},
			'diagnosis_code[description]': {
				required: "Description can't be blank."
			}
		}
	})

	$("#diagnosis_codes_report_report_type").change(function(event){
		reportType = $(this).val();
		if (reportType == "list") {
			$("#startDate").hide();
			$("#endDate").hide();
		} else {
			$("#startDate").show();
			$("#endDate").show();
		}
	})
});
