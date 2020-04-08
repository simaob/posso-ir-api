JSONAPI.configure do |config|
  config.exception_class_whitelist = [TooManyRequestsError]
  config.resource_cache = Rails.cache
  config.always_include_to_one_linkage_data = false

  config.default_paginator = :paged

  config.default_page_size = 100
  config.maximum_page_size = 150

  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count
  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :page_count
end
