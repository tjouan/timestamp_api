module TimestampAPI
  class User < Model
    api_path "/users"

    has_attributes :id, :created_at, :user_type, :first_name, :last_name, :email_address, :time_zone, :culture, :is_active,
                   :avatar_url, :last_accessed, :invited_at, :roles, :employment_type, :time_entry_mode, :importStatus, :invited
  end
end
