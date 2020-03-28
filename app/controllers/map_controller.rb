class MapController < ApplicationController
  def index
    @shops = Store.all.where.not(latitude: nil, longitude: nil).where(country: 'PT')
    @shops = Hash[@shops.collect { |item| [item.id, item] } ]
  end

  def update
    # PUT /map/:id?name=myname
    @shop = Store.find(params[:id])
    @shop.attributes = map_params
    # TODO: mark as validated
  end

  def delete
    @shop = Store.find(params[:id])
    @shop.attributes = map_params
    # TODO: mark as delete_requested
  end

  private

  def map_params
    params.require(:name)
  end
end
