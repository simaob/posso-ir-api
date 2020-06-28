class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.index [:store_id, :user_id]
    end
  end
end
