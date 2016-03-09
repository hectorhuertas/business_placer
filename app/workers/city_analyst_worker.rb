class CityAnalystWorker
  include Sidekiq::Worker

  # def perform(analyst)
  #   analyst.
  #   neighborhoods = analyst.best_neighborhoods
  #   # cache neighborhoods
  #
  #     @neighborhoods = Neighborhood.all.map do |n|
  #       current_location = "#{location} #{n.name}"
  #       puts "Analyzing #{keywords} at #{current_location}"
  #       results = finder.search(keywords, current_location)
  #
  #       {
  #         name: n.name,
  #         location: current_location,
  #         results_density: results[:total] / n.density
  #       }
  #     end.sort_by {|neighborhood| neighborhood[:results_density]}.take(10)
  #     Rails.cache.write(cache_key, @neighborhoods, expires_in: 7.days)
  # end
  def perform(cache_key, keywords, location)
    finder = FinderService.new
      @neighborhoods = Neighborhood.all.map do |n|
        current_location = "#{location} #{n.name}"
        puts "Analyzing #{keywords} at #{current_location}"
        results = finder.search(keywords, current_location)

        {
          name: n.name,
          location: current_location,
          results_density: results[:total] / n.density
        }
      end.sort_by {|neighborhood| neighborhood[:results_density]}.take(10)
      Rails.cache.write(cache_key, @neighborhoods, expires_in: 7.days)
  end
end
