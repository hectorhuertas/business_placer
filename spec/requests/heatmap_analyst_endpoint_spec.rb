require 'rails_helper'

RSpec.describe "Heatmap analyst endpoint" do
  context "When the heatmap is cached" do
    it "returns the cached heatmap" do
      load_user
      Rails.cache.write("heatmap_for_mexican_at_Denver_Speer", "Cached heatmap")

      get '/api/v1/analyst/heatmap?city=Denver&neighborhood=Speer&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached heatmap")
    end
  end

  context "When the heatmap is not cached" do
    it "calculates the heatmap" do
      load_user
      allow_any_instance_of(HeatmapCalculator)
        .to receive(:calculate_heatmap)
        .and_return({message: "calculated_heatmap"}.to_json)

      get '/api/v1/analyst/heatmap?city=Denver&neighborhood=Speer&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(json['message']).to eq("calculated_heatmap")
    end




    it "calculates the heatmap" do
      VCR.use_cassette('bob') do
      load_user
      # allow_any_instance_of(HeatmapCalculator)
      #   .to receive(:calculate_heatmap)
      #   .and_return({message: "calculated_heatmap"}.to_json
 #      {:sw_latitude=>39.6963231,
 # :sw_longitude=>-105.053635,
 # :ne_latitude=>39.711795,
 # :ne_longitude=>-105.0244381}

 # {:sw_latitude=>39.71167412578126,
 # :sw_longitude=>-105.02466620078124,
 # :ne_latitude=>39.711795,
 # :ne_longitude=>-105.0244381}

      get '/api/v1/analyst/heatmap?city=Denver&neighborhood=Westwood&keywords=water'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(json['message']).to eq("calculated_heatmap")
    end
    end
  end
end
