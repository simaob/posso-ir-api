class AddWaterClassificationToBeachConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :water_classification, :integer
  end
end
