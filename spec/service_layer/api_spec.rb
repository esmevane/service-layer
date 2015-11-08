require 'spec_helper'

describe ServiceLayer::Api, type: :api do
  let(:app) { described_class }
  let(:body) { JSON.parse(last_response.body, symbolize_names: true) }

  describe "GET '/'" do
    it "responds with '200' OK" do
      get "/"
      expect(last_response.status).to eq 200
    end
  end

  describe "GET '/:id'" do
    it "responds with '200' OK" do
      get "/123"
      expect(last_response.status).to eq 200
    end
  end

  describe "POST '/'" do
    it "responds with '200' OK" do
      post "/", { params: "stuff here" }
      expect(last_response.status).to eq 201
    end
  end

  describe "PATCH '/:id'" do
    it "responds with '200' OK" do
      patch "/123", { params: "stuff here" }
      expect(last_response.status).to eq 200
    end
  end

  describe "DELETE '/:id'" do
    it "responds with '200' OK" do
      delete "/123"
      expect(last_response.status).to eq 200
    end
  end
end
