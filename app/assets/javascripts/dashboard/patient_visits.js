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



  function pullFromCase(visit_id, clinic_id, patient_id, patient_case_id){
    $('#pull_from_case_'+visit_id).html('PULLING...')
    $.ajax({
      url: '/clinics/'+clinic_id+'/patients/'+patient_id+'/patient_cases/'+patient_case_id+'/patient_visits/'+visit_id+'/pull_from_case',
      method: 'put',
      dataType: 'json',
      success: function(){
        $('#pull_from_case_'+visit_id).html('PULLED')
      }      
    })    
  };

  function pushToCase(visit_id, clinic_id, patient_id, patient_case_id){
    $('#push_to_case_'+visit_id).html('PUSHING...')
    $.ajax({
      url: '/clinics/'+clinic_id+'/patients/'+patient_id+'/patient_cases/'+patient_case_id+'/patient_visits/'+visit_id+'/push_to_case',
      method: 'put',
      dataType: 'json',
      success: function(){
        $('#push_to_case_'+visit_id).html('PUSHED')
      }
    })    
  };
