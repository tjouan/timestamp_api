require "spec_helper"

describe TimestampAPI::ModelAttributes do
  let(:json_data) { {"object" => "fake", "name" => "Georges", "bornAt" => "60 years ago"} }

  before do
    stub_const("FakeBaseModel", Class.new)
    FakeBaseModel.class_eval do
      attr_reader :json_data

      def initialize(json_data)
        @json_data = json_data
      end

      include TimestampAPI::ModelAttributes
    end
    fake_model("Fake", FakeBaseModel)
  end

  subject { Fake.new(json_data) }

  context "when an attribute is defined" do
    before { Fake.class_eval { has_attributes :name } }

    it "provides a getter to its initialisation data" do
      expect(subject.name).to eq json_data["name"]
    end

    it "handles multiple `has_attributes` definitions" do
      Fake.class_eval{ has_attributes :born_at }
      expect(subject.born_at).to eq json_data["bornAt"]
      expect(subject.name).to eq json_data["name"]
    end
  end

  context "when attribute has multiple words" do
    before { Fake.class_eval{ has_attributes :born_at } }

    it "snakecases initialisation data keys (they are camelcased in API response data)" do
      expect(subject.born_at).to eq json_data["bornAt"]
    end
  end

  context "when an attribute is not defined" do
    it "does not provide a getter for it" do
      expect{ subject.undeclared_attribute }.to raise_error NoMethodError
    end
  end

  context "when a defined attribute is not initialized" do
    before { Fake.class_eval { has_attributes :age } }

    it "returns nil" do
      expect(subject.age).to be nil
    end
  end
end
