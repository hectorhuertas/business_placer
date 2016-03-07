class Api::V1::Neighborhoods::HeatmapController < Api::ApiController
  respond_to :json
  def show
    @heatmapData =  ZoneScanner.new(params[:location])
                               .find_all(params[:keywords])
    respond_with @heatmapData
  end
end
