class AddFromOsmToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :from_osm, :boolean, default: false
  end
end
