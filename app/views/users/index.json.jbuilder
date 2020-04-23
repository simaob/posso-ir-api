json.results do
  json.array! @users, partial: 'users/user', as: :user
end
