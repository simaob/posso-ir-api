class ChangeStatusToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :statuses, :status, :float
  end
end
