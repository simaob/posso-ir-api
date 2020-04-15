require 'rails_helper'

describe ImportStores do
  let!(:store1) { create(:store) }
  let!(:store2) { create(:store) }
  let!(:store3) { create(:store) }
  let!(:a_time) { Time.now.utc }

  context 'three status added, but only one in the last two hours' do
    let!(:set_the_scene) do
      create(:status_crowdsource_user, status: 10, store: store1, created_at: a_time)
      create(:status_crowdsource_user, status: 10, store: store2, created_at: a_time - 30.minutes)
      create(:status_crowdsource_user, status: 10, store: store3, created_at: a_time - 3.hours)

      sleep 1
      CalculateStatus.new.call
    end

    it 'should only update the status of store1' do
      expect(store1.status_generals.first.status).to eq(10)
      expect(store2.status_generals.first.status).to eq(10)
      expect(store3.status_generals.first.status).to be_nil
    end
  end

  context 'benchmark' do
    before do
      puts 'mass inserting...'
      stores = create_list(:store, 10)
      puts 'stores inserted'

      data = Array.new(100_000) do |i|
        time = Faker::Time.between(from: 2.hours.ago, to: 1.minute.ago)
        {
          store_id: stores[i % stores.size].id,
          created_at: time,
          updated_at: time,
          status: 10
        }
      end

      puts 'scu prepared'
      StatusCrowdsourceUser.insert_all(data)

      puts 'mass insert done'
    end

    it 'pulling rails' do
      CalculateStatus.new.call(new_cool: false)
    end

    it 'single query' do
      CalculateStatus.new.call(new_cool: true)
    end
  end
end
