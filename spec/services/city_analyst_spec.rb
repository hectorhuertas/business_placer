require 'rails_helper'

RSpec.describe CityAnalyst do
  it "return the 10 most suitable neighborhoods" do
    VCR.use_cassette 'mexican_denver' do
      nbhds = CityAnalyst.new('mexican', 'Denver').best_neighborhoods

      expect(nbhds.size).to eq(10)
      expect(nbhds.first[:name]).to eq('University')
      expect(nbhds.first[:results_density]).to eq(1.011976053479252e-06)
      expect(nbhds.last[:name]).to eq('Country Club')
      expect(nbhds.last[:results_density]).to eq(6.417334100919025e-06)
    end
  end
end
