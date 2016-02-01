module TimestampAPI
  class ModelRegistry
    extend Utils

    class << self

      @@registry = {}

      def register(klass)
        @@registry[registry_key(klass)] = klass unless klass.name.nil?
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
        camelize(klass.name.split("::").last)
      end
    end
  end
end
