class AddFieldToBadges < ActiveRecord::Migration[6.0]
  def change
    add_column :badges, :badge_type, :integer, null: false, default: 1
    add_column :badges, :store_type, :integer, null: true
    add_column :badges, :target, :integer, null: false, default: 0
    add_column :badges, :counter, :string

    add_index :badges, :counter
  end
end
