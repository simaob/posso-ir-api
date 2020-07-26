class AddBadgesTrackerToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :badges_tracker, :jsonb, default: {}
    add_column :users, :badges_won, :string, default: ''
  end
end
