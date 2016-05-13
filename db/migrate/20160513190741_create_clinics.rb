class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.integer :contact_id
      t.integer :address_id
      t.integer :billing_address_id
      t.string 	:tax_uuid
      t.string 	:type_ii_npi_uuid
      t.string 	:main_provider_id
      t.integer :account_id
      t.boolean :same_as_service_location
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
