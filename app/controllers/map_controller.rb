class MapController < ApplicationController
  def index
      @shops = Store.all.where.not(latitude: nil, longitude: nil)
    end
end
