require "spec_helper"

describe TimestampAPI::Model do

  before { fake_model("Fake") { has_attributes :name, :age, :born_at } }

  it "registers subclass to the model registry" do
    expect(TimestampAPI::ModelRegistry.registry["fake"]).to eq Fake
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

  describe "belongs_to" do
    before do
      fake_model("Client")  { has_attributes :id, :name }
      fake_model("Project") { has_attributes :id, :name; belongs_to :client }
      allow(Client).to receive(:find).with(nil).and_return(nil)
      allow(Client).to receive(:find).with(client.id).and_return(client)
    end

    let(:client)  { Client.new("object" => "client", "id" => "c1", "name" => "client1") }
    let(:project) { Project.new("object" => "project", "id" => "p1", "name" => "project1", "client" => {"id" => client.id}) }

    it "provides a getter to the linked item" do
      expect(project.client).to eq client
    end

    it "memoizes the getter result to minimize network requests" do
      2.times { project.client }
      expect(Client).to have_received(:find).with(client.id).once
    end

    context "when it belongs_to something that is not initialized" do
      let(:project) { Project.new("object" => "project", "id" => "p1", "name" => "project1") }

      it "returns nil" do
        expect(project.client).to be nil
      end
    end

    context "when it belongs_to something which does not exist" do
      let(:project) { Project.new("object" => "project", "id" => "p1", "name" => "project1", "client" => {"id" => "not_existing"}) }

      before { allow(Client).to receive(:find).with("not_existing").and_raise(TimestampAPI::ResourceNotFound.new(Project, "not_existing")) }

      it "raises a ResourceNotFound error" do
        expect{ project.client }.to raise_error TimestampAPI::ResourceNotFound
      end
    end

    context "when it belongs_to a not registered model" do
      before { fake_model("Project") { has_attributes :id, :name; belongs_to :not_a_model } }

      it "raises a UnknownAssociation error" do
        expect{ project.not_a_model }.to raise_error TimestampAPI::UnknownAssociation
      end
    end
  end
end
