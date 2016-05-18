class AddColumnSlugToClinics < ActiveRecord::Migration
  def change
    add_column :contacts, :slug, :string
    add_index :contacts, :slug
    add_column :clinics, :slug, :string
    add_index :clinics, :slug
  end
end
