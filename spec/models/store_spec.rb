require 'rails_helper'

describe Store do
  describe '#in_bounding_box' do
    it 'gets intersected store as geojson' do
      bbox = [[0, 0], [2, 2]]
      tesco = Store.create(name: 'Tesco', lonlat: 'POINT(1 1)')
      Store.create(name: 'Asda', lonlat: 'POINT(1,3)')

      query = Store.in_bounding_box(bbox)

      expect(query).to eq([tesco])
    end
  end
end
