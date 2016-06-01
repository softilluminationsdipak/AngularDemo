class CreateProcedureCodesFeeScheduleLabels < ActiveRecord::Migration
  def change
    create_table :procedure_codes_fee_schedule_labels do |t|
      t.integer :procedure_code_id
      t.integer :fee_schedule_label_id
      t.float :fee_cents
      t.integer :copay
      t.boolean :is_percentage, default: false
      t.float :expected_insurance_payment_cents, default: 0
      t.timestamps null: false
    end
  end
end
