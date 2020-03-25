class AddStateToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :state, :integer, default: 1
    add_column :stores, :reason_to_delete, :text
  end
end
