require 'rails_helper'

RSpec.describe "Checker endpoint" do
  context "When the analysis is cached" do
    it "returns the cached analysis" do
      load_user
      Rails.cache.write("analysis_for_mexican_at_Denver", "Cached analysis")

      get '/api/v1/checker?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached analysis")
    end
  end

  context "When the analysis is not cached" do
    it "runs the city analyst" do
      load_user

      get '/api/v1/checker?location=Denver&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(json['message']).to eq("not ready")
    end
  end
end
