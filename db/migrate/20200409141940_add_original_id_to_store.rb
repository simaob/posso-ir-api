class AddOriginalIdToStore < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :original_id, :bigint
  end
end
