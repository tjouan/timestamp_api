require "spec_helper"

describe TimestampAPI::Task do
  let(:project) { double(:project, id: "p1") }

  it "inherits from Model" do
    expect(TimestampAPI::Task.superclass).to be TimestampAPI::Model
  end

  it "has `/projects` as api_path" do
    expect(TimestampAPI::Task.api_path).to eq "/tasks"
  end

  describe ".for_project_id" do
    subject { TimestampAPI::Task.for_project_id(project.id) }

    it "calls .all with proper query parameters" do
      expect(TimestampAPI::Task).to receive(:all).with(project_id: project.id)
      subject
    end
  end
end
