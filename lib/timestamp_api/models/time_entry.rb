module TimestampAPI
  class TimeEntry < Model
    api_path "/timeEntries"

    has_attributes :id, :created_at, :comment, :day, :minutes, :is_archived, :is_approved, :is_invoiced, :is_externally_owned, :is_locked

    belongs_to :client
    belongs_to :project
    belongs_to :task
    belongs_to :user

    def self.for_task_id(task_id)
      all("$filter" => "TaskId%20eq%20#{task_id}")
    end
  end
end
