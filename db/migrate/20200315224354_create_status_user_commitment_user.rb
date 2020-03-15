class CreateStatusUserCommitmentUser < ActiveRecord::Migration[6.0]
  def change
    create_table :status_user_commitment_users do |t|
      t.integer :status, null: false
      t.timestamp :posted_at, null: false
      t.timestamp :start_at
      t.integer :duration

      t.timestamps

      t.references :store, { foreign_key: { on_delete: :cascade }, index: true }
      t.references :user, { foreign_key: { on_delete: :cascade }, index: true }
    end
  end
end
