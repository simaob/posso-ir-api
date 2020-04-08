class CreateOsmPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :osm_points do |t|
      t.string :housename
      t.string :housenumber
      t.string :name
      t.string :brand
      t.string :denomination
      t.string :building
      t.string :amenity
      t.string :shop
      t.float :latitude
      t.float :longitude
      t.geometry :geom

      t.timestamps
    end
  end
end
