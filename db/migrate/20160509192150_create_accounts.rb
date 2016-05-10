class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :full_domain
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
