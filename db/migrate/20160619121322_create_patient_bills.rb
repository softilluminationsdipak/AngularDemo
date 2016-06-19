class CreatePatientBills < ActiveRecord::Migration
  def change
    create_table :patient_bills do |t|
      t.integer :patient_case_id
      t.integer :insurance_carrier_id
      t.integer :provider_id
      t.boolean :is_secondary_claim, default: false
      t.integer :status_code
      t.boolean :is_workmanscomp_progress_form, default: false
      t.boolean :is_assigned
      t.datetime :hcfa_bill_date
      t.datetime :deleted_at
      t.text 		 :notes
      t.timestamps null: false
    end
    add_index :patient_bills, :patient_case_id
    add_index :patient_bills, :provider_id
		add_index :patient_bills, :insurance_carrier_id
		add_index :patient_bills, :deleted_at
  end
end
