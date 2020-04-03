class ManageStoresController < ApplicationController
  def index
    @stores = current_user.stores.order(:name)
      .includes(:status_store_owners)
    @stores = @stores.search(params[:search]).page(params[:page])
  end
end
