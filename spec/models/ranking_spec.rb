# == Schema Information
#
# Table name: rankings
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  score      :integer          not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Ranking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
