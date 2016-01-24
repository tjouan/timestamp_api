require "rest-client"
require "active_support/all"

require "timestamp_api/version"

module TimestampAPI
  @api_endpoint = "https://api.ontimestamp.com/api"

  class << self
    attr_accessor :api_endpoint, :api_key
  end

  def self.request(method, url)
    response = RestClient::Request.execute(request_options(method, url))
    json_with_indifferent_access(JSON.parse(response))
  end

  def self.request_options(method, url)
    {
      method:  method,
      url:     api_endpoint + url,
      headers: {
        "X-API-Key" => api_key || ENV["TIMESTAMP_API_KEY"],
        :accept     => :json,
        :user_agent => "TimestampAPI Ruby gem https://github.com/alpinelab/timestamp_api"
      }
    }
  end

  def self.json_with_indifferent_access(json)
    case json
    when Array then json.map(&:with_indifferent_access)
    when Hash  then json.with_indifferent_access
    else json
    end
  end
end
