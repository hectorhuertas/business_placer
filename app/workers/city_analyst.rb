class CityAnalyst
  include Sidekiq::Worker

  def perform(cache_key, keywords, location)
    puts "bob: #{location}"
      @neighborhoods = Neighborhood.all.map do |n|
        finder = FinderService.new
        current_location = "#{location} #{n.name}"
        puts current_location
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
