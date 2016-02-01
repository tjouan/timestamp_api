module TimestampAPI
  class Event < Model
    api_path "/events"

    has_attributes :resource_object, :change_type, :data

    def object
      TimestampAPI::ModelRegistry.model_for(data).new(data)
    end
  end
end
