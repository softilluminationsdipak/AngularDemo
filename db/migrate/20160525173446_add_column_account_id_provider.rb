class AddColumnAccountIdProvider < ActiveRecord::Migration
  def change
  	add_column :providers, :account_id, :integer
  end
end
