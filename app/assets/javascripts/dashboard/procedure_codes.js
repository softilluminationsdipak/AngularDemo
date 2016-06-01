$(document).on('ready page:load', function (event) {
	$('input.changesExpectedInsurance').each(function() {
		if (this.type == 'text'){
		 	$("#" + this.id).keyup(function(){
				changeExpectedInsuranceOfFeeSchedule(this);
		 	});
		}
		else{
		 	$("#" + this.id).change(function(){
		 	 	changeExpectedInsuranceOfFeeSchedule(this);
		 	})
		}
	});
});


function changeExpectedInsuranceOfFeeSchedule(obj){	
	var matches = (/procedure_code\[procedure_codes_fee_schedule_labels_attributes\]\[(\d+)\]\[(.+)\]/i).exec(obj.name);
	var number 	= matches[1];
	var fee 		= parseFloat($('#procedure_code_procedure_codes_fee_schedule_labels_attributes_'+number+'_fee_cents').val());
	var copay 	= parseFloat($('#procedure_code_procedure_codes_fee_schedule_labels_attributes_'+number+'_copay').val());
	var isPercentage = $('#procedure_code_procedure_codes_fee_schedule_labels_attributes_'+number+'_is_percentage').prop('checked');
	var expectedInsurancePayment = isPercentage ? fee - ((fee * copay) / 100) : fee - copay;
	var value = expectedInsurancePayment >= 0 ? expectedInsurancePayment.toFixed(2) : '0.00'
	$('#procedure_code_procedure_codes_fee_schedule_labels_attributes_'+number+'_expected_insurance_payment_cents').val(value);
}

function typeCodeChanged(typeCode, clinic_id){
	$.ajax({
		url: '/clinics/' + clinic_id + '/procedure_codes/type_code_selected',
		method: 'post',
		data: {type_code_id: typeCode},
		dataType: 'script'
	})
}

$(document).on('ready page:load', function (event) {

	$("#validate_new_procedure_code").validate({
		errorElement: "span",
		rules: {
			'procedure_code[name]': {
				required: true
			},
			'procedure_code[description]': {
				required: true
			},
			'procedure_code[cpt_code]': {
				required: true
			},
			'procedure_code[tax_rate_percentage]': {
				minlength: 1,
				maxlength: 2,
				digits: true,
				number: true				
			}
		},
		messages: {
			'procedure_code[name]': {
				required: "Name can't be blank!"	
			},
			'procedure_code[description]': {
				required: "Description can't be blank!"
			},
			'procedure_code[cpt_code]': {
				required: "CPT Code can't be blank!"
			},
			'procedure_code[tax_rate_percentage]': {
				number: 'Only number allow.',
				digits: 'Only number allow',
				minlength: 'Only 1 digit allow',
				maxlength: 'Only 2 digit allow'
			}
		}
	})
	
});