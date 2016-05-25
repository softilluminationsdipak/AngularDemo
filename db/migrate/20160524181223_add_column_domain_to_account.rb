class AddColumnDomainToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :domain, :string
  end
end
