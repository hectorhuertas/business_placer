require 'rails_helper'

RSpec.describe CityAnalystWorker do
  it "caches everything for a city analysis" do
    VCR.use_cassette('worker_mexican_denver') do
      CityAnalystWorker.new.perform('mexican', 'Denver')

      cache = Rails.cache.read("analysis_for_mexican_at_Denver")

      first_nbhd = {:name=>"University Park",
                    :location=>"Denver University Park",
                    :results_density=>1.097104454001869e-06}
      last_nbhd  = {:name=>"Jefferson Park",
                    :location=>"Denver Jefferson Park",
                    :results_density=>8.55278875811443e-06}
      expect(cache.first).to eq(first_nbhd)
      expect(cache.last).to eq(last_nbhd)

      country_club = Rails.cache.read("heatmap_for_mexican_at_Denver_Country Club")

      cc_heatmap = [ {:lat=>39.7178830006016, :lng=>-104.958904380676},
                     {:lat=>39.7116212546825, :lng=>-104.973333254457},
                     {:lat=>39.721241,        :lng=>-104.95858} ]
      expect(country_club).to eq(cc_heatmap)
    end
  end
end
