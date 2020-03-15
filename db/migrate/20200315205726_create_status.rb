class CreateStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.timestamp :updated_time, null: false
      t.timestamp :valid_until
      t.integer :status
      t.integer :queue_status
      t.string :type, null: false

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
    end
  end
end
