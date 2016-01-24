require "spec_helper"

describe TimestampAPI::MissingAPIKey do
  it "defines a custom message" do
    expect(TimestampAPI::MissingAPIKey.instance_methods(false)).to include :message
  end
end

describe TimestampAPI::InvalidServerResponse do
  it "defines a custom message" do
    expect(TimestampAPI::InvalidServerResponse.instance_methods(false)).to include :message
  end
end
