class CreateSubscriptionAffiliates < ActiveRecord::Migration
  def change
    create_table :subscription_affiliates do |t|
      t.string 		:name
	    t.decimal  	:rate, precision: 6, scale: 4, default: 0.0
  	  t.string   	:token
      t.timestamps null: false
    end
  end
end
