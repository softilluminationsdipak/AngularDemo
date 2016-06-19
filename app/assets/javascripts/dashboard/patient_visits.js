  function loadVisit(clinic_id, patient_id, patient_case_id, visit_id){
    $.ajax({
      url: '/clinics/' + clinic_id + '/patients/' + patient_id + '/patient_cases/' + patient_case_id + '/patient_visits/' + visit_id,
      method: 'get',
      dataType: 'script',
      success: function(response){
        document.location.hash = visit_id;
      }
    })
  };

  function diagnosis1(dval, number, clinic_id, patient_id, patient_case_id){
    $.ajax({
      url: '/clinics/'+clinic_id+'/patients/'+patient_id+'/patient_cases/'+patient_case_id+'/patient_visits/diagnosis_chosen?number='+ number,
      method: 'post',
      dataType: 'script',
      data: {diagnosis_code_id: dval }
    })    
  }
