class PhonesController < ApplicationController
  load_and_authorize_resource

  def index
    @phones = if current_user.admin?
                Phone.all
              else
                Phone.where(store_id: current_user.stores.pluck(:id))
              end
    @phones = @phones.search(params[:search]).page(params[:page])
  end

  def new
    @store = Store.new
  end

  def create
    @phone = Phone.new(phone_params)

    respond_to do |format|
      if @phone.save
        format.html { redirect_to @phone, notice: 'Phone was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def edit; end

  def destroy
    @phone.destroy
    respond_to do |format|
      format.html { redirect_to phones_url, notice: 'Phone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def phone_params
    params.require(:phone).permit(:phone_number, :name, :active, :store_id)
  end
end
