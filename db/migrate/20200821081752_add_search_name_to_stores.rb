class AddSearchNameToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :search_name, :string
  end
end
