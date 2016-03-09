require 'rails_helper'

RSpec.describe "Heatmap analyst endpoint" do
  context "When the heatmap is cached" do
    it "returns the cached heatmap" do
      load_user
      Rails.cache.write("heatmap_for_mexican_at__Speer", "Cached heatmap")

      get '/api/v1/analyst/heatmap?location=Denver&neighborhood=Speer&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached heatmap")
    end
  end

  context "When the heatmap is not cached" do
    it "calculates the heatmap" do
      load_user
      allow_any_instance_of(CityAnalyst)
        .to receive(:calculate_heatmap)
        .and_return({message: "calculated_heatmap"}.to_json)

      get '/api/v1/analyst/heatmap?location=Denver&neighborhood=Speer&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(json['message']).to eq("calculated_heatmap")

    end
  end
end
