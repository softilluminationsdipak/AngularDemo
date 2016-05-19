class CreateLegacyIdLabels < ActiveRecord::Migration
  def change
    create_table :legacy_id_labels do |t|
      t.string :label

      t.timestamps null: false
    end
  end
end
