class AddLastPostToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_post, :timestamp
  end
end
