class CreateRankingHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :ranking_histories do |t|
      t.integer :position, null: false
      t.integer :score, null: false
      t.integer :user_id, null: false
      t.date :date, null: false

      t.timestamps

      t.index [:position, :date]
      t.index :date
      t.index :user_id
    end
  end
end
