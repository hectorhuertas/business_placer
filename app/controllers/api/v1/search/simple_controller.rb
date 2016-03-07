class Api::V1::Search::SimpleController < Api::ApiController
  respond_to :json

  def index
    finder = FinderService.new
    respond_with finder.search(params[:keywords], params[:location])
  end

  def show
    finder = FinderService.new
    respond_with City.first
  end
end
