class Api::V1::Neighborhoods::HeatmapController < Api::ApiController
  respond_to :json
  def show
    # location: ((39.6671106, -104.9592591), (39.6844682, -104.94086979999997))

    # comprobar los resultados de los cuadrantes

    @heatmapData =  ZoneScanner.new(params[:location]).find_all(params[:keywords])
# binding.pry
    # finder = FinderService.new
    # @neighborhoods = Neighborhood.all.map do |n|
    #   location = "#{params[:location]} #{n.name}"
    #   # results = finder.search(params[:keywords], location)
    #
    #   {
    #     name: n.name,
    #     location: location,
    #     results_density: results[:total] / n.density
    #   }
    # end.sort_by {|neighborhood| neighborhood[:results_density]}.take(10)
    respond_with @heatmapData
  end
end
