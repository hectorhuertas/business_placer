require 'rails_helper'

RSpec.describe CityAnalyst do
  context "Created from the controller" do
    it  "loads the cache" do

    end

    it "fires the bg woker" do

    end
  end

  context "Created from bg worker" do
    it "return the 10 most suitable neighborhoods" do
      VCR.use_cassette 'mexican_denver' do
        Rails.cache.clear
        nbhds = CityAnalyst.new('mexican', 'Denver').best_neighborhoods

        expect(nbhds.size).to eq(10)
        expect(nbhds.first[:name]).to eq('University')
        expect(nbhds.first[:results_density]).to eq(1.011976053479252e-06)
        expect(nbhds.last[:name]).to eq('Country Club')
        expect(nbhds.last[:results_density]).to eq(6.417334100919025e-06)
      end
    end

    # it "XXXX returns the heatmapData of the neighborhood" do
    #   VCR.use_cassette 'XXmexican_denver_speer' do
    #     speer_location = "((39.70697284426492, -105.00044543825072), (39.73140014407822, -104.95911796174926))"
    #     speer = CityAnalyst.new('mexican', 'Denver').heatmap_of(speer_location)
    #     sp2 = ZoneScanner.new(speer_location).find_all('mexican')
    #
    #     expect(speer).to eq(sp2)
    #     # binding.pry
    #   end
    # end

    it "returns the heatmapData of the neighborhood" do
      VCR.use_cassette 'heatmap_mexican_denver_speer' do
        speer = CityAnalyst.new('mexican', 'Denver').heatmap_of('Speer')

        expect(speer.size).to eq(26)
        expect(speer.first).to eq({:lat=>39.725409, :lng=>-104.978013})
      end
    end

    it "returns the viewport of the neighborhood" do
      VCR.use_cassette 'speer_viewport' do
        viewport = CityAnalyst.new('mexican', 'Denver').viewport_of('Speer')
        expected = {"northeast"=>{"lat"=>39.7272871, "lng"=>-104.9718263},
                    "southwest"=>{"lat"=>39.7110871, "lng"=>-104.9877371}}
        expect(viewport).to eq(expected)
      end
    end
  end
end
