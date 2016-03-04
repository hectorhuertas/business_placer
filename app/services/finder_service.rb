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
    search = client.search(location, { term: keywords })
    locations = locations_from(search)

    {
      total: search.total,
      count: locations.count,
      locations: locations
    }
  end

  private
    def locations_from(search)
      search.businesses.map do |business|
       {
         lat: business.location.coordinate.latitude,
         lng: business.location.coordinate.longitude
       }
      end
    end
end
