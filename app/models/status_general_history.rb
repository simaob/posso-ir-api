# == Schema Information
#
# Table name: status_histories
#
#  id             :bigint           not null, primary key
#  updated_time   :datetime
#  valid_until    :datetime
#  status         :float
#  queue          :float
#  type           :string
#  store_id       :bigint
#  voters         :integer
#  is_official    :boolean
#  old_created_at :datetime
#  old_updated_at :datetime
#
class StatusGeneralHistory < StatusHistory
end
