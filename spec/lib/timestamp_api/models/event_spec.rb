require "spec_helper"

describe TimestampAPI::Event do
  it "inherits from Model" do
    expect(TimestampAPI::Event.superclass).to be TimestampAPI::Model
  end

  it "has `/events` as api_path" do
    expect(TimestampAPI::Event.api_path).to eq "/events"
  end

  describe "#object" do
    let(:task_json_data) { {"object" => "task", "id" => "t1"} }

    before { fake_model("Task") }

    subject { TimestampAPI::Event.new("object" => "event", "resourceObject" => "task", "data" => task_json_data) }

    it "creates a model object out of `data`" do
      expect(TimestampAPI::ModelRegistry).to receive(:model_for).with(task_json_data).and_return(Task)
      expect(Task).to receive(:new)
      subject.object
    end
  end
end
