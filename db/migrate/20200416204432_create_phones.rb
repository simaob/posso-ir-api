class CreatePhones < ActiveRecord::Migration[6.0]
  def change
    create_table :phones do |t|
      t.string :phone_number, uniq: true, null: false
      t.string :name
      t.boolean :active, default: true

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
      t.index :phone_number
    end
  end
end
