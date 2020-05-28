json.results do
  json.array! @stores, partial: 'stores/store', as: :store
end
