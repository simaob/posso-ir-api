class CalculateStatus
  UPDATE_TIME = 1

  def log(msg)
    Rails.logger.info msg
  end

  def call
    duration = Benchmark.ms do
      log 'Calculating the Crowdsource status'
      StatusCrowdsource
        .joins(store: :status_crowdsource_users)
        .where('status_crowdsource_users.created_at > ?', 2.hours.ago)
        .find_each.with_index do |s, i|
        log "Calculated #{i}" if (i % 100).zero?
        s.calculate_status
      end

      log 'Calculating the status'
      log 'Calculating the general status for store owners'

      where_clause = <<-SQL
        statuses.updated_time < status_store_owners_stores.updated_time
        AND status_store_owners_stores.active = true
      SQL

      # TODO: This can be optimized
      Store.includes(:status_store_owners, :status_general)
        .joins(:status_general).joins(:status_store_owners)
        .where(where_clause).find_each.with_index do |store, i|
        log "Calculated #{i}" if (i % 100).zero?
        owner = store.status_store_owners.order(created_at: :desc).first
        store.status_general.update!(
          status: owner.status,
          updated_time: owner.updated_time,
          valid_until: owner.updated_time + UPDATE_TIME.hour,
          is_official: true,
          estimation: false
        )
      end

      log 'Calculating the general status'

      where_clause = <<-SQL
        (statuses.updated_time < status_crowdsources_stores.updated_time) AND
        (
          (statuses.is_official = false) OR
          (statuses.valid_until = NULL OR
           statuses.valid_until < status_crowdsources_stores.updated_time )
        )
      SQL

      # TODO: This can be optimized
      Store.includes(:status_general, :status_crowdsources)
        .joins(:status_general, :status_crowdsources)
        .where(where_clause).find_each.with_index do |store, i|
        log "Calculated #{i}" if (i % 100).zero?
        crowdsource = store.status_crowdsources.first
        store.status_general.update(
          status: crowdsource.status,
          updated_time: crowdsource.updated_time,
          valid_until: nil,
          is_official: false,
          estimation: false
        )
      end
    end
    log "Finished calculating the statuses in #{duration} ms"
  end
end
