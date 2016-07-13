class AddColumnAccountIdToPatientBill < ActiveRecord::Migration
  def change
    add_column :patient_bills, :account_id, :integer
    add_index :patient_bills, :account_id
  end
end
