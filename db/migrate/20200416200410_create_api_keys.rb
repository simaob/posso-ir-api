class CreateApiKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :api_keys do |t|
      t.string :access_token, uniq: true, null: false
      t.datetime :expires_at, null: false
      t.boolean :is_active, default: false
      t.string :name

      t.timestamps

      t.references :user, { foreign_key: { on_delete: :cascade }, index: true }
      t.index :access_token
    end
  end
end
