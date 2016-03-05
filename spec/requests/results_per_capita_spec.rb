require 'rails_helper'

RSpec.describe "Results per capita" do
  describe "Make a search" do
    it "returns the 20 neighborhoods with lower density of business" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)

      get '/api/v1/neighborhoods/results_per_capita?location=Denver&keywords=karaoke'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json.length).to eq(20)
      expect(json.first["name"]).to eq('Speer')
      expect(json.last["name"]).to eq('Baker')
    end
  end
end
