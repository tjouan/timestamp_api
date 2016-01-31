require "spec_helper"

describe TimestampAPI::ModelDefaultAPIMethods do
  before do
    stub_const("Fake", Class.new)
    Fake.class_eval { include TimestampAPI::ModelDefaultAPIMethods }
  end

  describe ".api_path" do
    context "with an argument" do
      it "sets @@api_path" do
        Fake.class_eval { api_path "/fakes" }
        expect(Fake.class_variable_get(:@@api_path)).to eq "/fakes"
      end
    end

    context "without an argument" do
      it "gets @@api_path" do
        Fake.class_variable_set(:@@api_path, "/fakes")
        expect(Fake.api_path).to eq "/fakes"
      end
    end
  end

  describe ".all" do
    before { Fake.class_eval { api_path "/fakes" } }

    it "calls GET :api_path" do
      expect(TimestampAPI).to receive(:request).with(:get, "/fakes")
      Fake.all
    end

    context "when `api_path` is not set" do
      before { Fake.class_variable_set(:@@api_path, nil) }

      it "raises a APIPathNotSet errorl" do
        expect{ Fake.all }.to raise_error TimestampAPI::APIPathNotSet
      end
    end
  end

  describe ".find(id)" do
    before { Fake.class_eval { api_path "/fakes" } }

    it "calls GET :api_path/:id" do
      expect(TimestampAPI).to receive(:request).with(:get, "/fakes/42")
      Fake.find(42)
    end

    it "returns nil if `id` is nil" do
      expect(Fake.find(nil)).to be nil
    end

    context "when no project with this id exists" do
      before { allow(TimestampAPI).to receive(:request).with(:get, "/fakes/not_existing").and_raise(RestClient::ResourceNotFound) }

      it "raises a ResourceNotFound error" do
        expect{ Fake.find("not_existing") }.to raise_error TimestampAPI::ResourceNotFound
      end
    end

    context "when `api_path` is not set" do
      before { Fake.class_variable_set(:@@api_path, nil) }

      it "raises a APIPathNotSet errorl" do
        expect{ Fake.all }.to raise_error TimestampAPI::APIPathNotSet
      end
    end
  end
end
