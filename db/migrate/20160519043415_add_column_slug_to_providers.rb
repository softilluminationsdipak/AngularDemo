class AddColumnSlugToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :slug, :string
    add_index :providers, :slug
  end
end
