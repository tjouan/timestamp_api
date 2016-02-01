require "spec_helper"

describe TimestampAPI::ModelRegistry do
  describe ".registry" do
    subject { TimestampAPI::ModelRegistry.registry }

    it "returns the content of the registry" do
      expect(subject).to eq TimestampAPI::ModelRegistry.class_variable_get(:"@@registry")
    end
  end

  describe ".register(klass)" do
    let(:klass) { fake_model "Fake" }

    subject { TimestampAPI::ModelRegistry.register(klass) }

    def registry; TimestampAPI::ModelRegistry.registry; end

    it "adds the klass to the registry with its downcased name as key" do
      subject
      expect(registry["fake"]).to eq Fake
    end

    context "when klass has multiple words" do
      let(:klass) { fake_model "MultiWordModel" }

      it "camelizes klass name" do
        subject
        expect(registry).to have_key "multiWordModel"
      end
    end

    context "when klass is namespaced" do
      let(:klass) { fake_model "TimestampAPI::NamespacedModel" }

      it "de-namespaces klass name" do
        subject
        expect(registry).to have_key "namespacedModel"
      end
    end

    context "when klass is anonymous" do
      let(:klass) { Class.new }

      it "do nothing" do
        subject
        expect(registry).to_not have_key nil
      end
    end
  end

  describe ".model_for(json_data)" do
    let(:json_data) { {"object" => "fake"} }

    before { fake_model "Fake" }

    subject { TimestampAPI::ModelRegistry.model_for(json_data) }

    it "return the registry model registered with key equal to `object` field of `json_data`" do
      expect(subject).to eq Fake
    end

    context "when given param has no `object` field" do
      let(:json_data) { {some: "value"} }

      it "raises a UnknownModelData error" do
        expect{ subject }.to raise_error TimestampAPI::UnknownModelData
      end
    end

    context "when given param is not a hash" do
      let(:json_data) { "not a hash" }

      it "raises a UnknownModelData error" do
        expect{ subject }.to raise_error TimestampAPI::UnknownModelData
      end
    end
  end
end
