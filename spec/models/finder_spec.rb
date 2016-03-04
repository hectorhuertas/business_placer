require 'rails_helper'

RSpec.describe "finder service" do
  it "a search returns proper data" do
    search = FinderService.new.search("karaoke", "alicante")
    keys = search.keys

    expect(search[:total]).to be_a Fixnum
    expect(search[:count]).to be_a Fixnum
    expect(search[:count]).to be <= search[:total]
    expect(search[:locations]).to be_a Array

    coordinates = search[:locations].first
    expect(coordinates[:lat]).to be_a Float
    expect(coordinates[:lng]).to be_a Float
  end
end
