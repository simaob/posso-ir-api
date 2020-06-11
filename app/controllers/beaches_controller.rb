class BeachesController < StoresController
  def edit
    @beach = Store.find(params[:id])
  end

  private

  def set_stores
    @stores = Store.where(store_type: :beach)
  end
end
