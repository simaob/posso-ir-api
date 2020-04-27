class AddMakePhoneCallsToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :make_phone_calls, :boolean, default: false
    add_column :stores, :phone_call_interval, :integer, default: 60

    add_index :stores,:make_phone_calls
  end
end
