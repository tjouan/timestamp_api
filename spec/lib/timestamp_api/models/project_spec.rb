require "spec_helper"

describe TimestampAPI::Project do
  it "inherits from Model" do
    expect(TimestampAPI::Project.superclass).to be TimestampAPI::Model
  end

  it "has `/projects` as api_path" do
    expect(TimestampAPI::Project.api_path).to eq "/projects"
  end
end
