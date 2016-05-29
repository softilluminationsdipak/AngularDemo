class CreateDiagnosisCodes < ActiveRecord::Migration
  def change
    create_table :diagnosis_codes do |t|
      t.string :name
      t.string :code
      t.text :description
      t.datetime :deleted_at
      t.integer :clinic_id
      t.integer :account_id
      t.string :slug
      t.timestamps null: false
    end
    add_index :diagnosis_codes, :clinic_id
    add_index :diagnosis_codes, :account_id
    add_index :diagnosis_codes, :slug
  end
end
