class CityAnalystWorker
  include Sidekiq::Worker

  def perform(keywords, location)
    @neighborhoods = CityAnalyst.new(keywords, location).analyze_city
    @neighborhoods.each do |nbhd|
      HeatmapCalculator.new(keywords, location, nbhd[:name]).run
    end
  end
end
