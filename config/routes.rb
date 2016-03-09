Rails.application.routes.draw do
  root 'placer#show'

  get '/login',                       to: "sessions#new"
  get '/logout',                      to: "sessions#destroy"
  get '/auth/google_oauth2/callback', to: "sessions#create"

  namespace :api , defaults: {format: :json} do
    namespace :v1 do
      namespace :analyst do
        get "city", to: "city#index"
      end


      namespace :search do
        get '/simple', to: "simple#index"
      end

      resources :neighborhoods, only: [] do
        collection do
          get '/results_per_capita', to: "neighborhoods/results_per_capita#index"
          get '/heatmap', to: "neighborhoods/heatmap#show"
        end
      end

      resources :cities, only: [] do
        "/cities/analyst/"
        "/analyst/heatmap#show"
        "/analyst/city#index (ciudad)"
      end

      #Order of things:
      #from the location, make sure it is Denver or denver
      # if it is anything else, run the basic search
      # if it is denver, make the call to neighborhoods/better?keywords=whatever
    end
  end
end
