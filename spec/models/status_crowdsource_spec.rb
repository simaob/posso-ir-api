require 'rails_helper'

RSpec.describe StatusCrowdsource, type: :model do
  let(:store) { create(:store) }
  let(:status_crowdsource) { store.status_crowdsources.first }
  let!(:a_time) { Time.now }

  it 'should have status crowdsource nil when created' do
    expect(status_crowdsource.status).to be_nil
  end

  it 'should continue nil after calculating status without further inputs' do
    status_crowdsource.calculate_status
    expect(status_crowdsource.status).to be_nil
  end

  context 'after a user has just voted' do
    let!(:status_crowdsource_user) { create(:status_crowdsource_user, status: 10,
                                            store: store) }
    it 'should have the status added by the user' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(10)
    end
  end

  context 'after two users have voted the same thing at the same time' do
    let!(:status_crowdsource_user) { 2.times { create(:status_crowdsource_user, status: 10,
                                            store: store, posted_at: a_time) }}
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
      create(:status_crowdsource_user, status: 10, store: store, posted_at: a_time - 34.minutes)
      status_crowdsource.calculate_status
      create(:status_crowdsource_user, status: 5, store: store, posted_at: a_time)
    end

    it 'should have a weighted status the two users voted' do
      status_crowdsource.calculate_status
      expect(status_crowdsource.status).to eq(7.5)
    end
  end
end
