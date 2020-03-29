class MapController < ApplicationController
  def index
    @shops = Store.all.where.not(latitude: nil, longitude: nil).where(country: 'PT')
    @shops = Hash[@shops.collect { |item| [item.id, item] } ]
  end

  def create
  # POST /map
    # copy/pasted from stores controller > reuse?
    @shop = Store.new(map_params)

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :created, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
      # TODO: mark as to validate
  end

  def update
    # PUT /map/:id?name=myname
    @shop = Store.find(params[:id])
    @shop.attributes = map_params

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :ok, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
    # TODO: mark as validated
  end

  def destroy
    @shop = Store.find(params[:id])
    @shop.attributes = map_params

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :ok, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
    # TODO: mark as delete_requested
  end

  private

  def map_params
  # copy/pasted from stores controller > reuse?
    params.permit(:name, :group, :street, :city,
                                      :zip_code, :country, :district, :store_type,
                                      :latitude, :longitude, :capacity, :details)
  end
end
