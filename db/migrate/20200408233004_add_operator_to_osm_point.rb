class AddOperatorToOsmPoint < ActiveRecord::Migration[6.0]
  def change
    add_column :osm_points, :operator, :string
    add_column :osm_points, :street, :string
    add_column :osm_points, :city, :string
    add_column :osm_points, :district, :string
    add_column :osm_points, :country, :string
    add_column :osm_points, :zip_code, :string
    add_column :osm_points, :place, :string
    add_column :osm_points, :opening_hours, :string
  end
end
