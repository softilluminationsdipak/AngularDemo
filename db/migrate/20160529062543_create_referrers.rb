class CreateReferrers < ActiveRecord::Migration
  def change
    create_table :referrers do |t|
      t.integer :insurance_carrier_id
      t.string :source
      t.string :upin_uid
      t.text :comment
      t.string :npi_uid
      t.integer :address_id
      t.integer :contact_id
      t.string :slug
      t.string :account_id
      t.datetime :deleted_at
      t.timestamps null: false
    end
    add_index :referrers, :insurance_carrier_id
    add_index :referrers, :address_id
    add_index :referrers, :contact_id
    add_index :referrers, :account_id
    add_index :referrers, :slug
  end
end
