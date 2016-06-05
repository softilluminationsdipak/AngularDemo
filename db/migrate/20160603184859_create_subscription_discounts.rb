class CreateSubscriptionDiscounts < ActiveRecord::Migration
  def change
    create_table :subscription_discounts do |t|
      t.string 	 :name
	    t.string   :code
	    t.decimal  :amount, precision: 6, scale: 2, default: 0.0
	    t.boolean  :percent, default: false
	    t.date     :start_on
	    t.date     :end_on
	    t.boolean  :apply_to_setup, default: true
	    t.boolean  :apply_to_recurring, default: true
	    t.integer  :trial_period_extension, default: 0
      t.timestamps null: false
    end
  end
end
