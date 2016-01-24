require "rest-client"

require "timestamp_api/version"

module TimestampAPI
  @api_endpoint = "https://api.ontimestamp.com/api"

  class << self
    attr_accessor :api_endpoint, :api_key
  end

  def self.request(method, url)
    response = RestClient::Request.execute(request_options(method, url))
    JSON.parse(response)
  end

  def self.request_options(method, url)
    {
      method: method,
      url: api_endpoint + url,
      verify_ssl: false,
      headers: {
        "X-API-Key" => api_key,
        :accept     => :json,
        :user_agent => "TimestampAPI Ruby gem https://github.com/alpinelab/timestamp_api"
      }
    }
  end
end
