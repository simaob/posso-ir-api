class UsersController < ApplicationController
  load_and_authorize_resource except: [:statuses]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:created_at).includes(:created_stores)
      .search(params[:search])
      .page(params[:page])
    @users = @users.where(role: params[:role]) if params[:role].present?
    @users = @users.joins(:created_stores).distinct if params[:created_stores].present?
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @created_stores = @user.created_stores.search(params[:search])
    @created_stores = @created_stores.by_group(params[:group]) if params[:group].present?
    @created_stores = @created_stores.by_state(params[:state]) if params[:state].present?
    @created_stores = @created_stores.by_store_type(params[:store_type]) if params[:store_type].present?
    @created_stores = @created_stores.order(:name).page(params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def statuses
    authorize! :read, :statuses_user
    @user = User.find(params[:id])
    @status_crowdsource_users = @user.status_crowdsource_users.order(posted_at: :desc)
      .page(params[:page])
  end

  def regenerate_key
    if (current_user.admin? || current_user == @user) && %w[store_owner_code api_key].include?(params[:key])
      @user.send("regenerate_#{params[:key]}")
      redirect_to @user, notice: 'Success!'
    else
      redirect_to @user, error: 'You are not authorized to do this'
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :role, :password,
                                 :password_confirmation, store_ids: [])
  end
end
