class CreateStatusCrowdsourceUser < ActiveRecord::Migration[6.0]
  def change
    create_table :status_crowdsource_users do |t|
      t.integer :status, null: false
      t.integer :queue
      t.timestamp :posted_at

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
      t.references :user, { foreign_key: { on_delete: :cascade }, index: true }
    end
  end
end
