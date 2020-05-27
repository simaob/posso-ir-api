class RemoveDefaultForCreatedAndUpdatedAt < ActiveRecord::Migration[6.0]
  def change
    change_column_default :week_days, :created_at, nil
    change_column_default :week_days, :updated_at, nil
  end
end
