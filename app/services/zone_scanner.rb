class ZoneScanner
  attr_reader :finder

  def initialize(location)
    @finder = FinderService.new

    @zone   = {
      sw_latitude:  location['southwest']['lat'] -0.0005,
      sw_longitude: location['southwest']['lng'] -0.0005,
      ne_latitude:  location['northeast']['lat'] +0.0005,
      ne_longitude: location['northeast']['lng'] +0.0005
    }
  end

  def find_all(keywords)
    find_all_at(keywords: keywords, bounding_box: @zone).compact
  end

  def find_all_at(keywords:, bounding_box:)
    search = finder.geo_search(keywords, bounding_box)
    # binding.pry
    if search[:total] >= 20
      locations = Bounds.new(bounding_box).quadrants.reduce([]) do |result, quadrant|
        result << find_all_at( keywords: keywords, bounding_box: quadrant )
      end
      locations = locations.flatten.uniq
    else
      search[:locations]
    end
  end
end
