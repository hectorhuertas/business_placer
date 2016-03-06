require 'csv'

desc "Import csv files"

task import: [:environment] do
  denver_id = City.find_by(name: 'Denver').id
  file = "vendor/assets/csv/denver_population.csv"
  CSV.foreach(file, headers: true) do |row|
    data = {
      name: row['NBRHD_NAME'],
      area: row['SHAPE_Area'],
      population: row['POPULATION_2010'],
      city_id: denver_id
    }
    Neighborhood.create(data)
  end

  # file = "vendor/assets/csv/transactions.csv"
  # CSV.foreach(file, headers: true) do |row|
  #   row.delete("credit_card_expiration_date")
  #   Transaction.create row.to_h
  # end
end
