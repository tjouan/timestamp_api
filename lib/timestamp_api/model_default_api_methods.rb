module TimestampAPI
  module ModelDefaultAPIMethods
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class << self
          alias_method :inherited_without_default_api_methods, :inherited
          define_method(:inherited) do |subclass|
            inherited_without_default_api_methods(subclass)
            subclass.class_variable_set(:@@api_path, nil)
          end
        end
      end
    end

    module ClassMethods
      def api_path(path = nil)
        path.nil? ? self.class_variable_get(:@@api_path) : self.class_variable_set(:@@api_path, path)
      end

      def all
        raise APIPathNotSet.new(self) if api_path.nil?
        TimestampAPI.request(:get, api_path)
      end

      def find(id)
        return nil if id.nil?
        raise APIPathNotSet.new(self) if api_path.nil?
        TimestampAPI.request(:get, "#{api_path}/#{id}")
      rescue RestClient::ResourceNotFound
        raise ResourceNotFound.new(self, id)
      end
    end
  end
end
