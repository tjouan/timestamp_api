require "spec_helper"

describe TimestampAPI::Client, ".all" do
  it "calls GET /clients" do
    expect(TimestampAPI).to receive(:request).with(:get, "/clients")
    TimestampAPI::Client.all
  end
end

describe TimestampAPI::Client, ".find(id)" do
  it "calls GET /clients/:id" do
    expect(TimestampAPI).to receive(:request).with(:get, "/clients/42")
    TimestampAPI::Client.find(42)
  end

  it "returns nil if `id` is nil" do
    expect(TimestampAPI::Client.find(nil)).to be nil
  end
end
