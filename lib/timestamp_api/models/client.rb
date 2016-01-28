module TimestampAPI
  class Client < Model
    has_attributes :id, :created_at, :updated_at, :account_id, :name, :code, :is_archived, :is_account_default

    class << self
      def all
        TimestampAPI.request(:get, "/clients")
      end

      def find(id)
        TimestampAPI.request(:get, "/clients/#{id}")
      end
    end
  end
end
