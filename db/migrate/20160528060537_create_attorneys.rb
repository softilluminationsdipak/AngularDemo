class CreateAttorneys < ActiveRecord::Migration
  def change
    create_table :attorneys do |t|
      t.integer :address_id
      t.integer :contact_id
      t.datetime :deleted_at
      t.integer :insurance_carrier_id
      t.text :notes
      t.integer :account_id
      t.string :slug
      t.string :attorney_name
      t.timestamps null: false
    end
    add_index :insurance_carriers, :contact_id
    add_index :insurance_carriers, :address_id
    add_index :insurance_carriers, :account_id
    add_index :insurance_carriers, :slug
    add_index :attorneys, :contact_id
    add_index :attorneys, :address_id
    add_index :attorneys, :insurance_carrier_id
    add_index :attorneys, :account_id
    add_index :attorneys, :slug
  end
end
