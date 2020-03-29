class AddIsOfficialToStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :statuses, :is_official, :boolean, default: false
    add_column :statuses, :active, :boolean, default: true

    add_index :statuses, :active
  end
end
