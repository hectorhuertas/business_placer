require 'rails_helper'

RSpec.describe HeatmapCalculator do
  context "Created from bg worker" do
    it "returns the heatmapData of the neighborhood" do
      VCR.use_cassette 'heatmap_mexican_denver_speer' do
        speer = HeatmapCalculator.new('mexican', 'Denver', 'Speer').run

        expect(speer.size).to eq(26)
        expect(speer.first).to eq({:lat=>39.725409, :lng=>-104.978013})
      end
    end

    it "returns the viewport of the neighborhood" do
      VCR.use_cassette 'speer_viewport' do
        viewport = HeatmapCalculator.new('mexican', 'Denver', 'Speer').viewport
        expected = {"northeast"=>{"lat"=>39.7272871, "lng"=>-104.9718263},
                    "southwest"=>{"lat"=>39.7110871, "lng"=>-104.9877371}}
        expect(viewport).to eq(expected)
      end
    end
  end
end
