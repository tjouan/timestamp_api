require "spec_helper"

describe TimestampAPI::Project do
  it "inherits from Model" do
    expect(TimestampAPI::Project.superclass).to be TimestampAPI::Model
  end

  it "has `/projects` as api_path" do
    expect(TimestampAPI::Project.api_path).to eq "/projects"
  end

  describe "#enter_time" do
    let(:project)    { TimestampAPI::Project.new("object" => "project", "id" => "p1") }
    let(:task_id)    { 123 }
    let(:day)        { Date.today }
    let(:duration)   { 240 }
    let(:comment)    { "Stuff was done" }
    let(:event)      { Event.new("object" => "event") }
    let(:time_entry) { TimeEntry.new("object" => "timeEntry") }

    before do
      fake_model("TimeEntry")
      fake_model("Event")
      allow_any_instance_of(Event).to receive(:object).and_return(time_entry)
    end

    subject { project.enter_time(task_id, day, duration, comment) }

    it "makes a POST request to /projects/:id/enterTime" do
      expect(TimestampAPI).to receive(:request).with(:post, "/projects/#{project.id}/enterTime", {}, anything()).and_return(event)
      subject
    end

    it "make a POST request with correct payload" do
      payload = {
        task_id:    task_id,
        day:        day.strftime("%FT%T%:z"),
        time_value: duration,
        time_unit:  "Minutes",
        comment:    comment
      }
      expect(TimestampAPI).to receive(:request).with(:post, anything(), anything(), payload).and_return(event)
      subject
    end

    it "extracts object out of returned Event" do
      expect(TimestampAPI).to receive(:request).and_return(event)
      expect(event).to receive(:object)
      subject
    end
  end
end
