class Api::V1::Analyst::HeatmapController < Api::ApiController
  respond_to :json

  def show
    respond_with CityAnalyst.new(params[:keywords], params[:city])
                            .heatmap_of(params[:neighborhood])
  end
end
