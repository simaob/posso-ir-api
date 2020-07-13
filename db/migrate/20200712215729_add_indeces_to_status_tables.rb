class AddIndecesToStatusTables < ActiveRecord::Migration[6.0]
  def change
    add_index :status_histories, :store_id
    add_index :status_estimation_histories, :store_id
  end
end
