require 'rails_helper'

describe CalculateStatus do
  let(:store) { create(:store) }

  def create_statuses(users: [], owners: [], at: Time.now)
    Timecop.freeze(at) do
      users.each do |vote|
        create(:status_crowdsource_user, store: store, status: vote)
      end

      owners.each do |vote|
        create(:status_store_owner, store: store, status: vote)
      end
    end
  end

  def calculated_status(statuses)
    statuses.each { |status| create_statuses(**status) }
    CalculateStatus.new.call
    store.status_general.status
  end

  context 'three status added, but only one in the last two hours' do
    let!(:store1) { create(:store) }
    let!(:store2) { create(:store) }
    let!(:store3) { create(:store) }
    let!(:a_time) { Time.now.utc }

    let!(:set_the_scene) do
      create(:status_crowdsource_user, status: 10, store: store1, created_at: a_time)
      create(:status_crowdsource_user, status: 10, store: store2, created_at: a_time - 30.minutes)
      create(:status_crowdsource_user, status: 10, store: store3, created_at: a_time - 3.hours)
      CalculateStatus.new.call
    end

    it 'should only update the status of store1' do
      expect(store1.status_general.status).to eq(10)
      expect(store2.status_general.status).to eq(10)
      expect(store3.status_general.status).to be_nil
    end
  end

  it do
    expect(calculated_status(
      []
    )).to eq(nil)
  end

  it do
    expect(calculated_status([
      {users: [10], at: 0.minutes.ago}
    ])).to eq(10.00)
  end

  it do
    expect(calculated_status([
      {users: [10], at: 15.minutes.ago}
    ])).to eq(10.00)
  end

  it do
    expect(calculated_status([
      {users: [10], at: 25.minutes.ago}
    ])).to eq(10.00)
  end

  it do
    expect(calculated_status([
      {users: [10], at: 35.minutes.ago}
    ])).to eq(nil)
  end

  it do
    expect(calculated_status([
      {users: [10, 5], at: 0.minutes.ago}
    ])).to eq(7.50)
  end

  it do
    expect(calculated_status([
      {users: [1], at: 0.minutes.ago},
      {users: [2], at: 15.minutes.ago},
      {users: [3], at: 25.minutes.ago},
      {users: [4], at: 35.minutes.ago}
    ])).to eq(1.5)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 0.minutes.ago},
      {users: [10], at: 0.minutes.ago}
    ])).to eq(5.00)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 0.minutes.ago},
      {users: [10], at: 15.minutes.ago}
    ])).to eq(3.33)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 15.minutes.ago},
      {users: [10], at: 15.minutes.ago}
    ])).to eq(5.00)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 0.minutes.ago},
      {users: [10], at: 25.minutes.ago}
    ])).to eq(1.43)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 25.minutes.ago},
      {users: [10], at: 25.minutes.ago}
    ])).to eq(5.00)
  end

  it do
    expect(calculated_status([
      {users: [0], at: 0.minutes.ago},
      {users: [10], at: 35.minutes.ago}
    ])).to eq(0.00)
  end
end
