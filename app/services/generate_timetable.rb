class GenerateTimetable
  def call(store)
    return if store.week_days.any?

    (0..6).each { |day| WeekDay.create!(store_id: store.id, day: day) }
  end
end
