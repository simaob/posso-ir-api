class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :group
      t.string :street
      t.string :city
      t.float :latitude
      t.float :longitude
      t.integer :capacity
      t.text :details
      t.integer :store_type

      t.timestamps
    end
  end
end
