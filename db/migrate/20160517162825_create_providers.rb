class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.integer 	:clinic_id
      t.string 		:signature_name
      t.string 		:provider_type_code
      t.string 		:tax_uid
      t.string 		:upin_uid
      t.string		:license
      t.text 			:notes
      t.string 		:nycomp_testify
      t.string		:npi_uid
      t.integer 	:contact_id
      t.integer 	:address_id
      t.datetime 	:datetime
      t.timestamps null: false
    end
    add_index :providers, :clinic_id
    add_index :providers, :contact_id
    add_index :providers, :address_id
  end
end
