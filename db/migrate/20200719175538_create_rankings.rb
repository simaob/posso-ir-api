class CreateRankings < ActiveRecord::Migration[6.0]
  def change
    create_table :rankings do |t|
      t.integer :position, null: false
      t.integer :score, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.index :position
    end
  end
end
