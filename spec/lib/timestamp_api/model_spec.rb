require "spec_helper"

describe TimestampAPI::Model do

  before { fake_model("Fake") { has_attributes :name, :age, :born_at } }

  it "registers subclass to the model registry" do
    expect(TimestampAPI::ModelRegistry.registry["fake"]).to eq Fake
  end

  describe "#initialize" do
    let(:json_data) { {"object" => "fake", "name" => "Georges", "undeclaredAttribute" => "hidden"} }

    subject { Fake.new(json_data) }

    context "with non-JSON data" do
      let(:json_data) { "not JSON data" }

      it "is raises a InvalidModelData error" do
        expect{ subject }.to raise_error TimestampAPI::InvalidModelData
      end
    end

    context "without an `object` field" do
      let(:json_data) { {"name" => "Georges"} }

      it "is raises a InvalidModelData error" do
        expect{ subject }.to raise_error TimestampAPI::InvalidModelData
      end
    end

    context "with an `object` field that doesn't match the subclass name" do
      let(:json_data) { {"object" => "not_fake", "name" => "Georges"} }

      it "is raises a InvalidModelData error" do
        expect{ subject }.to raise_error TimestampAPI::InvalidModelData
      end
    end

    context "with an `object` field that matches the subclass name" do
      it "is works" do
        expect{ subject }.to_not raise_error
      end
    end
  end

  describe "attributes" do
    let(:json_data) { {"object" => "fake", "name" => "Georges", "bornAt" => "60 years ago"} }

    subject { Fake.new(json_data) }

    it "provides configurable attributes to access initialisation data" do
      expect(subject.name).to eq json_data["name"]
    end

    it "does not access JSON data if the attribute has not been defined" do
      expect{ subject.undeclared_attribute }.to raise_error NoMethodError
    end

    it "handles multiple `has_attributes` definitions" do
      Fake.class_eval{ has_attributes :undeclared_attribute }
      expect(subject.undeclared_attribute).to eq json_data["undeclaredAttribute"]
      expect(subject.name).to eq json_data["name"]
    end

    it "does not require all defined attributes to have an initialisation data" do
      expect(subject.age).to be nil
    end

    it "snakecases initialisation data keys (that are camelcased)" do
      expect(subject.born_at).to eq json_data["bornAt"]
    end
  end
end
