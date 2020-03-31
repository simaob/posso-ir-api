JSONAPI.configure do |config|
  config.exception_class_whitelist = [TooManyRequestsError]
  config.resource_cache = Rails.cache
  config.always_include_to_one_linkage_data = false
end