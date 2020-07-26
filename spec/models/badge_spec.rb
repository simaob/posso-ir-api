# == Schema Information
#
# Table name: badges
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_type :integer          default("1"), not null
#  store_type :integer
#  target     :integer          default("0"), not null
#  counter    :string
#
require 'rails_helper'

RSpec.describe Badge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
