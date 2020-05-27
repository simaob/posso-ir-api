class AddCodeAndWaterCodeToBeachConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :code, :float
    add_column :beach_configurations, :water_code, :string
  end
end
