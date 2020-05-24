class CreateBeachConfiguration < ActiveRecord::Migration[6.0]
  def change
    remove_column :stores, :category, :integer
    remove_column :stores, :quality_flag, :boolean

    create_table :beach_configurations do |t|
      t.integer :category
      t.string :beach_type
      t.string :ground
      t.string :restrictions
      t.string :risk_areas
      t.integer :average_users
      t.boolean :guarded
      t.boolean :first_aid_station
      t.boolean :wc
      t.boolean :showers
      t.boolean :accessibility
      t.boolean :garbage_collection
      t.boolean :cleaning
      t.boolean :info_panel
      t.boolean :restaurant
      t.boolean :parking
      t.integer :parking_spots
      t.date :season_start
      t.date :season_end
      t.integer :water_quality
      t.string :water_quality_url
      t.boolean :quality_flag
      t.string :water_quality_entity
      t.string :water_quality_contact
      t.string :water_contact_email
      t.string :security_entity
      t.string :security_entity_contact
      t.string :security_entity_email
      t.string :health_authority
      t.string :health_authority_contact
      t.string :health_authority_email
      t.string :municipality
      t.string :municipality_contact
      t.string :municipality_email

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
      t.index :category
      t.index :average_users
      t.index :guarded
      t.index :quality_flag
      t.index :water_quality
      t.index :parking
    end
  end
end
