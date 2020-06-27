# == Schema Information
#
# Table name: week_days
#
#  id             :bigint           not null, primary key
#  day            :integer          not null
#  opening_hour   :time
#  closing_hour   :time
#  active         :boolean          default("false")
#  timestamps     :string
#  store_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  open           :boolean          default("true")
#  opening_hour_2 :time
#  closing_hour_2 :time
#
class WeekDay < ApplicationRecord
  belongs_to :store

  validates :day, uniqueness: {scope: :store_id}
  validates :opening_hour, :closing_hour, presence: true, if: :active
  validate :time_order, :time_order_2, :time_slots_sequence

  enum day: {sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

  scope :today, -> { where(day: DateTime.now.wday) }

  def open_now?
    return false unless open?

    (opening_hour.present? && closing_hour.present? &&
     (opening_hour.to_s(:time)..closing_hour.to_s(:time)).cover?(Time.current)) ||
      (opening_hour_2.present? && closing_hour_2.present? &&
       (opening_hour_2.to_s(:time)..closing_hour_2.to_s(:time)).cover?(Time.current))
  end

  def times_set?
    (opening_hour.present? && closing_hour.present?) ||
      (opening_hour_2.present? && closing_hour_2.present?)
  end

  private

  def time_order
    return if opening_hour.blank? && closing_hour.blank?
    unless opening_hour.present? && closing_hour.present?
      return errors.add(:opening_hour, 'You must fill in both opening and closing hours')
    end

    errors.add(:opening_hour, 'You must open before you close') if opening_hour > closing_hour
  end

  def time_order_2
    return if opening_hour_2.blank? && closing_hour_2.blank?
    unless opening_hour_2.present? && closing_hour_2.present?
      return errors.add(:opening_hour_2, 'You must fill in both opening and closing hours (secondary)')
    end

    errors.add(:opening_hour_2, 'You must open before you close') if opening_hour_2 > closing_hour_2
  end

  def time_slots_sequence
    return if closing_hour.blank? || opening_hour_2.blank?

    errors.add(:opening_hour_2, 'You must open before you close') if closing_hour > opening_hour_2
  end
end
