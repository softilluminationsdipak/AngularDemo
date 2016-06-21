class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :contact_id
      t.integer :clinic_id
      t.date :date
      t.integer :provider_id
      t.integer :room_id
      t.datetime :starts_at
      t.text :notes
      t.integer :duration_units, default: 1
      t.integer :minute_units, default: 15
      t.datetime :deleted_at
      t.datetime :ends_at
      t.string :recurring_type
      t.integer :recurring_day
      t.time :start_time
      t.timestamps null: false
    end
    add_index :appointments, :contact_id
    add_index :appointments, :provider_id
    add_index :appointments, :clinic_id
    add_index :appointments, :room_id
    add_index :appointments, :deleted_at    
  end
end
