# == Schema Information
#
# Table name: user_stores
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  store_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class UserStoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
