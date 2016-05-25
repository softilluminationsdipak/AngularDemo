class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.string :name
      t.string :slug
      t.text :body
      t.string :salutation
      t.datetime :deleted_at
      t.boolean :should_sign_clinic_name
      t.integer :account_id
      t.timestamps null: false
    end
    add_index :letters, :account_id
    add_index :letters, :slug
  end
end
