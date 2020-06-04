require 'rails_helper'

describe Importer::ImportStores do
  context '.import_aldi' do
    include FakeFS::SpecHelpers

    before do
      FakeFS::FileSystem.clone(Rails.root.join('spec/fixtures/aldi.json'))
      FileUtils.mkdir_p(Rails.root.join('db/files'))
      File.write(
        Rails.root.join('db/files/aldi.json'),
        Rails.root.join('spec/fixtures/aldi.json').read
      )
    end

    it 'imports ALDI data' do
      Importer::ImportStores.new.import_aldi

      store = Store.first

      expect(store.group).to eq('Aldi')
      expect(store.country).to eq('PT')
      expect(store.city).to eq('Watopia')
      expect(store.district).to eq('Watopiashire')
      expect(store.zip_code).to eq('1111-222')
      expect(store.street).to eq('Avenue des ALpes')
      expect(store.store_type).to eq('supermarket')
    end
  end
end
