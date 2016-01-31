require "rest-client"
require "colorize"
require "hooks"

require "timestamp_api/version"
require "timestamp_api/errors"
require "timestamp_api/utils"
require "timestamp_api/model_registry"
require "timestamp_api/model_attributes"
require "timestamp_api/model_relations"
require "timestamp_api/model_default_api_methods"
require "timestamp_api/model"
require "timestamp_api/collection"
require "timestamp_api/models/project"
require "timestamp_api/models/client"
require "timestamp_api/models/task"

module TimestampAPI
  extend Utils

  @api_endpoint = "https://api.ontimestamp.com/api"

  class << self
    attr_accessor :api_endpoint, :api_key, :verbose
  end

  def self.request(method, path, query_params = {})
    output(method, path, camelize_keys(query_params)) if verbose
    response = RestClient::Request.execute(request_options(method, path, camelize_keys(query_params)))
    modelify(JSON.parse(response))
  rescue RestClient::Forbidden
    raise InvalidAPIKey
  rescue JSON::ParserError
    raise InvalidServerResponse
  end

private

  def self.request_options(method, path, query_params)
    {
      method:  method,
      url:     api_endpoint + path,
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

  def self.output(method, path, query_params)
    print "TimestampAPI ".colorize(:red)
    print "#{method.upcase} ".colorize(:yellow)
    full_path =  path
    full_path += "?#{query_params.each_with_object([]) { |p, acc| acc << "#{p[0]}=#{p[1]}" }.join("&")}" unless query_params.empty?
    puts full_path.colorize(:yellow)
  end
end
