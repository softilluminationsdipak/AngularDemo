class AddColumnSystemAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :system_admin, :boolean
  end
end
