module TimestampAPI
  class Client < Model
    api_path "/clients"

    has_attributes :id, :created_at, :updated_at, :name, :code, :is_archived, :is_account_default
  end
end
