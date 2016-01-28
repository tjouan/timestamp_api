require "spec_helper"

describe TimestampAPI::Project, ".all" do
  it "calls GET /projects" do
    expect(TimestampAPI).to receive(:request).with(:get, "/projects")
    TimestampAPI::Project.all
  end
end

describe TimestampAPI::Project, ".find(id)" do
  it "calls GET /projects/:id" do
    expect(TimestampAPI).to receive(:request).with(:get, "/projects/42")
    TimestampAPI::Project.find(42)
  end

  it "returns nil if `id` is nil" do
    expect(TimestampAPI::Project.find(nil)).to be nil
  end

  context "when no project with this id exists" do
    before { allow(TimestampAPI).to receive(:request).with(:get, "/projects/not_existing").and_raise(RestClient::ResourceNotFound) }

    it "raises a ResourceNotFound error" do
      expect{ TimestampAPI::Project.find("not_existing") }.to raise_error TimestampAPI::ResourceNotFound
    end
  end
end
