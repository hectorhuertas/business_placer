class Api::V1::Search::SimpleController < Api::ApiController
  respond_to :json

  def index
    finder = FinderService.new
    b = finder.search("karaoke", "alicante")
    respond_with b
    # respond_with({bob: 'dope'})
  end
end
