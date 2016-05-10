class AddColumnAccountIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_id, :integer
    add_column :users, :admin, :boolean, default: false    
  end
end
