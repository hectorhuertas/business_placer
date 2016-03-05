class Api::V1::Neighborhoods::ResultsPerCapitaController < Api::ApiController
  respond_to :json
  def index
    # binding.pry
    finder = FinderService.new
    @neighborhoods = Neighborhood.all.map do |n|
      location = "#{params[:location]} #{n.name}"
      results = finder.search(params[:keywords], location)

      {
        name: n.name,
        location: location,
        results_density: results[:total] / n.density
      }
    end.sort_by {|neighborhood| neighborhood[:results_density]}.take(20)
    # b = {
    #   city: params[:location],
    #   location: "denver_coordinates",
    #   neighborhoods: @results_per_capita
    # }
    # {
    #   city: 'denver',
    #   location: denver_coordinates,
    #   neighborhoods: [
    #     {
    #       name: 'baker',
    #       location: baker_coordinates,
    #       results_per_capita: 3.21
    #     },
    #     {
    #       name: 'speer',
    #       location: speer_coordinates,
    #       results_per_capita: 3.16
    #     }
    #   ]
    # }
    respond_with @neighborhoods
  end
end

=begin
neighborhoods.map  {name:population}
yelp.search city neighborhood_name keywords

{
neighborhood: baker
location: coordinates
results_per_capita: total/population
}
=end
