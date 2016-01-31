require "spec_helper"

describe TimestampAPI::Client do
  it "inherits from Model" do
    expect(TimestampAPI::Client.superclass).to be TimestampAPI::Model
  end

  it "has `/projects` as api_path" do
    expect(TimestampAPI::Client.api_path).to eq "/clients"
  end
end
