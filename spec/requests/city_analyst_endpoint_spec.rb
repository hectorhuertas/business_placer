require 'rails_helper'

RSpec.describe "City analyst endpoint" do
  context "When the heatmap is cached" do
    it "returns the cached heatmap" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)
      allow_any_instance_of(CityAnalyst)
        .to receive(:queue_analysis)
        .and_return({message: "analyzing"}.to_json)

      Rails.cache.write("results_for_mexican_at_Denver", "Cached heatmap")
      get '/api/v1/analyst/city?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached heatmap")
    end
  end

  context "When the heatmap is not cached" do
    it "runs the heatmap analyst" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
      .to receive(:current_user)
      .and_return(user)

      allow_any_instance_of(CityAnalyst)
      .to receive(:queue_analysis)
      .and_return({message: "analyzing"}.to_json)

      get '/api/v1/analyst/city?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json['message']).to eq("analyzing")
    end
  end
end
