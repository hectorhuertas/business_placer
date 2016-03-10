class Api::V1::CheckerController < Api::ApiController
  respond_to :json

  def show
    respond_with CityAnalyst.new(params[:keywords],
                                 params[:location]).check_analysis
  end
end
