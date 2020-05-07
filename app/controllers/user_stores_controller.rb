class UserStoresController < ApplicationController
  load_and_authorize_resource

  def index
    @user_stores = @user_stores.where(approved: false)
      .order(:created_at).page(params[:page])
  end

  def update
    @user_store.approved = true
    @user_store.save
    redirect_to user_stores_path, notice: 'Store allocation approved'
  end
end
