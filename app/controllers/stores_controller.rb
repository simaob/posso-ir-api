class StoresController < ApplicationController
  load_and_authorize_resource

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.search(params[:search])
    @stores = @stores.by_group(params[:group]) if params[:group].present?
    @stores = @stores.by_state(params[:state]) if params[:state].present?
    @stores = @stores.by_store_type(params[:store_type]) if params[:store_type].present?

    if params[:no_info]
      @stores = @stores.where(latitude: nil).or(Store.where(longitude: nil))
    end

    @stores = @stores.order(:group, :name)

    respond_to do |format|
      format.html do
        @stores = @stores.page(params[:page])
      end
      format.json do
        @stores = @stores.limit(50)
      end
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve_all
    @stores = Store.where(state: :waiting_approval)
    size = @stores.size
    @stores.update_all(state: :live)

    respond_to do |format|
      format.html { redirect_to stores_url, notice: "#{size} stores approved" }
      format.json { head :no_content }
    end

  end

  private

  # Only allow a list of trusted parameters through.
  def store_params
    permitted_params = [:name, :group, :street, :city, :zip_code, :country,
                        :district, :store_type, :latitude, :longitude,
                        :store_type, :open, :capacity, :details]
    permitted_params << :state if current_user.admin?

    params.require(:store).permit(permitted_params)
  end
end
