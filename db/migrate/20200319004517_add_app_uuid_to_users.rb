class AddAppUuidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :app_uuid, :string, uniq: true
  end
end
