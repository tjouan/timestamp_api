module TimestampAPI
  module ModelAttributes
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        after_initialize do
          self.class.class_variable_get(:@@attributes).each do |attribute|
            instance_variable_set(:"@#{attribute}", json_data[camelize(attribute)])
          end
        end

        after_inherited do |subclass|
          subclass.class_variable_set(:@@attributes, [])
        end
      end
    end

    module ClassMethods
      def has_attributes(*attributes)
        # Add those attributes to the list of attributes for this class
        self.class_variable_set(:@@attributes, self.class_variable_get(:@@attributes) + attributes)
        # Define getters for those attributes
        self.send(:attr_accessor, *attributes)
      end
    end
  end
end
