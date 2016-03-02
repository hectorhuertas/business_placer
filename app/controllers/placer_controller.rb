require 'yelp'
class PlacerController < ApplicationController
  respond_to :json, :html
  def show
    respond_to do |format|
      format.html {  }
      format.json { {data: "bob"}.to_json }
    end
  end

  def jsoner3
    binding.pry
    respond_with({data: "bob"}.to_json)
    # respond_to do |format|
    #   # format.json { {data: "bob"}.to_json }
    #   format .json { render :json => {data: "bob"} }
    # end
  end

  def jsoner
    # binding.pry
    client = Yelp::Client.new({ consumer_key: ENV['YELP_CONSUMER_KEY'],
                                consumer_secret: ENV['YELP_CONSUMER_SECRET'],
                                token: ENV['YELP_TOKEN'],
                                token_secret: ENV['YELP_TOKEN_SECRET']
                              })
    # params = { term: '',
    #        category_filter: ''
    #      }
    # bounding_box = { sw_latitude: 39.728451, sw_longitude: -105.007081, ne_latitude: 39.740002, ne_longitude: -104.986138}
    # b = client.search_by_bounding_box(bounding_box,params)
    b = client.search(params["location"], { term: params["business"] })
    @locations = b.businesses.map do |business|
      {
        lat: business.location.coordinate.latitude,
        lng: business.location.coordinate.longitude
      }
      # [
      #   business.location.coordinate.latitude,
      #   business.location.coordinate.longitude
      # ]
    end
    @locationsXXXXX = [ {:lat=>38.3443833, :lng=>-0.4815988},
                   {:lat=>38.345089, :lng=>-0.48713},
                   {:lat=>38.3465004, :lng=>-0.48339},
                  #  {:lat=>38.3449104205364, :lng=>-0.485122404552634},
                  #  {:lat=>38.3449060820208, :lng=>-0.483902874091218},
                  #  {:lat=>38.3455186507622, :lng=>-0.481429068881178},
                  #  {:lat=>38.34664375, :lng=>-0.48363984},
                  #  {:lat=>38.34851392, :lng=>-0.48697986},
                  #  {:lat=>38.345121208108, :lng=>-0.492963865399361},
                  #  {:lat=>38.3463707, :lng=>-0.4833},
                  #  {:lat=>38.3411712646484, :lng=>-0.500497996807098},
                  #  {:lat=>38.3430405, :lng=>-0.48502},
                  #  {:lat=>38.3420843, :lng=>-0.4891049},
                  #  {:lat=>38.3439217, :lng=>-0.48361},
                  #  {:lat=>38.3484192, :lng=>-0.48738},
                  #  {:lat=>38.3480841084608, :lng=>-0.490768596966524},
                  #  {:lat=>38.3465118, :lng=>-0.48461},
                  #  {:lat=>38.34542728482, :lng=>-0.485495924949646},
                  #  {:lat=>38.3423691, :lng=>-0.49409},
                   {:lat=>38.3467133652581, :lng=>-0.483829538940406}]
    # binding.pry
    # respond_to do |format|
    #   # format .json { render :json => {data: "bob"} }
    #   format .json { render :json => @locations }
    # end
    respond_with @locations
  end
end
