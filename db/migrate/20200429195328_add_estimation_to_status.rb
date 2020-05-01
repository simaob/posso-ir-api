class AddEstimationToStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :statuses, :estimation, :boolean, default: false

    add_index :statuses, :estimation
  end
end
