module TimestampAPI
  module ModelRelations
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        after_initialize do
          self.class.class_variable_get(:@@belongs_to).each do |association_name|
            instance_variable_set(:"@_#{association_name}_id", json_data[camelize(association_name)]["id"]) if json_data.has_key? camelize(association_name)
          end
        end

        after_inherited do |subclass|
          subclass.class_variable_set(:@@belongs_to, [])
        end
      end
    end

    module ClassMethods
      def belongs_to(association_name)
        # Add this association to the list of associations for this class
        self.class_variable_set(:@@belongs_to, self.class_variable_get(:@@belongs_to) + [association_name])
        # Define a memoizing getter for this association
        define_method(association_name) do
          return instance_variable_get(:"@#{association_name}") unless instance_variable_get(:"@#{association_name}").nil?
          unknown_association_error = UnknownAssociation.new(self, association_name)
          associationship_id = instance_variable_get(:"@_#{association_name}_id")
          association_class  = ModelRegistry.registry[association_name.to_s] || raise(unknown_association_error)
          instance_variable_set(:"@#{association_name}", association_class.find(associationship_id))
        end
      end
    end
  end
end
