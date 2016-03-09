class CityAnalyst
attr_reader :keywords, :location, :finder

  def initialize(keywords, location)
    @keywords = keywords
    @location = location
    @finder = FinderService.new
  end

  def run
    load_cache || start_analysis
  end

  def bob

  end

  def analyze
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

  private
    def cache_key
      "results_for_#{keywords.split.join('_')}_at_#{location}"
    end

    def load_cache
      Rails.cache.read(cache_key)
    end

    def start_analysis
      CityAnalystWorker.perform_async(keywords, location)
      {message: "analyzing"}
    end
    #
    # def start_analysis
    #   CityAnalystWorker.perform_async(cache_key, keywords, location)
    #   {message: "analyzing"}
    # end
end
