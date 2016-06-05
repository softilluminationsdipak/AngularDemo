class CreateSubscriptionPayments < ActiveRecord::Migration
  def change
    create_table :subscription_payments do |t|
      t.integer 	:account_id
	    t.integer  	:subscription_id
	    t.decimal  	:amount, precision: 10, scale: 2, default: 0.0
	    t.string   	:transaction_id
	    t.boolean  	:setup, default: false
	    t.boolean  	:misc, default: false
	    t.integer  	:subscription_affiliate_id
	    t.decimal  	:affiliate_amount, precision: 6,  scale: 2, default: 0.0
      t.timestamps null: false
    end
    add_index :subscription_payments, :account_id
    add_index :subscription_payments, :subscription_id
    add_index :subscriptions, :account_id
    add_index :subscription_plans, :plan_id
  end
end
