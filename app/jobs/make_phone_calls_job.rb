class MakePhoneCallsJob < ApplicationJob
  queue_as :phone_calls

  require 'net/http'
  require 'open-uri'

  def perform(*args)
    phone = args['phone'] || '+351919116159'
    store = arg['store'] || '12345' # random number in case there's no store
    endpoint = ENV['APIGEE_URL'].gsub('_store_id_', store)
    uri = URI.parse endpoint
    apikey = ENV['APIGEE_KEY']

    data = { number: phone }
    headers = { apikey: apikey, 'Content-Type': 'application/json'}

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = data.to_json
    response = https.request(request)
  end
end
