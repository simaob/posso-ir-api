# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string
#  group      :string
#  street     :string
#  city       :string
#  latitude   :float
#  longitude  :float
#  capacity   :integer
#  details    :text
#  store_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
