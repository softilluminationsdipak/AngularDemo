class CreatePatientVisitDetails < ActiveRecord::Migration
  def change
    create_table :patient_visit_details do |t|
      t.integer   :patient_case_id
      t.integer 	:patient_visit_id
	    t.integer  	:provider_id
	    t.integer 	:procedure_code_id
	    t.integer  	:amount_cents
	    t.integer  	:patient_owes_cent
	    t.integer  	:insurance_owes_cents
	    t.integer  	:units_sold
	    t.string   	:diagnosis_pointer
	    t.integer  	:place_of_service_code
	    t.datetime 	:deleted_at
      t.timestamps null: false
    end
    add_index :patient_visit_details, :patient_visit_id
    add_index :patient_visit_details, :provider_id
    add_index :patient_visit_details, :procedure_code_id
    add_index :patient_visit_details, :deleted_at
    add_index :patient_visit_details, :patient_case_id
  end
end
