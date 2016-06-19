class CreatePatientVisits < ActiveRecord::Migration
  def change
    create_table :patient_visits do |t|
      t.integer 	:patient_case_id
      t.datetime 	:visited_at
      t.string 		:fee_slip_number
      t.boolean 	:should_bill_primary, default: false
      t.integer  	:primary_patient_bill_id
      t.boolean 	:should_bill_secondary, default: false
      t.integer 	:secondary_patient_bill_id
      t.boolean 	:should_bill_attorney, default: false
      t.integer 	:attorney_patient_bill_id
      t.datetime 	:onset_at
      t.datetime  :first_treated_at
      t.integer 	:diagnosis1_id
      t.integer   :diagnosis2_id
      t.integer 	:diagnosis3_id
      t.integer 	:diagnosis4_id
      t.string 		:diagnosis1_description
      t.string 		:diagnosis2_description
      t.string 		:diagnosis3_description
      t.string 		:diagnosis4_description
      t.text 			:details
      t.datetime 	:deleted_at      
      t.timestamps null: false
    end
    add_index :patient_visits, :patient_case_id
    add_index :patient_visits, :diagnosis1_id
    add_index :patient_visits, :diagnosis2_id
    add_index :patient_visits, :diagnosis3_id
    add_index :patient_visits, :diagnosis4_id
  end
end
