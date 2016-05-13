class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string 		:first_name
      t.string 		:last_name
      t.string 		:company_name
      t.string 		:phone1_ext
      t.string 		:phone1
      t.string 		:phone2_ext
      t.string 		:phone2
      t.string 		:phone3_ext
      t.string 		:phone3
      t.string 		:email1
      t.string 		:email2
      t.string 		:attention
      t.text 	 		:notes      
      t.string 		:title
      t.string 		:fax1
      t.string 		:sex
      t.string 		:occupation
      t.string 		:middle_initial
			t.datetime 	:deleted_at
      t.integer		:contactable_id
      t.string 		:contactable_type
      t.timestamps null: false
    end
  end
end
