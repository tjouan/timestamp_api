module TimestampAPI
  class Model
    attr_reader :json_data

    def self.inherited(subclass)
      ModelRegistry.register(subclass)
    end

    def initialize(json_data)
      @json_data = json_data
      validate_init_data!
    end

    include Utils
    include ModelAttributes
    include ModelRelations

  private

    def validate_init_data!
      class_basename = self.class.name.split("::").last
      raise InvalidModelData.new(class_basename, json_data) unless json_data.is_a?(Hash) && json_data["object"] == class_basename.downcase
    end
  end
end
