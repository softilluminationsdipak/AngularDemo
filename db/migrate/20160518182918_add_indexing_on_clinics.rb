class AddIndexingOnClinics < ActiveRecord::Migration
  def change
  	add_index :clinics, :deleted_at
  	add_index :accounts, :deleted_at
  	add_index :addresses, :deleted_at
  	add_index :clinic_preferences, :deleted_at
  	add_index :contacts, :deleted_at
  	remove_column :providers, :datetime
  	add_column :providers, :deleted_at, :datetime
  	add_index :providers, :deleted_at
  end
end
