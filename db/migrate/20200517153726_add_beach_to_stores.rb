class AddBeachToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :category, :integer
    add_column :stores, :quality_flag, :boolean
  end
end
