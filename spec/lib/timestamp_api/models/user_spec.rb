require "spec_helper"

describe TimestampAPI::User do
  it "inherits from Model" do
    expect(TimestampAPI::User.superclass).to be TimestampAPI::Model
  end

  it "has `/users` as api_path" do
    expect(TimestampAPI::User.api_path).to eq "/users"
  end
end
