module TimestampAPI
  class Task < Model
    api_path "/tasks"

    has_attributes :id, :created_at, :updated_at, :name, :is_archived, :is_billable

    belongs_to :project

    def self.for_project_id(project_id)
      all(project_id: project_id)
    end
  end
end
