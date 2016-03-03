require 'rails_helper'

RSpec.describe "Simple search" do
  describe "search by keywords and location" do
    it "returns the simple search data" do
      user = User.create(name: "Peter")
      allow_any_instance_of(Api::ApiController)
        .to receive(:current_user)
        .and_return(user)

      get '/api/v1/search/simple?location=Denver baker&keywords=karaoke'
      expect(response).to be_success
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      binding.pry
      expect(json.length).to eq(2)
    end
    # it "returns the sisasafdasgmple search data" do
    #   get single_searches_path
    #   expect(response).to have_http_status(200)
    # end

    # it "returns all invoices" do
    #   invoices = create_list(:invoice, 2)
    #
    #   get '/api/v1/invoices'
    #   expect(response).to be_success
    #   expect(response).to have_http_status(200)
    #
    #   json = JSON.parse(response.body)
    #   expect(json.length).to eq(2)
    # end
  end
end
