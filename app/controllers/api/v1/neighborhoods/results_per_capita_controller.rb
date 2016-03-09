class Api::V1::Neighborhoods::ResultsPerCapitaController < Api::ApiController
  respond_to :json

  def index
    respond_with CityAnalyst.new(params[:keywords], params[:location]).run
  end
end
