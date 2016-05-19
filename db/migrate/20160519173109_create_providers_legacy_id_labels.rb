class CreateProvidersLegacyIdLabels < ActiveRecord::Migration
  def change
    create_table :providers_legacy_id_labels do |t|
      t.integer :legacy_id_label_id
      t.integer :provider_id
      t.string :legacy_id_value
      t.timestamps null: false
    end
    add_index :providers_legacy_id_labels, :legacy_id_label_id
    add_index :providers_legacy_id_labels, :provider_id
  end
end
