class CityAnalyst
  attr_reader :keywords, :location, :finder

  def initialize(keywords, location)
    @keywords = keywords
    @location = location
    @finder   = FinderService.new
  end

  def run
    load_cache || queue_analysis
  end

  def analyze_city
    Rails.cache.fetch(cache_key, expires_in: 7.days) do
      best_neighborhoods
    end
    # @nbhds = best_neighborhoods
    # Rails.cache.write(cache_key, @nbhds, expires_in: 7.days) && @nbhds
  end

  def check_analysis
    load_cache || { message: "not ready"}
  end

  def best_neighborhoods
    best_of(analyze_neighborhoods)
  end

  private
    def load_cache
      Rails.cache.read(cache_key)
    end

    def cache_key
      "analysis_for_#{keywords.split.join('_')}_at_#{location}"
    end

    def queue_analysis
      CityAnalystWorker.perform_async(keywords, location)
      { message: "analyzing" }
    end

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
end
