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
end
