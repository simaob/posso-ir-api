JSONAPI.configure do |config|
  config.exception_class_whitelist = [TooManyRequestsError]
end