require 'rails_helper'

RSpec.describe "City analyst endpoint" do
  context "When the heatmap is cached" do
    it "returns the cached heatmap" do
      load_user
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
      load_user
      allow_any_instance_of(CityAnalyst)
        .to receive(:queue_analysis)
        .and_return({message: "analyzing"}.to_json)

      get '/api/v1/analyst/city?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(json['message']).to eq("analyzing")
    end
  end
end
