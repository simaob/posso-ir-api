class AddStoreTypeNotNullInStores < ActiveRecord::Migration[6.0]
  def change
    Store.where(store_type: nil).update_all(store_type: 1)
    change_column :stores, :store_type, :integer, null: false, default: 1
  end
end
