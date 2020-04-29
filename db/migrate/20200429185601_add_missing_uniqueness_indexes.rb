class AddMissingUniquenessIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :api_keys, :access_token
    add_index :api_keys, :access_token, unique: true

    remove_index :phones, :phone_number
    add_index :phones, :phone_number, unique: true
  end
end
