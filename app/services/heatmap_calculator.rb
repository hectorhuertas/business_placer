class HeatmapCalculator
  attr_reader :keywords, :location, :finder, :neighborhood

  def initialize(keywords, location, neighborhood)
    @keywords     = keywords
    @location     = location
    @neighborhood = neighborhood
    @finder       = FinderService.new
  end

  def run
    Rails.cache.fetch(cache_key){ calculate_heatmap }
  end

  def viewport
    google  = "https://maps.googleapis.com/maps/api/geocode/json?"
    address = "address=#{location}+#{parametrize(neighborhood)}"
    key     = "&key=#{ENV['MAPS_API_KEY']}"
    url     = google+address+key

    result = JSON.parse(Faraday.get(url).body)["results"][0]
    result['geometry']['viewport']
  end

  private
    def cache_key
      "heatmap_for_#{keywords.split.join('_')}_at_#{location}_#{neighborhood}"
    end

    def calculate_heatmap
      ZoneScanner.new(viewport).find_all(keywords)
    end

    def parametrize(neighborhood_name)
      neighborhood_name.gsub("/", " ").split.join('+')
    end
end
