class AddOpenToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :open, :boolean, default: true
  end
end
