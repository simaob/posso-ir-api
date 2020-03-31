class MapController < ApplicationController
  include EnumI18nHelper

  def index
    @shops = Store.all.where.not(latitude: nil, longitude: nil).where(country: 'PT')
    @shops = Hash[@shops.collect { |item| [item.id, item] } ]
    @labels = {
      delete: I18n.t('views.map.index.delete'),
      edit: I18n.t('views.map.index.edit'),
      add_store: I18n.t('views.map.index.add_store'),
      delete_store: I18n.t('views.map.index.delete_store'),
      close: I18n.t('views.map.index.close'),
      cancel: I18n.t('views.map.index.cancel'),
      save: I18n.t('views.map.index.save'),
      confirm: I18n.t('views.map.index.confirm'),
      editing: I18n.t('views.map.index.editing_store'),
      deleting: I18n.t('views.map.index.deleting_store'),
      creating: I18n.t('views.map.index.creating_store')
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
    # TODO: mark as validated
  end

  def destroy
    @shop = Store.find(params[:id])
    @shop.attributes = map_params

    respond_to do |format|
      if @shop.save
        format.json { render json: @shop, status: :ok, location: @shop }
      else
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
    # TODO: mark as delete_requested
  end

  private

  def map_params
  # copy/pasted from stores controller > reuse?
    params.permit(:name, :group, :street, :city,
                                      :zip_code, :country, :district, :store_type,
                                      :latitude, :longitude, :capacity, :details)
  end
end
