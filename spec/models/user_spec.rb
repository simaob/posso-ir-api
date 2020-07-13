require 'rails_helper'

RSpec.describe User, type: :model do
  context '#reporter_rank should work' do
    let!(:stores) {
      stores = []
      10.times do
        stores << create(:store)
      end
      stores
    }
    let(:reporter1) {
      create(:user)
    }
    let(:reporter2) {
      create(:user)
    }
    let(:reporter3) {
      create(:user)
    }
    let(:random_reporters) {
      reporters = []
      50.times do
        reporters << create(:user)
      end
      reporters
    }
    it 'have reporter1 in first place, and reporter3 with a result of 0' do
      200.times do
        create(:status_crowdsource_user, store_id: stores.sample.id, user_id: reporter1.id)
      end
      150.times do
        create(:status_crowdsource_user, store_id: stores.sample.id, user_id: random_reporters.sample.id)
      end

      expect(reporter1.reporter_rank).to eql(1)
      expect(reporter3.reporter_rank).to eql(0)
    end

    it 'should have the three positions defined' do
      3.times do
        create(:status_crowdsource_user, store_id: stores.sample.id, user_id: reporter1.id)
      end
      2.times do
        create(:status_crowdsource_user, store_id: stores.sample.id, user_id: reporter2.id)
      end
      create(:status_crowdsource_user, store_id: stores.sample.id, user_id: reporter3.id)

      expect(reporter1.reporter_rank).to eql(1)
      expect(reporter2.reporter_rank).to eql(2)
      expect(reporter3.reporter_rank).to eql(3)
    end
  end
end
