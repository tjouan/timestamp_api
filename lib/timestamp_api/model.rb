module TimestampAPI
  class Model
    attr_reader :json_data

    include Hooks
    define_hooks :after_initialize, :after_inherited

    include Utils
    include ModelAttributes
    include ModelRelations
    include ModelDefaultAPIMethods

    def self.inherited(subclass)
      ModelRegistry.register(subclass)
      run_hook :after_inherited, subclass
    end

    def initialize(json_data)
      @json_data = json_data
      validate_init_data!
      run_hook :after_initialize
    end

  private

    def validate_init_data!
      class_basename = self.class.name.split("::").last
      raise InvalidModelData.new(class_basename, json_data) unless json_data.is_a?(Hash) && json_data["object"] == camelize(class_basename)
    end
  end
end
