class ManageStoresController < ApplicationController
  def index
    @user_stores = current_user.user_stores
      .includes(store: :status_store_owners)
      .joins(:store)
      .order('stores.name')
    @user_stores = @user_stores.search(params[:search]).page(params[:page])
  end
end
