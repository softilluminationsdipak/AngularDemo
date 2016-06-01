class CreateFeeScheduleLabels < ActiveRecord::Migration
  def change
    create_table :fee_schedule_labels do |t|
      t.string :label
      t.integer :clinic_id
      t.integer :account_id
      t.timestamps null: false
    end
    add_index :fee_schedule_labels, :account_id
    add_index :fee_schedule_labels, :clinic_id
  end
end
