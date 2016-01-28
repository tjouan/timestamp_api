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

  context "when no client with this id exists" do
    before { allow(TimestampAPI).to receive(:request).with(:get, "/clients/not_existing").and_raise(RestClient::ResourceNotFound) }

    it "raises a ResourceNotFound error" do
      expect{ TimestampAPI::Client.find("not_existing") }.to raise_error TimestampAPI::ResourceNotFound
    end
  end
end
