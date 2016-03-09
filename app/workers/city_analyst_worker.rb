class CityAnalystWorker
  include Sidekiq::Worker

  def perform(keywords, location)
    CityAnalyst.new(keywords, location).analyze
  end
end
