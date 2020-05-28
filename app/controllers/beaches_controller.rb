class BeachesController < StoresController
  private

  def set_stores
    @stores = Store.where(store_type: :beach)
  end
end
