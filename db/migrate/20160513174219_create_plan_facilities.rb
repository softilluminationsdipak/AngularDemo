class CreatePlanFacilities < ActiveRecord::Migration
  def change
    create_table :plan_facilities do |t|
      t.string :name
      t.integer :plan_id
      t.timestamps null: false
    end
    add_index :plan_facilities, :plan_id
  end
end
