class PagesController < ApplicationController
  def home
    client = Yelp::Client.new({ consumer_key: "8GJM-0H6mq7kVlosVSi_mQ",
                                consumer_secret: "7-MdCD1tNorjVvd8QPmWlYOsfCA",
                                token: "MJgO4gOWRhXCJO-sc3VaDhY7-6HZ6-93",
                                token_secret: "-R_u0OXCXJ1podILpIJhHWXT-KQ"
                              })
    params = { term: '',
           category_filter: ''
         }
    # bounding_box = { sw_latitude: 39.728451, -105.007081, sw_longitude: -122.4376, ne_latitude: 39.740002, -104.986138, ne_longitude: -122.391681 }
    bounding_box = { sw_latitude: 39.728451, sw_longitude: -105.007081, ne_latitude: 39.740002, ne_longitude: -104.986138}
    b = client.search_by_bounding_box(bounding_box,params)
    @locations = b.businesses.map do |business|
      # {
      #   lat: business.location.coordinate.latitude,
      #   lng: business.location.coordinate.longitude
      # }
      [
        business.location.coordinate.latitude,
        business.location.coordinate.longitude
      ]
    end
    # binding.pry
  end
end
