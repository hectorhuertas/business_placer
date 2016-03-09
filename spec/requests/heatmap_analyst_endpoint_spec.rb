require 'rails_helper'

RSpec.describe "Heatmap analyst endpoint" do
  # describe "Get a neighborhood's heatmap" do
  #   it "runs the city analyst" do
  #     user = User.create(name: "Peter")
  #     allow_any_instance_of(Api::ApiController)
  #     .to receive(:current_user)
  #     .and_return(user)
  #
  #     allow_any_instance_of(CityAnalyst)
  #     .to receive(:run)
  #     .and_return("City Analyst Running!")
  #
  #     get '/api/v1/analyst/city?location=Denver&keywords=mexican'
  #     expect(response).to be_success
  #     expect(response).to have_http_status(200)
  #     expect(response.body).to eq("City Analyst Running!")
  #   end
  # end

  context "When the heatmap is cached" do
    it "returns the cached heatmap" do
      load_user
      Rails.cache.write("heatmap_for_mexican_at_Denver_Speer", "Cached heatmap")

      get '/api/v1/analyst/heatmap?location=Denver&neighborhood=Speer&keywords=mexican'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.body).to eq("Cached heatmap")

    end
  end

  context "When the heatmap is not cached" do
    it "runs the heatmap analyst" do

    end
  end
end
