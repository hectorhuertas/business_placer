require 'rails_helper'

RSpec.describe "City analyst endpoint" do
  context "When the analysis is cached" do
    it "returns the cached analysis" do
      load_user
      Rails.cache.write("analysis_for_mexican_at_Denver", "Cached analysis")

      get '/api/v1/analyst/city?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached analysis")
    end
  end

  context "When the analysis is not cached" do
    it "runs the city analyst" do
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
