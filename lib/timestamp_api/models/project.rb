module TimestampAPI
  class Project < Model
    has_attributes :id, :created_at, :updated_at, :account_id, :name, :code, :color, :initiation_date,
                   :target_completion_date, :is_archived, :is_billable, :is_public, :is_approvable

    class << self
      def all
        TimestampAPI.request(:get, "/projects")
      end

      def find(id)
        TimestampAPI.request(:get, "/projects/#{id}")
      end
    end
  end
end
