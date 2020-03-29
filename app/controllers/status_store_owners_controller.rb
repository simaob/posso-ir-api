class StatusStoreOwnersController < ApplicationController
  before_action :set_store
  def new
    @status_store_owner = @store.status_store_owners
      .new(updated_time: Time.now)
  end

  def create
    @status_store_owner = @store.status_store_owners.new(status_store_owner_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to manage_stores_path, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
  end

  def status_store_owner_params
    params.require(:status_store_owner).permit(:updated_time, :status)
  end
end
