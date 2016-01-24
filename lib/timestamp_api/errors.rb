module TimestampAPI
  class MissingAPIKey < StandardError
    def message
      "API key must be configured either via the `TIMESTAMP_API_KEY` environment variable or using `TimestampAPi.api_key = \"YOUR_TIMESTAMP_API_KEY\"`."
    end
  end

  class InvalidServerResponse < StandardError
    def message
      "Server responded with invalid JSON. A possible cause is an invalid or revoked API key."
    end
  end
end
