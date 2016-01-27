module TimestampAPI
  class Model
    def initialize(json_data)
      validate_init_data! json_data
      @@attributes.each { |attr| instance_variable_set(:"@#{attr}", json_data[camelize(attr)]) }
    end

    def self.has_attributes(*attributes)
      attr_accessor *attributes
      @@attributes = attributes
    end

    def self.inherited(subclass)
      ModelRegistry.register(subclass)
    end

  private

    def camelize(symbol)
      symbol.to_s.split('_').each_with_index.map{ |chunk, idx| idx == 0 ? chunk : chunk.capitalize }.join
    end

    def validate_init_data!(json_data)
      class_basename = self.class.name.split("::").last
      raise InvalidModelData.new(class_basename, json_data) unless json_data.is_a?(Hash) && json_data["object"] == class_basename.downcase
    end
  end
end
