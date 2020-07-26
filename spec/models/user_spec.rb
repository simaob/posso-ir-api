# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  name                   :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  app_uuid               :string
#  last_post              :datetime
#  role                   :integer          default("0")
#  store_owner_code       :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  phone                  :string
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  badges_tracker         :jsonb
#  badges_won             :string           default("")
#
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
      create(:user, confirmed_at: DateTime.current)
    }
    let(:reporter2) {
      create(:user, confirmed_at: DateTime.current)
    }
    let(:reporter3) {
      create(:user, confirmed_at: DateTime.current)
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
      RankingService.new.call

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
      RankingService.new.call

      expect(reporter1.reporter_rank).to eql(1)
      expect(reporter2.reporter_rank).to eql(2)
      expect(reporter3.reporter_rank).to eql(3)
    end
  end

  context '#Badges should work' do
    let!(:user) { FactoryBot.create(:user, confirmed_at: Time.current - 1.minute) }
    let!(:badge_1) { FactoryBot.create(:badge_daily_login_count) }
    let!(:badge_2) { FactoryBot.create(:badge_total_reports) }
    let!(:badge_3) { FactoryBot.create(:badge_total_2) }
    let!(:badge_4) { FactoryBot.create(:badge_beach_unique_2) }

    context 'Calls #increase_login_counter for the first time' do
      it 'Should have 1 in the number of days logged in and the corresponding badge' do
        user.increase_login_counter

        expect(user.badges_tracker['daily_login_count']).to eql(1)
        expect(user.badges_tracker['total_reports']).to eql(0)
        expect(user.badges_won).to eql(' welcome')
      end
    end
    context 'Reports a beach' do
      let!(:beach) { FactoryBot.create(:store, store_type: :beach) }
      let!(:update_user) { user.increase_badges_counter({type: "#{beach.store_type}_reports", id: beach.id}) }

      it 'Should have 1 in the total_reports' do
        expect(user.badges_tracker['total_reports']).to eql(1)
      end
      it 'Should have 1 in the beach_reports' do
        expect(user.badges_tracker['beach_reports']).to eql(1)
      end
      it 'Should have the new badge' do
        expect(user.badges_won).to eql(' noob')
      end

      context 'Reports two beaches' do
        let!(:beach2) { FactoryBot.create(:store, store_type: :beach) }
        let!(:update_user2) { user.increase_badges_counter({type: "#{beach2.store_type}_reports", id: beach2.id}) }

        it 'Should have 2 in the total_reports' do
          expect(user.badges_tracker['total_reports']).to eql(2)
        end
        it 'Should have 2 in the beach_reports' do
          expect(user.badges_tracker['beach_reports']).to eql(2)
        end
        it 'Should have 2 in the beach_uniq' do
          expect(user.badges_tracker['beach_unique']).to eql(2)
        end
        it 'Should have the traveler and beach badges' do
          expect(user.badges_won.split(' ')).to include('beach')
          expect(user.badges_won.split(' ')).to include('traveler')
        end

        context 'Reports the same beach again' do
          let!(:update_user3) { user.increase_badges_counter({type: "#{beach2.store_type}_reports", id: beach2.id}) }

          it 'Should have 3 in total_reports' do
            expect(user.badges_tracker['total_reports']).to eql(3)
          end
          it 'Should have 3 in the beach_reports' do
            expect(user.badges_tracker['beach_reports']).to eql(3)
          end
          it 'Should have 2 in the beach_uniq' do
            expect(user.badges_tracker['beach_unique']).to eql(2)
          end
        end
      end
    end

    context 'Medals' do
      context 'Finished in the first place' do
        let!(:update_user) { user.increase_conquests_counter(1) }
        it 'Should have it in the badges tracker' do
          expect(user.badges_tracker['top_1']).to eql(1)
        end
        # TODO: Should it?
        pending 'Should have a medal'
      end
    end
  end
end
