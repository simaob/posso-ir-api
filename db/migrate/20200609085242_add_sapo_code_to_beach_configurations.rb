class AddSapoCodeToBeachConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :beach_configurations, :sapo_code, :string
  end
end
