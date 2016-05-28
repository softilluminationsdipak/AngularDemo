class CreateInsuranceCarriers < ActiveRecord::Migration
  def change
    create_table :insurance_carriers do |t|
      t.integer   :contact_id
      t.integer   :insurance_carrier_type_code
      t.integer   :insurance_type_code
      t.string    :payer_code
      t.string    :claims_office_sub_code
      t.string    :clinic_code
      t.string    :medigap_code
      t.string    :alias_name
      t.integer   :address_id
      t.datetime  :deleted_at
      t.string    :name
      t.text      :notes
      t.integer   :legacy_id_label_id
      t.integer   :import_id
      t.integer   :account_id
      t.string    :slug
      t.timestamps null: false
    end
  end
end
