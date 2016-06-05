class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer 	:account_id
   		t.decimal 	:amount, precision: 10, scale: 2
    	t.datetime 	:next_renewal_at
	    t.string   	:state, default: 'trial'
    	t.integer  	:subscription_plan_id
    	t.integer  	:subscription_discount_id, default: 0
      t.timestamps null: false
    end
  end
end
