class AddSourceToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :source, :string
  end
end
