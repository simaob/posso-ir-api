# == Schema Information
#
# Table name: stores
#
#  id                  :bigint           not null, primary key
#  name                :string
#  group               :string
#  street              :string
#  city                :string
#  district            :string
#  country             :string
#  zip_code            :string
#  latitude            :float
#  longitude           :float
#  capacity            :integer
#  details             :text
#  store_type          :integer          default("1"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lonlat              :geometry         point, 0
#  state               :integer          default("1")
#  reason_to_delete    :text
#  open                :boolean          default("true")
#  created_by_id       :bigint
#  updated_by_id       :bigint
#  from_osm            :boolean          default("false")
#  original_id         :bigint
#  source              :string
#  make_phone_calls    :boolean          default("false")
#  phone_call_interval :integer          default("60")
#  municipality        :string
#
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

  describe 'open_right_now?' do
    let(:store) { create(:store) }

    it 'should return closed if no weekdays defined and time is past close time' do
      allow(Time).to receive(:current).and_return(Time.zone.parse('23:00'))
      expect(store.open_right_now?).to be(false)
    end

    it 'should return closed if no weekdays defined and time is before default open time' do
      allow(Time).to receive(:current).and_return(Time.zone.parse('7:00'))
      expect(store.open_right_now?).to be(false)
    end

    it 'should return open if no weekdays defined and time is inside open defaults' do
      allow(Time).to receive(:current).and_return(Time.zone.parse('12:00'))
      expect(store.open_right_now?).to be(true)
    end

    context 'store with weekday defined' do
      let!(:week_day) {
        create(:week_day, store_id: store.id, day: Date.current.wday,
                          opening_hour: Time.zone.parse('10:00'),
                          closing_hour: Time.zone.parse('12:00'),
                          opening_hour_2: Time.zone.parse('15:00'),
                          closing_hour_2: Time.zone.parse('17:00'))
      }
      it 'should return close if time is before 10' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('9:00'))
        expect(store.open_right_now?).to be(false)
      end
      it 'should return open if time is between 10 an 12:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('10:00'))
        expect(store.open_right_now?).to be(true)
      end
      it 'should return close if time is between 12 an 15:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('13:00'))
        expect(store.open_right_now?).to be(false)
      end
      it 'should return open if time is between 15 an 17:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('15:30'))
        expect(store.open_right_now?).to be(true)
      end
      it 'should return close if time is after 17:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('17:10'))
        expect(store.open_right_now?).to be(false)
      end
    end

    context 'store with weekday defined without hours' do
      let!(:week_day) {
        create(:week_day, store_id: store.id, day: Date.current.wday,
                          open: true, opening_hour: nil, closing_hour: nil,
                          opening_hour_2: nil, closing_hour_2: nil)
      }
      it 'should return close if time is before 10' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('7:00'))
        expect(store.open_right_now?).to be(false)
      end
      it 'should return open if time is between 10 an 12:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('10:00'))
        expect(store.open_right_now?).to be(true)
      end
      it 'should return open if time is between 12 an 15:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('13:00'))
        expect(store.open_right_now?).to be(true)
      end
      it 'should return open if time is between 15 an 17:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('15:30'))
        expect(store.open_right_now?).to be(true)
      end
      it 'should return close if time is after 23:00' do
        allow(Time).to receive(:current).and_return(Time.zone.parse('23:10'))
        expect(store.open_right_now?).to be(false)
      end
    end
  end
end
