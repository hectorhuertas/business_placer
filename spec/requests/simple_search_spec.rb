require 'rails_helper'

RSpec.describe "Simple search" do
  describe "search by keywords and location" do
    it "returns the simple search data" do
      pending
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)

      get '/api/v1/search/simple?location=Denver baker&keywords=karaoke'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
    end
  end
end
