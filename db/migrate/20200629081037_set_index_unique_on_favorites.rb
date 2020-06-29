class SetIndexUniqueOnFavorites < ActiveRecord::Migration[6.0]
  def change
    remove_index :favorites, name: :index_favorites_on_store_id_and_user_id
    add_index :favorites, [:store_id, :user_id], unique: true
  end
end
