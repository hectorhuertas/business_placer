class Api::V1::Analyst::HeatmapController < Api::ApiController
  respond_to :json

  def show
    respond_with HeatmapCalculator.new(params[:keywords],
                                       params[:city],
                                       params[:neighborhood]).run
  end
end
