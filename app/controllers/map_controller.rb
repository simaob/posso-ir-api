class MapController < ApplicationController
  include EnumI18nHelper

  def index
    authorize! :read, :map

    @shops = if current_user.store_manager?
               current_user.stores
                 .where.not(latitude: nil).where.not(longitude: nil)
             else
               Store.where.not(latitude: nil).where.not(longitude: nil)
                 .where(state: 'live')
                 .where(country: 'PT')
             end
    @shops = Hash[@shops.collect { |item| [item.id, item] } ]
    @labels = {
      delete: t('views.map.index.delete'),
      edit: t('views.map.index.edit'),
      add_store: t('views.map.index.add_store'),
      delete_store: t('views.map.index.delete_store'),
      close: t('views.map.index.close'),
      cancel: t('views.map.index.cancel'),
      save: t('views.map.index.save'),
      confirm: t('views.map.index.confirm'),
      editing: t('views.map.index.editing'),
      deleting: t('views.map.index.deleting'),
      creating: t('views.map.index.creating')
    }
    @fields = [
      {
        attribute: 'name',
        label: Store.human_attribute_name(:name),
        type: 'text'
      },
      {
        attribute: 'store_type',
        label: Store.human_attribute_name(:store_type),
        type: 'select',
        options: enum_options_for_select(Store, :store_type)
      },
      {
        attribute: 'group',
        label: Store.human_attribute_name(:group),
        type: 'text'
      },
      {
        attribute: 'street',
        label: Store.human_attribute_name(:street),
        type: 'text'
      },
      {
        attribute: 'zip_code',
        label: Store.human_attribute_name(:zip_code),
        type: 'text'
      },
      {
        attribute: 'city',
        label: Store.human_attribute_name(:city),
        type: 'text'
      },
      {
        attribute: 'country',
        label: Store.human_attribute_name(:country),
        type: 'text'
      },
      {
        attribute: 'latitude',
        label: Store.human_attribute_name(:latitude),
        type: 'text',
        readonly: true
      },
      {
        attribute: 'longitude',
        label: Store.human_attribute_name(:longitude),
        type: 'text',
        readonly: true
      }
    ]
  end

  def create
  # POST /map
    # copy/pasted from stores controller > reuse?
    @shop = Store.new(map_params)

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :created, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
      # TODO: mark as to validate
  end

  def update
    # PUT /map/:id?name=myname
    @shop = Store.find(params[:id])
    @shop.attributes = map_params

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :ok, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shop = Store.find(params[:id])
    @shop.state = 3

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :ok, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def map_params
  # copy/pasted from stores controller > reuse?
    params.permit(:name, :group, :street, :city,
                                      :zip_code, :country, :district, :store_type,
                                      :latitude, :longitude, :capacity, :details)
  end
end
