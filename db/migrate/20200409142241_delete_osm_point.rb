class DeleteOsmPoint < ActiveRecord::Migration[6.0]
  def change
    drop_table :osm_points
  end
end
