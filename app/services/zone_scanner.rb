class ZoneScanner
  attr_reader :finder, :zone

  def initialize(location)
    @finder = FinderService.new

    location = location.gsub(/[(),]/,' ').split.map(&:to_f)
    @zone   = {
      sw_latitude: location[0] -0.0005,
      sw_longitude: location[1] -0.0005,
      ne_latitude: location[2] +0.0005,
      ne_longitude: location[3] +0.0005
    }
  end

  def find_all(keywords)
    search = finder.geo_search(keywords, zone)
    if search[:total] >= 20
      locations = Bounds.new(zone).quadrants.reduce([]) do |result, quadrant|
        result << find_all_at( keywords: keywords, bounding_box: quadrant )
        result
      end
      locations = locations.flatten.uniq
    else
      search[:locations]
    end
  end

  def find_all_at(keywords:, bounding_box:)
    search = finder.geo_search(keywords, bounding_box)
    if search[:total] >= 20
      locations = Bounds.new(zone).quadrants.reduce([]) do |result, quadrant|
        result << find_all_at( keywords: keywords, bounding_box: quadrant )
        result
      end
      locations = locations.flatten.uniq
      megabob
    else
      search[:locations]
    end
  end
end
