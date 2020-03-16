class StoreResource < JSONAPI::Resource
  attributes :name, :group, :address, :coordinates, :capacity, :details

end