require 'rails_helper'

RSpec.describe City, type: :model do
  it  "has many neighborhoods" do
    neighborhood_1 = Neighborhood.create()
    neighborhood_2 = Neighborhood.create()
    city = City.create(neighborhoods: [neighborhood_1, neighborhood_2])

    expect(city.neighborhoods.size).to eq(2)
  end
end
