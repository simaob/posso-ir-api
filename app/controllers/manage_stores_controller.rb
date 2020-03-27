class ManageStoresController < ApplicationController
  def index
    @stores = current_user.stores.order(:name)
  end
end
