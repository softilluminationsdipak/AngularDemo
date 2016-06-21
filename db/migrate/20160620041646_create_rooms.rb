class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :account_id
      t.time :first_appointment_time, default: Time.parse("09:00")
      t.time :last_appointment_time, default: Time.parse("18:00")
      t.integer :duration_units
      t.integer :minute_units
      t.timestamps null: false
    end
    add_index :rooms, :account_id
  end
end
