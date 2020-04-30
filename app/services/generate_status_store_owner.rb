class GenerateStatusStoreOwner
  def call
    generates_statuses
  end

  private

  # TODO: Not optimized at all. It's just code that's fast to write and slow to execute
  # but I don't care cause it's a "run once" task
  def generates_statuses
    Store.find_each.with_index do |store, index|
      Rails.logger.info "Imported #{index}" if (index % 100).zero?
      next if store.status_store_owners.any?

      status = StatusStoreOwner.new(store_id: store.id,
                                    updated_time: Time.current, active: true)
      status.save!(validate: false)
    end
  end
end
