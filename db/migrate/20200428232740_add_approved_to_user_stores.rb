class AddApprovedToUserStores < ActiveRecord::Migration[6.0]
  def change
    add_column :user_stores, :approved, :boolean, default: false
  end
end
