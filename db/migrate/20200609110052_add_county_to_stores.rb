class AddCountyToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :county, :string
  end
end
