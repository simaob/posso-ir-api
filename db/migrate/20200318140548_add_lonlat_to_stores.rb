class AddLonlatToStores < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'postgis'

    add_column :stores, :lonlat, :st_point
    add_index :stores, :lonlat, using: :gist
  end
end
