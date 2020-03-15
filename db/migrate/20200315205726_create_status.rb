class CreateStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.timestamp :updated_time
      t.timestamp :valid_until
      t.integer :status
      t.string :type

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
    end
  end
end
