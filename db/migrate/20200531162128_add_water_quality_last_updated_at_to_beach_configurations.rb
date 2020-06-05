class AddWaterQualityLastUpdatedAtToBeachConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :water_quality_updated_at, :datetime
  end
end
