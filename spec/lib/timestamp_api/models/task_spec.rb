require "spec_helper"

describe TimestampAPI::Task do
  it "inherits from Model" do
    expect(TimestampAPI::Task.superclass).to be TimestampAPI::Model
  end

  it "has `/projects` as api_path" do
    expect(TimestampAPI::Task.api_path).to eq "/tasks"
  end
end
