require "spec_helper"

describe TimestampAPI::Model do

  before { fake_model("Fake") { has_attributes :name, :age, :born_at } }

  it "registers subclass to the model registry" do
    expect(TimestampAPI::ModelRegistry.registry["fake"]).to eq Fake
  end

  it "includes ModelAttributes" do
    expect(TimestampAPI::Model.included_modules).to include TimestampAPI::ModelAttributes
  end

  it "includes ModelRelations" do
    expect(TimestampAPI::Model.included_modules).to include TimestampAPI::ModelRelations
  end

  it "includes ModelDefaultAPIMethods" do
    expect(TimestampAPI::Model.included_modules).to include TimestampAPI::ModelDefaultAPIMethods
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
end
