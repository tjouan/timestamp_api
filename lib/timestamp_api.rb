require "rest-client"
require "recursive-open-struct"

require "timestamp_api/version"
require "timestamp_api/errors"
require "timestamp_api/project"

module TimestampAPI
  @api_endpoint = "https://api.ontimestamp.com/api"

  class << self
    attr_accessor :api_endpoint, :api_key
  end

  def self.request(method, url, query_params = {})
    response = RestClient::Request.execute(request_options(method, url, query_params))
    objectify(JSON.parse(response))
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

  def self.objectify(json)
    case json
    when Array then json.map { |item| RecursiveOpenStruct.new(item, recurse_over_arrays: true) }
    when Hash  then RecursiveOpenStruct.new(json, recurse_over_arrays: true)
    end
  end
end
