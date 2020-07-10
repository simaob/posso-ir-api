class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :user

  attribute :email
  attribute :name
  attribute :reports_made do
    rand(1..100)
  end
  attribute :reporter_ranking do
    rand(1..100)
  end

  has_many :stores, type: :stores, serializer: StoreSerializer
end
