class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string 		:street
      t.string 		:street2
      t.string 		:city
      t.string 		:state
      t.string 		:zipcode
      t.string 		:label
      t.integer 	:addressable_id
      t.string 		:addressable_type
      t.datetime 	:deleted_at
      t.timestamps null: false
    end
  end
end
