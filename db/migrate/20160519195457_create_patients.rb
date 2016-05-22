class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.integer 	:clinic_id
    	t.string   	:encrypted_ssn
    	t.date     	:birthdate
    	t.string 		:slug
    	t.string   	:spouse_name
	    t.integer  	:referrer_id
	    t.boolean  	:is_active, default: true
	    t.string   	:statement_message
	    t.datetime 	:deleted_at
	    t.string   	:address_stationery_to_label
	    t.boolean  	:is_full_time_student, default: false
	    t.integer  	:marital_status_code
	    t.integer  	:disability_status_code
	    t.boolean  	:should_send_statements_when_overdue, default: true
	    t.integer  	:overdue_fee_percentage
	    t.text     	:notes
	    t.integer  	:contact_id
	    t.integer  	:address_id
	    t.string   	:referrer_type
	    t.integer  	:employer_contact_id
	    t.integer  	:employer_address_id
	    t.string   	:account_code
	    t.integer  	:employment_status_code
	    t.string   	:category
	    t.integer  	:parent_patient_id
	    t.integer  	:import_id
      t.timestamps null: false
    end
    add_index :patients, :clinic_id
    add_index :patients, :referrer_id
    add_index :patients, :deleted_at
    add_index :patients, :contact_id
    add_index :patients, :address_id
    add_index :patients, :slug
  end
end
