require "spec_helper"

describe TimestampAPI::ModelRegistry do
  class Model1; end
  class Model2; end
  class MultiWordModel; end
  class TimestampAPI::NamespacedModel; end

  before { TimestampAPI::ModelRegistry.class_variable_set(:@@registry, {}) }

  describe ".registry" do
    subject { TimestampAPI::ModelRegistry.registry }

    it "returns the content of the registry" do
      TimestampAPI::ModelRegistry.register(Model1)
      TimestampAPI::ModelRegistry.register(Model2)
      expect(subject).to eq({"model1" => Model1, "model2" => Model2})
    end

    it "is empty at initialisation" do
      expect(subject).to eq({})
    end
  end

  describe ".register(klass)" do
    let(:klass) { Model2 }

    before { TimestampAPI::ModelRegistry.class_variable_set(:@@registry, {"model1" => Model1}) }

    subject { TimestampAPI::ModelRegistry.register(klass) }

    def registry; TimestampAPI::ModelRegistry.registry; end

    it "adds the klass to the registry with its downcased name as key" do
      expect{ subject }.to change{ registry }.from({"model1" => Model1}).to({"model1" => Model1, "model2" => Model2})
    end

    context "when klass has multiple words" do
      let(:klass) { MultiWordModel }

      it "separates klass name words with underscores" do
        subject
        expect(registry).to have_key "multi_word_model"
      end
    end

    context "when klass is namespaced" do
      let(:klass) { TimestampAPI::NamespacedModel }

      it "de-namespaces klass name" do
        subject
        expect(registry).to have_key "namespaced_model"
      end
    end
  end

  describe ".model_for(json_data)" do
    let(:json_data) { {"object" => "model1"} }

    before do
      TimestampAPI::ModelRegistry.register(Model1)
      TimestampAPI::ModelRegistry.register(Model2)
    end

    subject { TimestampAPI::ModelRegistry.model_for(json_data) }

    it "return the registry model registered with key equal to `object` field of `json_data`" do
      expect(subject).to eq Model1
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
