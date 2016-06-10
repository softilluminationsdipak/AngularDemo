function showInfoForSelectedDiagnosisCode(select, number) {
	id = $(select).val()
	if(id){
		$('#diagnosisCode'+number+'_code').html(diagnosisCodes[id].code);
		$('#diagnosis'+number+'_description').attr('data-content', diagnosisCodes[id].description);
	}
}

$(document).on('ready page:load', function (event) {

	$("#validate_new_patient_case").validate({
		errorElement: "span",
		rules: {
			'patient_case[description]': {
				required: true
			},
			'patient_case[provider_id]': {
				required: true
			}
		},
		messages: {
			'patient_case[description]': {
				required: "Description can't be blank"
			},
			'patient_case[provider_id]': {
				required: "Provider can't be blank"
			}
		}
	});

});

function forceGuarantorContactIfRelationshipIsSelf(relationship, guarantorContactDropdownID, patientContactID) {
	if (relationship == "self"){
		$(guarantorContactDropdownID).val(patientContactID)
	}
}

function checkAssigned(patient_case_id, value, id) {
	$.ajax({
		url: '/clinics/' + currentClinicId + '/patient_cases/' + patientCaseId + '/check_assigned?insurance_carrier_id=' + value
	}).done(function(html){
		if(html == 'yes'){
			$("#"+id).prop('checked', true)
		}else{
			$("#"+id).prop('checked', false)
		}
	})
}

function updateDiagnosisCodeSelects() {
	showInfoForSelectedDiagnosisCode($('#patient_case_diagnosis'+ 1 +'_id'), 1);
  showInfoForSelectedDiagnosisCode($('#patient_case_diagnosis'+ 2 +'_id'), 2);
  showInfoForSelectedDiagnosisCode($('#patient_case_diagnosis'+ 3 +'_id'), 3);
  showInfoForSelectedDiagnosisCode($('#patient_case_diagnosis'+ 4 +'_id'), 4);
}
