class CreateStatusEstimationHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :status_estimation_histories do |t|
      t.datetime :updated_time
      t.datetime :valid_until
      t.float    :status
      t.bigint   :store_id

      t.datetime :old_created_at
      t.datetime :old_updated_at
    end
  end
end
