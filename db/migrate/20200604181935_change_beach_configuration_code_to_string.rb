class ChangeBeachConfigurationCodeToString < ActiveRecord::Migration[6.0]
  def change
    change_column :beach_configurations, :code, :string
  end
end
