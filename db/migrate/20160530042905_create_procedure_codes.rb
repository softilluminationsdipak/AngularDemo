class CreateProcedureCodes < ActiveRecord::Migration
  def change
    create_table :procedure_codes do |t|
      t.string    :name
      t.text      :description
      t.integer   :type_code
      t.integer   :service_type_code
      t.string    :modifier
      t.integer   :tax_rate_percentage
      t.string    :modifier2
      t.string    :modifier3
      t.string    :cpt_code
      t.datetime  :deleted_at
      t.integer   :clinic_id
      t.integer   :account_id
      t.string    :slug
      t.timestamps null: false
    end
    add_index :procedure_codes, :clinic_id
    add_index :procedure_codes, :account_id
    add_index :procedure_codes, :slug    
  end
end
