class Api::V1::Analyst::CityController < Api::ApiController
  respond_to :json

  def index
    respond_with CityAnalyst.new(params[:keywords], params[:location]).run
  end
end
