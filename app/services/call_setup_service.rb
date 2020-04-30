class CallSetupService
  # Find all the phone stores for which there an active calendar for the current day of the week
  # For each store, create a job to make the request
  def call
    week_day = DateTime.new.wday
    stores = Store.where(make_phone_calls: true)
      .joins(:week_days).where(week_days: {day: week_day, active: true}).joins(:phones)

    stores.each do |store|
      phone_number = store.phones.first.phone_number
      store_schedule = store.week_days.find_by(day: week_day)
      call_shift = rand(400)

      o_hour = store_schedule.opening_hour
      c_hour = store_schedule.closing_hour
      start_at = DateTime.current.change(hour: o_hour.hour, min: o_hour.min) + call_shift.seconds
      end_at = DateTime.current.change(hour: c_hour.hour, min: c_hour.min)

      times = [start_at]
      times << (times.last + store.phone_call_interval.minutes) while times.last < end_at

      times.each do |time|
        MakePhoneCallsJob.set(wait_until: time)
          .perform_later(phone_number, store.original_id)
      end
    end
  end
end
