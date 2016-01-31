module TimestampAPI
  module ModelAttributes
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        alias_method :initialize_without_attributes, :initialize
        def initialize(json_data)
          initialize_without_attributes(json_data)
          initialize_attributes
        end

        class << self
          alias_method :inherited_without_attributes, :inherited
          def inherited(subclass)
            inherited_without_attributes(subclass)
            subclass.class_variable_set(:@@attributes, [])
          end
        end
      end
    end

    module ClassMethods
      def has_attributes(*attributes)
        self.class_variable_set(:@@attributes, self.class_variable_get(:@@attributes) + attributes)
        define_attributes_getters(*attributes)
      end

    private

      def define_attributes_getters(*attributes)
        self.send(:attr_accessor, *attributes)
      end
    end

    def initialize_attributes
      self.class.class_variable_get(:@@attributes).each do |attribute|
        instance_variable_set(:"@#{attribute}", json_data[camelize(attribute)])
      end
    end
  end
end
