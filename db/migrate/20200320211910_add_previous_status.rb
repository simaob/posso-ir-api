class AddPreviousStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :statuses, :previous_status, :float
    add_column :statuses, :previous_queue, :float
    add_column :statuses, :previous_updated_time, :datetime
    add_column :statuses, :voters, :integer
    add_column :statuses, :previous_voters, :integer

    add_index :status_crowdsource_users, :posted_at
    add_index :status_crowdsource_users, :created_at
  end
end
