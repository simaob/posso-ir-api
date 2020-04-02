class AddCreatedByAndUpdatedByToStores < ActiveRecord::Migration[6.0]
  def change
    add_reference :stores, :created_by, foreign_key: { to_table: :users }, index: true
    add_reference :stores, :updated_by, foreign_key: { to_table: :users }, index: true
  end
end
