require "rest-client"

require "timestamp_api/version"
require "timestamp_api/errors"
require "timestamp_api/model_registry"
require "timestamp_api/model"
require "timestamp_api/collection"
require "timestamp_api/models/project"

module TimestampAPI
  @api_endpoint = "https://api.ontimestamp.com/api"

  class << self
    attr_accessor :api_endpoint, :api_key
  end

  def self.request(method, url, query_params = {})
    response = RestClient::Request.execute(request_options(method, url, query_params))
    modelify(JSON.parse(response))
  rescue JSON::ParserError
    raise InvalidServerResponse
  end

private

  def self.request_options(method, url, query_params)
    {
      method:  method,
      url:     api_endpoint + url,
      headers: {
        "X-API-Key" => api_key || ENV["TIMESTAMP_API_KEY"] || raise(MissingAPIKey),
        :accept     => :json,
        :user_agent => "TimestampAPI Ruby gem (https://github.com/alpinelab/timestamp_api)",
        :params     => query_params
      }
    }
  end

  def self.modelify(json)
    case json
    when Array then Collection.new(json.map { |item| modelify(item) })
    when Hash  then ModelRegistry.model_for(json).new(json)
    end
  end
end
