module TimestampAPI
  class Project < Model
    api_path "/projects"

    has_attributes :id, :created_at, :updated_at, :name, :code, :color, :initiation_date,
                   :target_completion_date, :is_archived, :is_billable, :is_public, :is_approvable

    belongs_to :client

    def enter_time(task_id, day, duration_in_minutes, comment = "")
      TimestampAPI.request(:post, "#{@@api_path}/#{id}/enterTime", {}, {
        task_id:    task_id,
        day:        day.strftime("%FT%T%:z"),
        time_value: duration_in_minutes,
        time_unit:  "Minutes",
        comment:    comment
      }).object
    end
  end
end
