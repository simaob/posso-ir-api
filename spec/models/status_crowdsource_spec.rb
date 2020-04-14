# == Schema Information
#
# Table name: statuses
#
#  id                    :bigint           not null, primary key
#  updated_time          :datetime         not null
#  valid_until           :datetime
#  status                :float
#  queue                 :integer
#  type                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  store_id              :bigint
#  previous_status       :float
#  previous_queue        :float
#  previous_updated_time :datetime
#  voters                :integer
#  previous_voters       :integer
#  is_official           :boolean          default("false")
#  active                :boolean          default("true")
#
require 'rails_helper'

RSpec.describe StatusCrowdsource, type: :model do
  let(:store) { create(:store) }
  let(:status_crowdsource) { store.status_crowdsources.first }
  let!(:a_time) { Time.now.utc }

  it 'should have status crowdsource nil when created' do
    expect(status_crowdsource.status).to be_nil
  end

  it 'should continue nil after calculating status without further inputs' do
    status_crowdsource.calculate_status
    expect(status_crowdsource.status).to be_nil
  end

  context 'after a user has just voted' do
    let!(:status_crowdsource_user) do
      create(:status_crowdsource_user, status: 10, store: store)
    end
    it 'should have the status added by the user' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'after two users have voted the same thing at the same time' do
    let!(:status_crowdsource_user) do
      2.times do
        create(:status_crowdsource_user, status: 10, store: store, posted_at: a_time)
      end
    end
    it 'should have the status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'after two users have voted the same thing five minutes appart' do
    let!(:status_crowdsource_users) do
      create(:status_crowdsource_user, status: 10, store: store, posted_at: a_time)
      create(:status_crowdsource_user, status: 10, store: store, posted_at: a_time - 12.minutes)
    end

    it 'should have the status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'after two users have voted different values at the same time' do
    let!(:status_crowdsource_users) do
      create(:status_crowdsource_user, status: 10, store: store, posted_at: a_time)
      create(:status_crowdsource_user, status: 5, store: store, posted_at: a_time)
    end

    it 'should have the average status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(7.5)
    end
  end

  context 'after two users have voted different values a few minutes apart' do
    let!(:set_the_scene) do
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time - 15.minutes)
      create(:status_crowdsource_user, status: 0, store: store, created_at: a_time)
    end

    it 'should have a weighted status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(3.33)
    end
  end

  context 'after three users have voted different values a many minutes apart' do
    let!(:set_the_scene) do
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time - 60.minutes)
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time)
    end

    it 'should have a weighted status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'after three users have voted different values a many minutes apart and the oldest is not valid' do
    let!(:set_the_scene) do
      create(:status_crowdsource_user, status: 0, store: store, created_at: a_time - 60.minutes)
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time)
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time)
    end

    it 'should have a weighted status the valid users that voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'finding an eleven' do
    let!(:set_the_scene) do
      store.status_crowdsources.first.update(status: 5,
                                             voters: 1,
                                             updated_time: a_time - 1.day)
      create(:status_crowdsource_user, status: 10, store: store, created_at: a_time - 13.minutes)
    end

    it 'should have the status as the last user' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end
end
