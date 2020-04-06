require 'rails_helper'

describe ImportStores do
  context '.import_aldi' do
    src = File.open(Rails.root.join('spec', 'fixtures', 'aldi.json'), 'r')
    fixture = File.read(src)
    json = JSON.parse(fixture)
    store_unit = json.first[1][0]
    store_district = json.first[0]

    let(:file_object) { double('file object') }

    it 'imports ALDI data' do
      allow(File).to receive(:open).with(Rails.root.join('db', 'files', 'aldi.json'), 'r').and_return(file_object)
      allow(File).to receive(:read).with(file_object).and_return(fixture)

      is = ImportStores.new
      is.import_aldi

      store = Store.find_by(name: store_unit['name'])

      expect(store.group).to eq('Aldi')
      expect(store.country).to eq('PT')
      expect(store.city).to eq(store_unit['addressLocality'])
      expect(store.district).to eq(store_district)
      expect(store.zip_code).to eq(store_unit['postalCode'])
      expect(store.street).to eq(store_unit['address'])
      expect(store.store_type).to eq('supermarket')
    end
  end
end
