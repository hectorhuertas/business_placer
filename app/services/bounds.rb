class Bounds
  attr_reader :sw_lat, :sw_lng, :ne_lat, :ne_lng

  def initialize(location)
    @sw_lat = location[:sw_latitude]
    @sw_lng = location[:sw_longitude]
    @ne_lat = location[:ne_latitude]
    @ne_lng = location[:ne_longitude]
  end

  def quadrants
    q1 = new_box(mid_lat, mid_lng,  ne_lat,  ne_lng)
    q2 = new_box(mid_lat,  sw_lng,  ne_lat, mid_lng)
    q3 = new_box( sw_lat,  sw_lng, mid_lat, mid_lng)
    q4 = new_box( sw_lat, mid_lng, mid_lat,  ne_lng)
    [ q1, q2, q3, q4 ]
  end

  def mid_lat
    (ne_lat + sw_lat) / 2
  end

  def mid_lng
    (ne_lng + sw_lng) / 2
  end

  def new_box(sw_latitude, sw_longitude, ne_latitude, ne_longitude)
    {
      sw_latitude:   sw_latitude,
      sw_longitude: sw_longitude,
      ne_latitude:   ne_latitude,
      ne_longitude: ne_longitude
    }
  end
end
