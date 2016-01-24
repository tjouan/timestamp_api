require "spec_helper"

describe TimestampAPI::MissingAPIKey do
  it "defines a custom message" do
    expect(TimestampAPI::MissingAPIKey.instance_methods(false)).to include :message
    expect(TimestampAPI::MissingAPIKey.new.message).to_not be_nil
    expect(TimestampAPI::MissingAPIKey.new.message).to_not be_empty
  end
end

describe TimestampAPI::InvalidServerResponse do
  it "defines a custom message" do
    expect(TimestampAPI::InvalidServerResponse.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidServerResponse.new.message).to_not be_nil
    expect(TimestampAPI::InvalidServerResponse.new.message).to_not be_empty
  end
end
