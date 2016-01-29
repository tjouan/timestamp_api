module TimestampAPI
  class Model
    def self.inherited(subclass)
      self.send(:attr_reader, :json_data)
      subclass.class_variable_set(:@@attributes, [])
      subclass.class_variable_set(:@@belongs_to, [])
      ModelRegistry.register(subclass)
    end

    def self.has_attributes(*attributes)
      self.class_variable_set(:@@attributes, self.class_variable_get(:@@attributes) + attributes)
      define_attributes_getters(*attributes)
    end

    def self.belongs_to(association_name)
      self.class_variable_set(:@@belongs_to, self.class_variable_get(:@@belongs_to) + [association_name])
      define_belongs_to_getter(association_name)
    end

    def initialize(json_data)
      @json_data = json_data
      validate_init_data!
      initialize_attributes
      initialize_belongs_to
    end

  private

    def camelize(symbol)
      symbol.to_s.split('_').each_with_index.map{ |chunk, idx| idx == 0 ? chunk : chunk.capitalize }.join
    end

    def validate_init_data!
      class_basename = self.class.name.split("::").last
      raise InvalidModelData.new(class_basename, json_data) unless json_data.is_a?(Hash) && json_data["object"] == class_basename.downcase
    end

    def self.define_belongs_to_getter(association_name)
      define_method(association_name) do
        return instance_variable_get(:"@#{association_name}") unless instance_variable_get(:"@#{association_name}").nil?
        unknown_association_error = UnknownAssociation.new(self, association_name)
        associationship_id = instance_variable_get(:"@_#{association_name}_id")
        association_class  = ModelRegistry.registry[association_name.to_s] || raise(unknown_association_error)
        instance_variable_set(:"@#{association_name}", association_class.find(associationship_id))
      end
    end

    def self.define_attributes_getters(*attributes)
      self.send(:attr_accessor, *attributes)
    end

    def initialize_attributes
      self.class.class_variable_get(:@@attributes).each do |attribute|
        instance_variable_set(:"@#{attribute}", json_data[camelize(attribute)])
      end
    end

    def initialize_belongs_to
      self.class.class_variable_get(:@@belongs_to).each do |association_name|
        instance_variable_set(:"@_#{association_name}_id", json_data[camelize(association_name)]["id"]) if json_data.has_key? camelize(association_name)
      end
    end
  end
end
