class Api::V1::Analyst::HeatmapController < Api::ApiController
  respond_to :json

  def show
    respond_with CityAnalyst.new(params[:keywords], params[:location])
                            .heatmap_of(params[:neighborhood])
  end
end
