module TimestampAPI
  class Project
    def self.all
      TimestampAPI.request(:get, "/projects")
    end

    def self.find(id)
      TimestampAPI.request(:get, "/projects/#{id}")
    end
  end
end
