module TimestampAPI
  class ModelRegistry
    class << self

      @@registry = {}

      def register(klass)
        @@registry[registry_key(klass)] = klass
      end

      def registry
        @@registry
      end

      def model_for(json_data)
        raise UnknownModelData.new unless json_data.is_a? Hash
        registry[json_data["object"]] || raise(UnknownModelData.new(json_data["object"]))
      end

    private

      def registry_key(klass)
        klass.name.split("::").last.gsub(/(.)([A-Z])/, '\1_\2').downcase
      end
    end
  end
end
