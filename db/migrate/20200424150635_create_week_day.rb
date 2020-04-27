class CreateWeekDay < ActiveRecord::Migration[6.0]
  def change
    create_table :week_days do |t|
      t.integer :day, null: false
      t.time :opening_hour
      t.time :closing_hour
      t.boolean :active, default: false

      t.string :timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }

      t.index :active
      t.index [:store_id, :day], unique: true
    end
  end
end
