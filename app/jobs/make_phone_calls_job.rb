class MakePhoneCallsJob < ApplicationJob
  queue_as :phone_calls

  require 'net/http'

  def perform(phone, store)
    Sidekiq.logger.debug("Going to make a phone call to #{phone}")

    store ||= '12345' # random number in case there's no store
    endpoint = ENV['APIGEE_URL'].gsub('_store_id_', store.to_s)
    uri = URI.parse endpoint
    apikey = ENV['APIGEE_KEY']

    data = {number: phone}
    headers = {apikey: apikey, 'Content-Type': 'application/json'}

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = data.to_json
    https.request(request)
  end
end
