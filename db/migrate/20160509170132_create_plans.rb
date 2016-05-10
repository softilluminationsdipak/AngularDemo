class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :price, default: 0
      t.string :title
      t.integer :clinic, default: 0
      t.integer :doctor, default: 0
      t.boolean :primary, default: false      
      t.timestamps null: false
    end
  end
end
