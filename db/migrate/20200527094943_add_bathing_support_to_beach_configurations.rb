class AddBathingSupportToBeachConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :bathing_support, :boolean
  end
end
