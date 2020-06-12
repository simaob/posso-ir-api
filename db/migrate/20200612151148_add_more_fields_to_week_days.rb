class AddMoreFieldsToWeekDays < ActiveRecord::Migration[6.0]
  def change
    add_column :week_days, :open, :boolean, default: true
    add_column :week_days, :opening_hour_2, :time
    add_column :week_days, :closing_hour_2, :time

    add_index :week_days, :open
  end
end
