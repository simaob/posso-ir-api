class AddStoreOwnerCodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :store_owner_code, :string, uniq: true
  end
end
