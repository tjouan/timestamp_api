module TimestampAPI
  class MissingAPIKey < StandardError
    def message
      "API key must be configured either via the `TIMESTAMP_API_KEY` environment variable or using `TimestampAPi.api_key = \"YOUR_TIMESTAMP_API_KEY\"`."
    end
  end

  class InvalidAPIKey < StandardError
    def message
      "Configured API key is invalid."
    end
  end

  class InvalidServerResponse < StandardError
    def message
      "Server responded with invalid JSON."
    end
  end

  class InvalidModelData < StandardError
    attr_reader :caller_class, :json_data

    def initialize(caller_class, json_data)
      @caller_class = caller_class
      @json_data    = json_data
    end

    def message
      if json_data.is_a? Hash
        "A `#{caller_class}` class was initialized with JSON data for a `#{json_data["object"] || "unknown"}` object."
      else
        "A `#{caller_class}` class was initialized with data which is not a `Hash` (it was a `#{json_data.class}`, actually)."
      end
    end
  end

  class UnknownModelData < StandardError
    attr_reader :json_object

    def initialize(json_object = nil)
      @json_object = json_object
    end

    def message
      if json_object
        "JSON data with object type `#{json_object}` has no matching model implemented."
      else
        "JSON data doesn't have an `object` field or it's not valid JSON data."
      end
    end
  end

  class InvalidWhereContitions < StandardError
    def message
      "Conditions passed to `Collection#where` must be a hash."
    end
  end
end
