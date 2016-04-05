class CityAnalystWorker
  include Sidekiq::Worker

  def perform(keywords, location)
    puts "MIRA AQUI"
    @neighborhoods = CityAnalyst.new(keywords, location).analyze_city
    @neighborhoods.each do |nbhd|
      HeatmapCalculator.new(keywords, location, nbhd[:name]).run
    end
  end
end
