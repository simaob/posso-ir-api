class AddTimestampsToWeekDays < ActiveRecord::Migration[6.0]
  def change
    add_column :week_days, :created_at, :datetime, null: false, default: Time.now
    add_column :week_days, :updated_at, :datetime, null: false, default: Time.now
  end
end
