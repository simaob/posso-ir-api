class ChangeQueueStatusToQueue < ActiveRecord::Migration[6.0]
  def change
    rename_column :statuses, :queue_status, :queue
  end
end
