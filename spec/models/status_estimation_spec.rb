require 'rails_helper'

RSpec.describe StatusEstimation, type: :model do
  let(:store) { create(:store) }
  let!(:a_time) { Time.current }
  let(:estimation) { build(:status_estimation, store: store, updated_time: a_time + 1.minute) }

  it 'should create history after save' do
    estimation.save!
    expect(StatusEstimationHistory.where(updated_time: estimation.updated_time).count).to eql(1)
  end

  it 'should replace old estimations for the same store' do
    create(:status_estimation, store: store, status: 0, updated_time: a_time)
    estimation.save!
    expect(StatusEstimation.where(store_id: estimation.store_id).count).to eql(1)
    expect(StatusEstimation.find_by(store_id: estimation.store_id).status).to eql(estimation.status)
  end

  context 'no active general statuses' do
    it 'should update the general status' do
      store.status_general.update(updated_time: a_time - 2.hours)
      estimation.save!
      general = Store.find(store.id).status_general

      expect(general.updated_time.round).to eql(estimation.updated_time.round)
      expect(general.status).to eql(estimation.status)
      expect(general.estimation).to eql(true)
      expect(general.is_official).to eql(false)
    end
  end

  context 'active general statuses' do
    let(:general) { StatusGeneral.find_by(store_id: store.id) }
    let(:updated_time) { a_time - 2.minutes }
    context 'general status is an estimation' do
      it 'should update the general status' do
        # rubocop:disable Rails/SkipsModelValidations
        general.update_columns(status: 0, updated_time: updated_time, estimation: true)
        # rubocop:enable Rails/SkipsModelValidations
        estimation.save!
        general.reload

        expect(general.status).to eql(estimation.status)
        expect(general.updated_time.round).to eql(estimation.updated_time.round)
      end
    end

    context 'general status is crowdsource' do
      it "shouldn't update the the general status" do
        # rubocop:disable Rails/SkipsModelValidations
        general.update_columns(status: 0, updated_time: updated_time, estimation: false, is_official: true)
        # rubocop:enable Rails/SkipsModelValidations
        estimation.save!
        general.reload

        expect(general.is_official).to eql(true)
        expect(general.estimation).to eql(false)
        expect(general.updated_time.round).to eql(updated_time.round)
        expect(general.status.round).to eql(0)
      end
    end

    context 'general status is store owner' do
      it "shouldn't update the general status" do
        # rubocop:disable Rails/SkipsModelValidations
        general.update_columns(status: 0, updated_time: updated_time, estimation: false, is_official: false)
        # rubocop:enable Rails/SkipsModelValidations
        estimation.save!
        general.reload

        expect(general.is_official).to eql(false)
        expect(general.estimation).to eql(false)
        expect(general.updated_time.round).to eql(updated_time.round)
        expect(general.status.round).to eql(0)
      end
    end
  end
end
