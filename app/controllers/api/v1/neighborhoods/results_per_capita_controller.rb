class Api::V1::Neighborhoods::ResultsPerCapitaController < Api::ApiController
  respond_to :json
  def index
    if Rails.cache.exist?(cache_key)
      respond_with Rails.cache.read(cache_key)
    else
      CityAnalyst.perform_async(cache_key, params[:keywords], params[:location])
      respond_with "analysis_started"
    end
  end

  private

  def cache_key
    "results_for_#{params[:keywords].split.join('_')}_at_#{params[:location]}"
  end
end
