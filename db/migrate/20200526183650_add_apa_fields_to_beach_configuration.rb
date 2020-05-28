class AddApaFieldsToBeachConfiguration < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :beach_support, :boolean
    add_column :beach_configurations, :water_chair, :boolean
    add_column :beach_configurations, :construction, :boolean
    add_column :beach_configurations, :collapsing_risk, :boolean
  end
end
