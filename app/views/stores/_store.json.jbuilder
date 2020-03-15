json.extract! store, :id, :name, :group, :street, :city, :latitude, :longitude, :capacity, :details, :created_at, :updated_at
json.url store_url(store, format: :json)
