class CityAnalyst
attr_reader :keywords, :location, :finder, :neighborhood

  def initialize(keywords, location, neighborhood = nil)
    @keywords = keywords
    @location = location
    @finder = FinderService.new
  end

  def run
    load_cache || queue_analysis
  end

  def analyze_city
    @neighborhoods = best_neighborhoods
    Rails.cache.write(cache_key, @neighborhoods, expires_in: 7.days)
    # @neighborhoods
  end
  # def analyze_city
  #   binding.pry
  #   @neighborhoods = Neighborhood.all.map do |n|
  #     current_location = "#{location} #{n.name}"
  #     puts "Analyzing #{keywords} at #{current_location}"
  #     results = finder.search(keywords, current_location)
  #
  #     {
  #       name: n.name,
  #       location: current_location,
  #       results_density: results[:total] / n.density
  #     }
  #   end.sort_by {|neighborhood| neighborhood[:results_density]}.take(10)
  #   Rails.cache.write(cache_key, @neighborhoods, expires_in: 7.days)
  #   # @neighborhoods
  # end

  def heatmap_of(neighborhood)
    @neighborhood = neighborhood
    load_heatmap || calculate_heatmap
  end

  def calculate_heatmap
    heatmap_from(neighborhood)
  end

  def heatmap_from(neighborhood)
    viewport = viewport_of(neighborhood)
    ZoneScanner.new(viewport).find_all(keywords)
  end

  def viewport_of(neighborhood)
    google = "https://maps.googleapis.com/maps/api/geocode/json?"
    address = "address=#{location}+#{parametrize(neighborhood)}"
    key = "&key=#{ENV['MAPS_API_KEY']}"
    url = google+address+key

    result = JSON.parse(Faraday.get(url).body)["results"][0]
    result['geometry']['viewport']
  end

  def parametrize(neighborhood_name)
    neighborhood_name.gsub("/", " ").split.join('+')
  end

  def best_neighborhoods
    best_of(analyze_neighborhoods)
  end

  private
    def analyze_neighborhoods
      Neighborhood.all.map do |n|
        current_location = "#{location} #{n.name}"
        results = finder.search(keywords, current_location)
        { name: n.name,
          location: current_location,
          results_density: results[:total] / n.density }
      end
    end

    def best_of(neighborhoods)
      neighborhoods.sort_by {|ngbh| ngbh[:results_density]}.take(10)
    end

    def cache_key
      "analysis_for_#{keywords.split.join('_')}_at_#{location}"
    end

    def load_cache
      Rails.cache.read(cache_key)
    end

    def load_heatmap
      Rails.cache.read(heatmap_cache_key)
    end

    def heatmap_cache_key
      "heatmap_for_#{keywords.split.join('_')}_at_#{location}_#{neighborhood}"
    end

    def queue_heatmap
      # HeatmapWorker.perform_async(keywords, location)
      {message: "calculating_heatmap"}
    end

    def queue_analysis
      CityAnalystWorker.perform_async(keywords, location)
      {message: "analyzing"}
    end
end
