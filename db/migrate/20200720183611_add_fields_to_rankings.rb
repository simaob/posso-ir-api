class AddFieldsToRankings < ActiveRecord::Migration[6.0]
  def change
    add_column :rankings, :reports, :integer, null: false, default: 0
    add_column :rankings, :places, :integer, null: false, default: 0
    add_column :ranking_histories, :reports, :integer, null: false, default: 0
    add_column :ranking_histories, :places, :integer, null: false, default: 0

    add_index :rankings, :reports
    add_index :rankings, :places
    add_index :ranking_histories, :reports
    add_index :ranking_histories, :places
  end
end
