require 'rails_helper'

RSpec.describe Neighborhood, type: :model do
  it "gets its own density" do
    neighborhood = Neighborhood.create(area: '10.0', population: '20.0')
    expect(neighborhood.density).to eq(2.0)
  end

  it "belongs to city" do
    city = City.create(name: 'Calais')
    neighborhood = Neighborhood.create(city: city)

    expect(neighborhood.city).to eq(city)
  end
end
