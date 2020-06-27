class RemoveDecoAttributesFromBeachConfiguration < ActiveRecord::Migration[6.0]
  def change
    remove_column :beach_configurations, :ground, :string
    remove_column :beach_configurations, :restrictions, :string
    remove_column :beach_configurations, :beach_type, :string
    remove_column :beach_configurations, :category, :integer
    remove_column :beach_configurations, :risk_areas, :string
    remove_column :beach_configurations, :average_users, :integer
    remove_column :beach_configurations, :restaurant, :boolean
    remove_column :beach_configurations, :parking_spots, :integer
    remove_column :beach_configurations, :water_quality_entity, :string
    remove_column :beach_configurations, :water_quality_contact, :string
    remove_column :beach_configurations, :water_contact_email, :string
    remove_column :beach_configurations, :security_entity, :string
    remove_column :beach_configurations, :security_entity_contact, :string
    remove_column :beach_configurations, :security_entity_email, :string
    remove_column :beach_configurations, :health_authority, :string
    remove_column :beach_configurations, :health_authority_contact, :string
    remove_column :beach_configurations, :health_authority_email, :string
    remove_column :beach_configurations, :municipality, :string
    remove_column :beach_configurations, :municipality_contact, :string
    remove_column :beach_configurations, :municipality_email, :string
  end
end
