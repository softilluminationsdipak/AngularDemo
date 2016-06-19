class CreatePatientVisitPayments < ActiveRecord::Migration
  def change
    create_table :patient_visit_payments do |t|
      t.integer :source_patient_visit_detail_id
      t.integer :destination_patient_visit_detail_id
      t.integer :amount_cents
      t.integer :transfer_direction_code
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
