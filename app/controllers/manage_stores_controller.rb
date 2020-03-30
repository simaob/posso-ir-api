class ManageStoresController < ApplicationController
  def index
    @stores = current_user.stores.order(:name)
      .includes(:status_store_owners)
  end
end
