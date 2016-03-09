require 'rails_helper'

RSpec.describe ZoneScanner do
    it "finds all locations at the viewport" do
      VCR.use_cassette 'all_mexican_speer' do
        Rails.cache.clear
        speer = {"northeast"=>{"lat"=>39.7272871, "lng"=>-104.9718263},
                 "southwest"=>{"lat"=>39.7110871, "lng"=>-104.9877371}}

        all = ZoneScanner.new(speer).find_all('mexican')

        expect(all.size).to eq(26)
        expect(all.first).to eq({:lat=>39.725409, :lng=>-104.978013})
      end
    end
end
