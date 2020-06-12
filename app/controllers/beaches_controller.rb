class BeachesController < StoresController
  before_action :set_beach, only: [:show, :edit, :update]

  def new
    @beach = Store.new(store_type: :beach)
    @beach.beach_configuration = BeachConfiguration.new
  end

  def create
    @beach = Store.new(beach_params)
    @beach.source = 'Community' if current_user.contributor?

    respond_to do |format|
      if @beach.save
        format.html { redirect_to beach_path(@beach), notice: 'Beach was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @beach.update(beach_params)
        format.html { redirect_to beach_path(@beach), notice: 'Beach was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_beach
    @beach = Store.find(params[:id])
  end

  def set_stores
    @stores = Store.where(store_type: :beach)
  end

  def beach_params
    permitted_params = [:name, :group, :street, :city, :zip_code, :country,
                        :district, :store_type, :latitude, :longitude,
                        :municipality, :store_type, :open, :capacity, :details,
                        beach_configuration_attributes: [
                          :id, :category, :quality_flag, :beach_type,
                          :ground, :restrictions, :risk_areas, :average_users,
                          :guarded, :first_aid_station, :wc, :showers,
                          :accessibility, :garbage_collection, :cleaning,
                          :info_panel, :restaurant, :parking, :parking_spots,
                          :season_start, :season_end, :beach_support,
                          :water_chair, :construction, :collapsing_risk,
                          :bathing_support, :water_classification, :sapo_code
                        ]]
    if current_user.any_admin? || current_user.general_manager?
      permitted_params << :state
      permitted_params << :source
    end

    params.require(:beach).permit(permitted_params)
  end
end
