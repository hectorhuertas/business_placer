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

  def best_neighborhoods

  end

  private
    def cache_key
      "results_for_#{keywords.split.join('_')}_at_#{location}"
    end

    def load_cache
      Rails.cache.read(cache_key)
    end

    # def start_analysis
    #   CityAnalystWorker.perform_async(self)
    #   {message: "analyzing"}
    # end

    def start_analysis
      CityAnalystWorker.perform_async(cache_key, keywords, location)
      {message: "analyzing"}
    end
end
