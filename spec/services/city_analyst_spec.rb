require 'rails_helper'

RSpec.describe CityAnalyst do
  it "return the 10 most suitable neighborhoods" do
    VCR.use_cassette 'best_neighborhoods_mexican_denver' do
      nbhds = CityAnalyst.new('mexican', 'Denver').best_neighborhoods

      expect(nbhds.size).to eq(10)
      expect(nbhds.first[:name]).to eq('University Park')
      expect(nbhds.first[:results_density]).to eq(1.097104454001869e-06)
      expect(nbhds.last[:name]).to eq('Jefferson Park')
      expect(nbhds.last[:results_density]).to eq(8.55278875811443e-06)
    end
  end
end
