require 'rails_helper'

RSpec.describe "Neighborhood heatmap data" do
  describe "click on a best neighborhoods result" do
    it "displays the heatmap of a neighborhood" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)

      get '/api/v1/neighborhoods/heatmap?location=((39.6671106, -104.9592591), (39.6844682, -104.94086979999997))&keywords=shoes'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json.length).to eq(4)
      expect(json.first).to eq({"lat"=>39.6695512, "lng"=>-104.9409155})
    end

    it "displays the heatmap of a denser neighborhood" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)

      #look for shoes at denver union station
      get '/api/v1/neighborhoods/heatmap?location=((39.745886, -105.00813670000002), (39.7603811, -104.99184049999997))&keywords=shoes'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      # binding.pry
      expect(json.length).to eq(21)
      # expect(json.first).to eq({"lat"=>39.6695512, "lng"=>-104.9409155})
    end
  end
end
