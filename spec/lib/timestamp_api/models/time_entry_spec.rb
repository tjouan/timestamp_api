require "spec_helper"

describe TimestampAPI::TimeEntry do
  it "inherits from Model" do
    expect(TimestampAPI::TimeEntry.superclass).to be TimestampAPI::Model
  end

  it "has `/timeEntries` as api_path" do
    expect(TimestampAPI::TimeEntry.api_path).to eq "/timeEntries"
  end

  describe ".for_task_id" do
    let(:task) { double(:task, id: "t1") }

    subject { TimestampAPI::TimeEntry.for_task_id(task.id) }

    it "calls .all with proper query parameters" do
      expect(TimestampAPI::TimeEntry).to receive(:all).with("$filter" => "TaskId%20eq%20#{task.id}")
      subject
    end
  end
end
