class CreateStatusHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :status_histories do |t|
      t.datetime :updated_time
      t.datetime :valid_until
      t.float    :status
      t.float    :queue
      t.string   :type
      t.bigint   :store_id
      t.integer  :voters
      t.boolean  :is_official

      t.datetime :old_created_at
      t.datetime :old_updated_at
    end
  end
end
