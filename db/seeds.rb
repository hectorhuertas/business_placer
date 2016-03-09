require 'csv'

class Seed
  def self.run
    Seed.load_neighborhoods_data
  end

  def self.load_neighborhoods_data
    denver_id = City.find_or_create_by(name: 'Denver').id
    file = "vendor/assets/csv/denver_population.csv"
    CSV.foreach(file, headers: true) do |row|
      data = {
        name: row['NBRHD_NAME'],
        area: row['SHAPE_Area'],
        population: row['POPULATION_2010'],
        city_id: denver_id
      }
      n = Neighborhood.create(data)
      puts "Created #{n.name}"
    end
  end
end

Seed.run
