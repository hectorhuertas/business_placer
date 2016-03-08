require 'yelp'

class FinderService
  attr_reader :client

  def initialize
    @client = Yelp::Client.new({ consumer_key: ENV['YELP_CONSUMER_KEY'],
                                 consumer_secret: ENV['YELP_CONSUMER_SECRET'],
                                 token: ENV['YELP_TOKEN'],
                                 token_secret: ENV['YELP_TOKEN_SECRET']
                               })
  end

  def search(keywords, location)
    # binding.pry
    # Rails.cache.fetch("search_#{keywords.split.join('_')}_at_#{location.split.join('_')}", expires_in: 7.days) do
      search = client.search(location, { term: keywords })
      # binding.pry
      puts [keywords, location]
      puts search
      locations = locations_from(search)

      {
        total: search.total,
        count: locations.count,
        locations: locations
      }
    # end
  end

  def geo_search(keywords, bounding_box)
    Rails.cache.fetch("geo_search_#{keywords.split.join('_')}_at_#{bounding_box.to_s}", expires_in: 7.days) do
      search = client.search_by_bounding_box(bounding_box, { term: keywords})
      locations = locations_from(search).compact

      {
        total: search.total,
        count: locations.count,
        locations: locations
      }
    end
  end

  private
    def locations_from(search)
      search.businesses.map do |business|
        if business.location.coordinate != nil
         {
           lat: business.location.coordinate.latitude,
           lng: business.location.coordinate.longitude
         }
       end
      end
    end
end
