class UserBadgeSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :badge

  attribute :slug
  attribute :name
  attribute :date
end
