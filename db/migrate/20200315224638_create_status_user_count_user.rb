class CreateStatusUserCountUser < ActiveRecord::Migration[6.0]
  def change
    create_table :status_user_count_users do |t|
      t.integer :status, null: false
      t.integer :queue_status

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
      t.references :user, { foreign_key: { on_delete: :cascade }, index: true }
    end
  end
end
