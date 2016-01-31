module TimestampAPI
  class Project < Model
    api_path "/projects"

    has_attributes :id, :created_at, :updated_at, :account_id, :name, :code, :color, :initiation_date,
                   :target_completion_date, :is_archived, :is_billable, :is_public, :is_approvable

    belongs_to :client
  end
end
