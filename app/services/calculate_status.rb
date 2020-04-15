class CalculateStatus
  UPDATE_TIME = 1

  def call(new_cool: true)
    puts "[#{Time.now}] Going to calculate the statuses"
    duration = Benchmark.ms do
      puts "[#{Time.now}] Calculating the Crowdsource status #{new_cool ? 'new' : 'old'}"
      StatusCrowdsource.find_each.with_index do |s, i|
        puts "Calculated #{i}" if (i % 100).zero?
        if new_cool
          s.calculate_status_new
        else
          s.calculate_status
        end
      end

      puts "[#{Time.now}] Calculating the status"
      puts "[#{Time.now}] Calculating the general status for store owners"

      where_clause = <<-SQL
        statuses.updated_time < status_store_owners_stores.updated_time
        AND status_store_owners_stores.active = true
      SQL

      # TODO: This can be optimized
      Store.includes(:status_store_owners, :status_generals)
        .joins(:status_generals).joins(:status_store_owners)
        .where(where_clause).find_each.with_index do |store, i|
        puts "Calculated #{i}" if (i % 100).zero?
        owner = store.status_store_owners.first
        general = store.status_generals.first
        general.update!(status: owner.status, updated_time: owner.updated_time,
                        valid_until: owner.updated_time + UPDATE_TIME.hour,
                        is_official: true)
      end

      puts "[#{Time.now}] Calculating the general status"

      where_clause = <<-SQL
        (statuses.updated_time < status_crowdsources_stores.updated_time) AND
        (
          (statuses.is_official = false) OR
          (statuses.valid_until = NULL OR
           statuses.valid_until < status_crowdsources_stores.updated_time )
        )
      SQL

      # TODO: This can be optimized
      Store.includes(:status_generals, :status_crowdsources)
        .joins(:status_generals, :status_crowdsources)
        .where(where_clause).find_each.with_index do |store, i|
        puts "Calculated #{i}" if (i % 100).zero?
        crowdsource = store.status_crowdsources.first
        general = store.status_generals.first
        general.update(status: crowdsource.status,
                       updated_time: crowdsource.updated_time,
                       valid_until: nil, is_official: false)
      end
    end
    puts "Finished calculating the statuses in #{duration} ms"
  end
end
