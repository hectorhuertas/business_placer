require 'rails_helper'

RSpec.describe CityAnalystWorker do
  it "caches everything for a city analysis" do
    VCR.use_cassette('worker_mexican_denver') do
      CityAnalystWorker.new.perform('mexican', 'Denver')

      cache = Rails.cache.read("analysis_for_mexican_at_Denver")

      first_nbhd = {:name=>"University",
                    :location=>"Denver University",
                    :results_density=>1.011976053479252e-06}
      last_nbhd  = {:name=>"Country Club",
                    :location=>"Denver Country Club",
                    :results_density=>6.417334100919025e-06}
      expect(cache.first).to eq(first_nbhd)
      expect(cache.last).to eq(last_nbhd)

      university = Rails.cache.read("??????")
      #assert cache exists for city and heatmap
    end
  end
end
