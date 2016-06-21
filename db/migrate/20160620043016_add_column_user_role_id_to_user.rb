class AddColumnUserRoleIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_role_id, :integer
    add_index :users, :user_role_id
  end
end
