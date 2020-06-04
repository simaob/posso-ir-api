class StoresController < ApplicationController
  load_and_authorize_resource :store, except: [:statuses, :index, :approve_all]
  before_action :set_stores, only: [:index, :approve_all]
  skip_before_action :authenticate_user!, if: proc { request.format.json? && action_name == 'index' }

  # GET /stores
  # GET /stores.json
  def index
    @stores = @stores.full_text_search(params[:search]).with_pg_search_rank if params[:search].present?
    @stores = @stores.by_country(params[:country]) if params[:country].present?
    @stores = @stores.by_group(params[:group]) if params[:group].present?

    @stores = if params[:state].present?
                @stores.by_state(params[:state])
              else
                @stores.where.not(state: :archived)
              end

    @stores = @stores.by_store_type(params[:store_type]) if params[:store_type].present?
    @stores = @stores.where(latitude: nil).or(Store.where(longitude: nil)) if params[:no_info]

    @stores = @stores.order(:group, :name)

    respond_to do |format|
      format.html do
        @stores = @stores.page(params[:page])
      end
      format.json do
        @stores = @stores.limit(50)
      end
      format.csv do
        send_data @stores.to_csv, type: 'csv', filename: 'stores-export.csv'
      end
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show; end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit; end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)
    @store.source = 'Community' if current_user.contributor?

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
      format.html do
        redirect_to polymorphic_url(controller_name, search_params),
                    notice: 'Store was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def approve_all
    @stores = @stores.search(params[:search])
    @stores = @stores.by_group(params[:group]) if params[:group].present?
    @stores = @stores.by_country(params[:country]) if params[:country].present?
    @stores = @stores.by_state(params[:state]) if params[:state].present?
    @stores = @stores.by_store_type(params[:store_type]) if params[:store_type].present?
    size = @stores.size
    @stores.update_all(state: :live) # rubocop:disable Rails/SkipsModelValidations

    respond_to do |format|
      format.html do
        redirect_to polymorphic_url(controller_name),
                    notice: t('controllers.stores.approve_all.notice', size: size)
      end
      format.json { head :no_content }
    end
  end

  def statuses
    authorize! :read, :statuses_store
    @store = Store.find(params[:id])
    @statuses = @store.statuses.order(updated_time: :desc)
    @status_crowdsource_users = @store.status_crowdsource_users
      .order(posted_at: :desc).page(params[:page])
    @estimation_histories = StatusEstimationHistory.where(store_id: @store.id)
      .order(updated_time: :desc).page(params[:page])
  end

  private

  def set_stores
    @stores = Store.where.not(store_type: :beach)
  end

  # Only allow a list of trusted parameters through.
  def store_params
    permitted_params = [:name, :group, :street, :city, :zip_code, :country,
                        :district, :store_type, :latitude, :longitude,
                        :store_type, :open, :capacity, :details, :phone_call_interval,
                        phones_attributes: [:id, :phone_number, :name, :active, :_destroy],
                        week_days_attributes: [:id, :opening_hour, :closing_hour, :active]]
    if current_user.admin? || current_user.general_manager?
      permitted_params << :state
      permitted_params << {manager_ids: []}
    end

    params.require(:store).permit(permitted_params)
  end

  def search_params
    {
      state: params[:state],
      group: params[:group],
      search: params[:search],
      country: params[:country],
      store_type: params[:store_type]
    }
  end
end
